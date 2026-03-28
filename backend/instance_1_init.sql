-- INSTANCE 1 INITIALIZATION
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



-- ── DATA FOR INSTANCE 1 ──

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
('f7ff2bdb-0881-4829-af14-fa9530d663fb', 'Bombay Boozers', 'bombayboozers', '$2b$10$kpkQG7sA/MRmKTVYWpLXDOlGGxUYML3hwIW24g1KcyxsMwFzKR46u', 120, 0),
('98258a27-3731-4ff1-b449-011cd1d84dd3', 'Bid Lords', 'bidlords', '$2b$10$srLqQ10rByYlyx.1lO0.euShdDvPhWoxCCVB7IyE9sZX8xwfXCFFO', 120, 0),
('2e5c9249-3e3f-4b5e-839e-089a15770858', 'Strikers', 'strikers', '$2b$10$bLEftYWL1pPFeSFfw2z3oez8CDln3Fuy5MkyXaIS5rHUVSXi5VY2.', 120, 0),
('c4d99a18-a6cf-41e7-9674-dcaf63d03f9b', 'RR', 'rr', '$2b$10$dmSMizBQEbu1hz7js3IGoeZih4PDHJrZYC/2d6ONHiU4zQcbRMj.e', 120, 0),
('d02f8f88-5808-43b5-8c24-4226b01152b2', 'Babita Blasters', 'babitablasters', '$2b$10$slsJTrrUjz4DHWNTigqpXO/5znk32mgA8BqBHbaWM3ABqqBhLaU0G', 120, 0),
('6edb9786-9f34-4cec-9f58-fa873a70a12f', 'People''s Ameen Party', 'peoplesameenparty', '$2b$10$OcSvs2pDq2ARn0ojdxW2Je7xoxcmiGDdMoNS3m0.B9O91kf7FyH9.', 120, 0),
('98efda62-faa6-4229-9f0f-e597244b1b56', 'Zenith Strikers', 'zenithstrikers', '$2b$10$youZyLs3LSkO38IDIHpJPeJTAaSLRnJ78hkcmghwt.6Nv6NcVrfM2', 120, 0),
('e231c903-2da9-4111-b47a-4e1ae11d3022', 'Logic legends', 'logiclegends', '$2b$10$/vUFFqoWRjEOFNWzSqNzxOZJJiJXLgesblx5aKNGgNRuGUDiGnSsu', 120, 0),
('167478f0-a695-45db-80ff-5e8fd98c2993', 'Thala Knight Challengers', 'thalaknightchallenge', '$2b$10$gcgSo3XpeTk/HSdlNxUIa.BaediQXXFkjY1xP33q6aX3l3UAVGxTS', 120, 0),
('b2774917-b56f-48bf-a82d-349297fca657', 'Villains', 'villains', '$2b$10$zWbYRYoTi5ZrTOb2/n/V3OEBbLTvXqHoydDWjzf1P9hPTDfqtnDgC', 120, 0);

INSERT INTO "Player" (id, rank, name, team, role, category, pool, grade, rating, nationality, nationality_raw, base_price, is_riddle, legacy, url, matches, bat_runs, bat_sr, bat_average, bowl_wickets, bowl_eco, bowl_avg, sub_scoring, sub_impact, sub_consistency, sub_experience, sub_wicket_taking, sub_economy, sub_efficiency, sub_batting, sub_bowling, sub_versatility) VALUES
('6937550e-d46e-4896-89b8-c0abdee957c6', 6, 'Rohit Sharma', 'Mumbai Indians', 'Batsman', 'BAT', 'BAT_WK', 'A', 96, 'INDIAN', 'Indian', 2, false, 8, 'https://www.cricbuzz.com/profiles/576/rohit-sharma', 272.0, 7046.0, 132.1, 29.73, NULL, NULL, NULL, 99.0, 66.0, 74.0, 99, NULL, NULL, NULL, NULL, NULL, NULL),
('4f56d201-ca96-4642-b59e-6384f19840f3', 123, 'Ayush Mhatre', 'Chennai Super Kings', 'Batsman', 'BAT', 'BAT_WK', 'C', 61, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/1431163/ayush-mhatre', 7.0, 240.0, 188.98, 34.29, NULL, NULL, NULL, 8.0, 99.0, 85.0, 33, NULL, NULL, NULL, NULL, NULL, NULL),
('fae3ec75-eb02-4a9d-b2cc-91d5a05b7e05', 138, 'Azmatullah Omarzai', 'Punjab Kings', 'Bowling Allrounder', 'AR', 'AR', 'C', 58, 'OVERSEAS', 'Afghan', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/13214/azmatullah-omarzai', 16.0, 99.0, NULL, NULL, 12.0, NULL, NULL, NULL, NULL, NULL, 38, NULL, NULL, NULL, 31.0, 25.0, 25.0),
('839de8a9-4d0b-44e8-b19c-cb71d4ae8130', 145, 'Akash Maharaj Singh', 'Lucknow Super Giants', 'Bowler', 'BOWL', 'BOWL', 'C', 57, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/14696/akash-maharaj-singh', 10.0, NULL, NULL, NULL, 9.0, 9.54, 36.22, NULL, NULL, NULL, 35, 9.0, 47.0, 61.0, NULL, NULL, NULL),
('4033080f-b718-40df-9ca5-77a399147247', 54, 'Heinrich Klaasen', 'Sunrisers Hyderabad', 'WK-Batsman', 'WK', 'BAT_WK', 'B', 74, 'OVERSEAS', 'South African', 1, false, 0, 'https://www.cricbuzz.com/profiles/10209/heinrich-klaasen', 49.0, 1480.0, 169.73, 40.0, NULL, NULL, NULL, 31.0, 91.0, 99.0, 54, NULL, NULL, NULL, NULL, NULL, NULL),
('bdb9fede-ab19-404f-8ed1-2e176fc274ac', 150, 'Adam Milne', 'Rajasthan Royals', 'Bowler', 'BOWL', 'BOWL', 'C', 56, 'OVERSEAS', 'New Zealander', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/7625/adam-milne', 10.0, NULL, NULL, NULL, 7.0, 9.48, 46.71, NULL, NULL, NULL, 35, 8.0, 48.0, 38.0, NULL, NULL, NULL),
('50a14274-d927-4455-8ebb-8e6558b9e39c', 71, 'Matheesha Pathirana', 'Kolkata Knight Riders', 'Bowler', 'BOWL', 'BOWL', 'B', 70, 'OVERSEAS', 'Sri Lankan', 1, false, 0, 'https://www.cricbuzz.com/profiles/16458/matheesha-pathirana', 32.0, NULL, NULL, NULL, 47.0, 8.68, 21.62, NULL, NULL, NULL, 46, 34.0, 61.0, 92.0, NULL, NULL, NULL),
('798fa776-3a48-4b37-8d2a-397416026714', 70, 'Venkatesh Iyer', 'Royal Challengers Bengaluru', 'Batting Allrounder', 'AR', 'AR', 'B', 70, 'INDIAN', 'Indian', 1, false, 0, 'https://www.cricbuzz.com/profiles/10917/venkatesh-iyer', 61.0, 1468.0, NULL, NULL, 3.0, NULL, NULL, NULL, NULL, NULL, 60, NULL, NULL, NULL, 77.0, 16.0, 16.0),
('de062a80-5513-45b0-b48f-8b6709ec64fc', 157, 'Manimaran Siddharth', 'Lucknow Super Giants', 'Bowler', 'BOWL', 'BOWL', 'C', 55, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/12930/manimaran-siddharth', 5.0, NULL, NULL, NULL, 3.0, 8.63, 46.0, NULL, NULL, NULL, 32, 5.0, 62.0, 40.0, NULL, NULL, NULL),
('c82e950a-1694-4bbe-a1be-05f2e716a960', 86, 'Mayank Markande', 'Mumbai Indians', 'Bowler', 'BOWL', 'BOWL', 'C', 67, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/12627/mayank-markande', 37.0, NULL, NULL, NULL, 37.0, 8.91, 28.89, NULL, NULL, NULL, 48, 27.0, 57.0, 76.0, NULL, NULL, NULL),
('b478cb23-6b34-4777-bec1-02bcd61dcc04', 120, 'Ravisrinivasan Sai Kishore', 'Gujarat Titans', 'Bowling Allrounder', 'AR', 'AR', 'C', 61, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/11595/ravisrinivasan-sai-kishore', 25.0, 18.0, NULL, NULL, 32.0, NULL, NULL, NULL, NULL, NULL, 42, NULL, NULL, NULL, 19.0, 41.0, 19.0),
('86f8af0e-05e4-4c52-bf61-72d96a0e71ea', 63, 'T Natarajan', 'Delhi Capitals', 'Bowler', 'BOWL', 'BOWL', 'B', 72, 'INDIAN', 'Indian', 1, false, 0, 'https://www.cricbuzz.com/profiles/10225/t-natarajan', 63.0, NULL, NULL, NULL, 67.0, 8.94, 30.12, NULL, NULL, NULL, 61, 47.0, 57.0, 74.0, NULL, NULL, NULL),
('ea18c59b-8ee0-4b72-9dc2-d8600e6054d8', 2, 'Yuzvendra Chahal', 'Punjab Kings', 'Bowler', 'BOWL', 'BOWL', 'A', 99, 'INDIAN', 'Indian', 2, false, 10, 'https://www.cricbuzz.com/profiles/7910/yuzvendra-chahal', 174.0, NULL, NULL, NULL, 221.0, 7.96, 22.77, NULL, NULL, NULL, 99, 99.0, 73.0, 89.0, NULL, NULL, NULL),
('d06a3629-ae60-4ba4-bc23-01dbaf5a2870', 36, 'Arshdeep Singh', 'Punjab Kings', 'Bowler', 'BOWL', 'BOWL', 'B', 78, 'INDIAN', 'Indian', 1, false, 0, 'https://www.cricbuzz.com/profiles/13217/arshdeep-singh', 82.0, NULL, NULL, NULL, 97.0, 9.0, 26.49, NULL, NULL, NULL, 71, 66.0, 56.0, 81.0, NULL, NULL, NULL),
('37364181-e3a2-4cc2-b060-04454e870060', 45, 'Shivam Dube', 'Chennai Super Kings', 'Batting Allrounder', 'AR', 'AR', 'B', 76, 'INDIAN', 'Indian', 1, false, 2, 'https://www.cricbuzz.com/profiles/11195/shivam-dube', 79.0, 1859.0, NULL, NULL, 5.0, NULL, NULL, NULL, NULL, NULL, 69, NULL, NULL, NULL, 88.0, 20.0, 20.0),
('326ac459-0d6f-4aaa-99a5-ca96462256df', 96, 'Vaibhav Arora', 'Kolkata Knight Riders', 'Bowler', 'BOWL', 'BOWL', 'C', 66, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/15861/vaibhav-arora', 32.0, NULL, NULL, NULL, 36.0, 9.55, 28.22, NULL, NULL, NULL, 46, 27.0, 47.0, 78.0, NULL, NULL, NULL),
('bfef23cb-edb8-4255-b547-a5cf7598d529', 92, 'Shashank Singh', 'Punjab Kings', 'Batting Allrounder', 'AR', 'AR', 'C', 67, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/10919/shashank-singh', 41.0, 773.0, NULL, NULL, 1.0, NULL, NULL, NULL, NULL, NULL, 50, NULL, NULL, NULL, 67.0, 14.0, 14.0),
('b52f4972-6656-48e4-aa20-e4ba5aca791e', 151, 'Dushmantha Chameera', 'Delhi Capitals', 'Bowler', 'BOWL', 'BOWL', 'C', 56, 'OVERSEAS', 'Sri Lankan', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/8393/dushmantha-chameera', 19.0, NULL, NULL, NULL, 13.0, 9.73, 46.38, NULL, NULL, NULL, 39, 12.0, 44.0, 39.0, NULL, NULL, NULL),
('f077e4a7-815d-4bd2-b8d4-ad2a115cc8c0', 69, 'Liam Livingstone', 'Sunrisers Hyderabad', 'Batting Allrounder', 'AR', 'AR', 'B', 70, 'OVERSEAS', 'English', 1, false, 0, 'https://www.cricbuzz.com/profiles/10045/liam-livingstone', 49.0, 1051.0, NULL, NULL, 13.0, NULL, NULL, NULL, NULL, NULL, 54, NULL, NULL, NULL, 70.0, 28.0, 28.0),
('ff8eafd8-e4cc-4d40-b2e1-881733128eb0', 112, 'Nitish Kumar Reddy', 'Sunrisers Hyderabad', 'Batting Allrounder', 'AR', 'AR', 'C', 62, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/14701/nitish-kumar-reddy', 28.0, 485.0, NULL, NULL, 5.0, NULL, NULL, NULL, NULL, NULL, 44, NULL, NULL, NULL, 50.0, 14.0, 14.0),
('4edbb1ed-730c-4012-b302-100eda17be5a', 72, 'Aiden Markram', 'Lucknow Super Giants', 'Batsman', 'BAT', 'BAT_WK', 'B', 70, 'OVERSEAS', 'South African', 1, false, 0, 'https://www.cricbuzz.com/profiles/9582/aiden-markram', 57.0, 1440.0, 135.09, 31.3, NULL, NULL, NULL, 30.0, 68.0, 78.0, 58, NULL, NULL, NULL, NULL, NULL, NULL),
('b8cee49c-f3a8-4563-ad4a-1422860069f5', 139, 'Nandre Burger', 'Rajasthan Royals', 'Bowler', 'BOWL', 'BOWL', 'C', 58, 'OVERSEAS', 'South African', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/13630/nandre-burger', 5.0, NULL, NULL, NULL, 7.0, 8.53, 20.71, NULL, NULL, NULL, 32, 8.0, 63.0, 94.0, NULL, NULL, NULL),
('df0f22bb-e45b-466a-8625-b4c481b37c3b', 101, 'Umran Malik', 'Kolkata Knight Riders', 'Bowler', 'BOWL', 'BOWL', 'C', 65, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/19027/umran-malik', 26.0, NULL, NULL, NULL, 29.0, 9.4, 26.62, NULL, NULL, NULL, 43, 22.0, 49.0, 81.0, NULL, NULL, NULL),
('50356e72-baa6-4bea-80e3-37f2dcb79e48', 116, 'Sherfane Rutherford', 'Mumbai Indians', 'Batting Allrounder', 'AR', 'AR', 'C', 62, 'OVERSEAS', 'West Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/13748/sherfane-rutherford', 23.0, 397.0, NULL, NULL, 1.0, NULL, NULL, NULL, NULL, NULL, 41, NULL, NULL, NULL, 48.0, 17.0, 17.0),
('b1172915-5ec3-4dde-9f9e-c9cc8b76d72a', 77, 'Rinku Singh', 'Kolkata Knight Riders', 'Batsman', 'BAT', 'BAT_WK', 'C', 69, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/10896/rinku-singh', 58.0, 1099.0, 145.18, 30.53, NULL, NULL, NULL, 24.0, 75.0, 76.0, 59, NULL, NULL, NULL, NULL, NULL, NULL),
('ee581742-54f3-4078-bc8c-f03c14d04c67', 29, 'Mohammed Siraj', 'Gujarat Titans', 'Bowler', 'BOWL', 'BOWL', 'B', 83, 'INDIAN', 'Indian', 1, false, 2, 'https://www.cricbuzz.com/profiles/10808/mohammed-siraj', 108.0, NULL, NULL, NULL, 109.0, 8.74, 30.72, NULL, NULL, NULL, 84, 74.0, 60.0, 72.0, NULL, NULL, NULL),
('a9cb6194-6802-452f-9cdd-667361b135cc', 79, 'Prabhsimran Singh', 'Punjab Kings', 'WK-Batsman', 'WK', 'BAT_WK', 'C', 69, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/14254/prabhsimran-singh', 51.0, 1305.0, 151.93, 25.59, NULL, NULL, NULL, 28.0, 79.0, 64.0, 55, NULL, NULL, NULL, NULL, NULL, NULL),
('10fdad7e-643d-4a8f-8735-bcfc688776e8', 20, 'Jos Buttler', 'Gujarat Titans', 'WK-Batsman', 'WK', 'BAT_WK', 'A', 88, 'OVERSEAS', 'English', 2, true, 2, 'https://www.cricbuzz.com/profiles/2258/jos-buttler', 121.0, 4120.0, 149.39, 40.0, NULL, NULL, NULL, 79.0, 78.0, 99.0, 90, NULL, NULL, NULL, NULL, NULL, NULL),
('77d8ab47-04a9-4a30-955d-9b6f7d3c40bd', 48, 'Pat Cummins', 'Sunrisers Hyderabad', 'Bowler', 'BOWL', 'BOWL', 'B', 75, 'OVERSEAS', 'Australian', 1, false, 0, 'https://www.cricbuzz.com/profiles/8095/pat-cummins', 72.0, NULL, NULL, NULL, 79.0, 8.81, 30.04, NULL, NULL, NULL, 66, 54.0, 59.0, 74.0, NULL, NULL, NULL),
('32d17ba0-6a0a-4bd0-bab6-9405a081082e', 104, 'Lungi Ngidi', 'Delhi Capitals', 'Bowler', 'BOWL', 'BOWL', 'C', 64, 'OVERSEAS', 'South African', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/9603/lungi-ngidi', 16.0, NULL, NULL, NULL, 29.0, 8.53, 18.24, NULL, NULL, NULL, 38, 22.0, 63.0, 99.0, NULL, NULL, NULL),
('da29d142-3d60-4be2-9df6-9dbe4cd1d292', 100, 'Abishek Porel', 'Delhi Capitals', 'WK-Batsman', 'WK', 'BAT_WK', 'C', 66, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/24326/abishek-porel', 31.0, 661.0, 149.89, 25.42, NULL, NULL, NULL, 16.0, 78.0, 63.0, 45, NULL, NULL, NULL, NULL, NULL, NULL),
('f27b8434-d165-4469-8798-5aedf5d8c32b', 44, 'Khaleel Ahmed', 'Chennai Super Kings', 'Bowler', 'BOWL', 'BOWL', 'B', 77, 'INDIAN', 'Indian', 1, false, 0, 'https://www.cricbuzz.com/profiles/10952/khaleel-ahmed', 71.0, NULL, NULL, NULL, 89.0, 8.98, 26.16, NULL, NULL, NULL, 65, 61.0, 56.0, 82.0, NULL, NULL, NULL),
('50da966c-ac66-4cb8-bd52-c7e3611dece2', 88, 'Harshit Rana', 'Kolkata Knight Riders', 'Bowler', 'BOWL', 'BOWL', 'C', 67, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/24729/harshit-rana', 33.0, NULL, NULL, NULL, 40.0, 9.51, 25.73, NULL, NULL, NULL, 46, 29.0, 47.0, 83.0, NULL, NULL, NULL),
('34a9d7a0-55ea-4014-9fef-22b11b048a00', 81, 'Harpreet Brar', 'Punjab Kings', 'Bowler', 'BOWL', 'BOWL', 'C', 68, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/14452/harpreet-brar', 49.0, NULL, NULL, NULL, 35.0, 8.03, 31.0, NULL, NULL, NULL, 54, 26.0, 71.0, 72.0, NULL, NULL, NULL),
('df807f6a-872d-4d0b-9d86-0910dc2833ef', 94, 'Will Jacks', 'Mumbai Indians', 'Batting Allrounder', 'AR', 'AR', 'C', 66, 'OVERSEAS', 'English', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/12258/will-jacks', 21.0, 463.0, NULL, NULL, 8.0, NULL, NULL, NULL, NULL, NULL, 40, NULL, NULL, NULL, 55.0, 28.0, 28.0),
('d089b3e3-64cc-4696-b575-5d0221bc0a77', 147, 'Mayank Yadav', 'Lucknow Super Giants', 'Bowler', 'BOWL', 'BOWL', 'C', 57, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/22401/mayank-yadav', 6.0, NULL, NULL, NULL, 9.0, 9.17, 20.56, NULL, NULL, NULL, 33, 9.0, 53.0, 94.0, NULL, NULL, NULL),
('5f31a5ac-d5be-4a3c-b3e7-ee40217b27df', 122, 'Ashutosh Sharma', 'Delhi Capitals', 'Batting Allrounder', 'AR', 'AR', 'C', 61, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/13497/ashutosh-sharma', 24.0, 393.0, NULL, NULL, 0.0, NULL, NULL, NULL, NULL, NULL, 42, NULL, NULL, NULL, 56.0, 0.0, 0.0),
('630a26a0-138a-4d94-b1ba-8eba682f322b', 62, 'Shimron Hetmyer', 'Rajasthan Royals', 'Batsman', 'BAT', 'BAT_WK', 'B', 72, 'OVERSEAS', 'West Indian', 1, false, 0, 'https://www.cricbuzz.com/profiles/9789/shimron-hetmyer', 86.0, 1482.0, 151.85, 29.06, NULL, NULL, NULL, 31.0, 79.0, 72.0, 73, NULL, NULL, NULL, NULL, NULL, NULL),
('bcf5b10a-ef79-47b8-95f2-6fb9c7b94b6e', 78, 'Rajat Patidar', 'Royal Challengers Bengaluru', 'Batsman', 'BAT', 'BAT_WK', 'C', 69, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/10636/rajat-patidar', 42.0, 1111.0, 154.31, 30.86, NULL, NULL, NULL, 24.0, 81.0, 77.0, 51, NULL, NULL, NULL, NULL, NULL, NULL),
('2e638ca6-f946-47e4-bcbd-0fa3f570ca3c', 149, 'Glenn Phillips', 'Gujarat Titans', 'Batting Allrounder', 'AR', 'AR', 'C', 56, 'OVERSEAS', 'New Zealander', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/10693/glenn-phillips', 8.0, 65.0, NULL, NULL, 2.0, NULL, NULL, NULL, NULL, NULL, 34, NULL, NULL, NULL, 24.0, 34.0, 24.0),
('60ab7d3c-2425-49be-b88c-dccaaef84ea2', 91, 'Shahrukh Khan', 'Gujarat Titans', 'Batting Allrounder', 'AR', 'AR', 'C', 67, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/10226/shahrukh-khan', 55.0, 732.0, NULL, NULL, 1.0, NULL, NULL, NULL, NULL, NULL, 57, NULL, NULL, NULL, 56.0, 27.0, 27.0),
('16757581-4418-44a5-ac68-fb6686a9ef6a', 11, 'Sandeep Sharma', 'Rajasthan Royals', 'Bowler', 'BOWL', 'BOWL', 'A', 93, 'INDIAN', 'Indian', 2, false, 4, 'https://www.cricbuzz.com/profiles/8356/sandeep-sharma', 136.0, NULL, NULL, NULL, 146.0, 8.03, 27.88, NULL, NULL, NULL, 98, 98.0, 71.0, 78.0, NULL, NULL, NULL),
('b6e9cc05-bf50-4cc9-8359-5f672ec5d286', 148, 'Vignesh Puthur', 'Rajasthan Royals', 'Bowler', 'BOWL', 'BOWL', 'C', 57, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/1447337/vignesh-puthur', 5.0, NULL, NULL, NULL, 6.0, 9.08, 18.17, NULL, NULL, NULL, 32, 7.0, 54.0, 99.0, NULL, NULL, NULL),
('404fa78a-ba47-4e55-bb87-2e6426f40fc3', 4, 'Sunil Narine', 'Kolkata Knight Riders', 'Bowling Allrounder', 'AR', 'AR', 'A', 98, 'OVERSEAS', 'West Indian', 2, false, 10, 'https://www.cricbuzz.com/profiles/2276/sunil-narine', 188.0, 1780.0, NULL, NULL, 192.0, NULL, NULL, NULL, NULL, NULL, 99, NULL, NULL, NULL, 84.0, 83.0, 83.0),
('d5e22224-5122-4303-aa27-3faa56953172', 31, 'Manish Pandey', 'Kolkata Knight Riders', 'Batsman', 'BAT', 'BAT_WK', 'B', 82, 'INDIAN', 'Indian', 1, false, 0, 'https://www.cricbuzz.com/profiles/1836/manish-pandey', 174.0, 3942.0, 121.52, 29.42, NULL, NULL, NULL, 76.0, 59.0, 73.0, 99, NULL, NULL, NULL, NULL, NULL, NULL),
('49a62f71-9571-4b8e-a1ee-292c9a9a2a71', 121, 'Suyash Sharma', 'Royal Challengers Bengaluru', 'Bowler', 'BOWL', 'BOWL', 'C', 61, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/36487/suyash-sharma', 27.0, NULL, NULL, NULL, 18.0, 8.75, 45.22, NULL, NULL, NULL, 43, 15.0, 60.0, 41.0, NULL, NULL, NULL),
('bdb914c4-9332-4a9c-8f00-8c9b9dafe680', 73, 'Tim David', 'Royal Challengers Bengaluru', 'Batsman', 'BAT', 'BAT_WK', 'B', 70, 'OVERSEAS', 'Singaporean', 1, false, 0, 'https://www.cricbuzz.com/profiles/13169/tim-david', 50.0, 846.0, 173.37, 32.54, NULL, NULL, NULL, 19.0, 94.0, 81.0, 55, NULL, NULL, NULL, NULL, NULL, NULL),
('02c98fca-bda0-4a6a-9e9b-8e53d3753506', 95, 'Nehal Wadhera', 'Punjab Kings', 'Batsman', 'BAT', 'BAT_WK', 'C', 66, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/13915/nehal-wadhera', 36.0, 719.0, 142.95, 26.63, NULL, NULL, NULL, 17.0, 73.0, 66.0, 48, NULL, NULL, NULL, NULL, NULL, NULL),
('2caabdd8-43f3-46cf-8e59-6be1d5d0599f', 135, 'Kartik Tyagi', 'Kolkata Knight Riders', 'Bowler', 'BOWL', 'BOWL', 'C', 58, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/13136/kartik-tyagi', 20.0, NULL, NULL, NULL, 15.0, 10.14, 47.53, NULL, NULL, NULL, 40, 13.0, 37.0, 37.0, NULL, NULL, NULL),
('81a39691-ac14-4642-8784-a92782f09154', 56, 'Josh Hazlewood', 'Royal Challengers Bengaluru', 'Bowler', 'BOWL', 'BOWL', 'B', 73, 'OVERSEAS', 'Australian', 1, false, 0, 'https://www.cricbuzz.com/profiles/6258/josh-hazlewood', 39.0, NULL, NULL, NULL, 57.0, 8.28, 20.98, NULL, NULL, NULL, 49, 40.0, 67.0, 93.0, NULL, NULL, NULL),
('dc77a2da-5355-4914-8d62-83eca0dc5565', 144, 'Vijaykumar Vyshak', 'Punjab Kings', 'Bowler', 'BOWL', 'BOWL', 'C', 57, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/10486/vijaykumar-vyshak', 16.0, NULL, NULL, NULL, 17.0, 10.38, 33.88, NULL, NULL, NULL, 38, 14.0, 33.0, 66.0, NULL, NULL, NULL),
('dfd01c47-589b-466b-b344-26e88fbebdfe', 61, 'Travis Head', 'Sunrisers Hyderabad', 'Batsman', 'BAT', 'BAT_WK', 'B', 72, 'OVERSEAS', 'Australian', 1, false, 0, 'https://www.cricbuzz.com/profiles/8497/travis-head', 38.0, 1146.0, 170.03, 34.73, NULL, NULL, NULL, 25.0, 92.0, 86.0, 49, NULL, NULL, NULL, NULL, NULL, NULL),
('c9a53737-dc37-42c4-8996-4892fd5c99bd', 106, 'Sarfaraz Khan', 'Chennai Super Kings', 'Batsman', 'BAT', 'BAT_WK', 'C', 64, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/9429/sarfaraz-khan', 50.0, 585.0, 130.59, 22.5, NULL, NULL, NULL, 15.0, 65.0, 56.0, 55, NULL, NULL, NULL, NULL, NULL, NULL),
('024a9e64-ff20-4f6e-93cc-af90305f4dac', 110, 'Josh Inglis', 'Lucknow Super Giants', 'WK-Batsman', 'WK', 'BAT_WK', 'C', 63, 'OVERSEAS', 'Australian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/10637/josh-inglis', 11.0, 278.0, 162.58, 30.89, NULL, NULL, NULL, 9.0, 87.0, 77.0, 35, NULL, NULL, NULL, NULL, NULL, NULL),
('59abd86e-d5ee-4657-8d0d-88db20a8e655', 22, 'Kagiso Rabada', 'Gujarat Titans', 'Bowler', 'BOWL', 'BOWL', 'A', 85, 'OVERSEAS', 'South African', 2, false, 2, 'https://www.cricbuzz.com/profiles/9585/kagiso-rabada', 84.0, NULL, NULL, NULL, 119.0, 8.62, 22.96, NULL, NULL, NULL, 72, 80.0, 62.0, 89.0, NULL, NULL, NULL),
('009d8a50-6e49-4391-8239-f0b787219567', 89, 'Dhruv Jurel', 'Rajasthan Royals', 'WK-Batsman', 'WK', 'BAT_WK', 'C', 67, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/14691/dhruv-jurel', 41.0, 680.0, 153.85, 28.33, NULL, NULL, NULL, 16.0, 81.0, 71.0, 50, NULL, NULL, NULL, NULL, NULL, NULL),
('ee9b8c88-c00f-4861-a0fa-40f0631aa229', 65, 'Tilak Varma', 'Mumbai Indians', 'Batsman', 'BAT', 'BAT_WK', 'B', 72, 'INDIAN', 'Indian', 1, false, 0, 'https://www.cricbuzz.com/profiles/14504/tilak-varma', 54.0, 1499.0, 144.42, 37.48, NULL, NULL, NULL, 31.0, 74.0, 93.0, 57, NULL, NULL, NULL, NULL, NULL, NULL),
('bed407bb-0ab4-4b19-8581-b0084df9ecb9', 49, 'Ravi Bishnoi', 'Rajasthan Royals', 'Bowler', 'BOWL', 'BOWL', 'B', 75, 'INDIAN', 'Indian', 1, false, 0, 'https://www.cricbuzz.com/profiles/14659/ravi-bishnoi', 77.0, NULL, NULL, NULL, 72.0, 8.22, 31.07, NULL, NULL, NULL, 68, 50.0, 68.0, 72.0, NULL, NULL, NULL),
('f2a11de4-ac26-424f-a715-6a847e8c28ea', 136, 'Arshad Khan', 'Gujarat Titans', 'Bowling Allrounder', 'AR', 'AR', 'C', 58, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/18637/arshad-khan', 19.0, 124.0, NULL, NULL, 12.0, NULL, NULL, NULL, NULL, NULL, 39, NULL, NULL, NULL, 39.0, 18.0, 18.0),
('9129b9c1-10cf-4e7d-811c-7ff1dc679e8a', 109, 'Abdul Samad', 'Lucknow Super Giants', 'Batting Allrounder', 'AR', 'AR', 'C', 63, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/14628/abdul-samad', 63.0, 741.0, NULL, NULL, 2.0, NULL, NULL, NULL, NULL, NULL, 61, NULL, NULL, NULL, 57.0, 5.0, 5.0),
('f5341b13-30c0-4923-a391-b9042a4ea43f', 118, 'Aniket Verma', 'Sunrisers Hyderabad', 'Batsman', 'BAT', 'BAT_WK', 'C', 62, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/1447065/aniket-verma', 14.0, 236.0, 166.2, 26.22, NULL, NULL, NULL, 8.0, 89.0, 65.0, 37, NULL, NULL, NULL, NULL, NULL, NULL),
('26390a88-11bb-429f-950e-714a05369f29', 53, 'Prasidh Krishna', 'Gujarat Titans', 'Bowler', 'BOWL', 'BOWL', 'B', 74, 'INDIAN', 'Indian', 1, false, 0, 'https://www.cricbuzz.com/profiles/10551/prasidh-krishna', 66.0, NULL, NULL, NULL, 74.0, 8.77, 29.61, NULL, NULL, NULL, 63, 51.0, 59.0, 75.0, NULL, NULL, NULL),
('6fb8f941-9f37-4e87-aa86-fdbab0c6a1a6', 127, 'Digvesh Singh Rathi', 'Lucknow Super Giants', 'Bowler', 'BOWL', 'BOWL', 'C', 61, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/1448289/digvesh-singh-rathi', 13.0, NULL, NULL, NULL, 14.0, 8.25, 30.64, NULL, NULL, NULL, 36, 12.0, 68.0, 72.0, NULL, NULL, NULL),
('980f57a0-79ff-4c02-8dbd-62ed79ac9e36', 102, 'Angkrish Raghuvanshi', 'Kolkata Knight Riders', 'Batsman', 'BAT', 'BAT_WK', 'C', 65, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/22566/angkrish-raghuvanshi', 22.0, 463.0, 144.69, 28.94, NULL, NULL, NULL, 12.0, 75.0, 72.0, 41, NULL, NULL, NULL, NULL, NULL, NULL),
('78bfcb2e-ad7d-48c9-a7f2-ce93c825a095', 84, 'Cameron Green', 'Kolkata Knight Riders', 'Batting Allrounder', 'AR', 'AR', 'C', 68, 'OVERSEAS', 'Australian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/12225/cameron-green', 29.0, 707.0, NULL, NULL, 16.0, NULL, NULL, NULL, NULL, NULL, 44, NULL, NULL, NULL, 64.0, 27.0, 27.0),
('2f3f2693-05e8-4489-a4c2-5d4166e835b6', 158, 'Arjun Tendulkar', 'Lucknow Super Giants', 'Bowling Allrounder', 'AR', 'AR', 'C', 55, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/13747/arjun-tendulkar', 5.0, 13.0, NULL, NULL, 3.0, NULL, NULL, NULL, NULL, NULL, 32, NULL, NULL, NULL, 32.0, 23.0, 23.0),
('78c12937-250a-48fa-a6c3-73787a7991c0', 41, 'Nitish Rana', 'Delhi Capitals', 'Batsman', 'BAT', 'BAT_WK', 'B', 77, 'INDIAN', 'Indian', 1, false, 0, 'https://www.cricbuzz.com/profiles/9204/nitish-rana', 118.0, 2853.0, 136.77, 27.7, NULL, NULL, NULL, 56.0, 69.0, 69.0, 89, NULL, NULL, NULL, NULL, NULL, NULL),
('954c590e-3b8d-45ad-acd4-9446550bf6ae', 115, 'Rachin Ravindra', 'Kolkata Knight Riders', 'Batting Allrounder', 'AR', 'AR', 'C', 62, 'OVERSEAS', 'New Zealander', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/11177/rachin-ravindra', 18.0, 413.0, NULL, NULL, 0.0, NULL, NULL, NULL, NULL, NULL, 39, NULL, NULL, NULL, 49.0, 29.0, 29.0),
('df3f8c7b-46cb-489b-9598-5484607ec483', 33, 'Ishant Sharma', 'Gujarat Titans', 'Bowler', 'BOWL', 'BOWL', 'B', 79, 'INDIAN', 'Indian', 1, false, 0, 'https://www.cricbuzz.com/profiles/702/ishant-sharma', 117.0, NULL, NULL, NULL, 96.0, 8.38, 35.18, NULL, NULL, NULL, 88, 65.0, 66.0, 63.0, NULL, NULL, NULL),
('0c2fb3a4-9f5c-41f7-9200-c1880e5cb16d', 43, 'Abhishek Sharma', 'Sunrisers Hyderabad', 'Batting Allrounder', 'AR', 'AR', 'B', 77, 'INDIAN', 'Indian', 1, false, 2, 'https://www.cricbuzz.com/profiles/12086/abhishek-sharma', 77.0, 1815.0, NULL, NULL, 11.0, NULL, NULL, NULL, NULL, NULL, 68, NULL, NULL, NULL, 90.0, 24.0, 24.0),
('14507e3c-16e6-4914-ad54-4fed1ed5470a', 85, 'Mohsin Khan', 'Lucknow Super Giants', 'Bowler', 'BOWL', 'BOWL', 'C', 67, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/13534/mohsin-khan', 24.0, NULL, NULL, NULL, 27.0, 8.51, 25.52, NULL, NULL, NULL, 42, 21.0, 64.0, 83.0, NULL, NULL, NULL),
('04f86ea3-c415-459c-935e-18cfced4173b', 1, 'Virat Kohli', 'Royal Challengers Bengaluru', 'Batsman', 'BAT', 'BAT_WK', 'A', 99, 'INDIAN', 'Indian', 2, false, 10, 'https://www.cricbuzz.com/profiles/1413/virat-kohli', 267.0, 8661.0, 132.86, 39.55, NULL, NULL, NULL, 99.0, 67.0, 98.0, 99, NULL, NULL, NULL, NULL, NULL, NULL),
('bf980d29-7651-4280-a4d6-2f3bec1faa0c', 25, 'Marcus Stoinis', 'Punjab Kings', 'Batting Allrounder', 'AR', 'AR', 'B', 83, 'OVERSEAS', 'Australian', 1, false, 4, 'https://www.cricbuzz.com/profiles/8989/marcus-stoinis', 109.0, 2026.0, NULL, NULL, 44.0, NULL, NULL, NULL, NULL, NULL, 84, NULL, NULL, NULL, 90.0, 37.0, 37.0),
('3745d73a-1466-42d1-b5c0-ec441cfc99c9', 23, 'Shubman Gill', 'Gujarat Titans', 'Batsman', 'BAT', 'BAT_WK', 'B', 84, 'INDIAN', 'Indian', 1, false, 0, 'https://www.cricbuzz.com/profiles/11808/shubman-gill', 118.0, 3866.0, 138.72, 39.45, NULL, NULL, NULL, 74.0, 70.0, 98.0, 89, NULL, NULL, NULL, NULL, NULL, NULL),
('7176047c-f6a3-46c6-b68a-b1370fc585fd', 9, 'KL Rahul', 'Delhi Capitals', 'WK-Batsman', 'WK', 'BAT_WK', 'A', 95, 'INDIAN', 'Indian', 2, false, 4, 'https://www.cricbuzz.com/profiles/8733/kl-rahul', 145.0, 5222.0, 136.03, 46.21, NULL, NULL, NULL, 99.0, 69.0, 99.0, 99, NULL, NULL, NULL, NULL, NULL, NULL),
('4d988cbd-983f-4a01-8152-87c161a8bbef', 55, 'Mitchell Starc', 'Delhi Capitals', 'Bowler', 'BOWL', 'BOWL', 'B', 73, 'OVERSEAS', 'Australian', 1, false, 0, 'https://www.cricbuzz.com/profiles/7710/mitchell-starc', 51.0, NULL, NULL, NULL, 65.0, 8.61, 23.12, NULL, NULL, NULL, 55, 45.0, 62.0, 88.0, NULL, NULL, NULL),
('45a3b6ee-02e4-4087-bab5-6e7f48f3949c', 126, 'Nathan Ellis', 'Chennai Super Kings', 'Bowler', 'BOWL', 'BOWL', 'C', 61, 'OVERSEAS', 'Australian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/15480/nathan-ellis', 17.0, NULL, NULL, NULL, 19.0, 8.67, 28.74, NULL, NULL, NULL, 38, 16.0, 61.0, 77.0, NULL, NULL, NULL),
('3584ca70-1355-41cf-959e-f102699ad940', 137, 'Jayant Yadav', 'Gujarat Titans', 'Bowling Allrounder', 'AR', 'AR', 'C', 58, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/8182/jayant-yadav', 20.0, 40.0, NULL, NULL, 8.0, NULL, NULL, NULL, NULL, NULL, 40, NULL, NULL, NULL, 22.0, 25.0, 22.0),
('9a2e616b-7f24-4985-9419-746a7080dcff', 93, 'Washington Sundar', 'Gujarat Titans', 'Bowling Allrounder', 'AR', 'AR', 'C', 67, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/10945/washington-sundar', 66.0, 511.0, NULL, NULL, 39.0, NULL, NULL, NULL, NULL, NULL, 63, NULL, NULL, NULL, 42.0, 40.0, 40.0),
('b9a64c0a-95c5-44bc-af6e-a22ee7681d40', 103, 'Priyansh Arya', 'Punjab Kings', 'Batsman', 'BAT', 'BAT_WK', 'C', 64, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/14689/priyansh-arya', 17.0, 475.0, 179.25, 27.94, NULL, NULL, NULL, 13.0, 98.0, 70.0, 38, NULL, NULL, NULL, NULL, NULL, NULL),
('677200bd-bbbe-44e4-b4df-0a6cf46da091', 98, 'Shivam Mavi', 'Sunrisers Hyderabad', 'Bowler', 'BOWL', 'BOWL', 'C', 66, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/12345/shivam-mavi', 32.0, NULL, NULL, NULL, 30.0, 8.71, 31.4, NULL, NULL, NULL, 46, 23.0, 60.0, 71.0, NULL, NULL, NULL),
('14c5b8ab-f913-452c-b36b-43edd2a305b5', 76, 'Tristan Stubbs', 'Delhi Capitals', 'WK-Batsman', 'WK', 'BAT_WK', 'B', 70, 'OVERSEAS', 'South African', 1, false, 0, 'https://www.cricbuzz.com/profiles/19243/tristan-stubbs', 32.0, 705.0, 163.2, 41.47, NULL, NULL, NULL, 17.0, 87.0, 99.0, 46, NULL, NULL, NULL, NULL, NULL, NULL),
('2073f8a7-7c58-49eb-8499-d19f79e4b57d', 3, 'Jasprit Bumrah', 'Mumbai Indians', 'Bowler', 'BOWL', 'BOWL', 'A', 99, 'INDIAN', 'Indian', 2, false, 8, 'https://www.cricbuzz.com/profiles/9311/jasprit-bumrah', 145.0, NULL, NULL, NULL, 183.0, 7.25, 22.03, NULL, NULL, NULL, 99, 99.0, 84.0, 91.0, NULL, NULL, NULL),
('6045c276-cfb6-4c20-91b9-15aa415daf1f', 143, 'Prashant Solanki', 'Kolkata Knight Riders', 'Bowler', 'BOWL', 'BOWL', 'C', 57, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/12805/prashant-solanki', 2.0, NULL, NULL, NULL, 2.0, 6.33, 19.0, NULL, NULL, NULL, 31, 5.0, 99.0, 97.0, NULL, NULL, NULL),
('99ccd3de-cbb2-4243-8a84-c5a77c695cef', 159, 'Rasikh Dar Salam', 'Royal Challengers Bengaluru', 'Bowler', 'BOWL', 'BOWL', 'C', 55, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/14274/rasikh-dar-salam', 13.0, NULL, NULL, NULL, 10.0, 10.62, 40.9, NULL, NULL, NULL, 36, 10.0, 29.0, 51.0, NULL, NULL, NULL),
('8b85a8b0-0f23-4eea-a3f6-3eed468c6b79', 19, 'Hardik Pandya', 'Mumbai Indians', 'Batting Allrounder', 'AR', 'AR', 'A', 89, 'INDIAN', 'Indian', 2, false, 6, 'https://www.cricbuzz.com/profiles/9647/hardik-pandya', 152.0, 2749.0, NULL, NULL, 78.0, NULL, NULL, NULL, NULL, NULL, 99, NULL, NULL, NULL, 90.0, 50.0, 50.0),
('c4eda41a-696c-4118-bfba-9bf53dd5c479', 83, 'Jason Holder', 'Gujarat Titans', 'Bowling Allrounder', 'AR', 'AR', 'C', 68, 'OVERSEAS', 'West Indian', 0.5, false, 2, 'https://www.cricbuzz.com/profiles/8313/jason-holder', 46.0, 259.0, NULL, NULL, 53.0, NULL, NULL, NULL, NULL, NULL, 53, NULL, NULL, NULL, 32.0, 45.0, 32.0),
('faf2490e-fe39-40e3-8fec-eedc946b58e3', 57, 'Jofra Archer', 'Rajasthan Royals', 'Bowler', 'BOWL', 'BOWL', 'B', 73, 'OVERSEAS', 'English', 1, false, 0, 'https://www.cricbuzz.com/profiles/11540/jofra-archer', 52.0, NULL, NULL, NULL, 59.0, 7.89, 27.15, NULL, NULL, NULL, 56, 41.0, 74.0, 80.0, NULL, NULL, NULL),
('8c136376-1b9c-4528-9a8f-06698c414cb9', 59, 'Rahul Tewatia', 'Gujarat Titans', 'Batting Allrounder', 'AR', 'AR', 'B', 73, 'INDIAN', 'Indian', 1, false, 0, 'https://www.cricbuzz.com/profiles/9693/rahul-tewatia', 108.0, 1112.0, NULL, NULL, 32.0, NULL, NULL, NULL, NULL, NULL, 84, NULL, NULL, NULL, 64.0, 38.0, 38.0),
('d3e468b1-a380-4421-9c1b-fca2facb1306', 30, 'Rishabh Pant', 'Lucknow Super Giants', 'WK-Batsman', 'WK', 'BAT_WK', 'B', 82, 'INDIAN', 'Indian', 1, false, 0, 'https://www.cricbuzz.com/profiles/10744/rishabh-pant', 125.0, 3553.0, 147.62, 34.16, NULL, NULL, NULL, 68.0, 76.0, 85.0, 92, NULL, NULL, NULL, NULL, NULL, NULL),
('f98863f1-9ee5-4578-bc5d-54d25169eefc', 14, 'Ajinkya Rahane', 'Kolkata Knight Riders', 'Batsman', 'BAT', 'BAT_WK', 'A', 91, 'INDIAN', 'Indian', 2, false, 4, 'https://www.cricbuzz.com/profiles/1447/ajinkya-rahane', 198.0, 5032.0, 125.02, 30.5, NULL, NULL, NULL, 95.0, 61.0, 76.0, 99, NULL, NULL, NULL, NULL, NULL, NULL),
('6e656d69-c7af-4a3c-adc6-e43ec8adb012', 134, 'Vipraj Nigam', 'Delhi Capitals', 'Bowler', 'BOWL', 'BOWL', 'C', 59, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/1431811/vipraj-nigam', 14.0, NULL, NULL, NULL, 11.0, 9.13, 32.36, NULL, NULL, NULL, 37, 10.0, 54.0, 69.0, NULL, NULL, NULL),
('62bfa4ef-bb76-4a94-8a55-3182d53f5e3e', 140, 'Mukesh Choudhary', 'Chennai Super Kings', 'Bowler', 'BOWL', 'BOWL', 'C', 58, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/13184/mukesh-choudhary', 16.0, NULL, NULL, NULL, 17.0, 9.94, 30.71, NULL, NULL, NULL, 38, 14.0, 40.0, 72.0, NULL, NULL, NULL),
('721396d6-b872-4e3d-ab9c-1d5530eb860c', 105, 'Mukesh Kumar', 'Delhi Capitals', 'Bowler', 'BOWL', 'BOWL', 'C', 64, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/10754/mukesh-kumar', 32.0, NULL, NULL, NULL, 36.0, 10.4, 30.61, NULL, NULL, NULL, 46, 27.0, 33.0, 73.0, NULL, NULL, NULL),
('a02398c9-6997-499d-9591-c8b20bbe07c4', 68, 'Anrich Nortje', 'Lucknow Super Giants', 'Bowler', 'BOWL', 'BOWL', 'B', 71, 'OVERSEAS', 'South African', 1, false, 0, 'https://www.cricbuzz.com/profiles/11427/anrich-nortje', 48.0, NULL, NULL, NULL, 61.0, 9.07, 27.16, NULL, NULL, NULL, 54, 43.0, 55.0, 80.0, NULL, NULL, NULL),
('566f13ea-3108-4549-9e3c-8e0cf7dd8402', 128, 'Yash Thakur', 'Punjab Kings', 'Bowler', 'BOWL', 'BOWL', 'C', 61, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/12096/yash-thakur', 21.0, NULL, NULL, NULL, 25.0, 10.43, 30.8, NULL, NULL, NULL, 40, 20.0, 32.0, 72.0, NULL, NULL, NULL),
('e270a4db-b690-4ebe-9880-b960500cbcc6', 39, 'Nicholas Pooran', 'Lucknow Super Giants', 'WK-Batsman', 'WK', 'BAT_WK', 'B', 78, 'OVERSEAS', 'West Indian', 1, false, 0, 'https://www.cricbuzz.com/profiles/9406/nicholas-pooran', 90.0, 2293.0, 168.98, 34.22, NULL, NULL, NULL, 46.0, 91.0, 85.0, 75, NULL, NULL, NULL, NULL, NULL, NULL),
('34ff9ffc-8e3c-439f-8572-9433edf8db2a', 13, 'Axar Patel', 'Delhi Capitals', 'Bowling Allrounder', 'AR', 'AR', 'A', 91, 'INDIAN', 'Indian', 2, false, 6, 'https://www.cricbuzz.com/profiles/8808/axar-patel', 162.0, 1916.0, NULL, NULL, 128.0, NULL, NULL, NULL, NULL, NULL, 99, NULL, NULL, NULL, 82.0, 72.0, 72.0),
('1093bb12-6a09-4f7b-b083-0f279c4d2069', 24, 'Varun Chakaravarthy', 'Kolkata Knight Riders', 'Bowler', 'BOWL', 'BOWL', 'B', 84, 'INDIAN', 'Indian', 1, false, 2, 'https://www.cricbuzz.com/profiles/12926/varun-chakaravarthy', 83.0, NULL, NULL, NULL, 100.0, 7.58, 23.85, NULL, NULL, NULL, 71, 68.0, 79.0, 87.0, NULL, NULL, NULL),
('f63c1332-0d19-474d-bb63-3efb12f17cd6', 26, 'Jaydev Unadkat', 'Sunrisers Hyderabad', 'Bowler', 'BOWL', 'BOWL', 'B', 83, 'INDIAN', 'Indian', 1, false, 2, 'https://www.cricbuzz.com/profiles/6327/jaydev-unadkat', 112.0, NULL, NULL, NULL, 110.0, 8.88, 30.58, NULL, NULL, NULL, 86, 74.0, 58.0, 73.0, NULL, NULL, NULL),
('cdc4de13-2840-417a-adb1-6073544f27d9', 80, 'Lockie Ferguson', 'Punjab Kings', 'Bowler', 'BOWL', 'BOWL', 'C', 69, 'OVERSEAS', 'New Zealander', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/10692/lockie-ferguson', 49.0, NULL, NULL, NULL, 51.0, 8.97, 30.0, NULL, NULL, NULL, 54, 36.0, 56.0, 74.0, NULL, NULL, NULL),
('b606e557-8da9-44b6-a9eb-eed4a9808ad7', 7, 'Ravindra Jadeja', 'Rajasthan Royals', 'Bowling Allrounder', 'AR', 'AR', 'A', 95, 'INDIAN', 'Indian', 2, false, 8, 'https://www.cricbuzz.com/profiles/587/ravindra-jadeja', 254.0, 3260.0, NULL, NULL, 170.0, NULL, NULL, NULL, NULL, NULL, 99, NULL, NULL, NULL, 85.0, 78.0, 78.0),
('4ca9fc60-804c-45b4-bcb8-37a2eb11d7a5', 130, 'Sameer Rizvi', 'Delhi Capitals', 'Batsman', 'BAT', 'BAT_WK', 'C', 60, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/14700/sameer-rizvi', 13.0, 172.0, 140.99, 24.57, NULL, NULL, NULL, 7.0, 72.0, 61.0, 36, NULL, NULL, NULL, NULL, NULL, NULL),
('9a572c40-5f3f-4c94-8b6f-75540beda0c3', 75, 'Karun Nair', 'Delhi Capitals', 'Batsman', 'BAT', 'BAT_WK', 'B', 70, 'INDIAN', 'Indian', 1, false, 0, 'https://www.cricbuzz.com/profiles/8257/karun-nair', 84.0, 1694.0, 131.73, 23.86, NULL, NULL, NULL, 35.0, 66.0, 60.0, 72, NULL, NULL, NULL, NULL, NULL, NULL),
('5269841e-13bc-482b-9cd6-fd462150637e', 99, 'Yash Dayal', 'Royal Challengers Bengaluru', 'Bowler', 'BOWL', 'BOWL', 'C', 66, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/14172/yash-dayal', 43.0, NULL, NULL, NULL, 41.0, 9.58, 33.9, NULL, NULL, NULL, 51, 30.0, 46.0, 66.0, NULL, NULL, NULL),
('05379ada-c6c3-4bc6-964b-f839018cf27d', 74, 'Devdutt Padikkal', 'Royal Challengers Bengaluru', 'Batsman', 'BAT', 'BAT_WK', 'B', 70, 'INDIAN', 'Indian', 1, false, 0, 'https://www.cricbuzz.com/profiles/13088/devdutt-padikkal', 74.0, 1806.0, 126.3, 25.44, NULL, NULL, NULL, 37.0, 62.0, 64.0, 67, NULL, NULL, NULL, NULL, NULL, NULL),
('54a12d22-1472-480d-8abb-5f706937c258', 132, 'Kuldeep Sen', 'Rajasthan Royals', 'Bowler', 'BOWL', 'BOWL', 'C', 59, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/14336/kuldeep-sen', 12.0, NULL, NULL, NULL, 14.0, 9.63, 27.64, NULL, NULL, NULL, 36, 12.0, 45.0, 79.0, NULL, NULL, NULL),
('c9e4d1a3-8c3a-49a3-a1b1-92db9b439c5a', 111, 'Ryan Rickelton', 'Mumbai Indians', 'WK-Batsman', 'WK', 'BAT_WK', 'C', 62, 'OVERSEAS', 'South African', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/13070/ryan-rickelton', 14.0, 388.0, 150.98, 29.85, NULL, NULL, NULL, 11.0, 79.0, 74.0, 37, NULL, NULL, NULL, NULL, NULL, NULL),
('acce8e9b-08fe-4f9b-a448-71fbfc62655e', 32, 'David Miller', 'Delhi Capitals', 'Batsman', 'BAT', 'BAT_WK', 'B', 80, 'OVERSEAS', 'South African', 1, false, 0, 'https://www.cricbuzz.com/profiles/6349/david-miller', 141.0, 3077.0, 138.61, 35.78, NULL, NULL, NULL, 60.0, 70.0, 89.0, 99, NULL, NULL, NULL, NULL, NULL, NULL),
('3e922723-72d1-4425-a859-26bab639fdcc', 113, 'Marco Jansen', 'Punjab Kings', 'Bowling Allrounder', 'AR', 'AR', 'C', 62, 'OVERSEAS', 'South African', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/14565/marco-jansen', 35.0, 141.0, NULL, NULL, 36.0, NULL, NULL, NULL, NULL, NULL, 47, NULL, NULL, NULL, 26.0, 36.0, 26.0),
('5fc1963f-eaa3-4b01-819f-d28f99f5d354', 8, 'MS Dhoni', 'Chennai Super Kings', 'WK-Batsman', 'WK', 'BAT_WK', 'A', 95, 'INDIAN', 'Indian', 2, false, 4, 'https://www.cricbuzz.com/profiles/265/ms-dhoni', 278.0, 5439.0, 137.46, 38.3, NULL, NULL, NULL, 99.0, 70.0, 95.0, 99, NULL, NULL, NULL, NULL, NULL, NULL),
('c5f50ed5-4428-4e1b-837c-dbf887faccaa', 125, 'Vaibhav Suryavanshi', 'Rajasthan Royals', 'Batsman', 'BAT', 'BAT_WK', 'C', 61, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/51791/vaibhav-suryavanshi', 7.0, 252.0, 206.56, 36.0, NULL, NULL, NULL, 9.0, 99.0, 89.0, 33, NULL, NULL, NULL, NULL, NULL, NULL),
('c3769f54-b7a0-4ca8-be6a-63603eaef401', 107, 'Shahbaz Ahmed', 'Lucknow Super Giants', 'Bowling Allrounder', 'AR', 'AR', 'C', 64, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/14606/shahbaz-ahmed', 58.0, 545.0, NULL, NULL, 22.0, NULL, NULL, NULL, NULL, NULL, 59, NULL, NULL, NULL, 43.0, 27.0, 27.0),
('7e392ad2-5367-4570-afc2-ec9cb1c78002', 133, 'Kyle Jamieson', 'Delhi Capitals', 'Bowler', 'BOWL', 'BOWL', 'C', 59, 'OVERSEAS', 'New Zealander', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/9441/kyle-jamieson', 13.0, NULL, NULL, NULL, 14.0, 9.67, 29.71, NULL, NULL, NULL, 36, 12.0, 45.0, 74.0, NULL, NULL, NULL),
('4c73b0d6-a8de-4674-a445-8b592cb68103', 40, 'Rahul Chahar', 'Chennai Super Kings', 'Bowler', 'BOWL', 'BOWL', 'B', 77, 'INDIAN', 'Indian', 1, false, 0, 'https://www.cricbuzz.com/profiles/12087/rahul-chahar', 79.0, NULL, NULL, NULL, 75.0, 7.72, 28.67, NULL, NULL, NULL, 69, 52.0, 76.0, 77.0, NULL, NULL, NULL),
('fe17a370-40df-4a8d-8e21-dda7f337f2c2', 34, 'Quinton de Kock', 'Mumbai Indians', 'WK-Batsman', 'WK', 'BAT_WK', 'B', 79, 'OVERSEAS', 'South African', 1, false, 0, 'https://www.cricbuzz.com/profiles/8520/quinton-de-kock', 115.0, 3309.0, 134.03, 30.64, NULL, NULL, NULL, 64.0, 67.0, 76.0, 87, NULL, NULL, NULL, NULL, NULL, NULL),
('a8da8085-3ef1-4ec5-acc6-c22df6e3c28e', 27, 'Shreyas Iyer', 'Punjab Kings', 'Batsman', 'BAT', 'BAT_WK', 'B', 83, 'INDIAN', 'Indian', 1, false, 0, 'https://www.cricbuzz.com/profiles/9428/shreyas-iyer', 132.0, 3731.0, 133.35, 34.23, NULL, NULL, NULL, 72.0, 67.0, 85.0, 96, NULL, NULL, NULL, NULL, NULL, NULL),
('3ba792f2-6cc7-442c-82ff-50de83d71ea1', 141, 'Eshan Malinga', 'Sunrisers Hyderabad', 'Bowler', 'BOWL', 'BOWL', 'C', 58, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/46926/eshan-malinga', 7.0, NULL, NULL, NULL, 13.0, 8.93, 18.31, NULL, NULL, NULL, 33, 12.0, 57.0, 99.0, NULL, NULL, NULL),
('c9cf81f7-adf1-4296-b69b-048cbed2e4b0', 64, 'Shreyas Gopal', 'Chennai Super Kings', 'Bowler', 'BOWL', 'BOWL', 'B', 72, 'INDIAN', 'Indian', 1, false, 0, 'https://www.cricbuzz.com/profiles/9746/shreyas-gopal', 52.0, NULL, NULL, NULL, 52.0, 8.16, 25.92, NULL, NULL, NULL, 56, 37.0, 69.0, 83.0, NULL, NULL, NULL),
('5922a9d3-9e66-4556-8cb5-67eeb4c54076', 97, 'Ramandeep Singh', 'Kolkata Knight Riders', 'Batting Allrounder', 'AR', 'AR', 'C', 66, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/12337/ramandeep-singh', 30.0, 217.0, NULL, NULL, 6.0, NULL, NULL, NULL, NULL, NULL, 45, NULL, NULL, NULL, 46.0, 35.0, 35.0),
('73842dce-2e3a-4bbd-9f47-a4744317f1b0', 154, 'Nuwan Thushara', 'Royal Challengers Bengaluru', 'Bowler', 'BOWL', 'BOWL', 'C', 56, 'OVERSEAS', 'Sri Lankan', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/18509/nuwan-thushara', 8.0, NULL, NULL, NULL, 9.0, 9.43, 31.44, NULL, NULL, NULL, 34, 9.0, 49.0, 71.0, NULL, NULL, NULL),
('290bb03a-2843-43ac-a448-b00ed045f73f', 21, 'Krunal Pandya', 'Royal Challengers Bengaluru', 'Batting Allrounder', 'AR', 'AR', 'A', 86, 'INDIAN', 'Indian', 2, true, 4, 'https://www.cricbuzz.com/profiles/11311/krunal-pandya', 142.0, 1748.0, NULL, NULL, 93.0, NULL, NULL, NULL, NULL, NULL, 99, NULL, NULL, NULL, 77.0, 60.0, 60.0),
('eadfa33d-511d-4673-8f7e-d09a656deba9', 119, 'Wanindu Hasaranga', 'Lucknow Super Giants', 'Bowling Allrounder', 'AR', 'AR', 'C', 62, 'OVERSEAS', 'Sri Lankan', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/10926/wanindu-hasaranga', 37.0, 81.0, NULL, NULL, 46.0, NULL, NULL, NULL, NULL, NULL, 48, NULL, NULL, NULL, 15.0, 45.0, 15.0),
('fe0f6043-224f-4b23-a8a4-07cd37cb970a', 37, 'Ishan Kishan', 'Sunrisers Hyderabad', 'WK-Batsman', 'WK', 'BAT_WK', 'B', 78, 'INDIAN', 'Indian', 1, false, 0, 'https://www.cricbuzz.com/profiles/10276/ishan-kishan', 119.0, 2998.0, 137.65, 29.11, NULL, NULL, NULL, 58.0, 70.0, 72.0, 89, NULL, NULL, NULL, NULL, NULL, NULL),
('dc064f88-c4fd-4f5e-a314-1d62c99885dc', 12, 'Trent Boult', 'Mumbai Indians', 'Bowler', 'BOWL', 'BOWL', 'A', 92, 'OVERSEAS', 'New Zealander', 2, false, 4, 'https://www.cricbuzz.com/profiles/8117/trent-boult', 119.0, NULL, NULL, NULL, 143.0, 8.38, 26.2, NULL, NULL, NULL, 89, 96.0, 66.0, 82.0, NULL, NULL, NULL),
('05c99db6-28df-4926-88ea-0f79e3c6951d', 67, 'Ayush Badoni', 'Lucknow Super Giants', 'Batting Allrounder', 'AR', 'AR', 'B', 71, 'INDIAN', 'Indian', 1, false, 0, 'https://www.cricbuzz.com/profiles/13907/ayush-badoni', 56.0, 963.0, NULL, NULL, 4.0, NULL, NULL, NULL, NULL, NULL, 58, NULL, NULL, NULL, 63.0, 37.0, 37.0),
('266a05b5-2dba-4aca-bf8b-7cf00d3a4d5d', 58, 'Riyan Parag', 'Rajasthan Royals', 'Batting Allrounder', 'AR', 'AR', 'B', 73, 'INDIAN', 'Indian', 1, false, 2, 'https://www.cricbuzz.com/profiles/12305/riyan-parag', 83.0, 1566.0, NULL, NULL, 7.0, NULL, NULL, NULL, NULL, NULL, 71, NULL, NULL, NULL, 78.0, 16.0, 16.0),
('f865cd66-05fc-4836-ac3b-f864b5b166be', 108, 'Rovman Powell', 'Kolkata Knight Riders', 'Batsman', 'BAT', 'BAT_WK', 'C', 63, 'OVERSEAS', 'West Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/11445/rovman-powell', 28.0, 365.0, 146.59, 18.25, NULL, NULL, NULL, 11.0, 76.0, 46.0, 44, NULL, NULL, NULL, NULL, NULL, NULL),
('b83ff560-68f6-441f-8626-81720e7d81bd', 28, 'Kuldeep Yadav', 'Delhi Capitals', 'Bowler', 'BOWL', 'BOWL', 'B', 83, 'INDIAN', 'Indian', 1, false, 2, 'https://www.cricbuzz.com/profiles/8292/kuldeep-yadav', 98.0, NULL, NULL, NULL, 102.0, 8.04, 26.95, NULL, NULL, NULL, 79, 69.0, 71.0, 80.0, NULL, NULL, NULL),
('fe806bd0-980f-443f-b96b-0bcc2717f324', 153, 'Urvil Patel', 'Chennai Super Kings', 'WK-Batsman', 'WK', 'BAT_WK', 'C', 56, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/13476/urvil-patel', 3.0, 68.0, 212.5, 22.67, NULL, NULL, NULL, 5.0, 99.0, 57.0, 31, NULL, NULL, NULL, NULL, NULL, NULL),
('0144db90-0ffb-48ce-89f3-5fbaa94dcf95', 114, 'Mitchell Santner', 'Mumbai Indians', 'Bowling Allrounder', 'AR', 'AR', 'C', 62, 'OVERSEAS', 'New Zealander', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/10100/mitchell-santner', 31.0, 110.0, NULL, NULL, 25.0, NULL, NULL, NULL, NULL, NULL, 45, NULL, NULL, NULL, 25.0, 40.0, 25.0),
('356b034a-46eb-4e30-b79f-40ae3878b2ce', 17, 'Mohammed Shami', 'Lucknow Super Giants', 'Bowler', 'BOWL', 'BOWL', 'A', 89, 'INDIAN', 'Indian', 2, false, 4, 'https://www.cricbuzz.com/profiles/7909/mohammed-shami', 119.0, NULL, NULL, NULL, 133.0, 8.63, 28.18, NULL, NULL, NULL, 89, 89.0, 62.0, 78.0, NULL, NULL, NULL),
('0309c7bf-b680-4079-afde-b63740f30819', 42, 'Ruturaj Gaikwad', 'Chennai Super Kings', 'Batsman', 'BAT', 'BAT_WK', 'B', 77, 'INDIAN', 'Indian', 1, false, 0, 'https://www.cricbuzz.com/profiles/11813/ruturaj-gaikwad', 71.0, 2502.0, 137.48, 40.35, NULL, NULL, NULL, 49.0, 70.0, 99.0, 65, NULL, NULL, NULL, NULL, NULL, NULL),
('6a0f73d6-5538-425e-a9fe-15d200e84e75', 152, 'Anukul Roy', 'Kolkata Knight Riders', 'Batting Allrounder', 'AR', 'AR', 'C', 56, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/12344/anukul-roy', 11.0, 26.0, NULL, NULL, 6.0, NULL, NULL, NULL, NULL, NULL, 35, NULL, NULL, NULL, 17.0, 29.0, 17.0),
('3d64eaad-1f5a-4678-8648-85ad8238cc5c', 82, 'Jitesh Sharma', 'Royal Challengers Bengaluru', 'WK-Batsman', 'WK', 'BAT_WK', 'C', 68, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/10214/jitesh-sharma', 55.0, 991.0, 157.06, 25.41, NULL, NULL, NULL, 22.0, 83.0, 63.0, 57, NULL, NULL, NULL, NULL, NULL, NULL),
('5350af6c-91ea-4306-b906-fd9b408a4234', 18, 'Rashid Khan', 'Gujarat Titans', 'Bowling Allrounder', 'AR', 'AR', 'A', 89, 'OVERSEAS', 'Afghan', 2, false, 8, 'https://www.cricbuzz.com/profiles/10738/rashid-khan', 136.0, 585.0, NULL, NULL, 158.0, NULL, NULL, NULL, NULL, NULL, 98, NULL, NULL, NULL, 51.0, 82.0, 51.0),
('fe172b44-c0ea-48cb-9045-49fd79bfefcb', 66, 'Philip Salt', 'Royal Challengers Bengaluru', 'WK-Batsman', 'WK', 'BAT_WK', 'B', 71, 'OVERSEAS', 'English', 1, false, 0, 'https://www.cricbuzz.com/profiles/10479/philip-salt', 34.0, 1056.0, 175.71, 34.06, NULL, NULL, NULL, 23.0, 95.0, 84.0, 47, NULL, NULL, NULL, NULL, NULL, NULL),
('f1f66810-4ea8-49a0-8976-1aa0173fffcf', 87, 'Tushar Deshpande', 'Rajasthan Royals', 'Bowler', 'BOWL', 'BOWL', 'C', 67, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/11307/tushar-deshpande', 46.0, NULL, NULL, NULL, 51.0, 9.84, 31.04, NULL, NULL, NULL, 53, 36.0, 42.0, 72.0, NULL, NULL, NULL),
('5e1b3848-ad59-4dc5-b587-981f908f580a', 50, 'Mitchell Marsh', 'Lucknow Super Giants', 'Batting Allrounder', 'AR', 'AR', 'B', 74, 'OVERSEAS', 'Australian', 1, false, 0, 'https://www.cricbuzz.com/profiles/6250/mitchell-marsh', 55.0, 1292.0, NULL, NULL, 37.0, NULL, NULL, NULL, NULL, NULL, 57, NULL, NULL, NULL, 72.0, 43.0, 43.0),
('4e6e100c-48a6-4b81-938a-2d7b33c57d7e', 38, 'Shardul Thakur', 'Mumbai Indians', 'Bowling Allrounder', 'AR', 'AR', 'B', 78, 'INDIAN', 'Indian', 1, false, 6, 'https://www.cricbuzz.com/profiles/8683/shardul-thakur', 105.0, 325.0, NULL, NULL, 107.0, NULL, NULL, NULL, NULL, NULL, 82, NULL, NULL, NULL, 38.0, 59.0, 38.0),
('909ae5ae-46eb-4e96-8e7f-378d9eed668a', 60, 'Noor Ahmad', 'Chennai Super Kings', 'Bowler', 'BOWL', 'BOWL', 'B', 72, 'OVERSEAS', 'Afghan', 1, false, 0, 'https://www.cricbuzz.com/profiles/15452/noor-ahmad', 37.0, NULL, NULL, NULL, 48.0, 8.08, 22.23, NULL, NULL, NULL, 48, 34.0, 71.0, 90.0, NULL, NULL, NULL),
('b91c24b4-070f-416c-8494-7d7cd51d33d4', 5, 'Bhuvneshwar Kumar', 'Royal Challengers Bengaluru', 'Bowler', 'BOWL', 'BOWL', 'A', 98, 'INDIAN', 'Indian', 2, false, 8, 'https://www.cricbuzz.com/profiles/1726/bhuvneshwar-kumar', 190.0, NULL, NULL, NULL, 198.0, 7.69, 27.33, NULL, NULL, NULL, 99, 99.0, 77.0, 80.0, NULL, NULL, NULL),
('2143af9f-f78d-4a31-a6a3-7e999003f077', 155, 'Swapnil Singh', 'Royal Challengers Bengaluru', 'Bowling Allrounder', 'AR', 'AR', 'C', 56, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/10238/swapnil-singh', 14.0, 51.0, NULL, NULL, 7.0, NULL, NULL, NULL, NULL, NULL, 37, NULL, NULL, NULL, 23.0, 27.0, 23.0),
('608fe965-9274-408d-8b88-d14c69b632d0', 35, 'Deepak Chahar', 'Mumbai Indians', 'Bowler', 'BOWL', 'BOWL', 'B', 78, 'INDIAN', 'Indian', 1, false, 0, 'https://www.cricbuzz.com/profiles/7836/deepak-chahar', 95.0, NULL, NULL, NULL, 88.0, 8.14, 29.51, NULL, NULL, NULL, 77, 60.0, 70.0, 75.0, NULL, NULL, NULL),
('726267eb-b49d-4ee8-b710-fdb1362deb6d', 146, 'Anshul Kamboj', 'Chennai Super Kings', 'Bowling Allrounder', 'AR', 'AR', 'C', 57, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/14598/anshul-kamboj', 11.0, 16.0, NULL, NULL, 10.0, NULL, NULL, NULL, NULL, NULL, 35, NULL, NULL, NULL, 21.0, 30.0, 21.0),
('bc7948ed-6f3c-4a56-b510-8c4363850c03', 46, 'Avesh Khan', 'Lucknow Super Giants', 'Bowler', 'BOWL', 'BOWL', 'B', 76, 'INDIAN', 'Indian', 1, false, 0, 'https://www.cricbuzz.com/profiles/9781/avesh-khan', 75.0, NULL, NULL, NULL, 87.0, 9.12, 28.29, NULL, NULL, NULL, 67, 60.0, 54.0, 77.0, NULL, NULL, NULL),
('9fadfede-b4d7-44c9-8b48-f1e6014876e8', 129, 'Anuj Rawat', 'Gujarat Titans', 'WK-Batsman', 'WK', 'BAT_WK', 'C', 60, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/13135/anuj-rawat', 24.0, 318.0, 119.11, 19.88, NULL, NULL, NULL, 10.0, 57.0, 50.0, 42, NULL, NULL, NULL, NULL, NULL, NULL),
('24955f90-5914-4aaa-acc9-3f9c0e8dfc06', 156, 'Matthew Short', 'Chennai Super Kings', 'Batsman', 'BAT', 'BAT_WK', 'C', 55, 'OVERSEAS', 'Australian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/9456/matthew-short', 6.0, 117.0, 127.18, 19.5, NULL, NULL, NULL, 6.0, 63.0, 49.0, 33, NULL, NULL, NULL, NULL, NULL, NULL),
('1a75a535-8b90-4301-836d-184b1eaed5c3', 131, 'Romario Shepherd', 'Royal Challengers Bengaluru', 'Bowling Allrounder', 'AR', 'AR', 'C', 60, 'OVERSEAS', 'West Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/13646/romario-shepherd', 18.0, 185.0, NULL, NULL, 10.0, NULL, NULL, NULL, NULL, NULL, 39, NULL, NULL, NULL, 52.0, 18.0, 18.0),
('39b60fda-0a8b-41a3-9e07-cd11b6b6af45', 90, 'Naman Dhir', 'Mumbai Indians', 'Batsman', 'BAT', 'BAT_WK', 'C', 67, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/36139/naman-dhir', 23.0, 392.0, 180.65, 28.0, NULL, NULL, NULL, 11.0, 99.0, 70.0, 41, NULL, NULL, NULL, NULL, NULL, NULL),
('aeec0322-0b14-4bc9-ab65-df29853fe7ac', 117, 'Dewald Brevis', 'Chennai Super Kings', 'Batsman', 'BAT', 'BAT_WK', 'C', 62, 'OVERSEAS', 'South African', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/20538/dewald-brevis', 16.0, 455.0, 153.2, 28.44, NULL, NULL, NULL, 12.0, 80.0, 71.0, 38, NULL, NULL, NULL, NULL, NULL, NULL),
('34ef3501-f5e9-4cc9-9ec0-64a06e6fd717', 47, 'Yashasvi Jaiswal', 'Rajasthan Royals', 'Batsman', 'BAT', 'BAT_WK', 'B', 75, 'INDIAN', 'Indian', 1, false, 0, 'https://www.cricbuzz.com/profiles/13940/yashasvi-jaiswal', 66.0, 2166.0, 152.86, 34.38, NULL, NULL, NULL, 43.0, 80.0, 85.0, 63, NULL, NULL, NULL, NULL, NULL, NULL),
('3f30779f-b1b9-4e92-9a0d-acdef89a532f', 124, 'Shubham Dubey', 'Rajasthan Royals', 'Batsman', 'BAT', 'BAT_WK', 'C', 61, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/19328/shubham-dubey', 13.0, 139.0, 163.53, 23.17, NULL, NULL, NULL, 6.0, 87.0, 58.0, 36, NULL, NULL, NULL, NULL, NULL, NULL),
('64b484ee-dd83-4a32-a43c-257472af5b99', 16, 'Suryakumar Yadav', 'Mumbai Indians', 'Batsman', 'BAT', 'BAT_WK', 'A', 89, 'INDIAN', 'Indian', 2, false, 2, 'https://www.cricbuzz.com/profiles/7915/suryakumar-yadav', 166.0, 4311.0, 148.66, 35.05, NULL, NULL, NULL, 82.0, 77.0, 87.0, 99, NULL, NULL, NULL, NULL, NULL, NULL),
('4ee0b7c8-4d22-4387-a12a-1079b2ab5b78', 51, 'Sam Curran', 'Rajasthan Royals', 'Bowling Allrounder', 'AR', 'AR', 'B', 74, 'OVERSEAS', 'English', 1, false, 2, 'https://www.cricbuzz.com/profiles/10420/sam-curran', 64.0, 997.0, NULL, NULL, 59.0, NULL, NULL, NULL, NULL, NULL, 62, NULL, NULL, NULL, 62.0, 41.0, 41.0),
('e3a501fd-3742-4de4-9ed9-53c68030cfb4', 10, 'Harshal Patel', 'Sunrisers Hyderabad', 'Bowler', 'BOWL', 'BOWL', 'A', 94, 'INDIAN', 'Indian', 2, false, 6, 'https://www.cricbuzz.com/profiles/8175/harshal-patel', 119.0, NULL, NULL, NULL, 151.0, 8.86, 23.7, NULL, NULL, NULL, 89, 99.0, 58.0, 87.0, NULL, NULL, NULL),
('37a93671-896c-4a40-9d04-5da6f6da1491', 52, 'Rahul Tripathi', 'Kolkata Knight Riders', 'Batsman', 'BAT', 'BAT_WK', 'B', 74, 'INDIAN', 'Indian', 1, false, 0, 'https://www.cricbuzz.com/profiles/9012/rahul-tripathi', 100.0, 2291.0, 137.85, 26.03, NULL, NULL, NULL, 46.0, 70.0, 65.0, 80, NULL, NULL, NULL, NULL, NULL, NULL),
('cc408933-3f4f-4434-b2fe-5c06036149d7', 142, 'Kamindu Mendis', 'Sunrisers Hyderabad', 'Batting Allrounder', 'AR', 'AR', 'C', 57, 'OVERSEAS', 'Sri Lankan', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/10940/kamindu-mendis', 5.0, 92.0, NULL, NULL, 2.0, NULL, NULL, NULL, NULL, NULL, 32, NULL, NULL, NULL, 38.0, 29.0, 29.0),
('62aa126e-c762-4f23-84f9-715a843b0e3e', 15, 'Sanju Samson', 'Chennai Super Kings', 'WK-Batsman', 'WK', 'BAT_WK', 'A', 89, 'INDIAN', 'Indian', 2, false, 2, 'https://www.cricbuzz.com/profiles/8271/sanju-samson', 176.0, 4704.0, 139.05, 30.75, NULL, NULL, NULL, 89.0, 71.0, 76.0, 99, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT INTO "AuctionPlayer" (id, player_id, status) VALUES
('b41aea86-c94a-4e23-a197-b3fe6f2c85b5', '6937550e-d46e-4896-89b8-c0abdee957c6', 'UNSOLD'),
('9af650fb-2452-4a69-a6c7-81449e5df14d', '4f56d201-ca96-4642-b59e-6384f19840f3', 'UNSOLD'),
('c0d95316-605e-4ec8-b19b-c5b5d877c62b', 'fae3ec75-eb02-4a9d-b2cc-91d5a05b7e05', 'UNSOLD'),
('44895a90-b556-4fc1-a2bc-8a685acb50bf', '839de8a9-4d0b-44e8-b19c-cb71d4ae8130', 'UNSOLD'),
('1ef3c033-42de-45e3-90e6-f8ae437b2721', '4033080f-b718-40df-9ca5-77a399147247', 'UNSOLD'),
('fc1bc6e9-07c2-4dc1-8c77-216f6079ed35', 'bdb9fede-ab19-404f-8ed1-2e176fc274ac', 'UNSOLD'),
('7d1a3f51-ca49-4073-8b39-cbff0a269cca', '50a14274-d927-4455-8ebb-8e6558b9e39c', 'UNSOLD'),
('01465543-28a4-4ff9-bf5f-3e0542cd5bbc', '798fa776-3a48-4b37-8d2a-397416026714', 'UNSOLD'),
('6e73a791-1771-4c66-8a8b-94a9db338ee0', 'de062a80-5513-45b0-b48f-8b6709ec64fc', 'UNSOLD'),
('46eebac9-f77f-48ba-bd31-97f611f55284', 'c82e950a-1694-4bbe-a1be-05f2e716a960', 'UNSOLD'),
('2acdbfa5-eb56-4aea-b9c6-0868fd2432ea', 'b478cb23-6b34-4777-bec1-02bcd61dcc04', 'UNSOLD'),
('4a2fc8dd-ae47-4ead-8962-aa11b3da55c9', '86f8af0e-05e4-4c52-bf61-72d96a0e71ea', 'UNSOLD'),
('7cfa881d-4a5a-4b3f-ae7a-4341612307a5', 'ea18c59b-8ee0-4b72-9dc2-d8600e6054d8', 'UNSOLD'),
('092a0e60-907a-40d2-a951-d18ea74a1d44', 'd06a3629-ae60-4ba4-bc23-01dbaf5a2870', 'UNSOLD'),
('89772c4a-eaa6-438b-96ed-3885461aa918', '37364181-e3a2-4cc2-b060-04454e870060', 'UNSOLD'),
('68f2afbf-b880-4997-b565-aa9dda52bfd9', '326ac459-0d6f-4aaa-99a5-ca96462256df', 'UNSOLD'),
('08fcb670-05b0-4dbd-9ebf-b4d2c11a09b2', 'bfef23cb-edb8-4255-b547-a5cf7598d529', 'UNSOLD'),
('ab1ad1c1-7ad1-4049-8074-047427a10a73', 'b52f4972-6656-48e4-aa20-e4ba5aca791e', 'UNSOLD'),
('eced4acb-ade6-4b37-912a-4cdc2f6c935e', 'f077e4a7-815d-4bd2-b8d4-ad2a115cc8c0', 'UNSOLD'),
('dfbc6f56-bd92-4494-a2db-ecdad5704e37', 'ff8eafd8-e4cc-4d40-b2e1-881733128eb0', 'UNSOLD'),
('95352046-8b76-4459-994c-fb872bc47cdb', '4edbb1ed-730c-4012-b302-100eda17be5a', 'UNSOLD'),
('c01460f3-c61f-43e2-a70e-c64c5c5ea813', 'b8cee49c-f3a8-4563-ad4a-1422860069f5', 'UNSOLD'),
('89debe4d-7389-45af-98b2-7f445e4b3378', 'df0f22bb-e45b-466a-8625-b4c481b37c3b', 'UNSOLD'),
('b792f1be-4715-435a-b7d7-ed90afc45b1b', '50356e72-baa6-4bea-80e3-37f2dcb79e48', 'UNSOLD'),
('004cf8f6-9d15-4920-9cbe-4b3cf840a18d', 'b1172915-5ec3-4dde-9f9e-c9cc8b76d72a', 'UNSOLD'),
('6d6b31cd-37dc-4828-aabe-42a6850b035c', 'ee581742-54f3-4078-bc8c-f03c14d04c67', 'UNSOLD'),
('bbf2ad64-9e62-4950-a504-27b94275d6fe', 'a9cb6194-6802-452f-9cdd-667361b135cc', 'UNSOLD'),
('2742a587-8842-4cc4-beec-7d370c0c3254', '10fdad7e-643d-4a8f-8735-bcfc688776e8', 'UNSOLD'),
('2b5b0f2b-44e0-4158-9a30-b39460738b27', '77d8ab47-04a9-4a30-955d-9b6f7d3c40bd', 'UNSOLD'),
('53a14f8c-e15e-4aa2-8920-964160e34aec', '32d17ba0-6a0a-4bd0-bab6-9405a081082e', 'UNSOLD'),
('35a13005-8ea5-4d8e-9b11-632631e6dcc7', 'da29d142-3d60-4be2-9df6-9dbe4cd1d292', 'UNSOLD'),
('85394027-46de-4627-a5a5-44117cf44f14', 'f27b8434-d165-4469-8798-5aedf5d8c32b', 'UNSOLD'),
('848420f3-893b-49ff-b2c7-4eebc8edcf7f', '50da966c-ac66-4cb8-bd52-c7e3611dece2', 'UNSOLD'),
('3efe2b77-2f91-4476-ba2a-de8185be5b7d', '34a9d7a0-55ea-4014-9fef-22b11b048a00', 'UNSOLD'),
('32b32b14-35a9-48b2-a8e4-f947090ea9b4', 'df807f6a-872d-4d0b-9d86-0910dc2833ef', 'UNSOLD'),
('f07133e8-e1b8-41cb-94e6-261c449e1cd3', 'd089b3e3-64cc-4696-b575-5d0221bc0a77', 'UNSOLD'),
('dc7eba20-1afc-43a5-8ebe-a6986079096f', '5f31a5ac-d5be-4a3c-b3e7-ee40217b27df', 'UNSOLD'),
('14bf22f6-0fb8-4283-8d33-43602d2b3119', '630a26a0-138a-4d94-b1ba-8eba682f322b', 'UNSOLD'),
('04aa59dd-d1a7-4395-a233-1626d2d17aa2', 'bcf5b10a-ef79-47b8-95f2-6fb9c7b94b6e', 'UNSOLD'),
('8872e563-1fc4-43a3-b407-6b741a0e3927', '2e638ca6-f946-47e4-bcbd-0fa3f570ca3c', 'UNSOLD'),
('ee673dd9-8200-434f-831e-15ad1e7df3ba', '60ab7d3c-2425-49be-b88c-dccaaef84ea2', 'UNSOLD'),
('5951db8a-2e50-4015-8135-91f47bc76e99', '16757581-4418-44a5-ac68-fb6686a9ef6a', 'UNSOLD'),
('9b988e52-7c01-4c91-92ad-72d0f72e2097', 'b6e9cc05-bf50-4cc9-8359-5f672ec5d286', 'UNSOLD'),
('7ce38a80-d5e8-4587-9acb-620275f67d7a', '404fa78a-ba47-4e55-bb87-2e6426f40fc3', 'UNSOLD'),
('678727e2-df10-4d96-9df4-cff048ab0946', 'd5e22224-5122-4303-aa27-3faa56953172', 'UNSOLD'),
('b8ce3c3c-74ce-4c02-a688-1fc559485782', '49a62f71-9571-4b8e-a1ee-292c9a9a2a71', 'UNSOLD'),
('f7d89a86-5901-47b6-a783-bbc341036cd5', 'bdb914c4-9332-4a9c-8f00-8c9b9dafe680', 'UNSOLD'),
('a1e2e05d-30c6-4a1c-95cc-d99314da5679', '02c98fca-bda0-4a6a-9e9b-8e53d3753506', 'UNSOLD'),
('0995a2a0-7dd9-44f2-8b82-80ed171fd679', '2caabdd8-43f3-46cf-8e59-6be1d5d0599f', 'UNSOLD'),
('1c05e272-af6d-4e81-b57e-201ac93c0d1c', '81a39691-ac14-4642-8784-a92782f09154', 'UNSOLD'),
('9ea3afac-fa5b-43e7-8d4b-4c2af9bffa51', 'dc77a2da-5355-4914-8d62-83eca0dc5565', 'UNSOLD'),
('1ebb0f63-f5e9-4dc0-835d-727dece3a14d', 'dfd01c47-589b-466b-b344-26e88fbebdfe', 'UNSOLD'),
('6ea1c21a-0870-46a7-a343-e423145e02b4', 'c9a53737-dc37-42c4-8996-4892fd5c99bd', 'UNSOLD'),
('4f478a49-50be-44c3-8e75-660e593e45cd', '024a9e64-ff20-4f6e-93cc-af90305f4dac', 'UNSOLD'),
('069a95e5-ebfb-4ddd-b244-b66594f7a966', '59abd86e-d5ee-4657-8d0d-88db20a8e655', 'UNSOLD'),
('5efce3a8-8539-4857-8d9c-edfff6e8a62f', '009d8a50-6e49-4391-8239-f0b787219567', 'UNSOLD'),
('225267f5-efbc-4bbb-92d6-2e2e09d76598', 'ee9b8c88-c00f-4861-a0fa-40f0631aa229', 'UNSOLD'),
('c986f9bb-a5ba-4544-b3c7-7636ffd31fa2', 'bed407bb-0ab4-4b19-8581-b0084df9ecb9', 'UNSOLD'),
('ee910278-1aed-4fb4-86e3-9fdf2a8e9844', 'f2a11de4-ac26-424f-a715-6a847e8c28ea', 'UNSOLD'),
('e9e8c03b-6a9b-4b84-a604-f1b4aec68651', '9129b9c1-10cf-4e7d-811c-7ff1dc679e8a', 'UNSOLD'),
('774fe615-d9f7-47d4-bf31-f4f50c019050', 'f5341b13-30c0-4923-a391-b9042a4ea43f', 'UNSOLD'),
('a5311b3d-ad5a-4a92-9605-2e16dd61b3bd', '26390a88-11bb-429f-950e-714a05369f29', 'UNSOLD'),
('82f32af8-6fab-4573-a342-549defd70614', '6fb8f941-9f37-4e87-aa86-fdbab0c6a1a6', 'UNSOLD'),
('8950ffcc-7b82-42ee-a991-42521c7b363b', '980f57a0-79ff-4c02-8dbd-62ed79ac9e36', 'UNSOLD'),
('a5ce097e-cdd4-4a5a-9fb8-b9aeb6eb7f3f', '78bfcb2e-ad7d-48c9-a7f2-ce93c825a095', 'UNSOLD'),
('6d4ba334-ff6a-4441-9561-37dc11265a23', '2f3f2693-05e8-4489-a4c2-5d4166e835b6', 'UNSOLD'),
('43f90175-c779-4125-ba08-ff8fc5d8dccf', '78c12937-250a-48fa-a6c3-73787a7991c0', 'UNSOLD'),
('57bf1abd-1944-437c-be8c-f9732925a931', '954c590e-3b8d-45ad-acd4-9446550bf6ae', 'UNSOLD'),
('260e2462-d896-4aab-8efd-50bf93247eb6', 'df3f8c7b-46cb-489b-9598-5484607ec483', 'UNSOLD'),
('a4c2c7a2-e98f-4f44-9f5a-9cb59147c849', '0c2fb3a4-9f5c-41f7-9200-c1880e5cb16d', 'UNSOLD'),
('681c7ade-e35b-4c4c-8fb2-83c5475e3f88', '14507e3c-16e6-4914-ad54-4fed1ed5470a', 'UNSOLD'),
('0f0551c4-7eee-4579-b556-394df1772a3b', '04f86ea3-c415-459c-935e-18cfced4173b', 'UNSOLD'),
('f3c3c7b4-4ebe-4b83-a5e1-d877e409a43e', 'bf980d29-7651-4280-a4d6-2f3bec1faa0c', 'UNSOLD'),
('9c5d8574-b26e-46d3-a1ac-cc80dee78054', '3745d73a-1466-42d1-b5c0-ec441cfc99c9', 'UNSOLD'),
('c6e9ba2b-262b-443c-8677-65dcb835d411', '7176047c-f6a3-46c6-b68a-b1370fc585fd', 'UNSOLD'),
('985f1e30-e9cb-4606-a83a-190c48f04909', '4d988cbd-983f-4a01-8152-87c161a8bbef', 'UNSOLD'),
('5694f9a4-2965-4b50-8680-cbdb843b7a3a', '45a3b6ee-02e4-4087-bab5-6e7f48f3949c', 'UNSOLD'),
('872c01e4-8196-47fc-9358-2293d7b303ae', '3584ca70-1355-41cf-959e-f102699ad940', 'UNSOLD'),
('3743220c-8b44-43a5-bd4c-6d59555b5f68', '9a2e616b-7f24-4985-9419-746a7080dcff', 'UNSOLD'),
('71978380-fd1c-44b4-b285-ba1a9bc73b9c', 'b9a64c0a-95c5-44bc-af6e-a22ee7681d40', 'UNSOLD'),
('0631010a-ef4c-41c4-8401-ee0a3d730bff', '677200bd-bbbe-44e4-b4df-0a6cf46da091', 'UNSOLD'),
('b35bb54f-3298-418b-9cfd-1826150f750c', '14c5b8ab-f913-452c-b36b-43edd2a305b5', 'UNSOLD'),
('1af0d893-65c7-47d5-834d-5fc4bd4ac57a', '2073f8a7-7c58-49eb-8499-d19f79e4b57d', 'UNSOLD'),
('044ed228-795e-4fbe-abeb-2a1069c28f3d', '6045c276-cfb6-4c20-91b9-15aa415daf1f', 'UNSOLD'),
('3cd1dc3f-50b9-4af5-a6d7-feb1a8f63e82', '99ccd3de-cbb2-4243-8a84-c5a77c695cef', 'UNSOLD'),
('2e5dec54-a4d5-4cb4-a635-8c7dbfbbb95c', '8b85a8b0-0f23-4eea-a3f6-3eed468c6b79', 'UNSOLD'),
('9902404f-b0ca-4848-a8fb-3e93c05a4335', 'c4eda41a-696c-4118-bfba-9bf53dd5c479', 'UNSOLD'),
('77822c55-32c0-4975-a8a1-eba817130607', 'faf2490e-fe39-40e3-8fec-eedc946b58e3', 'UNSOLD'),
('1181f27e-0ae0-4da3-a509-25e244d07bca', '8c136376-1b9c-4528-9a8f-06698c414cb9', 'UNSOLD'),
('42dbab4a-a598-4bcf-bb6d-f0bc8bef6e14', 'd3e468b1-a380-4421-9c1b-fca2facb1306', 'UNSOLD'),
('688fa7c0-660c-490c-a112-dcbbeebafb4a', 'f98863f1-9ee5-4578-bc5d-54d25169eefc', 'UNSOLD'),
('c2ee3f80-48c2-40f0-a317-48f32bb6ee5c', '6e656d69-c7af-4a3c-adc6-e43ec8adb012', 'UNSOLD'),
('5041be70-b5e0-4a64-9aef-3685a3d97b03', '62bfa4ef-bb76-4a94-8a55-3182d53f5e3e', 'UNSOLD'),
('58e11c15-a528-4e22-bd55-3fafc381416b', '721396d6-b872-4e3d-ab9c-1d5530eb860c', 'UNSOLD'),
('16a422c6-5538-417f-ae65-f8f0e95af810', 'a02398c9-6997-499d-9591-c8b20bbe07c4', 'UNSOLD'),
('d15a4e2d-751f-4a09-b6db-0f4fd600d25b', '566f13ea-3108-4549-9e3c-8e0cf7dd8402', 'UNSOLD'),
('aad0d042-f0ef-4b75-a7a4-0e9526c24ab3', 'e270a4db-b690-4ebe-9880-b960500cbcc6', 'UNSOLD'),
('9a1cc5cf-d018-46ea-807a-5f25bfbe60ec', '34ff9ffc-8e3c-439f-8572-9433edf8db2a', 'UNSOLD'),
('b27117f1-5913-4115-ac89-bff1b5c5dad0', '1093bb12-6a09-4f7b-b083-0f279c4d2069', 'UNSOLD'),
('63579ccf-30d2-42e6-98e5-bfb567c8ad48', 'f63c1332-0d19-474d-bb63-3efb12f17cd6', 'UNSOLD'),
('aecd0e01-7fd4-4aee-afdd-d3338369685e', 'cdc4de13-2840-417a-adb1-6073544f27d9', 'UNSOLD'),
('907131b4-88eb-4f55-870f-26781ab9a914', 'b606e557-8da9-44b6-a9eb-eed4a9808ad7', 'UNSOLD'),
('48b0b229-9ca2-4e38-a622-ea643b97aad3', '4ca9fc60-804c-45b4-bcb8-37a2eb11d7a5', 'UNSOLD'),
('5c071af9-35e8-41de-9dea-d8bf06661de4', '9a572c40-5f3f-4c94-8b6f-75540beda0c3', 'UNSOLD'),
('c4629c83-de49-4015-b9c7-c179175c01be', '5269841e-13bc-482b-9cd6-fd462150637e', 'UNSOLD'),
('e496824a-4606-4de8-b644-d4e47ff69ce1', '05379ada-c6c3-4bc6-964b-f839018cf27d', 'UNSOLD'),
('7b643260-540b-4f02-acb1-fe14e933fc48', '54a12d22-1472-480d-8abb-5f706937c258', 'UNSOLD'),
('b0f0b73c-630e-4a16-97e2-bc348735e24b', 'c9e4d1a3-8c3a-49a3-a1b1-92db9b439c5a', 'UNSOLD'),
('07dc2179-7513-4c2b-856f-64af1038cdd8', 'acce8e9b-08fe-4f9b-a448-71fbfc62655e', 'UNSOLD'),
('2c94ba49-54a9-44dc-b90b-1ae2ca2cbcc4', '3e922723-72d1-4425-a859-26bab639fdcc', 'UNSOLD'),
('d488eac5-fc4a-4826-a2b7-3303ca0cdbed', '5fc1963f-eaa3-4b01-819f-d28f99f5d354', 'UNSOLD'),
('b817e55f-3a3d-48ca-b17a-625b08af6278', 'c5f50ed5-4428-4e1b-837c-dbf887faccaa', 'UNSOLD'),
('1c5a9814-9b10-4683-a273-96ad31c602e1', 'c3769f54-b7a0-4ca8-be6a-63603eaef401', 'UNSOLD'),
('0654a1c4-c372-462f-91b0-bb3189d5ee48', '7e392ad2-5367-4570-afc2-ec9cb1c78002', 'UNSOLD'),
('71d7865f-a768-46e1-adf8-c0b9e2fe88a9', '4c73b0d6-a8de-4674-a445-8b592cb68103', 'UNSOLD'),
('94e6e513-9df1-4961-8f86-f4cb312e98ba', 'fe17a370-40df-4a8d-8e21-dda7f337f2c2', 'UNSOLD'),
('4a3c8e07-8edc-4d08-a1cc-8819e305b87e', 'a8da8085-3ef1-4ec5-acc6-c22df6e3c28e', 'UNSOLD'),
('a9c5e75a-bdf4-4fa9-a1db-f59a2250ad8e', '3ba792f2-6cc7-442c-82ff-50de83d71ea1', 'UNSOLD'),
('aaa6b5bf-6a96-4c86-9626-92133af8b76e', 'c9cf81f7-adf1-4296-b69b-048cbed2e4b0', 'UNSOLD'),
('2fc7590b-34a2-49b2-bc61-a7045ed0476f', '5922a9d3-9e66-4556-8cb5-67eeb4c54076', 'UNSOLD'),
('0b41ce3a-aef1-4f90-b4ff-ae7a26e7f2a2', '73842dce-2e3a-4bbd-9f47-a4744317f1b0', 'UNSOLD'),
('ed84ebbb-8e0f-4c94-a5c4-f1dac2ab71c5', '290bb03a-2843-43ac-a448-b00ed045f73f', 'UNSOLD'),
('7d73d791-239a-491d-b3ac-b19651645b3d', 'eadfa33d-511d-4673-8f7e-d09a656deba9', 'UNSOLD'),
('da2144df-5969-4776-b18e-2324f451d9b9', 'fe0f6043-224f-4b23-a8a4-07cd37cb970a', 'UNSOLD'),
('b1e5308b-51fc-446f-9ee7-8740345b1db6', 'dc064f88-c4fd-4f5e-a314-1d62c99885dc', 'UNSOLD'),
('0ded88ca-1187-4f16-a515-f7ed851b7e2e', '05c99db6-28df-4926-88ea-0f79e3c6951d', 'UNSOLD'),
('d1dc1f1b-b71d-439c-b2c1-ba0858e573da', '266a05b5-2dba-4aca-bf8b-7cf00d3a4d5d', 'UNSOLD'),
('b1bc8c89-8145-4a6e-8724-ae5277269cc3', 'f865cd66-05fc-4836-ac3b-f864b5b166be', 'UNSOLD'),
('07b660d4-a891-41e4-8fe5-02584ff10671', 'b83ff560-68f6-441f-8626-81720e7d81bd', 'UNSOLD'),
('e77fb761-baa5-45d6-84f1-4c45d5fa318c', 'fe806bd0-980f-443f-b96b-0bcc2717f324', 'UNSOLD'),
('9c8610b3-f60c-401b-9c46-650e0489101d', '0144db90-0ffb-48ce-89f3-5fbaa94dcf95', 'UNSOLD'),
('0b7a4162-fceb-459a-a902-fa5349f2f74c', '356b034a-46eb-4e30-b79f-40ae3878b2ce', 'UNSOLD'),
('3b2d10d3-e4aa-4185-b506-976d132ce15a', '0309c7bf-b680-4079-afde-b63740f30819', 'UNSOLD'),
('de6c8c88-3093-431c-9c29-0fd8d65d198c', '6a0f73d6-5538-425e-a9fe-15d200e84e75', 'UNSOLD'),
('a546dbaa-aac3-4be7-b424-6fc1e2660412', '3d64eaad-1f5a-4678-8648-85ad8238cc5c', 'UNSOLD'),
('a9919232-3f07-43af-a863-f633a71dac1b', '5350af6c-91ea-4306-b906-fd9b408a4234', 'UNSOLD'),
('f4e1b065-2ea0-4b7c-a8d3-f93b2e1b0e65', 'fe172b44-c0ea-48cb-9045-49fd79bfefcb', 'UNSOLD'),
('38b2982d-d1f6-4cdb-8bc8-905994381ba1', 'f1f66810-4ea8-49a0-8976-1aa0173fffcf', 'UNSOLD'),
('89ef438d-a81f-499e-b1b3-f3daf2dc75ee', '5e1b3848-ad59-4dc5-b587-981f908f580a', 'UNSOLD'),
('f49b82a6-3d78-42c3-9ae7-835e50dc0b7f', '4e6e100c-48a6-4b81-938a-2d7b33c57d7e', 'UNSOLD'),
('f17b3dde-7638-4255-8fce-19ee586116ca', '909ae5ae-46eb-4e96-8e7f-378d9eed668a', 'UNSOLD'),
('f2058d67-891e-4ab0-a8d7-ab747e4070d7', 'b91c24b4-070f-416c-8494-7d7cd51d33d4', 'UNSOLD'),
('19c0dd69-48f7-4d20-a6c1-5fd8ba1f543a', '2143af9f-f78d-4a31-a6a3-7e999003f077', 'UNSOLD'),
('2d902a88-d20c-4779-9210-c03ac4bdef19', '608fe965-9274-408d-8b88-d14c69b632d0', 'UNSOLD'),
('ffb77f28-99f8-4d84-839e-a0db1caef232', '726267eb-b49d-4ee8-b710-fdb1362deb6d', 'UNSOLD'),
('46de71f2-74af-4917-859a-0311aac3fc1b', 'bc7948ed-6f3c-4a56-b510-8c4363850c03', 'UNSOLD'),
('75bbb5e4-629d-43bf-8ff4-fb1bd94dcf46', '9fadfede-b4d7-44c9-8b48-f1e6014876e8', 'UNSOLD'),
('d1c3c34f-dde9-4db6-99ee-563f7acae875', '24955f90-5914-4aaa-acc9-3f9c0e8dfc06', 'UNSOLD'),
('0e4a440a-7f4f-4f9c-97fe-a7e8e174fdc1', '1a75a535-8b90-4301-836d-184b1eaed5c3', 'UNSOLD'),
('eb074d12-b0b7-4c8a-8648-a1a296b2e0f4', '39b60fda-0a8b-41a3-9e07-cd11b6b6af45', 'UNSOLD'),
('de742565-4511-4839-a1d1-90f1b1498960', 'aeec0322-0b14-4bc9-ab65-df29853fe7ac', 'UNSOLD'),
('99b54d2e-1da4-45f2-936c-2bf1784c976f', '34ef3501-f5e9-4cc9-9ec0-64a06e6fd717', 'UNSOLD'),
('954eb5d1-1dfe-43c4-9253-078e1c80587b', '3f30779f-b1b9-4e92-9a0d-acdef89a532f', 'UNSOLD'),
('72891e60-acb0-47a5-8cde-109ea7ba4ef0', '64b484ee-dd83-4a32-a43c-257472af5b99', 'UNSOLD'),
('bb834325-3a13-4e17-989d-196072efea81', '4ee0b7c8-4d22-4387-a12a-1079b2ab5b78', 'UNSOLD'),
('334df56b-6c6d-423b-bb3a-1cb7063e2e7d', 'e3a501fd-3742-4de4-9ed9-53c68030cfb4', 'UNSOLD'),
('a1395696-db25-4ed1-a1a5-2cbe4a917004', '37a93671-896c-4a40-9d04-5da6f6da1491', 'UNSOLD'),
('a8c1b337-3474-4b27-b6a2-c658f515f844', 'cc408933-3f4f-4434-b2fe-5c06036149d7', 'UNSOLD'),
('86921df8-b45e-4d33-bb84-0bf7c0e5cbeb', '62aa126e-c762-4f23-84f9-715a843b0e3e', 'UNSOLD');

INSERT INTO "AdminUser" (id, username, password_hash, role) VALUES
('e859f766-ace5-4bc6-b113-72781a318745', 'admin', '$2b$10$k8FP5aIshTwuMvX7rbECouA7ow0jVRjxSw6lS5BNYWEv8D8lNlh1q', 'ADMIN'),
('1bc42810-f25f-4aae-98a0-0fdd56662b15', 'screen', '$2b$10$82jawAme/.32wVH8/1R/revm1s3C.RoNy6f4BVuaS5C.n9plwMZWa', 'SCREEN');

INSERT INTO "AuctionSequence" (id, name, type, sequence_items) VALUES
(1, 'Franchise Auction', 'FRANCHISE', '[3,7,1,9,5,10,2,6,8,4]');

INSERT INTO "AuctionSequence" (id, name, type, sequence_items) VALUES
(2, 'Power Card Auction', 'POWER_CARD', '["GOD_EYE","MULLIGAN","FINAL_STRIKE","BID_FREEZER"]');

INSERT INTO "AuctionSequence" (id, name, type, sequence_items) VALUES
(3, 'Player Auction 1', 'PLAYER', '[6,123,138,145,54,150,71,70,157,86,120,63,2,36,45,96,92,151,69,112,72,139,101,116,77,29,79,20,48,104,100,44,88,81,94,147,122,62,78,149,91,11,148,4,31,121,73,95,135,56,144,61,106,110,22,89,65,49,136,109,118,53,127,102,84,158,41,115,33,43,85,1,25,23,9,55,126,137,93,103,98,76,3,143,159,19,83,57,59,30,14,134,140,105,68,128,39,13,24,26,80,7,130,75,99,74,132,111,32,113,8,125,107,133,40,34,27,141,64,97,154,21,119,37,12,67,58,108,28,153,114,17,42,152,82,18,66,87,50,38,60,5,155,35,146,46,129,156,131,90,117,47,124,16,51,10,52,142,15]');

INSERT INTO "AuctionState" (id, phase, auction_day) VALUES (1, 'NOT_STARTED', 'Day 1');

