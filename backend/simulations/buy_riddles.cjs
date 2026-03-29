const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();

async function simulateRiddleBuys() {
    try {
        const riddles = await prisma.player.findMany({ where: { is_riddle: true } });
        if (riddles.length === 0) {
            console.log("No riddle players found! Ensure DB is seeded with Day 2.");
            return;
        }

        const teams = await prisma.team.findMany();
        if (teams.length === 0) {
            console.log("No teams found.");
            return;
        }

        console.log(`Found ${riddles.length} riddle players. Distributing...`);

        for (let i = 0; i < riddles.length; i++) {
            const player = riddles[i];
            const team = teams[i % teams.length]; // distribute evenly

            // 1. Update AuctionPlayer to SOLD
            await prisma.auctionPlayer.updateMany({
                where: { player_id: player.id },
                data: {
                    status: 'SOLD',
                    sold_price: 2.0, // Default 2.0 Cr
                    sold_to_team_id: team.id
                }
            });

            // 2. Create TeamPlayer record
            await prisma.teamPlayer.create({
                data: {
                    team_id: team.id,
                    player_id: player.id,
                    price_paid: 2.0
                }
            });

            // 3. Update Team counts and purse
            await prisma.team.update({
                where: { id: team.id },
                data: {
                    purse_remaining: { decrement: 2.0 },
                    squad_count: { increment: 1 },
                    bowlers_count: player.role === 'Bowler' ? { increment: 1 } : undefined,
                    batsmen_count: player.role === 'Batsman' ? { increment: 1 } : undefined,
                    ar_count: player.role.includes('Allrounder') ? { increment: 1 } : undefined,
                    wk_count: player.role.includes('WK') ? { increment: 1 } : undefined,
                    overseas_count: player.nationality === 'OVERSEAS' ? { increment: 1 } : undefined
                }
            });

            // 4. Clear is_riddle flag on player
            await prisma.player.update({
                where: { id: player.id },
                data: { is_riddle: false }
            });

            console.log(`✅ ${player.name} (Riddle) sold to ${team.name} and unmasked`);
        }
        
    } catch(e) {
        console.error("Simulation error:", e);
    } finally {
        await prisma.$disconnect();
    }
}

simulateRiddleBuys();
