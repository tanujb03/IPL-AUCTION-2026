-- INSTANCE 4 INITIALIZATION
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



-- ── DATA FOR INSTANCE 4 ──

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
('88bdad29-ddb0-42c6-9ceb-f43ac6774625', 'Bid Masters X1', 'bidmastersx1', '$2b$10$boWG01yKxmTuiDbc/3w1PeEAzg/bIDaGIYtxIocnHbpDp642LHMNy', 120, 0),
('b14f8860-3a2c-40d4-9ee6-1ebe7b62a84b', 'Royal Paltans', 'royalpaltans', '$2b$10$ECuhxF0w47xcB4hVKkHfseof/JnQOUOnr0ncKzfW3Au74NjnOGMce', 120, 0),
('f8faf9c0-e095-4592-b740-384f4029ebcf', 'VISTAR X1', 'vistarx1', '$2b$10$LFvw18Uj4Y8iKxGJlA1axeSC11aMXM5Z1qZKUgcpDnMOSxviMMIO2', 120, 0),
('6c68f19b-570e-48e9-bbcf-c4aa6c7dea90', 'Elite Elevens', 'eliteelevens', '$2b$10$lQgLShw8NUjoNEVx.UASh.XA8HAvW5O95FpbPrzoRasATMb4C2F9O', 120, 0),
('1f3a4f01-3e63-4677-9aa9-201568989783', 'Mr Nags', 'mrnags', '$2b$10$7RJkntAp8PwaUAnhCA9AXOekx2pHZUTzV2LusdtEtJCCBCNINt2F6', 120, 0),
('8df778c2-7eb8-4359-b9c9-48f0ade5751f', '50 Shades of Strategy', '50shadesofstrategy', '$2b$10$/B9uEOyJfwGz83F3kyzwIOgFAs1Da1cQl6/OniEyX6zrF/yr1prpm', 120, 0),
('7b978f78-7969-4bd6-96c6-4548fa91fb21', 'Yash Kate', 'yashkate', '$2b$10$rJGQ8LutuZ9hl5ycCmigT.rOU8pyH0FfnUV7QxOvwRxu92RJTIn9O', 120, 0),
('0b8f1bf2-c45b-4185-9428-c7761cea6135', 'The Dominators', 'thedominators', '$2b$10$curkXK3HWRXbzgCiOwzOPOHxECiY5VXyLHoCDd46N1oalEO6ggSre', 120, 0),
('83f99152-0510-449b-923c-31f7a48970c7', 'Achievers', 'achievers', '$2b$10$J3bqh1IIuJxnMpIkMZ3W6OhBG2rl/3H/HCG9u4AZ.Wwxkyipb1dFC', 120, 0),
('7c9e41c8-5f84-4f4a-b1eb-7fddb72913f0', 'Harsh', 'harsh', '$2b$10$eq7cQLOCIZa7Jhga9UhHyOrQ.Kw//d52mSoO2Z4B.3U6.6.6RJ1yq', 120, 0);

INSERT INTO "Player" (id, rank, name, team, role, category, pool, grade, rating, nationality, nationality_raw, base_price, is_riddle, legacy, url, matches, bat_runs, bat_sr, bat_average, bowl_wickets, bowl_eco, bowl_avg, sub_scoring, sub_impact, sub_consistency, sub_experience, sub_wicket_taking, sub_economy, sub_efficiency, sub_batting, sub_bowling, sub_versatility) VALUES
('97fff3a4-9ae4-481a-a016-ef0ee72b60bd', 34, 'Quinton de Kock', 'Mumbai Indians', 'WK-Batsman', 'WK', 'BAT_WK', 'B', 79, 'OVERSEAS', 'South African', 1, false, 0, 'https://www.cricbuzz.com/profiles/8520/quinton-de-kock', 115.0, 3309.0, 134.03, 30.64, NULL, NULL, NULL, 64.0, 67.0, 76.0, 87, NULL, NULL, NULL, NULL, NULL, NULL),
('c8f92767-d0ae-41b4-98fc-256fde9cf072', 143, 'Prashant Solanki', 'Kolkata Knight Riders', 'Bowler', 'BOWL', 'BOWL', 'C', 57, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/12805/prashant-solanki', 2.0, NULL, NULL, NULL, 2.0, 6.33, 19.0, NULL, NULL, NULL, 31, 5.0, 99.0, 97.0, NULL, NULL, NULL),
('48f2e2ec-91b6-47b7-9f1b-b10b22acbb82', 82, 'Jitesh Sharma', 'Royal Challengers Bengaluru', 'WK-Batsman', 'WK', 'BAT_WK', 'C', 68, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/10214/jitesh-sharma', 55.0, 991.0, 157.06, 25.41, NULL, NULL, NULL, 22.0, 83.0, 63.0, 57, NULL, NULL, NULL, NULL, NULL, NULL),
('a074d14b-dbcc-4c60-87fd-a657a738b255', 149, 'Glenn Phillips', 'Gujarat Titans', 'Batting Allrounder', 'AR', 'AR', 'C', 56, 'OVERSEAS', 'New Zealander', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/10693/glenn-phillips', 8.0, 65.0, NULL, NULL, 2.0, NULL, NULL, NULL, NULL, NULL, 34, NULL, NULL, NULL, 24.0, 34.0, 24.0),
('a61fd319-bdcb-4594-a75d-4c56185fd41d', 152, 'Anukul Roy', 'Kolkata Knight Riders', 'Batting Allrounder', 'AR', 'AR', 'C', 56, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/12344/anukul-roy', 11.0, 26.0, NULL, NULL, 6.0, NULL, NULL, NULL, NULL, NULL, 35, NULL, NULL, NULL, 17.0, 29.0, 17.0),
('ff319fed-3750-4721-a2fa-7997e6c0db17', 127, 'Digvesh Singh Rathi', 'Lucknow Super Giants', 'Bowler', 'BOWL', 'BOWL', 'C', 61, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/1448289/digvesh-singh-rathi', 13.0, NULL, NULL, NULL, 14.0, 8.25, 30.64, NULL, NULL, NULL, 36, 12.0, 68.0, 72.0, NULL, NULL, NULL),
('4077e979-80bc-4064-8325-46e613736c10', 50, 'Mitchell Marsh', 'Lucknow Super Giants', 'Batting Allrounder', 'AR', 'AR', 'B', 74, 'OVERSEAS', 'Australian', 1, false, 0, 'https://www.cricbuzz.com/profiles/6250/mitchell-marsh', 55.0, 1292.0, NULL, NULL, 37.0, NULL, NULL, NULL, NULL, NULL, 57, NULL, NULL, NULL, 72.0, 43.0, 43.0),
('91af5ea3-9f59-408d-b418-0d9c40d7b1c7', 117, 'Dewald Brevis', 'Chennai Super Kings', 'Batsman', 'BAT', 'BAT_WK', 'C', 62, 'OVERSEAS', 'South African', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/20538/dewald-brevis', 16.0, 455.0, 153.2, 28.44, NULL, NULL, NULL, 12.0, 80.0, 71.0, 38, NULL, NULL, NULL, NULL, NULL, NULL),
('12defc7f-0626-4618-be1e-f94543018c81', 19, 'Hardik Pandya', 'Mumbai Indians', 'Batting Allrounder', 'AR', 'AR', 'A', 89, 'INDIAN', 'Indian', 2, false, 6, 'https://www.cricbuzz.com/profiles/9647/hardik-pandya', 152.0, 2749.0, NULL, NULL, 78.0, NULL, NULL, NULL, NULL, NULL, 99, NULL, NULL, NULL, 90.0, 50.0, 50.0),
('899f67b6-6b09-4239-b9e3-13a853d57b41', 147, 'Mayank Yadav', 'Lucknow Super Giants', 'Bowler', 'BOWL', 'BOWL', 'C', 57, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/22401/mayank-yadav', 6.0, NULL, NULL, NULL, 9.0, 9.17, 20.56, NULL, NULL, NULL, 33, 9.0, 53.0, 94.0, NULL, NULL, NULL),
('f59448a4-c8b4-4811-a29f-b70c6e04938a', 30, 'Rishabh Pant', 'Lucknow Super Giants', 'WK-Batsman', 'WK', 'BAT_WK', 'B', 82, 'INDIAN', 'Indian', 1, false, 0, 'https://www.cricbuzz.com/profiles/10744/rishabh-pant', 125.0, 3553.0, 147.62, 34.16, NULL, NULL, NULL, 68.0, 76.0, 85.0, 92, NULL, NULL, NULL, NULL, NULL, NULL),
('3a414a50-6810-4946-b8ff-3d97920ec302', 135, 'Kartik Tyagi', 'Kolkata Knight Riders', 'Bowler', 'BOWL', 'BOWL', 'C', 58, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/13136/kartik-tyagi', 20.0, NULL, NULL, NULL, 15.0, 10.14, 47.53, NULL, NULL, NULL, 40, 13.0, 37.0, 37.0, NULL, NULL, NULL),
('3e6bbc9c-1aa5-43e2-bd2f-8f256cb21b3a', 112, 'Nitish Kumar Reddy', 'Sunrisers Hyderabad', 'Batting Allrounder', 'AR', 'AR', 'C', 62, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/14701/nitish-kumar-reddy', 28.0, 485.0, NULL, NULL, 5.0, NULL, NULL, NULL, NULL, NULL, 44, NULL, NULL, NULL, 50.0, 14.0, 14.0),
('f0044807-7a84-471b-86ed-63cdd7f1449c', 37, 'Ishan Kishan', 'Sunrisers Hyderabad', 'WK-Batsman', 'WK', 'BAT_WK', 'B', 78, 'INDIAN', 'Indian', 1, false, 0, 'https://www.cricbuzz.com/profiles/10276/ishan-kishan', 119.0, 2998.0, 137.65, 29.11, NULL, NULL, NULL, 58.0, 70.0, 72.0, 89, NULL, NULL, NULL, NULL, NULL, NULL),
('43b24375-2310-47b6-a214-41c708d9bc30', 92, 'Shashank Singh', 'Punjab Kings', 'Batting Allrounder', 'AR', 'AR', 'C', 67, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/10919/shashank-singh', 41.0, 773.0, NULL, NULL, 1.0, NULL, NULL, NULL, NULL, NULL, 50, NULL, NULL, NULL, 67.0, 14.0, 14.0),
('e8772707-6b7a-43a3-899a-8b1268e3b272', 36, 'Arshdeep Singh', 'Punjab Kings', 'Bowler', 'BOWL', 'BOWL', 'B', 78, 'INDIAN', 'Indian', 1, false, 0, 'https://www.cricbuzz.com/profiles/13217/arshdeep-singh', 82.0, NULL, NULL, NULL, 97.0, 9.0, 26.49, NULL, NULL, NULL, 71, 66.0, 56.0, 81.0, NULL, NULL, NULL),
('6c279c44-e748-45c5-b47b-04130fa1213b', 142, 'Kamindu Mendis', 'Sunrisers Hyderabad', 'Batting Allrounder', 'AR', 'AR', 'C', 57, 'OVERSEAS', 'Sri Lankan', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/10940/kamindu-mendis', 5.0, 92.0, NULL, NULL, 2.0, NULL, NULL, NULL, NULL, NULL, 32, NULL, NULL, NULL, 38.0, 29.0, 29.0),
('229ebe98-7763-4e89-a86e-91ea91f5f564', 41, 'Nitish Rana', 'Delhi Capitals', 'Batsman', 'BAT', 'BAT_WK', 'B', 77, 'INDIAN', 'Indian', 1, false, 0, 'https://www.cricbuzz.com/profiles/9204/nitish-rana', 118.0, 2853.0, 136.77, 27.7, NULL, NULL, NULL, 56.0, 69.0, 69.0, 89, NULL, NULL, NULL, NULL, NULL, NULL),
('351e76b2-9a0e-4087-a5bf-aca0aa87b609', 109, 'Abdul Samad', 'Lucknow Super Giants', 'Batting Allrounder', 'AR', 'AR', 'C', 63, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/14628/abdul-samad', 63.0, 741.0, NULL, NULL, 2.0, NULL, NULL, NULL, NULL, NULL, 61, NULL, NULL, NULL, 57.0, 5.0, 5.0),
('7ebb9524-2d3a-42b5-a609-15ae25043511', 23, 'Shubman Gill', 'Gujarat Titans', 'Batsman', 'BAT', 'BAT_WK', 'B', 84, 'INDIAN', 'Indian', 1, false, 0, 'https://www.cricbuzz.com/profiles/11808/shubman-gill', 118.0, 3866.0, 138.72, 39.45, NULL, NULL, NULL, 74.0, 70.0, 98.0, 89, NULL, NULL, NULL, NULL, NULL, NULL),
('914d0a71-8760-498b-9e7a-8bf60f791d60', 100, 'Abishek Porel', 'Delhi Capitals', 'WK-Batsman', 'WK', 'BAT_WK', 'C', 66, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/24326/abishek-porel', 31.0, 661.0, 149.89, 25.42, NULL, NULL, NULL, 16.0, 78.0, 63.0, 45, NULL, NULL, NULL, NULL, NULL, NULL),
('e7435f6a-e99d-4aa1-befb-767e09271a43', 26, 'Jaydev Unadkat', 'Sunrisers Hyderabad', 'Bowler', 'BOWL', 'BOWL', 'B', 83, 'INDIAN', 'Indian', 1, true, 2, 'https://www.cricbuzz.com/profiles/6327/jaydev-unadkat', 112.0, NULL, NULL, NULL, 110.0, 8.88, 30.58, NULL, NULL, NULL, 86, 74.0, 58.0, 73.0, NULL, NULL, NULL),
('8dc801ec-4344-4a57-a9c9-ad94db1c5637', 33, 'Ishant Sharma', 'Gujarat Titans', 'Bowler', 'BOWL', 'BOWL', 'B', 79, 'INDIAN', 'Indian', 1, false, 0, 'https://www.cricbuzz.com/profiles/702/ishant-sharma', 117.0, NULL, NULL, NULL, 96.0, 8.38, 35.18, NULL, NULL, NULL, 88, 65.0, 66.0, 63.0, NULL, NULL, NULL),
('3db097fb-abc7-40d2-a534-7c147a90420a', 69, 'Liam Livingstone', 'Sunrisers Hyderabad', 'Batting Allrounder', 'AR', 'AR', 'B', 70, 'OVERSEAS', 'English', 1, false, 0, 'https://www.cricbuzz.com/profiles/10045/liam-livingstone', 49.0, 1051.0, NULL, NULL, 13.0, NULL, NULL, NULL, NULL, NULL, 54, NULL, NULL, NULL, 70.0, 28.0, 28.0),
('0b216bfa-babe-4962-93a2-1e3e3bb4f707', 119, 'Wanindu Hasaranga', 'Lucknow Super Giants', 'Bowling Allrounder', 'AR', 'AR', 'C', 62, 'OVERSEAS', 'Sri Lankan', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/10926/wanindu-hasaranga', 37.0, 81.0, NULL, NULL, 46.0, NULL, NULL, NULL, NULL, NULL, 48, NULL, NULL, NULL, 15.0, 45.0, 15.0),
('7278bf23-2bd0-438a-a40d-3a3007254a46', 159, 'Rasikh Dar Salam', 'Royal Challengers Bengaluru', 'Bowler', 'BOWL', 'BOWL', 'C', 55, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/14274/rasikh-dar-salam', 13.0, NULL, NULL, NULL, 10.0, 10.62, 40.9, NULL, NULL, NULL, 36, 10.0, 29.0, 51.0, NULL, NULL, NULL),
('6d03b9e2-d7ec-4af6-8432-99e953c4160e', 123, 'Ayush Mhatre', 'Chennai Super Kings', 'Batsman', 'BAT', 'BAT_WK', 'C', 61, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/1431163/ayush-mhatre', 7.0, 240.0, 188.98, 34.29, NULL, NULL, NULL, 8.0, 99.0, 85.0, 33, NULL, NULL, NULL, NULL, NULL, NULL),
('34b8692e-dcb6-48ed-ac3b-30f5c5e82cac', 89, 'Dhruv Jurel', 'Rajasthan Royals', 'WK-Batsman', 'WK', 'BAT_WK', 'C', 67, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/14691/dhruv-jurel', 41.0, 680.0, 153.85, 28.33, NULL, NULL, NULL, 16.0, 81.0, 71.0, 50, NULL, NULL, NULL, NULL, NULL, NULL),
('6f131895-abe3-4196-b4bb-bb757388e725', 80, 'Lockie Ferguson', 'Punjab Kings', 'Bowler', 'BOWL', 'BOWL', 'C', 69, 'OVERSEAS', 'New Zealander', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/10692/lockie-ferguson', 49.0, NULL, NULL, NULL, 51.0, 8.97, 30.0, NULL, NULL, NULL, 54, 36.0, 56.0, 74.0, NULL, NULL, NULL),
('d441d7d4-48cd-49bc-9837-67ecdfe77b99', 155, 'Swapnil Singh', 'Royal Challengers Bengaluru', 'Bowling Allrounder', 'AR', 'AR', 'C', 56, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/10238/swapnil-singh', 14.0, 51.0, NULL, NULL, 7.0, NULL, NULL, NULL, NULL, NULL, 37, NULL, NULL, NULL, 23.0, 27.0, 23.0),
('e121ec1f-eceb-4635-b311-a175da98377b', 47, 'Yashasvi Jaiswal', 'Rajasthan Royals', 'Batsman', 'BAT', 'BAT_WK', 'B', 75, 'INDIAN', 'Indian', 1, false, 0, 'https://www.cricbuzz.com/profiles/13940/yashasvi-jaiswal', 66.0, 2166.0, 152.86, 34.38, NULL, NULL, NULL, 43.0, 80.0, 85.0, 63, NULL, NULL, NULL, NULL, NULL, NULL),
('760059ae-f3db-431b-a853-5c85a7b884b8', 101, 'Umran Malik', 'Kolkata Knight Riders', 'Bowler', 'BOWL', 'BOWL', 'C', 65, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/19027/umran-malik', 26.0, NULL, NULL, NULL, 29.0, 9.4, 26.62, NULL, NULL, NULL, 43, 22.0, 49.0, 81.0, NULL, NULL, NULL),
('347e0f5c-3a18-476d-a20f-c7a22a83137b', 111, 'Ryan Rickelton', 'Mumbai Indians', 'WK-Batsman', 'WK', 'BAT_WK', 'C', 62, 'OVERSEAS', 'South African', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/13070/ryan-rickelton', 14.0, 388.0, 150.98, 29.85, NULL, NULL, NULL, 11.0, 79.0, 74.0, 37, NULL, NULL, NULL, NULL, NULL, NULL),
('5a357544-7fd0-4985-a591-3d701688ac18', 73, 'Tim David', 'Royal Challengers Bengaluru', 'Batsman', 'BAT', 'BAT_WK', 'B', 70, 'OVERSEAS', 'Singaporean', 1, false, 0, 'https://www.cricbuzz.com/profiles/13169/tim-david', 50.0, 846.0, 173.37, 32.54, NULL, NULL, NULL, 19.0, 94.0, 81.0, 55, NULL, NULL, NULL, NULL, NULL, NULL),
('c82f51a4-9dca-4faf-bcd0-bca5f41459ee', 43, 'Abhishek Sharma', 'Sunrisers Hyderabad', 'Batting Allrounder', 'AR', 'AR', 'B', 77, 'INDIAN', 'Indian', 1, false, 2, 'https://www.cricbuzz.com/profiles/12086/abhishek-sharma', 77.0, 1815.0, NULL, NULL, 11.0, NULL, NULL, NULL, NULL, NULL, 68, NULL, NULL, NULL, 90.0, 24.0, 24.0),
('3eae9f84-8aca-4e05-9d20-2419e059367b', 88, 'Harshit Rana', 'Kolkata Knight Riders', 'Bowler', 'BOWL', 'BOWL', 'C', 67, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/24729/harshit-rana', 33.0, NULL, NULL, NULL, 40.0, 9.51, 25.73, NULL, NULL, NULL, 46, 29.0, 47.0, 83.0, NULL, NULL, NULL),
('cdb1ac47-a96b-433e-a3ee-bad3a5882d57', 58, 'Riyan Parag', 'Rajasthan Royals', 'Batting Allrounder', 'AR', 'AR', 'B', 73, 'INDIAN', 'Indian', 1, false, 2, 'https://www.cricbuzz.com/profiles/12305/riyan-parag', 83.0, 1566.0, NULL, NULL, 7.0, NULL, NULL, NULL, NULL, NULL, 71, NULL, NULL, NULL, 78.0, 16.0, 16.0),
('c24da902-a313-4660-821d-3198bd10fcc8', 63, 'T Natarajan', 'Delhi Capitals', 'Bowler', 'BOWL', 'BOWL', 'B', 72, 'INDIAN', 'Indian', 1, false, 0, 'https://www.cricbuzz.com/profiles/10225/t-natarajan', 63.0, NULL, NULL, NULL, 67.0, 8.94, 30.12, NULL, NULL, NULL, 61, 47.0, 57.0, 74.0, NULL, NULL, NULL),
('17c98407-2cf7-4b4f-9311-070ce5d5cd4f', 115, 'Rachin Ravindra', 'Kolkata Knight Riders', 'Batting Allrounder', 'AR', 'AR', 'C', 62, 'OVERSEAS', 'New Zealander', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/11177/rachin-ravindra', 18.0, 413.0, NULL, NULL, 0.0, NULL, NULL, NULL, NULL, NULL, 39, NULL, NULL, NULL, 49.0, 29.0, 29.0),
('c83d5143-942f-4bfc-89e7-b4b0e2dddc73', 114, 'Mitchell Santner', 'Mumbai Indians', 'Bowling Allrounder', 'AR', 'AR', 'C', 62, 'OVERSEAS', 'New Zealander', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/10100/mitchell-santner', 31.0, 110.0, NULL, NULL, 25.0, NULL, NULL, NULL, NULL, NULL, 45, NULL, NULL, NULL, 25.0, 40.0, 25.0),
('e63d49ed-05da-47a9-918b-16252a0807bc', 32, 'David Miller', 'Delhi Capitals', 'Batsman', 'BAT', 'BAT_WK', 'B', 80, 'OVERSEAS', 'South African', 1, false, 0, 'https://www.cricbuzz.com/profiles/6349/david-miller', 141.0, 3077.0, 138.61, 35.78, NULL, NULL, NULL, 60.0, 70.0, 89.0, 99, NULL, NULL, NULL, NULL, NULL, NULL),
('e12a80c4-e42b-493f-9071-013825892124', 85, 'Mohsin Khan', 'Lucknow Super Giants', 'Bowler', 'BOWL', 'BOWL', 'C', 67, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/13534/mohsin-khan', 24.0, NULL, NULL, NULL, 27.0, 8.51, 25.52, NULL, NULL, NULL, 42, 21.0, 64.0, 83.0, NULL, NULL, NULL),
('66320ec9-1a1e-4f28-b503-072b3a028fc8', 57, 'Jofra Archer', 'Rajasthan Royals', 'Bowler', 'BOWL', 'BOWL', 'B', 73, 'OVERSEAS', 'English', 1, false, 0, 'https://www.cricbuzz.com/profiles/11540/jofra-archer', 52.0, NULL, NULL, NULL, 59.0, 7.89, 27.15, NULL, NULL, NULL, 56, 41.0, 74.0, 80.0, NULL, NULL, NULL),
('f729d4e4-52af-4ae3-8940-745217dea541', 150, 'Adam Milne', 'Rajasthan Royals', 'Bowler', 'BOWL', 'BOWL', 'C', 56, 'OVERSEAS', 'New Zealander', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/7625/adam-milne', 10.0, NULL, NULL, NULL, 7.0, 9.48, 46.71, NULL, NULL, NULL, 35, 8.0, 48.0, 38.0, NULL, NULL, NULL),
('d5000b8c-b683-42e2-a429-1c7df3798153', 61, 'Travis Head', 'Sunrisers Hyderabad', 'Batsman', 'BAT', 'BAT_WK', 'B', 72, 'OVERSEAS', 'Australian', 1, false, 0, 'https://www.cricbuzz.com/profiles/8497/travis-head', 38.0, 1146.0, 170.03, 34.73, NULL, NULL, NULL, 25.0, 92.0, 86.0, 49, NULL, NULL, NULL, NULL, NULL, NULL),
('1ec56440-2f69-4678-9e52-d50c45b6d684', 46, 'Avesh Khan', 'Lucknow Super Giants', 'Bowler', 'BOWL', 'BOWL', 'B', 76, 'INDIAN', 'Indian', 1, false, 0, 'https://www.cricbuzz.com/profiles/9781/avesh-khan', 75.0, NULL, NULL, NULL, 87.0, 9.12, 28.29, NULL, NULL, NULL, 67, 60.0, 54.0, 77.0, NULL, NULL, NULL),
('507637bb-1a50-43dd-8f09-44b3ab683c05', 13, 'Axar Patel', 'Delhi Capitals', 'Bowling Allrounder', 'AR', 'AR', 'A', 91, 'INDIAN', 'Indian', 2, false, 6, 'https://www.cricbuzz.com/profiles/8808/axar-patel', 162.0, 1916.0, NULL, NULL, 128.0, NULL, NULL, NULL, NULL, NULL, 99, NULL, NULL, NULL, 82.0, 72.0, 72.0),
('e65d0eab-2bc2-488c-871b-97f18ad162df', 158, 'Arjun Tendulkar', 'Lucknow Super Giants', 'Bowling Allrounder', 'AR', 'AR', 'C', 55, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/13747/arjun-tendulkar', 5.0, 13.0, NULL, NULL, 3.0, NULL, NULL, NULL, NULL, NULL, 32, NULL, NULL, NULL, 32.0, 23.0, 23.0),
('b6ee9e5f-4e14-4e7f-8cb1-0954d251fe23', 125, 'Vaibhav Suryavanshi', 'Rajasthan Royals', 'Batsman', 'BAT', 'BAT_WK', 'C', 61, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/51791/vaibhav-suryavanshi', 7.0, 252.0, 206.56, 36.0, NULL, NULL, NULL, 9.0, 99.0, 89.0, 33, NULL, NULL, NULL, NULL, NULL, NULL),
('d02874c9-e487-4bef-ad61-fa74c7e61575', 60, 'Noor Ahmad', 'Chennai Super Kings', 'Bowler', 'BOWL', 'BOWL', 'B', 72, 'OVERSEAS', 'Afghan', 1, false, 0, 'https://www.cricbuzz.com/profiles/15452/noor-ahmad', 37.0, NULL, NULL, NULL, 48.0, 8.08, 22.23, NULL, NULL, NULL, 48, 34.0, 71.0, 90.0, NULL, NULL, NULL),
('1eea516c-d733-40e8-bf05-f75bb749ec66', 137, 'Jayant Yadav', 'Gujarat Titans', 'Bowling Allrounder', 'AR', 'AR', 'C', 58, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/8182/jayant-yadav', 20.0, 40.0, NULL, NULL, 8.0, NULL, NULL, NULL, NULL, NULL, 40, NULL, NULL, NULL, 22.0, 25.0, 22.0),
('72dbe1b7-3f8d-471e-8c1a-c7522032efe2', 3, 'Jasprit Bumrah', 'Mumbai Indians', 'Bowler', 'BOWL', 'BOWL', 'A', 99, 'INDIAN', 'Indian', 2, false, 8, 'https://www.cricbuzz.com/profiles/9311/jasprit-bumrah', 145.0, NULL, NULL, NULL, 183.0, 7.25, 22.03, NULL, NULL, NULL, 99, 99.0, 84.0, 91.0, NULL, NULL, NULL),
('e08045b3-42d4-4568-8580-4f871c1f98d6', 103, 'Priyansh Arya', 'Punjab Kings', 'Batsman', 'BAT', 'BAT_WK', 'C', 64, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/14689/priyansh-arya', 17.0, 475.0, 179.25, 27.94, NULL, NULL, NULL, 13.0, 98.0, 70.0, 38, NULL, NULL, NULL, NULL, NULL, NULL),
('55c28e39-aae2-458c-96a6-2dc13c5842eb', 84, 'Cameron Green', 'Kolkata Knight Riders', 'Batting Allrounder', 'AR', 'AR', 'C', 68, 'OVERSEAS', 'Australian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/12225/cameron-green', 29.0, 707.0, NULL, NULL, 16.0, NULL, NULL, NULL, NULL, NULL, 44, NULL, NULL, NULL, 64.0, 27.0, 27.0),
('74f303d9-42ca-4c2f-a38a-d69e8fc6f64d', 6, 'Rohit Sharma', 'Mumbai Indians', 'Batsman', 'BAT', 'BAT_WK', 'A', 96, 'INDIAN', 'Indian', 2, false, 8, 'https://www.cricbuzz.com/profiles/576/rohit-sharma', 272.0, 7046.0, 132.1, 29.73, NULL, NULL, NULL, 99.0, 66.0, 74.0, 99, NULL, NULL, NULL, NULL, NULL, NULL),
('723d9ccf-c55f-40e3-9d94-aa3fbfae44c1', 133, 'Kyle Jamieson', 'Delhi Capitals', 'Bowler', 'BOWL', 'BOWL', 'C', 59, 'OVERSEAS', 'New Zealander', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/9441/kyle-jamieson', 13.0, NULL, NULL, NULL, 14.0, 9.67, 29.71, NULL, NULL, NULL, 36, 12.0, 45.0, 74.0, NULL, NULL, NULL),
('a350a1b3-c765-4b0d-a540-230640b72329', 94, 'Will Jacks', 'Mumbai Indians', 'Batting Allrounder', 'AR', 'AR', 'C', 66, 'OVERSEAS', 'English', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/12258/will-jacks', 21.0, 463.0, NULL, NULL, 8.0, NULL, NULL, NULL, NULL, NULL, 40, NULL, NULL, NULL, 55.0, 28.0, 28.0),
('9c972686-9ea6-4ee4-8407-891bc8cfa8aa', 17, 'Mohammed Shami', 'Lucknow Super Giants', 'Bowler', 'BOWL', 'BOWL', 'A', 89, 'INDIAN', 'Indian', 2, false, 4, 'https://www.cricbuzz.com/profiles/7909/mohammed-shami', 119.0, NULL, NULL, NULL, 133.0, 8.63, 28.18, NULL, NULL, NULL, 89, 89.0, 62.0, 78.0, NULL, NULL, NULL),
('e2c67df5-e7a4-4f88-b109-f1f001e5d7a9', 139, 'Nandre Burger', 'Rajasthan Royals', 'Bowler', 'BOWL', 'BOWL', 'C', 58, 'OVERSEAS', 'South African', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/13630/nandre-burger', 5.0, NULL, NULL, NULL, 7.0, 8.53, 20.71, NULL, NULL, NULL, 32, 8.0, 63.0, 94.0, NULL, NULL, NULL),
('983709cb-af18-47fc-8c8c-cd385c21e44a', 157, 'Manimaran Siddharth', 'Lucknow Super Giants', 'Bowler', 'BOWL', 'BOWL', 'C', 55, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/12930/manimaran-siddharth', 5.0, NULL, NULL, NULL, 3.0, 8.63, 46.0, NULL, NULL, NULL, 32, 5.0, 62.0, 40.0, NULL, NULL, NULL),
('b50696be-e46c-48c9-a542-4e0dea4072a4', 42, 'Ruturaj Gaikwad', 'Chennai Super Kings', 'Batsman', 'BAT', 'BAT_WK', 'B', 77, 'INDIAN', 'Indian', 1, false, 0, 'https://www.cricbuzz.com/profiles/11813/ruturaj-gaikwad', 71.0, 2502.0, 137.48, 40.35, NULL, NULL, NULL, 49.0, 70.0, 99.0, 65, NULL, NULL, NULL, NULL, NULL, NULL),
('e6f94746-67fd-4cf6-80fc-a8cf975d107c', 97, 'Ramandeep Singh', 'Kolkata Knight Riders', 'Batting Allrounder', 'AR', 'AR', 'C', 66, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/12337/ramandeep-singh', 30.0, 217.0, NULL, NULL, 6.0, NULL, NULL, NULL, NULL, NULL, 45, NULL, NULL, NULL, 46.0, 35.0, 35.0),
('494bd58f-6880-4a0e-9801-f0a3900b47d6', 132, 'Kuldeep Sen', 'Rajasthan Royals', 'Bowler', 'BOWL', 'BOWL', 'C', 59, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/14336/kuldeep-sen', 12.0, NULL, NULL, NULL, 14.0, 9.63, 27.64, NULL, NULL, NULL, 36, 12.0, 45.0, 79.0, NULL, NULL, NULL),
('6457f8b2-6166-49e7-ae57-a0037f53e005', 128, 'Yash Thakur', 'Punjab Kings', 'Bowler', 'BOWL', 'BOWL', 'C', 61, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/12096/yash-thakur', 21.0, NULL, NULL, NULL, 25.0, 10.43, 30.8, NULL, NULL, NULL, 40, 20.0, 32.0, 72.0, NULL, NULL, NULL),
('66fb7c14-cd21-4f70-b173-0e6a21186f3d', 54, 'Heinrich Klaasen', 'Sunrisers Hyderabad', 'WK-Batsman', 'WK', 'BAT_WK', 'B', 74, 'OVERSEAS', 'South African', 1, false, 0, 'https://www.cricbuzz.com/profiles/10209/heinrich-klaasen', 49.0, 1480.0, 169.73, 40.0, NULL, NULL, NULL, 31.0, 91.0, 99.0, 54, NULL, NULL, NULL, NULL, NULL, NULL),
('7609e429-12f8-4b03-b3bb-2d9e3041ea9c', 29, 'Mohammed Siraj', 'Gujarat Titans', 'Bowler', 'BOWL', 'BOWL', 'B', 83, 'INDIAN', 'Indian', 1, false, 2, 'https://www.cricbuzz.com/profiles/10808/mohammed-siraj', 108.0, NULL, NULL, NULL, 109.0, 8.74, 30.72, NULL, NULL, NULL, 84, 74.0, 60.0, 72.0, NULL, NULL, NULL),
('b8542e89-b151-4d57-aaab-f7ce02e2bf35', 154, 'Nuwan Thushara', 'Royal Challengers Bengaluru', 'Bowler', 'BOWL', 'BOWL', 'C', 56, 'OVERSEAS', 'Sri Lankan', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/18509/nuwan-thushara', 8.0, NULL, NULL, NULL, 9.0, 9.43, 31.44, NULL, NULL, NULL, 34, 9.0, 49.0, 71.0, NULL, NULL, NULL),
('c2c66d72-e17a-48e1-be37-bcd1ee182ac8', 107, 'Shahbaz Ahmed', 'Lucknow Super Giants', 'Bowling Allrounder', 'AR', 'AR', 'C', 64, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/14606/shahbaz-ahmed', 58.0, 545.0, NULL, NULL, 22.0, NULL, NULL, NULL, NULL, NULL, 59, NULL, NULL, NULL, 43.0, 27.0, 27.0),
('2132ccea-1e35-4858-822d-c2536f04cafe', 95, 'Nehal Wadhera', 'Punjab Kings', 'Batsman', 'BAT', 'BAT_WK', 'C', 66, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/13915/nehal-wadhera', 36.0, 719.0, 142.95, 26.63, NULL, NULL, NULL, 17.0, 73.0, 66.0, 48, NULL, NULL, NULL, NULL, NULL, NULL),
('3fa9b834-86c7-49a1-92bc-e8b6bdf43ab4', 96, 'Vaibhav Arora', 'Kolkata Knight Riders', 'Bowler', 'BOWL', 'BOWL', 'C', 66, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/15861/vaibhav-arora', 32.0, NULL, NULL, NULL, 36.0, 9.55, 28.22, NULL, NULL, NULL, 46, 27.0, 47.0, 78.0, NULL, NULL, NULL),
('55c57d3b-1dd5-4bb7-9dea-05c7da631be3', 64, 'Shreyas Gopal', 'Chennai Super Kings', 'Bowler', 'BOWL', 'BOWL', 'B', 72, 'INDIAN', 'Indian', 1, false, 0, 'https://www.cricbuzz.com/profiles/9746/shreyas-gopal', 52.0, NULL, NULL, NULL, 52.0, 8.16, 25.92, NULL, NULL, NULL, 56, 37.0, 69.0, 83.0, NULL, NULL, NULL),
('a44b9c81-667b-42b8-95e5-77baca677f3f', 51, 'Sam Curran', 'Rajasthan Royals', 'Bowling Allrounder', 'AR', 'AR', 'B', 74, 'OVERSEAS', 'English', 1, false, 2, 'https://www.cricbuzz.com/profiles/10420/sam-curran', 64.0, 997.0, NULL, NULL, 59.0, NULL, NULL, NULL, NULL, NULL, 62, NULL, NULL, NULL, 62.0, 41.0, 41.0),
('721b2857-071f-4229-a6ab-7aeb6d988fd1', 126, 'Nathan Ellis', 'Chennai Super Kings', 'Bowler', 'BOWL', 'BOWL', 'C', 61, 'OVERSEAS', 'Australian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/15480/nathan-ellis', 17.0, NULL, NULL, NULL, 19.0, 8.67, 28.74, NULL, NULL, NULL, 38, 16.0, 61.0, 77.0, NULL, NULL, NULL),
('90ebaf07-02b9-441f-aea2-0ec32a712783', 11, 'Sandeep Sharma', 'Rajasthan Royals', 'Bowler', 'BOWL', 'BOWL', 'A', 93, 'INDIAN', 'Indian', 2, false, 4, 'https://www.cricbuzz.com/profiles/8356/sandeep-sharma', 136.0, NULL, NULL, NULL, 146.0, 8.03, 27.88, NULL, NULL, NULL, 98, 98.0, 71.0, 78.0, NULL, NULL, NULL),
('c224d72e-47e8-4081-965b-dc13b16b245d', 118, 'Aniket Verma', 'Sunrisers Hyderabad', 'Batsman', 'BAT', 'BAT_WK', 'C', 62, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/1447065/aniket-verma', 14.0, 236.0, 166.2, 26.22, NULL, NULL, NULL, 8.0, 89.0, 65.0, 37, NULL, NULL, NULL, NULL, NULL, NULL),
('41db3afc-ce59-4117-b50d-2b856892479c', 78, 'Rajat Patidar', 'Royal Challengers Bengaluru', 'Batsman', 'BAT', 'BAT_WK', 'C', 69, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/10636/rajat-patidar', 42.0, 1111.0, 154.31, 30.86, NULL, NULL, NULL, 24.0, 81.0, 77.0, 51, NULL, NULL, NULL, NULL, NULL, NULL),
('66b44bc2-b9cd-4ff3-aca2-e3b12e0b08cb', 144, 'Vijaykumar Vyshak', 'Punjab Kings', 'Bowler', 'BOWL', 'BOWL', 'C', 57, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/10486/vijaykumar-vyshak', 16.0, NULL, NULL, NULL, 17.0, 10.38, 33.88, NULL, NULL, NULL, 38, 14.0, 33.0, 66.0, NULL, NULL, NULL),
('f2b4268b-9d07-4657-8800-e012ae4c2654', 44, 'Khaleel Ahmed', 'Chennai Super Kings', 'Bowler', 'BOWL', 'BOWL', 'B', 77, 'INDIAN', 'Indian', 1, false, 0, 'https://www.cricbuzz.com/profiles/10952/khaleel-ahmed', 71.0, NULL, NULL, NULL, 89.0, 8.98, 26.16, NULL, NULL, NULL, 65, 61.0, 56.0, 82.0, NULL, NULL, NULL),
('125f3ed6-72c9-4f95-b15d-f3199697c6ae', 83, 'Jason Holder', 'Gujarat Titans', 'Bowling Allrounder', 'AR', 'AR', 'C', 68, 'OVERSEAS', 'West Indian', 0.5, false, 2, 'https://www.cricbuzz.com/profiles/8313/jason-holder', 46.0, 259.0, NULL, NULL, 53.0, NULL, NULL, NULL, NULL, NULL, 53, NULL, NULL, NULL, 32.0, 45.0, 32.0),
('0aa6368b-5299-45ea-a078-ed3d66bba62a', 31, 'Manish Pandey', 'Kolkata Knight Riders', 'Batsman', 'BAT', 'BAT_WK', 'B', 82, 'INDIAN', 'Indian', 1, false, 0, 'https://www.cricbuzz.com/profiles/1836/manish-pandey', 174.0, 3942.0, 121.52, 29.42, NULL, NULL, NULL, 76.0, 59.0, 73.0, 99, NULL, NULL, NULL, NULL, NULL, NULL),
('2ebd735b-7f1b-47c9-aeac-ce4a80dd3ba7', 91, 'Shahrukh Khan', 'Gujarat Titans', 'Batting Allrounder', 'AR', 'AR', 'C', 67, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/10226/shahrukh-khan', 55.0, 732.0, NULL, NULL, 1.0, NULL, NULL, NULL, NULL, NULL, 57, NULL, NULL, NULL, 56.0, 27.0, 27.0),
('1414455a-80e3-4628-b517-630e3c300333', 67, 'Ayush Badoni', 'Lucknow Super Giants', 'Batting Allrounder', 'AR', 'AR', 'B', 71, 'INDIAN', 'Indian', 1, false, 0, 'https://www.cricbuzz.com/profiles/13907/ayush-badoni', 56.0, 963.0, NULL, NULL, 4.0, NULL, NULL, NULL, NULL, NULL, 58, NULL, NULL, NULL, 63.0, 37.0, 37.0),
('7428b96a-c6cf-4e05-aad9-2389e7cba8ac', 153, 'Urvil Patel', 'Chennai Super Kings', 'WK-Batsman', 'WK', 'BAT_WK', 'C', 56, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/13476/urvil-patel', 3.0, 68.0, 212.5, 22.67, NULL, NULL, NULL, 5.0, 99.0, 57.0, 31, NULL, NULL, NULL, NULL, NULL, NULL),
('4238a75d-d7c0-4975-96d3-8e2262babeaa', 105, 'Mukesh Kumar', 'Delhi Capitals', 'Bowler', 'BOWL', 'BOWL', 'C', 64, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/10754/mukesh-kumar', 32.0, NULL, NULL, NULL, 36.0, 10.4, 30.61, NULL, NULL, NULL, 46, 27.0, 33.0, 73.0, NULL, NULL, NULL),
('48a93d95-20c2-43da-8ca1-874a3814354f', 86, 'Mayank Markande', 'Mumbai Indians', 'Bowler', 'BOWL', 'BOWL', 'C', 67, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/12627/mayank-markande', 37.0, NULL, NULL, NULL, 37.0, 8.91, 28.89, NULL, NULL, NULL, 48, 27.0, 57.0, 76.0, NULL, NULL, NULL),
('67a8d193-1602-4f43-992a-7f0676138d4d', 38, 'Shardul Thakur', 'Mumbai Indians', 'Bowling Allrounder', 'AR', 'AR', 'B', 78, 'INDIAN', 'Indian', 1, false, 6, 'https://www.cricbuzz.com/profiles/8683/shardul-thakur', 105.0, 325.0, NULL, NULL, 107.0, NULL, NULL, NULL, NULL, NULL, 82, NULL, NULL, NULL, 38.0, 59.0, 38.0),
('92d7e56c-41c0-408c-90e3-4d04d617842a', 55, 'Mitchell Starc', 'Delhi Capitals', 'Bowler', 'BOWL', 'BOWL', 'B', 73, 'OVERSEAS', 'Australian', 1, false, 0, 'https://www.cricbuzz.com/profiles/7710/mitchell-starc', 51.0, NULL, NULL, NULL, 65.0, 8.61, 23.12, NULL, NULL, NULL, 55, 45.0, 62.0, 88.0, NULL, NULL, NULL),
('0f5e5ff1-3ab6-4a03-a21f-3c63e03111e8', 131, 'Romario Shepherd', 'Royal Challengers Bengaluru', 'Bowling Allrounder', 'AR', 'AR', 'C', 60, 'OVERSEAS', 'West Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/13646/romario-shepherd', 18.0, 185.0, NULL, NULL, 10.0, NULL, NULL, NULL, NULL, NULL, 39, NULL, NULL, NULL, 52.0, 18.0, 18.0),
('42edfc76-4344-4626-8bf8-951369f31307', 20, 'Jos Buttler', 'Gujarat Titans', 'WK-Batsman', 'WK', 'BAT_WK', 'A', 88, 'OVERSEAS', 'English', 2, false, 2, 'https://www.cricbuzz.com/profiles/2258/jos-buttler', 121.0, 4120.0, 149.39, 40.0, NULL, NULL, NULL, 79.0, 78.0, 99.0, 90, NULL, NULL, NULL, NULL, NULL, NULL),
('0eb70930-3932-49ba-ba46-a8429fd61a18', 120, 'Ravisrinivasan Sai Kishore', 'Gujarat Titans', 'Bowling Allrounder', 'AR', 'AR', 'C', 61, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/11595/ravisrinivasan-sai-kishore', 25.0, 18.0, NULL, NULL, 32.0, NULL, NULL, NULL, NULL, NULL, 42, NULL, NULL, NULL, 19.0, 41.0, 19.0),
('c0c87848-b06a-41ee-bdcf-4fa8db29eb38', 113, 'Marco Jansen', 'Punjab Kings', 'Bowling Allrounder', 'AR', 'AR', 'C', 62, 'OVERSEAS', 'South African', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/14565/marco-jansen', 35.0, 141.0, NULL, NULL, 36.0, NULL, NULL, NULL, NULL, NULL, 47, NULL, NULL, NULL, 26.0, 36.0, 26.0),
('f96d87d1-8506-4890-985a-cf7ff34caea0', 4, 'Sunil Narine', 'Kolkata Knight Riders', 'Bowling Allrounder', 'AR', 'AR', 'A', 98, 'OVERSEAS', 'West Indian', 2, false, 10, 'https://www.cricbuzz.com/profiles/2276/sunil-narine', 188.0, 1780.0, NULL, NULL, 192.0, NULL, NULL, NULL, NULL, NULL, 99, NULL, NULL, NULL, 84.0, 83.0, 83.0),
('dcfad369-5b68-4d15-a01b-f1faff52e3ac', 108, 'Rovman Powell', 'Kolkata Knight Riders', 'Batsman', 'BAT', 'BAT_WK', 'C', 63, 'OVERSEAS', 'West Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/11445/rovman-powell', 28.0, 365.0, 146.59, 18.25, NULL, NULL, NULL, 11.0, 76.0, 46.0, 44, NULL, NULL, NULL, NULL, NULL, NULL),
('2fe58528-588d-4323-8d78-1590375d3e35', 93, 'Washington Sundar', 'Gujarat Titans', 'Bowling Allrounder', 'AR', 'AR', 'C', 67, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/10945/washington-sundar', 66.0, 511.0, NULL, NULL, 39.0, NULL, NULL, NULL, NULL, NULL, 63, NULL, NULL, NULL, 42.0, 40.0, 40.0),
('86b7eb1f-9c5e-4670-9124-55d29f52dcb3', 146, 'Anshul Kamboj', 'Chennai Super Kings', 'Bowling Allrounder', 'AR', 'AR', 'C', 57, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/14598/anshul-kamboj', 11.0, 16.0, NULL, NULL, 10.0, NULL, NULL, NULL, NULL, NULL, 35, NULL, NULL, NULL, 21.0, 30.0, 21.0),
('d701864d-5b54-44fe-adeb-21eb5ea4e4f4', 145, 'Akash Maharaj Singh', 'Lucknow Super Giants', 'Bowler', 'BOWL', 'BOWL', 'C', 57, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/14696/akash-maharaj-singh', 10.0, NULL, NULL, NULL, 9.0, 9.54, 36.22, NULL, NULL, NULL, 35, 9.0, 47.0, 61.0, NULL, NULL, NULL),
('01ec2d33-0bc2-4f05-8e44-90a3a390ccf9', 71, 'Matheesha Pathirana', 'Kolkata Knight Riders', 'Bowler', 'BOWL', 'BOWL', 'B', 70, 'OVERSEAS', 'Sri Lankan', 1, false, 0, 'https://www.cricbuzz.com/profiles/16458/matheesha-pathirana', 32.0, NULL, NULL, NULL, 47.0, 8.68, 21.62, NULL, NULL, NULL, 46, 34.0, 61.0, 92.0, NULL, NULL, NULL),
('0353510b-474b-4b47-8995-04cfb57b08f9', 74, 'Devdutt Padikkal', 'Royal Challengers Bengaluru', 'Batsman', 'BAT', 'BAT_WK', 'B', 70, 'INDIAN', 'Indian', 1, false, 0, 'https://www.cricbuzz.com/profiles/13088/devdutt-padikkal', 74.0, 1806.0, 126.3, 25.44, NULL, NULL, NULL, 37.0, 62.0, 64.0, 67, NULL, NULL, NULL, NULL, NULL, NULL),
('215f71ec-7aef-43fd-bf7f-1b82b41a8749', 124, 'Shubham Dubey', 'Rajasthan Royals', 'Batsman', 'BAT', 'BAT_WK', 'C', 61, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/19328/shubham-dubey', 13.0, 139.0, 163.53, 23.17, NULL, NULL, NULL, 6.0, 87.0, 58.0, 36, NULL, NULL, NULL, NULL, NULL, NULL),
('8d848ba3-452b-496d-85bf-f985b98d6f60', 68, 'Anrich Nortje', 'Lucknow Super Giants', 'Bowler', 'BOWL', 'BOWL', 'B', 71, 'OVERSEAS', 'South African', 1, false, 0, 'https://www.cricbuzz.com/profiles/11427/anrich-nortje', 48.0, NULL, NULL, NULL, 61.0, 9.07, 27.16, NULL, NULL, NULL, 54, 43.0, 55.0, 80.0, NULL, NULL, NULL),
('4eab71db-1626-4b56-9237-7e471ca64397', 35, 'Deepak Chahar', 'Mumbai Indians', 'Bowler', 'BOWL', 'BOWL', 'B', 78, 'INDIAN', 'Indian', 1, false, 0, 'https://www.cricbuzz.com/profiles/7836/deepak-chahar', 95.0, NULL, NULL, NULL, 88.0, 8.14, 29.51, NULL, NULL, NULL, 77, 60.0, 70.0, 75.0, NULL, NULL, NULL),
('be394efa-ab20-4dc5-813f-74ecc58f6971', 28, 'Kuldeep Yadav', 'Delhi Capitals', 'Bowler', 'BOWL', 'BOWL', 'B', 83, 'INDIAN', 'Indian', 1, false, 2, 'https://www.cricbuzz.com/profiles/8292/kuldeep-yadav', 98.0, NULL, NULL, NULL, 102.0, 8.04, 26.95, NULL, NULL, NULL, 79, 69.0, 71.0, 80.0, NULL, NULL, NULL),
('aaada088-1bf4-4d32-8762-d6c62b2f63d8', 102, 'Angkrish Raghuvanshi', 'Kolkata Knight Riders', 'Batsman', 'BAT', 'BAT_WK', 'C', 65, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/22566/angkrish-raghuvanshi', 22.0, 463.0, 144.69, 28.94, NULL, NULL, NULL, 12.0, 75.0, 72.0, 41, NULL, NULL, NULL, NULL, NULL, NULL),
('6855a2d8-7559-4c30-9ee2-84af88d240aa', 106, 'Sarfaraz Khan', 'Chennai Super Kings', 'Batsman', 'BAT', 'BAT_WK', 'C', 64, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/9429/sarfaraz-khan', 50.0, 585.0, 130.59, 22.5, NULL, NULL, NULL, 15.0, 65.0, 56.0, 55, NULL, NULL, NULL, NULL, NULL, NULL),
('417d543d-a313-4a42-9f96-5bf353b9eef7', 52, 'Rahul Tripathi', 'Kolkata Knight Riders', 'Batsman', 'BAT', 'BAT_WK', 'B', 74, 'INDIAN', 'Indian', 1, false, 0, 'https://www.cricbuzz.com/profiles/9012/rahul-tripathi', 100.0, 2291.0, 137.85, 26.03, NULL, NULL, NULL, 46.0, 70.0, 65.0, 80, NULL, NULL, NULL, NULL, NULL, NULL),
('3d73acf2-8a2a-4649-9c10-75bd162b5560', 130, 'Sameer Rizvi', 'Delhi Capitals', 'Batsman', 'BAT', 'BAT_WK', 'C', 60, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/14700/sameer-rizvi', 13.0, 172.0, 140.99, 24.57, NULL, NULL, NULL, 7.0, 72.0, 61.0, 36, NULL, NULL, NULL, NULL, NULL, NULL),
('fff770e8-f20c-4e67-a06a-e3bcd7947764', 18, 'Rashid Khan', 'Gujarat Titans', 'Bowling Allrounder', 'AR', 'AR', 'A', 89, 'OVERSEAS', 'Afghan', 2, false, 8, 'https://www.cricbuzz.com/profiles/10738/rashid-khan', 136.0, 585.0, NULL, NULL, 158.0, NULL, NULL, NULL, NULL, NULL, 98, NULL, NULL, NULL, 51.0, 82.0, 51.0),
('282aeef4-1ce3-4c4b-96a8-45f07da40684', 62, 'Shimron Hetmyer', 'Rajasthan Royals', 'Batsman', 'BAT', 'BAT_WK', 'B', 72, 'OVERSEAS', 'West Indian', 1, false, 0, 'https://www.cricbuzz.com/profiles/9789/shimron-hetmyer', 86.0, 1482.0, 151.85, 29.06, NULL, NULL, NULL, 31.0, 79.0, 72.0, 73, NULL, NULL, NULL, NULL, NULL, NULL),
('43ccf01b-7c3c-43c7-b36c-3ffbc1ad7b1e', 79, 'Prabhsimran Singh', 'Punjab Kings', 'WK-Batsman', 'WK', 'BAT_WK', 'C', 69, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/14254/prabhsimran-singh', 51.0, 1305.0, 151.93, 25.59, NULL, NULL, NULL, 28.0, 79.0, 64.0, 55, NULL, NULL, NULL, NULL, NULL, NULL),
('124e1346-d269-4c24-b30b-90a7b5bbdef5', 141, 'Eshan Malinga', 'Sunrisers Hyderabad', 'Bowler', 'BOWL', 'BOWL', 'C', 58, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/46926/eshan-malinga', 7.0, NULL, NULL, NULL, 13.0, 8.93, 18.31, NULL, NULL, NULL, 33, 12.0, 57.0, 99.0, NULL, NULL, NULL),
('f867a3da-cf28-4fbc-a512-1cfcc28745cb', 40, 'Rahul Chahar', 'Chennai Super Kings', 'Bowler', 'BOWL', 'BOWL', 'B', 77, 'INDIAN', 'Indian', 1, false, 0, 'https://www.cricbuzz.com/profiles/12087/rahul-chahar', 79.0, NULL, NULL, NULL, 75.0, 7.72, 28.67, NULL, NULL, NULL, 69, 52.0, 76.0, 77.0, NULL, NULL, NULL),
('559a12e9-7de6-46be-bf3f-92cdbccc7b0d', 65, 'Tilak Varma', 'Mumbai Indians', 'Batsman', 'BAT', 'BAT_WK', 'B', 72, 'INDIAN', 'Indian', 1, false, 0, 'https://www.cricbuzz.com/profiles/14504/tilak-varma', 54.0, 1499.0, 144.42, 37.48, NULL, NULL, NULL, 31.0, 74.0, 93.0, 57, NULL, NULL, NULL, NULL, NULL, NULL),
('f53d25e7-655f-4a03-be62-af60c9eb5953', 99, 'Yash Dayal', 'Royal Challengers Bengaluru', 'Bowler', 'BOWL', 'BOWL', 'C', 66, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/14172/yash-dayal', 43.0, NULL, NULL, NULL, 41.0, 9.58, 33.9, NULL, NULL, NULL, 51, 30.0, 46.0, 66.0, NULL, NULL, NULL),
('070787d1-9cea-4a5a-86ec-112379a5baba', 16, 'Suryakumar Yadav', 'Mumbai Indians', 'Batsman', 'BAT', 'BAT_WK', 'A', 89, 'INDIAN', 'Indian', 2, false, 2, 'https://www.cricbuzz.com/profiles/7915/suryakumar-yadav', 166.0, 4311.0, 148.66, 35.05, NULL, NULL, NULL, 82.0, 77.0, 87.0, 99, NULL, NULL, NULL, NULL, NULL, NULL),
('84d19dd3-6577-4b25-94d0-7c80deeb8402', 138, 'Azmatullah Omarzai', 'Punjab Kings', 'Bowling Allrounder', 'AR', 'AR', 'C', 58, 'OVERSEAS', 'Afghan', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/13214/azmatullah-omarzai', 16.0, 99.0, NULL, NULL, 12.0, NULL, NULL, NULL, NULL, NULL, 38, NULL, NULL, NULL, 31.0, 25.0, 25.0),
('3da437e5-8614-41ff-9597-6e0b19a6a952', 136, 'Arshad Khan', 'Gujarat Titans', 'Bowling Allrounder', 'AR', 'AR', 'C', 58, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/18637/arshad-khan', 19.0, 124.0, NULL, NULL, 12.0, NULL, NULL, NULL, NULL, NULL, 39, NULL, NULL, NULL, 39.0, 18.0, 18.0),
('5607846a-1432-40a1-b95b-9160b809fede', 22, 'Kagiso Rabada', 'Gujarat Titans', 'Bowler', 'BOWL', 'BOWL', 'A', 85, 'OVERSEAS', 'South African', 2, true, 2, 'https://www.cricbuzz.com/profiles/9585/kagiso-rabada', 84.0, NULL, NULL, NULL, 119.0, 8.62, 22.96, NULL, NULL, NULL, 72, 80.0, 62.0, 89.0, NULL, NULL, NULL),
('6e7ee966-5750-45b8-a5dd-11e77aedf8a8', 72, 'Aiden Markram', 'Lucknow Super Giants', 'Batsman', 'BAT', 'BAT_WK', 'B', 70, 'OVERSEAS', 'South African', 1, false, 0, 'https://www.cricbuzz.com/profiles/9582/aiden-markram', 57.0, 1440.0, 135.09, 31.3, NULL, NULL, NULL, 30.0, 68.0, 78.0, 58, NULL, NULL, NULL, NULL, NULL, NULL),
('e496375f-1aed-4e77-baeb-683b9965f320', 10, 'Harshal Patel', 'Sunrisers Hyderabad', 'Bowler', 'BOWL', 'BOWL', 'A', 94, 'INDIAN', 'Indian', 2, false, 6, 'https://www.cricbuzz.com/profiles/8175/harshal-patel', 119.0, NULL, NULL, NULL, 151.0, 8.86, 23.7, NULL, NULL, NULL, 89, 99.0, 58.0, 87.0, NULL, NULL, NULL),
('dccc5223-ed80-4e03-b0e5-c5febe1ffefd', 90, 'Naman Dhir', 'Mumbai Indians', 'Batsman', 'BAT', 'BAT_WK', 'C', 67, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/36139/naman-dhir', 23.0, 392.0, 180.65, 28.0, NULL, NULL, NULL, 11.0, 99.0, 70.0, 41, NULL, NULL, NULL, NULL, NULL, NULL),
('444a737d-a6fe-4c5d-b6af-2aaa0c767d50', 116, 'Sherfane Rutherford', 'Mumbai Indians', 'Batting Allrounder', 'AR', 'AR', 'C', 62, 'OVERSEAS', 'West Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/13748/sherfane-rutherford', 23.0, 397.0, NULL, NULL, 1.0, NULL, NULL, NULL, NULL, NULL, 41, NULL, NULL, NULL, 48.0, 17.0, 17.0),
('474aa362-99c9-471a-a316-2ca9180b6699', 25, 'Marcus Stoinis', 'Punjab Kings', 'Batting Allrounder', 'AR', 'AR', 'B', 83, 'OVERSEAS', 'Australian', 1, false, 4, 'https://www.cricbuzz.com/profiles/8989/marcus-stoinis', 109.0, 2026.0, NULL, NULL, 44.0, NULL, NULL, NULL, NULL, NULL, 84, NULL, NULL, NULL, 90.0, 37.0, 37.0),
('7db478ef-edc7-46e2-8a6c-692c6269d28e', 110, 'Josh Inglis', 'Lucknow Super Giants', 'WK-Batsman', 'WK', 'BAT_WK', 'C', 63, 'OVERSEAS', 'Australian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/10637/josh-inglis', 11.0, 278.0, 162.58, 30.89, NULL, NULL, NULL, 9.0, 87.0, 77.0, 35, NULL, NULL, NULL, NULL, NULL, NULL),
('5368d09a-03fe-41aa-ac52-9bbc0b4f64e1', 134, 'Vipraj Nigam', 'Delhi Capitals', 'Bowler', 'BOWL', 'BOWL', 'C', 59, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/1431811/vipraj-nigam', 14.0, NULL, NULL, NULL, 11.0, 9.13, 32.36, NULL, NULL, NULL, 37, 10.0, 54.0, 69.0, NULL, NULL, NULL),
('3c0103dc-4209-438d-b2af-7c8c9ae18bb0', 129, 'Anuj Rawat', 'Gujarat Titans', 'WK-Batsman', 'WK', 'BAT_WK', 'C', 60, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/13135/anuj-rawat', 24.0, 318.0, 119.11, 19.88, NULL, NULL, NULL, 10.0, 57.0, 50.0, 42, NULL, NULL, NULL, NULL, NULL, NULL),
('cb745a20-0331-447d-8c02-238364396ca2', 9, 'KL Rahul', 'Delhi Capitals', 'WK-Batsman', 'WK', 'BAT_WK', 'A', 95, 'INDIAN', 'Indian', 2, false, 4, 'https://www.cricbuzz.com/profiles/8733/kl-rahul', 145.0, 5222.0, 136.03, 46.21, NULL, NULL, NULL, 99.0, 69.0, 99.0, 99, NULL, NULL, NULL, NULL, NULL, NULL),
('127bc78e-e404-4b23-bc8a-71f5010fe317', 140, 'Mukesh Choudhary', 'Chennai Super Kings', 'Bowler', 'BOWL', 'BOWL', 'C', 58, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/13184/mukesh-choudhary', 16.0, NULL, NULL, NULL, 17.0, 9.94, 30.71, NULL, NULL, NULL, 38, 14.0, 40.0, 72.0, NULL, NULL, NULL),
('fb739d97-4716-45fd-960f-5ed54afd3814', 66, 'Philip Salt', 'Royal Challengers Bengaluru', 'WK-Batsman', 'WK', 'BAT_WK', 'B', 71, 'OVERSEAS', 'English', 1, false, 0, 'https://www.cricbuzz.com/profiles/10479/philip-salt', 34.0, 1056.0, 175.71, 34.06, NULL, NULL, NULL, 23.0, 95.0, 84.0, 47, NULL, NULL, NULL, NULL, NULL, NULL),
('291d8a4b-793b-473a-9e76-dad868634d15', 45, 'Shivam Dube', 'Chennai Super Kings', 'Batting Allrounder', 'AR', 'AR', 'B', 76, 'INDIAN', 'Indian', 1, false, 2, 'https://www.cricbuzz.com/profiles/11195/shivam-dube', 79.0, 1859.0, NULL, NULL, 5.0, NULL, NULL, NULL, NULL, NULL, 69, NULL, NULL, NULL, 88.0, 20.0, 20.0),
('28a9b08c-4d0b-4310-94a2-fbc9a3868c77', 122, 'Ashutosh Sharma', 'Delhi Capitals', 'Batting Allrounder', 'AR', 'AR', 'C', 61, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/13497/ashutosh-sharma', 24.0, 393.0, NULL, NULL, 0.0, NULL, NULL, NULL, NULL, NULL, 42, NULL, NULL, NULL, 56.0, 0.0, 0.0),
('cfdd2ceb-4b8e-4729-8643-3696f6fbe14f', 8, 'MS Dhoni', 'Chennai Super Kings', 'WK-Batsman', 'WK', 'BAT_WK', 'A', 95, 'INDIAN', 'Indian', 2, false, 4, 'https://www.cricbuzz.com/profiles/265/ms-dhoni', 278.0, 5439.0, 137.46, 38.3, NULL, NULL, NULL, 99.0, 70.0, 95.0, 99, NULL, NULL, NULL, NULL, NULL, NULL),
('8e6db884-bda0-42cc-bfd5-b087183ec3b7', 48, 'Pat Cummins', 'Sunrisers Hyderabad', 'Bowler', 'BOWL', 'BOWL', 'B', 75, 'OVERSEAS', 'Australian', 1, false, 0, 'https://www.cricbuzz.com/profiles/8095/pat-cummins', 72.0, NULL, NULL, NULL, 79.0, 8.81, 30.04, NULL, NULL, NULL, 66, 54.0, 59.0, 74.0, NULL, NULL, NULL),
('1957673d-e7ee-4e17-9317-8d989ce9507c', 53, 'Prasidh Krishna', 'Gujarat Titans', 'Bowler', 'BOWL', 'BOWL', 'B', 74, 'INDIAN', 'Indian', 1, false, 0, 'https://www.cricbuzz.com/profiles/10551/prasidh-krishna', 66.0, NULL, NULL, NULL, 74.0, 8.77, 29.61, NULL, NULL, NULL, 63, 51.0, 59.0, 75.0, NULL, NULL, NULL),
('24e22d6d-b7bf-4cc9-9fc0-2b05461c31ce', 75, 'Karun Nair', 'Delhi Capitals', 'Batsman', 'BAT', 'BAT_WK', 'B', 70, 'INDIAN', 'Indian', 1, false, 0, 'https://www.cricbuzz.com/profiles/8257/karun-nair', 84.0, 1694.0, 131.73, 23.86, NULL, NULL, NULL, 35.0, 66.0, 60.0, 72, NULL, NULL, NULL, NULL, NULL, NULL),
('d3d494bc-8121-4885-93a8-aad1502c9282', 21, 'Krunal Pandya', 'Royal Challengers Bengaluru', 'Batting Allrounder', 'AR', 'AR', 'A', 86, 'INDIAN', 'Indian', 2, false, 4, 'https://www.cricbuzz.com/profiles/11311/krunal-pandya', 142.0, 1748.0, NULL, NULL, 93.0, NULL, NULL, NULL, NULL, NULL, 99, NULL, NULL, NULL, 77.0, 60.0, 60.0),
('aa492aa4-2a1e-42d6-a455-f04f1a29ba54', 39, 'Nicholas Pooran', 'Lucknow Super Giants', 'WK-Batsman', 'WK', 'BAT_WK', 'B', 78, 'OVERSEAS', 'West Indian', 1, false, 0, 'https://www.cricbuzz.com/profiles/9406/nicholas-pooran', 90.0, 2293.0, 168.98, 34.22, NULL, NULL, NULL, 46.0, 91.0, 85.0, 75, NULL, NULL, NULL, NULL, NULL, NULL),
('f38d0615-b5e5-405f-a1b4-128c4e835474', 2, 'Yuzvendra Chahal', 'Punjab Kings', 'Bowler', 'BOWL', 'BOWL', 'A', 99, 'INDIAN', 'Indian', 2, false, 10, 'https://www.cricbuzz.com/profiles/7910/yuzvendra-chahal', 174.0, NULL, NULL, NULL, 221.0, 7.96, 22.77, NULL, NULL, NULL, 99, 99.0, 73.0, 89.0, NULL, NULL, NULL),
('17285bcf-fd47-4280-8aa9-88ead0d0d591', 27, 'Shreyas Iyer', 'Punjab Kings', 'Batsman', 'BAT', 'BAT_WK', 'B', 83, 'INDIAN', 'Indian', 1, false, 0, 'https://www.cricbuzz.com/profiles/9428/shreyas-iyer', 132.0, 3731.0, 133.35, 34.23, NULL, NULL, NULL, 72.0, 67.0, 85.0, 96, NULL, NULL, NULL, NULL, NULL, NULL),
('a217c239-0245-4f08-b20f-9af9fa73efb9', 14, 'Ajinkya Rahane', 'Kolkata Knight Riders', 'Batsman', 'BAT', 'BAT_WK', 'A', 91, 'INDIAN', 'Indian', 2, false, 4, 'https://www.cricbuzz.com/profiles/1447/ajinkya-rahane', 198.0, 5032.0, 125.02, 30.5, NULL, NULL, NULL, 95.0, 61.0, 76.0, 99, NULL, NULL, NULL, NULL, NULL, NULL),
('53ea6988-b6be-4a8e-b7a6-8b52c9e50bc7', 56, 'Josh Hazlewood', 'Royal Challengers Bengaluru', 'Bowler', 'BOWL', 'BOWL', 'B', 73, 'OVERSEAS', 'Australian', 1, false, 0, 'https://www.cricbuzz.com/profiles/6258/josh-hazlewood', 39.0, NULL, NULL, NULL, 57.0, 8.28, 20.98, NULL, NULL, NULL, 49, 40.0, 67.0, 93.0, NULL, NULL, NULL),
('f931f561-407f-44e0-a3e1-4897b0eec9ae', 12, 'Trent Boult', 'Mumbai Indians', 'Bowler', 'BOWL', 'BOWL', 'A', 92, 'OVERSEAS', 'New Zealander', 2, false, 4, 'https://www.cricbuzz.com/profiles/8117/trent-boult', 119.0, NULL, NULL, NULL, 143.0, 8.38, 26.2, NULL, NULL, NULL, 89, 96.0, 66.0, 82.0, NULL, NULL, NULL),
('02092af6-62bb-410f-81f5-7d60e727119a', 148, 'Vignesh Puthur', 'Rajasthan Royals', 'Bowler', 'BOWL', 'BOWL', 'C', 57, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/1447337/vignesh-puthur', 5.0, NULL, NULL, NULL, 6.0, 9.08, 18.17, NULL, NULL, NULL, 32, 7.0, 54.0, 99.0, NULL, NULL, NULL),
('ce161253-4992-45f7-a1b0-27f12de13b85', 76, 'Tristan Stubbs', 'Delhi Capitals', 'WK-Batsman', 'WK', 'BAT_WK', 'B', 70, 'OVERSEAS', 'South African', 1, false, 0, 'https://www.cricbuzz.com/profiles/19243/tristan-stubbs', 32.0, 705.0, 163.2, 41.47, NULL, NULL, NULL, 17.0, 87.0, 99.0, 46, NULL, NULL, NULL, NULL, NULL, NULL),
('24121647-fbe9-412c-b354-5578bbf323ff', 98, 'Shivam Mavi', 'Sunrisers Hyderabad', 'Bowler', 'BOWL', 'BOWL', 'C', 66, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/12345/shivam-mavi', 32.0, NULL, NULL, NULL, 30.0, 8.71, 31.4, NULL, NULL, NULL, 46, 23.0, 60.0, 71.0, NULL, NULL, NULL),
('17cac589-31a6-4fb9-b158-92268f727fc2', 70, 'Venkatesh Iyer', 'Royal Challengers Bengaluru', 'Batting Allrounder', 'AR', 'AR', 'B', 70, 'INDIAN', 'Indian', 1, false, 0, 'https://www.cricbuzz.com/profiles/10917/venkatesh-iyer', 61.0, 1468.0, NULL, NULL, 3.0, NULL, NULL, NULL, NULL, NULL, 60, NULL, NULL, NULL, 77.0, 16.0, 16.0),
('4e90014d-b480-49dc-9251-1f82585731a5', 156, 'Matthew Short', 'Chennai Super Kings', 'Batsman', 'BAT', 'BAT_WK', 'C', 55, 'OVERSEAS', 'Australian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/9456/matthew-short', 6.0, 117.0, 127.18, 19.5, NULL, NULL, NULL, 6.0, 63.0, 49.0, 33, NULL, NULL, NULL, NULL, NULL, NULL),
('c0f138f0-5176-4f55-a08c-0d7d551ab530', 15, 'Sanju Samson', 'Chennai Super Kings', 'WK-Batsman', 'WK', 'BAT_WK', 'A', 89, 'INDIAN', 'Indian', 2, false, 2, 'https://www.cricbuzz.com/profiles/8271/sanju-samson', 176.0, 4704.0, 139.05, 30.75, NULL, NULL, NULL, 89.0, 71.0, 76.0, 99, NULL, NULL, NULL, NULL, NULL, NULL),
('f8409d58-1313-499e-8031-8085b686c9b5', 121, 'Suyash Sharma', 'Royal Challengers Bengaluru', 'Bowler', 'BOWL', 'BOWL', 'C', 61, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/36487/suyash-sharma', 27.0, NULL, NULL, NULL, 18.0, 8.75, 45.22, NULL, NULL, NULL, 43, 15.0, 60.0, 41.0, NULL, NULL, NULL),
('6df427c2-8d78-4e94-b7f6-a87e3f47acc6', 7, 'Ravindra Jadeja', 'Rajasthan Royals', 'Bowling Allrounder', 'AR', 'AR', 'A', 95, 'INDIAN', 'Indian', 2, false, 8, 'https://www.cricbuzz.com/profiles/587/ravindra-jadeja', 254.0, 3260.0, NULL, NULL, 170.0, NULL, NULL, NULL, NULL, NULL, 99, NULL, NULL, NULL, 85.0, 78.0, 78.0),
('9a801609-a162-49e4-af7a-fc2bac723be1', 104, 'Lungi Ngidi', 'Delhi Capitals', 'Bowler', 'BOWL', 'BOWL', 'C', 64, 'OVERSEAS', 'South African', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/9603/lungi-ngidi', 16.0, NULL, NULL, NULL, 29.0, 8.53, 18.24, NULL, NULL, NULL, 38, 22.0, 63.0, 99.0, NULL, NULL, NULL),
('3f1a6ab6-3914-4d2a-a6a8-b56f2a30b502', 77, 'Rinku Singh', 'Kolkata Knight Riders', 'Batsman', 'BAT', 'BAT_WK', 'C', 69, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/10896/rinku-singh', 58.0, 1099.0, 145.18, 30.53, NULL, NULL, NULL, 24.0, 75.0, 76.0, 59, NULL, NULL, NULL, NULL, NULL, NULL),
('9914e768-fc9c-490e-b41b-449cd2a2e169', 24, 'Varun Chakaravarthy', 'Kolkata Knight Riders', 'Bowler', 'BOWL', 'BOWL', 'B', 84, 'INDIAN', 'Indian', 1, false, 2, 'https://www.cricbuzz.com/profiles/12926/varun-chakaravarthy', 83.0, NULL, NULL, NULL, 100.0, 7.58, 23.85, NULL, NULL, NULL, 71, 68.0, 79.0, 87.0, NULL, NULL, NULL),
('f4a536a7-a552-4a2f-a712-311771038845', 87, 'Tushar Deshpande', 'Rajasthan Royals', 'Bowler', 'BOWL', 'BOWL', 'C', 67, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/11307/tushar-deshpande', 46.0, NULL, NULL, NULL, 51.0, 9.84, 31.04, NULL, NULL, NULL, 53, 36.0, 42.0, 72.0, NULL, NULL, NULL),
('e3ac0a1b-8026-445e-b675-f84c2943f588', 59, 'Rahul Tewatia', 'Gujarat Titans', 'Batting Allrounder', 'AR', 'AR', 'B', 73, 'INDIAN', 'Indian', 1, false, 0, 'https://www.cricbuzz.com/profiles/9693/rahul-tewatia', 108.0, 1112.0, NULL, NULL, 32.0, NULL, NULL, NULL, NULL, NULL, 84, NULL, NULL, NULL, 64.0, 38.0, 38.0),
('6d77b621-0798-49fe-b903-f02c1eb6ce11', 81, 'Harpreet Brar', 'Punjab Kings', 'Bowler', 'BOWL', 'BOWL', 'C', 68, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/14452/harpreet-brar', 49.0, NULL, NULL, NULL, 35.0, 8.03, 31.0, NULL, NULL, NULL, 54, 26.0, 71.0, 72.0, NULL, NULL, NULL),
('e33fe259-ff26-4a7f-a7f9-99c19cff8de6', 1, 'Virat Kohli', 'Royal Challengers Bengaluru', 'Batsman', 'BAT', 'BAT_WK', 'A', 99, 'INDIAN', 'Indian', 2, false, 10, 'https://www.cricbuzz.com/profiles/1413/virat-kohli', 267.0, 8661.0, 132.86, 39.55, NULL, NULL, NULL, 99.0, 67.0, 98.0, 99, NULL, NULL, NULL, NULL, NULL, NULL),
('e775d162-2fed-4bb1-8e9b-d98fa6d4d3d1', 49, 'Ravi Bishnoi', 'Rajasthan Royals', 'Bowler', 'BOWL', 'BOWL', 'B', 75, 'INDIAN', 'Indian', 1, false, 0, 'https://www.cricbuzz.com/profiles/14659/ravi-bishnoi', 77.0, NULL, NULL, NULL, 72.0, 8.22, 31.07, NULL, NULL, NULL, 68, 50.0, 68.0, 72.0, NULL, NULL, NULL),
('1df70acd-aeb4-4b4e-b88f-6724e86d8633', 151, 'Dushmantha Chameera', 'Delhi Capitals', 'Bowler', 'BOWL', 'BOWL', 'C', 56, 'OVERSEAS', 'Sri Lankan', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/8393/dushmantha-chameera', 19.0, NULL, NULL, NULL, 13.0, 9.73, 46.38, NULL, NULL, NULL, 39, 12.0, 44.0, 39.0, NULL, NULL, NULL),
('3376d17f-5f10-45b8-8fe4-49b9e5a81609', 5, 'Bhuvneshwar Kumar', 'Royal Challengers Bengaluru', 'Bowler', 'BOWL', 'BOWL', 'A', 98, 'INDIAN', 'Indian', 2, false, 8, 'https://www.cricbuzz.com/profiles/1726/bhuvneshwar-kumar', 190.0, NULL, NULL, NULL, 198.0, 7.69, 27.33, NULL, NULL, NULL, 99, 99.0, 77.0, 80.0, NULL, NULL, NULL);

INSERT INTO "AuctionPlayer" (id, player_id, status) VALUES
('01a9dcdd-0779-44cf-bca0-e063f0974269', '97fff3a4-9ae4-481a-a016-ef0ee72b60bd', 'UNSOLD'),
('f1b77df5-2322-49a8-9239-151b41134d69', 'c8f92767-d0ae-41b4-98fc-256fde9cf072', 'UNSOLD'),
('eb664ef9-f811-4b0b-a664-6c3f9d3ef7cd', '48f2e2ec-91b6-47b7-9f1b-b10b22acbb82', 'UNSOLD'),
('54364539-08a3-4e51-88d3-d03e3b7dcf49', 'a074d14b-dbcc-4c60-87fd-a657a738b255', 'UNSOLD'),
('32f57f90-d074-4362-9a7a-b9839b6ce198', 'a61fd319-bdcb-4594-a75d-4c56185fd41d', 'UNSOLD'),
('e5d5a539-6390-4dfd-b3ca-d53a1f77f991', 'ff319fed-3750-4721-a2fa-7997e6c0db17', 'UNSOLD'),
('f2ac46e4-1211-4330-bdad-23badf465b8f', '4077e979-80bc-4064-8325-46e613736c10', 'UNSOLD'),
('378e0d7b-9994-4e17-b6d5-0314e74aeb3f', '91af5ea3-9f59-408d-b418-0d9c40d7b1c7', 'UNSOLD'),
('bfeb47b5-ad7d-41c8-80d6-a71e9be9d4c5', '12defc7f-0626-4618-be1e-f94543018c81', 'UNSOLD'),
('9c36ae91-58b6-4b39-b3ee-3e3412adf9d0', '899f67b6-6b09-4239-b9e3-13a853d57b41', 'UNSOLD'),
('dd35fc84-965e-4cd8-8b80-c0cdb40dcdde', 'f59448a4-c8b4-4811-a29f-b70c6e04938a', 'UNSOLD'),
('98e384ba-2f06-4726-9612-16b3b0a833ad', '3a414a50-6810-4946-b8ff-3d97920ec302', 'UNSOLD'),
('0e7e8b07-d9c0-479d-b6af-8721f0ffc23e', '3e6bbc9c-1aa5-43e2-bd2f-8f256cb21b3a', 'UNSOLD'),
('d5b69800-d3bf-44c3-a05c-2a556046bbab', 'f0044807-7a84-471b-86ed-63cdd7f1449c', 'UNSOLD'),
('a6e9dad5-5a32-4f6e-a397-e79794e62bc1', '43b24375-2310-47b6-a214-41c708d9bc30', 'UNSOLD'),
('52d118a8-f72a-4888-8eb0-f56045fc9466', 'e8772707-6b7a-43a3-899a-8b1268e3b272', 'UNSOLD'),
('f1fe0a81-9941-4505-b73f-bd8b2307f2b0', '6c279c44-e748-45c5-b47b-04130fa1213b', 'UNSOLD'),
('7c43161c-f862-4231-9ec4-b93479efbfc1', '229ebe98-7763-4e89-a86e-91ea91f5f564', 'UNSOLD'),
('08bbe4d4-87bd-47cc-a6c2-5536b0abe601', '351e76b2-9a0e-4087-a5bf-aca0aa87b609', 'UNSOLD'),
('bb52f1af-47a9-42f0-b97b-5b641cddeb3a', '7ebb9524-2d3a-42b5-a609-15ae25043511', 'UNSOLD'),
('8183a561-640e-4bbb-85e5-0036ff1169ce', '914d0a71-8760-498b-9e7a-8bf60f791d60', 'UNSOLD'),
('70fe07c9-6d93-4f58-883b-1c9330332c56', 'e7435f6a-e99d-4aa1-befb-767e09271a43', 'UNSOLD'),
('a5c13277-1794-4d40-917e-56ab423dc92b', '8dc801ec-4344-4a57-a9c9-ad94db1c5637', 'UNSOLD'),
('281a1ca3-c88c-4ab3-8575-65be2bbcb342', '3db097fb-abc7-40d2-a534-7c147a90420a', 'UNSOLD'),
('f68134d1-9ee9-437c-b9b4-fde260e371b6', '0b216bfa-babe-4962-93a2-1e3e3bb4f707', 'UNSOLD'),
('398fa4ed-5ca0-4a46-a1ac-4fd4f55f0e54', '7278bf23-2bd0-438a-a40d-3a3007254a46', 'UNSOLD'),
('f40df89f-2dfe-4c0b-8ff4-e45e7fd8f273', '6d03b9e2-d7ec-4af6-8432-99e953c4160e', 'UNSOLD'),
('a73fc5cf-791d-4bfa-91dc-677082c85f74', '34b8692e-dcb6-48ed-ac3b-30f5c5e82cac', 'UNSOLD'),
('12b23a72-ccc5-460d-a4af-9f4f4f77202a', '6f131895-abe3-4196-b4bb-bb757388e725', 'UNSOLD'),
('f42f895f-b9b2-4dfa-b2a6-75109229cb84', 'd441d7d4-48cd-49bc-9837-67ecdfe77b99', 'UNSOLD'),
('d03ff969-14eb-4398-9cc3-a6582bb39e69', 'e121ec1f-eceb-4635-b311-a175da98377b', 'UNSOLD'),
('b77a9f80-883a-428f-8da9-62502d457ae4', '760059ae-f3db-431b-a853-5c85a7b884b8', 'UNSOLD'),
('a29e4d4a-f77c-4790-a04f-5890f1b8624f', '347e0f5c-3a18-476d-a20f-c7a22a83137b', 'UNSOLD'),
('3ab3161c-72d4-4abb-87a3-f347f875b9ff', '5a357544-7fd0-4985-a591-3d701688ac18', 'UNSOLD'),
('7c496bd6-20c1-4e18-ad10-ef4639a2c7ac', 'c82f51a4-9dca-4faf-bcd0-bca5f41459ee', 'UNSOLD'),
('5cf3c83e-40af-4a2b-a695-6f0de9b54f53', '3eae9f84-8aca-4e05-9d20-2419e059367b', 'UNSOLD'),
('fe19f7e4-25d6-4257-8034-278d623cf0c0', 'cdb1ac47-a96b-433e-a3ee-bad3a5882d57', 'UNSOLD'),
('d4b04a02-8598-4be1-9a8c-4ee39b9e5415', 'c24da902-a313-4660-821d-3198bd10fcc8', 'UNSOLD'),
('058ddb4a-3ecf-464f-b5f8-980f52ef9925', '17c98407-2cf7-4b4f-9311-070ce5d5cd4f', 'UNSOLD'),
('49142012-c02e-4a65-a05e-109ee370936a', 'c83d5143-942f-4bfc-89e7-b4b0e2dddc73', 'UNSOLD'),
('6682a5d0-9ef3-4959-b3db-1eb121063625', 'e63d49ed-05da-47a9-918b-16252a0807bc', 'UNSOLD'),
('ff0c36c6-090c-490a-a0a6-325ee6ee604f', 'e12a80c4-e42b-493f-9071-013825892124', 'UNSOLD'),
('1114bd0d-001f-4c5f-a5e7-d998c46bfcdd', '66320ec9-1a1e-4f28-b503-072b3a028fc8', 'UNSOLD'),
('a248c7af-60ec-4a1f-b1d9-36974fffa03a', 'f729d4e4-52af-4ae3-8940-745217dea541', 'UNSOLD'),
('65532ebc-f7a3-444b-9620-d85af52c3d5f', 'd5000b8c-b683-42e2-a429-1c7df3798153', 'UNSOLD'),
('32b403c0-452a-4029-ba69-960a9ef95f00', '1ec56440-2f69-4678-9e52-d50c45b6d684', 'UNSOLD'),
('a904669f-6ee8-4731-a218-a857d679df6e', '507637bb-1a50-43dd-8f09-44b3ab683c05', 'UNSOLD'),
('2499fc7f-fc8f-475b-97be-cce530537db8', 'e65d0eab-2bc2-488c-871b-97f18ad162df', 'UNSOLD'),
('edeb3acd-2f49-456b-a55f-4ae1aba74138', 'b6ee9e5f-4e14-4e7f-8cb1-0954d251fe23', 'UNSOLD'),
('0a1fd516-694b-4e97-b9c2-bc9802f7ad88', 'd02874c9-e487-4bef-ad61-fa74c7e61575', 'UNSOLD'),
('6a6e2712-628e-44a4-936c-4a0073c4e6ed', '1eea516c-d733-40e8-bf05-f75bb749ec66', 'UNSOLD'),
('60e33152-4677-487d-b853-92f54909d1aa', '72dbe1b7-3f8d-471e-8c1a-c7522032efe2', 'UNSOLD'),
('385bc65b-6d18-48dd-8398-75ce9821ac9a', 'e08045b3-42d4-4568-8580-4f871c1f98d6', 'UNSOLD'),
('f6a87bd7-156e-4bbb-bc36-f14dcad07003', '55c28e39-aae2-458c-96a6-2dc13c5842eb', 'UNSOLD'),
('c3e18d3e-b986-4cc4-b715-7f31f0e8d72e', '74f303d9-42ca-4c2f-a38a-d69e8fc6f64d', 'UNSOLD'),
('7887b25b-cd5f-4fff-bdd6-a89b9d3d60c6', '723d9ccf-c55f-40e3-9d94-aa3fbfae44c1', 'UNSOLD'),
('2a340ab4-8154-46ae-bdad-acf2ffb40d3a', 'a350a1b3-c765-4b0d-a540-230640b72329', 'UNSOLD'),
('27210503-5e07-4f5b-a698-9d2ecdd4d342', '9c972686-9ea6-4ee4-8407-891bc8cfa8aa', 'UNSOLD'),
('c09bb0ad-385f-489f-b9a3-1658ecec5bde', 'e2c67df5-e7a4-4f88-b109-f1f001e5d7a9', 'UNSOLD'),
('e16aba6f-c92d-4b90-93a3-29f723484416', '983709cb-af18-47fc-8c8c-cd385c21e44a', 'UNSOLD'),
('a8f7539c-7510-4ad2-946c-97b40b401ed0', 'b50696be-e46c-48c9-a542-4e0dea4072a4', 'UNSOLD'),
('1179bb99-bd2d-4c48-97af-6a6c1efa9ca4', 'e6f94746-67fd-4cf6-80fc-a8cf975d107c', 'UNSOLD'),
('d9f1729a-2d35-4986-b2f7-6769565d39d3', '494bd58f-6880-4a0e-9801-f0a3900b47d6', 'UNSOLD'),
('ba28ca65-dfb1-489e-881d-5728cee22ca1', '6457f8b2-6166-49e7-ae57-a0037f53e005', 'UNSOLD'),
('fa337d27-255f-4c78-a58c-8fe50e7b62c7', '66fb7c14-cd21-4f70-b173-0e6a21186f3d', 'UNSOLD'),
('b51cdc17-20d5-424d-9c83-d6dc8140c01e', '7609e429-12f8-4b03-b3bb-2d9e3041ea9c', 'UNSOLD'),
('b7c27a1a-dfa6-406d-9890-9f832057b502', 'b8542e89-b151-4d57-aaab-f7ce02e2bf35', 'UNSOLD'),
('cd0bf5a1-83d4-427b-beca-0ba5ac9c09be', 'c2c66d72-e17a-48e1-be37-bcd1ee182ac8', 'UNSOLD'),
('865a2b4b-c929-4349-b840-070c9d624b28', '2132ccea-1e35-4858-822d-c2536f04cafe', 'UNSOLD'),
('d6524014-b9ef-413e-a0c6-711ae638a25b', '3fa9b834-86c7-49a1-92bc-e8b6bdf43ab4', 'UNSOLD'),
('7f8e9611-7f74-42b9-b47e-45fcbf1a3144', '55c57d3b-1dd5-4bb7-9dea-05c7da631be3', 'UNSOLD'),
('f25105a4-5b15-4166-873b-1b07502b718e', 'a44b9c81-667b-42b8-95e5-77baca677f3f', 'UNSOLD'),
('25735b7b-f8ff-46dd-b01a-7833ab6e164f', '721b2857-071f-4229-a6ab-7aeb6d988fd1', 'UNSOLD'),
('217c24d1-cb27-4f1f-a754-4d47e1e14993', '90ebaf07-02b9-441f-aea2-0ec32a712783', 'UNSOLD'),
('59a2f261-27df-4a3b-8196-645a19e38135', 'c224d72e-47e8-4081-965b-dc13b16b245d', 'UNSOLD'),
('eafee478-b6ad-4066-975c-726d3540ed9f', '41db3afc-ce59-4117-b50d-2b856892479c', 'UNSOLD'),
('2b1850f0-5a2f-46c5-8e60-d283d0862ce7', '66b44bc2-b9cd-4ff3-aca2-e3b12e0b08cb', 'UNSOLD'),
('0e88476c-db7d-495e-b929-6f511f4e470b', 'f2b4268b-9d07-4657-8800-e012ae4c2654', 'UNSOLD'),
('0267b507-f96a-4244-9dfe-e7da92e34afe', '125f3ed6-72c9-4f95-b15d-f3199697c6ae', 'UNSOLD'),
('04c2c463-282c-4096-8f4e-25c69a957a76', '0aa6368b-5299-45ea-a078-ed3d66bba62a', 'UNSOLD'),
('a0f32cd9-aaf6-4e44-87cf-8c6db77aa22c', '2ebd735b-7f1b-47c9-aeac-ce4a80dd3ba7', 'UNSOLD'),
('63888a0b-5447-4133-b7bd-064ab1f7d7ad', '1414455a-80e3-4628-b517-630e3c300333', 'UNSOLD'),
('28b66f0e-354d-4161-9f1d-7924920b4044', '7428b96a-c6cf-4e05-aad9-2389e7cba8ac', 'UNSOLD'),
('7a6057f8-87b0-4268-acbd-77c2e6098a23', '4238a75d-d7c0-4975-96d3-8e2262babeaa', 'UNSOLD'),
('7db11bf0-5e32-41f1-b21f-74b7f97759c4', '48a93d95-20c2-43da-8ca1-874a3814354f', 'UNSOLD'),
('02e129a6-16ac-4315-8446-747548d555ff', '67a8d193-1602-4f43-992a-7f0676138d4d', 'UNSOLD'),
('13eb2522-28e4-413a-8855-721e792c1562', '92d7e56c-41c0-408c-90e3-4d04d617842a', 'UNSOLD'),
('5362d928-cd73-4f29-b390-8102292056ff', '0f5e5ff1-3ab6-4a03-a21f-3c63e03111e8', 'UNSOLD'),
('9f0a13a6-cd0e-454d-a77a-f0eb186ad018', '42edfc76-4344-4626-8bf8-951369f31307', 'UNSOLD'),
('e974172e-6450-44e5-b207-7793f4aa30d5', '0eb70930-3932-49ba-ba46-a8429fd61a18', 'UNSOLD'),
('9d773211-a021-46b0-96dd-d6f9823e7257', 'c0c87848-b06a-41ee-bdcf-4fa8db29eb38', 'UNSOLD'),
('a43df764-5bb6-4862-99d0-d3f1ebd33946', 'f96d87d1-8506-4890-985a-cf7ff34caea0', 'UNSOLD'),
('f23009c4-5891-4fcf-8d97-f6a07b09e037', 'dcfad369-5b68-4d15-a01b-f1faff52e3ac', 'UNSOLD'),
('a606754f-67c6-44f5-ae7e-0e08559790aa', '2fe58528-588d-4323-8d78-1590375d3e35', 'UNSOLD'),
('9ebcab26-ef18-4c25-a648-f66ce4e8faf4', '86b7eb1f-9c5e-4670-9124-55d29f52dcb3', 'UNSOLD'),
('88193261-aeca-4d75-a88b-76ec61d74d16', 'd701864d-5b54-44fe-adeb-21eb5ea4e4f4', 'UNSOLD'),
('0471cfdf-0c76-4253-b6ed-6fe7d790926a', '01ec2d33-0bc2-4f05-8e44-90a3a390ccf9', 'UNSOLD'),
('1656586a-1d02-401a-95d8-bc9ea9a0f121', '0353510b-474b-4b47-8995-04cfb57b08f9', 'UNSOLD'),
('2dcfb270-ea81-4042-9172-09938d9ebb15', '215f71ec-7aef-43fd-bf7f-1b82b41a8749', 'UNSOLD'),
('5bb7a573-e3cd-43cd-8c29-42847e0fa119', '8d848ba3-452b-496d-85bf-f985b98d6f60', 'UNSOLD'),
('8ef7ecab-1094-4403-aeec-51b60695e0fc', '4eab71db-1626-4b56-9237-7e471ca64397', 'UNSOLD'),
('0a41fc98-f91a-4f4d-9ada-d516eedee0e2', 'be394efa-ab20-4dc5-813f-74ecc58f6971', 'UNSOLD'),
('676fce20-1a1e-47ab-82b0-bb52a7abfa04', 'aaada088-1bf4-4d32-8762-d6c62b2f63d8', 'UNSOLD'),
('3e1fcd91-5fa8-4ea3-bcda-48e10a594409', '6855a2d8-7559-4c30-9ee2-84af88d240aa', 'UNSOLD'),
('a818614a-5d50-4320-84dc-bf11479fb820', '417d543d-a313-4a42-9f96-5bf353b9eef7', 'UNSOLD'),
('cf102796-339d-4d06-aad5-5251584023a9', '3d73acf2-8a2a-4649-9c10-75bd162b5560', 'UNSOLD'),
('2707d718-3e30-4bc9-a08c-feac6dcb8143', 'fff770e8-f20c-4e67-a06a-e3bcd7947764', 'UNSOLD'),
('944fc656-6d60-43ac-9425-65650ef86f2c', '282aeef4-1ce3-4c4b-96a8-45f07da40684', 'UNSOLD'),
('f56d5feb-a8e1-40c0-bc3f-fa0d962f74cb', '43ccf01b-7c3c-43c7-b36c-3ffbc1ad7b1e', 'UNSOLD'),
('328b053c-e219-4e3f-931b-a6d092d5d22c', '124e1346-d269-4c24-b30b-90a7b5bbdef5', 'UNSOLD'),
('73473b19-8a72-4fd4-a571-592a998ab7c5', 'f867a3da-cf28-4fbc-a512-1cfcc28745cb', 'UNSOLD'),
('6605c94e-2bdc-4675-851d-465156fa5b52', '559a12e9-7de6-46be-bf3f-92cdbccc7b0d', 'UNSOLD'),
('18bcac74-170e-4f02-af7a-7d2e4ddaf3e7', 'f53d25e7-655f-4a03-be62-af60c9eb5953', 'UNSOLD'),
('a9d5321c-30a7-49b0-8607-85c2ef0ddb68', '070787d1-9cea-4a5a-86ec-112379a5baba', 'UNSOLD'),
('dc03d1a5-9adc-4e32-8f36-5161ad7418e3', '84d19dd3-6577-4b25-94d0-7c80deeb8402', 'UNSOLD'),
('528f8c01-a2b1-4786-ac89-d7c5bb1f5368', '3da437e5-8614-41ff-9597-6e0b19a6a952', 'UNSOLD'),
('62e30e63-a096-4b7e-bf5d-13a63f2e32f8', '5607846a-1432-40a1-b95b-9160b809fede', 'UNSOLD'),
('8e2250db-ef0e-4850-8bca-9bc8268fa345', '6e7ee966-5750-45b8-a5dd-11e77aedf8a8', 'UNSOLD'),
('a1d37d1a-7a9d-45e6-93a5-6100646c5aca', 'e496375f-1aed-4e77-baeb-683b9965f320', 'UNSOLD'),
('bfbc74e1-ec67-4f07-8fa0-bd0040f753e8', 'dccc5223-ed80-4e03-b0e5-c5febe1ffefd', 'UNSOLD'),
('7755dc78-9ce7-441b-b091-9eb1480ab2cf', '444a737d-a6fe-4c5d-b6af-2aaa0c767d50', 'UNSOLD'),
('f3462f02-7daf-4057-aa15-5a4f4296bbf5', '474aa362-99c9-471a-a316-2ca9180b6699', 'UNSOLD'),
('30133757-c973-47a3-8057-6a20b6224e18', '7db478ef-edc7-46e2-8a6c-692c6269d28e', 'UNSOLD'),
('ceed6979-063b-456a-ab98-0de375314261', '5368d09a-03fe-41aa-ac52-9bbc0b4f64e1', 'UNSOLD'),
('0c536f22-cbae-4709-989e-e63a0a3c6115', '3c0103dc-4209-438d-b2af-7c8c9ae18bb0', 'UNSOLD'),
('b2212f8e-eb2c-43af-ae09-e62332a7f015', 'cb745a20-0331-447d-8c02-238364396ca2', 'UNSOLD'),
('2589d102-753b-439b-892b-f93f8ca7c7c9', '127bc78e-e404-4b23-bc8a-71f5010fe317', 'UNSOLD'),
('d1197b0d-13d7-4dc4-a1aa-02319a881566', 'fb739d97-4716-45fd-960f-5ed54afd3814', 'UNSOLD'),
('b9a96b1d-6321-4327-9299-f1b2268d70c1', '291d8a4b-793b-473a-9e76-dad868634d15', 'UNSOLD'),
('fc0cf46f-19db-41ac-b6bb-147d13b9cc91', '28a9b08c-4d0b-4310-94a2-fbc9a3868c77', 'UNSOLD'),
('f496805f-bea0-43c5-955d-585dfc507a31', 'cfdd2ceb-4b8e-4729-8643-3696f6fbe14f', 'UNSOLD'),
('3158c932-6f12-4ce6-ab8b-f850e9da3011', '8e6db884-bda0-42cc-bfd5-b087183ec3b7', 'UNSOLD'),
('29f14188-44ee-4e6c-807c-ec1020293bb6', '1957673d-e7ee-4e17-9317-8d989ce9507c', 'UNSOLD'),
('9f46b637-a5f8-489a-a79c-41703265f632', '24e22d6d-b7bf-4cc9-9fc0-2b05461c31ce', 'UNSOLD'),
('01e66c33-0363-45d2-80a7-da67ad8103f6', 'd3d494bc-8121-4885-93a8-aad1502c9282', 'UNSOLD'),
('fae92db2-61bc-4981-82c3-6a697caae9d2', 'aa492aa4-2a1e-42d6-a455-f04f1a29ba54', 'UNSOLD'),
('e266b030-2c0d-4438-8efd-11a289cd1b4c', 'f38d0615-b5e5-405f-a1b4-128c4e835474', 'UNSOLD'),
('ea8698e4-fd78-4dd6-92e1-91d1abff7d51', '17285bcf-fd47-4280-8aa9-88ead0d0d591', 'UNSOLD'),
('2b878b42-88d5-451d-bbfd-608469ffe0c3', 'a217c239-0245-4f08-b20f-9af9fa73efb9', 'UNSOLD'),
('adbcd7a6-d4e5-4351-b937-cf90f19effa9', '53ea6988-b6be-4a8e-b7a6-8b52c9e50bc7', 'UNSOLD'),
('4b086237-035b-4d2f-9a46-757ca5c1e55b', 'f931f561-407f-44e0-a3e1-4897b0eec9ae', 'UNSOLD'),
('9a695a4c-f3f0-4a78-914d-2fdf991043eb', '02092af6-62bb-410f-81f5-7d60e727119a', 'UNSOLD'),
('d432aae2-6fc7-44a1-acb7-522e91b7c107', 'ce161253-4992-45f7-a1b0-27f12de13b85', 'UNSOLD'),
('7f31904c-6eb2-43d2-a4c8-363f8e80d30e', '24121647-fbe9-412c-b354-5578bbf323ff', 'UNSOLD'),
('2f03cda6-5d58-4d4f-a683-3b64c9969c5c', '17cac589-31a6-4fb9-b158-92268f727fc2', 'UNSOLD'),
('3cbfcd3c-aa75-4814-98c4-339102b82b44', '4e90014d-b480-49dc-9251-1f82585731a5', 'UNSOLD'),
('8182fd2d-9cee-47f8-87cc-dcf8f7a1b39b', 'c0f138f0-5176-4f55-a08c-0d7d551ab530', 'UNSOLD'),
('c8e33fce-8ba9-4478-8afe-1f067e926212', 'f8409d58-1313-499e-8031-8085b686c9b5', 'UNSOLD'),
('ef10c92d-cc25-419f-a994-344ab7f2e1cf', '6df427c2-8d78-4e94-b7f6-a87e3f47acc6', 'UNSOLD'),
('84dabd3c-dc95-4015-ad33-e741cacdc66f', '9a801609-a162-49e4-af7a-fc2bac723be1', 'UNSOLD'),
('7c019003-52b4-4682-b850-f135b9219515', '3f1a6ab6-3914-4d2a-a6a8-b56f2a30b502', 'UNSOLD'),
('675ee0e9-2d6f-4a4a-b76f-feb3f5013219', '9914e768-fc9c-490e-b41b-449cd2a2e169', 'UNSOLD'),
('d72fe101-34cd-4a48-b7b6-db45bd202000', 'f4a536a7-a552-4a2f-a712-311771038845', 'UNSOLD'),
('6dab1f35-f1ae-4c95-9c58-8e3efd49abac', 'e3ac0a1b-8026-445e-b675-f84c2943f588', 'UNSOLD'),
('d24a4fc1-c8ca-418e-86db-6ed73aa65e44', '6d77b621-0798-49fe-b903-f02c1eb6ce11', 'UNSOLD'),
('dffea241-d655-4b4a-b3db-d9a8a4fff040', 'e33fe259-ff26-4a7f-a7f9-99c19cff8de6', 'UNSOLD'),
('67dbff83-efec-4091-83bc-8a568a01f41b', 'e775d162-2fed-4bb1-8e9b-d98fa6d4d3d1', 'UNSOLD'),
('288fcfe7-dd68-4a58-b9f1-03862af4966e', '1df70acd-aeb4-4b4e-b88f-6724e86d8633', 'UNSOLD'),
('06c6bf3b-f740-402a-9fb2-2a8021135ada', '3376d17f-5f10-45b8-8fe4-49b9e5a81609', 'UNSOLD');

INSERT INTO "AdminUser" (id, username, password_hash, role) VALUES
('6faca006-4050-4aeb-b8b5-1b17bf529aa3', 'admin', '$2b$10$5lN2qirsfBnjsKLDZRKS6eqlwIU65B4D9R6V3Nf6sAiyoUejzNpZC', 'ADMIN'),
('7681c79b-a552-49d6-923f-b9090ce79221', 'screen', '$2b$10$CPSvSCpCDszGpPLU44DJ0uBhQAI7sZeeGSxu5.Lq96Qt4Y1Cvz3Qa', 'SCREEN');

INSERT INTO "AuctionSequence" (id, name, type, sequence_items) VALUES
(1, 'Franchise Auction', 'FRANCHISE', '[3,7,1,9,5,10,2,6,8,4]');

INSERT INTO "AuctionSequence" (id, name, type, sequence_items) VALUES
(2, 'Power Card Auction', 'POWER_CARD', '["GOD_EYE","MULLIGAN","FINAL_STRIKE","BID_FREEZER"]');

INSERT INTO "AuctionSequence" (id, name, type, sequence_items) VALUES
(3, 'Player Auction 4', 'PLAYER', '[34,143,82,149,152,127,50,117,19,147,30,135,112,37,92,36,142,41,109,23,100,26,33,69,119,159,123,89,80,155,47,101,111,73,43,88,58,63,115,114,32,85,57,150,61,46,13,158,125,60,137,3,103,84,6,133,94,17,139,157,42,97,132,128,54,29,154,107,95,96,64,51,126,11,118,78,144,44,83,31,91,67,153,105,86,38,55,131,20,120,113,4,108,93,146,145,71,74,124,68,35,28,102,106,52,130,18,62,79,141,40,65,99,16,138,136,22,72,10,90,116,25,110,134,129,9,140,66,45,122,8,48,53,75,21,39,2,27,14,56,12,148,76,98,70,156,15,121,7,104,77,24,87,59,81,1,49,151,5]');

INSERT INTO "AuctionState" (id, phase, auction_day) VALUES (1, 'NOT_STARTED', 'Day 1');

