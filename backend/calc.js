const fs = require('fs');
const path = require('path');

function parseCSV(filePath) {
    const content = fs.readFileSync(filePath, 'utf-8');
    const lines = content.split(/\r?\n/).filter(line => line.trim());
    const header = lines[0].split(',');
    return lines.slice(1).map(line => {
        const values = line.split(',');
        const obj = {};
        header.forEach((h, i) => {
            obj[h.trim()] = values[i] ? values[i].trim() : null;
        });
        return obj;
    });
}

function parseRiddles(filePath) {
    if (!fs.existsSync(filePath)) return {};
    const content = fs.readFileSync(filePath, 'utf-8');
    const riddlesHash = {};
    const blocks = content.split(/Riddle Card \d+:\s*/i).filter(b => b.trim());
    blocks.forEach(block => {
        const lines = block.split(/\r?\n/).filter(l => l.trim());
        const title = lines[0]?.trim();
        const answerLine = lines.find(l => /^Answer:/i.test(l));
        const answer = answerLine ? answerLine.replace(/^Answer:\s*/i, '').trim() : '';
        if (answer) {
            riddlesHash[answer] = true;
        }
    });
    return riddlesHash;
}

const pIds = [143, 152, 147, 123, 11, 18, 79, 22, 72, 39, 12, 109, 137, 102, 146];

const allPlayers = parseCSV(path.join(__dirname, 'resources/sequence_1.csv'));
const allRiddles = parseRiddles(path.join(__dirname, 'resources/sequence_1_riddles.txt'));

const teamPlayers = allPlayers.filter(p => pIds.includes(parseInt(p.Rank)));

const purseRemaining = 13.75;
const brandScore = 40.00; // LSG brand score from generate_all_instances.cjs
// Max brand score is 67.84 (CSK)
const maxBrandScore = 67.84;

// Format players like the service expects
const squad = teamPlayers.map(p => {
    return {
        rank: parseInt(p.Rank),
        name: p.Player,
        category: p.Category.toUpperCase(),
        rating: parseInt(p.Rating) || 0,
        nationality: p.Nationality.toUpperCase() === 'INDIAN' ? 'INDIAN' : 'OVERSEAS',
        is_riddle: !!allRiddles[p.Player]
    };
});

// User noted: "(the riddle player is not being counted as a normal player after being bought,thus we need to find out their final score manually)"
// Let's identify the riddle player
const riddlePlayers = squad.filter(p => p.is_riddle);
console.log("Riddle Players:");
riddlePlayers.forEach(p => console.log(`- ${p.rank} ${p.name} (${p.category}, Rating: ${p.rating}, ${p.nationality})`));
console.log('');

// Composition counts
const counts = { BAT: 0, BOWL: 0, AR: 0, WK: 0, OVERSEAS: 0 };
squad.forEach(tp => {
    counts[tp.category]++;
    if (tp.nationality === 'OVERSEAS') counts.OVERSEAS++;
});

console.log(`Squad (${squad.length}): BAT:${counts.BAT} BOWL:${counts.BOWL} AR:${counts.AR} WK:${counts.WK} OVS:${counts.OVERSEAS}`);

const ROLE_WEIGHTS = { BAT: 1.00, AR: 1.00, WK: 1.00, BOWL: 0.96 };
const SQUAD_RULES = {
    BAT: { ideal: 4 },
    BOWL: { ideal: 6 },
    AR: { ideal: 4 },
    WK: { ideal: 2 },
    overseas: { ideal: 3 },
};

function calcBaseScore(top11Players) {
    return top11Players.reduce((sum, p) => sum + (ROLE_WEIGHTS[p.category] || 1.0) * Math.pow(p.rating, 1.15), 0);
}

function calcBalanceBonus(squadCounts) {
    const penalty =
        Math.abs(squadCounts.BAT - SQUAD_RULES.BAT.ideal) +
        Math.abs(squadCounts.BOWL - SQUAD_RULES.BOWL.ideal) +
        Math.abs(squadCounts.AR - SQUAD_RULES.AR.ideal) +
        Math.abs(squadCounts.WK - SQUAD_RULES.WK.ideal) +
        Math.abs(squadCounts.OVERSEAS - SQUAD_RULES.overseas.ideal);
    return Math.max(0, 30 - penalty * 4);
}

// Find best 11
function getBestTop11() {
    let bestScore = -1;
    let best11 = null;
    let bestCap = null;
    let bestVC = null;
    
    // We must select exactly 11, with max 4 overseas, min 1 WK.
    const getCombos = (arr, k) => {
        if (k === 0) return [[]];
        if (arr.length === 0) return [];
        const [first, ...rest] = arr;
        const withFirst = getCombos(rest, k - 1).map(c => [first, ...c]);
        const withoutFirst = getCombos(rest, k);
        return [...withFirst, ...withoutFirst];
    };
    
    const combos = getCombos(squad, 11);
    
    for (const combo of combos) {
        let wkCount = 0;
        let osCount = 0;
        combo.forEach(p => {
            if (p.category === 'WK') wkCount++;
            if (p.nationality === 'OVERSEAS') osCount++;
        });
        
        if (wkCount >= 1 && osCount <= 4) {
            // Find cap and VC
            let sorted = [...combo].sort((a,b) => b.rating - a.rating);
            const cap = sorted[0];
            const vc = sorted[1];
            
            const base = calcBaseScore(combo);
            const capBonus = Math.pow(cap.rating, 1.15);
            const vcBonus = 0.5 * Math.pow(vc.rating, 1.15);
            const total = base + capBonus + vcBonus;
            
            if (total > bestScore) {
                bestScore = total;
                best11 = combo;
                bestCap = cap;
                bestVC = vc;
            }
        }
    }
    
    return { best11, bestCap, bestVC, bestScore };
}

const { best11, bestCap, bestVC, bestScore } = getBestTop11();

const balanceBonus = calcBalanceBonus(counts);
const efficiencyBonus = Number(purseRemaining);
const brandBonus = Number(brandScore);

const finalScore = bestScore + balanceBonus + efficiencyBonus + brandBonus;

console.log("BEST TOP 11:");
best11.sort((a,b)=>b.rating - a.rating).forEach(p => {
    let lbl = '';
    if (p.rank === bestCap.rank) lbl = '(C)';
    if (p.rank === bestVC.rank) lbl = '(VC)';
    console.log(`- ${p.name} [${p.category}/OVS:${p.nationality==='OVERSEAS'}/Rating:${p.rating}] ${lbl}`);
});

console.log(`\nBase Score + Cap/VC: ${bestScore.toFixed(2)}` );
console.log(`Balance Bonus: ${balanceBonus}`);
console.log(`Efficiency Bonus: ${efficiencyBonus}`);
console.log(`Brand Bonus: ${brandBonus.toFixed(2)}`);
console.log(`FINAL SCORE: ${finalScore.toFixed(2)}`);
