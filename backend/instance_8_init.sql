-- INSTANCE 8 INITIALIZATION
-- RESETS THE DATABASE FOR A FRESH START
DROP SCHEMA public CASCADE;
CREATE SCHEMA public;
SET search_path TO public;

-- CreateEnum
CREATE TYPE "Category" AS ENUM ('BAT', 'BOWL', 'AR', 'WK');

-- CreateEnum
CREATE TYPE "Pool" AS ENUM ('BAT_WK', 'BOWL', 'AR');

-- CreateEnum
CREATE TYPE "Grade" AS ENUM ('A', 'B', 'C', 'D');

-- CreateEnum
CREATE TYPE "Nationality" AS ENUM ('INDIAN', 'OVERSEAS');

-- CreateEnum
CREATE TYPE "AuctionPhase" AS ENUM ('NOT_STARTED', 'FRANCHISE_PHASE', 'POWER_CARD_PHASE', 'LIVE', 'POST_AUCTION', 'COMPLETED');

-- CreateEnum
CREATE TYPE "SequenceType" AS ENUM ('PLAYER', 'FRANCHISE', 'POWER_CARD');

-- CreateEnum
CREATE TYPE "PlayerAuctionStatus" AS ENUM ('UNSOLD', 'SOLD');

-- CreateEnum
CREATE TYPE "PowerCardType" AS ENUM ('GOD_EYE', 'MULLIGAN', 'FINAL_STRIKE', 'BID_FREEZER', 'RIGHT_TO_MATCH');

-- CreateTable
CREATE TABLE "Team" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "username" TEXT NOT NULL,
    "password_hash" TEXT NOT NULL,
    "active_session_id" TEXT,
    "brand_key" TEXT,
    "franchise_name" TEXT,
    "brand_score" DECIMAL(65,30) NOT NULL DEFAULT 0,
    "purse_remaining" DECIMAL(65,30) NOT NULL DEFAULT 120,
    "squad_count" INTEGER NOT NULL DEFAULT 0,
    "overseas_count" INTEGER NOT NULL DEFAULT 0,
    "batsmen_count" INTEGER NOT NULL DEFAULT 0,
    "bowlers_count" INTEGER NOT NULL DEFAULT 0,
    "ar_count" INTEGER NOT NULL DEFAULT 0,
    "wk_count" INTEGER NOT NULL DEFAULT 0,
    "purchased_players" JSONB NOT NULL DEFAULT '[]',
    "logo" TEXT,
    "primary_color" TEXT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Team_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Player" (
    "id" TEXT NOT NULL,
    "rank" INTEGER NOT NULL,
    "name" TEXT NOT NULL,
    "team" TEXT NOT NULL,
    "role" TEXT NOT NULL,
    "category" "Category" NOT NULL,
    "pool" "Pool" NOT NULL,
    "grade" "Grade" NOT NULL,
    "rating" INTEGER NOT NULL,
    "nationality" "Nationality" NOT NULL,
    "nationality_raw" TEXT,
    "base_price" DECIMAL(65,30) NOT NULL,
    "legacy" INTEGER NOT NULL DEFAULT 0,
    "url" TEXT,
    "image_url" TEXT,
    "is_riddle" BOOLEAN NOT NULL DEFAULT false,
    "riddle_title" TEXT,
    "riddle_question" TEXT,
    "matches" INTEGER,
    "bat_runs" INTEGER,
    "bat_sr" DECIMAL(65,30),
    "bat_average" DECIMAL(65,30),
    "bowl_wickets" INTEGER,
    "bowl_eco" DECIMAL(65,30),
    "bowl_avg" DECIMAL(65,30),
    "sub_experience" INTEGER,
    "sub_scoring" INTEGER,
    "sub_impact" INTEGER,
    "sub_consistency" INTEGER,
    "sub_wicket_taking" INTEGER,
    "sub_economy" INTEGER,
    "sub_efficiency" INTEGER,
    "sub_batting" INTEGER,
    "sub_bowling" INTEGER,
    "sub_versatility" INTEGER,

    CONSTRAINT "Player_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "AuctionPlayer" (
    "id" TEXT NOT NULL,
    "player_id" TEXT NOT NULL,
    "status" "PlayerAuctionStatus" NOT NULL DEFAULT 'UNSOLD',
    "sold_price" DECIMAL(65,30),
    "sold_to_team_id" TEXT,

    CONSTRAINT "AuctionPlayer_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "TeamPlayer" (
    "id" TEXT NOT NULL,
    "team_id" TEXT NOT NULL,
    "player_id" TEXT NOT NULL,
    "price_paid" DECIMAL(65,30) NOT NULL,

    CONSTRAINT "TeamPlayer_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "AuctionState" (
    "id" INTEGER NOT NULL DEFAULT 1,
    "phase" "AuctionPhase" NOT NULL DEFAULT 'NOT_STARTED',
    "current_player_id" TEXT,
    "current_item_id" TEXT,
    "current_bid" DECIMAL(65,30),
    "highest_bidder_id" TEXT,
    "current_sequence_id" INTEGER,
    "current_sequence_index" INTEGER NOT NULL DEFAULT 0,
    "bid_frozen_team_id" TEXT,
    "auction_day" TEXT NOT NULL DEFAULT 'Day 1',
    "active_power_card" TEXT,
    "active_power_card_team" TEXT,
    "gods_eye_revealed" BOOLEAN NOT NULL DEFAULT false,
    "bid_history" JSONB NOT NULL DEFAULT '[]',
    "last_sold_player_id" TEXT,
    "last_sold_price" DECIMAL(65,30),
    "last_sold_team_id" TEXT,
    "last_sold_team_name" TEXT,

    CONSTRAINT "AuctionState_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "AuctionSequence" (
    "id" INTEGER NOT NULL,
    "name" TEXT NOT NULL,
    "type" "SequenceType" NOT NULL DEFAULT 'PLAYER',
    "sequence_items" JSONB NOT NULL DEFAULT '[]',

    CONSTRAINT "AuctionSequence_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "AdminUser" (
    "id" TEXT NOT NULL,
    "username" TEXT NOT NULL,
    "password_hash" TEXT NOT NULL,
    "role" TEXT NOT NULL,
    "active_session_id" TEXT,

    CONSTRAINT "AdminUser_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "PowerCard" (
    "id" TEXT NOT NULL,
    "team_id" TEXT NOT NULL,
    "type" "PowerCardType" NOT NULL,
    "is_used" BOOLEAN NOT NULL DEFAULT false,

    CONSTRAINT "PowerCard_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Top11Selection" (
    "team_id" TEXT NOT NULL,
    "player_ids" TEXT[],
    "captain_id" TEXT NOT NULL,
    "vice_captain_id" TEXT NOT NULL,
    "submitted_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Top11Selection_pkey" PRIMARY KEY ("team_id")
);

-- CreateTable
CREATE TABLE "AuditLog" (
    "id" TEXT NOT NULL,
    "action" TEXT NOT NULL,
    "details" JSONB NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "AuditLog_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Franchise" (
    "id" INTEGER NOT NULL,
    "name" TEXT NOT NULL,
    "short_name" TEXT NOT NULL,
    "brand_score" DECIMAL(65,30) NOT NULL DEFAULT 0,
    "logo" TEXT,
    "primary_color" TEXT,

    CONSTRAINT "Franchise_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "Team_name_key" ON "Team"("name");

-- CreateIndex
CREATE UNIQUE INDEX "Team_username_key" ON "Team"("username");

-- CreateIndex
CREATE UNIQUE INDEX "Team_brand_key_key" ON "Team"("brand_key");

-- CreateIndex
CREATE UNIQUE INDEX "Player_rank_key" ON "Player"("rank");

-- CreateIndex
CREATE UNIQUE INDEX "AuctionPlayer_player_id_key" ON "AuctionPlayer"("player_id");

-- CreateIndex
CREATE UNIQUE INDEX "TeamPlayer_team_id_player_id_key" ON "TeamPlayer"("team_id", "player_id");

-- CreateIndex
CREATE UNIQUE INDEX "AdminUser_username_key" ON "AdminUser"("username");

-- CreateIndex
CREATE UNIQUE INDEX "PowerCard_team_id_type_key" ON "PowerCard"("team_id", "type");

-- CreateIndex
CREATE UNIQUE INDEX "Franchise_name_key" ON "Franchise"("name");

-- CreateIndex
CREATE UNIQUE INDEX "Franchise_short_name_key" ON "Franchise"("short_name");

-- AddForeignKey
ALTER TABLE "AuctionPlayer" ADD CONSTRAINT "AuctionPlayer_player_id_fkey" FOREIGN KEY ("player_id") REFERENCES "Player"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AuctionPlayer" ADD CONSTRAINT "AuctionPlayer_sold_to_team_id_fkey" FOREIGN KEY ("sold_to_team_id") REFERENCES "Team"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "TeamPlayer" ADD CONSTRAINT "TeamPlayer_team_id_fkey" FOREIGN KEY ("team_id") REFERENCES "Team"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "TeamPlayer" ADD CONSTRAINT "TeamPlayer_player_id_fkey" FOREIGN KEY ("player_id") REFERENCES "Player"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PowerCard" ADD CONSTRAINT "PowerCard_team_id_fkey" FOREIGN KEY ("team_id") REFERENCES "Team"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Top11Selection" ADD CONSTRAINT "Top11Selection_team_id_fkey" FOREIGN KEY ("team_id") REFERENCES "Team"("id") ON DELETE RESTRICT ON UPDATE CASCADE;



-- ── DATA FOR INSTANCE 8 ──

INSERT INTO "Franchise" (id, name, short_name, brand_score, logo, primary_color) VALUES
(1, 'Chennai Super Kings', 'CSK', 67.84, '/teams/csk.png', '#FCBD02'),
(2, 'Mumbai Indians', 'MI', 66.46, '/teams/mi.png', '#004BA0'),
(3, 'Royal Challengers Bengaluru', 'RCB', 56.50, '/teams/rcb.png', '#EC1C24'),
(4, 'Kolkata Knight Riders', 'KKR', 52.87, '/teams/kkr.png', '#3A225D'),
(5, 'Sunrisers Hyderabad', 'SRH', 47.12, '/teams/srh.png', '#F7A721'),
(6, 'Rajasthan Royals', 'RR', 45.62, '/teams/rr.png', '#254AA5'),
(7, 'Gujarat Titans', 'GT', 45.29, '/teams/gt.png', '#1D5E84'),
(8, 'Delhi Capitals', 'DC', 42.23, '/teams/dc.png', '#0078BC'),
(9, 'Punjab Kings', 'PBKS', 42.16, '/teams/pbks.png', '#ED1B24'),
(10, 'Lucknow Super Giants', 'LSG', 40.00, '/teams/lsg.png', '#A72056');

INSERT INTO "Team" (id, name, username, password_hash, purse_remaining, squad_count) VALUES
('cf49df79-2b6f-4d06-965c-46659df190ee', '404 Not Found', '404 Not Found', '$2b$10$LOKevjqOQxaN.oAaGp.qW.V41CR7I.ZtbbAfGi1oBEs/J5mRkV5rW', 120, 0),
('77fadaec-f8bd-40ec-8bb8-a2d62abd03a4', 'Garden Boys', 'Garden Boys', '$2b$10$Hra7S7FWOwq2PsUDVtZOvuS.X03w6WZNh5FcrJAU3hWj0XupfRbsm', 120, 0),
('bba68a3b-7322-45c3-8b97-66b3f03e4aaa', 'Hamza Ali Mazari', 'Hamza Ali Mazari', '$2b$10$GDd9716naV41y/EsvTMdR.oKunrVwT801s5Tx9d9WCKB3sTpxyg1K', 120, 0),
('67d916fa-08f3-4797-9b67-221ebbf0ae34', 'SportsOnTop', 'SportsOnTop', '$2b$10$8b/HScGY/ozGVpJnd6OK7.Hi9SkOyW8I5YwpFd1sv3v3ef0Nx2rkm', 120, 0),
('0c4c29f4-23c5-414c-895d-9ffef0c703f0', 'Choco Indians', 'Choco Indians', '$2b$10$KKRKbjU3.JraPeQh3pSP..Lra94zBR1LzAdUrTXACyTNmCZeBKeLK', 120, 0),
('50ee19df-bcbc-46cf-ab5a-4893beff6651', '3 Musketeers', '3 Musketeers', '$2b$10$cY52IxzbvuSrIogNLHpsnOK91rsE6UCtBnKb0PrVfWteLKOaomG4O', 120, 0),
('e0a04b32-414b-49a4-9708-32d00ba6e38d', 'Tung Tung Sahur', 'Tung Tung Sahur', '$2b$10$oxrn1Ybm.gn0eOlZYGF3HudE6dltlFROmGwgPjsSNMv8Mdl9E0MyW', 120, 0),
('c4d4c202-7d4a-4e7a-a665-54944c3c4f3a', 'Kelloggzzz 11', 'Kelloggzzz 11', '$2b$10$cgtXtDIkXgY5Sg/WUeT8hOIXHUEvgznssIAmnjwMnkEf2DypGsxlK', 120, 0),
('5903fc6b-aa0a-4694-90cf-f370b1f312a9', 'Ex. Heads', 'Ex. Heads', '$2b$10$H9B/stqUzKfOrkhQR5upneOnt8I7mLYTwOx4QMXv1X5Y7LOX6rnS.', 120, 0),
('e63a745b-1106-4813-8b13-41e1974c8533', 'MI2020', 'MI2020', '$2b$10$P9CZt6xm0PCk6VNAj8Eu.OgrwFqPE1VPiJIpyzC6lEBBfbxo7ogiK', 120, 0);

INSERT INTO "Player" (id, rank, name, team, role, category, pool, grade, rating, nationality, nationality_raw, base_price, is_riddle, riddle_title, riddle_question, legacy, url, matches, bat_runs, bat_sr, bat_average, bowl_wickets, bowl_eco, bowl_avg, sub_scoring, sub_impact, sub_consistency, sub_experience, sub_wicket_taking, sub_economy, sub_efficiency, sub_batting, sub_bowling, sub_versatility) VALUES
('c4070925-53b6-4510-9261-bdbd2b3836ee', 89, 'Dhruv Jurel', 'Rajasthan Royals', 'WK-Batsman', 'WK', 'BAT_WK', 'C', 67, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/14691/dhruv-jurel', 41.0, 680.0, 153.85, 28.33, NULL, NULL, NULL, 16.0, 81.0, 71.0, 50, NULL, NULL, NULL, NULL, NULL, NULL),
('a813b77d-c158-4f62-90e8-48b17a88dbf3', 35, 'Deepak Chahar', 'Mumbai Indians', 'Bowler', 'BOWL', 'BOWL', 'B', 78, 'INDIAN', 'Indian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/7836/deepak-chahar', 95.0, NULL, NULL, NULL, 88.0, 8.14, 29.51, NULL, NULL, NULL, 77, 60.0, 70.0, 75.0, NULL, NULL, NULL),
('6891425c-1d56-444a-b5b4-41428771d14f', 122, 'Ashutosh Sharma', 'Delhi Capitals', 'Batting Allrounder', 'AR', 'AR', 'C', 61, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/13497/ashutosh-sharma', 24.0, 393.0, NULL, NULL, 0.0, NULL, NULL, NULL, NULL, NULL, 42, NULL, NULL, NULL, 56.0, 7, 14),
('60fe67d3-8883-4ed3-b76c-fd918b01f9b3', 120, 'Ravisrinivasan Sai Kishore', 'Gujarat Titans', 'Bowling Allrounder', 'AR', 'AR', 'C', 61, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/11595/ravisrinivasan-sai-kishore', 25.0, 18.0, NULL, NULL, 32.0, NULL, NULL, NULL, NULL, NULL, 42, NULL, NULL, NULL, 19.0, 41.0, 19.0),
('d8a9a1b4-3c9e-4743-b986-35718c12b551', 77, 'Rinku Singh', 'Kolkata Knight Riders', 'Batsman', 'BAT', 'BAT_WK', 'C', 69, 'INDIAN', 'Indian', 0.5, true, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/10896/rinku-singh', 58.0, 1099.0, 145.18, 30.53, NULL, NULL, NULL, 24.0, 75.0, 76.0, 59, NULL, NULL, NULL, NULL, NULL, NULL),
('bf6828ed-825d-4749-8f2c-d9534cc1095d', 147, 'Mayank Yadav', 'Lucknow Super Giants', 'Bowler', 'BOWL', 'BOWL', 'C', 57, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/22401/mayank-yadav', 6.0, NULL, NULL, NULL, 9.0, 9.17, 20.56, NULL, NULL, NULL, 33, 9.0, 53.0, 94.0, NULL, NULL, NULL),
('553fb779-b355-44ae-9a7b-04c54d932741', 107, 'Shahbaz Ahmed', 'Lucknow Super Giants', 'Bowling Allrounder', 'AR', 'AR', 'C', 64, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/14606/shahbaz-ahmed', 58.0, 545.0, NULL, NULL, 22.0, NULL, NULL, NULL, NULL, NULL, 59, NULL, NULL, NULL, 43.0, 27.0, 27.0),
('573fa1d9-43bb-4656-bc9c-dda03186d450', 50, 'Mitchell Marsh', 'Lucknow Super Giants', 'Batting Allrounder', 'AR', 'AR', 'B', 74, 'OVERSEAS', 'Australian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/6250/mitchell-marsh', 55.0, 1292.0, NULL, NULL, 37.0, NULL, NULL, NULL, NULL, NULL, 57, NULL, NULL, NULL, 72.0, 43.0, 43.0),
('f16d695b-5ceb-4d1d-a01a-f4f8a223e982', 132, 'Kuldeep Sen', 'Rajasthan Royals', 'Bowler', 'BOWL', 'BOWL', 'C', 59, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/14336/kuldeep-sen', 12.0, NULL, NULL, NULL, 14.0, 9.63, 27.64, NULL, NULL, NULL, 36, 12.0, 45.0, 79.0, NULL, NULL, NULL),
('342906c9-af9e-4e85-a647-2e3bf6c2175d', 100, 'Abishek Porel', 'Delhi Capitals', 'WK-Batsman', 'WK', 'BAT_WK', 'C', 66, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/24326/abishek-porel', 31.0, 661.0, 149.89, 25.42, NULL, NULL, NULL, 16.0, 78.0, 63.0, 45, NULL, NULL, NULL, NULL, NULL, NULL),
('7495e484-ceab-4b8c-86ee-6b7de98581b5', 46, 'Avesh Khan', 'Lucknow Super Giants', 'Bowler', 'BOWL', 'BOWL', 'B', 76, 'INDIAN', 'Indian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/9781/avesh-khan', 75.0, NULL, NULL, NULL, 87.0, 9.12, 28.29, NULL, NULL, NULL, 67, 60.0, 54.0, 77.0, NULL, NULL, NULL),
('2124fa80-5452-4b46-9f2f-b916a3df6815', 68, 'Anrich Nortje', 'Lucknow Super Giants', 'Bowler', 'BOWL', 'BOWL', 'B', 71, 'OVERSEAS', 'South African', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/11427/anrich-nortje', 48.0, NULL, NULL, NULL, 61.0, 9.07, 27.16, NULL, NULL, NULL, 54, 43.0, 55.0, 80.0, NULL, NULL, NULL),
('b4066e98-08aa-4afa-942b-cc348b175ad2', 95, 'Nehal Wadhera', 'Punjab Kings', 'Batsman', 'BAT', 'BAT_WK', 'C', 66, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/13915/nehal-wadhera', 36.0, 719.0, 142.95, 26.63, NULL, NULL, NULL, 17.0, 73.0, 66.0, 48, NULL, NULL, NULL, NULL, NULL, NULL),
('d6451af2-95e0-48fd-aa0b-2b7035613e47', 114, 'Mitchell Santner', 'Mumbai Indians', 'Bowling Allrounder', 'AR', 'AR', 'C', 62, 'OVERSEAS', 'New Zealander', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/10100/mitchell-santner', 31.0, 110.0, NULL, NULL, 25.0, NULL, NULL, NULL, NULL, NULL, 45, NULL, NULL, NULL, 25.0, 40.0, 25.0),
('37cd07bb-d457-488d-8de0-2df022497658', 63, 'T Natarajan', 'Delhi Capitals', 'Bowler', 'BOWL', 'BOWL', 'B', 72, 'INDIAN', 'Indian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/10225/t-natarajan', 63.0, NULL, NULL, NULL, 67.0, 8.94, 30.12, NULL, NULL, NULL, 61, 47.0, 57.0, 74.0, NULL, NULL, NULL),
('37b9acec-a832-4025-bb34-51bbaea1735d', 51, 'Sam Curran', 'Rajasthan Royals', 'Bowling Allrounder', 'AR', 'AR', 'B', 74, 'OVERSEAS', 'English', 1, false, NULL, NULL, 2, 'https://www.cricbuzz.com/profiles/10420/sam-curran', 64.0, 997.0, NULL, NULL, 59.0, NULL, NULL, NULL, NULL, NULL, 62, NULL, NULL, NULL, 62.0, 41.0, 41.0),
('7081eb90-c6b5-46a4-bc30-97ca62d7ed67', 78, 'Rajat Patidar', 'Royal Challengers Bengaluru', 'Batsman', 'BAT', 'BAT_WK', 'C', 69, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/10636/rajat-patidar', 42.0, 1111.0, 154.31, 30.86, NULL, NULL, NULL, 24.0, 81.0, 77.0, 51, NULL, NULL, NULL, NULL, NULL, NULL),
('907794e3-e498-42ec-9ec4-d96f60cc8cd5', 42, 'Ruturaj Gaikwad', 'Chennai Super Kings', 'Batsman', 'BAT', 'BAT_WK', 'B', 77, 'INDIAN', 'Indian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/11813/ruturaj-gaikwad', 71.0, 2502.0, 137.48, 40.35, NULL, NULL, NULL, 49.0, 70.0, 99.0, 65, NULL, NULL, NULL, NULL, NULL, NULL),
('f3a595af-cc6e-464d-b0a4-ba293e79279b', 105, 'Mukesh Kumar', 'Delhi Capitals', 'Bowler', 'BOWL', 'BOWL', 'C', 64, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/10754/mukesh-kumar', 32.0, NULL, NULL, NULL, 36.0, 10.4, 30.61, NULL, NULL, NULL, 46, 27.0, 33.0, 73.0, NULL, NULL, NULL),
('aeb105ee-2282-44b6-b0df-e853433a9949', 67, 'Ayush Badoni', 'Lucknow Super Giants', 'Batting Allrounder', 'AR', 'AR', 'B', 71, 'INDIAN', 'Indian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/13907/ayush-badoni', 56.0, 963.0, NULL, NULL, 4.0, NULL, NULL, NULL, NULL, NULL, 58, NULL, NULL, NULL, 63.0, 37.0, 37.0),
('091930bc-dc6d-42a1-a8fb-6d014e244e13', 148, 'Vignesh Puthur', 'Rajasthan Royals', 'Bowler', 'BOWL', 'BOWL', 'C', 57, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/1447337/vignesh-puthur', 5.0, NULL, NULL, NULL, 6.0, 9.08, 18.17, NULL, NULL, NULL, 32, 7.0, 54.0, 99.0, NULL, NULL, NULL),
('91485030-fb9a-41ae-9dc9-06ba28ca7ecd', 158, 'Arjun Tendulkar', 'Lucknow Super Giants', 'Bowling Allrounder', 'AR', 'AR', 'C', 55, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/13747/arjun-tendulkar', 5.0, 13.0, NULL, NULL, 3.0, NULL, NULL, NULL, NULL, NULL, 32, NULL, NULL, NULL, 32.0, 23.0, 23.0),
('333b262e-b6bd-42d3-b766-dafd9b42b91f', 129, 'Anuj Rawat', 'Gujarat Titans', 'WK-Batsman', 'WK', 'BAT_WK', 'C', 60, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/13135/anuj-rawat', 24.0, 318.0, 119.11, 19.88, NULL, NULL, NULL, 10.0, 57.0, 50.0, 42, NULL, NULL, NULL, NULL, NULL, NULL),
('32b4ee71-d2af-4f11-9225-b04763ab983a', 60, 'Noor Ahmad', 'Chennai Super Kings', 'Bowler', 'BOWL', 'BOWL', 'B', 72, 'OVERSEAS', 'Afghan', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/15452/noor-ahmad', 37.0, NULL, NULL, NULL, 48.0, 8.08, 22.23, NULL, NULL, NULL, 48, 34.0, 71.0, 90.0, NULL, NULL, NULL),
('7b39e3cf-4560-43a4-8217-e46b6df2e844', 135, 'Kartik Tyagi', 'Kolkata Knight Riders', 'Bowler', 'BOWL', 'BOWL', 'C', 58, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/13136/kartik-tyagi', 20.0, NULL, NULL, NULL, 15.0, 10.14, 47.53, NULL, NULL, NULL, 40, 13.0, 37.0, 37.0, NULL, NULL, NULL),
('e750c6b2-fa5b-45a0-9928-a567bac17480', 69, 'Liam Livingstone', 'Sunrisers Hyderabad', 'Batting Allrounder', 'AR', 'AR', 'B', 70, 'OVERSEAS', 'English', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/10045/liam-livingstone', 49.0, 1051.0, NULL, NULL, 13.0, NULL, NULL, NULL, NULL, NULL, 54, NULL, NULL, NULL, 70.0, 28.0, 28.0),
('5a322b5f-12c7-46bb-b8bb-632122c9c58b', 84, 'Cameron Green', 'Kolkata Knight Riders', 'Batting Allrounder', 'AR', 'AR', 'C', 68, 'OVERSEAS', 'Australian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/12225/cameron-green', 29.0, 707.0, NULL, NULL, 16.0, NULL, NULL, NULL, NULL, NULL, 44, NULL, NULL, NULL, 64.0, 27.0, 27.0),
('ddfd073e-4913-4417-8e9f-1babc46f436f', 11, 'Sandeep Sharma', 'Rajasthan Royals', 'Bowler', 'BOWL', 'BOWL', 'A', 93, 'INDIAN', 'Indian', 2, false, NULL, NULL, 4, 'https://www.cricbuzz.com/profiles/8356/sandeep-sharma', 136.0, NULL, NULL, NULL, 146.0, 8.03, 27.88, NULL, NULL, NULL, 98, 98.0, 71.0, 78.0, NULL, NULL, NULL),
('94873c28-1afb-47cf-b876-44d89b6275f5', 93, 'Washington Sundar', 'Gujarat Titans', 'Bowling Allrounder', 'AR', 'AR', 'C', 67, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/10945/washington-sundar', 66.0, 511.0, NULL, NULL, 39.0, NULL, NULL, NULL, NULL, NULL, 63, NULL, NULL, NULL, 42.0, 40.0, 40.0),
('33207a6e-fc8a-4481-98f2-8afaa3b6d835', 64, 'Shreyas Gopal', 'Chennai Super Kings', 'Bowler', 'BOWL', 'BOWL', 'B', 72, 'INDIAN', 'Indian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/9746/shreyas-gopal', 52.0, NULL, NULL, NULL, 52.0, 8.16, 25.92, NULL, NULL, NULL, 56, 37.0, 69.0, 83.0, NULL, NULL, NULL),
('ccbc70dd-adf0-4857-a93b-4461d5db948f', 140, 'Mukesh Choudhary', 'Chennai Super Kings', 'Bowler', 'BOWL', 'BOWL', 'C', 58, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/13184/mukesh-choudhary', 16.0, NULL, NULL, NULL, 17.0, 9.94, 30.71, NULL, NULL, NULL, 38, 14.0, 40.0, 72.0, NULL, NULL, NULL),
('cbf5a7da-0e91-4534-a994-e632c9d9b043', 101, 'Umran Malik', 'Kolkata Knight Riders', 'Bowler', 'BOWL', 'BOWL', 'C', 65, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/19027/umran-malik', 26.0, NULL, NULL, NULL, 29.0, 9.4, 26.62, NULL, NULL, NULL, 43, 22.0, 49.0, 81.0, NULL, NULL, NULL),
('e2399024-819c-48b0-bd71-eff4a9f58f7c', 29, 'Mohammed Siraj', 'Gujarat Titans', 'Bowler', 'BOWL', 'BOWL', 'B', 83, 'INDIAN', 'Indian', 1, false, NULL, NULL, 2, 'https://www.cricbuzz.com/profiles/10808/mohammed-siraj', 108.0, NULL, NULL, NULL, 109.0, 8.74, 30.72, NULL, NULL, NULL, 84, 74.0, 60.0, 72.0, NULL, NULL, NULL),
('9ac81fb0-9011-447e-980c-075828f66b60', 57, 'Jofra Archer', 'Rajasthan Royals', 'Bowler', 'BOWL', 'BOWL', 'B', 73, 'OVERSEAS', 'English', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/11540/jofra-archer', 52.0, NULL, NULL, NULL, 59.0, 7.89, 27.15, NULL, NULL, NULL, 56, 41.0, 74.0, 80.0, NULL, NULL, NULL),
('1583e72f-2577-4753-9023-eab4c35ecb0d', 41, 'Nitish Rana', 'Delhi Capitals', 'Batsman', 'BAT', 'BAT_WK', 'B', 77, 'INDIAN', 'Indian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/9204/nitish-rana', 118.0, 2853.0, 136.77, 27.7, NULL, NULL, NULL, 56.0, 69.0, 69.0, 89, NULL, NULL, NULL, NULL, NULL, NULL),
('c5fe5f02-8806-4b9c-93c2-48eefcb3b668', 155, 'Swapnil Singh', 'Royal Challengers Bengaluru', 'Bowling Allrounder', 'AR', 'AR', 'C', 56, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/10238/swapnil-singh', 14.0, 51.0, NULL, NULL, 7.0, NULL, NULL, NULL, NULL, NULL, 37, NULL, NULL, NULL, 23.0, 27.0, 23.0),
('0f09fe47-bd49-4d38-942d-23fdffac20f1', 134, 'Vipraj Nigam', 'Delhi Capitals', 'Bowler', 'BOWL', 'BOWL', 'C', 59, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/1431811/vipraj-nigam', 14.0, NULL, NULL, NULL, 11.0, 9.13, 32.36, NULL, NULL, NULL, 37, 10.0, 54.0, 69.0, NULL, NULL, NULL),
('91a6d41b-9766-4470-8b03-e671a2c8deb9', 59, 'Rahul Tewatia', 'Gujarat Titans', 'Batting Allrounder', 'AR', 'AR', 'B', 73, 'INDIAN', 'Indian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/9693/rahul-tewatia', 108.0, 1112.0, NULL, NULL, 32.0, NULL, NULL, NULL, NULL, NULL, 84, NULL, NULL, NULL, 64.0, 38.0, 38.0),
('401ec80f-0c44-49b3-b051-5e2326db7dce', 31, 'Manish Pandey', 'Kolkata Knight Riders', 'Batsman', 'BAT', 'BAT_WK', 'B', 82, 'INDIAN', 'Indian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/1836/manish-pandey', 174.0, 3942.0, 121.52, 29.42, NULL, NULL, NULL, 76.0, 59.0, 73.0, 99, NULL, NULL, NULL, NULL, NULL, NULL),
('c38db7c0-9de4-4f36-8f4a-6b7edd3ec170', 79, 'Prabhsimran Singh', 'Punjab Kings', 'WK-Batsman', 'WK', 'BAT_WK', 'C', 69, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/14254/prabhsimran-singh', 51.0, 1305.0, 151.93, 25.59, NULL, NULL, NULL, 28.0, 79.0, 64.0, 55, NULL, NULL, NULL, NULL, NULL, NULL),
('029600cb-a159-44f6-ab3a-79d1507b1c60', 150, 'Adam Milne', 'Rajasthan Royals', 'Bowler', 'BOWL', 'BOWL', 'C', 56, 'OVERSEAS', 'New Zealander', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/7625/adam-milne', 10.0, NULL, NULL, NULL, 7.0, 9.48, 46.71, NULL, NULL, NULL, 35, 8.0, 48.0, 38.0, NULL, NULL, NULL),
('96ec978a-b991-495e-aae0-e058ed573b9e', 109, 'Abdul Samad', 'Lucknow Super Giants', 'Batting Allrounder', 'AR', 'AR', 'C', 63, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/14628/abdul-samad', 63.0, 741.0, NULL, NULL, 2.0, NULL, NULL, NULL, NULL, NULL, 61, NULL, NULL, NULL, 57.0, 5.0, 5.0),
('de2bb370-f8d3-460c-84bd-deab1bf02c66', 6, 'Rohit Sharma', 'Mumbai Indians', 'Batsman', 'BAT', 'BAT_WK', 'A', 96, 'INDIAN', 'Indian', 2, false, NULL, NULL, 8, 'https://www.cricbuzz.com/profiles/576/rohit-sharma', 272.0, 7046.0, 132.1, 29.73, NULL, NULL, NULL, 99.0, 66.0, 74.0, 99, NULL, NULL, NULL, NULL, NULL, NULL),
('3483d6f9-94c6-45f3-8b2f-5d6b156e6d05', 145, 'Akash Maharaj Singh', 'Lucknow Super Giants', 'Bowler', 'BOWL', 'BOWL', 'C', 57, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/14696/akash-maharaj-singh', 10.0, NULL, NULL, NULL, 9.0, 9.54, 36.22, NULL, NULL, NULL, 35, 9.0, 47.0, 61.0, NULL, NULL, NULL),
('0cca0db8-b3ab-45de-9045-a86496af32f8', 139, 'Nandre Burger', 'Rajasthan Royals', 'Bowler', 'BOWL', 'BOWL', 'C', 58, 'OVERSEAS', 'South African', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/13630/nandre-burger', 5.0, NULL, NULL, NULL, 7.0, 8.53, 20.71, NULL, NULL, NULL, 32, 8.0, 63.0, 94.0, NULL, NULL, NULL),
('5ac92318-19d4-4bdf-9968-15736177a68d', 111, 'Ryan Rickelton', 'Mumbai Indians', 'WK-Batsman', 'WK', 'BAT_WK', 'C', 62, 'OVERSEAS', 'South African', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/13070/ryan-rickelton', 14.0, 388.0, 150.98, 29.85, NULL, NULL, NULL, 11.0, 79.0, 74.0, 37, NULL, NULL, NULL, NULL, NULL, NULL),
('6a51f887-9169-4ea4-8987-a2354efeef30', 85, 'Mohsin Khan', 'Lucknow Super Giants', 'Bowler', 'BOWL', 'BOWL', 'C', 67, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/13534/mohsin-khan', 24.0, NULL, NULL, NULL, 27.0, 8.51, 25.52, NULL, NULL, NULL, 42, 21.0, 64.0, 83.0, NULL, NULL, NULL),
('f0611606-ad27-4692-9143-90c5021aeca7', 24, 'Varun Chakaravarthy', 'Kolkata Knight Riders', 'Bowler', 'BOWL', 'BOWL', 'B', 84, 'INDIAN', 'Indian', 1, false, NULL, NULL, 2, 'https://www.cricbuzz.com/profiles/12926/varun-chakaravarthy', 83.0, NULL, NULL, NULL, 100.0, 7.58, 23.85, NULL, NULL, NULL, 71, 68.0, 79.0, 87.0, NULL, NULL, NULL),
('1444aa26-2483-407d-a3d6-c2d4dc5e8ac0', 103, 'Priyansh Arya', 'Punjab Kings', 'Batsman', 'BAT', 'BAT_WK', 'C', 64, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/14689/priyansh-arya', 17.0, 475.0, 179.25, 27.94, NULL, NULL, NULL, 13.0, 98.0, 70.0, 38, NULL, NULL, NULL, NULL, NULL, NULL),
('a8847115-6c3d-443d-885d-e076119e9371', 137, 'Jayant Yadav', 'Gujarat Titans', 'Bowling Allrounder', 'AR', 'AR', 'C', 58, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/8182/jayant-yadav', 20.0, 40.0, NULL, NULL, 8.0, NULL, NULL, NULL, NULL, NULL, 40, NULL, NULL, NULL, 22.0, 25.0, 22.0),
('539c62ac-2721-4ae9-a783-7141c2cfde2a', 36, 'Arshdeep Singh', 'Punjab Kings', 'Bowler', 'BOWL', 'BOWL', 'B', 78, 'INDIAN', 'Indian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/13217/arshdeep-singh', 82.0, NULL, NULL, NULL, 97.0, 9.0, 26.49, NULL, NULL, NULL, 71, 66.0, 56.0, 81.0, NULL, NULL, NULL),
('c495b1e2-be4e-4d01-a3d0-62bd4ec8af9f', 146, 'Anshul Kamboj', 'Chennai Super Kings', 'Bowling Allrounder', 'AR', 'AR', 'C', 57, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/14598/anshul-kamboj', 11.0, 16.0, NULL, NULL, 10.0, NULL, NULL, NULL, NULL, NULL, 35, NULL, NULL, NULL, 21.0, 30.0, 21.0),
('34fa1490-1ba7-420d-ab41-ce44d814595b', 62, 'Shimron Hetmyer', 'Rajasthan Royals', 'Batsman', 'BAT', 'BAT_WK', 'B', 72, 'OVERSEAS', 'West Indian', 1, true, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/9789/shimron-hetmyer', 86.0, 1482.0, 151.85, 29.06, NULL, NULL, NULL, 31.0, 79.0, 72.0, 73, NULL, NULL, NULL, NULL, NULL, NULL),
('5a129617-c2ee-4481-b974-6acbd744010e', 131, 'Romario Shepherd', 'Royal Challengers Bengaluru', 'Bowling Allrounder', 'AR', 'AR', 'C', 60, 'OVERSEAS', 'West Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/13646/romario-shepherd', 18.0, 185.0, NULL, NULL, 10.0, NULL, NULL, NULL, NULL, NULL, 39, NULL, NULL, NULL, 52.0, 18.0, 18.0),
('e6a747b0-2c35-4eac-b1d8-1848d7eaed49', 87, 'Tushar Deshpande', 'Rajasthan Royals', 'Bowler', 'BOWL', 'BOWL', 'C', 67, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/11307/tushar-deshpande', 46.0, NULL, NULL, NULL, 51.0, 9.84, 31.04, NULL, NULL, NULL, 53, 36.0, 42.0, 72.0, NULL, NULL, NULL),
('97204b72-e80c-4593-afea-144a3fe4d61e', 138, 'Azmatullah Omarzai', 'Punjab Kings', 'Bowling Allrounder', 'AR', 'AR', 'C', 58, 'OVERSEAS', 'Afghan', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/13214/azmatullah-omarzai', 16.0, 99.0, NULL, NULL, 12.0, NULL, NULL, NULL, NULL, NULL, 38, NULL, NULL, NULL, 31.0, 25.0, 25.0),
('f2368fdd-a66a-41f3-8b85-f455636ee351', 143, 'Prashant Solanki', 'Kolkata Knight Riders', 'Bowler', 'BOWL', 'BOWL', 'C', 57, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/12805/prashant-solanki', 2.0, NULL, NULL, NULL, 2.0, 6.33, 19.0, NULL, NULL, NULL, 31, 5.0, 99.0, 97.0, NULL, NULL, NULL),
('9aad95f5-ec38-44f7-b6d5-e004fa994533', 99, 'Yash Dayal', 'Royal Challengers Bengaluru', 'Bowler', 'BOWL', 'BOWL', 'C', 66, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/14172/yash-dayal', 43.0, NULL, NULL, NULL, 41.0, 9.58, 33.9, NULL, NULL, NULL, 51, 30.0, 46.0, 66.0, NULL, NULL, NULL),
('305aa14d-30e0-4736-8f70-d4be9441b349', 25, 'Marcus Stoinis', 'Punjab Kings', 'Batting Allrounder', 'AR', 'AR', 'B', 83, 'OVERSEAS', 'Australian', 1, false, NULL, NULL, 4, 'https://www.cricbuzz.com/profiles/8989/marcus-stoinis', 109.0, 2026.0, NULL, NULL, 44.0, NULL, NULL, NULL, NULL, NULL, 84, NULL, NULL, NULL, 90.0, 37.0, 37.0),
('052c0fc8-3149-42d6-8d2c-13dc3b008ee2', 18, 'Rashid Khan', 'Gujarat Titans', 'Bowling Allrounder', 'AR', 'AR', 'A', 89, 'OVERSEAS', 'Afghan', 2, false, NULL, NULL, 8, 'https://www.cricbuzz.com/profiles/10738/rashid-khan', 136.0, 585.0, NULL, NULL, 158.0, NULL, NULL, NULL, NULL, NULL, 98, NULL, NULL, NULL, 51.0, 82.0, 51.0),
('72f04f4f-396a-491d-95b3-3475c242faae', 110, 'Josh Inglis', 'Lucknow Super Giants', 'WK-Batsman', 'WK', 'BAT_WK', 'C', 63, 'OVERSEAS', 'Australian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/10637/josh-inglis', 11.0, 278.0, 162.58, 30.89, NULL, NULL, NULL, 9.0, 87.0, 77.0, 35, NULL, NULL, NULL, NULL, NULL, NULL),
('8da97457-84f4-4806-a7cd-96f40cf8a199', 34, 'Quinton de Kock', 'Mumbai Indians', 'WK-Batsman', 'WK', 'BAT_WK', 'B', 79, 'OVERSEAS', 'South African', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/8520/quinton-de-kock', 115.0, 3309.0, 134.03, 30.64, NULL, NULL, NULL, 64.0, 67.0, 76.0, 87, NULL, NULL, NULL, NULL, NULL, NULL),
('02f25cf4-b223-4574-b7d9-5b0391e4fd40', 33, 'Ishant Sharma', 'Gujarat Titans', 'Bowler', 'BOWL', 'BOWL', 'B', 79, 'INDIAN', 'Indian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/702/ishant-sharma', 117.0, NULL, NULL, NULL, 96.0, 8.38, 35.18, NULL, NULL, NULL, 88, 65.0, 66.0, 63.0, NULL, NULL, NULL),
('43c67788-b9d0-4ee5-b515-47aa8a06aee7', 126, 'Nathan Ellis', 'Chennai Super Kings', 'Bowler', 'BOWL', 'BOWL', 'C', 61, 'OVERSEAS', 'Australian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/15480/nathan-ellis', 17.0, NULL, NULL, NULL, 19.0, 8.67, 28.74, NULL, NULL, NULL, 38, 16.0, 61.0, 77.0, NULL, NULL, NULL),
('57bb85ae-495e-4d5c-9ee8-7bfa9d0d16d6', 112, 'Nitish Kumar Reddy', 'Sunrisers Hyderabad', 'Batting Allrounder', 'AR', 'AR', 'C', 62, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/14701/nitish-kumar-reddy', 28.0, 485.0, NULL, NULL, 5.0, NULL, NULL, NULL, NULL, NULL, 44, NULL, NULL, NULL, 50.0, 14.0, 14.0),
('e9fa7141-cae8-4415-bba6-baa89a0345cb', 117, 'Dewald Brevis', 'Chennai Super Kings', 'Batsman', 'BAT', 'BAT_WK', 'C', 62, 'OVERSEAS', 'South African', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/20538/dewald-brevis', 16.0, 455.0, 153.2, 28.44, NULL, NULL, NULL, 12.0, 80.0, 71.0, 38, NULL, NULL, NULL, NULL, NULL, NULL),
('6359c97e-f3a4-44e6-b00a-0e327c0dddf6', 81, 'Harpreet Brar', 'Punjab Kings', 'Bowler', 'BOWL', 'BOWL', 'C', 68, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/14452/harpreet-brar', 49.0, NULL, NULL, NULL, 35.0, 8.03, 31.0, NULL, NULL, NULL, 54, 26.0, 71.0, 72.0, NULL, NULL, NULL),
('1a620dda-f1c3-4c69-b7f8-ed416424f3e3', 156, 'Matthew Short', 'Chennai Super Kings', 'Batsman', 'BAT', 'BAT_WK', 'C', 55, 'OVERSEAS', 'Australian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/9456/matthew-short', 6.0, 117.0, 127.18, 19.5, NULL, NULL, NULL, 6.0, 63.0, 49.0, 33, NULL, NULL, NULL, NULL, NULL, NULL),
('2cf1a2e3-92fc-4080-9b28-857f6b629b0f', 98, 'Shivam Mavi', 'Sunrisers Hyderabad', 'Bowler', 'BOWL', 'BOWL', 'C', 66, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/12345/shivam-mavi', 32.0, NULL, NULL, NULL, 30.0, 8.71, 31.4, NULL, NULL, NULL, 46, 23.0, 60.0, 71.0, NULL, NULL, NULL),
('bdf8f9f8-f5b5-4fb6-9d9a-70294ec259ba', 130, 'Sameer Rizvi', 'Delhi Capitals', 'Batsman', 'BAT', 'BAT_WK', 'C', 60, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/14700/sameer-rizvi', 13.0, 172.0, 140.99, 24.57, NULL, NULL, NULL, 7.0, 72.0, 61.0, 36, NULL, NULL, NULL, NULL, NULL, NULL),
('26815ecc-d69c-4712-8f13-9c78bdacc75f', 75, 'Karun Nair', 'Delhi Capitals', 'Batsman', 'BAT', 'BAT_WK', 'B', 70, 'INDIAN', 'Indian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/8257/karun-nair', 84.0, 1694.0, 131.73, 23.86, NULL, NULL, NULL, 35.0, 66.0, 60.0, 72, NULL, NULL, NULL, NULL, NULL, NULL),
('f3348329-d5f7-4576-9de4-c0ab1a4bf672', 115, 'Rachin Ravindra', 'Kolkata Knight Riders', 'Batting Allrounder', 'AR', 'AR', 'C', 62, 'OVERSEAS', 'New Zealander', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/11177/rachin-ravindra', 18.0, 413.0, NULL, NULL, 0.0, NULL, NULL, NULL, NULL, NULL, 39, NULL, NULL, NULL, 49.0, 29.0, 29.0),
('07fe9994-3ff8-4504-bcb9-18ca4e724dce', 157, 'Manimaran Siddharth', 'Lucknow Super Giants', 'Bowler', 'BOWL', 'BOWL', 'C', 55, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/12930/manimaran-siddharth', 5.0, NULL, NULL, NULL, 3.0, 8.63, 46.0, NULL, NULL, NULL, 32, 5.0, 62.0, 40.0, NULL, NULL, NULL),
('86e091a8-33ec-4684-b16c-d21004d8091b', 22, 'Kagiso Rabada', 'Gujarat Titans', 'Bowler', 'BOWL', 'BOWL', 'A', 85, 'OVERSEAS', 'South African', 2, false, NULL, NULL, 2, 'https://www.cricbuzz.com/profiles/9585/kagiso-rabada', 84.0, NULL, NULL, NULL, 119.0, 8.62, 22.96, NULL, NULL, NULL, 72, 80.0, 62.0, 89.0, NULL, NULL, NULL),
('34f31397-aa94-4197-97af-f10994d615df', 23, 'Shubman Gill', 'Gujarat Titans', 'Batsman', 'BAT', 'BAT_WK', 'B', 84, 'INDIAN', 'Indian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/11808/shubman-gill', 118.0, 3866.0, 138.72, 39.45, NULL, NULL, NULL, 74.0, 70.0, 98.0, 89, NULL, NULL, NULL, NULL, NULL, NULL),
('8433cb28-028a-44ec-a839-96ddbc3b4a9d', 106, 'Sarfaraz Khan', 'Chennai Super Kings', 'Batsman', 'BAT', 'BAT_WK', 'C', 64, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/9429/sarfaraz-khan', 50.0, 585.0, 130.59, 22.5, NULL, NULL, NULL, 15.0, 65.0, 56.0, 55, NULL, NULL, NULL, NULL, NULL, NULL),
('6ce1be33-908e-41e9-a3a9-e0e95087356a', 149, 'Glenn Phillips', 'Gujarat Titans', 'Batting Allrounder', 'AR', 'AR', 'C', 56, 'OVERSEAS', 'New Zealander', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/10693/glenn-phillips', 8.0, 65.0, NULL, NULL, 2.0, NULL, NULL, NULL, NULL, NULL, 34, NULL, NULL, NULL, 24.0, 34.0, 24.0),
('8bebc36c-09c1-4600-a43d-aaecc7644843', 37, 'Ishan Kishan', 'Sunrisers Hyderabad', 'WK-Batsman', 'WK', 'BAT_WK', 'B', 78, 'INDIAN', 'Indian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/10276/ishan-kishan', 119.0, 2998.0, 137.65, 29.11, NULL, NULL, NULL, 58.0, 70.0, 72.0, 89, NULL, NULL, NULL, NULL, NULL, NULL),
('14cbb186-7738-4a9e-b7a6-471b0dbb7c0d', 121, 'Suyash Sharma', 'Royal Challengers Bengaluru', 'Bowler', 'BOWL', 'BOWL', 'C', 61, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/36487/suyash-sharma', 27.0, NULL, NULL, NULL, 18.0, 8.75, 45.22, NULL, NULL, NULL, 43, 15.0, 60.0, 41.0, NULL, NULL, NULL),
('e9915a98-f907-4d36-a727-1078e58177b0', 136, 'Arshad Khan', 'Gujarat Titans', 'Bowling Allrounder', 'AR', 'AR', 'C', 58, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/18637/arshad-khan', 19.0, 124.0, NULL, NULL, 12.0, NULL, NULL, NULL, NULL, NULL, 39, NULL, NULL, NULL, 39.0, 18.0, 18.0),
('f53f7b5e-a152-4506-8ca8-9c6f65dd9e5b', 88, 'Harshit Rana', 'Kolkata Knight Riders', 'Bowler', 'BOWL', 'BOWL', 'C', 67, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/24729/harshit-rana', 33.0, NULL, NULL, NULL, 40.0, 9.51, 25.73, NULL, NULL, NULL, 46, 29.0, 47.0, 83.0, NULL, NULL, NULL),
('8fe5e033-0553-4f41-a4c2-c01eef01d568', 27, 'Shreyas Iyer', 'Punjab Kings', 'Batsman', 'BAT', 'BAT_WK', 'B', 83, 'INDIAN', 'Indian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/9428/shreyas-iyer', 132.0, 3731.0, 133.35, 34.23, NULL, NULL, NULL, 72.0, 67.0, 85.0, 96, NULL, NULL, NULL, NULL, NULL, NULL),
('571c5904-08b1-4fdb-a293-01ba248e7b9d', 26, 'Jaydev Unadkat', 'Sunrisers Hyderabad', 'Bowler', 'BOWL', 'BOWL', 'B', 83, 'INDIAN', 'Indian', 1, false, NULL, NULL, 2, 'https://www.cricbuzz.com/profiles/6327/jaydev-unadkat', 112.0, NULL, NULL, NULL, 110.0, 8.88, 30.58, NULL, NULL, NULL, 86, 74.0, 58.0, 73.0, NULL, NULL, NULL),
('64057263-0136-437f-bc64-27d1c767ade4', 133, 'Kyle Jamieson', 'Delhi Capitals', 'Bowler', 'BOWL', 'BOWL', 'C', 59, 'OVERSEAS', 'New Zealander', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/9441/kyle-jamieson', 13.0, NULL, NULL, NULL, 14.0, 9.67, 29.71, NULL, NULL, NULL, 36, 12.0, 45.0, 74.0, NULL, NULL, NULL),
('12b3d0c9-412b-4d5b-b0b1-2ce135dc6947', 5, 'Bhuvneshwar Kumar', 'Royal Challengers Bengaluru', 'Bowler', 'BOWL', 'BOWL', 'A', 98, 'INDIAN', 'Indian', 2, false, NULL, NULL, 8, 'https://www.cricbuzz.com/profiles/1726/bhuvneshwar-kumar', 190.0, NULL, NULL, NULL, 198.0, 7.69, 27.33, NULL, NULL, NULL, 99, 99.0, 77.0, 80.0, NULL, NULL, NULL),
('9e887918-f85f-491a-8bb6-ad4d64b8562b', 125, 'Vaibhav Suryavanshi', 'Rajasthan Royals', 'Batsman', 'BAT', 'BAT_WK', 'C', 61, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/51791/vaibhav-suryavanshi', 7.0, 252.0, 206.56, 36.0, NULL, NULL, NULL, 9.0, 99.0, 89.0, 33, NULL, NULL, NULL, NULL, NULL, NULL),
('cc3403f0-c791-4c24-88e5-54925a7975ed', 97, 'Ramandeep Singh', 'Kolkata Knight Riders', 'Batting Allrounder', 'AR', 'AR', 'C', 66, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/12337/ramandeep-singh', 30.0, 217.0, NULL, NULL, 6.0, NULL, NULL, NULL, NULL, NULL, 45, NULL, NULL, NULL, 46.0, 35.0, 35.0),
('496fda8d-dcaf-435e-812d-fd187b125539', 82, 'Jitesh Sharma', 'Royal Challengers Bengaluru', 'WK-Batsman', 'WK', 'BAT_WK', 'C', 68, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/10214/jitesh-sharma', 55.0, 991.0, 157.06, 25.41, NULL, NULL, NULL, 22.0, 83.0, 63.0, 57, NULL, NULL, NULL, NULL, NULL, NULL),
('96470f7e-c46a-4cf2-bcfa-d460e33f1c07', 32, 'David Miller', 'Delhi Capitals', 'Batsman', 'BAT', 'BAT_WK', 'B', 80, 'OVERSEAS', 'South African', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/6349/david-miller', 141.0, 3077.0, 138.61, 35.78, NULL, NULL, NULL, 60.0, 70.0, 89.0, 99, NULL, NULL, NULL, NULL, NULL, NULL),
('f4697d2d-b7d2-4f6e-a9dd-a9070c0b0f0a', 83, 'Jason Holder', 'Gujarat Titans', 'Bowling Allrounder', 'AR', 'AR', 'C', 68, 'OVERSEAS', 'West Indian', 0.5, false, NULL, NULL, 2, 'https://www.cricbuzz.com/profiles/8313/jason-holder', 46.0, 259.0, NULL, NULL, 53.0, NULL, NULL, NULL, NULL, NULL, 53, NULL, NULL, NULL, 32.0, 45.0, 32.0),
('61011f1a-0036-4345-b730-02d92b0b5651', 70, 'Venkatesh Iyer', 'Royal Challengers Bengaluru', 'Batting Allrounder', 'AR', 'AR', 'B', 70, 'INDIAN', 'Indian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/10917/venkatesh-iyer', 61.0, 1468.0, NULL, NULL, 3.0, NULL, NULL, NULL, NULL, NULL, 60, NULL, NULL, NULL, 77.0, 16.0, 16.0),
('08e96dc0-3d30-4c27-ad7c-12da636b580e', 104, 'Lungi Ngidi', 'Delhi Capitals', 'Bowler', 'BOWL', 'BOWL', 'C', 64, 'OVERSEAS', 'South African', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/9603/lungi-ngidi', 16.0, NULL, NULL, NULL, 29.0, 8.53, 18.24, NULL, NULL, NULL, 38, 22.0, 63.0, 99.0, NULL, NULL, NULL),
('c7a49a2a-8740-48bb-bdd9-f510c6e95623', 80, 'Lockie Ferguson', 'Punjab Kings', 'Bowler', 'BOWL', 'BOWL', 'C', 69, 'OVERSEAS', 'New Zealander', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/10692/lockie-ferguson', 49.0, NULL, NULL, NULL, 51.0, 8.97, 30.0, NULL, NULL, NULL, 54, 36.0, 56.0, 74.0, NULL, NULL, NULL),
('0e6888ce-019a-48c6-99ca-974019f4a087', 52, 'Rahul Tripathi', 'Kolkata Knight Riders', 'Batsman', 'BAT', 'BAT_WK', 'B', 74, 'INDIAN', 'Indian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/9012/rahul-tripathi', 100.0, 2291.0, 137.85, 26.03, NULL, NULL, NULL, 46.0, 70.0, 65.0, 80, NULL, NULL, NULL, NULL, NULL, NULL),
('e7ccffd0-5a8e-4701-a53b-613959a069e3', 12, 'Trent Boult', 'Mumbai Indians', 'Bowler', 'BOWL', 'BOWL', 'A', 92, 'OVERSEAS', 'New Zealander', 2, false, NULL, NULL, 4, 'https://www.cricbuzz.com/profiles/8117/trent-boult', 119.0, NULL, NULL, NULL, 143.0, 8.38, 26.2, NULL, NULL, NULL, 89, 96.0, 66.0, 82.0, NULL, NULL, NULL),
('218b279b-f460-4838-a973-91903f89f1e4', 127, 'Digvesh Singh Rathi', 'Lucknow Super Giants', 'Bowler', 'BOWL', 'BOWL', 'C', 61, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/1448289/digvesh-singh-rathi', 13.0, NULL, NULL, NULL, 14.0, 8.25, 30.64, NULL, NULL, NULL, 36, 12.0, 68.0, 72.0, NULL, NULL, NULL),
('88f49148-dc08-4de6-8024-216f1063bf38', 144, 'Vijaykumar Vyshak', 'Punjab Kings', 'Bowler', 'BOWL', 'BOWL', 'C', 57, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/10486/vijaykumar-vyshak', 16.0, NULL, NULL, NULL, 17.0, 10.38, 33.88, NULL, NULL, NULL, 38, 14.0, 33.0, 66.0, NULL, NULL, NULL),
('8bbf3d00-eceb-4332-aee8-f072c86b4ca7', 152, 'Anukul Roy', 'Kolkata Knight Riders', 'Batting Allrounder', 'AR', 'AR', 'C', 56, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/12344/anukul-roy', 11.0, 26.0, NULL, NULL, 6.0, NULL, NULL, NULL, NULL, NULL, 35, NULL, NULL, NULL, 17.0, 29.0, 17.0),
('b5ab0512-0702-4f41-b11d-1ed38ded1ae9', 141, 'Eshan Malinga', 'Sunrisers Hyderabad', 'Bowler', 'BOWL', 'BOWL', 'C', 58, 'OVERSEAS', 'Sri Lankan', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/46926/eshan-malinga', 7.0, NULL, NULL, NULL, 13.0, 8.93, 18.31, NULL, NULL, NULL, 33, 12.0, 57.0, 99.0, NULL, NULL, NULL),
('6a95b9b9-c132-4f70-af43-0c8b08f4b6ca', 9, 'KL Rahul', 'Delhi Capitals', 'WK-Batsman', 'WK', 'BAT_WK', 'A', 95, 'INDIAN', 'Indian', 2, false, NULL, NULL, 4, 'https://www.cricbuzz.com/profiles/8733/kl-rahul', 145.0, 5222.0, 136.03, 46.21, NULL, NULL, NULL, 99.0, 69.0, 99.0, 99, NULL, NULL, NULL, NULL, NULL, NULL),
('9fd66f31-039f-4b67-98c0-861cd8c0c9e2', 44, 'Khaleel Ahmed', 'Chennai Super Kings', 'Bowler', 'BOWL', 'BOWL', 'B', 77, 'INDIAN', 'Indian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/10952/khaleel-ahmed', 71.0, NULL, NULL, NULL, 89.0, 8.98, 26.16, NULL, NULL, NULL, 65, 61.0, 56.0, 82.0, NULL, NULL, NULL),
('63a54cdf-84f4-4485-b9f1-93f03208abde', 102, 'Angkrish Raghuvanshi', 'Kolkata Knight Riders', 'Batsman', 'BAT', 'BAT_WK', 'C', 65, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/22566/angkrish-raghuvanshi', 22.0, 463.0, 144.69, 28.94, NULL, NULL, NULL, 12.0, 75.0, 72.0, 41, NULL, NULL, NULL, NULL, NULL, NULL),
('2e68449c-cfdf-4e82-adb5-58f1daa50106', 7, 'Ravindra Jadeja', 'Rajasthan Royals', 'Bowling Allrounder', 'AR', 'AR', 'A', 95, 'INDIAN', 'Indian', 2, false, NULL, NULL, 8, 'https://www.cricbuzz.com/profiles/587/ravindra-jadeja', 254.0, 3260.0, NULL, NULL, 170.0, NULL, NULL, NULL, NULL, NULL, 99, NULL, NULL, NULL, 85.0, 78.0, 78.0),
('4a0a4236-b3b1-4ef4-aea9-369ba8ae6603', 90, 'Naman Dhir', 'Mumbai Indians', 'Batsman', 'BAT', 'BAT_WK', 'C', 67, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/36139/naman-dhir', 23.0, 392.0, 180.65, 28.0, NULL, NULL, NULL, 11.0, 99.0, 70.0, 41, NULL, NULL, NULL, NULL, NULL, NULL),
('f47209d9-e4ec-4c04-899f-296a0dc67969', 53, 'Prasidh Krishna', 'Gujarat Titans', 'Bowler', 'BOWL', 'BOWL', 'B', 74, 'INDIAN', 'Indian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/10551/prasidh-krishna', 66.0, NULL, NULL, NULL, 74.0, 8.77, 29.61, NULL, NULL, NULL, 63, 51.0, 59.0, 75.0, NULL, NULL, NULL),
('c0b2b84b-c13c-4db8-b4ab-d019eeafecb3', 8, 'MS Dhoni', 'Chennai Super Kings', 'WK-Batsman', 'WK', 'BAT_WK', 'A', 95, 'INDIAN', 'Indian', 2, false, NULL, NULL, 4, 'https://www.cricbuzz.com/profiles/265/ms-dhoni', 278.0, 5439.0, 137.46, 38.3, NULL, NULL, NULL, 99.0, 70.0, 95.0, 99, NULL, NULL, NULL, NULL, NULL, NULL),
('432e09b5-3214-4614-964d-97faf3de50ff', 108, 'Rovman Powell', 'Kolkata Knight Riders', 'Batsman', 'BAT', 'BAT_WK', 'C', 63, 'OVERSEAS', 'West Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/11445/rovman-powell', 28.0, 365.0, 146.59, 18.25, NULL, NULL, NULL, 11.0, 76.0, 46.0, 44, NULL, NULL, NULL, NULL, NULL, NULL),
('13cd05b7-746b-4d19-9a3b-e286c6ce8bd5', 19, 'Hardik Pandya', 'Mumbai Indians', 'Batting Allrounder', 'AR', 'AR', 'A', 89, 'INDIAN', 'Indian', 2, false, NULL, NULL, 6, 'https://www.cricbuzz.com/profiles/9647/hardik-pandya', 152.0, 2749.0, NULL, NULL, 78.0, NULL, NULL, NULL, NULL, NULL, 99, NULL, NULL, NULL, 90.0, 50.0, 50.0),
('3ad0bde9-ac75-4551-8282-ae3d15a5b8d4', 61, 'Travis Head', 'Sunrisers Hyderabad', 'Batsman', 'BAT', 'BAT_WK', 'B', 72, 'OVERSEAS', 'Australian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/8497/travis-head', 38.0, 1146.0, 170.03, 34.73, NULL, NULL, NULL, 25.0, 92.0, 86.0, 49, NULL, NULL, NULL, NULL, NULL, NULL),
('440f8f55-dae8-4839-99cf-5adeb8dcd366', 28, 'Kuldeep Yadav', 'Delhi Capitals', 'Bowler', 'BOWL', 'BOWL', 'B', 83, 'INDIAN', 'Indian', 1, false, NULL, NULL, 2, 'https://www.cricbuzz.com/profiles/8292/kuldeep-yadav', 98.0, NULL, NULL, NULL, 102.0, 8.04, 26.95, NULL, NULL, NULL, 79, 69.0, 71.0, 80.0, NULL, NULL, NULL),
('92cb067c-6964-4d6e-be2e-d07b2e3f9f70', 128, 'Yash Thakur', 'Punjab Kings', 'Bowler', 'BOWL', 'BOWL', 'C', 61, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/12096/yash-thakur', 21.0, NULL, NULL, NULL, 25.0, 10.43, 30.8, NULL, NULL, NULL, 40, 20.0, 32.0, 72.0, NULL, NULL, NULL),
('b5642e5c-7cb0-4fd9-a804-f8f9a16cb4cf', 142, 'Kamindu Mendis', 'Sunrisers Hyderabad', 'Batting Allrounder', 'AR', 'AR', 'C', 57, 'OVERSEAS', 'Sri Lankan', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/10940/kamindu-mendis', 5.0, 92.0, NULL, NULL, 2.0, NULL, NULL, NULL, NULL, NULL, 32, NULL, NULL, NULL, 38.0, 29.0, 29.0),
('195f4084-ddaf-4412-b0b1-b229e1151085', 73, 'Tim David', 'Royal Challengers Bengaluru', 'Batsman', 'BAT', 'BAT_WK', 'B', 70, 'OVERSEAS', 'Singaporean', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/13169/tim-david', 50.0, 846.0, 173.37, 32.54, NULL, NULL, NULL, 19.0, 94.0, 81.0, 55, NULL, NULL, NULL, NULL, NULL, NULL),
('5ccf793e-ef83-4a2b-9687-51fac8e60296', 49, 'Ravi Bishnoi', 'Rajasthan Royals', 'Bowler', 'BOWL', 'BOWL', 'B', 75, 'INDIAN', 'Indian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/14659/ravi-bishnoi', 77.0, NULL, NULL, NULL, 72.0, 8.22, 31.07, NULL, NULL, NULL, 68, 50.0, 68.0, 72.0, NULL, NULL, NULL),
('998890b5-79fe-41bd-b2b8-ed22effd9bca', 21, 'Krunal Pandya', 'Royal Challengers Bengaluru', 'Batting Allrounder', 'AR', 'AR', 'A', 86, 'INDIAN', 'Indian', 2, false, NULL, NULL, 4, 'https://www.cricbuzz.com/profiles/11311/krunal-pandya', 142.0, 1748.0, NULL, NULL, 93.0, NULL, NULL, NULL, NULL, NULL, 99, NULL, NULL, NULL, 77.0, 60.0, 60.0),
('a062039a-2dd1-4aa4-b6bd-85df4ef60188', 116, 'Sherfane Rutherford', 'Mumbai Indians', 'Batting Allrounder', 'AR', 'AR', 'C', 62, 'OVERSEAS', 'West Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/13748/sherfane-rutherford', 23.0, 397.0, NULL, NULL, 1.0, NULL, NULL, NULL, NULL, NULL, 41, NULL, NULL, NULL, 48.0, 17.0, 17.0),
('c552043e-e188-47ef-85ff-91579e954867', 96, 'Vaibhav Arora', 'Kolkata Knight Riders', 'Bowler', 'BOWL', 'BOWL', 'C', 66, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/15861/vaibhav-arora', 32.0, NULL, NULL, NULL, 36.0, 9.55, 28.22, NULL, NULL, NULL, 46, 27.0, 47.0, 78.0, NULL, NULL, NULL),
('46229100-1940-4a0a-aed4-cc14756f39b8', 58, 'Riyan Parag', 'Rajasthan Royals', 'Batting Allrounder', 'AR', 'AR', 'B', 73, 'INDIAN', 'Indian', 1, false, NULL, NULL, 2, 'https://www.cricbuzz.com/profiles/12305/riyan-parag', 83.0, 1566.0, NULL, NULL, 7.0, NULL, NULL, NULL, NULL, NULL, 71, NULL, NULL, NULL, 78.0, 16.0, 16.0),
('04a021bb-030f-4374-9386-d4b36be43adb', 1, 'Virat Kohli', 'Royal Challengers Bengaluru', 'Batsman', 'BAT', 'BAT_WK', 'A', 99, 'INDIAN', 'Indian', 2, false, NULL, NULL, 10, 'https://www.cricbuzz.com/profiles/1413/virat-kohli', 267.0, 8661.0, 132.86, 39.55, NULL, NULL, NULL, 99.0, 67.0, 98.0, 99, NULL, NULL, NULL, NULL, NULL, NULL),
('50c5588c-8499-4e4a-a7f8-e910e1cb6528', 56, 'Josh Hazlewood', 'Royal Challengers Bengaluru', 'Bowler', 'BOWL', 'BOWL', 'B', 73, 'OVERSEAS', 'Australian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/6258/josh-hazlewood', 39.0, NULL, NULL, NULL, 57.0, 8.28, 20.98, NULL, NULL, NULL, 49, 40.0, 67.0, 93.0, NULL, NULL, NULL),
('285bd810-d5dd-4f80-a420-c74731a9196b', 40, 'Rahul Chahar', 'Chennai Super Kings', 'Bowler', 'BOWL', 'BOWL', 'B', 77, 'INDIAN', 'Indian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/12087/rahul-chahar', 79.0, NULL, NULL, NULL, 75.0, 7.72, 28.67, NULL, NULL, NULL, 69, 52.0, 76.0, 77.0, NULL, NULL, NULL),
('6e7172e0-a4ff-41c5-8e70-a7fbaee9dc04', 47, 'Yashasvi Jaiswal', 'Rajasthan Royals', 'Batsman', 'BAT', 'BAT_WK', 'B', 75, 'INDIAN', 'Indian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/13940/yashasvi-jaiswal', 66.0, 2166.0, 152.86, 34.38, NULL, NULL, NULL, 43.0, 80.0, 85.0, 63, NULL, NULL, NULL, NULL, NULL, NULL),
('3c646a8a-98b1-443c-8a50-eabf1a06d44d', 2, 'Yuzvendra Chahal', 'Punjab Kings', 'Bowler', 'BOWL', 'BOWL', 'A', 99, 'INDIAN', 'Indian', 2, false, NULL, NULL, 10, 'https://www.cricbuzz.com/profiles/7910/yuzvendra-chahal', 174.0, NULL, NULL, NULL, 221.0, 7.96, 22.77, NULL, NULL, NULL, 99, 99.0, 73.0, 89.0, NULL, NULL, NULL),
('9f2fdd73-1970-4cf4-ae29-a50ef87635f2', 39, 'Nicholas Pooran', 'Lucknow Super Giants', 'WK-Batsman', 'WK', 'BAT_WK', 'B', 78, 'OVERSEAS', 'West Indian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/9406/nicholas-pooran', 90.0, 2293.0, 168.98, 34.22, NULL, NULL, NULL, 46.0, 91.0, 85.0, 75, NULL, NULL, NULL, NULL, NULL, NULL),
('691e0a02-7e9a-4352-b957-2ed1fa7e2fe3', 94, 'Will Jacks', 'Mumbai Indians', 'Batting Allrounder', 'AR', 'AR', 'C', 66, 'OVERSEAS', 'English', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/12258/will-jacks', 21.0, 463.0, NULL, NULL, 8.0, NULL, NULL, NULL, NULL, NULL, 40, NULL, NULL, NULL, 55.0, 28.0, 28.0),
('f6a195c0-1fde-45aa-bf65-126fc18c1ad2', 54, 'Heinrich Klaasen', 'Sunrisers Hyderabad', 'WK-Batsman', 'WK', 'BAT_WK', 'B', 74, 'OVERSEAS', 'South African', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/10209/heinrich-klaasen', 49.0, 1480.0, 169.73, 40.0, NULL, NULL, NULL, 31.0, 91.0, 99.0, 54, NULL, NULL, NULL, NULL, NULL, NULL),
('b034ed62-2f1e-44e0-a1f7-4a5e11588757', 72, 'Aiden Markram', 'Lucknow Super Giants', 'Batsman', 'BAT', 'BAT_WK', 'B', 70, 'OVERSEAS', 'South African', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/9582/aiden-markram', 57.0, 1440.0, 135.09, 31.3, NULL, NULL, NULL, 30.0, 68.0, 78.0, 58, NULL, NULL, NULL, NULL, NULL, NULL),
('c6dbb37e-64cf-41e2-9288-f07e1cc9ac19', 15, 'Sanju Samson', 'Chennai Super Kings', 'WK-Batsman', 'WK', 'BAT_WK', 'A', 89, 'INDIAN', 'Indian', 2, false, NULL, NULL, 2, 'https://www.cricbuzz.com/profiles/8271/sanju-samson', 176.0, 4704.0, 139.05, 30.75, NULL, NULL, NULL, 89.0, 71.0, 76.0, 99, NULL, NULL, NULL, NULL, NULL, NULL),
('b7d09cd9-ab7f-47f7-a3b6-65164c2d6043', 119, 'Wanindu Hasaranga', 'Lucknow Super Giants', 'Bowling Allrounder', 'AR', 'AR', 'C', 62, 'OVERSEAS', 'Sri Lankan', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/10926/wanindu-hasaranga', 37.0, 81.0, NULL, NULL, 46.0, NULL, NULL, NULL, NULL, NULL, 48, NULL, NULL, NULL, 15.0, 45.0, 15.0),
('68315aee-47be-4583-b6a4-f5034c2b59c5', 66, 'Philip Salt', 'Royal Challengers Bengaluru', 'WK-Batsman', 'WK', 'BAT_WK', 'B', 71, 'OVERSEAS', 'English', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/10479/philip-salt', 34.0, 1056.0, 175.71, 34.06, NULL, NULL, NULL, 23.0, 95.0, 84.0, 47, NULL, NULL, NULL, NULL, NULL, NULL),
('0e6c03ba-60d1-437b-8e53-5c5b95e3c76d', 38, 'Shardul Thakur', 'Mumbai Indians', 'Bowling Allrounder', 'AR', 'AR', 'B', 78, 'INDIAN', 'Indian', 1, false, NULL, NULL, 6, 'https://www.cricbuzz.com/profiles/8683/shardul-thakur', 105.0, 325.0, NULL, NULL, 107.0, NULL, NULL, NULL, NULL, NULL, 82, NULL, NULL, NULL, 38.0, 59.0, 38.0),
('645fcdc0-2b64-45d9-b828-5cdf74fe84d0', 118, 'Aniket Verma', 'Sunrisers Hyderabad', 'Batsman', 'BAT', 'BAT_WK', 'C', 62, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/1447065/aniket-verma', 14.0, 236.0, 166.2, 26.22, NULL, NULL, NULL, 8.0, 89.0, 65.0, 37, NULL, NULL, NULL, NULL, NULL, NULL),
('48165a6c-057d-4959-8072-463b6ff394f4', 45, 'Shivam Dube', 'Chennai Super Kings', 'Batting Allrounder', 'AR', 'AR', 'B', 76, 'INDIAN', 'Indian', 1, false, NULL, NULL, 2, 'https://www.cricbuzz.com/profiles/11195/shivam-dube', 79.0, 1859.0, NULL, NULL, 5.0, NULL, NULL, NULL, NULL, NULL, 69, NULL, NULL, NULL, 88.0, 20.0, 20.0),
('64ba73e0-8d90-4357-92a7-f8ad9f15b04b', 123, 'Ayush Mhatre', 'Chennai Super Kings', 'Batsman', 'BAT', 'BAT_WK', 'C', 61, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/1431163/ayush-mhatre', 7.0, 240.0, 188.98, 34.29, NULL, NULL, NULL, 8.0, 99.0, 85.0, 33, NULL, NULL, NULL, NULL, NULL, NULL),
('e5cd7414-7381-4f09-949c-2ceeeb3fe336', 55, 'Mitchell Starc', 'Delhi Capitals', 'Bowler', 'BOWL', 'BOWL', 'B', 73, 'OVERSEAS', 'Australian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/7710/mitchell-starc', 51.0, NULL, NULL, NULL, 65.0, 8.61, 23.12, NULL, NULL, NULL, 55, 45.0, 62.0, 88.0, NULL, NULL, NULL),
('62b88203-b0e9-413e-ad39-68c02717ba99', 3, 'Jasprit Bumrah', 'Mumbai Indians', 'Bowler', 'BOWL', 'BOWL', 'A', 99, 'INDIAN', 'Indian', 2, false, NULL, NULL, 8, 'https://www.cricbuzz.com/profiles/9311/jasprit-bumrah', 145.0, NULL, NULL, NULL, 183.0, 7.25, 22.03, NULL, NULL, NULL, 99, 99.0, 84.0, 91.0, NULL, NULL, NULL),
('09625816-f51d-44c3-887a-c6550eb94403', 153, 'Urvil Patel', 'Chennai Super Kings', 'WK-Batsman', 'WK', 'BAT_WK', 'C', 56, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/13476/urvil-patel', 3.0, 68.0, 212.5, 22.67, NULL, NULL, NULL, 5.0, 99.0, 57.0, 31, NULL, NULL, NULL, NULL, NULL, NULL),
('36498285-993f-4eb8-830a-2f13c3de3756', 151, 'Dushmantha Chameera', 'Delhi Capitals', 'Bowler', 'BOWL', 'BOWL', 'C', 56, 'OVERSEAS', 'Sri Lankan', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/8393/dushmantha-chameera', 19.0, NULL, NULL, NULL, 13.0, 9.73, 46.38, NULL, NULL, NULL, 39, 12.0, 44.0, 39.0, NULL, NULL, NULL),
('0412f6fe-7eff-4801-9b98-bd8354c2933b', 14, 'Ajinkya Rahane', 'Kolkata Knight Riders', 'Batsman', 'BAT', 'BAT_WK', 'A', 91, 'INDIAN', 'Indian', 2, false, NULL, NULL, 4, 'https://www.cricbuzz.com/profiles/1447/ajinkya-rahane', 198.0, 5032.0, 125.02, 30.5, NULL, NULL, NULL, 95.0, 61.0, 76.0, 99, NULL, NULL, NULL, NULL, NULL, NULL),
('69ff79a8-6fc4-41bc-b391-3062eb79e800', 48, 'Pat Cummins', 'Sunrisers Hyderabad', 'Bowler', 'BOWL', 'BOWL', 'B', 75, 'OVERSEAS', 'Australian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/8095/pat-cummins', 72.0, NULL, NULL, NULL, 79.0, 8.81, 30.04, NULL, NULL, NULL, 66, 54.0, 59.0, 74.0, NULL, NULL, NULL),
('44f391fb-4df0-4539-b1b4-19fb8c9753c8', 20, 'Jos Buttler', 'Gujarat Titans', 'WK-Batsman', 'WK', 'BAT_WK', 'A', 88, 'OVERSEAS', 'English', 2, false, NULL, NULL, 2, 'https://www.cricbuzz.com/profiles/2258/jos-buttler', 121.0, 4120.0, 149.39, 40.0, NULL, NULL, NULL, 79.0, 78.0, 99.0, 90, NULL, NULL, NULL, NULL, NULL, NULL),
('e2cf4dda-f59e-44bc-916b-93b5ea7d4ed8', 30, 'Rishabh Pant', 'Lucknow Super Giants', 'WK-Batsman', 'WK', 'BAT_WK', 'B', 82, 'INDIAN', 'Indian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/10744/rishabh-pant', 125.0, 3553.0, 147.62, 34.16, NULL, NULL, NULL, 68.0, 76.0, 85.0, 92, NULL, NULL, NULL, NULL, NULL, NULL),
('5325341b-bc1f-496c-9bdc-6d34bc5d6e83', 91, 'Shahrukh Khan', 'Gujarat Titans', 'Batting Allrounder', 'AR', 'AR', 'C', 67, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/10226/shahrukh-khan', 55.0, 732.0, NULL, NULL, 1.0, NULL, NULL, NULL, NULL, NULL, 57, NULL, NULL, NULL, 56.0, 27.0, 27.0),
('9d2d4f9e-a449-4a65-92bf-3dd728d475ea', 76, 'Tristan Stubbs', 'Delhi Capitals', 'WK-Batsman', 'WK', 'BAT_WK', 'B', 70, 'OVERSEAS', 'South African', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/19243/tristan-stubbs', 32.0, 705.0, 163.2, 41.47, NULL, NULL, NULL, 17.0, 87.0, 99.0, 46, NULL, NULL, NULL, NULL, NULL, NULL),
('debf0d0b-3e89-4d9e-84fc-40c540153161', 74, 'Devdutt Padikkal', 'Royal Challengers Bengaluru', 'Batsman', 'BAT', 'BAT_WK', 'B', 70, 'INDIAN', 'Indian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/13088/devdutt-padikkal', 74.0, 1806.0, 126.3, 25.44, NULL, NULL, NULL, 37.0, 62.0, 64.0, 67, NULL, NULL, NULL, NULL, NULL, NULL),
('44bcee7b-1390-404d-9ae6-377a418ce589', 124, 'Shubham Dubey', 'Rajasthan Royals', 'Batsman', 'BAT', 'BAT_WK', 'C', 61, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/19328/shubham-dubey', 13.0, 139.0, 163.53, 23.17, NULL, NULL, NULL, 6.0, 87.0, 58.0, 36, NULL, NULL, NULL, NULL, NULL, NULL),
('6135fa19-360d-4f49-bc0f-52b76621f081', 113, 'Marco Jansen', 'Punjab Kings', 'Bowling Allrounder', 'AR', 'AR', 'C', 62, 'OVERSEAS', 'South African', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/14565/marco-jansen', 35.0, 141.0, NULL, NULL, 36.0, NULL, NULL, NULL, NULL, NULL, 47, NULL, NULL, NULL, 26.0, 36.0, 26.0),
('a6b53658-b973-4f4a-a727-da755d21282b', 92, 'Shashank Singh', 'Punjab Kings', 'Batting Allrounder', 'AR', 'AR', 'C', 67, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/10919/shashank-singh', 41.0, 773.0, NULL, NULL, 1.0, NULL, NULL, NULL, NULL, NULL, 50, NULL, NULL, NULL, 67.0, 14.0, 14.0),
('f2ce9d3b-6322-4a2d-b77f-be053b64c200', 65, 'Tilak Varma', 'Mumbai Indians', 'Batsman', 'BAT', 'BAT_WK', 'B', 72, 'INDIAN', 'Indian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/14504/tilak-varma', 54.0, 1499.0, 144.42, 37.48, NULL, NULL, NULL, 31.0, 74.0, 93.0, 57, NULL, NULL, NULL, NULL, NULL, NULL),
('71f72163-ba3d-4bf7-855e-b7d45052d158', 4, 'Sunil Narine', 'Kolkata Knight Riders', 'Bowling Allrounder', 'AR', 'AR', 'A', 98, 'OVERSEAS', 'West Indian', 2, false, NULL, NULL, 10, 'https://www.cricbuzz.com/profiles/2276/sunil-narine', 188.0, 1780.0, NULL, NULL, 192.0, NULL, NULL, NULL, NULL, NULL, 99, NULL, NULL, NULL, 84.0, 83.0, 83.0),
('00d43633-0372-4146-8eca-90275b673168', 159, 'Rasikh Dar Salam', 'Royal Challengers Bengaluru', 'Bowler', 'BOWL', 'BOWL', 'C', 55, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/14274/rasikh-dar-salam', 13.0, NULL, NULL, NULL, 10.0, 10.62, 40.9, NULL, NULL, NULL, 36, 10.0, 29.0, 51.0, NULL, NULL, NULL),
('cb480130-7e87-45c4-9089-77bd4664c25a', 10, 'Harshal Patel', 'Sunrisers Hyderabad', 'Bowler', 'BOWL', 'BOWL', 'A', 94, 'INDIAN', 'Indian', 2, false, NULL, NULL, 6, 'https://www.cricbuzz.com/profiles/8175/harshal-patel', 119.0, NULL, NULL, NULL, 151.0, 8.86, 23.7, NULL, NULL, NULL, 89, 99.0, 58.0, 87.0, NULL, NULL, NULL),
('e99a6098-1b32-4f8b-b9c9-a65ea3fc3228', 71, 'Matheesha Pathirana', 'Kolkata Knight Riders', 'Bowler', 'BOWL', 'BOWL', 'B', 70, 'OVERSEAS', 'Sri Lankan', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/16458/matheesha-pathirana', 32.0, NULL, NULL, NULL, 47.0, 8.68, 21.62, NULL, NULL, NULL, 46, 34.0, 61.0, 92.0, NULL, NULL, NULL),
('3e96f8c2-9e9b-4771-b758-198d423e31c1', 16, 'Suryakumar Yadav', 'Mumbai Indians', 'Batsman', 'BAT', 'BAT_WK', 'A', 89, 'INDIAN', 'Indian', 2, false, NULL, NULL, 2, 'https://www.cricbuzz.com/profiles/7915/suryakumar-yadav', 166.0, 4311.0, 148.66, 35.05, NULL, NULL, NULL, 82.0, 77.0, 87.0, 99, NULL, NULL, NULL, NULL, NULL, NULL),
('f6fb7849-7950-4695-979b-a85e5fa23088', 43, 'Abhishek Sharma', 'Sunrisers Hyderabad', 'Batting Allrounder', 'AR', 'AR', 'B', 77, 'INDIAN', 'Indian', 1, false, NULL, NULL, 2, 'https://www.cricbuzz.com/profiles/12086/abhishek-sharma', 77.0, 1815.0, NULL, NULL, 11.0, NULL, NULL, NULL, NULL, NULL, 68, NULL, NULL, NULL, 90.0, 24.0, 24.0),
('de6aa29d-253e-4dc1-b02d-e6db19647c96', 13, 'Axar Patel', 'Delhi Capitals', 'Bowling Allrounder', 'AR', 'AR', 'A', 91, 'INDIAN', 'Indian', 2, false, NULL, NULL, 6, 'https://www.cricbuzz.com/profiles/8808/axar-patel', 162.0, 1916.0, NULL, NULL, 128.0, NULL, NULL, NULL, NULL, NULL, 99, NULL, NULL, NULL, 82.0, 72.0, 72.0),
('1cea0283-991a-491b-8204-69be59c32f26', 154, 'Nuwan Thushara', 'Royal Challengers Bengaluru', 'Bowler', 'BOWL', 'BOWL', 'C', 56, 'OVERSEAS', 'Sri Lankan', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/18509/nuwan-thushara', 8.0, NULL, NULL, NULL, 9.0, 9.43, 31.44, NULL, NULL, NULL, 34, 9.0, 49.0, 71.0, NULL, NULL, NULL),
('7f8d69ca-6576-419c-bd3c-4568119c823e', 86, 'Mayank Markande', 'Mumbai Indians', 'Bowler', 'BOWL', 'BOWL', 'C', 67, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/12627/mayank-markande', 37.0, NULL, NULL, NULL, 37.0, 8.91, 28.89, NULL, NULL, NULL, 48, 27.0, 57.0, 76.0, NULL, NULL, NULL),
('63139858-d264-470b-a32a-a2f97b54d17a', 17, 'Mohammed Shami', 'Lucknow Super Giants', 'Bowler', 'BOWL', 'BOWL', 'A', 89, 'INDIAN', 'Indian', 2, false, NULL, NULL, 4, 'https://www.cricbuzz.com/profiles/7909/mohammed-shami', 119.0, NULL, NULL, NULL, 133.0, 8.63, 28.18, NULL, NULL, NULL, 89, 89.0, 62.0, 78.0, NULL, NULL, NULL);

INSERT INTO "AuctionPlayer" (id, player_id, status) VALUES
('b019ee9a-cd0f-4c53-b8ec-d4badea85329', 'c4070925-53b6-4510-9261-bdbd2b3836ee', 'UNSOLD'),
('41844745-0bf1-4ab4-af26-d7134e3b6dd4', 'a813b77d-c158-4f62-90e8-48b17a88dbf3', 'UNSOLD'),
('ea47340f-b789-4d4d-86d8-81d9c979d306', '6891425c-1d56-444a-b5b4-41428771d14f', 'UNSOLD'),
('fb13749d-618f-4ec8-9987-287ef96f96bb', '60fe67d3-8883-4ed3-b76c-fd918b01f9b3', 'UNSOLD'),
('ec4ca237-8b9d-49ae-89a0-a599db1164a4', 'd8a9a1b4-3c9e-4743-b986-35718c12b551', 'UNSOLD'),
('660facdc-a1ef-4f0b-b3dc-1b74e975addb', 'bf6828ed-825d-4749-8f2c-d9534cc1095d', 'UNSOLD'),
('4606a179-0def-43ce-b48e-7521daf3f748', '553fb779-b355-44ae-9a7b-04c54d932741', 'UNSOLD'),
('6df1ea99-d9c3-48e5-8e8f-4d42c29264b4', '573fa1d9-43bb-4656-bc9c-dda03186d450', 'UNSOLD'),
('f0f37b8f-a31e-4fbc-a2ef-d7689d0c25ee', 'f16d695b-5ceb-4d1d-a01a-f4f8a223e982', 'UNSOLD'),
('5f352a8b-b3cc-4dd9-a333-fa41ede31453', '342906c9-af9e-4e85-a647-2e3bf6c2175d', 'UNSOLD'),
('3f20c9db-8ff1-4af7-b105-a56337ed987c', '7495e484-ceab-4b8c-86ee-6b7de98581b5', 'UNSOLD'),
('c3f84723-cb77-4202-9e14-8358e190b565', '2124fa80-5452-4b46-9f2f-b916a3df6815', 'UNSOLD'),
('172846b5-374b-42b0-8d94-e42f2de0d987', 'b4066e98-08aa-4afa-942b-cc348b175ad2', 'UNSOLD'),
('569d685e-beee-4a1e-9afd-64157d8766bf', 'd6451af2-95e0-48fd-aa0b-2b7035613e47', 'UNSOLD'),
('d088e295-3a2d-42f5-a257-0d39411829b1', '37cd07bb-d457-488d-8de0-2df022497658', 'UNSOLD'),
('0c2adc26-e3c4-4c4f-a662-37bfcc178881', '37b9acec-a832-4025-bb34-51bbaea1735d', 'UNSOLD'),
('f4e8e1a0-d4ca-472c-a9d3-715d0f9e910c', '7081eb90-c6b5-46a4-bc30-97ca62d7ed67', 'UNSOLD'),
('5751db76-2a42-4acc-a9bc-2e05e0d9f9d3', '907794e3-e498-42ec-9ec4-d96f60cc8cd5', 'UNSOLD'),
('4db6c4ce-1d34-43e9-95b0-18be9369f1cb', 'f3a595af-cc6e-464d-b0a4-ba293e79279b', 'UNSOLD'),
('3e967d54-7397-467b-926a-2def2adcb0a8', 'aeb105ee-2282-44b6-b0df-e853433a9949', 'UNSOLD'),
('78b6386e-0e40-4ead-b1f3-98694022e9a6', '091930bc-dc6d-42a1-a8fb-6d014e244e13', 'UNSOLD'),
('9444d0e4-1b8f-47f6-8c0e-d3216482fa66', '91485030-fb9a-41ae-9dc9-06ba28ca7ecd', 'UNSOLD'),
('45295554-965a-4d44-a2db-40a64397ff67', '333b262e-b6bd-42d3-b766-dafd9b42b91f', 'UNSOLD'),
('172289b6-606c-46e2-b773-25bef8fbf614', '32b4ee71-d2af-4f11-9225-b04763ab983a', 'UNSOLD'),
('f662d7d3-f30b-4ba1-9afa-f02bbe1c932a', '7b39e3cf-4560-43a4-8217-e46b6df2e844', 'UNSOLD'),
('12a07495-ff22-463d-bb4c-deef945a9f37', 'e750c6b2-fa5b-45a0-9928-a567bac17480', 'UNSOLD'),
('0b7799ae-0cc1-4b06-8367-2bd99322bb11', '5a322b5f-12c7-46bb-b8bb-632122c9c58b', 'UNSOLD'),
('72a1bd29-2490-4423-8baf-c06a96a0fb53', 'ddfd073e-4913-4417-8e9f-1babc46f436f', 'UNSOLD'),
('2d25eac0-480b-494e-9b53-cd9116b43c5e', '94873c28-1afb-47cf-b876-44d89b6275f5', 'UNSOLD'),
('cfeb2b9a-1537-4355-ac5b-86459e1aed77', '33207a6e-fc8a-4481-98f2-8afaa3b6d835', 'UNSOLD'),
('939f3578-72f0-4e83-839b-7b1e880983c8', 'ccbc70dd-adf0-4857-a93b-4461d5db948f', 'UNSOLD'),
('d1c318dc-5e59-42b0-8bed-f2bbb113d18b', 'cbf5a7da-0e91-4534-a994-e632c9d9b043', 'UNSOLD'),
('1f325060-3e72-4ea2-8424-326e8837f330', 'e2399024-819c-48b0-bd71-eff4a9f58f7c', 'UNSOLD'),
('843a2b09-e6bc-4076-ae12-88a86eecf587', '9ac81fb0-9011-447e-980c-075828f66b60', 'UNSOLD'),
('fad2ebb0-1809-474e-b299-28df584b62bf', '1583e72f-2577-4753-9023-eab4c35ecb0d', 'UNSOLD'),
('2a2d8124-f9e6-41db-b8eb-c8e069b465de', 'c5fe5f02-8806-4b9c-93c2-48eefcb3b668', 'UNSOLD'),
('944d44ea-dd72-4520-87df-7051e12de372', '0f09fe47-bd49-4d38-942d-23fdffac20f1', 'UNSOLD'),
('274627ab-168e-4eda-94e4-b6554df45b64', '91a6d41b-9766-4470-8b03-e671a2c8deb9', 'UNSOLD'),
('671f8e5d-1f92-4eec-9dde-5e6d29307b5f', '401ec80f-0c44-49b3-b051-5e2326db7dce', 'UNSOLD'),
('9b0d6d26-1771-4dfb-9f5e-0d8c42c08c6b', 'c38db7c0-9de4-4f36-8f4a-6b7edd3ec170', 'UNSOLD'),
('ff3cef96-cdbc-4ceb-a685-9637712edad8', '029600cb-a159-44f6-ab3a-79d1507b1c60', 'UNSOLD'),
('6d62adcb-5570-4e66-8fff-c0b4ebfac42c', '96ec978a-b991-495e-aae0-e058ed573b9e', 'UNSOLD'),
('4effff6c-d67a-49ae-a8eb-000e14c0ef74', 'de2bb370-f8d3-460c-84bd-deab1bf02c66', 'UNSOLD'),
('fbcf76f7-427b-4609-8b1d-8cd7cb3cd339', '3483d6f9-94c6-45f3-8b2f-5d6b156e6d05', 'UNSOLD'),
('f25eeecc-d6ef-4866-8788-5dbecbeafd1e', '0cca0db8-b3ab-45de-9045-a86496af32f8', 'UNSOLD'),
('092cc12d-9b3f-408d-b5d9-93d8f26f4225', '5ac92318-19d4-4bdf-9968-15736177a68d', 'UNSOLD'),
('70d61bdb-4fb0-476e-af4d-8e3a02f3d909', '6a51f887-9169-4ea4-8987-a2354efeef30', 'UNSOLD'),
('5d340845-4328-4d03-b862-f11c2bd80eb7', 'f0611606-ad27-4692-9143-90c5021aeca7', 'UNSOLD'),
('55c3e71c-168d-4073-952a-ac9ecfea76f4', '1444aa26-2483-407d-a3d6-c2d4dc5e8ac0', 'UNSOLD'),
('87221041-1765-43d8-bad6-b4a64d35d223', 'a8847115-6c3d-443d-885d-e076119e9371', 'UNSOLD'),
('30af3224-998b-4965-9ceb-5f2366cee284', '539c62ac-2721-4ae9-a783-7141c2cfde2a', 'UNSOLD'),
('d0377a6c-d3ba-4ec7-98e6-881faca73782', 'c495b1e2-be4e-4d01-a3d0-62bd4ec8af9f', 'UNSOLD'),
('c627e3f4-1902-4575-8a4a-d779d980c051', '34fa1490-1ba7-420d-ab41-ce44d814595b', 'UNSOLD'),
('5348bc19-c9c1-4f3d-bec9-5f3fd33a9d0f', '5a129617-c2ee-4481-b974-6acbd744010e', 'UNSOLD'),
('fb9f3c2c-c00d-49a7-977c-a0882869c378', 'e6a747b0-2c35-4eac-b1d8-1848d7eaed49', 'UNSOLD'),
('fb140724-8aee-4158-a829-2d4f86aadd70', '97204b72-e80c-4593-afea-144a3fe4d61e', 'UNSOLD'),
('20899f6d-dc43-4603-9eea-9910cfadb44b', 'f2368fdd-a66a-41f3-8b85-f455636ee351', 'UNSOLD'),
('e37bc093-32bd-451a-85b1-22de71476dc0', '9aad95f5-ec38-44f7-b6d5-e004fa994533', 'UNSOLD'),
('9d6f739c-3e58-4d42-9be3-3f5a0561a9db', '305aa14d-30e0-4736-8f70-d4be9441b349', 'UNSOLD'),
('ac849095-f770-44ea-97a2-8709221c9cdd', '052c0fc8-3149-42d6-8d2c-13dc3b008ee2', 'UNSOLD'),
('e1ab1fa9-fcbc-4a44-b19a-6b0d30a3771d', '72f04f4f-396a-491d-95b3-3475c242faae', 'UNSOLD'),
('d0215bea-3cf9-4a81-99b0-e937d6f8b4a9', '8da97457-84f4-4806-a7cd-96f40cf8a199', 'UNSOLD'),
('f7e8d50d-6bdf-4225-8d45-a21555f95491', '02f25cf4-b223-4574-b7d9-5b0391e4fd40', 'UNSOLD'),
('4006f811-26d8-4703-89e8-67ba525aac55', '43c67788-b9d0-4ee5-b515-47aa8a06aee7', 'UNSOLD'),
('324b7da2-0df9-4358-909f-6f589c0f3df6', '57bb85ae-495e-4d5c-9ee8-7bfa9d0d16d6', 'UNSOLD'),
('a3b86d60-91a1-4084-89f1-a0a7df409977', 'e9fa7141-cae8-4415-bba6-baa89a0345cb', 'UNSOLD'),
('25d0e48e-630e-4225-bd6f-c95a55a3993f', '6359c97e-f3a4-44e6-b00a-0e327c0dddf6', 'UNSOLD'),
('deb8bf70-b6a1-4cc3-9e72-03fc8f1c4e43', '1a620dda-f1c3-4c69-b7f8-ed416424f3e3', 'UNSOLD'),
('4698b542-c2aa-4723-ae66-ba44c24c94d4', '2cf1a2e3-92fc-4080-9b28-857f6b629b0f', 'UNSOLD'),
('a49b977c-b974-405f-b332-ec893a3e565b', 'bdf8f9f8-f5b5-4fb6-9d9a-70294ec259ba', 'UNSOLD'),
('0e278eeb-0447-463c-b483-96ad4dacbe53', '26815ecc-d69c-4712-8f13-9c78bdacc75f', 'UNSOLD'),
('c8aef109-5cf1-49f1-8754-5f44f4776f9d', 'f3348329-d5f7-4576-9de4-c0ab1a4bf672', 'UNSOLD'),
('b224e249-2c86-45c7-9a8d-1057bd2f27b6', '07fe9994-3ff8-4504-bcb9-18ca4e724dce', 'UNSOLD'),
('4eb8ee86-6892-447d-bb2c-e6d2ac000ad6', '86e091a8-33ec-4684-b16c-d21004d8091b', 'UNSOLD'),
('9ec20f25-3a48-4ab3-a82a-b1990c62c77a', '34f31397-aa94-4197-97af-f10994d615df', 'UNSOLD'),
('84fceb5b-28aa-4be0-98da-3a00657e5631', '8433cb28-028a-44ec-a839-96ddbc3b4a9d', 'UNSOLD'),
('8d79a35b-601d-493f-84ed-69a0a3db9bd5', '6ce1be33-908e-41e9-a3a9-e0e95087356a', 'UNSOLD'),
('94cd2ab4-4637-4d77-ba26-ffe8943b3d5e', '8bebc36c-09c1-4600-a43d-aaecc7644843', 'UNSOLD'),
('77e40e89-c2a1-4549-ab0d-b5eb1e6d33c1', '14cbb186-7738-4a9e-b7a6-471b0dbb7c0d', 'UNSOLD'),
('665eac85-6e63-42b1-9d26-e2335e613a5a', 'e9915a98-f907-4d36-a727-1078e58177b0', 'UNSOLD'),
('bda61ff0-8fad-4325-bd55-e951db696175', 'f53f7b5e-a152-4506-8ca8-9c6f65dd9e5b', 'UNSOLD'),
('367f516d-3859-42ea-a5f8-fee354b2dbc4', '8fe5e033-0553-4f41-a4c2-c01eef01d568', 'UNSOLD'),
('d4e87683-b7fa-4c00-87b9-b15f07ebd687', '571c5904-08b1-4fdb-a293-01ba248e7b9d', 'UNSOLD'),
('3858b837-9059-402c-9c2b-d1ffd366a858', '64057263-0136-437f-bc64-27d1c767ade4', 'UNSOLD'),
('90d3cf06-a683-430e-9b9a-24399d38ab39', '12b3d0c9-412b-4d5b-b0b1-2ce135dc6947', 'UNSOLD'),
('2ad10153-55f4-46f1-a27a-91d1ee0f4aba', '9e887918-f85f-491a-8bb6-ad4d64b8562b', 'UNSOLD'),
('fc23fe89-f9c6-48ff-874c-2be175167b39', 'cc3403f0-c791-4c24-88e5-54925a7975ed', 'UNSOLD'),
('755c14e2-328b-4e08-8a50-1e904533392e', '496fda8d-dcaf-435e-812d-fd187b125539', 'UNSOLD'),
('426ff3c4-7792-4720-bab2-4b0ce0d9db38', '96470f7e-c46a-4cf2-bcfa-d460e33f1c07', 'UNSOLD'),
('3eee0d86-feeb-4fc8-a9fd-a8efa3783944', 'f4697d2d-b7d2-4f6e-a9dd-a9070c0b0f0a', 'UNSOLD'),
('29e88cbb-dff7-4f9a-ad05-7b3827ea1f20', '61011f1a-0036-4345-b730-02d92b0b5651', 'UNSOLD'),
('46879932-ef86-40d3-841f-04a9fdeefa0e', '08e96dc0-3d30-4c27-ad7c-12da636b580e', 'UNSOLD'),
('1698a565-c422-46eb-8c2b-9d06e5da817c', 'c7a49a2a-8740-48bb-bdd9-f510c6e95623', 'UNSOLD'),
('f320dbe7-80e4-4a1c-8c75-a64156d34fcb', '0e6888ce-019a-48c6-99ca-974019f4a087', 'UNSOLD'),
('45bea19a-856b-4bab-9938-a81dab99dfd1', 'e7ccffd0-5a8e-4701-a53b-613959a069e3', 'UNSOLD'),
('84772325-9a26-4efd-8db8-36c091bb91d0', '218b279b-f460-4838-a973-91903f89f1e4', 'UNSOLD'),
('3177f157-2bad-4321-81b0-57599d3c3176', '88f49148-dc08-4de6-8024-216f1063bf38', 'UNSOLD'),
('fa7b3417-5ecf-4c3d-abb8-6e135249c69f', '8bbf3d00-eceb-4332-aee8-f072c86b4ca7', 'UNSOLD'),
('c4d1ba06-7535-4b0b-886e-898b078ea8a4', 'b5ab0512-0702-4f41-b11d-1ed38ded1ae9', 'UNSOLD'),
('b23ac6fd-24df-43e2-8980-4adc45d81028', '6a95b9b9-c132-4f70-af43-0c8b08f4b6ca', 'UNSOLD'),
('77b60908-fa56-49bf-b22a-ec022b143d07', '9fd66f31-039f-4b67-98c0-861cd8c0c9e2', 'UNSOLD'),
('b13a01bd-1c03-4358-8f85-6a03f01f5722', '63a54cdf-84f4-4485-b9f1-93f03208abde', 'UNSOLD'),
('e7949c7b-25cf-45ed-8506-c6fd3bbf2fed', '2e68449c-cfdf-4e82-adb5-58f1daa50106', 'UNSOLD'),
('dc6d4f6c-5c60-457f-9618-f544261f2b81', '4a0a4236-b3b1-4ef4-aea9-369ba8ae6603', 'UNSOLD'),
('44585878-a437-4463-8dba-dd7eaf55bf50', 'f47209d9-e4ec-4c04-899f-296a0dc67969', 'UNSOLD'),
('bc7b97a4-acdf-40e2-a98e-f9fd62f480d9', 'c0b2b84b-c13c-4db8-b4ab-d019eeafecb3', 'UNSOLD'),
('402aeea4-0368-449a-80a2-b9182e6ae53d', '432e09b5-3214-4614-964d-97faf3de50ff', 'UNSOLD'),
('6a8d4fd2-6795-40f8-9321-350cebe741f2', '13cd05b7-746b-4d19-9a3b-e286c6ce8bd5', 'UNSOLD'),
('595537cf-5306-45ab-88c5-13bba8b95480', '3ad0bde9-ac75-4551-8282-ae3d15a5b8d4', 'UNSOLD'),
('b78fe926-9cb2-43c4-81d1-77db052b08d3', '440f8f55-dae8-4839-99cf-5adeb8dcd366', 'UNSOLD'),
('ee40cbb1-8fb3-4e8d-bfef-6dfc4b8e3791', '92cb067c-6964-4d6e-be2e-d07b2e3f9f70', 'UNSOLD'),
('f7ca9a5f-b859-4984-b201-61b34c65f6d0', 'b5642e5c-7cb0-4fd9-a804-f8f9a16cb4cf', 'UNSOLD'),
('a445b624-5048-4a3b-a164-9a4e03171dd5', '195f4084-ddaf-4412-b0b1-b229e1151085', 'UNSOLD'),
('5409b56e-d3e5-4f5c-9316-ad79bfb5fe1d', '5ccf793e-ef83-4a2b-9687-51fac8e60296', 'UNSOLD'),
('2228e72f-aa90-4d80-b952-a42bccf260ce', '998890b5-79fe-41bd-b2b8-ed22effd9bca', 'UNSOLD'),
('648c3784-db9a-49d5-93a4-0b3eb9bda65d', 'a062039a-2dd1-4aa4-b6bd-85df4ef60188', 'UNSOLD'),
('16c2d6d3-cc6b-4b32-83a4-005a07b35538', 'c552043e-e188-47ef-85ff-91579e954867', 'UNSOLD'),
('7ddfc3ad-7153-4d87-afb8-9d5d60c4aebb', '46229100-1940-4a0a-aed4-cc14756f39b8', 'UNSOLD'),
('b91d808a-7e47-4cc1-b54d-2c30c545f8ff', '04a021bb-030f-4374-9386-d4b36be43adb', 'UNSOLD'),
('375b3323-ec92-452b-a041-095345e2f9eb', '50c5588c-8499-4e4a-a7f8-e910e1cb6528', 'UNSOLD'),
('ea279b47-17c1-4a0e-8bc1-91bf1efa6375', '285bd810-d5dd-4f80-a420-c74731a9196b', 'UNSOLD'),
('6ee4259b-b662-4088-8f43-f5d31d02a080', '6e7172e0-a4ff-41c5-8e70-a7fbaee9dc04', 'UNSOLD'),
('9b653d79-399d-4556-8705-9a73844f62a5', '3c646a8a-98b1-443c-8a50-eabf1a06d44d', 'UNSOLD'),
('7574d104-3d12-487c-a58d-d544a50b362c', '9f2fdd73-1970-4cf4-ae29-a50ef87635f2', 'UNSOLD'),
('642bb0f2-0b8c-4a8e-ab20-63b5429bc201', '691e0a02-7e9a-4352-b957-2ed1fa7e2fe3', 'UNSOLD'),
('299981d9-3999-47df-9f42-ba22b7a0404f', 'f6a195c0-1fde-45aa-bf65-126fc18c1ad2', 'UNSOLD'),
('b1ef12e5-c208-492b-93c1-3dd9cd3b34cf', 'b034ed62-2f1e-44e0-a1f7-4a5e11588757', 'UNSOLD'),
('830bb513-ccc3-448e-bde6-db0405833209', 'c6dbb37e-64cf-41e2-9288-f07e1cc9ac19', 'UNSOLD'),
('98f04803-540c-4d93-8684-253272b02128', 'b7d09cd9-ab7f-47f7-a3b6-65164c2d6043', 'UNSOLD'),
('ecde2164-348a-4e1b-ab91-0b52ab9ad9dd', '68315aee-47be-4583-b6a4-f5034c2b59c5', 'UNSOLD'),
('93527e29-3344-458b-ab0a-ff1add0154d0', '0e6c03ba-60d1-437b-8e53-5c5b95e3c76d', 'UNSOLD'),
('e42bbe42-3c5b-4d0d-be0a-73ee684d2331', '645fcdc0-2b64-45d9-b828-5cdf74fe84d0', 'UNSOLD'),
('6a439ab2-23de-4536-82b4-812bfecba1c2', '48165a6c-057d-4959-8072-463b6ff394f4', 'UNSOLD'),
('c6241784-48a6-4e17-904a-ce6d0b1e3abf', '64ba73e0-8d90-4357-92a7-f8ad9f15b04b', 'UNSOLD'),
('5ad0c1aa-f664-45f9-badb-5a59af539430', 'e5cd7414-7381-4f09-949c-2ceeeb3fe336', 'UNSOLD'),
('4ba2f4df-4729-4246-9a45-b0fcea2e99e3', '62b88203-b0e9-413e-ad39-68c02717ba99', 'UNSOLD'),
('7b5efa0a-3cf7-4fea-b79e-8820ba645a05', '09625816-f51d-44c3-887a-c6550eb94403', 'UNSOLD'),
('64439f6c-140d-40ea-afda-a9917d80e186', '36498285-993f-4eb8-830a-2f13c3de3756', 'UNSOLD'),
('dec3d93e-b356-496e-93d6-9827b97c5b07', '0412f6fe-7eff-4801-9b98-bd8354c2933b', 'UNSOLD'),
('451581d4-b08a-45e5-9bed-669fd62253dc', '69ff79a8-6fc4-41bc-b391-3062eb79e800', 'UNSOLD'),
('02501495-7bf3-4c75-a62a-7315272d8c1d', '44f391fb-4df0-4539-b1b4-19fb8c9753c8', 'UNSOLD'),
('f12113ad-bd59-439f-a483-419489a3d371', 'e2cf4dda-f59e-44bc-916b-93b5ea7d4ed8', 'UNSOLD'),
('789828bc-305c-4286-b622-66ee279ac236', '5325341b-bc1f-496c-9bdc-6d34bc5d6e83', 'UNSOLD'),
('26514bc7-4ee5-4169-bfed-0f0a73ffea52', '9d2d4f9e-a449-4a65-92bf-3dd728d475ea', 'UNSOLD'),
('29adf670-0a79-43c5-a238-741b95188789', 'debf0d0b-3e89-4d9e-84fc-40c540153161', 'UNSOLD'),
('0d0480bd-3b45-42dd-90e2-c54576c83ca7', '44bcee7b-1390-404d-9ae6-377a418ce589', 'UNSOLD'),
('c354dc18-e221-4fb4-b02d-2c64cd99a56e', '6135fa19-360d-4f49-bc0f-52b76621f081', 'UNSOLD'),
('0791fe34-3fd8-4e0d-a0e5-2f0788c23e86', 'a6b53658-b973-4f4a-a727-da755d21282b', 'UNSOLD'),
('d6798af8-93a8-426d-89c9-793c6e4a84c6', 'f2ce9d3b-6322-4a2d-b77f-be053b64c200', 'UNSOLD'),
('a670b788-c8e0-4a00-9c3f-4cc0fc07c983', '71f72163-ba3d-4bf7-855e-b7d45052d158', 'UNSOLD'),
('aab9d7af-9eb9-41bc-904f-f2a6482a17c8', '00d43633-0372-4146-8eca-90275b673168', 'UNSOLD'),
('8efb15f3-8dd7-43bd-bc62-08ae8452ee61', 'cb480130-7e87-45c4-9089-77bd4664c25a', 'UNSOLD'),
('832ebeb0-1d9a-482f-9d43-7aabe1a96079', 'e99a6098-1b32-4f8b-b9c9-a65ea3fc3228', 'UNSOLD'),
('be6d612b-62bc-44c0-8ae2-8ea7e9d49138', '3e96f8c2-9e9b-4771-b758-198d423e31c1', 'UNSOLD'),
('f25078ae-3f0f-4dc9-ab1b-03dd667a5a0e', 'f6fb7849-7950-4695-979b-a85e5fa23088', 'UNSOLD'),
('8858c4c4-96bc-46fc-a88e-fac40c17fa8c', 'de6aa29d-253e-4dc1-b02d-e6db19647c96', 'UNSOLD'),
('0e0245bd-ca98-4c92-a5a6-56364a3bb929', '1cea0283-991a-491b-8204-69be59c32f26', 'UNSOLD'),
('f948598c-77a0-4415-b0ee-489f7dd18364', '7f8d69ca-6576-419c-bd3c-4568119c823e', 'UNSOLD'),
('e5dd81e5-a9c8-4074-8b07-b1305c04668c', '63139858-d264-470b-a32a-a2f97b54d17a', 'UNSOLD');

INSERT INTO "AdminUser" (id, username, password_hash, role) VALUES
('86c10afc-b79a-404c-baea-e47e662460b0', 'admin', '$2b$10$I1ebJauKGudjJpuwxBIm7eaLpfIChQ0DteRBp4AK3oA/G/rJ7AEV6', 'ADMIN'),
('50d6376f-f392-4720-8dbf-9e19a9b7d6ca', 'screen', '$2b$10$o9nhhsoYUfIHPVdGHLYB4uNYQbZJItRmiC/7g3uB9Xm1YWb2XD1eW', 'SCREEN');

INSERT INTO "AuctionSequence" (id, name, type, sequence_items) VALUES
(1, 'Franchise Auction', 'FRANCHISE', '[3,7,1,9,5,10,2,6,8,4]');

INSERT INTO "AuctionSequence" (id, name, type, sequence_items) VALUES
(2, 'Power Card Auction', 'POWER_CARD', '["GOD_EYE","MULLIGAN","FINAL_STRIKE","BID_FREEZER"]');

INSERT INTO "AuctionSequence" (id, name, type, sequence_items) VALUES
(3, 'Player Auction 8', 'PLAYER', '[89,35,122,120,77,147,107,50,132,100,46,68,95,114,63,51,78,42,105,67,148,158,129,60,135,69,84,11,93,64,140,101,29,57,41,155,134,59,31,79,150,109,6,145,139,111,85,24,103,137,36,146,62,131,87,138,143,99,25,18,110,34,33,126,112,117,81,156,98,130,75,115,157,22,23,106,149,37,121,136,88,27,26,133,5,125,97,82,32,83,70,104,80,52,12,127,144,152,141,9,44,102,7,90,53,8,108,19,61,28,128,142,73,49,21,116,96,58,1,56,40,47,2,39,94,54,72,15,119,66,38,118,45,123,55,3,153,151,14,48,20,30,91,76,74,124,113,92,65,4,159,10,71,16,43,13,154,86,17]');

INSERT INTO "AuctionState" (id, phase, auction_day) VALUES (1, 'NOT_STARTED', 'Day 2');

