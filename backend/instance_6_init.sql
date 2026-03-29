-- INSTANCE 6 INITIALIZATION
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



-- ── DATA FOR INSTANCE 6 ──

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
('614e9fcf-81aa-4e6b-9716-2eea247aa18d', 'Humorless', 'Humorless', '$2b$10$CNnakQt9WgN2TjMEnTT3OeSjnCg1bRj/cpGHRgZpnb4l9cU8dtFOa', 120, 0),
('a04e0cb1-22d5-4091-95d9-a11b07b78ff7', 'Shawarma', 'Shawarma', '$2b$10$7zTc5A0xs10rXcDkyVN7a.Uz70jk7Evp9j0PK8zjKJwckTmEn.QA6', 120, 0),
('f1652b3b-1597-494c-a709-71ece173db46', 'NAMO', 'NAMO', '$2b$10$wmPA0O13g4k2oLQ/ow14y.kpdqIoVS/myLSwlVnbC62HpEp4JvwCS', 120, 0),
('df72ea8d-763a-465a-95e3-f225616a17f4', 'Teddy 11', 'Teddy 11', '$2b$10$zg3orsNznZ/DVzk.GTipkuXz2AksKaKT4Rsu2/deLpembsvageeNO', 120, 0),
('4dee50fd-7598-4ade-a790-079534cd84f9', 'Dhurandhar', 'Dhurandhar', '$2b$10$LaviXiF50taclZVL3W3XNe7d2j/kvNRVPsixrO9uVr73U1Ic7vhdC', 120, 0),
('f4ede382-aa5e-4b33-a1a7-e7d3f44f7699', 'Boundary Breakers', 'Boundary Breakers', '$2b$10$WNmAUxpGI43E2nx4Xj9y8eKOUL8wU3XXk6.Nb2JmUWK7murIDJ1/O', 120, 0),
('59f62344-05ec-4ead-8db9-5921d05e4161', 'Team Diamonds', 'Team Diamonds', '$2b$10$nfsZzZuauvQqwJGCj7Fone6cRfTdLRRP007V4sHMyIDzQbOtHzwwa', 120, 0),
('362c6cdf-1f5a-4f50-9d53-4711314ebd7e', 'mavericks', 'mavericks', '$2b$10$lkTpgrqe0EkAI4kQ9SCEle8MYa.FsefsbkiDjzhT5Nov.NZUL7tKu', 120, 0),
('fdbcf62d-1ab4-4417-97eb-a433bbaf1d28', 'Dhurandar XI', 'Dhurandar XI', '$2b$10$IedBeCBQVzN/zT64XUH9UeWOSryzxGFDOxgpA6nI2B5eSmz5ixxyC', 120, 0),
('20479129-061e-4e89-9c82-f8e8834261fd', 'Vajra warriors', 'Vajra warriors', '$2b$10$8fIvYk2U/QqG4CIiK6JN1ewmtao4VlOkHOKjJcrnu58wKH2LBzuGK', 120, 0);

INSERT INTO "Player" (id, rank, name, team, role, category, pool, grade, rating, nationality, nationality_raw, base_price, is_riddle, riddle_title, riddle_question, legacy, url, matches, bat_runs, bat_sr, bat_average, bowl_wickets, bowl_eco, bowl_avg, sub_scoring, sub_impact, sub_consistency, sub_experience, sub_wicket_taking, sub_economy, sub_efficiency, sub_batting, sub_bowling, sub_versatility) VALUES
('548faaaf-a06e-4d97-8232-7608b9269cbf', 93, 'Washington Sundar', 'Gujarat Titans', 'Bowling Allrounder', 'AR', 'AR', 'C', 67, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/10945/washington-sundar', 66.0, 511.0, NULL, NULL, 39.0, NULL, NULL, NULL, NULL, NULL, 63, NULL, NULL, NULL, 42.0, 40.0, 40.0),
('84c51892-3ff7-42b9-8240-5ae2b092c102', 9, 'KL Rahul', 'Delhi Capitals', 'WK-Batsman', 'WK', 'BAT_WK', 'A', 95, 'INDIAN', 'Indian', 2, false, NULL, NULL, 4, 'https://www.cricbuzz.com/profiles/8733/kl-rahul', 145.0, 5222.0, 136.03, 46.21, NULL, NULL, NULL, 99.0, 69.0, 99.0, 99, NULL, NULL, NULL, NULL, NULL, NULL),
('cae60e59-0588-4fa2-97b8-c1b5420c96c5', 144, 'Vijaykumar Vyshak', 'Punjab Kings', 'Bowler', 'BOWL', 'BOWL', 'C', 57, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/10486/vijaykumar-vyshak', 16.0, NULL, NULL, NULL, 17.0, 10.38, 33.88, NULL, NULL, NULL, 38, 14.0, 33.0, 66.0, NULL, NULL, NULL),
('0421a913-592c-4d9d-94dd-4e4a8c8e6f35', 67, 'Ayush Badoni', 'Lucknow Super Giants', 'Batting Allrounder', 'AR', 'AR', 'B', 71, 'INDIAN', 'Indian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/13907/ayush-badoni', 56.0, 963.0, NULL, NULL, 4.0, NULL, NULL, NULL, NULL, NULL, 58, NULL, NULL, NULL, 63.0, 37.0, 37.0),
('d6b103f8-5a80-421a-b27e-606c800ef9b5', 32, 'David Miller', 'Delhi Capitals', 'Batsman', 'BAT', 'BAT_WK', 'B', 80, 'OVERSEAS', 'South African', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/6349/david-miller', 141.0, 3077.0, 138.61, 35.78, NULL, NULL, NULL, 60.0, 70.0, 89.0, 99, NULL, NULL, NULL, NULL, NULL, NULL),
('62aeb2d3-b3ce-465b-8f4e-3298f55379e7', 110, 'Josh Inglis', 'Lucknow Super Giants', 'WK-Batsman', 'WK', 'BAT_WK', 'C', 63, 'OVERSEAS', 'Australian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/10637/josh-inglis', 11.0, 278.0, 162.58, 30.89, NULL, NULL, NULL, 9.0, 87.0, 77.0, 35, NULL, NULL, NULL, NULL, NULL, NULL),
('e48a8d08-b42a-4427-b4f0-a97f13b9f148', 152, 'Anukul Roy', 'Kolkata Knight Riders', 'Batting Allrounder', 'AR', 'AR', 'C', 56, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/12344/anukul-roy', 11.0, 26.0, NULL, NULL, 6.0, NULL, NULL, NULL, NULL, NULL, 35, NULL, NULL, NULL, 17.0, 29.0, 17.0),
('bb8790b6-1c6d-4671-b04d-4c41a1f0d1b4', 130, 'Sameer Rizvi', 'Delhi Capitals', 'Batsman', 'BAT', 'BAT_WK', 'C', 60, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/14700/sameer-rizvi', 13.0, 172.0, 140.99, 24.57, NULL, NULL, NULL, 7.0, 72.0, 61.0, 36, NULL, NULL, NULL, NULL, NULL, NULL),
('9dbc518d-9b26-47c1-a197-1608f9df0c77', 95, 'Nehal Wadhera', 'Punjab Kings', 'Batsman', 'BAT', 'BAT_WK', 'C', 66, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/13915/nehal-wadhera', 36.0, 719.0, 142.95, 26.63, NULL, NULL, NULL, 17.0, 73.0, 66.0, 48, NULL, NULL, NULL, NULL, NULL, NULL),
('6c9f1808-f9b6-4227-af66-ece7f000797d', 87, 'Tushar Deshpande', 'Rajasthan Royals', 'Bowler', 'BOWL', 'BOWL', 'C', 67, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/11307/tushar-deshpande', 46.0, NULL, NULL, NULL, 51.0, 9.84, 31.04, NULL, NULL, NULL, 53, 36.0, 42.0, 72.0, NULL, NULL, NULL),
('ca28696f-cb0e-45fd-83f7-751755299ca6', 90, 'Naman Dhir', 'Mumbai Indians', 'Batsman', 'BAT', 'BAT_WK', 'C', 67, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/36139/naman-dhir', 23.0, 392.0, 180.65, 28.0, NULL, NULL, NULL, 11.0, 99.0, 70.0, 41, NULL, NULL, NULL, NULL, NULL, NULL),
('bac09b04-443b-4cfb-95d6-e78c1455582c', 92, 'Shashank Singh', 'Punjab Kings', 'Batting Allrounder', 'AR', 'AR', 'C', 67, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/10919/shashank-singh', 41.0, 773.0, NULL, NULL, 1.0, NULL, NULL, NULL, NULL, NULL, 50, NULL, NULL, NULL, 67.0, 14.0, 14.0),
('6e7228cf-87fa-4435-8274-5c29a90b24d7', 119, 'Wanindu Hasaranga', 'Lucknow Super Giants', 'Bowling Allrounder', 'AR', 'AR', 'C', 62, 'OVERSEAS', 'Sri Lankan', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/10926/wanindu-hasaranga', 37.0, 81.0, NULL, NULL, 46.0, NULL, NULL, NULL, NULL, NULL, 48, NULL, NULL, NULL, 15.0, 45.0, 15.0),
('24950e2e-df00-46bb-b093-461f8629bf74', 27, 'Shreyas Iyer', 'Punjab Kings', 'Batsman', 'BAT', 'BAT_WK', 'B', 83, 'INDIAN', 'Indian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/9428/shreyas-iyer', 132.0, 3731.0, 133.35, 34.23, NULL, NULL, NULL, 72.0, 67.0, 85.0, 96, NULL, NULL, NULL, NULL, NULL, NULL),
('5e6daa01-9630-495a-b1a7-30c5b5b121c1', 145, 'Akash Maharaj Singh', 'Lucknow Super Giants', 'Bowler', 'BOWL', 'BOWL', 'C', 57, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/14696/akash-maharaj-singh', 10.0, NULL, NULL, NULL, 9.0, 9.54, 36.22, NULL, NULL, NULL, 35, 9.0, 47.0, 61.0, NULL, NULL, NULL),
('8a57919f-ce98-4954-83b4-9d74d788574f', 2, 'Yuzvendra Chahal', 'Punjab Kings', 'Bowler', 'BOWL', 'BOWL', 'A', 99, 'INDIAN', 'Indian', 2, false, NULL, NULL, 10, 'https://www.cricbuzz.com/profiles/7910/yuzvendra-chahal', 174.0, NULL, NULL, NULL, 221.0, 7.96, 22.77, NULL, NULL, NULL, 99, 99.0, 73.0, 89.0, NULL, NULL, NULL),
('5c400197-7c13-4a0c-b5d8-6a4f9aaba6ce', 140, 'Mukesh Choudhary', 'Chennai Super Kings', 'Bowler', 'BOWL', 'BOWL', 'C', 58, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/13184/mukesh-choudhary', 16.0, NULL, NULL, NULL, 17.0, 9.94, 30.71, NULL, NULL, NULL, 38, 14.0, 40.0, 72.0, NULL, NULL, NULL),
('75dc351c-46fc-4649-bcf4-2eb5baa37c43', 143, 'Prashant Solanki', 'Kolkata Knight Riders', 'Bowler', 'BOWL', 'BOWL', 'C', 57, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/12805/prashant-solanki', 2.0, NULL, NULL, NULL, 2.0, 6.33, 19.0, NULL, NULL, NULL, 31, 5.0, 99.0, 97.0, NULL, NULL, NULL),
('deb2a097-a4d9-4a78-9dee-48be4e658f77', 34, 'Quinton de Kock', 'Mumbai Indians', 'WK-Batsman', 'WK', 'BAT_WK', 'B', 79, 'OVERSEAS', 'South African', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/8520/quinton-de-kock', 115.0, 3309.0, 134.03, 30.64, NULL, NULL, NULL, 64.0, 67.0, 76.0, 87, NULL, NULL, NULL, NULL, NULL, NULL),
('0f03c0f6-d3eb-40f4-9f32-5ff47ae536ab', 142, 'Kamindu Mendis', 'Sunrisers Hyderabad', 'Batting Allrounder', 'AR', 'AR', 'C', 57, 'OVERSEAS', 'Sri Lankan', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/10940/kamindu-mendis', 5.0, 92.0, NULL, NULL, 2.0, NULL, NULL, NULL, NULL, NULL, 32, NULL, NULL, NULL, 38.0, 29.0, 29.0),
('23a6fe90-586f-46d2-9501-537afc1d14e8', 37, 'Ishan Kishan', 'Sunrisers Hyderabad', 'WK-Batsman', 'WK', 'BAT_WK', 'B', 78, 'INDIAN', 'Indian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/10276/ishan-kishan', 119.0, 2998.0, 137.65, 29.11, NULL, NULL, NULL, 58.0, 70.0, 72.0, 89, NULL, NULL, NULL, NULL, NULL, NULL),
('852bc0ff-ecd5-49af-872f-7dc8ad69dd76', 35, 'Deepak Chahar', 'Mumbai Indians', 'Bowler', 'BOWL', 'BOWL', 'B', 78, 'INDIAN', 'Indian', 1, true, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/7836/deepak-chahar', 95.0, NULL, NULL, NULL, 88.0, 8.14, 29.51, NULL, NULL, NULL, 77, 60.0, 70.0, 75.0, NULL, NULL, NULL),
('46bc75d2-62e8-4678-bce0-c0ee4650c9d8', 25, 'Marcus Stoinis', 'Punjab Kings', 'Batting Allrounder', 'AR', 'AR', 'B', 83, 'OVERSEAS', 'Australian', 1, false, NULL, NULL, 4, 'https://www.cricbuzz.com/profiles/8989/marcus-stoinis', 109.0, 2026.0, NULL, NULL, 44.0, NULL, NULL, NULL, NULL, NULL, 84, NULL, NULL, NULL, 90.0, 37.0, 37.0),
('72bc6c8c-1bae-454e-93f3-08af9093e80c', 139, 'Nandre Burger', 'Rajasthan Royals', 'Bowler', 'BOWL', 'BOWL', 'C', 58, 'OVERSEAS', 'South African', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/13630/nandre-burger', 5.0, NULL, NULL, NULL, 7.0, 8.53, 20.71, NULL, NULL, NULL, 32, 8.0, 63.0, 94.0, NULL, NULL, NULL),
('5d388507-923d-4449-b857-6ea7e5532f4d', 148, 'Vignesh Puthur', 'Rajasthan Royals', 'Bowler', 'BOWL', 'BOWL', 'C', 57, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/1447337/vignesh-puthur', 5.0, NULL, NULL, NULL, 6.0, 9.08, 18.17, NULL, NULL, NULL, 32, 7.0, 54.0, 99.0, NULL, NULL, NULL),
('aeb9aa8b-d991-43b8-86e2-2d8467a6abc1', 129, 'Anuj Rawat', 'Gujarat Titans', 'WK-Batsman', 'WK', 'BAT_WK', 'C', 60, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/13135/anuj-rawat', 24.0, 318.0, 119.11, 19.88, NULL, NULL, NULL, 10.0, 57.0, 50.0, 42, NULL, NULL, NULL, NULL, NULL, NULL),
('26b5d6b7-9d8e-4650-86e0-1864fa619380', 8, 'MS Dhoni', 'Chennai Super Kings', 'WK-Batsman', 'WK', 'BAT_WK', 'A', 95, 'INDIAN', 'Indian', 2, false, NULL, NULL, 4, 'https://www.cricbuzz.com/profiles/265/ms-dhoni', 278.0, 5439.0, 137.46, 38.3, NULL, NULL, NULL, 99.0, 70.0, 95.0, 99, NULL, NULL, NULL, NULL, NULL, NULL),
('866799e4-b2f3-4743-ae02-6ede10f320f6', 99, 'Yash Dayal', 'Royal Challengers Bengaluru', 'Bowler', 'BOWL', 'BOWL', 'C', 66, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/14172/yash-dayal', 43.0, NULL, NULL, NULL, 41.0, 9.58, 33.9, NULL, NULL, NULL, 51, 30.0, 46.0, 66.0, NULL, NULL, NULL),
('895d57e0-c6e0-4b25-b7ac-2bfb5b591023', 118, 'Aniket Verma', 'Sunrisers Hyderabad', 'Batsman', 'BAT', 'BAT_WK', 'C', 62, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/1447065/aniket-verma', 14.0, 236.0, 166.2, 26.22, NULL, NULL, NULL, 8.0, 89.0, 65.0, 37, NULL, NULL, NULL, NULL, NULL, NULL),
('66538494-f0fd-4fb2-88d4-2e35740659b6', 78, 'Rajat Patidar', 'Royal Challengers Bengaluru', 'Batsman', 'BAT', 'BAT_WK', 'C', 69, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/10636/rajat-patidar', 42.0, 1111.0, 154.31, 30.86, NULL, NULL, NULL, 24.0, 81.0, 77.0, 51, NULL, NULL, NULL, NULL, NULL, NULL),
('3e360ee7-148d-40cd-b747-5fbba7af2609', 33, 'Ishant Sharma', 'Gujarat Titans', 'Bowler', 'BOWL', 'BOWL', 'B', 79, 'INDIAN', 'Indian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/702/ishant-sharma', 117.0, NULL, NULL, NULL, 96.0, 8.38, 35.18, NULL, NULL, NULL, 88, 65.0, 66.0, 63.0, NULL, NULL, NULL),
('67d6a937-c44f-4ec9-9956-15f6a2aaff27', 107, 'Shahbaz Ahmed', 'Lucknow Super Giants', 'Bowling Allrounder', 'AR', 'AR', 'C', 64, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/14606/shahbaz-ahmed', 58.0, 545.0, NULL, NULL, 22.0, NULL, NULL, NULL, NULL, NULL, 59, NULL, NULL, NULL, 43.0, 27.0, 27.0),
('3ee06803-0884-46d1-8abf-142f755d0e2c', 44, 'Khaleel Ahmed', 'Chennai Super Kings', 'Bowler', 'BOWL', 'BOWL', 'B', 77, 'INDIAN', 'Indian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/10952/khaleel-ahmed', 71.0, NULL, NULL, NULL, 89.0, 8.98, 26.16, NULL, NULL, NULL, 65, 61.0, 56.0, 82.0, NULL, NULL, NULL),
('09d26803-17d8-4f1b-96ac-07c3ec3284a2', 106, 'Sarfaraz Khan', 'Chennai Super Kings', 'Batsman', 'BAT', 'BAT_WK', 'C', 64, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/9429/sarfaraz-khan', 50.0, 585.0, 130.59, 22.5, NULL, NULL, NULL, 15.0, 65.0, 56.0, 55, NULL, NULL, NULL, NULL, NULL, NULL),
('9c7aa329-91a3-48a4-bbe6-784ddffa825d', 105, 'Mukesh Kumar', 'Delhi Capitals', 'Bowler', 'BOWL', 'BOWL', 'C', 64, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/10754/mukesh-kumar', 32.0, NULL, NULL, NULL, 36.0, 10.4, 30.61, NULL, NULL, NULL, 46, 27.0, 33.0, 73.0, NULL, NULL, NULL),
('7d6f5eea-ebd8-44a3-abb0-b5a55f45b18f', 80, 'Lockie Ferguson', 'Punjab Kings', 'Bowler', 'BOWL', 'BOWL', 'C', 69, 'OVERSEAS', 'New Zealander', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/10692/lockie-ferguson', 49.0, NULL, NULL, NULL, 51.0, 8.97, 30.0, NULL, NULL, NULL, 54, 36.0, 56.0, 74.0, NULL, NULL, NULL),
('d1ef9f33-6f4c-4465-ad12-8ac82873fcbc', 57, 'Jofra Archer', 'Rajasthan Royals', 'Bowler', 'BOWL', 'BOWL', 'B', 73, 'OVERSEAS', 'English', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/11540/jofra-archer', 52.0, NULL, NULL, NULL, 59.0, 7.89, 27.15, NULL, NULL, NULL, 56, 41.0, 74.0, 80.0, NULL, NULL, NULL),
('f4fbeac5-5e26-41c9-900a-c46aba53ed32', 126, 'Nathan Ellis', 'Chennai Super Kings', 'Bowler', 'BOWL', 'BOWL', 'C', 61, 'OVERSEAS', 'Australian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/15480/nathan-ellis', 17.0, NULL, NULL, NULL, 19.0, 8.67, 28.74, NULL, NULL, NULL, 38, 16.0, 61.0, 77.0, NULL, NULL, NULL),
('738192aa-b2a5-42d9-95ad-63e5b7de49ff', 28, 'Kuldeep Yadav', 'Delhi Capitals', 'Bowler', 'BOWL', 'BOWL', 'B', 83, 'INDIAN', 'Indian', 1, false, NULL, NULL, 2, 'https://www.cricbuzz.com/profiles/8292/kuldeep-yadav', 98.0, NULL, NULL, NULL, 102.0, 8.04, 26.95, NULL, NULL, NULL, 79, 69.0, 71.0, 80.0, NULL, NULL, NULL),
('e33c1bcc-2841-48d2-b265-c65692cd97a9', 121, 'Suyash Sharma', 'Royal Challengers Bengaluru', 'Bowler', 'BOWL', 'BOWL', 'C', 61, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/36487/suyash-sharma', 27.0, NULL, NULL, NULL, 18.0, 8.75, 45.22, NULL, NULL, NULL, 43, 15.0, 60.0, 41.0, NULL, NULL, NULL),
('adc87e8e-c3f4-4eb2-b72c-84c78e9fa89c', 113, 'Marco Jansen', 'Punjab Kings', 'Bowling Allrounder', 'AR', 'AR', 'C', 62, 'OVERSEAS', 'South African', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/14565/marco-jansen', 35.0, 141.0, NULL, NULL, 36.0, NULL, NULL, NULL, NULL, NULL, 47, NULL, NULL, NULL, 26.0, 36.0, 26.0),
('66cc8bb8-c2a6-47ec-a67f-68e866d3323a', 137, 'Jayant Yadav', 'Gujarat Titans', 'Bowling Allrounder', 'AR', 'AR', 'C', 58, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/8182/jayant-yadav', 20.0, 40.0, NULL, NULL, 8.0, NULL, NULL, NULL, NULL, NULL, 40, NULL, NULL, NULL, 22.0, 25.0, 22.0),
('986611d0-69c3-4041-a3d7-63f8bf4f32ce', 83, 'Jason Holder', 'Gujarat Titans', 'Bowling Allrounder', 'AR', 'AR', 'C', 68, 'OVERSEAS', 'West Indian', 0.5, false, NULL, NULL, 2, 'https://www.cricbuzz.com/profiles/8313/jason-holder', 46.0, 259.0, NULL, NULL, 53.0, NULL, NULL, NULL, NULL, NULL, 53, NULL, NULL, NULL, 32.0, 45.0, 32.0),
('56d6576b-ce76-4ada-a774-7902083759c2', 24, 'Varun Chakaravarthy', 'Kolkata Knight Riders', 'Bowler', 'BOWL', 'BOWL', 'B', 84, 'INDIAN', 'Indian', 1, false, NULL, NULL, 2, 'https://www.cricbuzz.com/profiles/12926/varun-chakaravarthy', 83.0, NULL, NULL, NULL, 100.0, 7.58, 23.85, NULL, NULL, NULL, 71, 68.0, 79.0, 87.0, NULL, NULL, NULL),
('8c56b21d-954f-45da-8907-9f3aad9a5838', 55, 'Mitchell Starc', 'Delhi Capitals', 'Bowler', 'BOWL', 'BOWL', 'B', 73, 'OVERSEAS', 'Australian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/7710/mitchell-starc', 51.0, NULL, NULL, NULL, 65.0, 8.61, 23.12, NULL, NULL, NULL, 55, 45.0, 62.0, 88.0, NULL, NULL, NULL),
('a4a7ec8c-dea6-43fc-aa00-86b794185e46', 69, 'Liam Livingstone', 'Sunrisers Hyderabad', 'Batting Allrounder', 'AR', 'AR', 'B', 70, 'OVERSEAS', 'English', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/10045/liam-livingstone', 49.0, 1051.0, NULL, NULL, 13.0, NULL, NULL, NULL, NULL, NULL, 54, NULL, NULL, NULL, 70.0, 28.0, 28.0),
('5698b972-8319-4537-abac-75b5a394fcd9', 149, 'Glenn Phillips', 'Gujarat Titans', 'Batting Allrounder', 'AR', 'AR', 'C', 56, 'OVERSEAS', 'New Zealander', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/10693/glenn-phillips', 8.0, 65.0, NULL, NULL, 2.0, NULL, NULL, NULL, NULL, NULL, 34, NULL, NULL, NULL, 24.0, 34.0, 24.0),
('f9fb85eb-3143-4197-ac12-a40cf9b4c009', 5, 'Bhuvneshwar Kumar', 'Royal Challengers Bengaluru', 'Bowler', 'BOWL', 'BOWL', 'A', 98, 'INDIAN', 'Indian', 2, false, NULL, NULL, 8, 'https://www.cricbuzz.com/profiles/1726/bhuvneshwar-kumar', 190.0, NULL, NULL, NULL, 198.0, 7.69, 27.33, NULL, NULL, NULL, 99, 99.0, 77.0, 80.0, NULL, NULL, NULL),
('f59b55f6-9438-4e4e-802d-7280e1941b2c', 111, 'Ryan Rickelton', 'Mumbai Indians', 'WK-Batsman', 'WK', 'BAT_WK', 'C', 62, 'OVERSEAS', 'South African', 0.5, true, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/13070/ryan-rickelton', 14.0, 388.0, 150.98, 29.85, NULL, NULL, NULL, 11.0, 79.0, 74.0, 37, NULL, NULL, NULL, NULL, NULL, NULL),
('48e976de-7a0f-4a52-b9a6-387b9d71b835', 86, 'Mayank Markande', 'Mumbai Indians', 'Bowler', 'BOWL', 'BOWL', 'C', 67, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/12627/mayank-markande', 37.0, NULL, NULL, NULL, 37.0, 8.91, 28.89, NULL, NULL, NULL, 48, 27.0, 57.0, 76.0, NULL, NULL, NULL),
('c8cdd3a0-4ed7-4da3-84cd-c37a6bcdd1c5', 127, 'Digvesh Singh Rathi', 'Lucknow Super Giants', 'Bowler', 'BOWL', 'BOWL', 'C', 61, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/1448289/digvesh-singh-rathi', 13.0, NULL, NULL, NULL, 14.0, 8.25, 30.64, NULL, NULL, NULL, 36, 12.0, 68.0, 72.0, NULL, NULL, NULL),
('49d3f73f-1b2d-4201-bead-fc363b0d479a', 133, 'Kyle Jamieson', 'Delhi Capitals', 'Bowler', 'BOWL', 'BOWL', 'C', 59, 'OVERSEAS', 'New Zealander', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/9441/kyle-jamieson', 13.0, NULL, NULL, NULL, 14.0, 9.67, 29.71, NULL, NULL, NULL, 36, 12.0, 45.0, 74.0, NULL, NULL, NULL),
('6e8dc887-5955-43a3-bd1f-827ba696abca', 3, 'Jasprit Bumrah', 'Mumbai Indians', 'Bowler', 'BOWL', 'BOWL', 'A', 99, 'INDIAN', 'Indian', 2, false, NULL, NULL, 8, 'https://www.cricbuzz.com/profiles/9311/jasprit-bumrah', 145.0, NULL, NULL, NULL, 183.0, 7.25, 22.03, NULL, NULL, NULL, 99, 99.0, 84.0, 91.0, NULL, NULL, NULL),
('043c9dad-8267-447f-8899-e150d955f1a9', 102, 'Angkrish Raghuvanshi', 'Kolkata Knight Riders', 'Batsman', 'BAT', 'BAT_WK', 'C', 65, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/22566/angkrish-raghuvanshi', 22.0, 463.0, 144.69, 28.94, NULL, NULL, NULL, 12.0, 75.0, 72.0, 41, NULL, NULL, NULL, NULL, NULL, NULL),
('4cadc5f7-9048-4f95-9fab-55ac949e7255', 15, 'Sanju Samson', 'Chennai Super Kings', 'WK-Batsman', 'WK', 'BAT_WK', 'A', 89, 'INDIAN', 'Indian', 2, false, NULL, NULL, 2, 'https://www.cricbuzz.com/profiles/8271/sanju-samson', 176.0, 4704.0, 139.05, 30.75, NULL, NULL, NULL, 89.0, 71.0, 76.0, 99, NULL, NULL, NULL, NULL, NULL, NULL),
('80c9dc71-b3f5-4679-b129-109fc3977e5b', 85, 'Mohsin Khan', 'Lucknow Super Giants', 'Bowler', 'BOWL', 'BOWL', 'C', 67, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/13534/mohsin-khan', 24.0, NULL, NULL, NULL, 27.0, 8.51, 25.52, NULL, NULL, NULL, 42, 21.0, 64.0, 83.0, NULL, NULL, NULL),
('d1e65893-89ff-4523-9214-2fed695e1d19', 122, 'Ashutosh Sharma', 'Delhi Capitals', 'Batting Allrounder', 'AR', 'AR', 'C', 61, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/13497/ashutosh-sharma', 24.0, 393.0, NULL, NULL, 0.0, NULL, NULL, NULL, NULL, NULL, 42, NULL, NULL, NULL, 56.0, 7, 14),
('b0a83476-c878-483c-85ad-c2bbffa9a786', 45, 'Shivam Dube', 'Chennai Super Kings', 'Batting Allrounder', 'AR', 'AR', 'B', 76, 'INDIAN', 'Indian', 1, false, NULL, NULL, 2, 'https://www.cricbuzz.com/profiles/11195/shivam-dube', 79.0, 1859.0, NULL, NULL, 5.0, NULL, NULL, NULL, NULL, NULL, 69, NULL, NULL, NULL, 88.0, 20.0, 20.0),
('2edfe6a1-9b15-431f-8175-5185305ca9b5', 117, 'Dewald Brevis', 'Chennai Super Kings', 'Batsman', 'BAT', 'BAT_WK', 'C', 62, 'OVERSEAS', 'South African', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/20538/dewald-brevis', 16.0, 455.0, 153.2, 28.44, NULL, NULL, NULL, 12.0, 80.0, 71.0, 38, NULL, NULL, NULL, NULL, NULL, NULL),
('cc60caae-e92d-4aa9-b9a5-0ce2769e291d', 141, 'Eshan Malinga', 'Sunrisers Hyderabad', 'Bowler', 'BOWL', 'BOWL', 'C', 58, 'OVERSEAS', 'Sri Lankan', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/46926/eshan-malinga', 7.0, NULL, NULL, NULL, 13.0, 8.93, 18.31, NULL, NULL, NULL, 33, 12.0, 57.0, 99.0, NULL, NULL, NULL),
('4fa426a6-9bcc-42a0-86c2-a0487820f09a', 82, 'Jitesh Sharma', 'Royal Challengers Bengaluru', 'WK-Batsman', 'WK', 'BAT_WK', 'C', 68, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/10214/jitesh-sharma', 55.0, 991.0, 157.06, 25.41, NULL, NULL, NULL, 22.0, 83.0, 63.0, 57, NULL, NULL, NULL, NULL, NULL, NULL),
('81a35ff7-ff4a-4d5d-b8a1-ce074675e67b', 155, 'Swapnil Singh', 'Royal Challengers Bengaluru', 'Bowling Allrounder', 'AR', 'AR', 'C', 56, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/10238/swapnil-singh', 14.0, 51.0, NULL, NULL, 7.0, NULL, NULL, NULL, NULL, NULL, 37, NULL, NULL, NULL, 23.0, 27.0, 23.0),
('1f81a263-48a6-4d02-9428-79827aa06701', 157, 'Manimaran Siddharth', 'Lucknow Super Giants', 'Bowler', 'BOWL', 'BOWL', 'C', 55, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/12930/manimaran-siddharth', 5.0, NULL, NULL, NULL, 3.0, 8.63, 46.0, NULL, NULL, NULL, 32, 5.0, 62.0, 40.0, NULL, NULL, NULL),
('37d4877b-91a9-4eb5-8846-fe3dffaee100', 53, 'Prasidh Krishna', 'Gujarat Titans', 'Bowler', 'BOWL', 'BOWL', 'B', 74, 'INDIAN', 'Indian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/10551/prasidh-krishna', 66.0, NULL, NULL, NULL, 74.0, 8.77, 29.61, NULL, NULL, NULL, 63, 51.0, 59.0, 75.0, NULL, NULL, NULL),
('9f27ce24-41ba-4173-8d86-41a7ce89813d', 125, 'Vaibhav Suryavanshi', 'Rajasthan Royals', 'Batsman', 'BAT', 'BAT_WK', 'C', 61, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/51791/vaibhav-suryavanshi', 7.0, 252.0, 206.56, 36.0, NULL, NULL, NULL, 9.0, 99.0, 89.0, 33, NULL, NULL, NULL, NULL, NULL, NULL),
('d071a89e-d4b5-4ed1-9300-659c46bce77b', 81, 'Harpreet Brar', 'Punjab Kings', 'Bowler', 'BOWL', 'BOWL', 'C', 68, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/14452/harpreet-brar', 49.0, NULL, NULL, NULL, 35.0, 8.03, 31.0, NULL, NULL, NULL, 54, 26.0, 71.0, 72.0, NULL, NULL, NULL),
('cb883425-037f-4f44-a00b-d8619afd8632', 66, 'Philip Salt', 'Royal Challengers Bengaluru', 'WK-Batsman', 'WK', 'BAT_WK', 'B', 71, 'OVERSEAS', 'English', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/10479/philip-salt', 34.0, 1056.0, 175.71, 34.06, NULL, NULL, NULL, 23.0, 95.0, 84.0, 47, NULL, NULL, NULL, NULL, NULL, NULL),
('24fa1f6e-9e82-4bc9-8528-50e5a68e1db9', 79, 'Prabhsimran Singh', 'Punjab Kings', 'WK-Batsman', 'WK', 'BAT_WK', 'C', 69, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/14254/prabhsimran-singh', 51.0, 1305.0, 151.93, 25.59, NULL, NULL, NULL, 28.0, 79.0, 64.0, 55, NULL, NULL, NULL, NULL, NULL, NULL),
('6654a878-e555-4451-a964-5cf97f12d650', 116, 'Sherfane Rutherford', 'Mumbai Indians', 'Batting Allrounder', 'AR', 'AR', 'C', 62, 'OVERSEAS', 'West Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/13748/sherfane-rutherford', 23.0, 397.0, NULL, NULL, 1.0, NULL, NULL, NULL, NULL, NULL, 41, NULL, NULL, NULL, 48.0, 17.0, 17.0),
('1de63497-8c67-4799-9e22-8f19abbeccf7', 132, 'Kuldeep Sen', 'Rajasthan Royals', 'Bowler', 'BOWL', 'BOWL', 'C', 59, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/14336/kuldeep-sen', 12.0, NULL, NULL, NULL, 14.0, 9.63, 27.64, NULL, NULL, NULL, 36, 12.0, 45.0, 79.0, NULL, NULL, NULL),
('e0e588c8-aba0-4e7c-970a-d14ab51607c2', 29, 'Mohammed Siraj', 'Gujarat Titans', 'Bowler', 'BOWL', 'BOWL', 'B', 83, 'INDIAN', 'Indian', 1, false, NULL, NULL, 2, 'https://www.cricbuzz.com/profiles/10808/mohammed-siraj', 108.0, NULL, NULL, NULL, 109.0, 8.74, 30.72, NULL, NULL, NULL, 84, 74.0, 60.0, 72.0, NULL, NULL, NULL),
('5efedc98-33b0-478b-a1ef-5361393294c4', 70, 'Venkatesh Iyer', 'Royal Challengers Bengaluru', 'Batting Allrounder', 'AR', 'AR', 'B', 70, 'INDIAN', 'Indian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/10917/venkatesh-iyer', 61.0, 1468.0, NULL, NULL, 3.0, NULL, NULL, NULL, NULL, NULL, 60, NULL, NULL, NULL, 77.0, 16.0, 16.0),
('08909ca5-deea-435e-b3bb-c5bd2b98b3e9', 56, 'Josh Hazlewood', 'Royal Challengers Bengaluru', 'Bowler', 'BOWL', 'BOWL', 'B', 73, 'OVERSEAS', 'Australian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/6258/josh-hazlewood', 39.0, NULL, NULL, NULL, 57.0, 8.28, 20.98, NULL, NULL, NULL, 49, 40.0, 67.0, 93.0, NULL, NULL, NULL),
('f2aa8cba-b6c4-42a7-92db-b4855fbfff70', 18, 'Rashid Khan', 'Gujarat Titans', 'Bowling Allrounder', 'AR', 'AR', 'A', 89, 'OVERSEAS', 'Afghan', 2, false, NULL, NULL, 8, 'https://www.cricbuzz.com/profiles/10738/rashid-khan', 136.0, 585.0, NULL, NULL, 158.0, NULL, NULL, NULL, NULL, NULL, 98, NULL, NULL, NULL, 51.0, 82.0, 51.0),
('aececfda-8138-4448-b6cf-3bdb9921ae6d', 75, 'Karun Nair', 'Delhi Capitals', 'Batsman', 'BAT', 'BAT_WK', 'B', 70, 'INDIAN', 'Indian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/8257/karun-nair', 84.0, 1694.0, 131.73, 23.86, NULL, NULL, NULL, 35.0, 66.0, 60.0, 72, NULL, NULL, NULL, NULL, NULL, NULL),
('dd11970c-fa6c-4fc1-bfda-ec836c202f56', 42, 'Ruturaj Gaikwad', 'Chennai Super Kings', 'Batsman', 'BAT', 'BAT_WK', 'B', 77, 'INDIAN', 'Indian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/11813/ruturaj-gaikwad', 71.0, 2502.0, 137.48, 40.35, NULL, NULL, NULL, 49.0, 70.0, 99.0, 65, NULL, NULL, NULL, NULL, NULL, NULL),
('dec4343b-2e13-44f4-8d79-f22f8a04cee9', 61, 'Travis Head', 'Sunrisers Hyderabad', 'Batsman', 'BAT', 'BAT_WK', 'B', 72, 'OVERSEAS', 'Australian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/8497/travis-head', 38.0, 1146.0, 170.03, 34.73, NULL, NULL, NULL, 25.0, 92.0, 86.0, 49, NULL, NULL, NULL, NULL, NULL, NULL),
('322c54e9-86c8-4d91-8a51-ee2b8202f3f4', 158, 'Arjun Tendulkar', 'Lucknow Super Giants', 'Bowling Allrounder', 'AR', 'AR', 'C', 55, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/13747/arjun-tendulkar', 5.0, 13.0, NULL, NULL, 3.0, NULL, NULL, NULL, NULL, NULL, 32, NULL, NULL, NULL, 32.0, 23.0, 23.0),
('95ffc37d-9f37-45f4-bcf0-c506d4791bb2', 23, 'Shubman Gill', 'Gujarat Titans', 'Batsman', 'BAT', 'BAT_WK', 'B', 84, 'INDIAN', 'Indian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/11808/shubman-gill', 118.0, 3866.0, 138.72, 39.45, NULL, NULL, NULL, 74.0, 70.0, 98.0, 89, NULL, NULL, NULL, NULL, NULL, NULL),
('8e0f766b-174e-4206-962d-7af8cf9743ea', 39, 'Nicholas Pooran', 'Lucknow Super Giants', 'WK-Batsman', 'WK', 'BAT_WK', 'B', 78, 'OVERSEAS', 'West Indian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/9406/nicholas-pooran', 90.0, 2293.0, 168.98, 34.22, NULL, NULL, NULL, 46.0, 91.0, 85.0, 75, NULL, NULL, NULL, NULL, NULL, NULL),
('aef22928-f034-4877-b61e-78853093be6f', 153, 'Urvil Patel', 'Chennai Super Kings', 'WK-Batsman', 'WK', 'BAT_WK', 'C', 56, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/13476/urvil-patel', 3.0, 68.0, 212.5, 22.67, NULL, NULL, NULL, 5.0, 99.0, 57.0, 31, NULL, NULL, NULL, NULL, NULL, NULL),
('c3155b1f-fc7e-45f7-93a3-07e1d76e9c4d', 76, 'Tristan Stubbs', 'Delhi Capitals', 'WK-Batsman', 'WK', 'BAT_WK', 'B', 70, 'OVERSEAS', 'South African', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/19243/tristan-stubbs', 32.0, 705.0, 163.2, 41.47, NULL, NULL, NULL, 17.0, 87.0, 99.0, 46, NULL, NULL, NULL, NULL, NULL, NULL),
('1aff7a8f-a80b-4423-a7f0-e06c888e26c7', 46, 'Avesh Khan', 'Lucknow Super Giants', 'Bowler', 'BOWL', 'BOWL', 'B', 76, 'INDIAN', 'Indian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/9781/avesh-khan', 75.0, NULL, NULL, NULL, 87.0, 9.12, 28.29, NULL, NULL, NULL, 67, 60.0, 54.0, 77.0, NULL, NULL, NULL),
('3032425e-f4a9-44aa-8f6b-610599eada8a', 135, 'Kartik Tyagi', 'Kolkata Knight Riders', 'Bowler', 'BOWL', 'BOWL', 'C', 58, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/13136/kartik-tyagi', 20.0, NULL, NULL, NULL, 15.0, 10.14, 47.53, NULL, NULL, NULL, 40, 13.0, 37.0, 37.0, NULL, NULL, NULL),
('a0a8bd0b-a24b-407a-899d-35ea1251e0d9', 88, 'Harshit Rana', 'Kolkata Knight Riders', 'Bowler', 'BOWL', 'BOWL', 'C', 67, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/24729/harshit-rana', 33.0, NULL, NULL, NULL, 40.0, 9.51, 25.73, NULL, NULL, NULL, 46, 29.0, 47.0, 83.0, NULL, NULL, NULL),
('e31e5e6d-79e3-4cd6-8841-cd53a72453f3', 54, 'Heinrich Klaasen', 'Sunrisers Hyderabad', 'WK-Batsman', 'WK', 'BAT_WK', 'B', 74, 'OVERSEAS', 'South African', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/10209/heinrich-klaasen', 49.0, 1480.0, 169.73, 40.0, NULL, NULL, NULL, 31.0, 91.0, 99.0, 54, NULL, NULL, NULL, NULL, NULL, NULL),
('05051bfb-c363-42e4-9486-320057209840', 40, 'Rahul Chahar', 'Chennai Super Kings', 'Bowler', 'BOWL', 'BOWL', 'B', 77, 'INDIAN', 'Indian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/12087/rahul-chahar', 79.0, NULL, NULL, NULL, 75.0, 7.72, 28.67, NULL, NULL, NULL, 69, 52.0, 76.0, 77.0, NULL, NULL, NULL),
('dc344d39-2f89-4323-b287-facdfd665fbd', 6, 'Rohit Sharma', 'Mumbai Indians', 'Batsman', 'BAT', 'BAT_WK', 'A', 96, 'INDIAN', 'Indian', 2, false, NULL, NULL, 8, 'https://www.cricbuzz.com/profiles/576/rohit-sharma', 272.0, 7046.0, 132.1, 29.73, NULL, NULL, NULL, 99.0, 66.0, 74.0, 99, NULL, NULL, NULL, NULL, NULL, NULL),
('8b8e5ccc-1143-4577-a6e6-456fc4e33d5e', 38, 'Shardul Thakur', 'Mumbai Indians', 'Bowling Allrounder', 'AR', 'AR', 'B', 78, 'INDIAN', 'Indian', 1, false, NULL, NULL, 6, 'https://www.cricbuzz.com/profiles/8683/shardul-thakur', 105.0, 325.0, NULL, NULL, 107.0, NULL, NULL, NULL, NULL, NULL, 82, NULL, NULL, NULL, 38.0, 59.0, 38.0),
('af2b25fe-96c0-4fba-b0bd-7cb6636f092e', 94, 'Will Jacks', 'Mumbai Indians', 'Batting Allrounder', 'AR', 'AR', 'C', 66, 'OVERSEAS', 'English', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/12258/will-jacks', 21.0, 463.0, NULL, NULL, 8.0, NULL, NULL, NULL, NULL, NULL, 40, NULL, NULL, NULL, 55.0, 28.0, 28.0),
('9204027a-f44f-4e59-b49f-6666477bf3ae', 98, 'Shivam Mavi', 'Sunrisers Hyderabad', 'Bowler', 'BOWL', 'BOWL', 'C', 66, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/12345/shivam-mavi', 32.0, NULL, NULL, NULL, 30.0, 8.71, 31.4, NULL, NULL, NULL, 46, 23.0, 60.0, 71.0, NULL, NULL, NULL),
('a70d4ca2-276e-49d4-865f-ce76bbb908b7', 156, 'Matthew Short', 'Chennai Super Kings', 'Batsman', 'BAT', 'BAT_WK', 'C', 55, 'OVERSEAS', 'Australian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/9456/matthew-short', 6.0, 117.0, 127.18, 19.5, NULL, NULL, NULL, 6.0, 63.0, 49.0, 33, NULL, NULL, NULL, NULL, NULL, NULL),
('007d3a66-2110-4473-8b72-441f5189d077', 131, 'Romario Shepherd', 'Royal Challengers Bengaluru', 'Bowling Allrounder', 'AR', 'AR', 'C', 60, 'OVERSEAS', 'West Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/13646/romario-shepherd', 18.0, 185.0, NULL, NULL, 10.0, NULL, NULL, NULL, NULL, NULL, 39, NULL, NULL, NULL, 52.0, 18.0, 18.0),
('6d160759-85ad-48c7-8ade-586de793cfac', 104, 'Lungi Ngidi', 'Delhi Capitals', 'Bowler', 'BOWL', 'BOWL', 'C', 64, 'OVERSEAS', 'South African', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/9603/lungi-ngidi', 16.0, NULL, NULL, NULL, 29.0, 8.53, 18.24, NULL, NULL, NULL, 38, 22.0, 63.0, 99.0, NULL, NULL, NULL),
('cb1decad-3b95-4661-b21d-ee10bfa2fe6c', 74, 'Devdutt Padikkal', 'Royal Challengers Bengaluru', 'Batsman', 'BAT', 'BAT_WK', 'B', 70, 'INDIAN', 'Indian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/13088/devdutt-padikkal', 74.0, 1806.0, 126.3, 25.44, NULL, NULL, NULL, 37.0, 62.0, 64.0, 67, NULL, NULL, NULL, NULL, NULL, NULL),
('38fe0871-398b-4ca9-a2f4-952d2977eddb', 26, 'Jaydev Unadkat', 'Sunrisers Hyderabad', 'Bowler', 'BOWL', 'BOWL', 'B', 83, 'INDIAN', 'Indian', 1, false, NULL, NULL, 2, 'https://www.cricbuzz.com/profiles/6327/jaydev-unadkat', 112.0, NULL, NULL, NULL, 110.0, 8.88, 30.58, NULL, NULL, NULL, 86, 74.0, 58.0, 73.0, NULL, NULL, NULL),
('9ecddd43-9728-4ea5-9525-29a4abec9705', 58, 'Riyan Parag', 'Rajasthan Royals', 'Batting Allrounder', 'AR', 'AR', 'B', 73, 'INDIAN', 'Indian', 1, false, NULL, NULL, 2, 'https://www.cricbuzz.com/profiles/12305/riyan-parag', 83.0, 1566.0, NULL, NULL, 7.0, NULL, NULL, NULL, NULL, NULL, 71, NULL, NULL, NULL, 78.0, 16.0, 16.0),
('1be5e32b-0a5e-4ff6-b7af-399400e0a3fc', 14, 'Ajinkya Rahane', 'Kolkata Knight Riders', 'Batsman', 'BAT', 'BAT_WK', 'A', 91, 'INDIAN', 'Indian', 2, false, NULL, NULL, 4, 'https://www.cricbuzz.com/profiles/1447/ajinkya-rahane', 198.0, 5032.0, 125.02, 30.5, NULL, NULL, NULL, 95.0, 61.0, 76.0, 99, NULL, NULL, NULL, NULL, NULL, NULL),
('da9439d2-d905-43d3-b64c-ea287bca6eae', 63, 'T Natarajan', 'Delhi Capitals', 'Bowler', 'BOWL', 'BOWL', 'B', 72, 'INDIAN', 'Indian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/10225/t-natarajan', 63.0, NULL, NULL, NULL, 67.0, 8.94, 30.12, NULL, NULL, NULL, 61, 47.0, 57.0, 74.0, NULL, NULL, NULL),
('32dc58f5-fde6-417c-885d-a1be652715b5', 136, 'Arshad Khan', 'Gujarat Titans', 'Bowling Allrounder', 'AR', 'AR', 'C', 58, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/18637/arshad-khan', 19.0, 124.0, NULL, NULL, 12.0, NULL, NULL, NULL, NULL, NULL, 39, NULL, NULL, NULL, 39.0, 18.0, 18.0),
('3ca69f4e-ea6f-4d76-82b7-02aad2d6145f', 112, 'Nitish Kumar Reddy', 'Sunrisers Hyderabad', 'Batting Allrounder', 'AR', 'AR', 'C', 62, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/14701/nitish-kumar-reddy', 28.0, 485.0, NULL, NULL, 5.0, NULL, NULL, NULL, NULL, NULL, 44, NULL, NULL, NULL, 50.0, 14.0, 14.0),
('d6921f93-8c88-43d7-9ae5-e9f3f2311bb2', 150, 'Adam Milne', 'Rajasthan Royals', 'Bowler', 'BOWL', 'BOWL', 'C', 56, 'OVERSEAS', 'New Zealander', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/7625/adam-milne', 10.0, NULL, NULL, NULL, 7.0, 9.48, 46.71, NULL, NULL, NULL, 35, 8.0, 48.0, 38.0, NULL, NULL, NULL),
('f746b06f-ca34-4978-9cee-e08d6340152f', 7, 'Ravindra Jadeja', 'Rajasthan Royals', 'Bowling Allrounder', 'AR', 'AR', 'A', 95, 'INDIAN', 'Indian', 2, false, NULL, NULL, 8, 'https://www.cricbuzz.com/profiles/587/ravindra-jadeja', 254.0, 3260.0, NULL, NULL, 170.0, NULL, NULL, NULL, NULL, NULL, 99, NULL, NULL, NULL, 85.0, 78.0, 78.0),
('2b29c17c-2268-4291-8214-2330a04bfb7f', 101, 'Umran Malik', 'Kolkata Knight Riders', 'Bowler', 'BOWL', 'BOWL', 'C', 65, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/19027/umran-malik', 26.0, NULL, NULL, NULL, 29.0, 9.4, 26.62, NULL, NULL, NULL, 43, 22.0, 49.0, 81.0, NULL, NULL, NULL),
('12797e1f-74a2-479c-8413-30d9a80e1449', 43, 'Abhishek Sharma', 'Sunrisers Hyderabad', 'Batting Allrounder', 'AR', 'AR', 'B', 77, 'INDIAN', 'Indian', 1, false, NULL, NULL, 2, 'https://www.cricbuzz.com/profiles/12086/abhishek-sharma', 77.0, 1815.0, NULL, NULL, 11.0, NULL, NULL, NULL, NULL, NULL, 68, NULL, NULL, NULL, 90.0, 24.0, 24.0),
('404485b1-1476-489a-a049-174212a1cf13', 123, 'Ayush Mhatre', 'Chennai Super Kings', 'Batsman', 'BAT', 'BAT_WK', 'C', 61, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/1431163/ayush-mhatre', 7.0, 240.0, 188.98, 34.29, NULL, NULL, NULL, 8.0, 99.0, 85.0, 33, NULL, NULL, NULL, NULL, NULL, NULL),
('da47fcc2-c46e-44ed-adc4-7de875380054', 128, 'Yash Thakur', 'Punjab Kings', 'Bowler', 'BOWL', 'BOWL', 'C', 61, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/12096/yash-thakur', 21.0, NULL, NULL, NULL, 25.0, 10.43, 30.8, NULL, NULL, NULL, 40, 20.0, 32.0, 72.0, NULL, NULL, NULL),
('2a99d241-4ba9-44d6-85d0-bbdd486d3e49', 108, 'Rovman Powell', 'Kolkata Knight Riders', 'Batsman', 'BAT', 'BAT_WK', 'C', 63, 'OVERSEAS', 'West Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/11445/rovman-powell', 28.0, 365.0, 146.59, 18.25, NULL, NULL, NULL, 11.0, 76.0, 46.0, 44, NULL, NULL, NULL, NULL, NULL, NULL),
('d4b2247e-9f4f-4842-9a39-46c52c95ea17', 51, 'Sam Curran', 'Rajasthan Royals', 'Bowling Allrounder', 'AR', 'AR', 'B', 74, 'OVERSEAS', 'English', 1, false, NULL, NULL, 2, 'https://www.cricbuzz.com/profiles/10420/sam-curran', 64.0, 997.0, NULL, NULL, 59.0, NULL, NULL, NULL, NULL, NULL, 62, NULL, NULL, NULL, 62.0, 41.0, 41.0),
('49ffa457-363a-4fa2-ac22-e7d0ca953225', 30, 'Rishabh Pant', 'Lucknow Super Giants', 'WK-Batsman', 'WK', 'BAT_WK', 'B', 82, 'INDIAN', 'Indian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/10744/rishabh-pant', 125.0, 3553.0, 147.62, 34.16, NULL, NULL, NULL, 68.0, 76.0, 85.0, 92, NULL, NULL, NULL, NULL, NULL, NULL),
('c085171d-3d8f-455b-8567-d92cee9ee0d4', 11, 'Sandeep Sharma', 'Rajasthan Royals', 'Bowler', 'BOWL', 'BOWL', 'A', 93, 'INDIAN', 'Indian', 2, false, NULL, NULL, 4, 'https://www.cricbuzz.com/profiles/8356/sandeep-sharma', 136.0, NULL, NULL, NULL, 146.0, 8.03, 27.88, NULL, NULL, NULL, 98, 98.0, 71.0, 78.0, NULL, NULL, NULL),
('611a7026-1b41-4550-967e-73e9d3affdac', 100, 'Abishek Porel', 'Delhi Capitals', 'WK-Batsman', 'WK', 'BAT_WK', 'C', 66, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/24326/abishek-porel', 31.0, 661.0, 149.89, 25.42, NULL, NULL, NULL, 16.0, 78.0, 63.0, 45, NULL, NULL, NULL, NULL, NULL, NULL),
('d3688673-c348-42c6-93e2-b8efedaa84b4', 60, 'Noor Ahmad', 'Chennai Super Kings', 'Bowler', 'BOWL', 'BOWL', 'B', 72, 'OVERSEAS', 'Afghan', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/15452/noor-ahmad', 37.0, NULL, NULL, NULL, 48.0, 8.08, 22.23, NULL, NULL, NULL, 48, 34.0, 71.0, 90.0, NULL, NULL, NULL),
('44860f03-4aa8-416a-9629-5c350d1e275e', 154, 'Nuwan Thushara', 'Royal Challengers Bengaluru', 'Bowler', 'BOWL', 'BOWL', 'C', 56, 'OVERSEAS', 'Sri Lankan', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/18509/nuwan-thushara', 8.0, NULL, NULL, NULL, 9.0, 9.43, 31.44, NULL, NULL, NULL, 34, 9.0, 49.0, 71.0, NULL, NULL, NULL),
('81cab4b4-8c4e-488b-ba22-0d113cda76be', 97, 'Ramandeep Singh', 'Kolkata Knight Riders', 'Batting Allrounder', 'AR', 'AR', 'C', 66, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/12337/ramandeep-singh', 30.0, 217.0, NULL, NULL, 6.0, NULL, NULL, NULL, NULL, NULL, 45, NULL, NULL, NULL, 46.0, 35.0, 35.0),
('e113175f-c3fc-430c-b09d-f03e08c4c51f', 72, 'Aiden Markram', 'Lucknow Super Giants', 'Batsman', 'BAT', 'BAT_WK', 'B', 70, 'OVERSEAS', 'South African', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/9582/aiden-markram', 57.0, 1440.0, 135.09, 31.3, NULL, NULL, NULL, 30.0, 68.0, 78.0, 58, NULL, NULL, NULL, NULL, NULL, NULL),
('9be6c489-ed18-4cf7-b40e-a0185c8edb8c', 64, 'Shreyas Gopal', 'Chennai Super Kings', 'Bowler', 'BOWL', 'BOWL', 'B', 72, 'INDIAN', 'Indian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/9746/shreyas-gopal', 52.0, NULL, NULL, NULL, 52.0, 8.16, 25.92, NULL, NULL, NULL, 56, 37.0, 69.0, 83.0, NULL, NULL, NULL),
('f690d2ad-b3da-4979-985d-d719494aebe8', 19, 'Hardik Pandya', 'Mumbai Indians', 'Batting Allrounder', 'AR', 'AR', 'A', 89, 'INDIAN', 'Indian', 2, false, NULL, NULL, 6, 'https://www.cricbuzz.com/profiles/9647/hardik-pandya', 152.0, 2749.0, NULL, NULL, 78.0, NULL, NULL, NULL, NULL, NULL, 99, NULL, NULL, NULL, 90.0, 50.0, 50.0),
('4f045fab-4bd9-4c8f-a31f-130c8d5f03c8', 109, 'Abdul Samad', 'Lucknow Super Giants', 'Batting Allrounder', 'AR', 'AR', 'C', 63, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/14628/abdul-samad', 63.0, 741.0, NULL, NULL, 2.0, NULL, NULL, NULL, NULL, NULL, 61, NULL, NULL, NULL, 57.0, 5.0, 5.0),
('cb1e7613-d0d1-4540-a7c1-0c510ccd5a97', 114, 'Mitchell Santner', 'Mumbai Indians', 'Bowling Allrounder', 'AR', 'AR', 'C', 62, 'OVERSEAS', 'New Zealander', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/10100/mitchell-santner', 31.0, 110.0, NULL, NULL, 25.0, NULL, NULL, NULL, NULL, NULL, 45, NULL, NULL, NULL, 25.0, 40.0, 25.0),
('5f24e8de-4de7-4b30-af46-97bb3dd8e6d7', 89, 'Dhruv Jurel', 'Rajasthan Royals', 'WK-Batsman', 'WK', 'BAT_WK', 'C', 67, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/14691/dhruv-jurel', 41.0, 680.0, 153.85, 28.33, NULL, NULL, NULL, 16.0, 81.0, 71.0, 50, NULL, NULL, NULL, NULL, NULL, NULL),
('d4a7b7ac-6d12-43c2-8a47-98aed445ac5d', 50, 'Mitchell Marsh', 'Lucknow Super Giants', 'Batting Allrounder', 'AR', 'AR', 'B', 74, 'OVERSEAS', 'Australian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/6250/mitchell-marsh', 55.0, 1292.0, NULL, NULL, 37.0, NULL, NULL, NULL, NULL, NULL, 57, NULL, NULL, NULL, 72.0, 43.0, 43.0),
('a682b894-132a-44cf-9dfd-11d29438cea3', 103, 'Priyansh Arya', 'Punjab Kings', 'Batsman', 'BAT', 'BAT_WK', 'C', 64, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/14689/priyansh-arya', 17.0, 475.0, 179.25, 27.94, NULL, NULL, NULL, 13.0, 98.0, 70.0, 38, NULL, NULL, NULL, NULL, NULL, NULL),
('d2d1eb8c-4b48-4e0d-97b1-d3a94cc3b196', 17, 'Mohammed Shami', 'Lucknow Super Giants', 'Bowler', 'BOWL', 'BOWL', 'A', 89, 'INDIAN', 'Indian', 2, false, NULL, NULL, 4, 'https://www.cricbuzz.com/profiles/7909/mohammed-shami', 119.0, NULL, NULL, NULL, 133.0, 8.63, 28.18, NULL, NULL, NULL, 89, 89.0, 62.0, 78.0, NULL, NULL, NULL),
('87d722d8-e25c-4ad9-910d-aede913308ae', 68, 'Anrich Nortje', 'Lucknow Super Giants', 'Bowler', 'BOWL', 'BOWL', 'B', 71, 'OVERSEAS', 'South African', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/11427/anrich-nortje', 48.0, NULL, NULL, NULL, 61.0, 9.07, 27.16, NULL, NULL, NULL, 54, 43.0, 55.0, 80.0, NULL, NULL, NULL),
('c7cfc3e8-adaf-45fd-980c-fea464a4f3f1', 31, 'Manish Pandey', 'Kolkata Knight Riders', 'Batsman', 'BAT', 'BAT_WK', 'B', 82, 'INDIAN', 'Indian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/1836/manish-pandey', 174.0, 3942.0, 121.52, 29.42, NULL, NULL, NULL, 76.0, 59.0, 73.0, 99, NULL, NULL, NULL, NULL, NULL, NULL),
('22cd39dc-c3ad-48c7-9c9e-25864c7b06fd', 120, 'Ravisrinivasan Sai Kishore', 'Gujarat Titans', 'Bowling Allrounder', 'AR', 'AR', 'C', 61, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/11595/ravisrinivasan-sai-kishore', 25.0, 18.0, NULL, NULL, 32.0, NULL, NULL, NULL, NULL, NULL, 42, NULL, NULL, NULL, 19.0, 41.0, 19.0),
('5080f6b6-5a9c-49a0-aa52-d549f271171c', 65, 'Tilak Varma', 'Mumbai Indians', 'Batsman', 'BAT', 'BAT_WK', 'B', 72, 'INDIAN', 'Indian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/14504/tilak-varma', 54.0, 1499.0, 144.42, 37.48, NULL, NULL, NULL, 31.0, 74.0, 93.0, 57, NULL, NULL, NULL, NULL, NULL, NULL),
('6118f1db-ea5d-4c65-b991-93a3bb348ea8', 62, 'Shimron Hetmyer', 'Rajasthan Royals', 'Batsman', 'BAT', 'BAT_WK', 'B', 72, 'OVERSEAS', 'West Indian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/9789/shimron-hetmyer', 86.0, 1482.0, 151.85, 29.06, NULL, NULL, NULL, 31.0, 79.0, 72.0, 73, NULL, NULL, NULL, NULL, NULL, NULL),
('fedb9eaa-abfc-4222-9c59-89029424db6c', 96, 'Vaibhav Arora', 'Kolkata Knight Riders', 'Bowler', 'BOWL', 'BOWL', 'C', 66, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/15861/vaibhav-arora', 32.0, NULL, NULL, NULL, 36.0, 9.55, 28.22, NULL, NULL, NULL, 46, 27.0, 47.0, 78.0, NULL, NULL, NULL),
('db8003f7-1554-4bd2-83ed-e8e09f126956', 36, 'Arshdeep Singh', 'Punjab Kings', 'Bowler', 'BOWL', 'BOWL', 'B', 78, 'INDIAN', 'Indian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/13217/arshdeep-singh', 82.0, NULL, NULL, NULL, 97.0, 9.0, 26.49, NULL, NULL, NULL, 71, 66.0, 56.0, 81.0, NULL, NULL, NULL),
('910d594b-a1b4-4b1f-bf86-e77d299850ca', 84, 'Cameron Green', 'Kolkata Knight Riders', 'Batting Allrounder', 'AR', 'AR', 'C', 68, 'OVERSEAS', 'Australian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/12225/cameron-green', 29.0, 707.0, NULL, NULL, 16.0, NULL, NULL, NULL, NULL, NULL, 44, NULL, NULL, NULL, 64.0, 27.0, 27.0),
('8b372358-4278-4906-a242-974248901c32', 13, 'Axar Patel', 'Delhi Capitals', 'Bowling Allrounder', 'AR', 'AR', 'A', 91, 'INDIAN', 'Indian', 2, false, NULL, NULL, 6, 'https://www.cricbuzz.com/profiles/8808/axar-patel', 162.0, 1916.0, NULL, NULL, 128.0, NULL, NULL, NULL, NULL, NULL, 99, NULL, NULL, NULL, 82.0, 72.0, 72.0),
('ba9cb518-a529-4c43-aa50-a29b76797bac', 49, 'Ravi Bishnoi', 'Rajasthan Royals', 'Bowler', 'BOWL', 'BOWL', 'B', 75, 'INDIAN', 'Indian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/14659/ravi-bishnoi', 77.0, NULL, NULL, NULL, 72.0, 8.22, 31.07, NULL, NULL, NULL, 68, 50.0, 68.0, 72.0, NULL, NULL, NULL),
('4781e2ba-523d-43a7-ab30-94b040c1f70d', 20, 'Jos Buttler', 'Gujarat Titans', 'WK-Batsman', 'WK', 'BAT_WK', 'A', 88, 'OVERSEAS', 'English', 2, false, NULL, NULL, 2, 'https://www.cricbuzz.com/profiles/2258/jos-buttler', 121.0, 4120.0, 149.39, 40.0, NULL, NULL, NULL, 79.0, 78.0, 99.0, 90, NULL, NULL, NULL, NULL, NULL, NULL),
('4d91531e-f797-4e72-8d50-3154aba3c727', 134, 'Vipraj Nigam', 'Delhi Capitals', 'Bowler', 'BOWL', 'BOWL', 'C', 59, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/1431811/vipraj-nigam', 14.0, NULL, NULL, NULL, 11.0, 9.13, 32.36, NULL, NULL, NULL, 37, 10.0, 54.0, 69.0, NULL, NULL, NULL),
('be42eee4-c5e4-4875-af52-3faff00c6485', 4, 'Sunil Narine', 'Kolkata Knight Riders', 'Bowling Allrounder', 'AR', 'AR', 'A', 98, 'OVERSEAS', 'West Indian', 2, false, NULL, NULL, 10, 'https://www.cricbuzz.com/profiles/2276/sunil-narine', 188.0, 1780.0, NULL, NULL, 192.0, NULL, NULL, NULL, NULL, NULL, 99, NULL, NULL, NULL, 84.0, 83.0, 83.0),
('260e7292-f34a-4134-b6ef-1eedf3839f57', 115, 'Rachin Ravindra', 'Kolkata Knight Riders', 'Batting Allrounder', 'AR', 'AR', 'C', 62, 'OVERSEAS', 'New Zealander', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/11177/rachin-ravindra', 18.0, 413.0, NULL, NULL, 0.0, NULL, NULL, NULL, NULL, NULL, 39, NULL, NULL, NULL, 49.0, 29.0, 29.0),
('685927fe-2848-4045-839f-d555de868f2b', 124, 'Shubham Dubey', 'Rajasthan Royals', 'Batsman', 'BAT', 'BAT_WK', 'C', 61, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/19328/shubham-dubey', 13.0, 139.0, 163.53, 23.17, NULL, NULL, NULL, 6.0, 87.0, 58.0, 36, NULL, NULL, NULL, NULL, NULL, NULL),
('7dda3d38-8c44-499a-b994-bfd028a06a94', 1, 'Virat Kohli', 'Royal Challengers Bengaluru', 'Batsman', 'BAT', 'BAT_WK', 'A', 99, 'INDIAN', 'Indian', 2, false, NULL, NULL, 10, 'https://www.cricbuzz.com/profiles/1413/virat-kohli', 267.0, 8661.0, 132.86, 39.55, NULL, NULL, NULL, 99.0, 67.0, 98.0, 99, NULL, NULL, NULL, NULL, NULL, NULL),
('6fdd35bb-e775-41b9-84d0-a48ae58492b0', 77, 'Rinku Singh', 'Kolkata Knight Riders', 'Batsman', 'BAT', 'BAT_WK', 'C', 69, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/10896/rinku-singh', 58.0, 1099.0, 145.18, 30.53, NULL, NULL, NULL, 24.0, 75.0, 76.0, 59, NULL, NULL, NULL, NULL, NULL, NULL),
('ea49ef18-6ff5-46bb-8129-3c7ca3cbc4be', 159, 'Rasikh Dar Salam', 'Royal Challengers Bengaluru', 'Bowler', 'BOWL', 'BOWL', 'C', 55, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/14274/rasikh-dar-salam', 13.0, NULL, NULL, NULL, 10.0, 10.62, 40.9, NULL, NULL, NULL, 36, 10.0, 29.0, 51.0, NULL, NULL, NULL),
('91561bb8-cc43-4802-8526-fa508cce4921', 10, 'Harshal Patel', 'Sunrisers Hyderabad', 'Bowler', 'BOWL', 'BOWL', 'A', 94, 'INDIAN', 'Indian', 2, false, NULL, NULL, 6, 'https://www.cricbuzz.com/profiles/8175/harshal-patel', 119.0, NULL, NULL, NULL, 151.0, 8.86, 23.7, NULL, NULL, NULL, 89, 99.0, 58.0, 87.0, NULL, NULL, NULL),
('0eb58610-a866-4f4f-ab70-5917baaa9049', 59, 'Rahul Tewatia', 'Gujarat Titans', 'Batting Allrounder', 'AR', 'AR', 'B', 73, 'INDIAN', 'Indian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/9693/rahul-tewatia', 108.0, 1112.0, NULL, NULL, 32.0, NULL, NULL, NULL, NULL, NULL, 84, NULL, NULL, NULL, 64.0, 38.0, 38.0),
('0a49f588-a21c-4994-8f05-e9f47a0edc66', 21, 'Krunal Pandya', 'Royal Challengers Bengaluru', 'Batting Allrounder', 'AR', 'AR', 'A', 86, 'INDIAN', 'Indian', 2, false, NULL, NULL, 4, 'https://www.cricbuzz.com/profiles/11311/krunal-pandya', 142.0, 1748.0, NULL, NULL, 93.0, NULL, NULL, NULL, NULL, NULL, 99, NULL, NULL, NULL, 77.0, 60.0, 60.0),
('b5d01b5b-1009-47fa-9b38-1c4affc2bb57', 48, 'Pat Cummins', 'Sunrisers Hyderabad', 'Bowler', 'BOWL', 'BOWL', 'B', 75, 'OVERSEAS', 'Australian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/8095/pat-cummins', 72.0, NULL, NULL, NULL, 79.0, 8.81, 30.04, NULL, NULL, NULL, 66, 54.0, 59.0, 74.0, NULL, NULL, NULL),
('b8fae5c5-f22a-42e0-888e-860a5fcc4a94', 52, 'Rahul Tripathi', 'Kolkata Knight Riders', 'Batsman', 'BAT', 'BAT_WK', 'B', 74, 'INDIAN', 'Indian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/9012/rahul-tripathi', 100.0, 2291.0, 137.85, 26.03, NULL, NULL, NULL, 46.0, 70.0, 65.0, 80, NULL, NULL, NULL, NULL, NULL, NULL),
('98ced8a8-b7b8-45ab-9c68-d74d8070cade', 151, 'Dushmantha Chameera', 'Delhi Capitals', 'Bowler', 'BOWL', 'BOWL', 'C', 56, 'OVERSEAS', 'Sri Lankan', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/8393/dushmantha-chameera', 19.0, NULL, NULL, NULL, 13.0, 9.73, 46.38, NULL, NULL, NULL, 39, 12.0, 44.0, 39.0, NULL, NULL, NULL),
('47082fbd-7769-4b74-bcff-db08110ae02c', 147, 'Mayank Yadav', 'Lucknow Super Giants', 'Bowler', 'BOWL', 'BOWL', 'C', 57, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/22401/mayank-yadav', 6.0, NULL, NULL, NULL, 9.0, 9.17, 20.56, NULL, NULL, NULL, 33, 9.0, 53.0, 94.0, NULL, NULL, NULL),
('56b02b7a-a249-432f-adbf-22bf06cda84d', 138, 'Azmatullah Omarzai', 'Punjab Kings', 'Bowling Allrounder', 'AR', 'AR', 'C', 58, 'OVERSEAS', 'Afghan', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/13214/azmatullah-omarzai', 16.0, 99.0, NULL, NULL, 12.0, NULL, NULL, NULL, NULL, NULL, 38, NULL, NULL, NULL, 31.0, 25.0, 25.0),
('f6d71580-c693-49cc-9d13-a1d8434688a9', 16, 'Suryakumar Yadav', 'Mumbai Indians', 'Batsman', 'BAT', 'BAT_WK', 'A', 89, 'INDIAN', 'Indian', 2, false, NULL, NULL, 2, 'https://www.cricbuzz.com/profiles/7915/suryakumar-yadav', 166.0, 4311.0, 148.66, 35.05, NULL, NULL, NULL, 82.0, 77.0, 87.0, 99, NULL, NULL, NULL, NULL, NULL, NULL),
('37a0439c-887f-4f72-a78f-d4c188d07fcc', 47, 'Yashasvi Jaiswal', 'Rajasthan Royals', 'Batsman', 'BAT', 'BAT_WK', 'B', 75, 'INDIAN', 'Indian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/13940/yashasvi-jaiswal', 66.0, 2166.0, 152.86, 34.38, NULL, NULL, NULL, 43.0, 80.0, 85.0, 63, NULL, NULL, NULL, NULL, NULL, NULL),
('551c7f29-2128-4640-aab6-46443ad58992', 12, 'Trent Boult', 'Mumbai Indians', 'Bowler', 'BOWL', 'BOWL', 'A', 92, 'OVERSEAS', 'New Zealander', 2, false, NULL, NULL, 4, 'https://www.cricbuzz.com/profiles/8117/trent-boult', 119.0, NULL, NULL, NULL, 143.0, 8.38, 26.2, NULL, NULL, NULL, 89, 96.0, 66.0, 82.0, NULL, NULL, NULL),
('59ee0d7f-5596-4a87-80e7-110175f7b2cd', 71, 'Matheesha Pathirana', 'Kolkata Knight Riders', 'Bowler', 'BOWL', 'BOWL', 'B', 70, 'OVERSEAS', 'Sri Lankan', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/16458/matheesha-pathirana', 32.0, NULL, NULL, NULL, 47.0, 8.68, 21.62, NULL, NULL, NULL, 46, 34.0, 61.0, 92.0, NULL, NULL, NULL),
('3deb2bf2-50e0-4695-ba6a-1db69191f388', 73, 'Tim David', 'Royal Challengers Bengaluru', 'Batsman', 'BAT', 'BAT_WK', 'B', 70, 'OVERSEAS', 'Singaporean', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/13169/tim-david', 50.0, 846.0, 173.37, 32.54, NULL, NULL, NULL, 19.0, 94.0, 81.0, 55, NULL, NULL, NULL, NULL, NULL, NULL),
('ddde6f23-51d6-44e1-adfe-f648aa1ff4b3', 146, 'Anshul Kamboj', 'Chennai Super Kings', 'Bowling Allrounder', 'AR', 'AR', 'C', 57, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/14598/anshul-kamboj', 11.0, 16.0, NULL, NULL, 10.0, NULL, NULL, NULL, NULL, NULL, 35, NULL, NULL, NULL, 21.0, 30.0, 21.0),
('8945ccef-7481-43f9-aa4f-b1f484719060', 91, 'Shahrukh Khan', 'Gujarat Titans', 'Batting Allrounder', 'AR', 'AR', 'C', 67, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/10226/shahrukh-khan', 55.0, 732.0, NULL, NULL, 1.0, NULL, NULL, NULL, NULL, NULL, 57, NULL, NULL, NULL, 56.0, 27.0, 27.0),
('862cb871-5562-4de0-8d08-8a6699241044', 41, 'Nitish Rana', 'Delhi Capitals', 'Batsman', 'BAT', 'BAT_WK', 'B', 77, 'INDIAN', 'Indian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/9204/nitish-rana', 118.0, 2853.0, 136.77, 27.7, NULL, NULL, NULL, 56.0, 69.0, 69.0, 89, NULL, NULL, NULL, NULL, NULL, NULL),
('5b591717-76c1-407b-a6e2-60e6ba5ecf92', 22, 'Kagiso Rabada', 'Gujarat Titans', 'Bowler', 'BOWL', 'BOWL', 'A', 85, 'OVERSEAS', 'South African', 2, false, NULL, NULL, 2, 'https://www.cricbuzz.com/profiles/9585/kagiso-rabada', 84.0, NULL, NULL, NULL, 119.0, 8.62, 22.96, NULL, NULL, NULL, 72, 80.0, 62.0, 89.0, NULL, NULL, NULL);

INSERT INTO "AuctionPlayer" (id, player_id, status) VALUES
('a4793501-28d4-4624-8eed-1e3a307bb19f', '548faaaf-a06e-4d97-8232-7608b9269cbf', 'UNSOLD'),
('17838a20-475f-4f12-a791-7f1330fc6762', '84c51892-3ff7-42b9-8240-5ae2b092c102', 'UNSOLD'),
('172be507-3580-4962-b2ca-0564215ffafc', 'cae60e59-0588-4fa2-97b8-c1b5420c96c5', 'UNSOLD'),
('4441c9ea-9ac6-4027-b072-4d2746efca0d', '0421a913-592c-4d9d-94dd-4e4a8c8e6f35', 'UNSOLD'),
('71ed2f4b-500e-493a-abef-b8d427eccf68', 'd6b103f8-5a80-421a-b27e-606c800ef9b5', 'UNSOLD'),
('f84d12c6-a801-492f-8309-f4aa6565c5ed', '62aeb2d3-b3ce-465b-8f4e-3298f55379e7', 'UNSOLD'),
('b3cc79af-5a89-4fb6-93de-2e58d0cf8eaf', 'e48a8d08-b42a-4427-b4f0-a97f13b9f148', 'UNSOLD'),
('716d6fe2-ba1e-48cb-88b7-47a31b852013', 'bb8790b6-1c6d-4671-b04d-4c41a1f0d1b4', 'UNSOLD'),
('a528eb04-13d4-4779-9e9d-71932a3f8b76', '9dbc518d-9b26-47c1-a197-1608f9df0c77', 'UNSOLD'),
('4bcec421-8390-434f-8978-45decd2b4019', '6c9f1808-f9b6-4227-af66-ece7f000797d', 'UNSOLD'),
('008898a2-fb50-43eb-89ad-0a1734004d02', 'ca28696f-cb0e-45fd-83f7-751755299ca6', 'UNSOLD'),
('1ea37a66-e8e9-4612-87e4-f7294682301f', 'bac09b04-443b-4cfb-95d6-e78c1455582c', 'UNSOLD'),
('9476897c-a9a0-46cc-91cb-b718d196a9bb', '6e7228cf-87fa-4435-8274-5c29a90b24d7', 'UNSOLD'),
('1c932965-a944-498c-a7b1-ef9f5e95f0f7', '24950e2e-df00-46bb-b093-461f8629bf74', 'UNSOLD'),
('69f4ccff-eb26-4cc6-9265-9fefb4a0465d', '5e6daa01-9630-495a-b1a7-30c5b5b121c1', 'UNSOLD'),
('d12ca9a1-4ecb-4316-8c9e-5655259611af', '8a57919f-ce98-4954-83b4-9d74d788574f', 'UNSOLD'),
('2e4d0dbb-c5ba-486f-bb7b-dbf39f5a5c4b', '5c400197-7c13-4a0c-b5d8-6a4f9aaba6ce', 'UNSOLD'),
('b3c5700b-4af2-4e60-878d-db642830ca2b', '75dc351c-46fc-4649-bcf4-2eb5baa37c43', 'UNSOLD'),
('d964d2ca-96f0-48c9-8255-9643896034ff', 'deb2a097-a4d9-4a78-9dee-48be4e658f77', 'UNSOLD'),
('e48620fc-5b17-434c-b825-74517153a329', '0f03c0f6-d3eb-40f4-9f32-5ff47ae536ab', 'UNSOLD'),
('a39c8bc0-3c03-400f-a34a-ec0319b484bd', '23a6fe90-586f-46d2-9501-537afc1d14e8', 'UNSOLD'),
('0416ce56-d042-4b5c-9b51-2093f7b4b99d', '852bc0ff-ecd5-49af-872f-7dc8ad69dd76', 'UNSOLD'),
('4d978e42-d8be-4303-95be-2d9aa554ca57', '46bc75d2-62e8-4678-bce0-c0ee4650c9d8', 'UNSOLD'),
('5c2d723e-9e6e-4f3d-9e92-f86146f3808a', '72bc6c8c-1bae-454e-93f3-08af9093e80c', 'UNSOLD'),
('fa70b19a-5c3d-4193-919a-72c6586f3111', '5d388507-923d-4449-b857-6ea7e5532f4d', 'UNSOLD'),
('8daf99b7-00ea-4920-be82-47a5cea935a7', 'aeb9aa8b-d991-43b8-86e2-2d8467a6abc1', 'UNSOLD'),
('29d76196-5143-4dd1-abf4-a0f2a65a8e4e', '26b5d6b7-9d8e-4650-86e0-1864fa619380', 'UNSOLD'),
('e141c2a7-3be8-45a2-bdae-dfd581f94302', '866799e4-b2f3-4743-ae02-6ede10f320f6', 'UNSOLD'),
('c2095c4e-15db-4bc4-9553-fe2933955a5c', '895d57e0-c6e0-4b25-b7ac-2bfb5b591023', 'UNSOLD'),
('66cf5680-0adc-4d65-93e5-579031334a31', '66538494-f0fd-4fb2-88d4-2e35740659b6', 'UNSOLD'),
('281caaa9-be51-45fb-ac02-a1f7c091c587', '3e360ee7-148d-40cd-b747-5fbba7af2609', 'UNSOLD'),
('07a70850-5cbe-4957-805d-a6930a49df00', '67d6a937-c44f-4ec9-9956-15f6a2aaff27', 'UNSOLD'),
('93be70f0-30eb-41e1-9e86-f9460dc5c06e', '3ee06803-0884-46d1-8abf-142f755d0e2c', 'UNSOLD'),
('9908f4f6-fadf-476f-a8d8-0291ef46094e', '09d26803-17d8-4f1b-96ac-07c3ec3284a2', 'UNSOLD'),
('88ae8be5-6579-41c0-94c1-0d049c919200', '9c7aa329-91a3-48a4-bbe6-784ddffa825d', 'UNSOLD'),
('52000f9e-ce0b-4ea4-8bdc-8d6952815469', '7d6f5eea-ebd8-44a3-abb0-b5a55f45b18f', 'UNSOLD'),
('3e2e998f-4334-4873-8f66-f053b7a6830d', 'd1ef9f33-6f4c-4465-ad12-8ac82873fcbc', 'UNSOLD'),
('b0b04358-5d9d-4ce4-a4dc-7732afcf75e0', 'f4fbeac5-5e26-41c9-900a-c46aba53ed32', 'UNSOLD'),
('88f856c3-287b-467c-963e-af2e366c9c1c', '738192aa-b2a5-42d9-95ad-63e5b7de49ff', 'UNSOLD'),
('45d2ecc0-9893-4a8c-9afe-746c5c578946', 'e33c1bcc-2841-48d2-b265-c65692cd97a9', 'UNSOLD'),
('7b4d2f45-686f-416a-a584-beed87333e2d', 'adc87e8e-c3f4-4eb2-b72c-84c78e9fa89c', 'UNSOLD'),
('480aeb3d-2384-43d8-89f6-3a9f4aecdbc2', '66cc8bb8-c2a6-47ec-a67f-68e866d3323a', 'UNSOLD'),
('9e634da6-b30b-42fe-9697-f039d6a62ae3', '986611d0-69c3-4041-a3d7-63f8bf4f32ce', 'UNSOLD'),
('e69ce6d2-f691-4c54-83bc-c65c6a99deec', '56d6576b-ce76-4ada-a774-7902083759c2', 'UNSOLD'),
('53269485-91e0-49b5-a8be-33b7776ac242', '8c56b21d-954f-45da-8907-9f3aad9a5838', 'UNSOLD'),
('b4c79e2a-03b9-4c5f-8744-712909dbf9cc', 'a4a7ec8c-dea6-43fc-aa00-86b794185e46', 'UNSOLD'),
('69f4055a-0757-4f44-a526-36253c0efe3d', '5698b972-8319-4537-abac-75b5a394fcd9', 'UNSOLD'),
('483b55c4-2c44-4e60-83dc-e41ea58fa098', 'f9fb85eb-3143-4197-ac12-a40cf9b4c009', 'UNSOLD'),
('b2e1761b-acf1-46b2-97e9-135b25f76b11', 'f59b55f6-9438-4e4e-802d-7280e1941b2c', 'UNSOLD'),
('72888c8c-8a73-498c-bbe5-b1a401189e12', '48e976de-7a0f-4a52-b9a6-387b9d71b835', 'UNSOLD'),
('82783690-877d-4a7b-b118-13be52c872d1', 'c8cdd3a0-4ed7-4da3-84cd-c37a6bcdd1c5', 'UNSOLD'),
('365da1a4-8f1d-41bf-9b2a-3fe8928f137c', '49d3f73f-1b2d-4201-bead-fc363b0d479a', 'UNSOLD'),
('93b3d27a-1926-48aa-8561-4645ed3d8b69', '6e8dc887-5955-43a3-bd1f-827ba696abca', 'UNSOLD'),
('259798da-28b1-4e27-9d6a-a7d21a3b2425', '043c9dad-8267-447f-8899-e150d955f1a9', 'UNSOLD'),
('3988d303-c58e-4981-bd73-962b3e737a06', '4cadc5f7-9048-4f95-9fab-55ac949e7255', 'UNSOLD'),
('50fd3309-46c9-41c3-af0e-e0f8eb22ddfa', '80c9dc71-b3f5-4679-b129-109fc3977e5b', 'UNSOLD'),
('d192a28e-b708-495d-b45f-5037aee3e08a', 'd1e65893-89ff-4523-9214-2fed695e1d19', 'UNSOLD'),
('0c9ddcee-8892-409b-a1a1-fd318217c3bb', 'b0a83476-c878-483c-85ad-c2bbffa9a786', 'UNSOLD'),
('947a2ce2-be8d-4452-9869-74478ad8bc00', '2edfe6a1-9b15-431f-8175-5185305ca9b5', 'UNSOLD'),
('0000c25c-256e-4b56-9422-1bb5b5ad1593', 'cc60caae-e92d-4aa9-b9a5-0ce2769e291d', 'UNSOLD'),
('99b7743d-a921-4194-a684-dc9c390781ca', '4fa426a6-9bcc-42a0-86c2-a0487820f09a', 'UNSOLD'),
('261267dc-0624-4282-9113-873ae0247014', '81a35ff7-ff4a-4d5d-b8a1-ce074675e67b', 'UNSOLD'),
('14b647a7-c3bb-4d65-8564-a441eddda18c', '1f81a263-48a6-4d02-9428-79827aa06701', 'UNSOLD'),
('cfdc169e-f870-4eae-8f4b-0381f8500b80', '37d4877b-91a9-4eb5-8846-fe3dffaee100', 'UNSOLD'),
('cba06052-37ee-4cb4-b86c-c9a02590e273', '9f27ce24-41ba-4173-8d86-41a7ce89813d', 'UNSOLD'),
('c27e95f1-8c36-433e-bdc3-a0a28e266425', 'd071a89e-d4b5-4ed1-9300-659c46bce77b', 'UNSOLD'),
('5420fd1f-ce09-4d3e-9538-2804059e9a48', 'cb883425-037f-4f44-a00b-d8619afd8632', 'UNSOLD'),
('000a2786-9068-423c-9989-3a111d3f0daf', '24fa1f6e-9e82-4bc9-8528-50e5a68e1db9', 'UNSOLD'),
('396eba47-2313-4c6d-8f5c-632907110ae4', '6654a878-e555-4451-a964-5cf97f12d650', 'UNSOLD'),
('e9740369-4195-4e7c-892c-3f2ff2709a40', '1de63497-8c67-4799-9e22-8f19abbeccf7', 'UNSOLD'),
('c3ac8aff-93d5-408c-9932-7082ba1de84a', 'e0e588c8-aba0-4e7c-970a-d14ab51607c2', 'UNSOLD'),
('75be1443-b718-4649-af52-d2362a9eba97', '5efedc98-33b0-478b-a1ef-5361393294c4', 'UNSOLD'),
('cb5b1352-4c8e-4dc5-81de-1c8a5a3b9815', '08909ca5-deea-435e-b3bb-c5bd2b98b3e9', 'UNSOLD'),
('e95bd016-7dfd-4781-84b2-e348ae3e7deb', 'f2aa8cba-b6c4-42a7-92db-b4855fbfff70', 'UNSOLD'),
('b0b41032-11c6-464e-a75a-07c1bf2066ed', 'aececfda-8138-4448-b6cf-3bdb9921ae6d', 'UNSOLD'),
('03be22da-78b4-4b77-b94f-2bccbb2e2b47', 'dd11970c-fa6c-4fc1-bfda-ec836c202f56', 'UNSOLD'),
('b633125b-49c7-40e3-94a3-361e54461b9c', 'dec4343b-2e13-44f4-8d79-f22f8a04cee9', 'UNSOLD'),
('4da98d52-aa4a-42b5-8770-b7bbb323b0b9', '322c54e9-86c8-4d91-8a51-ee2b8202f3f4', 'UNSOLD'),
('0a6ac5a0-18c9-4860-b514-d27d0392e6a3', '95ffc37d-9f37-45f4-bcf0-c506d4791bb2', 'UNSOLD'),
('927e0036-76d0-45b2-901f-e120983edbac', '8e0f766b-174e-4206-962d-7af8cf9743ea', 'UNSOLD'),
('3dec69e6-895c-497d-8fc7-4d0a61228b70', 'aef22928-f034-4877-b61e-78853093be6f', 'UNSOLD'),
('3da0729e-3e36-49ad-8186-a26fd633ecf6', 'c3155b1f-fc7e-45f7-93a3-07e1d76e9c4d', 'UNSOLD'),
('655ba8b0-324b-4a80-bb4d-88ccdf2f4971', '1aff7a8f-a80b-4423-a7f0-e06c888e26c7', 'UNSOLD'),
('118ae11c-9668-40e1-a3f8-232827123bee', '3032425e-f4a9-44aa-8f6b-610599eada8a', 'UNSOLD'),
('47fcaef7-8fc8-45c2-b045-747467e748c0', 'a0a8bd0b-a24b-407a-899d-35ea1251e0d9', 'UNSOLD'),
('268e99f8-75b4-4fb9-bf99-f088ffa36d0d', 'e31e5e6d-79e3-4cd6-8841-cd53a72453f3', 'UNSOLD'),
('4255af8e-c588-4385-be00-a753341e45a4', '05051bfb-c363-42e4-9486-320057209840', 'UNSOLD'),
('b96ab805-d683-4783-ae3c-062d5d635209', 'dc344d39-2f89-4323-b287-facdfd665fbd', 'UNSOLD'),
('cb032c87-c614-457c-8b17-19a913e4af67', '8b8e5ccc-1143-4577-a6e6-456fc4e33d5e', 'UNSOLD'),
('d62c5fe7-0838-4dda-8a1f-980d99a8f122', 'af2b25fe-96c0-4fba-b0bd-7cb6636f092e', 'UNSOLD'),
('2efdca6a-94f2-4046-8add-132f590032c4', '9204027a-f44f-4e59-b49f-6666477bf3ae', 'UNSOLD'),
('aabb21aa-a86d-44e0-939c-fe56d98735e7', 'a70d4ca2-276e-49d4-865f-ce76bbb908b7', 'UNSOLD'),
('ce0a9016-ad2a-4284-aff9-111ba82e56a2', '007d3a66-2110-4473-8b72-441f5189d077', 'UNSOLD'),
('4e17fde0-f040-4cf0-957c-32d93136b318', '6d160759-85ad-48c7-8ade-586de793cfac', 'UNSOLD'),
('ee7aac92-3c27-42ad-a1ab-b434fae8364a', 'cb1decad-3b95-4661-b21d-ee10bfa2fe6c', 'UNSOLD'),
('2903f63e-e69a-4923-8470-31ea470397d0', '38fe0871-398b-4ca9-a2f4-952d2977eddb', 'UNSOLD'),
('f4fbbf8e-8fda-46b5-ac46-52c09ad07ef5', '9ecddd43-9728-4ea5-9525-29a4abec9705', 'UNSOLD'),
('5d97afc9-309a-45e4-8c36-020a5ee9d5c2', '1be5e32b-0a5e-4ff6-b7af-399400e0a3fc', 'UNSOLD'),
('d6955635-40ec-49ce-8df9-22dd1d2061af', 'da9439d2-d905-43d3-b64c-ea287bca6eae', 'UNSOLD'),
('4ac4dbb1-60bb-4ecc-96c7-3c72b281fbe0', '32dc58f5-fde6-417c-885d-a1be652715b5', 'UNSOLD'),
('3486693c-6608-4db4-907a-9f1af03868fe', '3ca69f4e-ea6f-4d76-82b7-02aad2d6145f', 'UNSOLD'),
('4ec45ebd-5560-43ef-96ef-da392e268c1d', 'd6921f93-8c88-43d7-9ae5-e9f3f2311bb2', 'UNSOLD'),
('9129729a-bff2-46d2-ba9c-f4bfbbf2a773', 'f746b06f-ca34-4978-9cee-e08d6340152f', 'UNSOLD'),
('d4baeb7b-2127-4599-bef4-34d7cb21551f', '2b29c17c-2268-4291-8214-2330a04bfb7f', 'UNSOLD'),
('989e50c9-1538-471b-87ba-f6a284720e4b', '12797e1f-74a2-479c-8413-30d9a80e1449', 'UNSOLD'),
('63c018cd-e930-434d-b455-1df381056930', '404485b1-1476-489a-a049-174212a1cf13', 'UNSOLD'),
('96ab7a25-e7a0-474a-989f-f0e17ede78bf', 'da47fcc2-c46e-44ed-adc4-7de875380054', 'UNSOLD'),
('02792d0b-f34c-4916-bce6-4506009dbce3', '2a99d241-4ba9-44d6-85d0-bbdd486d3e49', 'UNSOLD'),
('c0757801-d4b8-47c6-83c8-5a8d11e8cc08', 'd4b2247e-9f4f-4842-9a39-46c52c95ea17', 'UNSOLD'),
('cfe1ed5f-8387-437c-ac63-8b6173ddedba', '49ffa457-363a-4fa2-ac22-e7d0ca953225', 'UNSOLD'),
('86ea3385-6dfd-4c03-ae27-35164b47da71', 'c085171d-3d8f-455b-8567-d92cee9ee0d4', 'UNSOLD'),
('7641b92e-59ee-42cd-bfa8-d17e5fd1386f', '611a7026-1b41-4550-967e-73e9d3affdac', 'UNSOLD'),
('5bd9616b-d512-4b0f-8ac0-e2390587d36a', 'd3688673-c348-42c6-93e2-b8efedaa84b4', 'UNSOLD'),
('48637f79-eb1e-496b-b65d-6a94cf7c5e4e', '44860f03-4aa8-416a-9629-5c350d1e275e', 'UNSOLD'),
('d2de4f48-8b37-4fcc-b35a-4624ed0d23d7', '81cab4b4-8c4e-488b-ba22-0d113cda76be', 'UNSOLD'),
('e7cf2739-0d22-45f9-ac34-e6f23eaa9d34', 'e113175f-c3fc-430c-b09d-f03e08c4c51f', 'UNSOLD'),
('a9dab5b7-f010-4903-8ede-2f9d32355178', '9be6c489-ed18-4cf7-b40e-a0185c8edb8c', 'UNSOLD'),
('a4269657-1e2b-4411-a357-e58779af05c1', 'f690d2ad-b3da-4979-985d-d719494aebe8', 'UNSOLD'),
('dff8e7e9-5f75-4088-b7bd-194a0ab438b1', '4f045fab-4bd9-4c8f-a31f-130c8d5f03c8', 'UNSOLD'),
('f57b27ac-3e0b-4617-8388-815aa9441768', 'cb1e7613-d0d1-4540-a7c1-0c510ccd5a97', 'UNSOLD'),
('7cc324a8-383a-4143-a54f-11fa3fdd24db', '5f24e8de-4de7-4b30-af46-97bb3dd8e6d7', 'UNSOLD'),
('624c9cab-0418-471b-8169-288e8097cf38', 'd4a7b7ac-6d12-43c2-8a47-98aed445ac5d', 'UNSOLD'),
('e839874a-7df5-4b72-bd05-589935bf6d9a', 'a682b894-132a-44cf-9dfd-11d29438cea3', 'UNSOLD'),
('3e83d10f-a33e-46a2-8aab-57b3bfcd20c2', 'd2d1eb8c-4b48-4e0d-97b1-d3a94cc3b196', 'UNSOLD'),
('7a1fd02f-2dc2-4137-a5ea-bb846d961150', '87d722d8-e25c-4ad9-910d-aede913308ae', 'UNSOLD'),
('38c7eeff-7f1d-445f-bd0d-ce95539b6209', 'c7cfc3e8-adaf-45fd-980c-fea464a4f3f1', 'UNSOLD'),
('f7880ce2-eb9d-4a4a-97d4-37d3d3e8e3eb', '22cd39dc-c3ad-48c7-9c9e-25864c7b06fd', 'UNSOLD'),
('2694b333-fb27-48a0-85fd-2287d3d198fc', '5080f6b6-5a9c-49a0-aa52-d549f271171c', 'UNSOLD'),
('106b05fc-7863-4c47-95d3-3dfa0e0cd24a', '6118f1db-ea5d-4c65-b991-93a3bb348ea8', 'UNSOLD'),
('ffd55969-d9e1-4f0f-a746-230b26f03c27', 'fedb9eaa-abfc-4222-9c59-89029424db6c', 'UNSOLD'),
('0a7d1be1-9045-4b12-887c-0f1eed359978', 'db8003f7-1554-4bd2-83ed-e8e09f126956', 'UNSOLD'),
('546ec7bb-bfe8-48d3-9b80-f9ef862589c0', '910d594b-a1b4-4b1f-bf86-e77d299850ca', 'UNSOLD'),
('dc3dd16e-1555-4c8b-9e02-b37ac1132379', '8b372358-4278-4906-a242-974248901c32', 'UNSOLD'),
('86b07060-2d1e-436f-922e-167dd10bde8e', 'ba9cb518-a529-4c43-aa50-a29b76797bac', 'UNSOLD'),
('47c4f66c-b28b-44dd-87ed-40daa449df70', '4781e2ba-523d-43a7-ab30-94b040c1f70d', 'UNSOLD'),
('8520aac6-180f-4feb-8e4d-e870304b1d41', '4d91531e-f797-4e72-8d50-3154aba3c727', 'UNSOLD'),
('d80d716f-371b-4ee6-8c86-bb5b65b9f7b3', 'be42eee4-c5e4-4875-af52-3faff00c6485', 'UNSOLD'),
('77df4bc4-4e56-4e49-b572-ada2e7b215fc', '260e7292-f34a-4134-b6ef-1eedf3839f57', 'UNSOLD'),
('8fa526d8-f4a7-4283-abd2-ae192c107c36', '685927fe-2848-4045-839f-d555de868f2b', 'UNSOLD'),
('689dc5e3-ff01-4649-97f6-e53f8307789e', '7dda3d38-8c44-499a-b994-bfd028a06a94', 'UNSOLD'),
('1fa60d47-fe10-47f5-ab2c-ca79d5470ce4', '6fdd35bb-e775-41b9-84d0-a48ae58492b0', 'UNSOLD'),
('0050258e-9549-4ea5-847c-2a3c6866c64a', 'ea49ef18-6ff5-46bb-8129-3c7ca3cbc4be', 'UNSOLD'),
('e3256453-23ab-4365-bd03-9b9b4d0fb549', '91561bb8-cc43-4802-8526-fa508cce4921', 'UNSOLD'),
('6ba7de16-1da8-4baa-8595-10af3b92c4fa', '0eb58610-a866-4f4f-ab70-5917baaa9049', 'UNSOLD'),
('52dc5fb5-e7e7-497b-a05f-5c9d48a88227', '0a49f588-a21c-4994-8f05-e9f47a0edc66', 'UNSOLD'),
('18e9f9dc-2276-41a0-9d0f-f56d247f86b2', 'b5d01b5b-1009-47fa-9b38-1c4affc2bb57', 'UNSOLD'),
('f343cff8-23a3-444d-abe6-76a5d8ec3813', 'b8fae5c5-f22a-42e0-888e-860a5fcc4a94', 'UNSOLD'),
('9921c980-226a-4689-acbc-3259cc6fc24f', '98ced8a8-b7b8-45ab-9c68-d74d8070cade', 'UNSOLD'),
('9a9e1e0a-2277-4fcf-8e62-a3da91d31f0b', '47082fbd-7769-4b74-bcff-db08110ae02c', 'UNSOLD'),
('b4898d68-1098-43c7-8d83-6213b4cc680f', '56b02b7a-a249-432f-adbf-22bf06cda84d', 'UNSOLD'),
('898577fc-084b-474f-9d6d-38eb6d0a6e7d', 'f6d71580-c693-49cc-9d13-a1d8434688a9', 'UNSOLD'),
('27dd791f-d664-4abc-b630-9279a375485a', '37a0439c-887f-4f72-a78f-d4c188d07fcc', 'UNSOLD'),
('d117e6b1-34d4-483c-a981-eb32161585e7', '551c7f29-2128-4640-aab6-46443ad58992', 'UNSOLD'),
('b7139a3a-01b8-45dd-ad7f-063ecdb2d8fb', '59ee0d7f-5596-4a87-80e7-110175f7b2cd', 'UNSOLD'),
('278e013f-f996-4f7f-ab46-a05e12d105d6', '3deb2bf2-50e0-4695-ba6a-1db69191f388', 'UNSOLD'),
('dd634b71-d091-4574-87d4-7ca5679a6b31', 'ddde6f23-51d6-44e1-adfe-f648aa1ff4b3', 'UNSOLD'),
('f3fb3a57-bf83-4938-915b-0d03e5f30949', '8945ccef-7481-43f9-aa4f-b1f484719060', 'UNSOLD'),
('99bb921f-814b-4899-bfb0-e7c0c86c5eba', '862cb871-5562-4de0-8d08-8a6699241044', 'UNSOLD'),
('3f9ba4b1-7a65-4e4d-9411-b6353f45218b', '5b591717-76c1-407b-a6e2-60e6ba5ecf92', 'UNSOLD');

INSERT INTO "AdminUser" (id, username, password_hash, role) VALUES
('10b06678-be42-484b-9a5d-bf04ce27ddd2', 'admin', '$2b$10$4VeQ.7kyYWI14BDvvzEwWOjgUHa9KnYNQxyEjqFjacBXnuXVjiq0.', 'ADMIN'),
('d889e518-a2d6-45ef-b14a-0d093775ea83', 'screen', '$2b$10$PlZoCGF560jB1VD1lT2GpOHMppiGeRqkQS96fpurCm4INHd9FeGFW', 'SCREEN');

INSERT INTO "AuctionSequence" (id, name, type, sequence_items) VALUES
(1, 'Franchise Auction', 'FRANCHISE', '[3,7,1,9,5,10,2,6,8,4]');

INSERT INTO "AuctionSequence" (id, name, type, sequence_items) VALUES
(2, 'Power Card Auction', 'POWER_CARD', '["GOD_EYE","MULLIGAN","FINAL_STRIKE","BID_FREEZER"]');

INSERT INTO "AuctionSequence" (id, name, type, sequence_items) VALUES
(3, 'Player Auction 6', 'PLAYER', '[93,9,144,67,32,110,152,130,95,87,90,92,119,27,145,2,140,143,34,142,37,35,25,139,148,129,8,99,118,78,33,107,44,106,105,80,57,126,28,121,113,137,83,24,55,69,149,5,111,86,127,133,3,102,15,85,122,45,117,141,82,155,157,53,125,81,66,79,116,132,29,70,56,18,75,42,61,158,23,39,153,76,46,135,88,54,40,6,38,94,98,156,131,104,74,26,58,14,63,136,112,150,7,101,43,123,128,108,51,30,11,100,60,154,97,72,64,19,109,114,89,50,103,17,68,31,120,65,62,96,36,84,13,49,20,134,4,115,124,1,77,159,10,59,21,48,52,151,147,138,16,47,12,71,73,146,91,41,22]');

INSERT INTO "AuctionState" (id, phase, auction_day) VALUES (1, 'NOT_STARTED', 'Day 2');

