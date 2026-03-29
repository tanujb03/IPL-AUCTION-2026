-- INSTANCE 2 INITIALIZATION
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



-- ── DATA FOR INSTANCE 2 ──

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
('da9a8bf6-3dac-44cf-b735-3daa5cbdbc83', 'Yashowardhan Deshmukh', 'yashowardhandeshmukh', '$2b$10$yNItYfpaxyMxWdBkcO8PEuz67BTcwhdXI9Fpox2jLCl7jMOK8yInq', 120, 0),
('2f15cf6d-b1e5-4ff5-8f4f-7dccc7998a71', 'Strategic Strikers', 'strategicstrikers', '$2b$10$jA5bdvJ2REVXzTHYXAjKbOECKXMLsNPNXyPQCBbZ5LbehAAzxdC.e', 120, 0),
('f922c1f2-c4ec-401d-9ca1-fafb4fe49c41', 'Royal Challengers Mumbai', 'royalchallengersmumb', '$2b$10$rqSP3qog5yJH0SEZv/vFMeqaABNs/EyJCcSGC.NxtoLItAzz2fndq', 120, 0),
('1d06affc-f183-4010-8ac9-80f039131d4d', 'Gully Gang', 'gullygang', '$2b$10$m8LFbUometANnzZ2ExO8Wuhj9OKFCsOgpI2xb1dH7iVCv1l4wy98K', 120, 0),
('979d4c40-d595-4428-90e1-e980b181fbdd', 'Rangers', 'rangers', '$2b$10$O/g3ZN7gIabVp541uTuS2.b8ebFPgexRzwHl1MAOQahNXZcgTqMMC', 120, 0),
('f7026d07-71ad-4264-b73b-a74b2a07599b', 'DOPA', 'dopa', '$2b$10$gdFK.mjJdg9B6mTU.nVCPep5XplaU/7DkhfJtnwuE07PWXGx2uGVG', 120, 0),
('faf4e54b-44d5-4830-b503-84ca5ad6e368', 'Conquerors', 'conquerors', '$2b$10$kzhJd.NEimkoG2xaA9PLsukCNZqaGfiH7kXrJrxB3S.FfpM7076L2', 120, 0),
('8ee3f601-dc49-4ecd-b047-c82704337ea2', 'chambal ke daaku', 'chambalkedaaku', '$2b$10$7I0EgrzCYeSnL6RU55M9puEwR5bMuBBnlHTTpqGoUKiOZIC6PWsWm', 120, 0),
('587c3510-e15b-4863-9237-7c33a196be14', 'Bibtya Warriors', 'bibtyawarriors', '$2b$10$dO8b8G2s5U/tubNrtHoDVOpGxkWzWtnn.9PuHqpLV9VLnIZnuSpce', 120, 0),
('a2388cf1-d96a-43be-8d36-8946373c4b5b', 'AN1227', 'an1227', '$2b$10$7bRrqqPA40Aczx9TcxD/wO7QXHc4L3CiNzyl06nnCR11GyLpWtfJy', 120, 0);

INSERT INTO "Player" (id, rank, name, team, role, category, pool, grade, rating, nationality, nationality_raw, base_price, is_riddle, riddle_title, riddle_question, legacy, url, matches, bat_runs, bat_sr, bat_average, bowl_wickets, bowl_eco, bowl_avg, sub_scoring, sub_impact, sub_consistency, sub_experience, sub_wicket_taking, sub_economy, sub_efficiency, sub_batting, sub_bowling, sub_versatility) VALUES
('58787ff7-e58f-42e6-ba02-d080f146bc4f', 131, 'Romario Shepherd', 'Royal Challengers Bengaluru', 'Bowling Allrounder', 'AR', 'AR', 'C', 60, 'OVERSEAS', 'West Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/13646/romario-shepherd', 18.0, 185.0, NULL, NULL, 10.0, NULL, NULL, NULL, NULL, NULL, 39, NULL, NULL, NULL, 52.0, 18.0, 18.0),
('7a74b117-6afe-4502-9ac7-94e49e40b00a', 134, 'Vipraj Nigam', 'Delhi Capitals', 'Bowler', 'BOWL', 'BOWL', 'C', 59, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/1431811/vipraj-nigam', 14.0, NULL, NULL, NULL, 11.0, 9.13, 32.36, NULL, NULL, NULL, 37, 10.0, 54.0, 69.0, NULL, NULL, NULL),
('f66f8fd7-4328-40fc-9957-7e86ed6288b5', 149, 'Glenn Phillips', 'Gujarat Titans', 'Batting Allrounder', 'AR', 'AR', 'C', 56, 'OVERSEAS', 'New Zealander', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/10693/glenn-phillips', 8.0, 65.0, NULL, NULL, 2.0, NULL, NULL, NULL, NULL, NULL, 34, NULL, NULL, NULL, 24.0, 34.0, 24.0),
('e148249e-d52c-40b8-b386-fda2bc74224e', 69, 'Liam Livingstone', 'Sunrisers Hyderabad', 'Batting Allrounder', 'AR', 'AR', 'B', 70, 'OVERSEAS', 'English', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/10045/liam-livingstone', 49.0, 1051.0, NULL, NULL, 13.0, NULL, NULL, NULL, NULL, NULL, 54, NULL, NULL, NULL, 70.0, 28.0, 28.0),
('a23be824-2d58-42e0-ab78-5f86eec5ebdb', 81, 'Harpreet Brar', 'Punjab Kings', 'Bowler', 'BOWL', 'BOWL', 'C', 68, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/14452/harpreet-brar', 49.0, NULL, NULL, NULL, 35.0, 8.03, 31.0, NULL, NULL, NULL, 54, 26.0, 71.0, 72.0, NULL, NULL, NULL),
('73672ad0-b2ec-4c04-b9dc-a5c44b8dcfcb', 66, 'Philip Salt', 'Royal Challengers Bengaluru', 'WK-Batsman', 'WK', 'BAT_WK', 'B', 71, 'OVERSEAS', 'English', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/10479/philip-salt', 34.0, 1056.0, 175.71, 34.06, NULL, NULL, NULL, 23.0, 95.0, 84.0, 47, NULL, NULL, NULL, NULL, NULL, NULL),
('d2cd3fec-1006-4714-be2c-0bc1b2da069d', 26, 'Jaydev Unadkat', 'Sunrisers Hyderabad', 'Bowler', 'BOWL', 'BOWL', 'B', 83, 'INDIAN', 'Indian', 1, false, NULL, NULL, 2, 'https://www.cricbuzz.com/profiles/6327/jaydev-unadkat', 112.0, NULL, NULL, NULL, 110.0, 8.88, 30.58, NULL, NULL, NULL, 86, 74.0, 58.0, 73.0, NULL, NULL, NULL),
('4a3d9e71-aa5e-4cf8-ab01-e8abc7242aa4', 34, 'Quinton de Kock', 'Mumbai Indians', 'WK-Batsman', 'WK', 'BAT_WK', 'B', 79, 'OVERSEAS', 'South African', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/8520/quinton-de-kock', 115.0, 3309.0, 134.03, 30.64, NULL, NULL, NULL, 64.0, 67.0, 76.0, 87, NULL, NULL, NULL, NULL, NULL, NULL),
('7fccb1c8-a6e3-424f-a2d3-f18b07262994', 84, 'Cameron Green', 'Kolkata Knight Riders', 'Batting Allrounder', 'AR', 'AR', 'C', 68, 'OVERSEAS', 'Australian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/12225/cameron-green', 29.0, 707.0, NULL, NULL, 16.0, NULL, NULL, NULL, NULL, NULL, 44, NULL, NULL, NULL, 64.0, 27.0, 27.0),
('2386dfa8-5e20-4848-8ffe-4b489d960890', 23, 'Shubman Gill', 'Gujarat Titans', 'Batsman', 'BAT', 'BAT_WK', 'B', 84, 'INDIAN', 'Indian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/11808/shubman-gill', 118.0, 3866.0, 138.72, 39.45, NULL, NULL, NULL, 74.0, 70.0, 98.0, 89, NULL, NULL, NULL, NULL, NULL, NULL),
('37666c86-0432-4129-b2e8-c5d557377883', 116, 'Sherfane Rutherford', 'Mumbai Indians', 'Batting Allrounder', 'AR', 'AR', 'C', 62, 'OVERSEAS', 'West Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/13748/sherfane-rutherford', 23.0, 397.0, NULL, NULL, 1.0, NULL, NULL, NULL, NULL, NULL, 41, NULL, NULL, NULL, 48.0, 17.0, 17.0),
('73034e9f-1154-4f9d-9cd4-186dd8f14dcd', 155, 'Swapnil Singh', 'Royal Challengers Bengaluru', 'Bowling Allrounder', 'AR', 'AR', 'C', 56, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/10238/swapnil-singh', 14.0, 51.0, NULL, NULL, 7.0, NULL, NULL, NULL, NULL, NULL, 37, NULL, NULL, NULL, 23.0, 27.0, 23.0),
('a049bb10-9081-44d6-b909-1cd49a9fc8a7', 123, 'Ayush Mhatre', 'Chennai Super Kings', 'Batsman', 'BAT', 'BAT_WK', 'C', 61, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/1431163/ayush-mhatre', 7.0, 240.0, 188.98, 34.29, NULL, NULL, NULL, 8.0, 99.0, 85.0, 33, NULL, NULL, NULL, NULL, NULL, NULL),
('914fa046-e88f-4189-ab0f-a73645b02044', 124, 'Shubham Dubey', 'Rajasthan Royals', 'Batsman', 'BAT', 'BAT_WK', 'C', 61, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/19328/shubham-dubey', 13.0, 139.0, 163.53, 23.17, NULL, NULL, NULL, 6.0, 87.0, 58.0, 36, NULL, NULL, NULL, NULL, NULL, NULL),
('8987ed1b-265e-4daa-b66c-9ba949abcd3b', 142, 'Kamindu Mendis', 'Sunrisers Hyderabad', 'Batting Allrounder', 'AR', 'AR', 'C', 57, 'OVERSEAS', 'Sri Lankan', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/10940/kamindu-mendis', 5.0, 92.0, NULL, NULL, 2.0, NULL, NULL, NULL, NULL, NULL, 32, NULL, NULL, NULL, 38.0, 29.0, 29.0),
('79dbda6d-4478-4eef-8075-cca41362ae34', 148, 'Vignesh Puthur', 'Rajasthan Royals', 'Bowler', 'BOWL', 'BOWL', 'C', 57, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/1447337/vignesh-puthur', 5.0, NULL, NULL, NULL, 6.0, 9.08, 18.17, NULL, NULL, NULL, 32, 7.0, 54.0, 99.0, NULL, NULL, NULL),
('cc436107-f8b5-4893-b81c-a5b92409434e', 101, 'Umran Malik', 'Kolkata Knight Riders', 'Bowler', 'BOWL', 'BOWL', 'C', 65, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/19027/umran-malik', 26.0, NULL, NULL, NULL, 29.0, 9.4, 26.62, NULL, NULL, NULL, 43, 22.0, 49.0, 81.0, NULL, NULL, NULL),
('be62c33c-ff39-45c7-9c63-c398483c1fd3', 94, 'Will Jacks', 'Mumbai Indians', 'Batting Allrounder', 'AR', 'AR', 'C', 66, 'OVERSEAS', 'English', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/12258/will-jacks', 21.0, 463.0, NULL, NULL, 8.0, NULL, NULL, NULL, NULL, NULL, 40, NULL, NULL, NULL, 55.0, 28.0, 28.0),
('b2833e39-c23e-47e1-bfdb-adf5ff823cca', 119, 'Wanindu Hasaranga', 'Lucknow Super Giants', 'Bowling Allrounder', 'AR', 'AR', 'C', 62, 'OVERSEAS', 'Sri Lankan', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/10926/wanindu-hasaranga', 37.0, 81.0, NULL, NULL, 46.0, NULL, NULL, NULL, NULL, NULL, 48, NULL, NULL, NULL, 15.0, 45.0, 15.0),
('dabe431c-f0e8-4224-ac22-28128dec58eb', 76, 'Tristan Stubbs', 'Delhi Capitals', 'WK-Batsman', 'WK', 'BAT_WK', 'B', 70, 'OVERSEAS', 'South African', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/19243/tristan-stubbs', 32.0, 705.0, 163.2, 41.47, NULL, NULL, NULL, 17.0, 87.0, 99.0, 46, NULL, NULL, NULL, NULL, NULL, NULL),
('eec84412-4df9-4ee1-bca5-1ecab4a39556', 135, 'Kartik Tyagi', 'Kolkata Knight Riders', 'Bowler', 'BOWL', 'BOWL', 'C', 58, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/13136/kartik-tyagi', 20.0, NULL, NULL, NULL, 15.0, 10.14, 47.53, NULL, NULL, NULL, 40, 13.0, 37.0, 37.0, NULL, NULL, NULL),
('57c59d73-fee1-4c12-8480-f0ad407df344', 115, 'Rachin Ravindra', 'Kolkata Knight Riders', 'Batting Allrounder', 'AR', 'AR', 'C', 62, 'OVERSEAS', 'New Zealander', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/11177/rachin-ravindra', 18.0, 413.0, NULL, NULL, 0.0, NULL, NULL, NULL, NULL, NULL, 39, NULL, NULL, NULL, 49.0, 29.0, 29.0),
('db9fb571-0f27-4c34-9ef8-03fcff3e7218', 147, 'Mayank Yadav', 'Lucknow Super Giants', 'Bowler', 'BOWL', 'BOWL', 'C', 57, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/22401/mayank-yadav', 6.0, NULL, NULL, NULL, 9.0, 9.17, 20.56, NULL, NULL, NULL, 33, 9.0, 53.0, 94.0, NULL, NULL, NULL),
('1ef6148f-4eb7-4d92-88d9-c1927991a588', 19, 'Hardik Pandya', 'Mumbai Indians', 'Batting Allrounder', 'AR', 'AR', 'A', 89, 'INDIAN', 'Indian', 2, false, NULL, NULL, 6, 'https://www.cricbuzz.com/profiles/9647/hardik-pandya', 152.0, 2749.0, NULL, NULL, 78.0, NULL, NULL, NULL, NULL, NULL, 99, NULL, NULL, NULL, 90.0, 50.0, 50.0),
('63633ea3-d158-4ecd-8d71-c511a557f372', 43, 'Abhishek Sharma', 'Sunrisers Hyderabad', 'Batting Allrounder', 'AR', 'AR', 'B', 77, 'INDIAN', 'Indian', 1, false, NULL, NULL, 2, 'https://www.cricbuzz.com/profiles/12086/abhishek-sharma', 77.0, 1815.0, NULL, NULL, 11.0, NULL, NULL, NULL, NULL, NULL, 68, NULL, NULL, NULL, 90.0, 24.0, 24.0),
('9decd6a2-a5e0-4ee8-8033-25b9df31cda8', 1, 'Virat Kohli', 'Royal Challengers Bengaluru', 'Batsman', 'BAT', 'BAT_WK', 'A', 99, 'INDIAN', 'Indian', 2, false, NULL, NULL, 10, 'https://www.cricbuzz.com/profiles/1413/virat-kohli', 267.0, 8661.0, 132.86, 39.55, NULL, NULL, NULL, 99.0, 67.0, 98.0, 99, NULL, NULL, NULL, NULL, NULL, NULL),
('39f21ecc-2ce1-44a6-ba81-ec00da05c6f6', 80, 'Lockie Ferguson', 'Punjab Kings', 'Bowler', 'BOWL', 'BOWL', 'C', 69, 'OVERSEAS', 'New Zealander', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/10692/lockie-ferguson', 49.0, NULL, NULL, NULL, 51.0, 8.97, 30.0, NULL, NULL, NULL, 54, 36.0, 56.0, 74.0, NULL, NULL, NULL),
('a03021cf-26b1-480f-b440-63563a5528d3', 30, 'Rishabh Pant', 'Lucknow Super Giants', 'WK-Batsman', 'WK', 'BAT_WK', 'B', 82, 'INDIAN', 'Indian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/10744/rishabh-pant', 125.0, 3553.0, 147.62, 34.16, NULL, NULL, NULL, 68.0, 76.0, 85.0, 92, NULL, NULL, NULL, NULL, NULL, NULL),
('e357efee-f2a9-482e-b469-b0145a669913', 68, 'Anrich Nortje', 'Lucknow Super Giants', 'Bowler', 'BOWL', 'BOWL', 'B', 71, 'OVERSEAS', 'South African', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/11427/anrich-nortje', 48.0, NULL, NULL, NULL, 61.0, 9.07, 27.16, NULL, NULL, NULL, 54, 43.0, 55.0, 80.0, NULL, NULL, NULL),
('85fa9d7c-5a56-42ae-b2a5-03142a6fa03b', 85, 'Mohsin Khan', 'Lucknow Super Giants', 'Bowler', 'BOWL', 'BOWL', 'C', 67, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/13534/mohsin-khan', 24.0, NULL, NULL, NULL, 27.0, 8.51, 25.52, NULL, NULL, NULL, 42, 21.0, 64.0, 83.0, NULL, NULL, NULL),
('413a4a2f-19d3-4972-806b-083253ed807a', 109, 'Abdul Samad', 'Lucknow Super Giants', 'Batting Allrounder', 'AR', 'AR', 'C', 63, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/14628/abdul-samad', 63.0, 741.0, NULL, NULL, 2.0, NULL, NULL, NULL, NULL, NULL, 61, NULL, NULL, NULL, 57.0, 5.0, 5.0),
('df5f1ed5-bb87-46c6-b26c-ae9c97b70dd4', 118, 'Aniket Verma', 'Sunrisers Hyderabad', 'Batsman', 'BAT', 'BAT_WK', 'C', 62, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/1447065/aniket-verma', 14.0, 236.0, 166.2, 26.22, NULL, NULL, NULL, 8.0, 89.0, 65.0, 37, NULL, NULL, NULL, NULL, NULL, NULL),
('cc9c507e-88ba-4d9e-a9b0-c462caa66ca9', 100, 'Abishek Porel', 'Delhi Capitals', 'WK-Batsman', 'WK', 'BAT_WK', 'C', 66, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/24326/abishek-porel', 31.0, 661.0, 149.89, 25.42, NULL, NULL, NULL, 16.0, 78.0, 63.0, 45, NULL, NULL, NULL, NULL, NULL, NULL),
('f3684dd3-137b-4a3c-a2a5-16d287191102', 58, 'Riyan Parag', 'Rajasthan Royals', 'Batting Allrounder', 'AR', 'AR', 'B', 73, 'INDIAN', 'Indian', 1, false, NULL, NULL, 2, 'https://www.cricbuzz.com/profiles/12305/riyan-parag', 83.0, 1566.0, NULL, NULL, 7.0, NULL, NULL, NULL, NULL, NULL, 71, NULL, NULL, NULL, 78.0, 16.0, 16.0),
('ac1b8404-994d-4fd6-af16-77f5f4b91091', 7, 'Ravindra Jadeja', 'Rajasthan Royals', 'Bowling Allrounder', 'AR', 'AR', 'A', 95, 'INDIAN', 'Indian', 2, false, NULL, NULL, 8, 'https://www.cricbuzz.com/profiles/587/ravindra-jadeja', 254.0, 3260.0, NULL, NULL, 170.0, NULL, NULL, NULL, NULL, NULL, 99, NULL, NULL, NULL, 85.0, 78.0, 78.0),
('2737a997-1ef5-4ebe-8d21-5f7bc3f52ddf', 120, 'Ravisrinivasan Sai Kishore', 'Gujarat Titans', 'Bowling Allrounder', 'AR', 'AR', 'C', 61, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/11595/ravisrinivasan-sai-kishore', 25.0, 18.0, NULL, NULL, 32.0, NULL, NULL, NULL, NULL, NULL, 42, NULL, NULL, NULL, 19.0, 41.0, 19.0),
('cbea32a7-c4bd-438f-a20c-61235b19a74f', 122, 'Ashutosh Sharma', 'Delhi Capitals', 'Batting Allrounder', 'AR', 'AR', 'C', 61, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/13497/ashutosh-sharma', 24.0, 393.0, NULL, NULL, 0.0, NULL, NULL, NULL, NULL, NULL, 42, NULL, NULL, NULL, 56.0, 0.0, 0.0),
('901f7acb-959f-4c3f-a061-a94f7462902b', 128, 'Yash Thakur', 'Punjab Kings', 'Bowler', 'BOWL', 'BOWL', 'C', 61, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/12096/yash-thakur', 21.0, NULL, NULL, NULL, 25.0, 10.43, 30.8, NULL, NULL, NULL, 40, 20.0, 32.0, 72.0, NULL, NULL, NULL),
('53ab066a-e592-47bf-9d16-a779b0df964c', 130, 'Sameer Rizvi', 'Delhi Capitals', 'Batsman', 'BAT', 'BAT_WK', 'C', 60, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/14700/sameer-rizvi', 13.0, 172.0, 140.99, 24.57, NULL, NULL, NULL, 7.0, 72.0, 61.0, 36, NULL, NULL, NULL, NULL, NULL, NULL),
('7024eef6-2575-4a70-9889-205b3ff78e60', 64, 'Shreyas Gopal', 'Chennai Super Kings', 'Bowler', 'BOWL', 'BOWL', 'B', 72, 'INDIAN', 'Indian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/9746/shreyas-gopal', 52.0, NULL, NULL, NULL, 52.0, 8.16, 25.92, NULL, NULL, NULL, 56, 37.0, 69.0, 83.0, NULL, NULL, NULL),
('669a6008-c419-41ce-b141-bbefbbd61ce3', 121, 'Suyash Sharma', 'Royal Challengers Bengaluru', 'Bowler', 'BOWL', 'BOWL', 'C', 61, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/36487/suyash-sharma', 27.0, NULL, NULL, NULL, 18.0, 8.75, 45.22, NULL, NULL, NULL, 43, 15.0, 60.0, 41.0, NULL, NULL, NULL),
('9fd05243-38c8-4a56-a79f-2e8df8ab71a5', 144, 'Vijaykumar Vyshak', 'Punjab Kings', 'Bowler', 'BOWL', 'BOWL', 'C', 57, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/10486/vijaykumar-vyshak', 16.0, NULL, NULL, NULL, 17.0, 10.38, 33.88, NULL, NULL, NULL, 38, 14.0, 33.0, 66.0, NULL, NULL, NULL),
('95e30748-4b1a-4cf6-8e37-a1ddcfe512b0', 24, 'Varun Chakaravarthy', 'Kolkata Knight Riders', 'Bowler', 'BOWL', 'BOWL', 'B', 84, 'INDIAN', 'Indian', 1, false, NULL, NULL, 2, 'https://www.cricbuzz.com/profiles/12926/varun-chakaravarthy', 83.0, NULL, NULL, NULL, 100.0, 7.58, 23.85, NULL, NULL, NULL, 71, 68.0, 79.0, 87.0, NULL, NULL, NULL),
('b6b04a67-f2bc-438c-9952-d18c7a8240e3', 42, 'Ruturaj Gaikwad', 'Chennai Super Kings', 'Batsman', 'BAT', 'BAT_WK', 'B', 77, 'INDIAN', 'Indian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/11813/ruturaj-gaikwad', 71.0, 2502.0, 137.48, 40.35, NULL, NULL, NULL, 49.0, 70.0, 99.0, 65, NULL, NULL, NULL, NULL, NULL, NULL),
('515d4893-cf8e-465f-8d84-5917c8a37b44', 137, 'Jayant Yadav', 'Gujarat Titans', 'Bowling Allrounder', 'AR', 'AR', 'C', 58, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/8182/jayant-yadav', 20.0, 40.0, NULL, NULL, 8.0, NULL, NULL, NULL, NULL, NULL, 40, NULL, NULL, NULL, 22.0, 25.0, 22.0),
('bb0bc6fb-7525-4fba-ba67-c8cf27823d87', 133, 'Kyle Jamieson', 'Delhi Capitals', 'Bowler', 'BOWL', 'BOWL', 'C', 59, 'OVERSEAS', 'New Zealander', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/9441/kyle-jamieson', 13.0, NULL, NULL, NULL, 14.0, 9.67, 29.71, NULL, NULL, NULL, 36, 12.0, 45.0, 74.0, NULL, NULL, NULL),
('5bd620ee-7930-49ea-b841-4268a7fb9e6b', 141, 'Eshan Malinga', 'Sunrisers Hyderabad', 'Bowler', 'BOWL', 'BOWL', 'C', 58, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/46926/eshan-malinga', 7.0, NULL, NULL, NULL, 13.0, 8.93, 18.31, NULL, NULL, NULL, 33, 12.0, 57.0, 99.0, NULL, NULL, NULL),
('14c9c436-b1a6-429c-bdeb-176b2bcdc6f8', 88, 'Harshit Rana', 'Kolkata Knight Riders', 'Bowler', 'BOWL', 'BOWL', 'C', 67, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/24729/harshit-rana', 33.0, NULL, NULL, NULL, 40.0, 9.51, 25.73, NULL, NULL, NULL, 46, 29.0, 47.0, 83.0, NULL, NULL, NULL),
('28e55a4d-3731-4b8e-b523-e23048dfce67', 74, 'Devdutt Padikkal', 'Royal Challengers Bengaluru', 'Batsman', 'BAT', 'BAT_WK', 'B', 70, 'INDIAN', 'Indian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/13088/devdutt-padikkal', 74.0, 1806.0, 126.3, 25.44, NULL, NULL, NULL, 37.0, 62.0, 64.0, 67, NULL, NULL, NULL, NULL, NULL, NULL),
('db92a924-673e-4a09-8c1e-e47d5e680f9c', 60, 'Noor Ahmad', 'Chennai Super Kings', 'Bowler', 'BOWL', 'BOWL', 'B', 72, 'OVERSEAS', 'Afghan', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/15452/noor-ahmad', 37.0, NULL, NULL, NULL, 48.0, 8.08, 22.23, NULL, NULL, NULL, 48, 34.0, 71.0, 90.0, NULL, NULL, NULL),
('fb51b78f-7a83-43f5-b13c-3a155f959802', 29, 'Mohammed Siraj', 'Gujarat Titans', 'Bowler', 'BOWL', 'BOWL', 'B', 83, 'INDIAN', 'Indian', 1, false, NULL, NULL, 2, 'https://www.cricbuzz.com/profiles/10808/mohammed-siraj', 108.0, NULL, NULL, NULL, 109.0, 8.74, 30.72, NULL, NULL, NULL, 84, 74.0, 60.0, 72.0, NULL, NULL, NULL),
('45be1e04-23ec-4dbe-8fe2-ec38d409f2d3', 106, 'Sarfaraz Khan', 'Chennai Super Kings', 'Batsman', 'BAT', 'BAT_WK', 'C', 64, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/9429/sarfaraz-khan', 50.0, 585.0, 130.59, 22.5, NULL, NULL, NULL, 15.0, 65.0, 56.0, 55, NULL, NULL, NULL, NULL, NULL, NULL),
('18e57050-cbb9-4746-bfc9-f32ee0e48ba4', 159, 'Rasikh Dar Salam', 'Royal Challengers Bengaluru', 'Bowler', 'BOWL', 'BOWL', 'C', 55, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/14274/rasikh-dar-salam', 13.0, NULL, NULL, NULL, 10.0, 10.62, 40.9, NULL, NULL, NULL, 36, 10.0, 29.0, 51.0, NULL, NULL, NULL),
('445279fa-f3b6-4969-b49e-304b5be79a0c', 59, 'Rahul Tewatia', 'Gujarat Titans', 'Batting Allrounder', 'AR', 'AR', 'B', 73, 'INDIAN', 'Indian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/9693/rahul-tewatia', 108.0, 1112.0, NULL, NULL, 32.0, NULL, NULL, NULL, NULL, NULL, 84, NULL, NULL, NULL, 64.0, 38.0, 38.0),
('d9f9bbcc-bb55-4744-ad66-096cf38f6ddb', 97, 'Ramandeep Singh', 'Kolkata Knight Riders', 'Batting Allrounder', 'AR', 'AR', 'C', 66, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/12337/ramandeep-singh', 30.0, 217.0, NULL, NULL, 6.0, NULL, NULL, NULL, NULL, NULL, 45, NULL, NULL, NULL, 46.0, 35.0, 35.0),
('91535ff1-b9f8-4ab4-bc23-63bed99df48d', 49, 'Ravi Bishnoi', 'Rajasthan Royals', 'Bowler', 'BOWL', 'BOWL', 'B', 75, 'INDIAN', 'Indian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/14659/ravi-bishnoi', 77.0, NULL, NULL, NULL, 72.0, 8.22, 31.07, NULL, NULL, NULL, 68, 50.0, 68.0, 72.0, NULL, NULL, NULL),
('45893609-c5ef-4891-babe-76fd44c1d543', 92, 'Shashank Singh', 'Punjab Kings', 'Batting Allrounder', 'AR', 'AR', 'C', 67, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/10919/shashank-singh', 41.0, 773.0, NULL, NULL, 1.0, NULL, NULL, NULL, NULL, NULL, 50, NULL, NULL, NULL, 67.0, 14.0, 14.0),
('efcfdd37-b78a-4ea6-a3e4-9511f7d7cf3f', 78, 'Rajat Patidar', 'Royal Challengers Bengaluru', 'Batsman', 'BAT', 'BAT_WK', 'C', 69, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/10636/rajat-patidar', 42.0, 1111.0, 154.31, 30.86, NULL, NULL, NULL, 24.0, 81.0, 77.0, 51, NULL, NULL, NULL, NULL, NULL, NULL),
('14b1ec6a-493f-4c24-bb68-5bdd9b9473c9', 151, 'Dushmantha Chameera', 'Delhi Capitals', 'Bowler', 'BOWL', 'BOWL', 'C', 56, 'OVERSEAS', 'Sri Lankan', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/8393/dushmantha-chameera', 19.0, NULL, NULL, NULL, 13.0, 9.73, 46.38, NULL, NULL, NULL, 39, 12.0, 44.0, 39.0, NULL, NULL, NULL),
('b77d35f6-08e9-41bf-8c02-5e050d57cd06', 47, 'Yashasvi Jaiswal', 'Rajasthan Royals', 'Batsman', 'BAT', 'BAT_WK', 'B', 75, 'INDIAN', 'Indian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/13940/yashasvi-jaiswal', 66.0, 2166.0, 152.86, 34.38, NULL, NULL, NULL, 43.0, 80.0, 85.0, 63, NULL, NULL, NULL, NULL, NULL, NULL),
('0ee1d03e-f5cc-4c9a-be74-35a3b32b149a', 82, 'Jitesh Sharma', 'Royal Challengers Bengaluru', 'WK-Batsman', 'WK', 'BAT_WK', 'C', 68, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/10214/jitesh-sharma', 55.0, 991.0, 157.06, 25.41, NULL, NULL, NULL, 22.0, 83.0, 63.0, 57, NULL, NULL, NULL, NULL, NULL, NULL),
('1e8d8303-e216-4d5d-a153-ab3a89802d55', 77, 'Rinku Singh', 'Kolkata Knight Riders', 'Batsman', 'BAT', 'BAT_WK', 'C', 69, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/10896/rinku-singh', 58.0, 1099.0, 145.18, 30.53, NULL, NULL, NULL, 24.0, 75.0, 76.0, 59, NULL, NULL, NULL, NULL, NULL, NULL),
('c17f5513-c88c-4b71-ade7-6f478ca0e982', 140, 'Mukesh Choudhary', 'Chennai Super Kings', 'Bowler', 'BOWL', 'BOWL', 'C', 58, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/13184/mukesh-choudhary', 16.0, NULL, NULL, NULL, 17.0, 9.94, 30.71, NULL, NULL, NULL, 38, 14.0, 40.0, 72.0, NULL, NULL, NULL),
('72df0a74-9ac6-4efd-9206-fb2a69416aed', 98, 'Shivam Mavi', 'Sunrisers Hyderabad', 'Bowler', 'BOWL', 'BOWL', 'C', 66, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/12345/shivam-mavi', 32.0, NULL, NULL, NULL, 30.0, 8.71, 31.4, NULL, NULL, NULL, 46, 23.0, 60.0, 71.0, NULL, NULL, NULL),
('515eb6fc-3c88-49c8-95cf-079a973f7c58', 72, 'Aiden Markram', 'Lucknow Super Giants', 'Batsman', 'BAT', 'BAT_WK', 'B', 70, 'OVERSEAS', 'South African', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/9582/aiden-markram', 57.0, 1440.0, 135.09, 31.3, NULL, NULL, NULL, 30.0, 68.0, 78.0, 58, NULL, NULL, NULL, NULL, NULL, NULL),
('fac281b4-014a-4847-8deb-7830d89a7fb8', 62, 'Shimron Hetmyer', 'Rajasthan Royals', 'Batsman', 'BAT', 'BAT_WK', 'B', 72, 'OVERSEAS', 'West Indian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/9789/shimron-hetmyer', 86.0, 1482.0, 151.85, 29.06, NULL, NULL, NULL, 31.0, 79.0, 72.0, 73, NULL, NULL, NULL, NULL, NULL, NULL),
('e154a840-5d74-4618-86cc-bd4dd6206d9f', 102, 'Angkrish Raghuvanshi', 'Kolkata Knight Riders', 'Batsman', 'BAT', 'BAT_WK', 'C', 65, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/22566/angkrish-raghuvanshi', 22.0, 463.0, 144.69, 28.94, NULL, NULL, NULL, 12.0, 75.0, 72.0, 41, NULL, NULL, NULL, NULL, NULL, NULL),
('ed3f0310-0972-4ca4-b9d0-44dd95ab7a78', 63, 'T Natarajan', 'Delhi Capitals', 'Bowler', 'BOWL', 'BOWL', 'B', 72, 'INDIAN', 'Indian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/10225/t-natarajan', 63.0, NULL, NULL, NULL, 67.0, 8.94, 30.12, NULL, NULL, NULL, 61, 47.0, 57.0, 74.0, NULL, NULL, NULL),
('a2abe584-2670-4303-8241-2e975e085752', 5, 'Bhuvneshwar Kumar', 'Royal Challengers Bengaluru', 'Bowler', 'BOWL', 'BOWL', 'A', 98, 'INDIAN', 'Indian', 2, false, NULL, NULL, 8, 'https://www.cricbuzz.com/profiles/1726/bhuvneshwar-kumar', 190.0, NULL, NULL, NULL, 198.0, 7.69, 27.33, NULL, NULL, NULL, 99, 99.0, 77.0, 80.0, NULL, NULL, NULL),
('a1724551-e508-4319-85f9-f0b7aefe2fae', 136, 'Arshad Khan', 'Gujarat Titans', 'Bowling Allrounder', 'AR', 'AR', 'C', 58, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/18637/arshad-khan', 19.0, 124.0, NULL, NULL, 12.0, NULL, NULL, NULL, NULL, NULL, 39, NULL, NULL, NULL, 39.0, 18.0, 18.0),
('2bdc3c2c-a674-4f95-8076-43bb423a5007', 93, 'Washington Sundar', 'Gujarat Titans', 'Bowling Allrounder', 'AR', 'AR', 'C', 67, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/10945/washington-sundar', 66.0, 511.0, NULL, NULL, 39.0, NULL, NULL, NULL, NULL, NULL, 63, NULL, NULL, NULL, 42.0, 40.0, 40.0),
('e87ca0fa-f37d-4492-b4ac-66c4e21e5d37', 71, 'Matheesha Pathirana', 'Kolkata Knight Riders', 'Bowler', 'BOWL', 'BOWL', 'B', 70, 'OVERSEAS', 'Sri Lankan', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/16458/matheesha-pathirana', 32.0, NULL, NULL, NULL, 47.0, 8.68, 21.62, NULL, NULL, NULL, 46, 34.0, 61.0, 92.0, NULL, NULL, NULL),
('7220c4ae-4463-49dd-b514-88b6556d6748', 146, 'Anshul Kamboj', 'Chennai Super Kings', 'Bowling Allrounder', 'AR', 'AR', 'C', 57, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/14598/anshul-kamboj', 11.0, 16.0, NULL, NULL, 10.0, NULL, NULL, NULL, NULL, NULL, 35, NULL, NULL, NULL, 21.0, 30.0, 21.0),
('540e69f2-8f3e-4861-92b0-011272c6f9af', 153, 'Urvil Patel', 'Chennai Super Kings', 'WK-Batsman', 'WK', 'BAT_WK', 'C', 56, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/13476/urvil-patel', 3.0, 68.0, 212.5, 22.67, NULL, NULL, NULL, 5.0, 99.0, 57.0, 31, NULL, NULL, NULL, NULL, NULL, NULL),
('eb0aa390-39c2-4970-aedb-66f42677843e', 40, 'Rahul Chahar', 'Chennai Super Kings', 'Bowler', 'BOWL', 'BOWL', 'B', 77, 'INDIAN', 'Indian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/12087/rahul-chahar', 79.0, NULL, NULL, NULL, 75.0, 7.72, 28.67, NULL, NULL, NULL, 69, 52.0, 76.0, 77.0, NULL, NULL, NULL),
('975c85fc-8fb0-4b6a-a000-b2ea4ea2f82e', 113, 'Marco Jansen', 'Punjab Kings', 'Bowling Allrounder', 'AR', 'AR', 'C', 62, 'OVERSEAS', 'South African', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/14565/marco-jansen', 35.0, 141.0, NULL, NULL, 36.0, NULL, NULL, NULL, NULL, NULL, 47, NULL, NULL, NULL, 26.0, 36.0, 26.0),
('cdb88385-cf62-467d-89e0-2d14581ca954', 48, 'Pat Cummins', 'Sunrisers Hyderabad', 'Bowler', 'BOWL', 'BOWL', 'B', 75, 'OVERSEAS', 'Australian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/8095/pat-cummins', 72.0, NULL, NULL, NULL, 79.0, 8.81, 30.04, NULL, NULL, NULL, 66, 54.0, 59.0, 74.0, NULL, NULL, NULL),
('8bc0174c-f199-4997-a9f6-08a0574fa8a4', 4, 'Sunil Narine', 'Kolkata Knight Riders', 'Bowling Allrounder', 'AR', 'AR', 'A', 98, 'OVERSEAS', 'West Indian', 2, false, NULL, NULL, 10, 'https://www.cricbuzz.com/profiles/2276/sunil-narine', 188.0, 1780.0, NULL, NULL, 192.0, NULL, NULL, NULL, NULL, NULL, 99, NULL, NULL, NULL, 84.0, 83.0, 83.0),
('d66dac8e-0434-43ec-b91d-b9a70fb4004c', 139, 'Nandre Burger', 'Rajasthan Royals', 'Bowler', 'BOWL', 'BOWL', 'C', 58, 'OVERSEAS', 'South African', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/13630/nandre-burger', 5.0, NULL, NULL, NULL, 7.0, 8.53, 20.71, NULL, NULL, NULL, 32, 8.0, 63.0, 94.0, NULL, NULL, NULL),
('5d01173b-0a7d-4401-94d4-a7f470941c54', 55, 'Mitchell Starc', 'Delhi Capitals', 'Bowler', 'BOWL', 'BOWL', 'B', 73, 'OVERSEAS', 'Australian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/7710/mitchell-starc', 51.0, NULL, NULL, NULL, 65.0, 8.61, 23.12, NULL, NULL, NULL, 55, 45.0, 62.0, 88.0, NULL, NULL, NULL),
('542cbf5c-6714-46bf-a78f-078cc4645bab', 107, 'Shahbaz Ahmed', 'Lucknow Super Giants', 'Bowling Allrounder', 'AR', 'AR', 'C', 64, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/14606/shahbaz-ahmed', 58.0, 545.0, NULL, NULL, 22.0, NULL, NULL, NULL, NULL, NULL, 59, NULL, NULL, NULL, 43.0, 27.0, 27.0),
('80fd8654-9c9f-478e-95d6-5a55e585e89f', 36, 'Arshdeep Singh', 'Punjab Kings', 'Bowler', 'BOWL', 'BOWL', 'B', 78, 'INDIAN', 'Indian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/13217/arshdeep-singh', 82.0, NULL, NULL, NULL, 97.0, 9.0, 26.49, NULL, NULL, NULL, 71, 66.0, 56.0, 81.0, NULL, NULL, NULL),
('ea346c5f-9708-4d14-83b5-762d14fd913e', 143, 'Prashant Solanki', 'Kolkata Knight Riders', 'Bowler', 'BOWL', 'BOWL', 'C', 57, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/12805/prashant-solanki', 2.0, NULL, NULL, NULL, 2.0, 6.33, 19.0, NULL, NULL, NULL, 31, 5.0, 99.0, 97.0, NULL, NULL, NULL),
('c163ad39-0584-4306-b49d-222d834f98f7', 99, 'Yash Dayal', 'Royal Challengers Bengaluru', 'Bowler', 'BOWL', 'BOWL', 'C', 66, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/14172/yash-dayal', 43.0, NULL, NULL, NULL, 41.0, 9.58, 33.9, NULL, NULL, NULL, 51, 30.0, 46.0, 66.0, NULL, NULL, NULL),
('f898caa0-85aa-4dad-90d7-6d02c42bb3f4', 41, 'Nitish Rana', 'Delhi Capitals', 'Batsman', 'BAT', 'BAT_WK', 'B', 77, 'INDIAN', 'Indian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/9204/nitish-rana', 118.0, 2853.0, 136.77, 27.7, NULL, NULL, NULL, 56.0, 69.0, 69.0, 89, NULL, NULL, NULL, NULL, NULL, NULL),
('7c58ef80-4aeb-4488-8768-da73209f947b', 152, 'Anukul Roy', 'Kolkata Knight Riders', 'Batting Allrounder', 'AR', 'AR', 'C', 56, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/12344/anukul-roy', 11.0, 26.0, NULL, NULL, 6.0, NULL, NULL, NULL, NULL, NULL, 35, NULL, NULL, NULL, 17.0, 29.0, 17.0),
('ae3d71a6-09a6-4b80-8631-4e0b76590839', 20, 'Jos Buttler', 'Gujarat Titans', 'WK-Batsman', 'WK', 'BAT_WK', 'A', 88, 'OVERSEAS', 'English', 2, false, NULL, NULL, 2, 'https://www.cricbuzz.com/profiles/2258/jos-buttler', 121.0, 4120.0, 149.39, 40.0, NULL, NULL, NULL, 79.0, 78.0, 99.0, 90, NULL, NULL, NULL, NULL, NULL, NULL),
('1057b877-033c-4c2e-a0f2-cf3693b07912', 54, 'Heinrich Klaasen', 'Sunrisers Hyderabad', 'WK-Batsman', 'WK', 'BAT_WK', 'B', 74, 'OVERSEAS', 'South African', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/10209/heinrich-klaasen', 49.0, 1480.0, 169.73, 40.0, NULL, NULL, NULL, 31.0, 91.0, 99.0, 54, NULL, NULL, NULL, NULL, NULL, NULL),
('d969be63-2cda-4038-b58e-f6f22e174790', 95, 'Nehal Wadhera', 'Punjab Kings', 'Batsman', 'BAT', 'BAT_WK', 'C', 66, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/13915/nehal-wadhera', 36.0, 719.0, 142.95, 26.63, NULL, NULL, NULL, 17.0, 73.0, 66.0, 48, NULL, NULL, NULL, NULL, NULL, NULL),
('3485c997-543e-4ea6-9626-60da696a6ed1', 32, 'David Miller', 'Delhi Capitals', 'Batsman', 'BAT', 'BAT_WK', 'B', 80, 'OVERSEAS', 'South African', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/6349/david-miller', 141.0, 3077.0, 138.61, 35.78, NULL, NULL, NULL, 60.0, 70.0, 89.0, 99, NULL, NULL, NULL, NULL, NULL, NULL),
('d3bdf365-3928-48bb-b9b1-1de4704dbb4b', 103, 'Priyansh Arya', 'Punjab Kings', 'Batsman', 'BAT', 'BAT_WK', 'C', 64, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/14689/priyansh-arya', 17.0, 475.0, 179.25, 27.94, NULL, NULL, NULL, 13.0, 98.0, 70.0, 38, NULL, NULL, NULL, NULL, NULL, NULL),
('976915ed-3187-4f69-b03b-bb513700d7ea', 111, 'Ryan Rickelton', 'Mumbai Indians', 'WK-Batsman', 'WK', 'BAT_WK', 'C', 62, 'OVERSEAS', 'South African', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/13070/ryan-rickelton', 14.0, 388.0, 150.98, 29.85, NULL, NULL, NULL, 11.0, 79.0, 74.0, 37, NULL, NULL, NULL, NULL, NULL, NULL),
('dadd5b00-7112-45a0-a418-7b1713232eae', 38, 'Shardul Thakur', 'Mumbai Indians', 'Bowling Allrounder', 'AR', 'AR', 'B', 78, 'INDIAN', 'Indian', 1, false, NULL, NULL, 6, 'https://www.cricbuzz.com/profiles/8683/shardul-thakur', 105.0, 325.0, NULL, NULL, 107.0, NULL, NULL, NULL, NULL, NULL, 82, NULL, NULL, NULL, 38.0, 59.0, 38.0),
('bf2a4e7c-95b7-4c29-9f4d-677408b817d9', 90, 'Naman Dhir', 'Mumbai Indians', 'Batsman', 'BAT', 'BAT_WK', 'C', 67, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/36139/naman-dhir', 23.0, 392.0, 180.65, 28.0, NULL, NULL, NULL, 11.0, 99.0, 70.0, 41, NULL, NULL, NULL, NULL, NULL, NULL),
('823a73e8-67f2-4131-80ba-1c8b653401b6', 79, 'Prabhsimran Singh', 'Punjab Kings', 'WK-Batsman', 'WK', 'BAT_WK', 'C', 69, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/14254/prabhsimran-singh', 51.0, 1305.0, 151.93, 25.59, NULL, NULL, NULL, 28.0, 79.0, 64.0, 55, NULL, NULL, NULL, NULL, NULL, NULL),
('3a0f2e65-8c4a-489b-ab83-bd7342a71d27', 96, 'Vaibhav Arora', 'Kolkata Knight Riders', 'Bowler', 'BOWL', 'BOWL', 'C', 66, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/15861/vaibhav-arora', 32.0, NULL, NULL, NULL, 36.0, 9.55, 28.22, NULL, NULL, NULL, 46, 27.0, 47.0, 78.0, NULL, NULL, NULL),
('b53609ad-d2b3-448f-8de1-dcb4181d42de', 12, 'Trent Boult', 'Mumbai Indians', 'Bowler', 'BOWL', 'BOWL', 'A', 92, 'OVERSEAS', 'New Zealander', 2, true, 'The First-Over Menace', 'I’m a smiling Kiwi whose absolute favorite hobby is completely destroying top orders in the very first over of a match. When I’m forced to hold a bat, you might catch me busting out my legendary "flamingo" defensive shot. After spending a few seasons causing chaos in pink, I am finally back home to lead the pace attack in blue and gold. Who am I?', 4, 'https://www.cricbuzz.com/profiles/8117/trent-boult', 119.0, NULL, NULL, NULL, 143.0, 8.38, 26.2, NULL, NULL, NULL, 89, 96.0, 66.0, 82.0, NULL, NULL, NULL),
('0e463fc4-0dea-4e7c-bd96-d09e21fb3bcb', 86, 'Mayank Markande', 'Mumbai Indians', 'Bowler', 'BOWL', 'BOWL', 'C', 67, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/12627/mayank-markande', 37.0, NULL, NULL, NULL, 37.0, 8.91, 28.89, NULL, NULL, NULL, 48, 27.0, 57.0, 76.0, NULL, NULL, NULL),
('8c07b19c-8d38-4d00-acc5-e8155c99a614', 158, 'Arjun Tendulkar', 'Lucknow Super Giants', 'Bowling Allrounder', 'AR', 'AR', 'C', 55, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/13747/arjun-tendulkar', 5.0, 13.0, NULL, NULL, 3.0, NULL, NULL, NULL, NULL, NULL, 32, NULL, NULL, NULL, 32.0, 23.0, 23.0),
('24d91560-bf52-434f-af36-8848e83d62f5', 46, 'Avesh Khan', 'Lucknow Super Giants', 'Bowler', 'BOWL', 'BOWL', 'B', 76, 'INDIAN', 'Indian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/9781/avesh-khan', 75.0, NULL, NULL, NULL, 87.0, 9.12, 28.29, NULL, NULL, NULL, 67, 60.0, 54.0, 77.0, NULL, NULL, NULL),
('1d4a97bc-4980-4cfd-aea9-e6ddfed69856', 104, 'Lungi Ngidi', 'Delhi Capitals', 'Bowler', 'BOWL', 'BOWL', 'C', 64, 'OVERSEAS', 'South African', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/9603/lungi-ngidi', 16.0, NULL, NULL, NULL, 29.0, 8.53, 18.24, NULL, NULL, NULL, 38, 22.0, 63.0, 99.0, NULL, NULL, NULL),
('67a441ec-56d9-4ffd-8c34-10da08362fa1', 75, 'Karun Nair', 'Delhi Capitals', 'Batsman', 'BAT', 'BAT_WK', 'B', 70, 'INDIAN', 'Indian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/8257/karun-nair', 84.0, 1694.0, 131.73, 23.86, NULL, NULL, NULL, 35.0, 66.0, 60.0, 72, NULL, NULL, NULL, NULL, NULL, NULL),
('6676eb33-80f4-458e-8675-9862bdf71789', 18, 'Rashid Khan', 'Gujarat Titans', 'Bowling Allrounder', 'AR', 'AR', 'A', 89, 'OVERSEAS', 'Afghan', 2, false, NULL, NULL, 8, 'https://www.cricbuzz.com/profiles/10738/rashid-khan', 136.0, 585.0, NULL, NULL, 158.0, NULL, NULL, NULL, NULL, NULL, 98, NULL, NULL, NULL, 51.0, 82.0, 51.0),
('8424bbfd-270d-4c82-aad8-2dc9f20b0f86', 129, 'Anuj Rawat', 'Gujarat Titans', 'WK-Batsman', 'WK', 'BAT_WK', 'C', 60, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/13135/anuj-rawat', 24.0, 318.0, 119.11, 19.88, NULL, NULL, NULL, 10.0, 57.0, 50.0, 42, NULL, NULL, NULL, NULL, NULL, NULL),
('e27a89e7-120b-481b-b865-d008d5dce42a', 57, 'Jofra Archer', 'Rajasthan Royals', 'Bowler', 'BOWL', 'BOWL', 'B', 73, 'OVERSEAS', 'English', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/11540/jofra-archer', 52.0, NULL, NULL, NULL, 59.0, 7.89, 27.15, NULL, NULL, NULL, 56, 41.0, 74.0, 80.0, NULL, NULL, NULL),
('27e68ce3-4fdb-4f93-9f12-6addf2e19cf4', 105, 'Mukesh Kumar', 'Delhi Capitals', 'Bowler', 'BOWL', 'BOWL', 'C', 64, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/10754/mukesh-kumar', 32.0, NULL, NULL, NULL, 36.0, 10.4, 30.61, NULL, NULL, NULL, 46, 27.0, 33.0, 73.0, NULL, NULL, NULL),
('0c60d35d-8045-4628-987e-d5e56a1b4984', 89, 'Dhruv Jurel', 'Rajasthan Royals', 'WK-Batsman', 'WK', 'BAT_WK', 'C', 67, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/14691/dhruv-jurel', 41.0, 680.0, 153.85, 28.33, NULL, NULL, NULL, 16.0, 81.0, 71.0, 50, NULL, NULL, NULL, NULL, NULL, NULL),
('95c14de1-1e1b-4b53-8672-23f524f940a3', 154, 'Nuwan Thushara', 'Royal Challengers Bengaluru', 'Bowler', 'BOWL', 'BOWL', 'C', 56, 'OVERSEAS', 'Sri Lankan', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/18509/nuwan-thushara', 8.0, NULL, NULL, NULL, 9.0, 9.43, 31.44, NULL, NULL, NULL, 34, 9.0, 49.0, 71.0, NULL, NULL, NULL),
('47e541de-de32-4c74-a538-db7dddc832ee', 44, 'Khaleel Ahmed', 'Chennai Super Kings', 'Bowler', 'BOWL', 'BOWL', 'B', 77, 'INDIAN', 'Indian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/10952/khaleel-ahmed', 71.0, NULL, NULL, NULL, 89.0, 8.98, 26.16, NULL, NULL, NULL, 65, 61.0, 56.0, 82.0, NULL, NULL, NULL),
('d42e10a7-1e2c-49c4-b405-899273398b55', 16, 'Suryakumar Yadav', 'Mumbai Indians', 'Batsman', 'BAT', 'BAT_WK', 'A', 89, 'INDIAN', 'Indian', 2, false, NULL, NULL, 2, 'https://www.cricbuzz.com/profiles/7915/suryakumar-yadav', 166.0, 4311.0, 148.66, 35.05, NULL, NULL, NULL, 82.0, 77.0, 87.0, 99, NULL, NULL, NULL, NULL, NULL, NULL),
('70a0b9b7-0683-4845-a5b5-131055a38132', 117, 'Dewald Brevis', 'Chennai Super Kings', 'Batsman', 'BAT', 'BAT_WK', 'C', 62, 'OVERSEAS', 'South African', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/20538/dewald-brevis', 16.0, 455.0, 153.2, 28.44, NULL, NULL, NULL, 12.0, 80.0, 71.0, 38, NULL, NULL, NULL, NULL, NULL, NULL),
('f2d6b700-f34a-46bc-8c62-0c57e243072c', 39, 'Nicholas Pooran', 'Lucknow Super Giants', 'WK-Batsman', 'WK', 'BAT_WK', 'B', 78, 'OVERSEAS', 'West Indian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/9406/nicholas-pooran', 90.0, 2293.0, 168.98, 34.22, NULL, NULL, NULL, 46.0, 91.0, 85.0, 75, NULL, NULL, NULL, NULL, NULL, NULL),
('857c0f54-a024-43cf-9bce-68e742cbcb9b', 108, 'Rovman Powell', 'Kolkata Knight Riders', 'Batsman', 'BAT', 'BAT_WK', 'C', 63, 'OVERSEAS', 'West Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/11445/rovman-powell', 28.0, 365.0, 146.59, 18.25, NULL, NULL, NULL, 11.0, 76.0, 46.0, 44, NULL, NULL, NULL, NULL, NULL, NULL),
('d2bea203-41a1-4d35-8ee6-8aa7397d3d0e', 35, 'Deepak Chahar', 'Mumbai Indians', 'Bowler', 'BOWL', 'BOWL', 'B', 78, 'INDIAN', 'Indian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/7836/deepak-chahar', 95.0, NULL, NULL, NULL, 88.0, 8.14, 29.51, NULL, NULL, NULL, 77, 60.0, 70.0, 75.0, NULL, NULL, NULL),
('ebf80b94-8287-41cd-b034-746598350200', 8, 'MS Dhoni', 'Chennai Super Kings', 'WK-Batsman', 'WK', 'BAT_WK', 'A', 95, 'INDIAN', 'Indian', 2, false, NULL, NULL, 4, 'https://www.cricbuzz.com/profiles/265/ms-dhoni', 278.0, 5439.0, 137.46, 38.3, NULL, NULL, NULL, 99.0, 70.0, 95.0, 99, NULL, NULL, NULL, NULL, NULL, NULL),
('d066622f-5321-4440-8965-1fe065d4e3c3', 33, 'Ishant Sharma', 'Gujarat Titans', 'Bowler', 'BOWL', 'BOWL', 'B', 79, 'INDIAN', 'Indian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/702/ishant-sharma', 117.0, NULL, NULL, NULL, 96.0, 8.38, 35.18, NULL, NULL, NULL, 88, 65.0, 66.0, 63.0, NULL, NULL, NULL),
('d5e64d1f-4e40-431c-b258-386c313a3639', 67, 'Ayush Badoni', 'Lucknow Super Giants', 'Batting Allrounder', 'AR', 'AR', 'B', 71, 'INDIAN', 'Indian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/13907/ayush-badoni', 56.0, 963.0, NULL, NULL, 4.0, NULL, NULL, NULL, NULL, NULL, 58, NULL, NULL, NULL, 63.0, 37.0, 37.0),
('04723b74-8e98-4fbf-8751-de60d01f4ca9', 13, 'Axar Patel', 'Delhi Capitals', 'Bowling Allrounder', 'AR', 'AR', 'A', 91, 'INDIAN', 'Indian', 2, false, NULL, NULL, 6, 'https://www.cricbuzz.com/profiles/8808/axar-patel', 162.0, 1916.0, NULL, NULL, 128.0, NULL, NULL, NULL, NULL, NULL, 99, NULL, NULL, NULL, 82.0, 72.0, 72.0),
('25f82357-1a13-499f-9856-576597368a9d', 125, 'Vaibhav Suryavanshi', 'Rajasthan Royals', 'Batsman', 'BAT', 'BAT_WK', 'C', 61, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/51791/vaibhav-suryavanshi', 7.0, 252.0, 206.56, 36.0, NULL, NULL, NULL, 9.0, 99.0, 89.0, 33, NULL, NULL, NULL, NULL, NULL, NULL),
('ae4712c9-fb5f-4e34-85fe-6ed12b6ecc2a', 150, 'Adam Milne', 'Rajasthan Royals', 'Bowler', 'BOWL', 'BOWL', 'C', 56, 'OVERSEAS', 'New Zealander', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/7625/adam-milne', 10.0, NULL, NULL, NULL, 7.0, 9.48, 46.71, NULL, NULL, NULL, 35, 8.0, 48.0, 38.0, NULL, NULL, NULL),
('e4f6a082-db8a-4890-92e8-51b28a951e53', 52, 'Rahul Tripathi', 'Kolkata Knight Riders', 'Batsman', 'BAT', 'BAT_WK', 'B', 74, 'INDIAN', 'Indian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/9012/rahul-tripathi', 100.0, 2291.0, 137.85, 26.03, NULL, NULL, NULL, 46.0, 70.0, 65.0, 80, NULL, NULL, NULL, NULL, NULL, NULL),
('d8119296-0721-4481-9be6-b889b3749d3e', 138, 'Azmatullah Omarzai', 'Punjab Kings', 'Bowling Allrounder', 'AR', 'AR', 'C', 58, 'OVERSEAS', 'Afghan', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/13214/azmatullah-omarzai', 16.0, 99.0, NULL, NULL, 12.0, NULL, NULL, NULL, NULL, NULL, 38, NULL, NULL, NULL, 31.0, 25.0, 25.0),
('3369b25a-f7d3-492e-85cd-63853aad8a0a', 31, 'Manish Pandey', 'Kolkata Knight Riders', 'Batsman', 'BAT', 'BAT_WK', 'B', 82, 'INDIAN', 'Indian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/1836/manish-pandey', 174.0, 3942.0, 121.52, 29.42, NULL, NULL, NULL, 76.0, 59.0, 73.0, 99, NULL, NULL, NULL, NULL, NULL, NULL),
('fc49d3d4-fdc3-4e71-9405-220068f7b113', 126, 'Nathan Ellis', 'Chennai Super Kings', 'Bowler', 'BOWL', 'BOWL', 'C', 61, 'OVERSEAS', 'Australian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/15480/nathan-ellis', 17.0, NULL, NULL, NULL, 19.0, 8.67, 28.74, NULL, NULL, NULL, 38, 16.0, 61.0, 77.0, NULL, NULL, NULL),
('ea9d30a4-4cc4-4b4b-b86b-5725bd323197', 157, 'Manimaran Siddharth', 'Lucknow Super Giants', 'Bowler', 'BOWL', 'BOWL', 'C', 55, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/12930/manimaran-siddharth', 5.0, NULL, NULL, NULL, 3.0, 8.63, 46.0, NULL, NULL, NULL, 32, 5.0, 62.0, 40.0, NULL, NULL, NULL),
('3ad6dabf-989a-4515-8fab-92945e92e1d6', 87, 'Tushar Deshpande', 'Rajasthan Royals', 'Bowler', 'BOWL', 'BOWL', 'C', 67, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/11307/tushar-deshpande', 46.0, NULL, NULL, NULL, 51.0, 9.84, 31.04, NULL, NULL, NULL, 53, 36.0, 42.0, 72.0, NULL, NULL, NULL),
('8c4fd7b5-d891-4122-9927-6ae63788eba3', 10, 'Harshal Patel', 'Sunrisers Hyderabad', 'Bowler', 'BOWL', 'BOWL', 'A', 94, 'INDIAN', 'Indian', 2, false, NULL, NULL, 6, 'https://www.cricbuzz.com/profiles/8175/harshal-patel', 119.0, NULL, NULL, NULL, 151.0, 8.86, 23.7, NULL, NULL, NULL, 89, 99.0, 58.0, 87.0, NULL, NULL, NULL),
('5e0868e1-ab09-4e40-8fa7-6cea847ee31d', 114, 'Mitchell Santner', 'Mumbai Indians', 'Bowling Allrounder', 'AR', 'AR', 'C', 62, 'OVERSEAS', 'New Zealander', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/10100/mitchell-santner', 31.0, 110.0, NULL, NULL, 25.0, NULL, NULL, NULL, NULL, NULL, 45, NULL, NULL, NULL, 25.0, 40.0, 25.0),
('395a5eba-d7e9-40f0-ba8d-a614a0b22644', 73, 'Tim David', 'Royal Challengers Bengaluru', 'Batsman', 'BAT', 'BAT_WK', 'B', 70, 'OVERSEAS', 'Singaporean', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/13169/tim-david', 50.0, 846.0, 173.37, 32.54, NULL, NULL, NULL, 19.0, 94.0, 81.0, 55, NULL, NULL, NULL, NULL, NULL, NULL),
('56eb63b0-e54d-4e0e-9752-bceb9a3c0777', 83, 'Jason Holder', 'Gujarat Titans', 'Bowling Allrounder', 'AR', 'AR', 'C', 68, 'OVERSEAS', 'West Indian', 0.5, false, NULL, NULL, 2, 'https://www.cricbuzz.com/profiles/8313/jason-holder', 46.0, 259.0, NULL, NULL, 53.0, NULL, NULL, NULL, NULL, NULL, 53, NULL, NULL, NULL, 32.0, 45.0, 32.0),
('279c764c-920f-4dd9-a96b-862cc5855477', 2, 'Yuzvendra Chahal', 'Punjab Kings', 'Bowler', 'BOWL', 'BOWL', 'A', 99, 'INDIAN', 'Indian', 2, false, NULL, NULL, 10, 'https://www.cricbuzz.com/profiles/7910/yuzvendra-chahal', 174.0, NULL, NULL, NULL, 221.0, 7.96, 22.77, NULL, NULL, NULL, 99, 99.0, 73.0, 89.0, NULL, NULL, NULL),
('b95f9533-d406-4fc7-b9e5-f802b7f7dbd3', 25, 'Marcus Stoinis', 'Punjab Kings', 'Batting Allrounder', 'AR', 'AR', 'B', 83, 'OVERSEAS', 'Australian', 1, false, NULL, NULL, 4, 'https://www.cricbuzz.com/profiles/8989/marcus-stoinis', 109.0, 2026.0, NULL, NULL, 44.0, NULL, NULL, NULL, NULL, NULL, 84, NULL, NULL, NULL, 90.0, 37.0, 37.0),
('842b0933-c553-4d13-b2ee-21afa340b38b', 15, 'Sanju Samson', 'Chennai Super Kings', 'WK-Batsman', 'WK', 'BAT_WK', 'A', 89, 'INDIAN', 'Indian', 2, false, NULL, NULL, 2, 'https://www.cricbuzz.com/profiles/8271/sanju-samson', 176.0, 4704.0, 139.05, 30.75, NULL, NULL, NULL, 89.0, 71.0, 76.0, 99, NULL, NULL, NULL, NULL, NULL, NULL),
('a500e74b-7cee-452f-8223-b7ec54571fb8', 45, 'Shivam Dube', 'Chennai Super Kings', 'Batting Allrounder', 'AR', 'AR', 'B', 76, 'INDIAN', 'Indian', 1, false, NULL, NULL, 2, 'https://www.cricbuzz.com/profiles/11195/shivam-dube', 79.0, 1859.0, NULL, NULL, 5.0, NULL, NULL, NULL, NULL, NULL, 69, NULL, NULL, NULL, 88.0, 20.0, 20.0),
('bc175b61-0025-4cea-af6c-7781b947ae1e', 56, 'Josh Hazlewood', 'Royal Challengers Bengaluru', 'Bowler', 'BOWL', 'BOWL', 'B', 73, 'OVERSEAS', 'Australian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/6258/josh-hazlewood', 39.0, NULL, NULL, NULL, 57.0, 8.28, 20.98, NULL, NULL, NULL, 49, 40.0, 67.0, 93.0, NULL, NULL, NULL),
('209a0972-032b-475a-b5da-6dd843662059', 53, 'Prasidh Krishna', 'Gujarat Titans', 'Bowler', 'BOWL', 'BOWL', 'B', 74, 'INDIAN', 'Indian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/10551/prasidh-krishna', 66.0, NULL, NULL, NULL, 74.0, 8.77, 29.61, NULL, NULL, NULL, 63, 51.0, 59.0, 75.0, NULL, NULL, NULL),
('445206df-d6c4-49df-91ee-b3b7626f9402', 127, 'Digvesh Singh Rathi', 'Lucknow Super Giants', 'Bowler', 'BOWL', 'BOWL', 'C', 61, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/1448289/digvesh-singh-rathi', 13.0, NULL, NULL, NULL, 14.0, 8.25, 30.64, NULL, NULL, NULL, 36, 12.0, 68.0, 72.0, NULL, NULL, NULL),
('7b3372ee-0a2d-4700-ad75-3f7dcac11c77', 11, 'Sandeep Sharma', 'Rajasthan Royals', 'Bowler', 'BOWL', 'BOWL', 'A', 93, 'INDIAN', 'Indian', 2, false, NULL, NULL, 4, 'https://www.cricbuzz.com/profiles/8356/sandeep-sharma', 136.0, NULL, NULL, NULL, 146.0, 8.03, 27.88, NULL, NULL, NULL, 98, 98.0, 71.0, 78.0, NULL, NULL, NULL),
('83ad09ad-fbb0-49b2-9d91-ca933c9fa5f0', 156, 'Matthew Short', 'Chennai Super Kings', 'Batsman', 'BAT', 'BAT_WK', 'C', 55, 'OVERSEAS', 'Australian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/9456/matthew-short', 6.0, 117.0, 127.18, 19.5, NULL, NULL, NULL, 6.0, 63.0, 49.0, 33, NULL, NULL, NULL, NULL, NULL, NULL),
('b41bc65c-39b1-495f-8005-f6db7dfe8415', 21, 'Krunal Pandya', 'Royal Challengers Bengaluru', 'Batting Allrounder', 'AR', 'AR', 'A', 86, 'INDIAN', 'Indian', 2, false, NULL, NULL, 4, 'https://www.cricbuzz.com/profiles/11311/krunal-pandya', 142.0, 1748.0, NULL, NULL, 93.0, NULL, NULL, NULL, NULL, NULL, 99, NULL, NULL, NULL, 77.0, 60.0, 60.0),
('b8b662a3-b543-4838-a0e6-52c2cba5c231', 51, 'Sam Curran', 'Rajasthan Royals', 'Bowling Allrounder', 'AR', 'AR', 'B', 74, 'OVERSEAS', 'English', 1, false, NULL, NULL, 2, 'https://www.cricbuzz.com/profiles/10420/sam-curran', 64.0, 997.0, NULL, NULL, 59.0, NULL, NULL, NULL, NULL, NULL, 62, NULL, NULL, NULL, 62.0, 41.0, 41.0),
('784ad092-fa35-4b63-892e-ed635e4514db', 65, 'Tilak Varma', 'Mumbai Indians', 'Batsman', 'BAT', 'BAT_WK', 'B', 72, 'INDIAN', 'Indian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/14504/tilak-varma', 54.0, 1499.0, 144.42, 37.48, NULL, NULL, NULL, 31.0, 74.0, 93.0, 57, NULL, NULL, NULL, NULL, NULL, NULL),
('496463bb-89e1-4aee-b40d-a8e7898abbb2', 28, 'Kuldeep Yadav', 'Delhi Capitals', 'Bowler', 'BOWL', 'BOWL', 'B', 83, 'INDIAN', 'Indian', 1, false, NULL, NULL, 2, 'https://www.cricbuzz.com/profiles/8292/kuldeep-yadav', 98.0, NULL, NULL, NULL, 102.0, 8.04, 26.95, NULL, NULL, NULL, 79, 69.0, 71.0, 80.0, NULL, NULL, NULL),
('9da55ff2-39c0-44ae-99fa-f26ad104752a', 112, 'Nitish Kumar Reddy', 'Sunrisers Hyderabad', 'Batting Allrounder', 'AR', 'AR', 'C', 62, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/14701/nitish-kumar-reddy', 28.0, 485.0, NULL, NULL, 5.0, NULL, NULL, NULL, NULL, NULL, 44, NULL, NULL, NULL, 50.0, 14.0, 14.0),
('2f498fb9-c3be-4e4b-8775-18b44263bf1d', 70, 'Venkatesh Iyer', 'Royal Challengers Bengaluru', 'Batting Allrounder', 'AR', 'AR', 'B', 70, 'INDIAN', 'Indian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/10917/venkatesh-iyer', 61.0, 1468.0, NULL, NULL, 3.0, NULL, NULL, NULL, NULL, NULL, 60, NULL, NULL, NULL, 77.0, 16.0, 16.0),
('b3d8b533-0f82-4abc-9b7d-e78e83209b2b', 22, 'Kagiso Rabada', 'Gujarat Titans', 'Bowler', 'BOWL', 'BOWL', 'A', 85, 'OVERSEAS', 'South African', 2, false, NULL, NULL, 2, 'https://www.cricbuzz.com/profiles/9585/kagiso-rabada', 84.0, NULL, NULL, NULL, 119.0, 8.62, 22.96, NULL, NULL, NULL, 72, 80.0, 62.0, 89.0, NULL, NULL, NULL),
('3ab733ac-d5b8-4268-895d-42a3cc147056', 61, 'Travis Head', 'Sunrisers Hyderabad', 'Batsman', 'BAT', 'BAT_WK', 'B', 72, 'OVERSEAS', 'Australian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/8497/travis-head', 38.0, 1146.0, 170.03, 34.73, NULL, NULL, NULL, 25.0, 92.0, 86.0, 49, NULL, NULL, NULL, NULL, NULL, NULL),
('2637ee54-941e-45ce-b954-7c8ba234eda9', 17, 'Mohammed Shami', 'Lucknow Super Giants', 'Bowler', 'BOWL', 'BOWL', 'A', 89, 'INDIAN', 'Indian', 2, false, NULL, NULL, 4, 'https://www.cricbuzz.com/profiles/7909/mohammed-shami', 119.0, NULL, NULL, NULL, 133.0, 8.63, 28.18, NULL, NULL, NULL, 89, 89.0, 62.0, 78.0, NULL, NULL, NULL),
('8268da92-7e58-4c30-886e-a97d7ef04426', 91, 'Shahrukh Khan', 'Gujarat Titans', 'Batting Allrounder', 'AR', 'AR', 'C', 67, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/10226/shahrukh-khan', 55.0, 732.0, NULL, NULL, 1.0, NULL, NULL, NULL, NULL, NULL, 57, NULL, NULL, NULL, 56.0, 27.0, 27.0),
('01cce2e0-9e95-4a5f-93c8-c603aa29c9b6', 9, 'KL Rahul', 'Delhi Capitals', 'WK-Batsman', 'WK', 'BAT_WK', 'A', 95, 'INDIAN', 'Indian', 2, true, 'The ''Strike Rate'' Debater', 'I have one of the most elegant cover drives in world cricket, but I’m equally famous for sparking internet debates about whether "strike rate is overrated." After dealing with a rather public, animated scolding from my former team boss on the field, I’ve left Lucknow behind to open the batting in the Capital. Who am I?', 4, 'https://www.cricbuzz.com/profiles/8733/kl-rahul', 145.0, 5222.0, 136.03, 46.21, NULL, NULL, NULL, 99.0, 69.0, 99.0, 99, NULL, NULL, NULL, NULL, NULL, NULL),
('538d83bb-5fbb-49ea-9275-af5ee7eb4967', 50, 'Mitchell Marsh', 'Lucknow Super Giants', 'Batting Allrounder', 'AR', 'AR', 'B', 74, 'OVERSEAS', 'Australian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/6250/mitchell-marsh', 55.0, 1292.0, NULL, NULL, 37.0, NULL, NULL, NULL, NULL, NULL, 57, NULL, NULL, NULL, 72.0, 43.0, 43.0),
('88a211bf-790f-4e9d-9261-1cd6421f9f89', 6, 'Rohit Sharma', 'Mumbai Indians', 'Batsman', 'BAT', 'BAT_WK', 'A', 96, 'INDIAN', 'Indian', 2, false, NULL, NULL, 8, 'https://www.cricbuzz.com/profiles/576/rohit-sharma', 272.0, 7046.0, 132.1, 29.73, NULL, NULL, NULL, 99.0, 66.0, 74.0, 99, NULL, NULL, NULL, NULL, NULL, NULL),
('597beed0-1067-4f7d-8a3e-54091f126c6a', 132, 'Kuldeep Sen', 'Rajasthan Royals', 'Bowler', 'BOWL', 'BOWL', 'C', 59, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/14336/kuldeep-sen', 12.0, NULL, NULL, NULL, 14.0, 9.63, 27.64, NULL, NULL, NULL, 36, 12.0, 45.0, 79.0, NULL, NULL, NULL),
('3893792b-f7e1-4b7b-83ca-b909c6c9dbed', 145, 'Akash Maharaj Singh', 'Lucknow Super Giants', 'Bowler', 'BOWL', 'BOWL', 'C', 57, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/14696/akash-maharaj-singh', 10.0, NULL, NULL, NULL, 9.0, 9.54, 36.22, NULL, NULL, NULL, 35, 9.0, 47.0, 61.0, NULL, NULL, NULL),
('61d87c5c-f235-4aaa-9a5d-5cb193e65bbd', 3, 'Jasprit Bumrah', 'Mumbai Indians', 'Bowler', 'BOWL', 'BOWL', 'A', 99, 'INDIAN', 'Indian', 2, false, NULL, NULL, 8, 'https://www.cricbuzz.com/profiles/9311/jasprit-bumrah', 145.0, NULL, NULL, NULL, 183.0, 7.25, 22.03, NULL, NULL, NULL, 99, 99.0, 84.0, 91.0, NULL, NULL, NULL),
('3ed2bc7a-071f-46a2-9dd9-c79065fb2853', 27, 'Shreyas Iyer', 'Punjab Kings', 'Batsman', 'BAT', 'BAT_WK', 'B', 83, 'INDIAN', 'Indian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/9428/shreyas-iyer', 132.0, 3731.0, 133.35, 34.23, NULL, NULL, NULL, 72.0, 67.0, 85.0, 96, NULL, NULL, NULL, NULL, NULL, NULL),
('49b9e54b-e712-43e1-8bed-5bbf9bbbe6d2', 110, 'Josh Inglis', 'Lucknow Super Giants', 'WK-Batsman', 'WK', 'BAT_WK', 'C', 63, 'OVERSEAS', 'Australian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/10637/josh-inglis', 11.0, 278.0, 162.58, 30.89, NULL, NULL, NULL, 9.0, 87.0, 77.0, 35, NULL, NULL, NULL, NULL, NULL, NULL),
('567b1bf1-5f49-4099-b33d-06ded85c4d44', 37, 'Ishan Kishan', 'Sunrisers Hyderabad', 'WK-Batsman', 'WK', 'BAT_WK', 'B', 78, 'INDIAN', 'Indian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/10276/ishan-kishan', 119.0, 2998.0, 137.65, 29.11, NULL, NULL, NULL, 58.0, 70.0, 72.0, 89, NULL, NULL, NULL, NULL, NULL, NULL),
('2f24601e-3564-4c0c-b7f2-bd1fc96dfd93', 14, 'Ajinkya Rahane', 'Kolkata Knight Riders', 'Batsman', 'BAT', 'BAT_WK', 'A', 91, 'INDIAN', 'Indian', 2, false, NULL, NULL, 4, 'https://www.cricbuzz.com/profiles/1447/ajinkya-rahane', 198.0, 5032.0, 125.02, 30.5, NULL, NULL, NULL, 95.0, 61.0, 76.0, 99, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT INTO "AuctionPlayer" (id, player_id, status) VALUES
('b92f6138-6403-4cee-87f2-cde1c9f1cf4c', '58787ff7-e58f-42e6-ba02-d080f146bc4f', 'UNSOLD'),
('adb0b70f-816f-45d9-bda9-f7be235d7128', '7a74b117-6afe-4502-9ac7-94e49e40b00a', 'UNSOLD'),
('5338d163-93fd-4536-b0a3-5235d4fac80e', 'f66f8fd7-4328-40fc-9957-7e86ed6288b5', 'UNSOLD'),
('39bc10db-9e7c-4cae-bdcb-39b236da61b7', 'e148249e-d52c-40b8-b386-fda2bc74224e', 'UNSOLD'),
('ff3f8bcd-3043-455c-a947-be4bf50bdc03', 'a23be824-2d58-42e0-ab78-5f86eec5ebdb', 'UNSOLD'),
('94970c1d-8f4b-43eb-856f-47199e7f071e', '73672ad0-b2ec-4c04-b9dc-a5c44b8dcfcb', 'UNSOLD'),
('a9c10c5e-10f1-44d4-9d42-118769a43860', 'd2cd3fec-1006-4714-be2c-0bc1b2da069d', 'UNSOLD'),
('d9d07bc8-ee92-4667-991c-06048b8399bf', '4a3d9e71-aa5e-4cf8-ab01-e8abc7242aa4', 'UNSOLD'),
('00d15c3a-a70c-450c-9ae3-719c989e4840', '7fccb1c8-a6e3-424f-a2d3-f18b07262994', 'UNSOLD'),
('1465fa33-4408-48f9-b45d-6e1bdf7fefaa', '2386dfa8-5e20-4848-8ffe-4b489d960890', 'UNSOLD'),
('0ea569a3-dd4a-41f4-ab80-63339ea30f62', '37666c86-0432-4129-b2e8-c5d557377883', 'UNSOLD'),
('ac78d41f-7ed0-45ff-8ad6-32361fdd570d', '73034e9f-1154-4f9d-9cd4-186dd8f14dcd', 'UNSOLD'),
('8946996b-5f44-4c95-a239-891c6e01d5a6', 'a049bb10-9081-44d6-b909-1cd49a9fc8a7', 'UNSOLD'),
('7937d1ed-6eca-4c36-9132-d296e7ed4972', '914fa046-e88f-4189-ab0f-a73645b02044', 'UNSOLD'),
('725166e6-2167-4761-9899-11abe960e8bc', '8987ed1b-265e-4daa-b66c-9ba949abcd3b', 'UNSOLD'),
('db7e938f-95cf-4f53-9ae3-8148f26841cf', '79dbda6d-4478-4eef-8075-cca41362ae34', 'UNSOLD'),
('a152e054-6d7b-44f5-bb44-ce5c8f5e11b6', 'cc436107-f8b5-4893-b81c-a5b92409434e', 'UNSOLD'),
('05050a30-1fe8-4e2e-8363-8f53e0633354', 'be62c33c-ff39-45c7-9c63-c398483c1fd3', 'UNSOLD'),
('ff7c08ba-3495-4ac9-b790-3b4e5528b98c', 'b2833e39-c23e-47e1-bfdb-adf5ff823cca', 'UNSOLD'),
('2bbf1bc9-eb83-4665-ab7f-38ca4e70b8bd', 'dabe431c-f0e8-4224-ac22-28128dec58eb', 'UNSOLD'),
('5f745c42-441d-499c-95f7-0feb61ab96b0', 'eec84412-4df9-4ee1-bca5-1ecab4a39556', 'UNSOLD'),
('9e848d5e-9450-4392-994e-adcf3eb80d93', '57c59d73-fee1-4c12-8480-f0ad407df344', 'UNSOLD'),
('c237212e-645c-4bc6-ae9a-d3d413a2bde6', 'db9fb571-0f27-4c34-9ef8-03fcff3e7218', 'UNSOLD'),
('6e284fde-5560-429e-98de-6ddee91ab4d2', '1ef6148f-4eb7-4d92-88d9-c1927991a588', 'UNSOLD'),
('b3e224ec-3274-4c3d-8967-664c0a5bd96c', '63633ea3-d158-4ecd-8d71-c511a557f372', 'UNSOLD'),
('e91f5bf9-6351-4c85-a57a-ba69ed78303f', '9decd6a2-a5e0-4ee8-8033-25b9df31cda8', 'UNSOLD'),
('7c065ebc-f3c8-471e-8416-f7f3be03a8ed', '39f21ecc-2ce1-44a6-ba81-ec00da05c6f6', 'UNSOLD'),
('52fb5473-49d8-4887-b597-e6b12c2e81c4', 'a03021cf-26b1-480f-b440-63563a5528d3', 'UNSOLD'),
('17e7d6f3-dc67-4167-9d07-6c51ff426819', 'e357efee-f2a9-482e-b469-b0145a669913', 'UNSOLD'),
('aee713de-f05f-4329-aec8-6c424eb4824b', '85fa9d7c-5a56-42ae-b2a5-03142a6fa03b', 'UNSOLD'),
('3c05a176-bd2a-4c34-a4b1-d9c210263910', '413a4a2f-19d3-4972-806b-083253ed807a', 'UNSOLD'),
('a80a4110-8eeb-48e3-85da-e0a8a7764628', 'df5f1ed5-bb87-46c6-b26c-ae9c97b70dd4', 'UNSOLD'),
('778f8cdb-b5a1-468c-87e1-f5854e55e1e3', 'cc9c507e-88ba-4d9e-a9b0-c462caa66ca9', 'UNSOLD'),
('cdd53b5f-c784-4528-a2c0-2b7c5e957d74', 'f3684dd3-137b-4a3c-a2a5-16d287191102', 'UNSOLD'),
('b6512924-b52f-4e58-bc8c-0e1ed6f6e16d', 'ac1b8404-994d-4fd6-af16-77f5f4b91091', 'UNSOLD'),
('a99ee9a9-18ee-4997-a2e0-f6ebbd25ce28', '2737a997-1ef5-4ebe-8d21-5f7bc3f52ddf', 'UNSOLD'),
('f04ae3bf-7ac0-4d9c-aeb2-bc39de8ff863', 'cbea32a7-c4bd-438f-a20c-61235b19a74f', 'UNSOLD'),
('df6aa421-6167-4858-b325-38718bfb6ee8', '901f7acb-959f-4c3f-a061-a94f7462902b', 'UNSOLD'),
('71d5105c-56d8-460b-9df6-378665d7cb18', '53ab066a-e592-47bf-9d16-a779b0df964c', 'UNSOLD'),
('f3a67478-dff6-4219-8064-ae696327a64b', '7024eef6-2575-4a70-9889-205b3ff78e60', 'UNSOLD'),
('2ee05cac-135f-4273-8900-7ebb69502d98', '669a6008-c419-41ce-b141-bbefbbd61ce3', 'UNSOLD'),
('d3c2d2cc-b1d4-4562-b593-0a573d752727', '9fd05243-38c8-4a56-a79f-2e8df8ab71a5', 'UNSOLD'),
('fdff82d7-7ce5-489c-9007-29d978ddb7a9', '95e30748-4b1a-4cf6-8e37-a1ddcfe512b0', 'UNSOLD'),
('a99988e6-05b3-4735-895f-3578cd7bb72d', 'b6b04a67-f2bc-438c-9952-d18c7a8240e3', 'UNSOLD'),
('656ab404-caf3-4180-9565-3ed106efc734', '515d4893-cf8e-465f-8d84-5917c8a37b44', 'UNSOLD'),
('7d965cbd-3766-438a-9a86-72563a6e58bb', 'bb0bc6fb-7525-4fba-ba67-c8cf27823d87', 'UNSOLD'),
('dd95d51d-70b7-41f3-a4b8-d395a0bcb7e3', '5bd620ee-7930-49ea-b841-4268a7fb9e6b', 'UNSOLD'),
('a28bef56-466a-4a4b-a403-25958d6eca93', '14c9c436-b1a6-429c-bdeb-176b2bcdc6f8', 'UNSOLD'),
('8170b32b-c636-4ba5-92f0-45230c3e644f', '28e55a4d-3731-4b8e-b523-e23048dfce67', 'UNSOLD'),
('7a590b6e-c399-4925-bbd6-cce2b1fee9ac', 'db92a924-673e-4a09-8c1e-e47d5e680f9c', 'UNSOLD'),
('a067cf5c-f3d5-4d05-a8be-afe6795fd30a', 'fb51b78f-7a83-43f5-b13c-3a155f959802', 'UNSOLD'),
('1b86a8bc-b418-4b13-b08c-1bc5712cfc1c', '45be1e04-23ec-4dbe-8fe2-ec38d409f2d3', 'UNSOLD'),
('f0b217be-eba5-4380-b2b7-0de95580a3d7', '18e57050-cbb9-4746-bfc9-f32ee0e48ba4', 'UNSOLD'),
('b7ffba2a-0764-404a-9483-8e4c1bff8b10', '445279fa-f3b6-4969-b49e-304b5be79a0c', 'UNSOLD'),
('fdfe7a37-1ceb-44da-a745-66be2610788c', 'd9f9bbcc-bb55-4744-ad66-096cf38f6ddb', 'UNSOLD'),
('d941331c-5a3a-413c-a905-e9c904779173', '91535ff1-b9f8-4ab4-bc23-63bed99df48d', 'UNSOLD'),
('8a2ce335-d11a-46ac-993b-8a36b5d98484', '45893609-c5ef-4891-babe-76fd44c1d543', 'UNSOLD'),
('10f9e4f6-5f49-4858-9af9-e81131639b2b', 'efcfdd37-b78a-4ea6-a3e4-9511f7d7cf3f', 'UNSOLD'),
('b9c04cf3-5ace-47c9-bd54-f21f40239c08', '14b1ec6a-493f-4c24-bb68-5bdd9b9473c9', 'UNSOLD'),
('c0b0b9cf-3b11-475d-ac94-c5e762bfbfd5', 'b77d35f6-08e9-41bf-8c02-5e050d57cd06', 'UNSOLD'),
('bbc7a12f-3f88-4efd-9b0c-0c917fd86014', '0ee1d03e-f5cc-4c9a-be74-35a3b32b149a', 'UNSOLD'),
('45ff94b1-ae9d-44de-bcd8-a6a25d7c37b2', '1e8d8303-e216-4d5d-a153-ab3a89802d55', 'UNSOLD'),
('c524fefe-6a24-46d9-ab0a-b1635c5bf555', 'c17f5513-c88c-4b71-ade7-6f478ca0e982', 'UNSOLD'),
('d14c1501-c027-4658-adf2-a09a0f09203b', '72df0a74-9ac6-4efd-9206-fb2a69416aed', 'UNSOLD'),
('a66eab2a-8906-4fad-a261-a4926995591b', '515eb6fc-3c88-49c8-95cf-079a973f7c58', 'UNSOLD'),
('1a1037b6-82d8-4d93-9b05-576a4d7607fb', 'fac281b4-014a-4847-8deb-7830d89a7fb8', 'UNSOLD'),
('8238884a-41ac-40e7-aa89-42f3a6462115', 'e154a840-5d74-4618-86cc-bd4dd6206d9f', 'UNSOLD'),
('5c17e25a-192b-4a07-a7d4-0fc2aa213c8f', 'ed3f0310-0972-4ca4-b9d0-44dd95ab7a78', 'UNSOLD'),
('d69b24fb-0583-4feb-98dc-4c94261752b5', 'a2abe584-2670-4303-8241-2e975e085752', 'UNSOLD'),
('dd1c9f44-05e7-4221-8ff9-4fb8bf2872bd', 'a1724551-e508-4319-85f9-f0b7aefe2fae', 'UNSOLD'),
('4fac517f-e0b0-474b-94d4-b2e84abeccf3', '2bdc3c2c-a674-4f95-8076-43bb423a5007', 'UNSOLD'),
('6cae4955-2157-4474-abaa-4ffdb2bbf842', 'e87ca0fa-f37d-4492-b4ac-66c4e21e5d37', 'UNSOLD'),
('e0337bb4-7221-40f8-99cd-edec87b55f83', '7220c4ae-4463-49dd-b514-88b6556d6748', 'UNSOLD'),
('058b7ebd-f7e0-4bac-81c0-f0294176e80b', '540e69f2-8f3e-4861-92b0-011272c6f9af', 'UNSOLD'),
('ec8292ef-78f5-4019-9305-2a6fe6287ec3', 'eb0aa390-39c2-4970-aedb-66f42677843e', 'UNSOLD'),
('986e25b0-4412-4cc2-81af-39281b173db8', '975c85fc-8fb0-4b6a-a000-b2ea4ea2f82e', 'UNSOLD'),
('f29b2896-3ee7-4b8b-a7bf-2e50569f0260', 'cdb88385-cf62-467d-89e0-2d14581ca954', 'UNSOLD'),
('2dc92820-23ff-44f8-b53f-ec289a36d8f0', '8bc0174c-f199-4997-a9f6-08a0574fa8a4', 'UNSOLD'),
('58ab8649-99f8-4ca1-97d9-4f52f901d15b', 'd66dac8e-0434-43ec-b91d-b9a70fb4004c', 'UNSOLD'),
('05b4d968-d088-4e5b-90e5-a8f6c52c0fb4', '5d01173b-0a7d-4401-94d4-a7f470941c54', 'UNSOLD'),
('e9f2180e-86e9-494f-8843-cccb6b917bb2', '542cbf5c-6714-46bf-a78f-078cc4645bab', 'UNSOLD'),
('01f07f86-c1a8-40a1-9ca7-f79a036f997a', '80fd8654-9c9f-478e-95d6-5a55e585e89f', 'UNSOLD'),
('7caa7b01-bbf0-49f8-9081-47fb0ab3d0d7', 'ea346c5f-9708-4d14-83b5-762d14fd913e', 'UNSOLD'),
('b6de9eac-6600-42aa-981a-98a1b701e93c', 'c163ad39-0584-4306-b49d-222d834f98f7', 'UNSOLD'),
('47c10c82-214d-4599-a163-d154a1b942de', 'f898caa0-85aa-4dad-90d7-6d02c42bb3f4', 'UNSOLD'),
('b12595ce-45c5-4ef3-82cf-74bff20f7fe4', '7c58ef80-4aeb-4488-8768-da73209f947b', 'UNSOLD'),
('f5e4c240-2fe0-4c37-a3a0-9479ae533851', 'ae3d71a6-09a6-4b80-8631-4e0b76590839', 'UNSOLD'),
('664eb0b2-2329-4d72-a470-869173b4db58', '1057b877-033c-4c2e-a0f2-cf3693b07912', 'UNSOLD'),
('7b39294c-98fc-4af5-b5bd-7e3ba19e4272', 'd969be63-2cda-4038-b58e-f6f22e174790', 'UNSOLD'),
('9c98f8e6-1d31-4f0b-95ce-30347fad35bc', '3485c997-543e-4ea6-9626-60da696a6ed1', 'UNSOLD'),
('87e0c3e5-237a-44af-86cb-8e2401597628', 'd3bdf365-3928-48bb-b9b1-1de4704dbb4b', 'UNSOLD'),
('daf128b9-1baf-4f53-a7de-74f4d934ae4c', '976915ed-3187-4f69-b03b-bb513700d7ea', 'UNSOLD'),
('d3fe911d-39bb-440e-bd51-92aa6ea61bf7', 'dadd5b00-7112-45a0-a418-7b1713232eae', 'UNSOLD'),
('bec802ab-481a-40cf-af85-b5feeac33d7d', 'bf2a4e7c-95b7-4c29-9f4d-677408b817d9', 'UNSOLD'),
('d6452e82-f236-495c-a990-6fe52a41a38a', '823a73e8-67f2-4131-80ba-1c8b653401b6', 'UNSOLD'),
('6b2d80d9-899c-4613-bd9c-ffd0ccf55d96', '3a0f2e65-8c4a-489b-ab83-bd7342a71d27', 'UNSOLD'),
('7f787558-26cb-4a76-b403-2590c4df3860', 'b53609ad-d2b3-448f-8de1-dcb4181d42de', 'UNSOLD'),
('2370450d-04e9-424d-80ec-16973b0e974d', '0e463fc4-0dea-4e7c-bd96-d09e21fb3bcb', 'UNSOLD'),
('7813aeeb-d990-4f44-be5c-f32eb72da68d', '8c07b19c-8d38-4d00-acc5-e8155c99a614', 'UNSOLD'),
('188dd66d-e473-4a2c-835f-3c00fc0997b4', '24d91560-bf52-434f-af36-8848e83d62f5', 'UNSOLD'),
('354ed52a-2694-4bb8-afe2-fda74767c812', '1d4a97bc-4980-4cfd-aea9-e6ddfed69856', 'UNSOLD'),
('8179dfa2-5fdf-471e-a7d4-5bcf1898988b', '67a441ec-56d9-4ffd-8c34-10da08362fa1', 'UNSOLD'),
('d9743ddf-8400-4ddc-8a39-aa6e0ff02cd8', '6676eb33-80f4-458e-8675-9862bdf71789', 'UNSOLD'),
('496e136a-3cf3-4351-85ad-36ac21971a01', '8424bbfd-270d-4c82-aad8-2dc9f20b0f86', 'UNSOLD'),
('9fcf3002-0973-46ef-a80c-28bd3e7503e0', 'e27a89e7-120b-481b-b865-d008d5dce42a', 'UNSOLD'),
('02f769d6-b7d1-42ea-b856-449d60a6ce5f', '27e68ce3-4fdb-4f93-9f12-6addf2e19cf4', 'UNSOLD'),
('f355afc9-6834-4910-bb61-bbe13e9c7e12', '0c60d35d-8045-4628-987e-d5e56a1b4984', 'UNSOLD'),
('43b17c6d-ed15-4c44-a9e7-c4ef888d1d58', '95c14de1-1e1b-4b53-8672-23f524f940a3', 'UNSOLD'),
('cc736e6c-3240-4d88-b1f6-ba1e405035bd', '47e541de-de32-4c74-a538-db7dddc832ee', 'UNSOLD'),
('3c57468b-5152-4bfc-850a-5fb5dd6c72da', 'd42e10a7-1e2c-49c4-b405-899273398b55', 'UNSOLD'),
('1e4cd215-41dd-4c57-a8cd-081e3ca1a93b', '70a0b9b7-0683-4845-a5b5-131055a38132', 'UNSOLD'),
('b9cd207e-6725-44af-ac38-e9b37789f853', 'f2d6b700-f34a-46bc-8c62-0c57e243072c', 'UNSOLD'),
('4509a1a7-bbb1-46cb-a269-f3d9cd2da076', '857c0f54-a024-43cf-9bce-68e742cbcb9b', 'UNSOLD'),
('7aab4e0e-eb8e-4efc-b2f7-099dc360df80', 'd2bea203-41a1-4d35-8ee6-8aa7397d3d0e', 'UNSOLD'),
('125f8314-0f03-4bec-8db3-8a1d68e69a56', 'ebf80b94-8287-41cd-b034-746598350200', 'UNSOLD'),
('523cfb95-c55c-4910-892e-28810cd7553f', 'd066622f-5321-4440-8965-1fe065d4e3c3', 'UNSOLD'),
('facd5f3f-ed74-4c80-b5ed-d4cdae66b0a1', 'd5e64d1f-4e40-431c-b258-386c313a3639', 'UNSOLD'),
('7a12d787-21c8-48e7-84a5-c710f25ccc5d', '04723b74-8e98-4fbf-8751-de60d01f4ca9', 'UNSOLD'),
('3cdad7be-386e-407c-bea0-da9aa9800727', '25f82357-1a13-499f-9856-576597368a9d', 'UNSOLD'),
('cd0a47c1-0ad0-4775-8072-e5c2be1dffaa', 'ae4712c9-fb5f-4e34-85fe-6ed12b6ecc2a', 'UNSOLD'),
('f1134828-a5fd-4691-8d13-4d1e6959d248', 'e4f6a082-db8a-4890-92e8-51b28a951e53', 'UNSOLD'),
('8a89ada7-3444-4012-9128-83c19ad1e8b3', 'd8119296-0721-4481-9be6-b889b3749d3e', 'UNSOLD'),
('fd8d41b8-8a2c-4c89-a9ee-9600eb0d65ef', '3369b25a-f7d3-492e-85cd-63853aad8a0a', 'UNSOLD'),
('c78131bf-3d45-42d5-9664-83d7a370f934', 'fc49d3d4-fdc3-4e71-9405-220068f7b113', 'UNSOLD'),
('310a2187-5a08-47a7-9496-ff78667e5105', 'ea9d30a4-4cc4-4b4b-b86b-5725bd323197', 'UNSOLD'),
('8f7de3e4-d0c6-4755-9e3a-c262f38d7d1e', '3ad6dabf-989a-4515-8fab-92945e92e1d6', 'UNSOLD'),
('d5866662-69b5-4a22-a5ca-771eb0d55c89', '8c4fd7b5-d891-4122-9927-6ae63788eba3', 'UNSOLD'),
('23a3f0a2-e604-4ee6-b216-2750785e8956', '5e0868e1-ab09-4e40-8fa7-6cea847ee31d', 'UNSOLD'),
('97b02811-97d7-4afb-9808-cf161d758cdf', '395a5eba-d7e9-40f0-ba8d-a614a0b22644', 'UNSOLD'),
('f1050211-200c-4a66-9ac0-abb2a85b9c3b', '56eb63b0-e54d-4e0e-9752-bceb9a3c0777', 'UNSOLD'),
('b605e663-ea29-4e72-bea3-42b699fa3dde', '279c764c-920f-4dd9-a96b-862cc5855477', 'UNSOLD'),
('71de172d-7c2b-4d2b-9f9d-424ec1f71c46', 'b95f9533-d406-4fc7-b9e5-f802b7f7dbd3', 'UNSOLD'),
('1b30be43-186e-496e-8f5f-e828dc82e283', '842b0933-c553-4d13-b2ee-21afa340b38b', 'UNSOLD'),
('1c9e49da-5dd1-41bb-b504-2dfea75666a5', 'a500e74b-7cee-452f-8223-b7ec54571fb8', 'UNSOLD'),
('ffc140ba-f691-42d8-ac91-e69c4e40bde6', 'bc175b61-0025-4cea-af6c-7781b947ae1e', 'UNSOLD'),
('3bcacf28-4b5d-4c7b-9be2-e633c745c21a', '209a0972-032b-475a-b5da-6dd843662059', 'UNSOLD'),
('10c144b5-b6aa-4fe8-b0ca-3cbbd9ac11ff', '445206df-d6c4-49df-91ee-b3b7626f9402', 'UNSOLD'),
('e5cdfb63-c4c9-4ccb-9ccf-b1589112c063', '7b3372ee-0a2d-4700-ad75-3f7dcac11c77', 'UNSOLD'),
('ba821789-7c6d-4b08-b78b-5e2acaf74129', '83ad09ad-fbb0-49b2-9d91-ca933c9fa5f0', 'UNSOLD'),
('d00abf08-1cde-45ca-a69c-f931d15f4da7', 'b41bc65c-39b1-495f-8005-f6db7dfe8415', 'UNSOLD'),
('007c95f8-7d1e-4a1f-a505-ee28141ba79a', 'b8b662a3-b543-4838-a0e6-52c2cba5c231', 'UNSOLD'),
('7e05c906-9996-4066-afb7-c1ef3d2a133d', '784ad092-fa35-4b63-892e-ed635e4514db', 'UNSOLD'),
('d735e79f-cada-4f97-96ab-d6890f94e011', '496463bb-89e1-4aee-b40d-a8e7898abbb2', 'UNSOLD'),
('92c53cf7-ec17-4737-9e68-be6a193c9741', '9da55ff2-39c0-44ae-99fa-f26ad104752a', 'UNSOLD'),
('70af69d9-ec71-4e21-a5ed-0910448e8913', '2f498fb9-c3be-4e4b-8775-18b44263bf1d', 'UNSOLD'),
('b0ee90ef-84c4-41b4-88f3-2419cd435c42', 'b3d8b533-0f82-4abc-9b7d-e78e83209b2b', 'UNSOLD'),
('0788d3df-45cf-49b9-9cac-9e0eadf07d2a', '3ab733ac-d5b8-4268-895d-42a3cc147056', 'UNSOLD'),
('1bdcf8d6-9cf9-4fee-a301-7d99d194eae2', '2637ee54-941e-45ce-b954-7c8ba234eda9', 'UNSOLD'),
('ed381545-868c-4bbe-ae1f-ce67ca7870ae', '8268da92-7e58-4c30-886e-a97d7ef04426', 'UNSOLD'),
('07c84669-de85-4e78-afef-2e0f46dec138', '01cce2e0-9e95-4a5f-93c8-c603aa29c9b6', 'UNSOLD'),
('20917fd7-b069-4d86-9b16-c7d59af6c644', '538d83bb-5fbb-49ea-9275-af5ee7eb4967', 'UNSOLD'),
('e5355f4c-97df-4f7a-8bd9-0b5d150e6e00', '88a211bf-790f-4e9d-9261-1cd6421f9f89', 'UNSOLD'),
('ee6dea10-daf0-49e6-b497-e3c52c878554', '597beed0-1067-4f7d-8a3e-54091f126c6a', 'UNSOLD'),
('d6a980cf-9537-470b-b3b5-06c63a7fbf61', '3893792b-f7e1-4b7b-83ca-b909c6c9dbed', 'UNSOLD'),
('316cfc79-3164-4933-8803-95041eca75a8', '61d87c5c-f235-4aaa-9a5d-5cb193e65bbd', 'UNSOLD'),
('29409a51-795d-4dfb-aa9e-63a0d966e550', '3ed2bc7a-071f-46a2-9dd9-c79065fb2853', 'UNSOLD'),
('295df326-23ec-4936-9afe-3ec93b9e6998', '49b9e54b-e712-43e1-8bed-5bbf9bbbe6d2', 'UNSOLD'),
('237af567-8ebd-4bd5-8e97-569fb5ac1e6a', '567b1bf1-5f49-4099-b33d-06ded85c4d44', 'UNSOLD'),
('00edfb1e-b026-4ccb-b931-91101b776591', '2f24601e-3564-4c0c-b7f2-bd1fc96dfd93', 'UNSOLD');

INSERT INTO "AdminUser" (id, username, password_hash, role) VALUES
('b5144f10-2a68-4df8-89df-738728109e7d', 'admin', '$2b$10$pNRuXx/wNG9/0GAXNMatduK0ddJRe42hGIn2E7OKG3d65lHFsgC9K', 'ADMIN'),
('298aacf2-5bc4-44ef-a41f-0d5b333312eb', 'screen', '$2b$10$sRE/jFSWeK9itC3FcQ3Vme6hLSs81ZGYbq/E.1lSdJpeiCpSDQx9K', 'SCREEN');

INSERT INTO "AuctionSequence" (id, name, type, sequence_items) VALUES
(1, 'Franchise Auction', 'FRANCHISE', '[3,7,1,9,5,10,2,6,8,4]');

INSERT INTO "AuctionSequence" (id, name, type, sequence_items) VALUES
(2, 'Power Card Auction', 'POWER_CARD', '["GOD_EYE","MULLIGAN","FINAL_STRIKE","BID_FREEZER"]');

INSERT INTO "AuctionSequence" (id, name, type, sequence_items) VALUES
(3, 'Player Auction 2', 'PLAYER', '[131,134,149,69,81,66,26,34,84,23,116,155,123,124,142,148,101,94,119,76,135,115,147,19,43,1,80,30,68,85,109,118,100,58,7,120,122,128,130,64,121,144,24,42,137,133,141,88,74,60,29,106,159,59,97,49,92,78,151,47,82,77,140,98,72,62,102,63,5,136,93,71,146,153,40,113,48,4,139,55,107,36,143,99,41,152,20,54,95,32,103,111,38,90,79,96,12,86,158,46,104,75,18,129,57,105,89,154,44,16,117,39,108,35,8,33,67,13,125,150,52,138,31,126,157,87,10,114,73,83,2,25,15,45,56,53,127,11,156,21,51,65,28,112,70,22,61,17,91,9,50,6,132,145,3,27,110,37,14]');

INSERT INTO "AuctionState" (id, phase, auction_day) VALUES (1, 'NOT_STARTED', 'Day 1');

