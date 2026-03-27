// ═══════════════════════════════════════════════════════════════
// IPL Auction 2026 — End-to-End Scoring Simulation (API Version)
// ═══════════════════════════════════════════════════════════════

import prisma from '../src/config/db.js';

const API_URL = 'http://localhost:5000/api';

async function lockLineupViaApi(teamId, playerIds, captainId, viceCaptainId) {
    const res = await fetch(`${API_URL}/scoring/lock-lineup`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ teamId, playerIds, captainId, viceCaptainId })
    });
    if (!res.ok) {
        const data = await res.json();
        throw new Error(data.error || 'API Error');
    }
    return res.json();
}

async function getLeaderboardViaApi() {
    const res = await fetch(`${API_URL}/scoring/leaderboard`);
    if (!res.ok) throw new Error('Failed to fetch leaderboard');
    return res.json();
}

function countCategories(playerArr) {
    const c = { BAT: 0, BOWL: 0, AR: 0, WK: 0, OVERSEAS: 0, INDIAN: 0 };
    playerArr.forEach(p => {
        c[p.category] = (c[p.category] || 0) + 1;
        c[p.nationality] = (c[p.nationality] || 0) + 1;
    });
    return c;
}

function fmtCounts(c) {
    return `BAT:${c.BAT} BOWL:${c.BOWL} AR:${c.AR} WK:${c.WK} | OS:${c.OVERSEAS} IND:${c.INDIAN}`;
}

async function runSimulation() {
    console.log('🚀 Starting Final Standings Simulation...\n');

    try {
        // Robust update for phase
        await prisma.auctionState.updateMany({ data: { phase: 'POST_AUCTION' } });
        
        const teams = await prisma.team.findMany();
        const players = await prisma.player.findMany();

        const shuffle = (arr) => [...arr].sort(() => Math.random() - 0.5);

        // Print available pool
        const poolCounts = countCategories(players);
        console.log(`📊 Player Pool: ${players.length} total — ${fmtCounts(poolCounts)}`);
        console.log('');

        // Track which players have been assigned globally
        const assignedIds = new Set();
        const isAvailable = (p) => p && !assignedIds.has(p.id);
        const markAssigned = (p) => assignedIds.add(p.id);

        // Distribute mathematically guaranteed minimums round-robin
        const allWks = shuffle(players.filter(p => p.category === 'WK'));
        const allBats = shuffle(players.filter(p => p.category === 'BAT'));
        const allBowls = shuffle(players.filter(p => p.category === 'BOWL'));
        const allArs = shuffle(players.filter(p => p.category === 'AR'));

        // We prepare buckets for each team (10 teams)
        const teamBuckets = teams.map(t => ({ team: t, squad: new Set() }));

        // Helper to deal N players of a specific list to each team while respecting max 5 overseas
        const dealToTeams = (playerList, nPerTeam) => {
            for (let round = 0; round < nPerTeam; round++) {
                for (const tb of teamBuckets) {
                    const getOsCount = () => Array.from(tb.squad).filter(x => x.nationality === 'OVERSEAS').length;
                    
                    let foundIdx = playerList.findIndex(p => 
                        !assignedIds.has(p.id) && 
                        !(p.nationality === 'OVERSEAS' && getOsCount() >= 5)
                    );
                    
                    if (foundIdx !== -1) {
                        const p = playerList[foundIdx];
                        tb.squad.add(p);
                        markAssigned(p);
                    }
                }
            }
        };

        // Deal required minimums
        // WK: want ~2 per team (deals 2)
        dealToTeams(allWks, 2);
        // BAT: min 3 per team
        dealToTeams(allBats, 3);
        // AR: min 3 per team
        dealToTeams(allArs, 3);
        // BOWL: min 5 per team
        dealToTeams(allBowls, 5);

        // At this point, squads have ~13 players.
        // We have ~2 spots left per team.
        // Let's fill the rest up to 15, respecting Overseas cap <= 5.
        // And ensuring Overseas min >= 2 if possible (but random is fine, we just filter constraints).
        const remainingPlayers = shuffle(players.filter(p => isAvailable(p)));
        let remIdx = 0;

        for (const tb of teamBuckets) {
            const getOsCount = () => Array.from(tb.squad).filter(x => x.nationality === 'OVERSEAS').length;
            
            // First, if they have less than 2 OVERSEAS, force them to take overseas
            while (getOsCount() < 2 && tb.squad.size < 15 && remIdx < remainingPlayers.length) {
                const candidateIdx = remainingPlayers.findIndex((p, i) => i >= remIdx && p.nationality === 'OVERSEAS' && isAvailable(p));
                if (candidateIdx === -1) break; // no more overseas
                const p = remainingPlayers[candidateIdx];
                tb.squad.add(p);
                markAssigned(p);
                // swap candidate to remIdx so we don't scan it again
                [remainingPlayers[remIdx], remainingPlayers[candidateIdx]] = [remainingPlayers[candidateIdx], remainingPlayers[remIdx]];
                remIdx++;
            }

            // Fill up to 15
            while (tb.squad.size < 15 && remIdx < remainingPlayers.length) {
                const p = remainingPlayers[remIdx];
                // Check max constraints
                if (p.nationality === 'OVERSEAS' && getOsCount() >= 5) {
                    remIdx++; continue;
                }
                tb.squad.add(p);
                markAssigned(p);
                remIdx++;
            }
        }

        // Now persist
        for (const { team, squad: uniqueSquad } of teamBuckets) {
            const squad = Array.from(uniqueSquad);
            const getCounts = (set) => countCategories(Array.from(set));
            const squadCounts = getCounts(uniqueSquad);

            // Print squad composition
            console.log(`📋 ${team.name} — Squad (${squad.length}): ${fmtCounts(squadCounts)}`);

            await prisma.teamPlayer.deleteMany({ where: { team_id: team.id } });
            await prisma.top11Selection.deleteMany({ where: { team_id: team.id } });

            const spent = 100 + Math.random() * 15;
            await prisma.team.update({
                where: { id: team.id },
                data: {
                    brand_score: 40 + Math.random() * 60,
                    purse_remaining: 120 - spent
                }
            });

            for (const p of squad) {
                await prisma.teamPlayer.create({
                    data: { team_id: team.id, player_id: p.id, price_paid: spent / 15 }
                });
            }

            // Pick 11 from the 15: MUST include at least 1 WK, max 4 overseas
            const squadWks = squad.filter(p => p.category === 'WK');
            const squadNonWks = squad.filter(p => p.category !== 'WK');
            const top11 = [...squadWks]; // Include all WKs
            
            for (const p of shuffle(squadNonWks)) {
                if (top11.length >= 11) break;
                const osInTop11 = top11.filter(x => x.nationality === 'OVERSEAS').length;
                if (p.nationality === 'OVERSEAS' && osInTop11 >= 4) continue;
                top11.push(p);
            }

            const top11Counts = countCategories(top11);
            const top11Ids = top11.map(p => p.id);
            const captainId = top11Ids[0];
            const viceCaptainId = top11Ids[1];

            console.log(`   └─ Top 11 (${top11.length}): ${fmtCounts(top11Counts)}`);

            try {
                await lockLineupViaApi(team.id, top11Ids, captainId, viceCaptainId);
                console.log(`   ✅ Lineup locked successfully`);
            } catch (err) {
                console.log(`   ❌ Lineup FAILED: ${err.message}`);
            }
            console.log('');
        }

        console.log(`📊 Total players assigned: ${assignedIds.size} / ${players.length}`);
        console.log('');

        const leaderboard = await getLeaderboardViaApi();
        console.log('🏆 LEADERBOARD RESULTS');
        console.log('─'.repeat(60));
        leaderboard.forEach(entry => {
            console.log(`${entry.rank}. ${entry.teamName} | Total Score: ${entry.score.finalScore}`);
            if (entry.status === 'ACTIVE') {
                 console.log(`   Detailed Calculation:`);
                 console.log(`   - Base Score (Σ rating^1.15 * weight): ${entry.score.baseScore}`);
                 console.log(`   - Captain Bonus (rating^1.15): ${entry.score.captainBonus}`);
                 console.log(`   - Vice Captain Bonus (0.5 * rating^1.15): ${entry.score.vcBonus}`);
                 console.log(`   - Squad Balance Bonus (30 - Penalty*4): ${entry.score.balanceBonus}`);
                 console.log(`   - Efficiency Bonus (15 - |Spent-110|*0.3): ${entry.score.efficiencyBonus}`);
                 console.log(`   - Brand Bonus (NormalizedBrand * 5): ${entry.score.brandBonus}`);
            }
            if (entry.status === 'ELIMINATED') {
                console.log(`   ❌ Errors: ${entry.errors.join('; ')}`);
            }
        });

    } catch (error) {
        console.error('❌ Error:', error);
    } finally {
        await prisma.$disconnect();
    }
}

runSimulation();
