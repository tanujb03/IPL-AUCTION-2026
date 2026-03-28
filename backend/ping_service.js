import https from 'https';
import http from 'http';
import dotenv from 'dotenv';
dotenv.config();

// Array of backend URLs to keep alive
const TARGET_URLS = [
    process.env.BACKEND_URL_1 || 'https://ipl-auction-backend-1.onrender.com',
    process.env.BACKEND_URL_2 || 'https://ipl-auction-backend-2.onrender.com',
    process.env.BACKEND_URL_3 || 'https://ipl-auction-backend-3.onrender.com',
    process.env.BACKEND_URL_4 || 'https://ipl-auction-backend-4.onrender.com',
];

const PING_INTERVAL_MINUTES = 10;
const PING_INTERVAL_MS = PING_INTERVAL_MINUTES * 60 * 1000;

function pingUrls() {
    console.log(`\n[${new Date().toLocaleTimeString()}] 🚀 Initiating ping sequence for ${TARGET_URLS.length} instances...`);
    
    TARGET_URLS.forEach((baseUrl, index) => {
        if (!baseUrl || baseUrl.trim() === '') return;
        
        // Remove trailing slash if present
        const url = `${baseUrl.replace(/\/$/, '')}/api/health`;
        const client = url.startsWith('https') ? https : http;

        client.get(url, (res) => {
            if (res.statusCode === 200) {
                console.log(`✅ Instance ${index + 1} (${baseUrl}) is AWAKE (Status: ${res.statusCode})`);
            } else {
                console.warn(`⚠️ Instance ${index + 1} (${baseUrl}) returned status: ${res.statusCode}`);
            }
        }).on('error', (err) => {
            console.error(`❌ Error pinging Instance ${index + 1} (${baseUrl}): ${err.message}`);
        });
    });
}

console.log('═══════════════════════════════════════════════════');
console.log(`🏏 IPL Auction 2026 — Multi-Instance Keep-Alive Service`);
console.log(`Interval: Every ${PING_INTERVAL_MINUTES} minutes`);
console.log(`Monitoring ${TARGET_URLS.length} endpoints`);
console.log(`Make sure to update the URLs in ping_service.js or .env file!`);
console.log(`Press Ctrl+C to stop`);
console.log('═══════════════════════════════════════════════════');

// Initial ping
pingUrls();

// Schedule subsequent pings
setInterval(pingUrls, PING_INTERVAL_MS);
