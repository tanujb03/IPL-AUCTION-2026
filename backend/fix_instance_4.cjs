const fs = require('fs');

let sql = fs.readFileSync('instance_4_init.sql', 'utf8');

sql = sql.replace(
    /('Ayush Badoni'[^]+?) false, NULL, NULL, (\d+, 'https)/,
    `$1 true, 'Mystery Player', 'Delhi found me late, IPL gave me my stage, and I turned into a finisher who punches hard from the lower order. My name sounds gentle, but my bat speaks loudly under pressure. Who am I?', $2`
);

sql = sql.replace(
    /('Nehal Wadhera'[^]+?) true, 'Mystery Player', '[^]+?', (0, 'https)/,
    `$1 true, 'Mystery Player', 'A young batter who rose quickly through domestic cricket. Mumbai once trusted my fearless stroke play in the middle order. Left-hand elegance mixed with aggression. Who am I?', $2`
);

fs.writeFileSync('instance_4_init.sql', sql, 'utf8');
