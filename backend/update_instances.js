const fs = require('fs');
const path = require('path');

const instances = [
    { file: 'instance_1_init.sql', listFile: 'List1.txt', oldRiddles: ['Jos Buttler', 'Krunal Pandya'] },
    { file: 'instance_2_init.sql', listFile: 'List2.txt', oldRiddles: ['Trent Boult', 'KL Rahul'] },
    { file: 'instance_3_init.sql', listFile: 'List3.txt', oldRiddles: ['Shardul Thakur', 'Mohsin Khan'] },
    { file: 'instance_4_init.sql', listFile: 'List4.txt', oldRiddles: ['Kagiso Rabada', 'Jaydev Unadkat'] }
];

const brandScores = {
    'CSK': 5,
    'MI': 4.83,
    'RCB': 3.56,
    'KKR': 3.1,
    'SRH': 2.1,
    'RR': 2.37,
    'GT': 2.33,
    'DC': 1.97,
    'PBKS': 1.96,
    'LSG': 1.5
};

function parseList(listPath) {
    const listPathAbs = path.join(__dirname, 'resources', listPath);
    if (!fs.existsSync(listPathAbs)) return [];
    
    const content = fs.readFileSync(listPathAbs, 'utf8');
    const riddles = [];
    const blocks = content.split('\n\n').filter(b => b.trim());
    
    for (let block of blocks) {
        const lines = block.split('\n').filter(x => x.trim());
        let name = null;
        let question = [];
        
        for (let line of lines) {
            line = line.trim();
            if (line.toLowerCase().startsWith('name:')) {
                name = line.substring(5).trim();
                if (name === 'Ayush Badnoi') name = 'Ayush Badoni';
                if (name.toLowerCase() === 'liam livingstone') name = 'Liam Livingstone';
            } else {
                question.push(line);
            }
        }
        
        if (name && question.length > 0) {
            riddles.push({
                name,
                title: 'Mystery Player', 
                question: question.join(' ').replace(/'/g, "''")
            });
        }
    }
    return riddles;
}

instances.forEach(inst => {
    const filePath = path.join(__dirname, inst.file);
    if (!fs.existsSync(filePath)) return;
    
    let sqlLines = fs.readFileSync(filePath, 'utf8').split('\n');
    let sqlModified = false;

    for (let i = 0; i < sqlLines.length; i++) {
        let text = sqlLines[i];
        
        // 1. Ashutosh Sharma
        if (text.includes("'Ashutosh Sharma'") && text.includes('56.0, 0.0, 0.0)')) {
            text = text.replace('56.0, 0.0, 0.0)', '56.0, 7.0, 14.0)');
            sqlModified = true;
        }

        // 2. Franchise bonuses
        for (const [shortName, score] of Object.entries(brandScores)) {
            const brandMatch = new RegExp(`\\(\\d+, '[^']+', '${shortName}', [\\d.]+, `);
            if (brandMatch.test(text)) {
                text = text.replace(new RegExp(`(\\(\\d+, '[^']+', '${shortName}', )[\\d.]+(, )`), `$1${score}$2`);
                sqlModified = true;
            }
        }

        // 3. Remove Old Riddles
        for (const oldName of inst.oldRiddles) {
            if (text.includes(`'${oldName}',`)) {
                // Safely match everything up to the legacy ID which is immediately before URL
                const oldRiddleMatch = /(, true, )(.*?)(, \d+, 'https)/;
                if (oldRiddleMatch.test(text)) {
                    text = text.replace(oldRiddleMatch, ', false, NULL, NULL$3');
                    sqlModified = true;
                }
            }
        }

        // 4. Add New Riddles
        const newRiddles = parseList(inst.listFile);
        for (const riddle of newRiddles) {
            if (text.includes(`'${riddle.name}',`)) {
                const newRiddleMatch = /(, false, NULL, NULL)(, \d+, 'https)/;
                if (newRiddleMatch.test(text)) {
                    text = text.replace(newRiddleMatch, `, true, '${riddle.title}', '${riddle.question}'$2`);
                    sqlModified = true;
                }
            }
        }

        sqlLines[i] = text;
    }

    if (sqlModified) {
        fs.writeFileSync(filePath, sqlLines.join('\n'), 'utf8');
        console.log(`Successfully updated ${inst.file}`);
    }
});
