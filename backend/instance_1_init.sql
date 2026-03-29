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
('b539e33c-a9f8-4d23-8182-09bc3fa5b1c7', 'Bombay Boozers', 'bombayboozers', '$2b$10$Vxiy1eROO/IdXzFaqAGF1eLvFYebAgJ5joYD6hT5Y8xidb5RDpjTS', 120, 0),
('6d2e7b7e-f794-4f19-a790-9190942ca2d6', 'Bid Lords', 'bidlords', '$2b$10$DRt0pIxWxGiABYplh8ut5.iSr1OmWn5BPZctigvdPlvaNUvK316gK', 120, 0),
('ddb78859-78f4-41e2-9356-34a24398045c', 'Strikers', 'strikers', '$2b$10$utzHbY63wj7EVJogcxoO8OueqhAWIJ.hQlg006QWhWfjMGzdn2762', 120, 0),
('446a2714-a981-4565-a4c9-a308caf7efc6', 'RR', 'rr', '$2b$10$B52E2p15eTZVvFPeCnhiHuHIhTPwTT7GX85ijcH2vvy32SBJtXxTy', 120, 0),
('dc4a78e3-594b-47c6-bd38-151b444e272d', 'Babita Blasters', 'babitablasters', '$2b$10$wmeH/PvjhruSrZX46qns6evTHYl95LpIWjq/.lmqg1ga0oE6fPNSm', 120, 0),
('fad4cdde-8260-4386-a10b-53c5376346ae', 'People''s Ameen Party', 'peoplesameenparty', '$2b$10$7jH7CjEYziDrSaX.KGM.1ulSM68DLkosMD5sp85a1thPLUXhrDs/a', 120, 0),
('94c158d1-8f3d-45a6-9b48-efe308bac622', 'Zenith Strikers', 'zenithstrikers', '$2b$10$WrHlHpI2fLdl8fqPkqrHx.8uCaujjqKyeBEA0fNJ7/.H2yQONlkzi', 120, 0),
('e1fb13e1-d9ba-48f2-a6b3-2cfe2894619d', 'Logic legends', 'logiclegends', '$2b$10$Z8W2su1PB7tzi9fUJa/IwuD06y7YG/UE1y46Tv3NCcj0DvThJ/MV.', 120, 0),
('658ad553-c22e-4816-a9db-9f471926ac6b', 'Thala Knight Challengers', 'thalaknightchallenge', '$2b$10$2rHXx/EqVctryVG6W7Lf6OXKVf8AUfXYtflTQsdxTFE9qxlAxoZri', 120, 0),
('e5736268-460d-4658-806b-2793cb3c4fe5', 'Villains', 'villains', '$2b$10$4RjFZhsWVXiBCl3fIDkjZO9ehB/M4MH9KgRFk5uptyeAyaaHlbzU.', 120, 0);

INSERT INTO "Player" (id, rank, name, team, role, category, pool, grade, rating, nationality, nationality_raw, base_price, is_riddle, riddle_title, riddle_question, legacy, url, matches, bat_runs, bat_sr, bat_average, bowl_wickets, bowl_eco, bowl_avg, sub_scoring, sub_impact, sub_consistency, sub_experience, sub_wicket_taking, sub_economy, sub_efficiency, sub_batting, sub_bowling, sub_versatility) VALUES
('a47e7768-99cc-4eb9-b1c2-9ca0dc1f9534', 6, 'Rohit Sharma', 'Mumbai Indians', 'Batsman', 'BAT', 'BAT_WK', 'A', 96, 'INDIAN', 'Indian', 2, false, NULL, NULL, 8, 'https://www.cricbuzz.com/profiles/576/rohit-sharma', 272.0, 7046.0, 132.1, 29.73, NULL, NULL, NULL, 99.0, 66.0, 74.0, 99, NULL, NULL, NULL, NULL, NULL, NULL),
('7d8ddcf5-334c-4dc6-922f-c1964332520d', 123, 'Ayush Mhatre', 'Chennai Super Kings', 'Batsman', 'BAT', 'BAT_WK', 'C', 61, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/1431163/ayush-mhatre', 7.0, 240.0, 188.98, 34.29, NULL, NULL, NULL, 8.0, 99.0, 85.0, 33, NULL, NULL, NULL, NULL, NULL, NULL),
('5ca29f3c-9216-44df-ac68-177ae1fa25f3', 138, 'Azmatullah Omarzai', 'Punjab Kings', 'Bowling Allrounder', 'AR', 'AR', 'C', 58, 'OVERSEAS', 'Afghan', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/13214/azmatullah-omarzai', 16.0, 99.0, NULL, NULL, 12.0, NULL, NULL, NULL, NULL, NULL, 38, NULL, NULL, NULL, 31.0, 25.0, 25.0),
('5c69c5fe-ede7-4c88-bb93-595f59e5d14e', 145, 'Akash Maharaj Singh', 'Lucknow Super Giants', 'Bowler', 'BOWL', 'BOWL', 'C', 57, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/14696/akash-maharaj-singh', 10.0, NULL, NULL, NULL, 9.0, 9.54, 36.22, NULL, NULL, NULL, 35, 9.0, 47.0, 61.0, NULL, NULL, NULL),
('98fc0b1a-d6b6-41d4-a986-aca163cfe459', 54, 'Heinrich Klaasen', 'Sunrisers Hyderabad', 'WK-Batsman', 'WK', 'BAT_WK', 'B', 74, 'OVERSEAS', 'South African', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/10209/heinrich-klaasen', 49.0, 1480.0, 169.73, 40.0, NULL, NULL, NULL, 31.0, 91.0, 99.0, 54, NULL, NULL, NULL, NULL, NULL, NULL),
('4357f1e4-1f13-4770-a5e7-4dbf5fbb7a63', 150, 'Adam Milne', 'Rajasthan Royals', 'Bowler', 'BOWL', 'BOWL', 'C', 56, 'OVERSEAS', 'New Zealander', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/7625/adam-milne', 10.0, NULL, NULL, NULL, 7.0, 9.48, 46.71, NULL, NULL, NULL, 35, 8.0, 48.0, 38.0, NULL, NULL, NULL),
('d724047f-2891-46a6-892d-34f1baa866e5', 71, 'Matheesha Pathirana', 'Kolkata Knight Riders', 'Bowler', 'BOWL', 'BOWL', 'B', 70, 'OVERSEAS', 'Sri Lankan', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/16458/matheesha-pathirana', 32.0, NULL, NULL, NULL, 47.0, 8.68, 21.62, NULL, NULL, NULL, 46, 34.0, 61.0, 92.0, NULL, NULL, NULL),
('22266d60-176c-485f-93bf-35dd426a0399', 70, 'Venkatesh Iyer', 'Royal Challengers Bengaluru', 'Batting Allrounder', 'AR', 'AR', 'B', 70, 'INDIAN', 'Indian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/10917/venkatesh-iyer', 61.0, 1468.0, NULL, NULL, 3.0, NULL, NULL, NULL, NULL, NULL, 60, NULL, NULL, NULL, 77.0, 16.0, 16.0),
('c6abb549-50d2-46fe-8f3e-f72c76b8f868', 157, 'Manimaran Siddharth', 'Lucknow Super Giants', 'Bowler', 'BOWL', 'BOWL', 'C', 55, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/12930/manimaran-siddharth', 5.0, NULL, NULL, NULL, 3.0, 8.63, 46.0, NULL, NULL, NULL, 32, 5.0, 62.0, 40.0, NULL, NULL, NULL),
('84720fcf-377f-479d-994c-98b9e6e91218', 86, 'Mayank Markande', 'Mumbai Indians', 'Bowler', 'BOWL', 'BOWL', 'C', 67, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/12627/mayank-markande', 37.0, NULL, NULL, NULL, 37.0, 8.91, 28.89, NULL, NULL, NULL, 48, 27.0, 57.0, 76.0, NULL, NULL, NULL),
('f7f78271-37fe-45c3-8eea-ce515a310456', 120, 'Ravisrinivasan Sai Kishore', 'Gujarat Titans', 'Bowling Allrounder', 'AR', 'AR', 'C', 61, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/11595/ravisrinivasan-sai-kishore', 25.0, 18.0, NULL, NULL, 32.0, NULL, NULL, NULL, NULL, NULL, 42, NULL, NULL, NULL, 19.0, 41.0, 19.0),
('f28f748c-a6ee-4b6e-9bd1-d5248d2031df', 63, 'T Natarajan', 'Delhi Capitals', 'Bowler', 'BOWL', 'BOWL', 'B', 72, 'INDIAN', 'Indian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/10225/t-natarajan', 63.0, NULL, NULL, NULL, 67.0, 8.94, 30.12, NULL, NULL, NULL, 61, 47.0, 57.0, 74.0, NULL, NULL, NULL),
('7a537b83-7bc1-4e63-96a1-65931e2d7fd0', 2, 'Yuzvendra Chahal', 'Punjab Kings', 'Bowler', 'BOWL', 'BOWL', 'A', 99, 'INDIAN', 'Indian', 2, false, NULL, NULL, 10, 'https://www.cricbuzz.com/profiles/7910/yuzvendra-chahal', 174.0, NULL, NULL, NULL, 221.0, 7.96, 22.77, NULL, NULL, NULL, 99, 99.0, 73.0, 89.0, NULL, NULL, NULL),
('51087551-e4c2-4bf4-a967-f90b2dc8f701', 36, 'Arshdeep Singh', 'Punjab Kings', 'Bowler', 'BOWL', 'BOWL', 'B', 78, 'INDIAN', 'Indian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/13217/arshdeep-singh', 82.0, NULL, NULL, NULL, 97.0, 9.0, 26.49, NULL, NULL, NULL, 71, 66.0, 56.0, 81.0, NULL, NULL, NULL),
('05c25dcf-8f11-4d81-80a4-8ba3d568339f', 45, 'Shivam Dube', 'Chennai Super Kings', 'Batting Allrounder', 'AR', 'AR', 'B', 76, 'INDIAN', 'Indian', 1, false, NULL, NULL, 2, 'https://www.cricbuzz.com/profiles/11195/shivam-dube', 79.0, 1859.0, NULL, NULL, 5.0, NULL, NULL, NULL, NULL, NULL, 69, NULL, NULL, NULL, 88.0, 20.0, 20.0),
('29c10831-a523-4ad7-abbb-d619202a521e', 96, 'Vaibhav Arora', 'Kolkata Knight Riders', 'Bowler', 'BOWL', 'BOWL', 'C', 66, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/15861/vaibhav-arora', 32.0, NULL, NULL, NULL, 36.0, 9.55, 28.22, NULL, NULL, NULL, 46, 27.0, 47.0, 78.0, NULL, NULL, NULL),
('c0cebb7c-65b2-46ea-a80a-9ad9cf14e977', 92, 'Shashank Singh', 'Punjab Kings', 'Batting Allrounder', 'AR', 'AR', 'C', 67, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/10919/shashank-singh', 41.0, 773.0, NULL, NULL, 1.0, NULL, NULL, NULL, NULL, NULL, 50, NULL, NULL, NULL, 67.0, 14.0, 14.0),
('bc626849-dee6-4c62-959f-ec66e83e0c34', 151, 'Dushmantha Chameera', 'Delhi Capitals', 'Bowler', 'BOWL', 'BOWL', 'C', 56, 'OVERSEAS', 'Sri Lankan', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/8393/dushmantha-chameera', 19.0, NULL, NULL, NULL, 13.0, 9.73, 46.38, NULL, NULL, NULL, 39, 12.0, 44.0, 39.0, NULL, NULL, NULL),
('fe1b363a-8b3c-4b67-8452-3243a142985e', 69, 'Liam Livingstone', 'Sunrisers Hyderabad', 'Batting Allrounder', 'AR', 'AR', 'B', 70, 'OVERSEAS', 'English', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/10045/liam-livingstone', 49.0, 1051.0, NULL, NULL, 13.0, NULL, NULL, NULL, NULL, NULL, 54, NULL, NULL, NULL, 70.0, 28.0, 28.0),
('87d81a8d-f457-4c48-848d-8fb95036a546', 112, 'Nitish Kumar Reddy', 'Sunrisers Hyderabad', 'Batting Allrounder', 'AR', 'AR', 'C', 62, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/14701/nitish-kumar-reddy', 28.0, 485.0, NULL, NULL, 5.0, NULL, NULL, NULL, NULL, NULL, 44, NULL, NULL, NULL, 50.0, 14.0, 14.0),
('44f3396f-cb7d-422e-9545-5b18f788d273', 72, 'Aiden Markram', 'Lucknow Super Giants', 'Batsman', 'BAT', 'BAT_WK', 'B', 70, 'OVERSEAS', 'South African', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/9582/aiden-markram', 57.0, 1440.0, 135.09, 31.3, NULL, NULL, NULL, 30.0, 68.0, 78.0, 58, NULL, NULL, NULL, NULL, NULL, NULL),
('f96595f5-9a99-4cf9-a23f-9247f8aca60d', 139, 'Nandre Burger', 'Rajasthan Royals', 'Bowler', 'BOWL', 'BOWL', 'C', 58, 'OVERSEAS', 'South African', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/13630/nandre-burger', 5.0, NULL, NULL, NULL, 7.0, 8.53, 20.71, NULL, NULL, NULL, 32, 8.0, 63.0, 94.0, NULL, NULL, NULL),
('8e0f2d70-06cf-4b43-9781-0e6f5f4da77b', 101, 'Umran Malik', 'Kolkata Knight Riders', 'Bowler', 'BOWL', 'BOWL', 'C', 65, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/19027/umran-malik', 26.0, NULL, NULL, NULL, 29.0, 9.4, 26.62, NULL, NULL, NULL, 43, 22.0, 49.0, 81.0, NULL, NULL, NULL),
('a2f03df2-31e5-48ae-8561-ff433bc5c6ff', 116, 'Sherfane Rutherford', 'Mumbai Indians', 'Batting Allrounder', 'AR', 'AR', 'C', 62, 'OVERSEAS', 'West Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/13748/sherfane-rutherford', 23.0, 397.0, NULL, NULL, 1.0, NULL, NULL, NULL, NULL, NULL, 41, NULL, NULL, NULL, 48.0, 17.0, 17.0),
('9e5e5df4-e0a1-4d01-b698-d68d4b689474', 77, 'Rinku Singh', 'Kolkata Knight Riders', 'Batsman', 'BAT', 'BAT_WK', 'C', 69, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/10896/rinku-singh', 58.0, 1099.0, 145.18, 30.53, NULL, NULL, NULL, 24.0, 75.0, 76.0, 59, NULL, NULL, NULL, NULL, NULL, NULL),
('2917997a-452c-4c9f-b0c5-56471bc43c79', 29, 'Mohammed Siraj', 'Gujarat Titans', 'Bowler', 'BOWL', 'BOWL', 'B', 83, 'INDIAN', 'Indian', 1, false, NULL, NULL, 2, 'https://www.cricbuzz.com/profiles/10808/mohammed-siraj', 108.0, NULL, NULL, NULL, 109.0, 8.74, 30.72, NULL, NULL, NULL, 84, 74.0, 60.0, 72.0, NULL, NULL, NULL),
('251e12f7-26d0-4ec1-a62a-6f1cffbba68e', 79, 'Prabhsimran Singh', 'Punjab Kings', 'WK-Batsman', 'WK', 'BAT_WK', 'C', 69, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/14254/prabhsimran-singh', 51.0, 1305.0, 151.93, 25.59, NULL, NULL, NULL, 28.0, 79.0, 64.0, 55, NULL, NULL, NULL, NULL, NULL, NULL),
('66dbc2d6-1328-4edb-b00b-a1f80af6d0e4', 20, 'Jos Buttler', 'Gujarat Titans', 'WK-Batsman', 'WK', 'BAT_WK', 'A', 88, 'OVERSEAS', 'English', 2, true, 'The Scoop King', 'I am the absolute "Boss" of scooping terrifyingly fast bowlers right over the keeper''s head. I spent years painting the town pink with my centuries, but now I’m taking my English royalty to the biggest cricket stadium in the world. Who am I?', 2, 'https://www.cricbuzz.com/profiles/2258/jos-buttler', 121.0, 4120.0, 149.39, 40.0, NULL, NULL, NULL, 79.0, 78.0, 99.0, 90, NULL, NULL, NULL, NULL, NULL, NULL),
('c7df7662-56c0-465c-8857-c62d76e26acc', 48, 'Pat Cummins', 'Sunrisers Hyderabad', 'Bowler', 'BOWL', 'BOWL', 'B', 75, 'OVERSEAS', 'Australian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/8095/pat-cummins', 72.0, NULL, NULL, NULL, 79.0, 8.81, 30.04, NULL, NULL, NULL, 66, 54.0, 59.0, 74.0, NULL, NULL, NULL),
('f5ce70b7-1e74-4fd8-a0ec-83f2b8aea95b', 104, 'Lungi Ngidi', 'Delhi Capitals', 'Bowler', 'BOWL', 'BOWL', 'C', 64, 'OVERSEAS', 'South African', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/9603/lungi-ngidi', 16.0, NULL, NULL, NULL, 29.0, 8.53, 18.24, NULL, NULL, NULL, 38, 22.0, 63.0, 99.0, NULL, NULL, NULL),
('de5e2474-2cf3-4cde-9f43-91907cf373cd', 100, 'Abishek Porel', 'Delhi Capitals', 'WK-Batsman', 'WK', 'BAT_WK', 'C', 66, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/24326/abishek-porel', 31.0, 661.0, 149.89, 25.42, NULL, NULL, NULL, 16.0, 78.0, 63.0, 45, NULL, NULL, NULL, NULL, NULL, NULL),
('2b2962a3-f21d-4a18-81ab-8a84d2a9260c', 44, 'Khaleel Ahmed', 'Chennai Super Kings', 'Bowler', 'BOWL', 'BOWL', 'B', 77, 'INDIAN', 'Indian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/10952/khaleel-ahmed', 71.0, NULL, NULL, NULL, 89.0, 8.98, 26.16, NULL, NULL, NULL, 65, 61.0, 56.0, 82.0, NULL, NULL, NULL),
('8ee689c6-0dbd-416e-bd15-6a29aeec2b71', 88, 'Harshit Rana', 'Kolkata Knight Riders', 'Bowler', 'BOWL', 'BOWL', 'C', 67, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/24729/harshit-rana', 33.0, NULL, NULL, NULL, 40.0, 9.51, 25.73, NULL, NULL, NULL, 46, 29.0, 47.0, 83.0, NULL, NULL, NULL),
('fa50fafc-3b34-44dc-9f2e-33034eb86cda', 81, 'Harpreet Brar', 'Punjab Kings', 'Bowler', 'BOWL', 'BOWL', 'C', 68, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/14452/harpreet-brar', 49.0, NULL, NULL, NULL, 35.0, 8.03, 31.0, NULL, NULL, NULL, 54, 26.0, 71.0, 72.0, NULL, NULL, NULL),
('c25d4f0f-0206-4ee1-9c6a-d306e66981d4', 94, 'Will Jacks', 'Mumbai Indians', 'Batting Allrounder', 'AR', 'AR', 'C', 66, 'OVERSEAS', 'English', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/12258/will-jacks', 21.0, 463.0, NULL, NULL, 8.0, NULL, NULL, NULL, NULL, NULL, 40, NULL, NULL, NULL, 55.0, 28.0, 28.0),
('0aca1380-4e93-4e7c-8a84-4df3ca28ee6d', 147, 'Mayank Yadav', 'Lucknow Super Giants', 'Bowler', 'BOWL', 'BOWL', 'C', 57, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/22401/mayank-yadav', 6.0, NULL, NULL, NULL, 9.0, 9.17, 20.56, NULL, NULL, NULL, 33, 9.0, 53.0, 94.0, NULL, NULL, NULL),
('fbdaf797-57ec-4bf4-b529-e8c9a5c6af09', 122, 'Ashutosh Sharma', 'Delhi Capitals', 'Batting Allrounder', 'AR', 'AR', 'C', 61, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/13497/ashutosh-sharma', 24.0, 393.0, NULL, NULL, 0.0, NULL, NULL, NULL, NULL, NULL, 42, NULL, NULL, NULL, 56.0, 0.0, 0.0),
('f289bdcc-247f-47d2-a4c7-d27567de0b95', 62, 'Shimron Hetmyer', 'Rajasthan Royals', 'Batsman', 'BAT', 'BAT_WK', 'B', 72, 'OVERSEAS', 'West Indian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/9789/shimron-hetmyer', 86.0, 1482.0, 151.85, 29.06, NULL, NULL, NULL, 31.0, 79.0, 72.0, 73, NULL, NULL, NULL, NULL, NULL, NULL),
('ffb7841a-bf4f-4bbf-9c19-5b64ecefa722', 78, 'Rajat Patidar', 'Royal Challengers Bengaluru', 'Batsman', 'BAT', 'BAT_WK', 'C', 69, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/10636/rajat-patidar', 42.0, 1111.0, 154.31, 30.86, NULL, NULL, NULL, 24.0, 81.0, 77.0, 51, NULL, NULL, NULL, NULL, NULL, NULL),
('31dfe1c5-9c3b-4fe9-b551-b92927b9bb12', 149, 'Glenn Phillips', 'Gujarat Titans', 'Batting Allrounder', 'AR', 'AR', 'C', 56, 'OVERSEAS', 'New Zealander', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/10693/glenn-phillips', 8.0, 65.0, NULL, NULL, 2.0, NULL, NULL, NULL, NULL, NULL, 34, NULL, NULL, NULL, 24.0, 34.0, 24.0),
('e50ce6a8-e07e-4a4d-b443-29ae97440e80', 91, 'Shahrukh Khan', 'Gujarat Titans', 'Batting Allrounder', 'AR', 'AR', 'C', 67, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/10226/shahrukh-khan', 55.0, 732.0, NULL, NULL, 1.0, NULL, NULL, NULL, NULL, NULL, 57, NULL, NULL, NULL, 56.0, 27.0, 27.0),
('6187fa48-36e4-4f98-a15e-f1529ca38094', 11, 'Sandeep Sharma', 'Rajasthan Royals', 'Bowler', 'BOWL', 'BOWL', 'A', 93, 'INDIAN', 'Indian', 2, false, NULL, NULL, 4, 'https://www.cricbuzz.com/profiles/8356/sandeep-sharma', 136.0, NULL, NULL, NULL, 146.0, 8.03, 27.88, NULL, NULL, NULL, 98, 98.0, 71.0, 78.0, NULL, NULL, NULL),
('c2c8d52d-255b-4f73-9c0d-e6c3f1fd0b95', 148, 'Vignesh Puthur', 'Rajasthan Royals', 'Bowler', 'BOWL', 'BOWL', 'C', 57, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/1447337/vignesh-puthur', 5.0, NULL, NULL, NULL, 6.0, 9.08, 18.17, NULL, NULL, NULL, 32, 7.0, 54.0, 99.0, NULL, NULL, NULL),
('5612301d-72e8-43a6-b61d-f14809dbe5ce', 4, 'Sunil Narine', 'Kolkata Knight Riders', 'Bowling Allrounder', 'AR', 'AR', 'A', 98, 'OVERSEAS', 'West Indian', 2, false, NULL, NULL, 10, 'https://www.cricbuzz.com/profiles/2276/sunil-narine', 188.0, 1780.0, NULL, NULL, 192.0, NULL, NULL, NULL, NULL, NULL, 99, NULL, NULL, NULL, 84.0, 83.0, 83.0),
('e2668b21-a431-4fb2-a2a0-0a7308890a31', 31, 'Manish Pandey', 'Kolkata Knight Riders', 'Batsman', 'BAT', 'BAT_WK', 'B', 82, 'INDIAN', 'Indian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/1836/manish-pandey', 174.0, 3942.0, 121.52, 29.42, NULL, NULL, NULL, 76.0, 59.0, 73.0, 99, NULL, NULL, NULL, NULL, NULL, NULL),
('de226dd1-14ee-4a5e-bf4c-ff5a0c679e92', 121, 'Suyash Sharma', 'Royal Challengers Bengaluru', 'Bowler', 'BOWL', 'BOWL', 'C', 61, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/36487/suyash-sharma', 27.0, NULL, NULL, NULL, 18.0, 8.75, 45.22, NULL, NULL, NULL, 43, 15.0, 60.0, 41.0, NULL, NULL, NULL),
('10b900fc-795a-4ed5-9bfc-c29382d62f45', 73, 'Tim David', 'Royal Challengers Bengaluru', 'Batsman', 'BAT', 'BAT_WK', 'B', 70, 'OVERSEAS', 'Singaporean', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/13169/tim-david', 50.0, 846.0, 173.37, 32.54, NULL, NULL, NULL, 19.0, 94.0, 81.0, 55, NULL, NULL, NULL, NULL, NULL, NULL),
('737871df-c167-4d76-b52e-17310a9bc3ae', 95, 'Nehal Wadhera', 'Punjab Kings', 'Batsman', 'BAT', 'BAT_WK', 'C', 66, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/13915/nehal-wadhera', 36.0, 719.0, 142.95, 26.63, NULL, NULL, NULL, 17.0, 73.0, 66.0, 48, NULL, NULL, NULL, NULL, NULL, NULL),
('90783639-5519-4be8-a570-e74e9ba3cd41', 135, 'Kartik Tyagi', 'Kolkata Knight Riders', 'Bowler', 'BOWL', 'BOWL', 'C', 58, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/13136/kartik-tyagi', 20.0, NULL, NULL, NULL, 15.0, 10.14, 47.53, NULL, NULL, NULL, 40, 13.0, 37.0, 37.0, NULL, NULL, NULL),
('8ef1c0fe-b010-40f4-b605-5faa2913e1c3', 56, 'Josh Hazlewood', 'Royal Challengers Bengaluru', 'Bowler', 'BOWL', 'BOWL', 'B', 73, 'OVERSEAS', 'Australian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/6258/josh-hazlewood', 39.0, NULL, NULL, NULL, 57.0, 8.28, 20.98, NULL, NULL, NULL, 49, 40.0, 67.0, 93.0, NULL, NULL, NULL),
('dc65d029-7d4a-421f-9ab1-5025dadb33c8', 144, 'Vijaykumar Vyshak', 'Punjab Kings', 'Bowler', 'BOWL', 'BOWL', 'C', 57, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/10486/vijaykumar-vyshak', 16.0, NULL, NULL, NULL, 17.0, 10.38, 33.88, NULL, NULL, NULL, 38, 14.0, 33.0, 66.0, NULL, NULL, NULL),
('d781a486-4957-432d-83e2-45a6f2553993', 61, 'Travis Head', 'Sunrisers Hyderabad', 'Batsman', 'BAT', 'BAT_WK', 'B', 72, 'OVERSEAS', 'Australian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/8497/travis-head', 38.0, 1146.0, 170.03, 34.73, NULL, NULL, NULL, 25.0, 92.0, 86.0, 49, NULL, NULL, NULL, NULL, NULL, NULL),
('83b17433-d1f5-43ce-8e57-c0b2ba69814a', 106, 'Sarfaraz Khan', 'Chennai Super Kings', 'Batsman', 'BAT', 'BAT_WK', 'C', 64, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/9429/sarfaraz-khan', 50.0, 585.0, 130.59, 22.5, NULL, NULL, NULL, 15.0, 65.0, 56.0, 55, NULL, NULL, NULL, NULL, NULL, NULL),
('6b86490c-d616-47d6-a9d4-745158df7ce4', 110, 'Josh Inglis', 'Lucknow Super Giants', 'WK-Batsman', 'WK', 'BAT_WK', 'C', 63, 'OVERSEAS', 'Australian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/10637/josh-inglis', 11.0, 278.0, 162.58, 30.89, NULL, NULL, NULL, 9.0, 87.0, 77.0, 35, NULL, NULL, NULL, NULL, NULL, NULL),
('fbd76fbd-0536-4e3b-8e95-219fa46bbc9e', 22, 'Kagiso Rabada', 'Gujarat Titans', 'Bowler', 'BOWL', 'BOWL', 'A', 85, 'OVERSEAS', 'South African', 2, false, NULL, NULL, 2, 'https://www.cricbuzz.com/profiles/9585/kagiso-rabada', 84.0, NULL, NULL, NULL, 119.0, 8.62, 22.96, NULL, NULL, NULL, 72, 80.0, 62.0, 89.0, NULL, NULL, NULL),
('3fac61e2-c3ab-43b3-9501-1e96433aa651', 89, 'Dhruv Jurel', 'Rajasthan Royals', 'WK-Batsman', 'WK', 'BAT_WK', 'C', 67, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/14691/dhruv-jurel', 41.0, 680.0, 153.85, 28.33, NULL, NULL, NULL, 16.0, 81.0, 71.0, 50, NULL, NULL, NULL, NULL, NULL, NULL),
('30257f37-c989-4cc9-921d-e0e06a69a2e7', 65, 'Tilak Varma', 'Mumbai Indians', 'Batsman', 'BAT', 'BAT_WK', 'B', 72, 'INDIAN', 'Indian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/14504/tilak-varma', 54.0, 1499.0, 144.42, 37.48, NULL, NULL, NULL, 31.0, 74.0, 93.0, 57, NULL, NULL, NULL, NULL, NULL, NULL),
('8071c96c-a6d5-4e6f-b85f-dcd7f4ae6163', 49, 'Ravi Bishnoi', 'Rajasthan Royals', 'Bowler', 'BOWL', 'BOWL', 'B', 75, 'INDIAN', 'Indian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/14659/ravi-bishnoi', 77.0, NULL, NULL, NULL, 72.0, 8.22, 31.07, NULL, NULL, NULL, 68, 50.0, 68.0, 72.0, NULL, NULL, NULL),
('ec78b85b-652d-444d-bbd3-6163e2b77a12', 136, 'Arshad Khan', 'Gujarat Titans', 'Bowling Allrounder', 'AR', 'AR', 'C', 58, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/18637/arshad-khan', 19.0, 124.0, NULL, NULL, 12.0, NULL, NULL, NULL, NULL, NULL, 39, NULL, NULL, NULL, 39.0, 18.0, 18.0),
('f0fa2413-1bba-4b76-ae87-6e8866e2ede0', 109, 'Abdul Samad', 'Lucknow Super Giants', 'Batting Allrounder', 'AR', 'AR', 'C', 63, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/14628/abdul-samad', 63.0, 741.0, NULL, NULL, 2.0, NULL, NULL, NULL, NULL, NULL, 61, NULL, NULL, NULL, 57.0, 5.0, 5.0),
('acb8afde-5e66-447b-903e-8447129eadbb', 118, 'Aniket Verma', 'Sunrisers Hyderabad', 'Batsman', 'BAT', 'BAT_WK', 'C', 62, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/1447065/aniket-verma', 14.0, 236.0, 166.2, 26.22, NULL, NULL, NULL, 8.0, 89.0, 65.0, 37, NULL, NULL, NULL, NULL, NULL, NULL),
('aaf50182-baf4-427f-a0f4-39f87ea52aec', 53, 'Prasidh Krishna', 'Gujarat Titans', 'Bowler', 'BOWL', 'BOWL', 'B', 74, 'INDIAN', 'Indian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/10551/prasidh-krishna', 66.0, NULL, NULL, NULL, 74.0, 8.77, 29.61, NULL, NULL, NULL, 63, 51.0, 59.0, 75.0, NULL, NULL, NULL),
('60ba781b-ff36-4a02-bdda-8b9138cd7719', 127, 'Digvesh Singh Rathi', 'Lucknow Super Giants', 'Bowler', 'BOWL', 'BOWL', 'C', 61, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/1448289/digvesh-singh-rathi', 13.0, NULL, NULL, NULL, 14.0, 8.25, 30.64, NULL, NULL, NULL, 36, 12.0, 68.0, 72.0, NULL, NULL, NULL),
('47ae3803-4db2-4218-a4c4-6de14f7505e5', 102, 'Angkrish Raghuvanshi', 'Kolkata Knight Riders', 'Batsman', 'BAT', 'BAT_WK', 'C', 65, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/22566/angkrish-raghuvanshi', 22.0, 463.0, 144.69, 28.94, NULL, NULL, NULL, 12.0, 75.0, 72.0, 41, NULL, NULL, NULL, NULL, NULL, NULL),
('a8776dff-391c-433f-bcf2-4e3d433bcc9b', 84, 'Cameron Green', 'Kolkata Knight Riders', 'Batting Allrounder', 'AR', 'AR', 'C', 68, 'OVERSEAS', 'Australian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/12225/cameron-green', 29.0, 707.0, NULL, NULL, 16.0, NULL, NULL, NULL, NULL, NULL, 44, NULL, NULL, NULL, 64.0, 27.0, 27.0),
('32ea8d21-07d7-43cf-9a43-21df3db812a5', 158, 'Arjun Tendulkar', 'Lucknow Super Giants', 'Bowling Allrounder', 'AR', 'AR', 'C', 55, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/13747/arjun-tendulkar', 5.0, 13.0, NULL, NULL, 3.0, NULL, NULL, NULL, NULL, NULL, 32, NULL, NULL, NULL, 32.0, 23.0, 23.0),
('898cedbd-1f88-4b97-9680-abbd43df0749', 41, 'Nitish Rana', 'Delhi Capitals', 'Batsman', 'BAT', 'BAT_WK', 'B', 77, 'INDIAN', 'Indian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/9204/nitish-rana', 118.0, 2853.0, 136.77, 27.7, NULL, NULL, NULL, 56.0, 69.0, 69.0, 89, NULL, NULL, NULL, NULL, NULL, NULL),
('8a403008-8121-42f0-bd92-615a6c6792a1', 115, 'Rachin Ravindra', 'Kolkata Knight Riders', 'Batting Allrounder', 'AR', 'AR', 'C', 62, 'OVERSEAS', 'New Zealander', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/11177/rachin-ravindra', 18.0, 413.0, NULL, NULL, 0.0, NULL, NULL, NULL, NULL, NULL, 39, NULL, NULL, NULL, 49.0, 29.0, 29.0),
('e99e337e-921e-46d6-851c-ada85a43a2b1', 33, 'Ishant Sharma', 'Gujarat Titans', 'Bowler', 'BOWL', 'BOWL', 'B', 79, 'INDIAN', 'Indian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/702/ishant-sharma', 117.0, NULL, NULL, NULL, 96.0, 8.38, 35.18, NULL, NULL, NULL, 88, 65.0, 66.0, 63.0, NULL, NULL, NULL),
('6787fffb-84d6-475b-a4aa-d71b4aa74ed8', 43, 'Abhishek Sharma', 'Sunrisers Hyderabad', 'Batting Allrounder', 'AR', 'AR', 'B', 77, 'INDIAN', 'Indian', 1, false, NULL, NULL, 2, 'https://www.cricbuzz.com/profiles/12086/abhishek-sharma', 77.0, 1815.0, NULL, NULL, 11.0, NULL, NULL, NULL, NULL, NULL, 68, NULL, NULL, NULL, 90.0, 24.0, 24.0),
('933523a4-805e-43d0-bfc9-06661ba9eb29', 85, 'Mohsin Khan', 'Lucknow Super Giants', 'Bowler', 'BOWL', 'BOWL', 'C', 67, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/13534/mohsin-khan', 24.0, NULL, NULL, NULL, 27.0, 8.51, 25.52, NULL, NULL, NULL, 42, 21.0, 64.0, 83.0, NULL, NULL, NULL),
('5d27d5d7-aeba-48e7-b777-77e48e89c033', 1, 'Virat Kohli', 'Royal Challengers Bengaluru', 'Batsman', 'BAT', 'BAT_WK', 'A', 99, 'INDIAN', 'Indian', 2, false, NULL, NULL, 10, 'https://www.cricbuzz.com/profiles/1413/virat-kohli', 267.0, 8661.0, 132.86, 39.55, NULL, NULL, NULL, 99.0, 67.0, 98.0, 99, NULL, NULL, NULL, NULL, NULL, NULL),
('9942972a-21c2-42bc-a869-87d6d393b093', 25, 'Marcus Stoinis', 'Punjab Kings', 'Batting Allrounder', 'AR', 'AR', 'B', 83, 'OVERSEAS', 'Australian', 1, false, NULL, NULL, 4, 'https://www.cricbuzz.com/profiles/8989/marcus-stoinis', 109.0, 2026.0, NULL, NULL, 44.0, NULL, NULL, NULL, NULL, NULL, 84, NULL, NULL, NULL, 90.0, 37.0, 37.0),
('2dd32543-699a-4d8d-a442-6c8d53d0c98d', 23, 'Shubman Gill', 'Gujarat Titans', 'Batsman', 'BAT', 'BAT_WK', 'B', 84, 'INDIAN', 'Indian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/11808/shubman-gill', 118.0, 3866.0, 138.72, 39.45, NULL, NULL, NULL, 74.0, 70.0, 98.0, 89, NULL, NULL, NULL, NULL, NULL, NULL),
('e853c732-0a72-4be2-8569-7482ecb7f83a', 9, 'KL Rahul', 'Delhi Capitals', 'WK-Batsman', 'WK', 'BAT_WK', 'A', 95, 'INDIAN', 'Indian', 2, false, NULL, NULL, 4, 'https://www.cricbuzz.com/profiles/8733/kl-rahul', 145.0, 5222.0, 136.03, 46.21, NULL, NULL, NULL, 99.0, 69.0, 99.0, 99, NULL, NULL, NULL, NULL, NULL, NULL),
('a19193ad-8053-483a-adc6-33920aae94d5', 55, 'Mitchell Starc', 'Delhi Capitals', 'Bowler', 'BOWL', 'BOWL', 'B', 73, 'OVERSEAS', 'Australian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/7710/mitchell-starc', 51.0, NULL, NULL, NULL, 65.0, 8.61, 23.12, NULL, NULL, NULL, 55, 45.0, 62.0, 88.0, NULL, NULL, NULL),
('eeef0121-e65f-4a9b-918e-0d08486eb02d', 126, 'Nathan Ellis', 'Chennai Super Kings', 'Bowler', 'BOWL', 'BOWL', 'C', 61, 'OVERSEAS', 'Australian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/15480/nathan-ellis', 17.0, NULL, NULL, NULL, 19.0, 8.67, 28.74, NULL, NULL, NULL, 38, 16.0, 61.0, 77.0, NULL, NULL, NULL),
('464e6a18-892b-460d-95f1-cd2c865476ee', 137, 'Jayant Yadav', 'Gujarat Titans', 'Bowling Allrounder', 'AR', 'AR', 'C', 58, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/8182/jayant-yadav', 20.0, 40.0, NULL, NULL, 8.0, NULL, NULL, NULL, NULL, NULL, 40, NULL, NULL, NULL, 22.0, 25.0, 22.0),
('c4a2fc49-875d-4223-8cca-abd46a8b25dd', 93, 'Washington Sundar', 'Gujarat Titans', 'Bowling Allrounder', 'AR', 'AR', 'C', 67, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/10945/washington-sundar', 66.0, 511.0, NULL, NULL, 39.0, NULL, NULL, NULL, NULL, NULL, 63, NULL, NULL, NULL, 42.0, 40.0, 40.0),
('4ef5f494-cf20-41df-a5b2-bf711ce232f1', 103, 'Priyansh Arya', 'Punjab Kings', 'Batsman', 'BAT', 'BAT_WK', 'C', 64, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/14689/priyansh-arya', 17.0, 475.0, 179.25, 27.94, NULL, NULL, NULL, 13.0, 98.0, 70.0, 38, NULL, NULL, NULL, NULL, NULL, NULL),
('a612f859-1956-4141-a24b-75bbe3e3abeb', 98, 'Shivam Mavi', 'Sunrisers Hyderabad', 'Bowler', 'BOWL', 'BOWL', 'C', 66, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/12345/shivam-mavi', 32.0, NULL, NULL, NULL, 30.0, 8.71, 31.4, NULL, NULL, NULL, 46, 23.0, 60.0, 71.0, NULL, NULL, NULL),
('1e8a73df-b57f-4a17-8522-e81dabdfe881', 76, 'Tristan Stubbs', 'Delhi Capitals', 'WK-Batsman', 'WK', 'BAT_WK', 'B', 70, 'OVERSEAS', 'South African', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/19243/tristan-stubbs', 32.0, 705.0, 163.2, 41.47, NULL, NULL, NULL, 17.0, 87.0, 99.0, 46, NULL, NULL, NULL, NULL, NULL, NULL),
('2c462eb7-7421-484d-a0df-138e20d8ad88', 3, 'Jasprit Bumrah', 'Mumbai Indians', 'Bowler', 'BOWL', 'BOWL', 'A', 99, 'INDIAN', 'Indian', 2, false, NULL, NULL, 8, 'https://www.cricbuzz.com/profiles/9311/jasprit-bumrah', 145.0, NULL, NULL, NULL, 183.0, 7.25, 22.03, NULL, NULL, NULL, 99, 99.0, 84.0, 91.0, NULL, NULL, NULL),
('ad0deeb9-dda5-498c-97c2-f778e091e746', 143, 'Prashant Solanki', 'Kolkata Knight Riders', 'Bowler', 'BOWL', 'BOWL', 'C', 57, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/12805/prashant-solanki', 2.0, NULL, NULL, NULL, 2.0, 6.33, 19.0, NULL, NULL, NULL, 31, 5.0, 99.0, 97.0, NULL, NULL, NULL),
('326c1960-8a5f-4ebf-9cc0-7454374b921e', 159, 'Rasikh Dar Salam', 'Royal Challengers Bengaluru', 'Bowler', 'BOWL', 'BOWL', 'C', 55, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/14274/rasikh-dar-salam', 13.0, NULL, NULL, NULL, 10.0, 10.62, 40.9, NULL, NULL, NULL, 36, 10.0, 29.0, 51.0, NULL, NULL, NULL),
('7bdc1abe-8e32-41c7-9188-dfa93f522717', 19, 'Hardik Pandya', 'Mumbai Indians', 'Batting Allrounder', 'AR', 'AR', 'A', 89, 'INDIAN', 'Indian', 2, false, NULL, NULL, 6, 'https://www.cricbuzz.com/profiles/9647/hardik-pandya', 152.0, 2749.0, NULL, NULL, 78.0, NULL, NULL, NULL, NULL, NULL, 99, NULL, NULL, NULL, 90.0, 50.0, 50.0),
('cd0c1e4b-1bc7-44b7-bb45-355f5339b855', 83, 'Jason Holder', 'Gujarat Titans', 'Bowling Allrounder', 'AR', 'AR', 'C', 68, 'OVERSEAS', 'West Indian', 0.5, false, NULL, NULL, 2, 'https://www.cricbuzz.com/profiles/8313/jason-holder', 46.0, 259.0, NULL, NULL, 53.0, NULL, NULL, NULL, NULL, NULL, 53, NULL, NULL, NULL, 32.0, 45.0, 32.0),
('bbe2c154-1ca5-435d-8975-bd2ff9a745d8', 57, 'Jofra Archer', 'Rajasthan Royals', 'Bowler', 'BOWL', 'BOWL', 'B', 73, 'OVERSEAS', 'English', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/11540/jofra-archer', 52.0, NULL, NULL, NULL, 59.0, 7.89, 27.15, NULL, NULL, NULL, 56, 41.0, 74.0, 80.0, NULL, NULL, NULL),
('ade08ae3-0643-4347-b3ae-46211fcedeac', 59, 'Rahul Tewatia', 'Gujarat Titans', 'Batting Allrounder', 'AR', 'AR', 'B', 73, 'INDIAN', 'Indian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/9693/rahul-tewatia', 108.0, 1112.0, NULL, NULL, 32.0, NULL, NULL, NULL, NULL, NULL, 84, NULL, NULL, NULL, 64.0, 38.0, 38.0),
('ae849ca7-f5ce-4d9e-afd2-1ed0301dd7d7', 30, 'Rishabh Pant', 'Lucknow Super Giants', 'WK-Batsman', 'WK', 'BAT_WK', 'B', 82, 'INDIAN', 'Indian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/10744/rishabh-pant', 125.0, 3553.0, 147.62, 34.16, NULL, NULL, NULL, 68.0, 76.0, 85.0, 92, NULL, NULL, NULL, NULL, NULL, NULL),
('576bd8c0-43d1-4f37-932a-a1bcaeb07271', 14, 'Ajinkya Rahane', 'Kolkata Knight Riders', 'Batsman', 'BAT', 'BAT_WK', 'A', 91, 'INDIAN', 'Indian', 2, false, NULL, NULL, 4, 'https://www.cricbuzz.com/profiles/1447/ajinkya-rahane', 198.0, 5032.0, 125.02, 30.5, NULL, NULL, NULL, 95.0, 61.0, 76.0, 99, NULL, NULL, NULL, NULL, NULL, NULL),
('7011e996-c0ad-4292-989c-58d78a6b64d9', 134, 'Vipraj Nigam', 'Delhi Capitals', 'Bowler', 'BOWL', 'BOWL', 'C', 59, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/1431811/vipraj-nigam', 14.0, NULL, NULL, NULL, 11.0, 9.13, 32.36, NULL, NULL, NULL, 37, 10.0, 54.0, 69.0, NULL, NULL, NULL),
('7c60b6e1-fdb4-4d20-bdf7-2555efc50581', 140, 'Mukesh Choudhary', 'Chennai Super Kings', 'Bowler', 'BOWL', 'BOWL', 'C', 58, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/13184/mukesh-choudhary', 16.0, NULL, NULL, NULL, 17.0, 9.94, 30.71, NULL, NULL, NULL, 38, 14.0, 40.0, 72.0, NULL, NULL, NULL),
('4e85d813-fdad-424d-8ef8-4a9d20203716', 105, 'Mukesh Kumar', 'Delhi Capitals', 'Bowler', 'BOWL', 'BOWL', 'C', 64, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/10754/mukesh-kumar', 32.0, NULL, NULL, NULL, 36.0, 10.4, 30.61, NULL, NULL, NULL, 46, 27.0, 33.0, 73.0, NULL, NULL, NULL),
('230879a9-c8e9-4393-9992-ccbc3eefa852', 68, 'Anrich Nortje', 'Lucknow Super Giants', 'Bowler', 'BOWL', 'BOWL', 'B', 71, 'OVERSEAS', 'South African', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/11427/anrich-nortje', 48.0, NULL, NULL, NULL, 61.0, 9.07, 27.16, NULL, NULL, NULL, 54, 43.0, 55.0, 80.0, NULL, NULL, NULL),
('b465e058-3d97-44d8-b884-b08e0377680a', 128, 'Yash Thakur', 'Punjab Kings', 'Bowler', 'BOWL', 'BOWL', 'C', 61, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/12096/yash-thakur', 21.0, NULL, NULL, NULL, 25.0, 10.43, 30.8, NULL, NULL, NULL, 40, 20.0, 32.0, 72.0, NULL, NULL, NULL),
('f864415e-6e73-462c-bdbb-3361ccfd341d', 39, 'Nicholas Pooran', 'Lucknow Super Giants', 'WK-Batsman', 'WK', 'BAT_WK', 'B', 78, 'OVERSEAS', 'West Indian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/9406/nicholas-pooran', 90.0, 2293.0, 168.98, 34.22, NULL, NULL, NULL, 46.0, 91.0, 85.0, 75, NULL, NULL, NULL, NULL, NULL, NULL),
('b0caac01-7621-4921-abcf-cb3ce372ee35', 13, 'Axar Patel', 'Delhi Capitals', 'Bowling Allrounder', 'AR', 'AR', 'A', 91, 'INDIAN', 'Indian', 2, false, NULL, NULL, 6, 'https://www.cricbuzz.com/profiles/8808/axar-patel', 162.0, 1916.0, NULL, NULL, 128.0, NULL, NULL, NULL, NULL, NULL, 99, NULL, NULL, NULL, 82.0, 72.0, 72.0),
('f19a8618-2ad3-4bb7-a177-660668914a8a', 24, 'Varun Chakaravarthy', 'Kolkata Knight Riders', 'Bowler', 'BOWL', 'BOWL', 'B', 84, 'INDIAN', 'Indian', 1, false, NULL, NULL, 2, 'https://www.cricbuzz.com/profiles/12926/varun-chakaravarthy', 83.0, NULL, NULL, NULL, 100.0, 7.58, 23.85, NULL, NULL, NULL, 71, 68.0, 79.0, 87.0, NULL, NULL, NULL),
('cbe0ca24-8b4f-4cde-9b2d-fc7c3a08c992', 26, 'Jaydev Unadkat', 'Sunrisers Hyderabad', 'Bowler', 'BOWL', 'BOWL', 'B', 83, 'INDIAN', 'Indian', 1, false, NULL, NULL, 2, 'https://www.cricbuzz.com/profiles/6327/jaydev-unadkat', 112.0, NULL, NULL, NULL, 110.0, 8.88, 30.58, NULL, NULL, NULL, 86, 74.0, 58.0, 73.0, NULL, NULL, NULL),
('6bde1cda-e5ac-4c87-ac34-ed10e0fd1822', 80, 'Lockie Ferguson', 'Punjab Kings', 'Bowler', 'BOWL', 'BOWL', 'C', 69, 'OVERSEAS', 'New Zealander', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/10692/lockie-ferguson', 49.0, NULL, NULL, NULL, 51.0, 8.97, 30.0, NULL, NULL, NULL, 54, 36.0, 56.0, 74.0, NULL, NULL, NULL),
('15581c4e-54b9-4f57-ab40-da157918d3bb', 7, 'Ravindra Jadeja', 'Rajasthan Royals', 'Bowling Allrounder', 'AR', 'AR', 'A', 95, 'INDIAN', 'Indian', 2, false, NULL, NULL, 8, 'https://www.cricbuzz.com/profiles/587/ravindra-jadeja', 254.0, 3260.0, NULL, NULL, 170.0, NULL, NULL, NULL, NULL, NULL, 99, NULL, NULL, NULL, 85.0, 78.0, 78.0),
('ad6bad9e-dd25-406c-925b-d482594986ab', 130, 'Sameer Rizvi', 'Delhi Capitals', 'Batsman', 'BAT', 'BAT_WK', 'C', 60, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/14700/sameer-rizvi', 13.0, 172.0, 140.99, 24.57, NULL, NULL, NULL, 7.0, 72.0, 61.0, 36, NULL, NULL, NULL, NULL, NULL, NULL),
('f029367e-57c4-49b4-9e28-ebdf23882a6b', 75, 'Karun Nair', 'Delhi Capitals', 'Batsman', 'BAT', 'BAT_WK', 'B', 70, 'INDIAN', 'Indian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/8257/karun-nair', 84.0, 1694.0, 131.73, 23.86, NULL, NULL, NULL, 35.0, 66.0, 60.0, 72, NULL, NULL, NULL, NULL, NULL, NULL),
('3804df65-bf8c-4d6c-b6b4-de6ff6959ea7', 99, 'Yash Dayal', 'Royal Challengers Bengaluru', 'Bowler', 'BOWL', 'BOWL', 'C', 66, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/14172/yash-dayal', 43.0, NULL, NULL, NULL, 41.0, 9.58, 33.9, NULL, NULL, NULL, 51, 30.0, 46.0, 66.0, NULL, NULL, NULL),
('ee3bd3f2-969a-4a7a-bbd4-b960b71a8610', 74, 'Devdutt Padikkal', 'Royal Challengers Bengaluru', 'Batsman', 'BAT', 'BAT_WK', 'B', 70, 'INDIAN', 'Indian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/13088/devdutt-padikkal', 74.0, 1806.0, 126.3, 25.44, NULL, NULL, NULL, 37.0, 62.0, 64.0, 67, NULL, NULL, NULL, NULL, NULL, NULL),
('7da77f61-cfb8-46ae-8327-052a8f028545', 132, 'Kuldeep Sen', 'Rajasthan Royals', 'Bowler', 'BOWL', 'BOWL', 'C', 59, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/14336/kuldeep-sen', 12.0, NULL, NULL, NULL, 14.0, 9.63, 27.64, NULL, NULL, NULL, 36, 12.0, 45.0, 79.0, NULL, NULL, NULL),
('fceb1e37-dd46-4815-a575-32381d9385ad', 111, 'Ryan Rickelton', 'Mumbai Indians', 'WK-Batsman', 'WK', 'BAT_WK', 'C', 62, 'OVERSEAS', 'South African', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/13070/ryan-rickelton', 14.0, 388.0, 150.98, 29.85, NULL, NULL, NULL, 11.0, 79.0, 74.0, 37, NULL, NULL, NULL, NULL, NULL, NULL),
('09c791ea-4840-4a74-87e3-3525e26cd5c6', 32, 'David Miller', 'Delhi Capitals', 'Batsman', 'BAT', 'BAT_WK', 'B', 80, 'OVERSEAS', 'South African', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/6349/david-miller', 141.0, 3077.0, 138.61, 35.78, NULL, NULL, NULL, 60.0, 70.0, 89.0, 99, NULL, NULL, NULL, NULL, NULL, NULL),
('438555ad-d049-468e-aa56-cd31754f1bf6', 113, 'Marco Jansen', 'Punjab Kings', 'Bowling Allrounder', 'AR', 'AR', 'C', 62, 'OVERSEAS', 'South African', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/14565/marco-jansen', 35.0, 141.0, NULL, NULL, 36.0, NULL, NULL, NULL, NULL, NULL, 47, NULL, NULL, NULL, 26.0, 36.0, 26.0),
('62a25c6c-1422-4396-89d4-30d2658251f4', 8, 'MS Dhoni', 'Chennai Super Kings', 'WK-Batsman', 'WK', 'BAT_WK', 'A', 95, 'INDIAN', 'Indian', 2, false, NULL, NULL, 4, 'https://www.cricbuzz.com/profiles/265/ms-dhoni', 278.0, 5439.0, 137.46, 38.3, NULL, NULL, NULL, 99.0, 70.0, 95.0, 99, NULL, NULL, NULL, NULL, NULL, NULL),
('a09626d7-7f31-476e-afb3-ceb70fe457b8', 125, 'Vaibhav Suryavanshi', 'Rajasthan Royals', 'Batsman', 'BAT', 'BAT_WK', 'C', 61, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/51791/vaibhav-suryavanshi', 7.0, 252.0, 206.56, 36.0, NULL, NULL, NULL, 9.0, 99.0, 89.0, 33, NULL, NULL, NULL, NULL, NULL, NULL),
('af96832a-6733-4c3b-acd6-82137f18a9d4', 107, 'Shahbaz Ahmed', 'Lucknow Super Giants', 'Bowling Allrounder', 'AR', 'AR', 'C', 64, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/14606/shahbaz-ahmed', 58.0, 545.0, NULL, NULL, 22.0, NULL, NULL, NULL, NULL, NULL, 59, NULL, NULL, NULL, 43.0, 27.0, 27.0),
('5f6e6021-0587-4639-8bcb-dd13cf38b0ac', 133, 'Kyle Jamieson', 'Delhi Capitals', 'Bowler', 'BOWL', 'BOWL', 'C', 59, 'OVERSEAS', 'New Zealander', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/9441/kyle-jamieson', 13.0, NULL, NULL, NULL, 14.0, 9.67, 29.71, NULL, NULL, NULL, 36, 12.0, 45.0, 74.0, NULL, NULL, NULL),
('eff823b8-53a1-4713-b2ef-7926d498c04d', 40, 'Rahul Chahar', 'Chennai Super Kings', 'Bowler', 'BOWL', 'BOWL', 'B', 77, 'INDIAN', 'Indian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/12087/rahul-chahar', 79.0, NULL, NULL, NULL, 75.0, 7.72, 28.67, NULL, NULL, NULL, 69, 52.0, 76.0, 77.0, NULL, NULL, NULL),
('a98d9612-0f01-44ef-a615-39312e7e0ac7', 34, 'Quinton de Kock', 'Mumbai Indians', 'WK-Batsman', 'WK', 'BAT_WK', 'B', 79, 'OVERSEAS', 'South African', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/8520/quinton-de-kock', 115.0, 3309.0, 134.03, 30.64, NULL, NULL, NULL, 64.0, 67.0, 76.0, 87, NULL, NULL, NULL, NULL, NULL, NULL),
('65934d0b-cc0c-4902-826c-791a740511a8', 27, 'Shreyas Iyer', 'Punjab Kings', 'Batsman', 'BAT', 'BAT_WK', 'B', 83, 'INDIAN', 'Indian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/9428/shreyas-iyer', 132.0, 3731.0, 133.35, 34.23, NULL, NULL, NULL, 72.0, 67.0, 85.0, 96, NULL, NULL, NULL, NULL, NULL, NULL),
('9d88fc69-05e3-452b-97ec-d866d3b0499c', 141, 'Eshan Malinga', 'Sunrisers Hyderabad', 'Bowler', 'BOWL', 'BOWL', 'C', 58, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/46926/eshan-malinga', 7.0, NULL, NULL, NULL, 13.0, 8.93, 18.31, NULL, NULL, NULL, 33, 12.0, 57.0, 99.0, NULL, NULL, NULL),
('072c577a-9b2e-40e1-87e4-e7225b198920', 64, 'Shreyas Gopal', 'Chennai Super Kings', 'Bowler', 'BOWL', 'BOWL', 'B', 72, 'INDIAN', 'Indian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/9746/shreyas-gopal', 52.0, NULL, NULL, NULL, 52.0, 8.16, 25.92, NULL, NULL, NULL, 56, 37.0, 69.0, 83.0, NULL, NULL, NULL),
('6b9cb139-b92c-4762-a1e6-fba30db6e6e6', 97, 'Ramandeep Singh', 'Kolkata Knight Riders', 'Batting Allrounder', 'AR', 'AR', 'C', 66, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/12337/ramandeep-singh', 30.0, 217.0, NULL, NULL, 6.0, NULL, NULL, NULL, NULL, NULL, 45, NULL, NULL, NULL, 46.0, 35.0, 35.0),
('4917f30f-f1dc-4f8d-9c9b-755c746470aa', 154, 'Nuwan Thushara', 'Royal Challengers Bengaluru', 'Bowler', 'BOWL', 'BOWL', 'C', 56, 'OVERSEAS', 'Sri Lankan', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/18509/nuwan-thushara', 8.0, NULL, NULL, NULL, 9.0, 9.43, 31.44, NULL, NULL, NULL, 34, 9.0, 49.0, 71.0, NULL, NULL, NULL),
('305ce243-461a-4688-a20e-0538c2b0f163', 21, 'Krunal Pandya', 'Royal Challengers Bengaluru', 'Batting Allrounder', 'AR', 'AR', 'A', 86, 'INDIAN', 'Indian', 2, true, 'The Intense Allrounder', 'I’ve got a cabinet full of IPL trophies, but I’m probably best known for my intense on-field death stares and my very famous younger brother. I recently traded my Nawabi vibes in Lucknow to join the chaos at the Chinnaswamy. Who am I?', 4, 'https://www.cricbuzz.com/profiles/11311/krunal-pandya', 142.0, 1748.0, NULL, NULL, 93.0, NULL, NULL, NULL, NULL, NULL, 99, NULL, NULL, NULL, 77.0, 60.0, 60.0),
('37e1a6c3-8b8f-4a0c-9fec-9f99e93eb46c', 119, 'Wanindu Hasaranga', 'Lucknow Super Giants', 'Bowling Allrounder', 'AR', 'AR', 'C', 62, 'OVERSEAS', 'Sri Lankan', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/10926/wanindu-hasaranga', 37.0, 81.0, NULL, NULL, 46.0, NULL, NULL, NULL, NULL, NULL, 48, NULL, NULL, NULL, 15.0, 45.0, 15.0),
('d2eb29dc-0a01-4537-87ae-51ba4cba3051', 37, 'Ishan Kishan', 'Sunrisers Hyderabad', 'WK-Batsman', 'WK', 'BAT_WK', 'B', 78, 'INDIAN', 'Indian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/10276/ishan-kishan', 119.0, 2998.0, 137.65, 29.11, NULL, NULL, NULL, 58.0, 70.0, 72.0, 89, NULL, NULL, NULL, NULL, NULL, NULL),
('0b4ca758-9467-4359-9fa4-c4a28a7536e3', 12, 'Trent Boult', 'Mumbai Indians', 'Bowler', 'BOWL', 'BOWL', 'A', 92, 'OVERSEAS', 'New Zealander', 2, false, NULL, NULL, 4, 'https://www.cricbuzz.com/profiles/8117/trent-boult', 119.0, NULL, NULL, NULL, 143.0, 8.38, 26.2, NULL, NULL, NULL, 89, 96.0, 66.0, 82.0, NULL, NULL, NULL),
('491b040f-6623-43ee-9ec1-62169fa1bf2b', 67, 'Ayush Badoni', 'Lucknow Super Giants', 'Batting Allrounder', 'AR', 'AR', 'B', 71, 'INDIAN', 'Indian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/13907/ayush-badoni', 56.0, 963.0, NULL, NULL, 4.0, NULL, NULL, NULL, NULL, NULL, 58, NULL, NULL, NULL, 63.0, 37.0, 37.0),
('64d88df9-205f-475e-aee7-662e84db12b8', 58, 'Riyan Parag', 'Rajasthan Royals', 'Batting Allrounder', 'AR', 'AR', 'B', 73, 'INDIAN', 'Indian', 1, false, NULL, NULL, 2, 'https://www.cricbuzz.com/profiles/12305/riyan-parag', 83.0, 1566.0, NULL, NULL, 7.0, NULL, NULL, NULL, NULL, NULL, 71, NULL, NULL, NULL, 78.0, 16.0, 16.0),
('b3484a09-2645-426c-8949-f5dd7e9404d7', 108, 'Rovman Powell', 'Kolkata Knight Riders', 'Batsman', 'BAT', 'BAT_WK', 'C', 63, 'OVERSEAS', 'West Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/11445/rovman-powell', 28.0, 365.0, 146.59, 18.25, NULL, NULL, NULL, 11.0, 76.0, 46.0, 44, NULL, NULL, NULL, NULL, NULL, NULL),
('e287c9a9-d6cc-437a-b781-636f33e7404a', 28, 'Kuldeep Yadav', 'Delhi Capitals', 'Bowler', 'BOWL', 'BOWL', 'B', 83, 'INDIAN', 'Indian', 1, false, NULL, NULL, 2, 'https://www.cricbuzz.com/profiles/8292/kuldeep-yadav', 98.0, NULL, NULL, NULL, 102.0, 8.04, 26.95, NULL, NULL, NULL, 79, 69.0, 71.0, 80.0, NULL, NULL, NULL),
('ec6a1257-97a4-4b5b-8137-3e8aaee60143', 153, 'Urvil Patel', 'Chennai Super Kings', 'WK-Batsman', 'WK', 'BAT_WK', 'C', 56, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/13476/urvil-patel', 3.0, 68.0, 212.5, 22.67, NULL, NULL, NULL, 5.0, 99.0, 57.0, 31, NULL, NULL, NULL, NULL, NULL, NULL),
('555d334d-0bab-439c-9162-52fcf10b0a78', 114, 'Mitchell Santner', 'Mumbai Indians', 'Bowling Allrounder', 'AR', 'AR', 'C', 62, 'OVERSEAS', 'New Zealander', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/10100/mitchell-santner', 31.0, 110.0, NULL, NULL, 25.0, NULL, NULL, NULL, NULL, NULL, 45, NULL, NULL, NULL, 25.0, 40.0, 25.0),
('20d511d9-a0fd-4382-a09f-81b942c6f199', 17, 'Mohammed Shami', 'Lucknow Super Giants', 'Bowler', 'BOWL', 'BOWL', 'A', 89, 'INDIAN', 'Indian', 2, false, NULL, NULL, 4, 'https://www.cricbuzz.com/profiles/7909/mohammed-shami', 119.0, NULL, NULL, NULL, 133.0, 8.63, 28.18, NULL, NULL, NULL, 89, 89.0, 62.0, 78.0, NULL, NULL, NULL),
('c1dfec75-e69b-4fe1-b76e-fdc86c7b3464', 42, 'Ruturaj Gaikwad', 'Chennai Super Kings', 'Batsman', 'BAT', 'BAT_WK', 'B', 77, 'INDIAN', 'Indian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/11813/ruturaj-gaikwad', 71.0, 2502.0, 137.48, 40.35, NULL, NULL, NULL, 49.0, 70.0, 99.0, 65, NULL, NULL, NULL, NULL, NULL, NULL),
('5aa5aa8e-03d9-406e-9ce9-6dbe43913eab', 152, 'Anukul Roy', 'Kolkata Knight Riders', 'Batting Allrounder', 'AR', 'AR', 'C', 56, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/12344/anukul-roy', 11.0, 26.0, NULL, NULL, 6.0, NULL, NULL, NULL, NULL, NULL, 35, NULL, NULL, NULL, 17.0, 29.0, 17.0),
('19021b90-1500-47fa-b3e4-155e00f27eeb', 82, 'Jitesh Sharma', 'Royal Challengers Bengaluru', 'WK-Batsman', 'WK', 'BAT_WK', 'C', 68, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/10214/jitesh-sharma', 55.0, 991.0, 157.06, 25.41, NULL, NULL, NULL, 22.0, 83.0, 63.0, 57, NULL, NULL, NULL, NULL, NULL, NULL),
('cee0ea48-f8b7-459a-8d0e-1493981ae851', 18, 'Rashid Khan', 'Gujarat Titans', 'Bowling Allrounder', 'AR', 'AR', 'A', 89, 'OVERSEAS', 'Afghan', 2, false, NULL, NULL, 8, 'https://www.cricbuzz.com/profiles/10738/rashid-khan', 136.0, 585.0, NULL, NULL, 158.0, NULL, NULL, NULL, NULL, NULL, 98, NULL, NULL, NULL, 51.0, 82.0, 51.0),
('5ad2c8b6-0e7c-4456-89df-db644c707cec', 66, 'Philip Salt', 'Royal Challengers Bengaluru', 'WK-Batsman', 'WK', 'BAT_WK', 'B', 71, 'OVERSEAS', 'English', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/10479/philip-salt', 34.0, 1056.0, 175.71, 34.06, NULL, NULL, NULL, 23.0, 95.0, 84.0, 47, NULL, NULL, NULL, NULL, NULL, NULL),
('f00a896d-01ef-4314-8e5d-742f01a6f2db', 87, 'Tushar Deshpande', 'Rajasthan Royals', 'Bowler', 'BOWL', 'BOWL', 'C', 67, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/11307/tushar-deshpande', 46.0, NULL, NULL, NULL, 51.0, 9.84, 31.04, NULL, NULL, NULL, 53, 36.0, 42.0, 72.0, NULL, NULL, NULL),
('d103ade1-8912-4455-96ca-e79bede35bbe', 50, 'Mitchell Marsh', 'Lucknow Super Giants', 'Batting Allrounder', 'AR', 'AR', 'B', 74, 'OVERSEAS', 'Australian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/6250/mitchell-marsh', 55.0, 1292.0, NULL, NULL, 37.0, NULL, NULL, NULL, NULL, NULL, 57, NULL, NULL, NULL, 72.0, 43.0, 43.0),
('cad40791-c85b-4154-a755-8fe1c677ed41', 38, 'Shardul Thakur', 'Mumbai Indians', 'Bowling Allrounder', 'AR', 'AR', 'B', 78, 'INDIAN', 'Indian', 1, false, NULL, NULL, 6, 'https://www.cricbuzz.com/profiles/8683/shardul-thakur', 105.0, 325.0, NULL, NULL, 107.0, NULL, NULL, NULL, NULL, NULL, 82, NULL, NULL, NULL, 38.0, 59.0, 38.0),
('cd205486-e151-487c-84a3-fa7c9fc3e889', 60, 'Noor Ahmad', 'Chennai Super Kings', 'Bowler', 'BOWL', 'BOWL', 'B', 72, 'OVERSEAS', 'Afghan', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/15452/noor-ahmad', 37.0, NULL, NULL, NULL, 48.0, 8.08, 22.23, NULL, NULL, NULL, 48, 34.0, 71.0, 90.0, NULL, NULL, NULL),
('e461f705-26cb-47f3-b9bd-cf877748dfaa', 5, 'Bhuvneshwar Kumar', 'Royal Challengers Bengaluru', 'Bowler', 'BOWL', 'BOWL', 'A', 98, 'INDIAN', 'Indian', 2, false, NULL, NULL, 8, 'https://www.cricbuzz.com/profiles/1726/bhuvneshwar-kumar', 190.0, NULL, NULL, NULL, 198.0, 7.69, 27.33, NULL, NULL, NULL, 99, 99.0, 77.0, 80.0, NULL, NULL, NULL),
('26617ba4-f0d0-4aff-9266-5b04ab9329f3', 155, 'Swapnil Singh', 'Royal Challengers Bengaluru', 'Bowling Allrounder', 'AR', 'AR', 'C', 56, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/10238/swapnil-singh', 14.0, 51.0, NULL, NULL, 7.0, NULL, NULL, NULL, NULL, NULL, 37, NULL, NULL, NULL, 23.0, 27.0, 23.0),
('2554d599-7557-4056-b46d-15df398d0a13', 35, 'Deepak Chahar', 'Mumbai Indians', 'Bowler', 'BOWL', 'BOWL', 'B', 78, 'INDIAN', 'Indian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/7836/deepak-chahar', 95.0, NULL, NULL, NULL, 88.0, 8.14, 29.51, NULL, NULL, NULL, 77, 60.0, 70.0, 75.0, NULL, NULL, NULL),
('a99ce55d-f947-44de-a882-294d044c85b6', 146, 'Anshul Kamboj', 'Chennai Super Kings', 'Bowling Allrounder', 'AR', 'AR', 'C', 57, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/14598/anshul-kamboj', 11.0, 16.0, NULL, NULL, 10.0, NULL, NULL, NULL, NULL, NULL, 35, NULL, NULL, NULL, 21.0, 30.0, 21.0),
('c1bd9a0c-c8b5-412f-a326-4813394e8465', 46, 'Avesh Khan', 'Lucknow Super Giants', 'Bowler', 'BOWL', 'BOWL', 'B', 76, 'INDIAN', 'Indian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/9781/avesh-khan', 75.0, NULL, NULL, NULL, 87.0, 9.12, 28.29, NULL, NULL, NULL, 67, 60.0, 54.0, 77.0, NULL, NULL, NULL),
('0741ba20-8e53-4e4e-8893-27e21652cac0', 129, 'Anuj Rawat', 'Gujarat Titans', 'WK-Batsman', 'WK', 'BAT_WK', 'C', 60, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/13135/anuj-rawat', 24.0, 318.0, 119.11, 19.88, NULL, NULL, NULL, 10.0, 57.0, 50.0, 42, NULL, NULL, NULL, NULL, NULL, NULL),
('f65ad787-b230-454b-b21c-fc99492ba8aa', 156, 'Matthew Short', 'Chennai Super Kings', 'Batsman', 'BAT', 'BAT_WK', 'C', 55, 'OVERSEAS', 'Australian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/9456/matthew-short', 6.0, 117.0, 127.18, 19.5, NULL, NULL, NULL, 6.0, 63.0, 49.0, 33, NULL, NULL, NULL, NULL, NULL, NULL),
('48b81043-c5e3-4e15-bfa7-fdbc64339cdc', 131, 'Romario Shepherd', 'Royal Challengers Bengaluru', 'Bowling Allrounder', 'AR', 'AR', 'C', 60, 'OVERSEAS', 'West Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/13646/romario-shepherd', 18.0, 185.0, NULL, NULL, 10.0, NULL, NULL, NULL, NULL, NULL, 39, NULL, NULL, NULL, 52.0, 18.0, 18.0),
('1fd3b8b2-fbca-4fc2-a317-0acfa781d88c', 90, 'Naman Dhir', 'Mumbai Indians', 'Batsman', 'BAT', 'BAT_WK', 'C', 67, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/36139/naman-dhir', 23.0, 392.0, 180.65, 28.0, NULL, NULL, NULL, 11.0, 99.0, 70.0, 41, NULL, NULL, NULL, NULL, NULL, NULL),
('14bd5306-df25-474e-bcba-2b851f7916a2', 117, 'Dewald Brevis', 'Chennai Super Kings', 'Batsman', 'BAT', 'BAT_WK', 'C', 62, 'OVERSEAS', 'South African', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/20538/dewald-brevis', 16.0, 455.0, 153.2, 28.44, NULL, NULL, NULL, 12.0, 80.0, 71.0, 38, NULL, NULL, NULL, NULL, NULL, NULL),
('ecbfefab-cc3c-4052-ad5f-3907148ac132', 47, 'Yashasvi Jaiswal', 'Rajasthan Royals', 'Batsman', 'BAT', 'BAT_WK', 'B', 75, 'INDIAN', 'Indian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/13940/yashasvi-jaiswal', 66.0, 2166.0, 152.86, 34.38, NULL, NULL, NULL, 43.0, 80.0, 85.0, 63, NULL, NULL, NULL, NULL, NULL, NULL),
('aa583314-be24-4462-a9a6-fe378472636d', 124, 'Shubham Dubey', 'Rajasthan Royals', 'Batsman', 'BAT', 'BAT_WK', 'C', 61, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/19328/shubham-dubey', 13.0, 139.0, 163.53, 23.17, NULL, NULL, NULL, 6.0, 87.0, 58.0, 36, NULL, NULL, NULL, NULL, NULL, NULL),
('5c9ad2f0-32d5-48fa-b631-f98130e1db7b', 16, 'Suryakumar Yadav', 'Mumbai Indians', 'Batsman', 'BAT', 'BAT_WK', 'A', 89, 'INDIAN', 'Indian', 2, false, NULL, NULL, 2, 'https://www.cricbuzz.com/profiles/7915/suryakumar-yadav', 166.0, 4311.0, 148.66, 35.05, NULL, NULL, NULL, 82.0, 77.0, 87.0, 99, NULL, NULL, NULL, NULL, NULL, NULL),
('a7f55959-ba61-4c70-b5e6-0621d8f32a4d', 51, 'Sam Curran', 'Rajasthan Royals', 'Bowling Allrounder', 'AR', 'AR', 'B', 74, 'OVERSEAS', 'English', 1, false, NULL, NULL, 2, 'https://www.cricbuzz.com/profiles/10420/sam-curran', 64.0, 997.0, NULL, NULL, 59.0, NULL, NULL, NULL, NULL, NULL, 62, NULL, NULL, NULL, 62.0, 41.0, 41.0),
('e0e801a5-b761-4c9a-b82d-a0da04c512ea', 10, 'Harshal Patel', 'Sunrisers Hyderabad', 'Bowler', 'BOWL', 'BOWL', 'A', 94, 'INDIAN', 'Indian', 2, false, NULL, NULL, 6, 'https://www.cricbuzz.com/profiles/8175/harshal-patel', 119.0, NULL, NULL, NULL, 151.0, 8.86, 23.7, NULL, NULL, NULL, 89, 99.0, 58.0, 87.0, NULL, NULL, NULL),
('cec1c4cc-595c-4ddc-8fc7-62afab52eefd', 52, 'Rahul Tripathi', 'Kolkata Knight Riders', 'Batsman', 'BAT', 'BAT_WK', 'B', 74, 'INDIAN', 'Indian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/9012/rahul-tripathi', 100.0, 2291.0, 137.85, 26.03, NULL, NULL, NULL, 46.0, 70.0, 65.0, 80, NULL, NULL, NULL, NULL, NULL, NULL),
('81ecc57e-8ebf-4aaf-931a-9dc6e3188e0f', 142, 'Kamindu Mendis', 'Sunrisers Hyderabad', 'Batting Allrounder', 'AR', 'AR', 'C', 57, 'OVERSEAS', 'Sri Lankan', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/10940/kamindu-mendis', 5.0, 92.0, NULL, NULL, 2.0, NULL, NULL, NULL, NULL, NULL, 32, NULL, NULL, NULL, 38.0, 29.0, 29.0),
('af91f02d-6e2f-41d8-b5f3-7aec794b6f9b', 15, 'Sanju Samson', 'Chennai Super Kings', 'WK-Batsman', 'WK', 'BAT_WK', 'A', 89, 'INDIAN', 'Indian', 2, false, NULL, NULL, 2, 'https://www.cricbuzz.com/profiles/8271/sanju-samson', 176.0, 4704.0, 139.05, 30.75, NULL, NULL, NULL, 89.0, 71.0, 76.0, 99, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT INTO "AuctionPlayer" (id, player_id, status) VALUES
('827d98a2-b0d7-4c89-8fb5-105e23569c10', 'a47e7768-99cc-4eb9-b1c2-9ca0dc1f9534', 'UNSOLD'),
('1091d0bf-9520-4d87-8a93-f667c3e31e8b', '7d8ddcf5-334c-4dc6-922f-c1964332520d', 'UNSOLD'),
('0c3ce3cf-0cf9-4baa-a088-b1e2b7892817', '5ca29f3c-9216-44df-ac68-177ae1fa25f3', 'UNSOLD'),
('d3de45ad-60de-4249-bf54-19d87994ba05', '5c69c5fe-ede7-4c88-bb93-595f59e5d14e', 'UNSOLD'),
('746db8ee-d5f7-48b1-b1f6-26f61656b411', '98fc0b1a-d6b6-41d4-a986-aca163cfe459', 'UNSOLD'),
('5a9db81e-b81c-4816-a7fb-69035a7b81ac', '4357f1e4-1f13-4770-a5e7-4dbf5fbb7a63', 'UNSOLD'),
('13d8fc64-7e5b-4f91-a2b3-a5cd596351f3', 'd724047f-2891-46a6-892d-34f1baa866e5', 'UNSOLD'),
('8892027d-9e71-4428-b9ae-c9ca7a4aa437', '22266d60-176c-485f-93bf-35dd426a0399', 'UNSOLD'),
('577a9638-ed09-43e2-a3dd-851d2442402d', 'c6abb549-50d2-46fe-8f3e-f72c76b8f868', 'UNSOLD'),
('99164d2e-c0f7-4624-b55a-815757e7192b', '84720fcf-377f-479d-994c-98b9e6e91218', 'UNSOLD'),
('5ff45e07-b83c-419c-9824-404c268b24cc', 'f7f78271-37fe-45c3-8eea-ce515a310456', 'UNSOLD'),
('f6b282da-9d6f-478d-8ef9-978a21857900', 'f28f748c-a6ee-4b6e-9bd1-d5248d2031df', 'UNSOLD'),
('024877cd-d2ea-433d-8001-c692acd2c129', '7a537b83-7bc1-4e63-96a1-65931e2d7fd0', 'UNSOLD'),
('29531cf4-8c43-4cd4-bb30-02b74b99684f', '51087551-e4c2-4bf4-a967-f90b2dc8f701', 'UNSOLD'),
('e36786f3-af33-4221-b763-a862a3c300a0', '05c25dcf-8f11-4d81-80a4-8ba3d568339f', 'UNSOLD'),
('a8e41b29-a7be-449c-bf41-1739f4717c5c', '29c10831-a523-4ad7-abbb-d619202a521e', 'UNSOLD'),
('0db7b381-a5c6-4502-87f3-4f3182bec3a0', 'c0cebb7c-65b2-46ea-a80a-9ad9cf14e977', 'UNSOLD'),
('844f074c-c5e4-4d4a-b119-d56604230841', 'bc626849-dee6-4c62-959f-ec66e83e0c34', 'UNSOLD'),
('83cd5c16-58a0-494d-a1a1-2f12070eaaf9', 'fe1b363a-8b3c-4b67-8452-3243a142985e', 'UNSOLD'),
('3df85eec-9dfb-4ccf-81b4-9b486ea7a938', '87d81a8d-f457-4c48-848d-8fb95036a546', 'UNSOLD'),
('53ebb49e-38e0-4cf0-87b0-aa9fc383e90b', '44f3396f-cb7d-422e-9545-5b18f788d273', 'UNSOLD'),
('c94ee5b7-9bd9-4be3-ab4e-b7aacb93803c', 'f96595f5-9a99-4cf9-a23f-9247f8aca60d', 'UNSOLD'),
('d935f9b2-df64-432a-8c7e-cfffb2350af9', '8e0f2d70-06cf-4b43-9781-0e6f5f4da77b', 'UNSOLD'),
('dcc75548-8de2-4b6c-9454-3f26bc10a7b1', 'a2f03df2-31e5-48ae-8561-ff433bc5c6ff', 'UNSOLD'),
('c65e19b5-db37-42bc-b261-47995c8ccafa', '9e5e5df4-e0a1-4d01-b698-d68d4b689474', 'UNSOLD'),
('270d2e7f-b4ee-47e3-9492-6f804c17c02c', '2917997a-452c-4c9f-b0c5-56471bc43c79', 'UNSOLD'),
('a0ae4b29-790b-4582-b1ce-1741fc1e408f', '251e12f7-26d0-4ec1-a62a-6f1cffbba68e', 'UNSOLD'),
('537f03d0-cd9d-49ac-a3b8-7ce93b6b3be5', '66dbc2d6-1328-4edb-b00b-a1f80af6d0e4', 'UNSOLD'),
('7747bf75-ea87-4407-ae6d-af0ccf93b1ab', 'c7df7662-56c0-465c-8857-c62d76e26acc', 'UNSOLD'),
('c6baf37e-1e30-4762-b53d-c391a4b92211', 'f5ce70b7-1e74-4fd8-a0ec-83f2b8aea95b', 'UNSOLD'),
('4077ae15-c4a6-4592-b539-13ae940f31f2', 'de5e2474-2cf3-4cde-9f43-91907cf373cd', 'UNSOLD'),
('e46e2800-d970-49f1-9df1-45e8c415efed', '2b2962a3-f21d-4a18-81ab-8a84d2a9260c', 'UNSOLD'),
('41cb0a9a-35a8-4643-8c75-5cccd42dcbd2', '8ee689c6-0dbd-416e-bd15-6a29aeec2b71', 'UNSOLD'),
('60387a69-167f-4e4c-b64b-55b86d4497ef', 'fa50fafc-3b34-44dc-9f2e-33034eb86cda', 'UNSOLD'),
('64268065-2103-4a1e-9c47-00be4920fd7a', 'c25d4f0f-0206-4ee1-9c6a-d306e66981d4', 'UNSOLD'),
('03f26632-e78f-4d74-a791-3332f074bfe9', '0aca1380-4e93-4e7c-8a84-4df3ca28ee6d', 'UNSOLD'),
('98b1d14c-7b47-46a6-909c-c1cdd87639f0', 'fbdaf797-57ec-4bf4-b529-e8c9a5c6af09', 'UNSOLD'),
('7b0b883f-3c99-4d85-b6fc-863d79a5e161', 'f289bdcc-247f-47d2-a4c7-d27567de0b95', 'UNSOLD'),
('ca498a28-728f-469a-9be4-e05df3172c07', 'ffb7841a-bf4f-4bbf-9c19-5b64ecefa722', 'UNSOLD'),
('8b1827dd-58e4-45a5-8086-2476e056d3b4', '31dfe1c5-9c3b-4fe9-b551-b92927b9bb12', 'UNSOLD'),
('2ca70a6b-825f-4798-93ef-2c37a4e42e8e', 'e50ce6a8-e07e-4a4d-b443-29ae97440e80', 'UNSOLD'),
('4f633575-4a70-4f06-a681-67142e6377de', '6187fa48-36e4-4f98-a15e-f1529ca38094', 'UNSOLD'),
('d04b448c-bfb3-419d-9dd5-24bf48810f18', 'c2c8d52d-255b-4f73-9c0d-e6c3f1fd0b95', 'UNSOLD'),
('64dee1b4-936f-4611-91d8-0dc25eb93095', '5612301d-72e8-43a6-b61d-f14809dbe5ce', 'UNSOLD'),
('8b7363b0-4eee-4e86-9e2e-2f53617af3b0', 'e2668b21-a431-4fb2-a2a0-0a7308890a31', 'UNSOLD'),
('a02f4ea9-9e14-4125-9b17-d8f03bfc9c5b', 'de226dd1-14ee-4a5e-bf4c-ff5a0c679e92', 'UNSOLD'),
('d054cb10-1bd8-47b4-82c6-3bff91c80bca', '10b900fc-795a-4ed5-9bfc-c29382d62f45', 'UNSOLD'),
('8ee69b96-36f1-4f28-9e43-4975875af6c7', '737871df-c167-4d76-b52e-17310a9bc3ae', 'UNSOLD'),
('0b7f4f7d-a42d-4999-a8e8-9f451532b8b4', '90783639-5519-4be8-a570-e74e9ba3cd41', 'UNSOLD'),
('eb72b18e-05c5-4b87-9fb8-5517aa699bc2', '8ef1c0fe-b010-40f4-b605-5faa2913e1c3', 'UNSOLD'),
('182c855d-1416-41eb-beb7-707d62a70122', 'dc65d029-7d4a-421f-9ab1-5025dadb33c8', 'UNSOLD'),
('49302def-0beb-4b00-85db-1ecaf52d2ba3', 'd781a486-4957-432d-83e2-45a6f2553993', 'UNSOLD'),
('1a719414-8c3a-43cc-b893-c8ef3a3ee223', '83b17433-d1f5-43ce-8e57-c0b2ba69814a', 'UNSOLD'),
('9713ae06-c673-40a1-95c6-5bc366fd5d03', '6b86490c-d616-47d6-a9d4-745158df7ce4', 'UNSOLD'),
('2e2f75a3-7934-4126-bc3b-b2ef70688ccc', 'fbd76fbd-0536-4e3b-8e95-219fa46bbc9e', 'UNSOLD'),
('6dc234f9-bb4e-4a96-ba6f-277fe2a7fd3b', '3fac61e2-c3ab-43b3-9501-1e96433aa651', 'UNSOLD'),
('e9f28d1d-8152-4648-975c-f9057eaa93cc', '30257f37-c989-4cc9-921d-e0e06a69a2e7', 'UNSOLD'),
('5aabd98b-7d17-4a39-9431-cf00cd9b400f', '8071c96c-a6d5-4e6f-b85f-dcd7f4ae6163', 'UNSOLD'),
('8a592738-68c3-45e6-a1db-4c6a97577a0c', 'ec78b85b-652d-444d-bbd3-6163e2b77a12', 'UNSOLD'),
('f0423730-5f95-46c6-8b12-05cc08cf5c84', 'f0fa2413-1bba-4b76-ae87-6e8866e2ede0', 'UNSOLD'),
('c34bb237-d64b-409d-b65e-a7b01119927e', 'acb8afde-5e66-447b-903e-8447129eadbb', 'UNSOLD'),
('72c65d93-ff02-4fb0-950a-390c0ec81e04', 'aaf50182-baf4-427f-a0f4-39f87ea52aec', 'UNSOLD'),
('5e776cf7-1ae7-45bc-99c6-0be9335e6b8a', '60ba781b-ff36-4a02-bdda-8b9138cd7719', 'UNSOLD'),
('98423ac1-1735-4e42-a041-f87b3ab9c1ac', '47ae3803-4db2-4218-a4c4-6de14f7505e5', 'UNSOLD'),
('fc6d2cca-aa31-434c-bbb3-dd06057a4b37', 'a8776dff-391c-433f-bcf2-4e3d433bcc9b', 'UNSOLD'),
('fd2af047-4f2f-4263-92ca-9ad016a66b89', '32ea8d21-07d7-43cf-9a43-21df3db812a5', 'UNSOLD'),
('89ca233a-51b5-4df2-afca-74d5041946c8', '898cedbd-1f88-4b97-9680-abbd43df0749', 'UNSOLD'),
('b1d11460-62ae-452a-a2f2-cc2f6470c264', '8a403008-8121-42f0-bd92-615a6c6792a1', 'UNSOLD'),
('4508cf7a-eebc-446c-8d37-369cb11315aa', 'e99e337e-921e-46d6-851c-ada85a43a2b1', 'UNSOLD'),
('df859e16-6ea6-4a07-bb26-cdf98ae474f2', '6787fffb-84d6-475b-a4aa-d71b4aa74ed8', 'UNSOLD'),
('87314265-b538-454b-92ad-58890d8483a4', '933523a4-805e-43d0-bfc9-06661ba9eb29', 'UNSOLD'),
('f63e1da7-c920-43a8-b24e-93de2f08ee3e', '5d27d5d7-aeba-48e7-b777-77e48e89c033', 'UNSOLD'),
('38b334c6-fda0-47d7-9866-bd9e3020f7bc', '9942972a-21c2-42bc-a869-87d6d393b093', 'UNSOLD'),
('d7bb4eb1-3f35-4b76-8350-4aecf5175c5b', '2dd32543-699a-4d8d-a442-6c8d53d0c98d', 'UNSOLD'),
('54ee2b95-3776-4e4a-8b6c-101c9f65d09f', 'e853c732-0a72-4be2-8569-7482ecb7f83a', 'UNSOLD'),
('4ecdb644-33d4-46d3-a7ac-9316f1d47261', 'a19193ad-8053-483a-adc6-33920aae94d5', 'UNSOLD'),
('4cadc0c6-8c76-498f-853b-ff92e15b1251', 'eeef0121-e65f-4a9b-918e-0d08486eb02d', 'UNSOLD'),
('e187e4a5-6d77-42f9-8641-17a51025c86c', '464e6a18-892b-460d-95f1-cd2c865476ee', 'UNSOLD'),
('bf8bff29-761c-4b83-8e63-2f1da375fc89', 'c4a2fc49-875d-4223-8cca-abd46a8b25dd', 'UNSOLD'),
('c3c6fc94-b7de-440c-be48-f5c834bc25bf', '4ef5f494-cf20-41df-a5b2-bf711ce232f1', 'UNSOLD'),
('7f94fdd2-e38e-46ee-91a3-d569e0c1c32b', 'a612f859-1956-4141-a24b-75bbe3e3abeb', 'UNSOLD'),
('85728d6c-7832-48f9-95bb-c7ae0923b35c', '1e8a73df-b57f-4a17-8522-e81dabdfe881', 'UNSOLD'),
('1990d0f3-d910-4812-9369-3d4a2af13fde', '2c462eb7-7421-484d-a0df-138e20d8ad88', 'UNSOLD'),
('d040a7c5-77e5-4b3b-9b96-c3666a0c7f43', 'ad0deeb9-dda5-498c-97c2-f778e091e746', 'UNSOLD'),
('b7c86dba-db82-4a6b-adfb-270fc2ceed8b', '326c1960-8a5f-4ebf-9cc0-7454374b921e', 'UNSOLD'),
('3cc0bd25-db01-40e8-aaf1-0f5e8df9a17a', '7bdc1abe-8e32-41c7-9188-dfa93f522717', 'UNSOLD'),
('3b1376bb-efba-4188-baeb-54dd5baa2d25', 'cd0c1e4b-1bc7-44b7-bb45-355f5339b855', 'UNSOLD'),
('7334f261-5a0f-4bb5-bb8e-ec40c8b2fe6d', 'bbe2c154-1ca5-435d-8975-bd2ff9a745d8', 'UNSOLD'),
('24d0ccfa-c2b0-4fe0-beca-7149e7eb4773', 'ade08ae3-0643-4347-b3ae-46211fcedeac', 'UNSOLD'),
('c4d6c94f-6ba2-4a21-9eb7-f9569cc1030c', 'ae849ca7-f5ce-4d9e-afd2-1ed0301dd7d7', 'UNSOLD'),
('caa79aea-f779-41e5-be9b-0c467b05246c', '576bd8c0-43d1-4f37-932a-a1bcaeb07271', 'UNSOLD'),
('77aa7723-5cc0-4c1a-bc70-58dd9478ad86', '7011e996-c0ad-4292-989c-58d78a6b64d9', 'UNSOLD'),
('0010f4e1-6318-4676-bd85-15ba45d05f03', '7c60b6e1-fdb4-4d20-bdf7-2555efc50581', 'UNSOLD'),
('eb1bb974-2fed-4f4e-bb5b-fdd62011dd0f', '4e85d813-fdad-424d-8ef8-4a9d20203716', 'UNSOLD'),
('52a30c0e-a3bc-4144-ae73-5f8c47852a59', '230879a9-c8e9-4393-9992-ccbc3eefa852', 'UNSOLD'),
('46a7134d-0237-4de2-85d2-e832f8966761', 'b465e058-3d97-44d8-b884-b08e0377680a', 'UNSOLD'),
('79a075c1-55f5-4208-86f5-02723cd38690', 'f864415e-6e73-462c-bdbb-3361ccfd341d', 'UNSOLD'),
('60da8c98-5e09-412e-8355-8e1ea572c26f', 'b0caac01-7621-4921-abcf-cb3ce372ee35', 'UNSOLD'),
('ec5bec24-8892-4af5-9d10-48a0e46c4e49', 'f19a8618-2ad3-4bb7-a177-660668914a8a', 'UNSOLD'),
('5a53c65f-6b4e-4f46-ad88-a03dcb77a676', 'cbe0ca24-8b4f-4cde-9b2d-fc7c3a08c992', 'UNSOLD'),
('4e81c49b-a0e8-4615-af80-48ec7a95b289', '6bde1cda-e5ac-4c87-ac34-ed10e0fd1822', 'UNSOLD'),
('1a737ecb-55fc-4ac2-9f14-9bdc35480eee', '15581c4e-54b9-4f57-ab40-da157918d3bb', 'UNSOLD'),
('7aeb7eb6-9a30-4e0a-a582-4fa36f986bd0', 'ad6bad9e-dd25-406c-925b-d482594986ab', 'UNSOLD'),
('51c9aa71-76b7-48be-9df8-4c0a11416156', 'f029367e-57c4-49b4-9e28-ebdf23882a6b', 'UNSOLD'),
('f742a9d9-8915-4e86-a7f2-c56bf168247f', '3804df65-bf8c-4d6c-b6b4-de6ff6959ea7', 'UNSOLD'),
('c1e2c968-6d06-472b-bd9c-ed9ecf66487a', 'ee3bd3f2-969a-4a7a-bbd4-b960b71a8610', 'UNSOLD'),
('41ea02a6-7fd4-4e27-b40b-b7c5fb39bbc3', '7da77f61-cfb8-46ae-8327-052a8f028545', 'UNSOLD'),
('8c6610d6-d8c3-4d9b-b4c0-16d76d0ec982', 'fceb1e37-dd46-4815-a575-32381d9385ad', 'UNSOLD'),
('82ab8dff-d2eb-49cf-b2da-e2e940e7ded9', '09c791ea-4840-4a74-87e3-3525e26cd5c6', 'UNSOLD'),
('790bbed4-122f-49f4-9f88-e53235db579b', '438555ad-d049-468e-aa56-cd31754f1bf6', 'UNSOLD'),
('a6d724f8-4fbe-4984-9a8a-f37f3ac1adba', '62a25c6c-1422-4396-89d4-30d2658251f4', 'UNSOLD'),
('1110a74b-1da0-431b-9281-5faf7264e427', 'a09626d7-7f31-476e-afb3-ceb70fe457b8', 'UNSOLD'),
('556d610f-9688-4c12-92a2-0a3ca0732800', 'af96832a-6733-4c3b-acd6-82137f18a9d4', 'UNSOLD'),
('f08e13c8-21db-4ca9-83f4-8e2cb4103f61', '5f6e6021-0587-4639-8bcb-dd13cf38b0ac', 'UNSOLD'),
('b5922954-dbcc-421c-9279-1d5a749cab39', 'eff823b8-53a1-4713-b2ef-7926d498c04d', 'UNSOLD'),
('ddd58cf8-747b-4b81-8209-9a70f2776ab7', 'a98d9612-0f01-44ef-a615-39312e7e0ac7', 'UNSOLD'),
('9d836430-76cc-49f7-acfa-4966cbf0f4ad', '65934d0b-cc0c-4902-826c-791a740511a8', 'UNSOLD'),
('21293add-efff-4420-bd16-2bcd64aefb53', '9d88fc69-05e3-452b-97ec-d866d3b0499c', 'UNSOLD'),
('23ec21cc-cdcb-43be-9ac5-2c1bbccb723c', '072c577a-9b2e-40e1-87e4-e7225b198920', 'UNSOLD'),
('3e58104d-a436-44c3-ba8a-fca7b66c942b', '6b9cb139-b92c-4762-a1e6-fba30db6e6e6', 'UNSOLD'),
('58943320-a594-497b-a7e3-b78945d825b1', '4917f30f-f1dc-4f8d-9c9b-755c746470aa', 'UNSOLD'),
('fade1568-a334-4756-9ea5-60f208eecb66', '305ce243-461a-4688-a20e-0538c2b0f163', 'UNSOLD'),
('53cd4896-2f47-4463-969c-f4c6374f59b9', '37e1a6c3-8b8f-4a0c-9fec-9f99e93eb46c', 'UNSOLD'),
('94566704-b316-461a-9f1d-269ae852f167', 'd2eb29dc-0a01-4537-87ae-51ba4cba3051', 'UNSOLD'),
('d4d6900a-44df-432f-83e5-b691e0552d38', '0b4ca758-9467-4359-9fa4-c4a28a7536e3', 'UNSOLD'),
('dbbacae5-ab4d-40eb-9432-0dc7af4f0db4', '491b040f-6623-43ee-9ec1-62169fa1bf2b', 'UNSOLD'),
('27c073d2-8324-47d5-b9f3-1d552086d6a2', '64d88df9-205f-475e-aee7-662e84db12b8', 'UNSOLD'),
('7c524541-609c-4c18-bfb8-ceaa4b1395e8', 'b3484a09-2645-426c-8949-f5dd7e9404d7', 'UNSOLD'),
('d2b18406-6d55-44af-8a74-547b464e0192', 'e287c9a9-d6cc-437a-b781-636f33e7404a', 'UNSOLD'),
('ede417d7-439e-487e-b92f-b89876969056', 'ec6a1257-97a4-4b5b-8137-3e8aaee60143', 'UNSOLD'),
('fb6249a6-7e6e-4bcc-980d-78bbfcf6fe6f', '555d334d-0bab-439c-9162-52fcf10b0a78', 'UNSOLD'),
('916202b9-26b1-4552-9bcf-fe6030f89e48', '20d511d9-a0fd-4382-a09f-81b942c6f199', 'UNSOLD'),
('816df626-5ecb-4052-aef4-babe10fde2a6', 'c1dfec75-e69b-4fe1-b76e-fdc86c7b3464', 'UNSOLD'),
('3a565796-0438-420b-8be3-adf08544f0ff', '5aa5aa8e-03d9-406e-9ce9-6dbe43913eab', 'UNSOLD'),
('04f8be33-7992-4a1a-8fb0-fed4b2382b13', '19021b90-1500-47fa-b3e4-155e00f27eeb', 'UNSOLD'),
('a1ee351f-3070-4f9b-9981-dc1f944eac10', 'cee0ea48-f8b7-459a-8d0e-1493981ae851', 'UNSOLD'),
('7eac43a4-06bf-4a48-b730-d8d431f924fd', '5ad2c8b6-0e7c-4456-89df-db644c707cec', 'UNSOLD'),
('9a7a1641-e071-417c-bff9-c596dc2692eb', 'f00a896d-01ef-4314-8e5d-742f01a6f2db', 'UNSOLD'),
('316ca5e0-2cce-488c-9e05-9c74782f927d', 'd103ade1-8912-4455-96ca-e79bede35bbe', 'UNSOLD'),
('cb1c33d1-0edd-4583-bc0a-a487db49e5fa', 'cad40791-c85b-4154-a755-8fe1c677ed41', 'UNSOLD'),
('a4b43ae1-1b35-478c-987b-09cfdd638428', 'cd205486-e151-487c-84a3-fa7c9fc3e889', 'UNSOLD'),
('512e6a55-a77b-4dae-ad46-b91371a324bd', 'e461f705-26cb-47f3-b9bd-cf877748dfaa', 'UNSOLD'),
('7b636eed-2858-4417-82e2-56429802ab00', '26617ba4-f0d0-4aff-9266-5b04ab9329f3', 'UNSOLD'),
('c4bbd254-70ef-400e-b009-5894a949f051', '2554d599-7557-4056-b46d-15df398d0a13', 'UNSOLD'),
('14a38f58-69f3-475c-bc21-29241353818a', 'a99ce55d-f947-44de-a882-294d044c85b6', 'UNSOLD'),
('1a2e1789-361a-4531-85a3-7381e48400fb', 'c1bd9a0c-c8b5-412f-a326-4813394e8465', 'UNSOLD'),
('32215234-9ec0-4613-9971-eb9c9221b69c', '0741ba20-8e53-4e4e-8893-27e21652cac0', 'UNSOLD'),
('26cb5a09-d4bd-4ea6-a553-19a2caf25738', 'f65ad787-b230-454b-b21c-fc99492ba8aa', 'UNSOLD'),
('9a26fc2e-c9ab-4044-866f-7d23ef3deda7', '48b81043-c5e3-4e15-bfa7-fdbc64339cdc', 'UNSOLD'),
('afbc16a0-9718-400b-bea9-c02f95b98155', '1fd3b8b2-fbca-4fc2-a317-0acfa781d88c', 'UNSOLD'),
('f29315fe-4042-47c5-b58a-409311ad26c7', '14bd5306-df25-474e-bcba-2b851f7916a2', 'UNSOLD'),
('272f3678-5948-499c-8cd4-0f8a3898bfcb', 'ecbfefab-cc3c-4052-ad5f-3907148ac132', 'UNSOLD'),
('9c51dc24-0a6f-4d00-8458-f3edb6ac7a2a', 'aa583314-be24-4462-a9a6-fe378472636d', 'UNSOLD'),
('d9bc6dba-106c-4ae2-8021-901ec7885a09', '5c9ad2f0-32d5-48fa-b631-f98130e1db7b', 'UNSOLD'),
('96d5cbc9-3569-4da5-a995-bb252a5dc1e9', 'a7f55959-ba61-4c70-b5e6-0621d8f32a4d', 'UNSOLD'),
('70a9e6b7-659a-4d31-9164-4e0ee5fb7df2', 'e0e801a5-b761-4c9a-b82d-a0da04c512ea', 'UNSOLD'),
('266b36b4-b943-42d0-b5a6-4076201e8df3', 'cec1c4cc-595c-4ddc-8fc7-62afab52eefd', 'UNSOLD'),
('0f1e1812-1168-4e12-b0b9-a187aec4a0d2', '81ecc57e-8ebf-4aaf-931a-9dc6e3188e0f', 'UNSOLD'),
('2a241f96-c40c-4e5f-abf0-133777749553', 'af91f02d-6e2f-41d8-b5f3-7aec794b6f9b', 'UNSOLD');

INSERT INTO "AdminUser" (id, username, password_hash, role) VALUES
('563499c3-2195-4091-8b6b-0eff2a1a4d96', 'admin', '$2b$10$tv4nM3ukWWr0lT9dSJZIruIXk6EX/Xw2GBY71UYqwntXCVbJnWWlO', 'ADMIN'),
('eaa6c404-4ebd-4dac-ac98-f031717162b8', 'screen', '$2b$10$NZjPETkHGWDxAZFFLVWqI.sBmMN1Ln/ulizKs1sX5vh8Ox3oSwlhq', 'SCREEN');

INSERT INTO "AuctionSequence" (id, name, type, sequence_items) VALUES
(1, 'Franchise Auction', 'FRANCHISE', '[3,7,1,9,5,10,2,6,8,4]');

INSERT INTO "AuctionSequence" (id, name, type, sequence_items) VALUES
(2, 'Power Card Auction', 'POWER_CARD', '["GOD_EYE","MULLIGAN","FINAL_STRIKE","BID_FREEZER"]');

INSERT INTO "AuctionSequence" (id, name, type, sequence_items) VALUES
(3, 'Player Auction 1', 'PLAYER', '[6,123,138,145,54,150,71,70,157,86,120,63,2,36,45,96,92,151,69,112,72,139,101,116,77,29,79,20,48,104,100,44,88,81,94,147,122,62,78,149,91,11,148,4,31,121,73,95,135,56,144,61,106,110,22,89,65,49,136,109,118,53,127,102,84,158,41,115,33,43,85,1,25,23,9,55,126,137,93,103,98,76,3,143,159,19,83,57,59,30,14,134,140,105,68,128,39,13,24,26,80,7,130,75,99,74,132,111,32,113,8,125,107,133,40,34,27,141,64,97,154,21,119,37,12,67,58,108,28,153,114,17,42,152,82,18,66,87,50,38,60,5,155,35,146,46,129,156,131,90,117,47,124,16,51,10,52,142,15]');

INSERT INTO "AuctionState" (id, phase, auction_day) VALUES (1, 'NOT_STARTED', 'Day 1');

