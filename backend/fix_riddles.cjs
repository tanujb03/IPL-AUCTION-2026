const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();

async function fixRiddleFlags() {
    try {
        console.log("Checking for sold players that are still marked as riddles...");
        
        // Find all players who are in the team_players table but still have is_riddle = true
        const soldRiddles = await prisma.player.findMany({
            where: {
                is_riddle: true,
                team_players: {
                    some: {}
                }
            }
        });

        if (soldRiddles.length === 0) {
            console.log("No inconsistencies found. All sold players are already unmasked.");
            return;
        }

        console.log(`Found ${soldRiddles.length} sold players that are still masked. Unmasking...`);

        for (const player of soldRiddles) {
            await prisma.player.update({
                where: { id: player.id },
                data: { is_riddle: false }
            });
            console.log(`✅ Unmasked ${player.name} (Rank ${player.rank})`);
        }

        console.log("Database reconciliation complete.");
    } catch (e) {
        console.error("Error during fix:", e);
    } finally {
        await prisma.$disconnect();
    }
}

fixRiddleFlags();
