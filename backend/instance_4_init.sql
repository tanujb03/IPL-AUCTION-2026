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
('c194c1db-0948-4825-a0b8-7025d0123bae', 'Bid Masters X1', 'bidmastersx1', '$2b$10$aTTIwfKsoopQZEuP7ZGYre/XRJZO.wnEMNU7TQzEF3uWaSNcLZisu', 120, 0),
('c6558622-3d61-4d2f-ba3d-05951d37fc8d', 'Royal Paltans', 'royalpaltans', '$2b$10$pgApAGC1WRJ1nyoN7h2/jecNqUe8thI6HTvoCGuxgHg.GbaZSAozm', 120, 0),
('e3c30b98-f9ff-4d54-87c6-b4509c93e12a', 'VISTAR X1', 'vistarx1', '$2b$10$mE3yOLEYnTtf7qhJqSELduigGNNTRz4vXPq4ZdF7AQasMhwQ6cuaO', 120, 0),
('1eb663f3-ee67-4dbc-80ad-ba86f718538a', 'Elite Elevens', 'eliteelevens', '$2b$10$0d5x7F1gMyBMqL4A0fOKoeNP8BGsV7t3O5udrxg7GQd3wGla9pEnO', 120, 0),
('3e0c314d-4f67-40e3-9912-ad1eab83211b', 'Mr Nags', 'mrnags', '$2b$10$0dsKw7Fu1KylaCnUyta1y./8iJQHgiV7kA2Yj1E/KbED0zDKe/zPW', 120, 0),
('4939f61b-8f4f-48d2-b9b9-538d80d975c1', '50 Shades of Strategy', '50shadesofstrategy', '$2b$10$Kn7GU6uo7KTA3SAVPT6AReG9U6gPSddKakMAW0uTP16Ypt/LRDnhe', 120, 0),
('5cb218a3-58b6-475d-999a-e8d8a05826e9', 'Yash Kate', 'yashkate', '$2b$10$DqeAHri/6reYNKM8wLwCaOsBO3SuBcMI4KNkrG6NOh5X1Nl2S/j3C', 120, 0),
('02d8ea87-6478-4e42-b8c3-0beee0601432', 'The Dominators', 'thedominators', '$2b$10$/7uc0Oqgwb3ePcyLUQB4FeD.pYU5n1UJSgxMOrBtcUqgLWogmFT2K', 120, 0),
('9b85a456-8f86-4d40-8ad4-d5edd37ad80e', 'Achievers', 'achievers', '$2b$10$6UgQmjP0AsmptyltzfiDaO3m9H7n7aCYjBu//EFBQkiamHYfo5S8.', 120, 0),
('91466c01-93cb-44bd-ad57-f8c1d9a96386', 'Harsh', 'harsh', '$2b$10$Iab7crOEK/amyim3mXSqGeg7PnjvRMf/EFcAi75y//pO2LIDNasNC', 120, 0);

INSERT INTO "Player" (id, rank, name, team, role, category, pool, grade, rating, nationality, nationality_raw, base_price, is_riddle, riddle_title, riddle_question, legacy, url, matches, bat_runs, bat_sr, bat_average, bowl_wickets, bowl_eco, bowl_avg, sub_scoring, sub_impact, sub_consistency, sub_experience, sub_wicket_taking, sub_economy, sub_efficiency, sub_batting, sub_bowling, sub_versatility) VALUES
('a3946b74-9fba-4689-a6fa-8d4c2b43875b', 34, 'Quinton de Kock', 'Mumbai Indians', 'WK-Batsman', 'WK', 'BAT_WK', 'B', 79, 'OVERSEAS', 'South African', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/8520/quinton-de-kock', 115.0, 3309.0, 134.03, 30.64, NULL, NULL, NULL, 64.0, 67.0, 76.0, 87, NULL, NULL, NULL, NULL, NULL, NULL),
('83bfc46a-90ce-40e9-80b0-14983f67e2f5', 143, 'Prashant Solanki', 'Kolkata Knight Riders', 'Bowler', 'BOWL', 'BOWL', 'C', 57, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/12805/prashant-solanki', 2.0, NULL, NULL, NULL, 2.0, 6.33, 19.0, NULL, NULL, NULL, 31, 5.0, 99.0, 97.0, NULL, NULL, NULL),
('456555e6-0107-4dd9-8478-776821b563e0', 82, 'Jitesh Sharma', 'Royal Challengers Bengaluru', 'WK-Batsman', 'WK', 'BAT_WK', 'C', 68, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/10214/jitesh-sharma', 55.0, 991.0, 157.06, 25.41, NULL, NULL, NULL, 22.0, 83.0, 63.0, 57, NULL, NULL, NULL, NULL, NULL, NULL),
('a042c540-951a-4324-80ba-19b83adacda7', 149, 'Glenn Phillips', 'Gujarat Titans', 'Batting Allrounder', 'AR', 'AR', 'C', 56, 'OVERSEAS', 'New Zealander', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/10693/glenn-phillips', 8.0, 65.0, NULL, NULL, 2.0, NULL, NULL, NULL, NULL, NULL, 34, NULL, NULL, NULL, 24.0, 34.0, 24.0),
('ac561c3b-3818-4845-88a7-940090f82c4a', 152, 'Anukul Roy', 'Kolkata Knight Riders', 'Batting Allrounder', 'AR', 'AR', 'C', 56, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/12344/anukul-roy', 11.0, 26.0, NULL, NULL, 6.0, NULL, NULL, NULL, NULL, NULL, 35, NULL, NULL, NULL, 17.0, 29.0, 17.0),
('da65b344-a67e-423b-9e4d-0ed8b39722de', 127, 'Digvesh Singh Rathi', 'Lucknow Super Giants', 'Bowler', 'BOWL', 'BOWL', 'C', 61, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/1448289/digvesh-singh-rathi', 13.0, NULL, NULL, NULL, 14.0, 8.25, 30.64, NULL, NULL, NULL, 36, 12.0, 68.0, 72.0, NULL, NULL, NULL),
('2fe541a6-ac78-423d-840f-f1728273739b', 50, 'Mitchell Marsh', 'Lucknow Super Giants', 'Batting Allrounder', 'AR', 'AR', 'B', 74, 'OVERSEAS', 'Australian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/6250/mitchell-marsh', 55.0, 1292.0, NULL, NULL, 37.0, NULL, NULL, NULL, NULL, NULL, 57, NULL, NULL, NULL, 72.0, 43.0, 43.0),
('d18de589-b119-4038-b25d-afba997b561e', 117, 'Dewald Brevis', 'Chennai Super Kings', 'Batsman', 'BAT', 'BAT_WK', 'C', 62, 'OVERSEAS', 'South African', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/20538/dewald-brevis', 16.0, 455.0, 153.2, 28.44, NULL, NULL, NULL, 12.0, 80.0, 71.0, 38, NULL, NULL, NULL, NULL, NULL, NULL),
('f6859668-42ad-4a1d-a272-b03434069d85', 19, 'Hardik Pandya', 'Mumbai Indians', 'Batting Allrounder', 'AR', 'AR', 'A', 89, 'INDIAN', 'Indian', 2, false, NULL, NULL, 6, 'https://www.cricbuzz.com/profiles/9647/hardik-pandya', 152.0, 2749.0, NULL, NULL, 78.0, NULL, NULL, NULL, NULL, NULL, 99, NULL, NULL, NULL, 90.0, 50.0, 50.0),
('d8a551b8-cb30-4cd2-846e-9814fa54d20e', 147, 'Mayank Yadav', 'Lucknow Super Giants', 'Bowler', 'BOWL', 'BOWL', 'C', 57, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/22401/mayank-yadav', 6.0, NULL, NULL, NULL, 9.0, 9.17, 20.56, NULL, NULL, NULL, 33, 9.0, 53.0, 94.0, NULL, NULL, NULL),
('b0951b0f-3c08-46c9-90f4-34babd903c90', 30, 'Rishabh Pant', 'Lucknow Super Giants', 'WK-Batsman', 'WK', 'BAT_WK', 'B', 82, 'INDIAN', 'Indian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/10744/rishabh-pant', 125.0, 3553.0, 147.62, 34.16, NULL, NULL, NULL, 68.0, 76.0, 85.0, 92, NULL, NULL, NULL, NULL, NULL, NULL),
('3f1e8fb5-9682-4833-b312-dd6883d2b59e', 135, 'Kartik Tyagi', 'Kolkata Knight Riders', 'Bowler', 'BOWL', 'BOWL', 'C', 58, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/13136/kartik-tyagi', 20.0, NULL, NULL, NULL, 15.0, 10.14, 47.53, NULL, NULL, NULL, 40, 13.0, 37.0, 37.0, NULL, NULL, NULL),
('24ed192f-7162-4329-a965-a4bf5315e4e8', 112, 'Nitish Kumar Reddy', 'Sunrisers Hyderabad', 'Batting Allrounder', 'AR', 'AR', 'C', 62, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/14701/nitish-kumar-reddy', 28.0, 485.0, NULL, NULL, 5.0, NULL, NULL, NULL, NULL, NULL, 44, NULL, NULL, NULL, 50.0, 14.0, 14.0),
('b1e7ed9b-97dc-404c-8e4b-ca725225a00a', 37, 'Ishan Kishan', 'Sunrisers Hyderabad', 'WK-Batsman', 'WK', 'BAT_WK', 'B', 78, 'INDIAN', 'Indian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/10276/ishan-kishan', 119.0, 2998.0, 137.65, 29.11, NULL, NULL, NULL, 58.0, 70.0, 72.0, 89, NULL, NULL, NULL, NULL, NULL, NULL),
('0062df71-85f6-4400-83e9-0f7941b7fc8a', 92, 'Shashank Singh', 'Punjab Kings', 'Batting Allrounder', 'AR', 'AR', 'C', 67, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/10919/shashank-singh', 41.0, 773.0, NULL, NULL, 1.0, NULL, NULL, NULL, NULL, NULL, 50, NULL, NULL, NULL, 67.0, 14.0, 14.0),
('1f2d4109-4971-4475-99aa-b8643f2e8a98', 36, 'Arshdeep Singh', 'Punjab Kings', 'Bowler', 'BOWL', 'BOWL', 'B', 78, 'INDIAN', 'Indian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/13217/arshdeep-singh', 82.0, NULL, NULL, NULL, 97.0, 9.0, 26.49, NULL, NULL, NULL, 71, 66.0, 56.0, 81.0, NULL, NULL, NULL),
('ddff0c92-dc3c-439d-a98e-2c615a4bee5e', 142, 'Kamindu Mendis', 'Sunrisers Hyderabad', 'Batting Allrounder', 'AR', 'AR', 'C', 57, 'OVERSEAS', 'Sri Lankan', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/10940/kamindu-mendis', 5.0, 92.0, NULL, NULL, 2.0, NULL, NULL, NULL, NULL, NULL, 32, NULL, NULL, NULL, 38.0, 29.0, 29.0),
('9e9f004f-950d-441b-a039-63b765dee692', 41, 'Nitish Rana', 'Delhi Capitals', 'Batsman', 'BAT', 'BAT_WK', 'B', 77, 'INDIAN', 'Indian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/9204/nitish-rana', 118.0, 2853.0, 136.77, 27.7, NULL, NULL, NULL, 56.0, 69.0, 69.0, 89, NULL, NULL, NULL, NULL, NULL, NULL),
('e5bafdc7-9e62-439a-8839-7dedc647261a', 109, 'Abdul Samad', 'Lucknow Super Giants', 'Batting Allrounder', 'AR', 'AR', 'C', 63, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/14628/abdul-samad', 63.0, 741.0, NULL, NULL, 2.0, NULL, NULL, NULL, NULL, NULL, 61, NULL, NULL, NULL, 57.0, 5.0, 5.0),
('c3fed97e-e15a-4f04-99be-1efed761671a', 23, 'Shubman Gill', 'Gujarat Titans', 'Batsman', 'BAT', 'BAT_WK', 'B', 84, 'INDIAN', 'Indian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/11808/shubman-gill', 118.0, 3866.0, 138.72, 39.45, NULL, NULL, NULL, 74.0, 70.0, 98.0, 89, NULL, NULL, NULL, NULL, NULL, NULL),
('f2182dd2-589d-4e11-b299-5064510d3476', 100, 'Abishek Porel', 'Delhi Capitals', 'WK-Batsman', 'WK', 'BAT_WK', 'C', 66, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/24326/abishek-porel', 31.0, 661.0, 149.89, 25.42, NULL, NULL, NULL, 16.0, 78.0, 63.0, 45, NULL, NULL, NULL, NULL, NULL, NULL),
('91510bc2-a050-4bea-a9c6-c7d0c6591033', 26, 'Jaydev Unadkat', 'Sunrisers Hyderabad', 'Bowler', 'BOWL', 'BOWL', 'B', 83, 'INDIAN', 'Indian', 1, true, 'The Ultimate Journeyman (Grade B)', 'Forget winning trophies; my biggest IPL achievement is collecting almost every single franchise jersey in the tournament''s history! My wardrobe looks like a rainbow. A domestic captain legend who specializes in tricky left-arm slower balls, my absolute peak was carrying a defunct Pune franchise to a final. After touring practically the entire country, I’m currently throwing down my off-cutters for the Orange Army down South. Who am I?', 2, 'https://www.cricbuzz.com/profiles/6327/jaydev-unadkat', 112.0, NULL, NULL, NULL, 110.0, 8.88, 30.58, NULL, NULL, NULL, 86, 74.0, 58.0, 73.0, NULL, NULL, NULL),
('e957d068-2796-4943-8797-f4f23a56c5f2', 33, 'Ishant Sharma', 'Gujarat Titans', 'Bowler', 'BOWL', 'BOWL', 'B', 79, 'INDIAN', 'Indian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/702/ishant-sharma', 117.0, NULL, NULL, NULL, 96.0, 8.38, 35.18, NULL, NULL, NULL, 88, 65.0, 66.0, 63.0, NULL, NULL, NULL),
('b60644be-5d74-447f-8f49-03f92a389018', 69, 'Liam Livingstone', 'Sunrisers Hyderabad', 'Batting Allrounder', 'AR', 'AR', 'B', 70, 'OVERSEAS', 'English', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/10045/liam-livingstone', 49.0, 1051.0, NULL, NULL, 13.0, NULL, NULL, NULL, NULL, NULL, 54, NULL, NULL, NULL, 70.0, 28.0, 28.0),
('a99580a3-300b-47d1-8e1c-a227a9692487', 119, 'Wanindu Hasaranga', 'Lucknow Super Giants', 'Bowling Allrounder', 'AR', 'AR', 'C', 62, 'OVERSEAS', 'Sri Lankan', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/10926/wanindu-hasaranga', 37.0, 81.0, NULL, NULL, 46.0, NULL, NULL, NULL, NULL, NULL, 48, NULL, NULL, NULL, 15.0, 45.0, 15.0),
('77325df4-4a9d-4c84-94c0-304c8604d22b', 159, 'Rasikh Dar Salam', 'Royal Challengers Bengaluru', 'Bowler', 'BOWL', 'BOWL', 'C', 55, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/14274/rasikh-dar-salam', 13.0, NULL, NULL, NULL, 10.0, 10.62, 40.9, NULL, NULL, NULL, 36, 10.0, 29.0, 51.0, NULL, NULL, NULL),
('675a3bf9-b16d-4a29-aee1-4bb5ec8cec5a', 123, 'Ayush Mhatre', 'Chennai Super Kings', 'Batsman', 'BAT', 'BAT_WK', 'C', 61, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/1431163/ayush-mhatre', 7.0, 240.0, 188.98, 34.29, NULL, NULL, NULL, 8.0, 99.0, 85.0, 33, NULL, NULL, NULL, NULL, NULL, NULL),
('5cca6b6d-e618-4287-98c1-6ff10d68c646', 89, 'Dhruv Jurel', 'Rajasthan Royals', 'WK-Batsman', 'WK', 'BAT_WK', 'C', 67, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/14691/dhruv-jurel', 41.0, 680.0, 153.85, 28.33, NULL, NULL, NULL, 16.0, 81.0, 71.0, 50, NULL, NULL, NULL, NULL, NULL, NULL),
('5e6f66c0-976f-43da-b664-b6a75e5e508f', 80, 'Lockie Ferguson', 'Punjab Kings', 'Bowler', 'BOWL', 'BOWL', 'C', 69, 'OVERSEAS', 'New Zealander', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/10692/lockie-ferguson', 49.0, NULL, NULL, NULL, 51.0, 8.97, 30.0, NULL, NULL, NULL, 54, 36.0, 56.0, 74.0, NULL, NULL, NULL),
('adcee4e3-c7f9-4501-a20d-014658995863', 155, 'Swapnil Singh', 'Royal Challengers Bengaluru', 'Bowling Allrounder', 'AR', 'AR', 'C', 56, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/10238/swapnil-singh', 14.0, 51.0, NULL, NULL, 7.0, NULL, NULL, NULL, NULL, NULL, 37, NULL, NULL, NULL, 23.0, 27.0, 23.0),
('caf6010e-f84e-422d-9d3a-8654a699995c', 47, 'Yashasvi Jaiswal', 'Rajasthan Royals', 'Batsman', 'BAT', 'BAT_WK', 'B', 75, 'INDIAN', 'Indian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/13940/yashasvi-jaiswal', 66.0, 2166.0, 152.86, 34.38, NULL, NULL, NULL, 43.0, 80.0, 85.0, 63, NULL, NULL, NULL, NULL, NULL, NULL),
('3be49f0b-aa81-469d-b56b-9f699236976a', 101, 'Umran Malik', 'Kolkata Knight Riders', 'Bowler', 'BOWL', 'BOWL', 'C', 65, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/19027/umran-malik', 26.0, NULL, NULL, NULL, 29.0, 9.4, 26.62, NULL, NULL, NULL, 43, 22.0, 49.0, 81.0, NULL, NULL, NULL),
('5cdce19f-7316-455c-9e63-b7679a5f0693', 111, 'Ryan Rickelton', 'Mumbai Indians', 'WK-Batsman', 'WK', 'BAT_WK', 'C', 62, 'OVERSEAS', 'South African', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/13070/ryan-rickelton', 14.0, 388.0, 150.98, 29.85, NULL, NULL, NULL, 11.0, 79.0, 74.0, 37, NULL, NULL, NULL, NULL, NULL, NULL),
('db35e715-8231-442b-a03e-37401d30e0d4', 73, 'Tim David', 'Royal Challengers Bengaluru', 'Batsman', 'BAT', 'BAT_WK', 'B', 70, 'OVERSEAS', 'Singaporean', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/13169/tim-david', 50.0, 846.0, 173.37, 32.54, NULL, NULL, NULL, 19.0, 94.0, 81.0, 55, NULL, NULL, NULL, NULL, NULL, NULL),
('805f2c04-c31c-419a-86ba-6111c56a00b2', 43, 'Abhishek Sharma', 'Sunrisers Hyderabad', 'Batting Allrounder', 'AR', 'AR', 'B', 77, 'INDIAN', 'Indian', 1, false, NULL, NULL, 2, 'https://www.cricbuzz.com/profiles/12086/abhishek-sharma', 77.0, 1815.0, NULL, NULL, 11.0, NULL, NULL, NULL, NULL, NULL, 68, NULL, NULL, NULL, 90.0, 24.0, 24.0),
('ea3b9c0d-08b3-40ec-9539-0c36f7f24f1d', 88, 'Harshit Rana', 'Kolkata Knight Riders', 'Bowler', 'BOWL', 'BOWL', 'C', 67, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/24729/harshit-rana', 33.0, NULL, NULL, NULL, 40.0, 9.51, 25.73, NULL, NULL, NULL, 46, 29.0, 47.0, 83.0, NULL, NULL, NULL),
('dc753bff-6611-4261-a45a-1545d72f4946', 58, 'Riyan Parag', 'Rajasthan Royals', 'Batting Allrounder', 'AR', 'AR', 'B', 73, 'INDIAN', 'Indian', 1, false, NULL, NULL, 2, 'https://www.cricbuzz.com/profiles/12305/riyan-parag', 83.0, 1566.0, NULL, NULL, 7.0, NULL, NULL, NULL, NULL, NULL, 71, NULL, NULL, NULL, 78.0, 16.0, 16.0),
('1a6cf871-9dca-4a8e-8ea4-5fe221949c44', 63, 'T Natarajan', 'Delhi Capitals', 'Bowler', 'BOWL', 'BOWL', 'B', 72, 'INDIAN', 'Indian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/10225/t-natarajan', 63.0, NULL, NULL, NULL, 67.0, 8.94, 30.12, NULL, NULL, NULL, 61, 47.0, 57.0, 74.0, NULL, NULL, NULL),
('12105c1c-3bc0-4059-af9b-5764e9bbcc99', 115, 'Rachin Ravindra', 'Kolkata Knight Riders', 'Batting Allrounder', 'AR', 'AR', 'C', 62, 'OVERSEAS', 'New Zealander', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/11177/rachin-ravindra', 18.0, 413.0, NULL, NULL, 0.0, NULL, NULL, NULL, NULL, NULL, 39, NULL, NULL, NULL, 49.0, 29.0, 29.0),
('3bb74ae5-f0a1-4178-a1da-1c5e6763fded', 114, 'Mitchell Santner', 'Mumbai Indians', 'Bowling Allrounder', 'AR', 'AR', 'C', 62, 'OVERSEAS', 'New Zealander', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/10100/mitchell-santner', 31.0, 110.0, NULL, NULL, 25.0, NULL, NULL, NULL, NULL, NULL, 45, NULL, NULL, NULL, 25.0, 40.0, 25.0),
('18d26609-3e49-49ed-b6b0-6c93534e0405', 32, 'David Miller', 'Delhi Capitals', 'Batsman', 'BAT', 'BAT_WK', 'B', 80, 'OVERSEAS', 'South African', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/6349/david-miller', 141.0, 3077.0, 138.61, 35.78, NULL, NULL, NULL, 60.0, 70.0, 89.0, 99, NULL, NULL, NULL, NULL, NULL, NULL),
('fb4da53d-3df8-431f-b82d-ab52a680502f', 85, 'Mohsin Khan', 'Lucknow Super Giants', 'Bowler', 'BOWL', 'BOWL', 'C', 67, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/13534/mohsin-khan', 24.0, NULL, NULL, NULL, 27.0, 8.51, 25.52, NULL, NULL, NULL, 42, 21.0, 64.0, 83.0, NULL, NULL, NULL),
('8ef7f5ca-2440-447d-a125-7a5e6c6ebe89', 57, 'Jofra Archer', 'Rajasthan Royals', 'Bowler', 'BOWL', 'BOWL', 'B', 73, 'OVERSEAS', 'English', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/11540/jofra-archer', 52.0, NULL, NULL, NULL, 59.0, 7.89, 27.15, NULL, NULL, NULL, 56, 41.0, 74.0, 80.0, NULL, NULL, NULL),
('05b94bb9-1630-46ee-aa55-2ca2729a1c02', 150, 'Adam Milne', 'Rajasthan Royals', 'Bowler', 'BOWL', 'BOWL', 'C', 56, 'OVERSEAS', 'New Zealander', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/7625/adam-milne', 10.0, NULL, NULL, NULL, 7.0, 9.48, 46.71, NULL, NULL, NULL, 35, 8.0, 48.0, 38.0, NULL, NULL, NULL),
('ca0632d4-e42f-4e47-9a84-85847869d148', 61, 'Travis Head', 'Sunrisers Hyderabad', 'Batsman', 'BAT', 'BAT_WK', 'B', 72, 'OVERSEAS', 'Australian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/8497/travis-head', 38.0, 1146.0, 170.03, 34.73, NULL, NULL, NULL, 25.0, 92.0, 86.0, 49, NULL, NULL, NULL, NULL, NULL, NULL),
('0880c773-dbbb-441d-bb6b-c2ffd9710029', 46, 'Avesh Khan', 'Lucknow Super Giants', 'Bowler', 'BOWL', 'BOWL', 'B', 76, 'INDIAN', 'Indian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/9781/avesh-khan', 75.0, NULL, NULL, NULL, 87.0, 9.12, 28.29, NULL, NULL, NULL, 67, 60.0, 54.0, 77.0, NULL, NULL, NULL),
('4286fb43-1d63-4372-a1b8-0e0a6cc85112', 13, 'Axar Patel', 'Delhi Capitals', 'Bowling Allrounder', 'AR', 'AR', 'A', 91, 'INDIAN', 'Indian', 2, false, NULL, NULL, 6, 'https://www.cricbuzz.com/profiles/8808/axar-patel', 162.0, 1916.0, NULL, NULL, 128.0, NULL, NULL, NULL, NULL, NULL, 99, NULL, NULL, NULL, 82.0, 72.0, 72.0),
('ac469b7e-0aaf-4fe5-ac6a-25fbf1a04ca1', 158, 'Arjun Tendulkar', 'Lucknow Super Giants', 'Bowling Allrounder', 'AR', 'AR', 'C', 55, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/13747/arjun-tendulkar', 5.0, 13.0, NULL, NULL, 3.0, NULL, NULL, NULL, NULL, NULL, 32, NULL, NULL, NULL, 32.0, 23.0, 23.0),
('7c0caf2b-f990-4a36-979a-1875b10c23e6', 125, 'Vaibhav Suryavanshi', 'Rajasthan Royals', 'Batsman', 'BAT', 'BAT_WK', 'C', 61, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/51791/vaibhav-suryavanshi', 7.0, 252.0, 206.56, 36.0, NULL, NULL, NULL, 9.0, 99.0, 89.0, 33, NULL, NULL, NULL, NULL, NULL, NULL),
('71b291ce-ceed-4b6e-a45f-bd04e8070e0a', 60, 'Noor Ahmad', 'Chennai Super Kings', 'Bowler', 'BOWL', 'BOWL', 'B', 72, 'OVERSEAS', 'Afghan', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/15452/noor-ahmad', 37.0, NULL, NULL, NULL, 48.0, 8.08, 22.23, NULL, NULL, NULL, 48, 34.0, 71.0, 90.0, NULL, NULL, NULL),
('d0bd331b-e8cc-4657-81dd-a8e1d19a84f2', 137, 'Jayant Yadav', 'Gujarat Titans', 'Bowling Allrounder', 'AR', 'AR', 'C', 58, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/8182/jayant-yadav', 20.0, 40.0, NULL, NULL, 8.0, NULL, NULL, NULL, NULL, NULL, 40, NULL, NULL, NULL, 22.0, 25.0, 22.0),
('1637b9a9-628f-4490-baa5-5c64761ddfe6', 3, 'Jasprit Bumrah', 'Mumbai Indians', 'Bowler', 'BOWL', 'BOWL', 'A', 99, 'INDIAN', 'Indian', 2, false, NULL, NULL, 8, 'https://www.cricbuzz.com/profiles/9311/jasprit-bumrah', 145.0, NULL, NULL, NULL, 183.0, 7.25, 22.03, NULL, NULL, NULL, 99, 99.0, 84.0, 91.0, NULL, NULL, NULL),
('305c6f3c-b2cb-4052-a961-47e4ee2f9277', 103, 'Priyansh Arya', 'Punjab Kings', 'Batsman', 'BAT', 'BAT_WK', 'C', 64, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/14689/priyansh-arya', 17.0, 475.0, 179.25, 27.94, NULL, NULL, NULL, 13.0, 98.0, 70.0, 38, NULL, NULL, NULL, NULL, NULL, NULL),
('7ed29c8a-d089-4501-bbb6-1179af3bd4b9', 84, 'Cameron Green', 'Kolkata Knight Riders', 'Batting Allrounder', 'AR', 'AR', 'C', 68, 'OVERSEAS', 'Australian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/12225/cameron-green', 29.0, 707.0, NULL, NULL, 16.0, NULL, NULL, NULL, NULL, NULL, 44, NULL, NULL, NULL, 64.0, 27.0, 27.0),
('098f5230-e2fb-432c-bf01-4c45b8843f5e', 6, 'Rohit Sharma', 'Mumbai Indians', 'Batsman', 'BAT', 'BAT_WK', 'A', 96, 'INDIAN', 'Indian', 2, false, NULL, NULL, 8, 'https://www.cricbuzz.com/profiles/576/rohit-sharma', 272.0, 7046.0, 132.1, 29.73, NULL, NULL, NULL, 99.0, 66.0, 74.0, 99, NULL, NULL, NULL, NULL, NULL, NULL),
('428d12a5-5662-43d6-913b-d67090ac1b68', 133, 'Kyle Jamieson', 'Delhi Capitals', 'Bowler', 'BOWL', 'BOWL', 'C', 59, 'OVERSEAS', 'New Zealander', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/9441/kyle-jamieson', 13.0, NULL, NULL, NULL, 14.0, 9.67, 29.71, NULL, NULL, NULL, 36, 12.0, 45.0, 74.0, NULL, NULL, NULL),
('001527c9-92ae-410b-924d-98a93dda9746', 94, 'Will Jacks', 'Mumbai Indians', 'Batting Allrounder', 'AR', 'AR', 'C', 66, 'OVERSEAS', 'English', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/12258/will-jacks', 21.0, 463.0, NULL, NULL, 8.0, NULL, NULL, NULL, NULL, NULL, 40, NULL, NULL, NULL, 55.0, 28.0, 28.0),
('fd529108-da77-41d1-aa00-9dc3632dadd6', 17, 'Mohammed Shami', 'Lucknow Super Giants', 'Bowler', 'BOWL', 'BOWL', 'A', 89, 'INDIAN', 'Indian', 2, false, NULL, NULL, 4, 'https://www.cricbuzz.com/profiles/7909/mohammed-shami', 119.0, NULL, NULL, NULL, 133.0, 8.63, 28.18, NULL, NULL, NULL, 89, 89.0, 62.0, 78.0, NULL, NULL, NULL),
('2918ddb2-8699-4fe9-93f3-b5808a31f399', 139, 'Nandre Burger', 'Rajasthan Royals', 'Bowler', 'BOWL', 'BOWL', 'C', 58, 'OVERSEAS', 'South African', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/13630/nandre-burger', 5.0, NULL, NULL, NULL, 7.0, 8.53, 20.71, NULL, NULL, NULL, 32, 8.0, 63.0, 94.0, NULL, NULL, NULL),
('a00ab5ad-f8bf-4d09-8ea8-0889cd6f139f', 157, 'Manimaran Siddharth', 'Lucknow Super Giants', 'Bowler', 'BOWL', 'BOWL', 'C', 55, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/12930/manimaran-siddharth', 5.0, NULL, NULL, NULL, 3.0, 8.63, 46.0, NULL, NULL, NULL, 32, 5.0, 62.0, 40.0, NULL, NULL, NULL),
('2494ee1a-a8aa-4263-a776-620090745f06', 42, 'Ruturaj Gaikwad', 'Chennai Super Kings', 'Batsman', 'BAT', 'BAT_WK', 'B', 77, 'INDIAN', 'Indian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/11813/ruturaj-gaikwad', 71.0, 2502.0, 137.48, 40.35, NULL, NULL, NULL, 49.0, 70.0, 99.0, 65, NULL, NULL, NULL, NULL, NULL, NULL),
('76c3bd05-eab2-46e8-a1f2-8252e3a1045c', 97, 'Ramandeep Singh', 'Kolkata Knight Riders', 'Batting Allrounder', 'AR', 'AR', 'C', 66, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/12337/ramandeep-singh', 30.0, 217.0, NULL, NULL, 6.0, NULL, NULL, NULL, NULL, NULL, 45, NULL, NULL, NULL, 46.0, 35.0, 35.0),
('59d1d7c3-9ad1-4da7-b3c3-6304645dc908', 132, 'Kuldeep Sen', 'Rajasthan Royals', 'Bowler', 'BOWL', 'BOWL', 'C', 59, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/14336/kuldeep-sen', 12.0, NULL, NULL, NULL, 14.0, 9.63, 27.64, NULL, NULL, NULL, 36, 12.0, 45.0, 79.0, NULL, NULL, NULL),
('f45567a5-1804-43ec-9ce0-decac7e5b5cc', 128, 'Yash Thakur', 'Punjab Kings', 'Bowler', 'BOWL', 'BOWL', 'C', 61, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/12096/yash-thakur', 21.0, NULL, NULL, NULL, 25.0, 10.43, 30.8, NULL, NULL, NULL, 40, 20.0, 32.0, 72.0, NULL, NULL, NULL),
('8db9f605-62d2-4ab2-ba0e-fd469f3ec71b', 54, 'Heinrich Klaasen', 'Sunrisers Hyderabad', 'WK-Batsman', 'WK', 'BAT_WK', 'B', 74, 'OVERSEAS', 'South African', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/10209/heinrich-klaasen', 49.0, 1480.0, 169.73, 40.0, NULL, NULL, NULL, 31.0, 91.0, 99.0, 54, NULL, NULL, NULL, NULL, NULL, NULL),
('ad594da7-9679-4fb2-97f2-2543e3013557', 29, 'Mohammed Siraj', 'Gujarat Titans', 'Bowler', 'BOWL', 'BOWL', 'B', 83, 'INDIAN', 'Indian', 1, false, NULL, NULL, 2, 'https://www.cricbuzz.com/profiles/10808/mohammed-siraj', 108.0, NULL, NULL, NULL, 109.0, 8.74, 30.72, NULL, NULL, NULL, 84, 74.0, 60.0, 72.0, NULL, NULL, NULL),
('8ca3d793-5559-4056-af4d-950ff5b6c141', 154, 'Nuwan Thushara', 'Royal Challengers Bengaluru', 'Bowler', 'BOWL', 'BOWL', 'C', 56, 'OVERSEAS', 'Sri Lankan', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/18509/nuwan-thushara', 8.0, NULL, NULL, NULL, 9.0, 9.43, 31.44, NULL, NULL, NULL, 34, 9.0, 49.0, 71.0, NULL, NULL, NULL),
('78de0983-36c2-408a-9261-8f0b68622f44', 107, 'Shahbaz Ahmed', 'Lucknow Super Giants', 'Bowling Allrounder', 'AR', 'AR', 'C', 64, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/14606/shahbaz-ahmed', 58.0, 545.0, NULL, NULL, 22.0, NULL, NULL, NULL, NULL, NULL, 59, NULL, NULL, NULL, 43.0, 27.0, 27.0),
('387db1e3-b44c-4c8b-920d-ef49bf00a941', 95, 'Nehal Wadhera', 'Punjab Kings', 'Batsman', 'BAT', 'BAT_WK', 'C', 66, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/13915/nehal-wadhera', 36.0, 719.0, 142.95, 26.63, NULL, NULL, NULL, 17.0, 73.0, 66.0, 48, NULL, NULL, NULL, NULL, NULL, NULL),
('512ca56e-fa51-4dba-9e4c-9e536233ba87', 96, 'Vaibhav Arora', 'Kolkata Knight Riders', 'Bowler', 'BOWL', 'BOWL', 'C', 66, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/15861/vaibhav-arora', 32.0, NULL, NULL, NULL, 36.0, 9.55, 28.22, NULL, NULL, NULL, 46, 27.0, 47.0, 78.0, NULL, NULL, NULL),
('16b5bb97-6b05-4c85-8bd9-7fe21a853cc2', 64, 'Shreyas Gopal', 'Chennai Super Kings', 'Bowler', 'BOWL', 'BOWL', 'B', 72, 'INDIAN', 'Indian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/9746/shreyas-gopal', 52.0, NULL, NULL, NULL, 52.0, 8.16, 25.92, NULL, NULL, NULL, 56, 37.0, 69.0, 83.0, NULL, NULL, NULL),
('5833d939-e2f0-42ec-bb87-e3ef972d95f6', 51, 'Sam Curran', 'Rajasthan Royals', 'Bowling Allrounder', 'AR', 'AR', 'B', 74, 'OVERSEAS', 'English', 1, false, NULL, NULL, 2, 'https://www.cricbuzz.com/profiles/10420/sam-curran', 64.0, 997.0, NULL, NULL, 59.0, NULL, NULL, NULL, NULL, NULL, 62, NULL, NULL, NULL, 62.0, 41.0, 41.0),
('3d65ab42-52df-4587-be40-e6e4d7adceaa', 126, 'Nathan Ellis', 'Chennai Super Kings', 'Bowler', 'BOWL', 'BOWL', 'C', 61, 'OVERSEAS', 'Australian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/15480/nathan-ellis', 17.0, NULL, NULL, NULL, 19.0, 8.67, 28.74, NULL, NULL, NULL, 38, 16.0, 61.0, 77.0, NULL, NULL, NULL),
('5806cc6a-7e69-41a9-8cbe-818ac4563e72', 11, 'Sandeep Sharma', 'Rajasthan Royals', 'Bowler', 'BOWL', 'BOWL', 'A', 93, 'INDIAN', 'Indian', 2, false, NULL, NULL, 4, 'https://www.cricbuzz.com/profiles/8356/sandeep-sharma', 136.0, NULL, NULL, NULL, 146.0, 8.03, 27.88, NULL, NULL, NULL, 98, 98.0, 71.0, 78.0, NULL, NULL, NULL),
('edecf274-71ef-4507-95d9-3a968e68bba9', 118, 'Aniket Verma', 'Sunrisers Hyderabad', 'Batsman', 'BAT', 'BAT_WK', 'C', 62, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/1447065/aniket-verma', 14.0, 236.0, 166.2, 26.22, NULL, NULL, NULL, 8.0, 89.0, 65.0, 37, NULL, NULL, NULL, NULL, NULL, NULL),
('575c20c2-5342-4a24-8f65-28095977bb5f', 78, 'Rajat Patidar', 'Royal Challengers Bengaluru', 'Batsman', 'BAT', 'BAT_WK', 'C', 69, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/10636/rajat-patidar', 42.0, 1111.0, 154.31, 30.86, NULL, NULL, NULL, 24.0, 81.0, 77.0, 51, NULL, NULL, NULL, NULL, NULL, NULL),
('10fef280-ad03-4f22-acfd-e56db2386265', 144, 'Vijaykumar Vyshak', 'Punjab Kings', 'Bowler', 'BOWL', 'BOWL', 'C', 57, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/10486/vijaykumar-vyshak', 16.0, NULL, NULL, NULL, 17.0, 10.38, 33.88, NULL, NULL, NULL, 38, 14.0, 33.0, 66.0, NULL, NULL, NULL),
('001420db-2cdf-43d7-8827-73ca2fd2cce2', 44, 'Khaleel Ahmed', 'Chennai Super Kings', 'Bowler', 'BOWL', 'BOWL', 'B', 77, 'INDIAN', 'Indian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/10952/khaleel-ahmed', 71.0, NULL, NULL, NULL, 89.0, 8.98, 26.16, NULL, NULL, NULL, 65, 61.0, 56.0, 82.0, NULL, NULL, NULL),
('0ed582ab-8d49-4943-a915-1da3e3a15e74', 83, 'Jason Holder', 'Gujarat Titans', 'Bowling Allrounder', 'AR', 'AR', 'C', 68, 'OVERSEAS', 'West Indian', 0.5, false, NULL, NULL, 2, 'https://www.cricbuzz.com/profiles/8313/jason-holder', 46.0, 259.0, NULL, NULL, 53.0, NULL, NULL, NULL, NULL, NULL, 53, NULL, NULL, NULL, 32.0, 45.0, 32.0),
('3f28afd1-1ca7-4d8d-a47d-ead97d61ca75', 31, 'Manish Pandey', 'Kolkata Knight Riders', 'Batsman', 'BAT', 'BAT_WK', 'B', 82, 'INDIAN', 'Indian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/1836/manish-pandey', 174.0, 3942.0, 121.52, 29.42, NULL, NULL, NULL, 76.0, 59.0, 73.0, 99, NULL, NULL, NULL, NULL, NULL, NULL),
('da97db01-cf02-42f9-97bb-183893fe6551', 91, 'Shahrukh Khan', 'Gujarat Titans', 'Batting Allrounder', 'AR', 'AR', 'C', 67, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/10226/shahrukh-khan', 55.0, 732.0, NULL, NULL, 1.0, NULL, NULL, NULL, NULL, NULL, 57, NULL, NULL, NULL, 56.0, 27.0, 27.0),
('cd95f8e6-8393-401b-b30f-2c35766ec3c6', 67, 'Ayush Badoni', 'Lucknow Super Giants', 'Batting Allrounder', 'AR', 'AR', 'B', 71, 'INDIAN', 'Indian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/13907/ayush-badoni', 56.0, 963.0, NULL, NULL, 4.0, NULL, NULL, NULL, NULL, NULL, 58, NULL, NULL, NULL, 63.0, 37.0, 37.0),
('d24911f7-5609-4dd7-b3ae-6782e31b7be3', 153, 'Urvil Patel', 'Chennai Super Kings', 'WK-Batsman', 'WK', 'BAT_WK', 'C', 56, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/13476/urvil-patel', 3.0, 68.0, 212.5, 22.67, NULL, NULL, NULL, 5.0, 99.0, 57.0, 31, NULL, NULL, NULL, NULL, NULL, NULL),
('7408cea3-60ed-4f29-bfb1-6a733e3400cb', 105, 'Mukesh Kumar', 'Delhi Capitals', 'Bowler', 'BOWL', 'BOWL', 'C', 64, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/10754/mukesh-kumar', 32.0, NULL, NULL, NULL, 36.0, 10.4, 30.61, NULL, NULL, NULL, 46, 27.0, 33.0, 73.0, NULL, NULL, NULL),
('5ec47e33-6eac-40c5-bc24-620ded89abf2', 86, 'Mayank Markande', 'Mumbai Indians', 'Bowler', 'BOWL', 'BOWL', 'C', 67, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/12627/mayank-markande', 37.0, NULL, NULL, NULL, 37.0, 8.91, 28.89, NULL, NULL, NULL, 48, 27.0, 57.0, 76.0, NULL, NULL, NULL),
('d1280668-66ce-49fb-bffc-058013ecc2f0', 38, 'Shardul Thakur', 'Mumbai Indians', 'Bowling Allrounder', 'AR', 'AR', 'B', 78, 'INDIAN', 'Indian', 1, false, NULL, NULL, 6, 'https://www.cricbuzz.com/profiles/8683/shardul-thakur', 105.0, 325.0, NULL, NULL, 107.0, NULL, NULL, NULL, NULL, NULL, 82, NULL, NULL, NULL, 38.0, 59.0, 38.0),
('aa2b658f-2e14-4b86-a7c1-822ffe448bae', 55, 'Mitchell Starc', 'Delhi Capitals', 'Bowler', 'BOWL', 'BOWL', 'B', 73, 'OVERSEAS', 'Australian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/7710/mitchell-starc', 51.0, NULL, NULL, NULL, 65.0, 8.61, 23.12, NULL, NULL, NULL, 55, 45.0, 62.0, 88.0, NULL, NULL, NULL),
('002b1b5e-54c2-4e60-9a28-42566aee4ff1', 131, 'Romario Shepherd', 'Royal Challengers Bengaluru', 'Bowling Allrounder', 'AR', 'AR', 'C', 60, 'OVERSEAS', 'West Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/13646/romario-shepherd', 18.0, 185.0, NULL, NULL, 10.0, NULL, NULL, NULL, NULL, NULL, 39, NULL, NULL, NULL, 52.0, 18.0, 18.0),
('c083f43d-f151-49dc-8a6c-67ae39fab6f1', 20, 'Jos Buttler', 'Gujarat Titans', 'WK-Batsman', 'WK', 'BAT_WK', 'A', 88, 'OVERSEAS', 'English', 2, false, NULL, NULL, 2, 'https://www.cricbuzz.com/profiles/2258/jos-buttler', 121.0, 4120.0, 149.39, 40.0, NULL, NULL, NULL, 79.0, 78.0, 99.0, 90, NULL, NULL, NULL, NULL, NULL, NULL),
('ad9227bd-8a76-4504-8507-40a3cc0f3a62', 120, 'Ravisrinivasan Sai Kishore', 'Gujarat Titans', 'Bowling Allrounder', 'AR', 'AR', 'C', 61, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/11595/ravisrinivasan-sai-kishore', 25.0, 18.0, NULL, NULL, 32.0, NULL, NULL, NULL, NULL, NULL, 42, NULL, NULL, NULL, 19.0, 41.0, 19.0),
('77e0541d-b97e-4e0e-8e82-85160825b473', 113, 'Marco Jansen', 'Punjab Kings', 'Bowling Allrounder', 'AR', 'AR', 'C', 62, 'OVERSEAS', 'South African', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/14565/marco-jansen', 35.0, 141.0, NULL, NULL, 36.0, NULL, NULL, NULL, NULL, NULL, 47, NULL, NULL, NULL, 26.0, 36.0, 26.0),
('47467a82-c6ee-4648-a0dd-e0237059fab4', 4, 'Sunil Narine', 'Kolkata Knight Riders', 'Bowling Allrounder', 'AR', 'AR', 'A', 98, 'OVERSEAS', 'West Indian', 2, false, NULL, NULL, 10, 'https://www.cricbuzz.com/profiles/2276/sunil-narine', 188.0, 1780.0, NULL, NULL, 192.0, NULL, NULL, NULL, NULL, NULL, 99, NULL, NULL, NULL, 84.0, 83.0, 83.0),
('c2c0b20c-f6f7-4a86-b81d-e8a7dd20c92d', 108, 'Rovman Powell', 'Kolkata Knight Riders', 'Batsman', 'BAT', 'BAT_WK', 'C', 63, 'OVERSEAS', 'West Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/11445/rovman-powell', 28.0, 365.0, 146.59, 18.25, NULL, NULL, NULL, 11.0, 76.0, 46.0, 44, NULL, NULL, NULL, NULL, NULL, NULL),
('f1321474-a53a-4ca5-8d89-010e84d45df9', 93, 'Washington Sundar', 'Gujarat Titans', 'Bowling Allrounder', 'AR', 'AR', 'C', 67, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/10945/washington-sundar', 66.0, 511.0, NULL, NULL, 39.0, NULL, NULL, NULL, NULL, NULL, 63, NULL, NULL, NULL, 42.0, 40.0, 40.0),
('952e798d-42df-443d-8d24-30e267221c0b', 146, 'Anshul Kamboj', 'Chennai Super Kings', 'Bowling Allrounder', 'AR', 'AR', 'C', 57, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/14598/anshul-kamboj', 11.0, 16.0, NULL, NULL, 10.0, NULL, NULL, NULL, NULL, NULL, 35, NULL, NULL, NULL, 21.0, 30.0, 21.0),
('b369db55-6a41-4273-9577-0a6d8941edc5', 145, 'Akash Maharaj Singh', 'Lucknow Super Giants', 'Bowler', 'BOWL', 'BOWL', 'C', 57, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/14696/akash-maharaj-singh', 10.0, NULL, NULL, NULL, 9.0, 9.54, 36.22, NULL, NULL, NULL, 35, 9.0, 47.0, 61.0, NULL, NULL, NULL),
('a8dae344-6b62-4a09-97d9-1963154ee67c', 71, 'Matheesha Pathirana', 'Kolkata Knight Riders', 'Bowler', 'BOWL', 'BOWL', 'B', 70, 'OVERSEAS', 'Sri Lankan', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/16458/matheesha-pathirana', 32.0, NULL, NULL, NULL, 47.0, 8.68, 21.62, NULL, NULL, NULL, 46, 34.0, 61.0, 92.0, NULL, NULL, NULL),
('ffa7d862-59dd-4efb-87e2-f1fcc424b160', 74, 'Devdutt Padikkal', 'Royal Challengers Bengaluru', 'Batsman', 'BAT', 'BAT_WK', 'B', 70, 'INDIAN', 'Indian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/13088/devdutt-padikkal', 74.0, 1806.0, 126.3, 25.44, NULL, NULL, NULL, 37.0, 62.0, 64.0, 67, NULL, NULL, NULL, NULL, NULL, NULL),
('12fd3429-a772-4ae4-b131-fb606830c58e', 124, 'Shubham Dubey', 'Rajasthan Royals', 'Batsman', 'BAT', 'BAT_WK', 'C', 61, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/19328/shubham-dubey', 13.0, 139.0, 163.53, 23.17, NULL, NULL, NULL, 6.0, 87.0, 58.0, 36, NULL, NULL, NULL, NULL, NULL, NULL),
('bd657050-6dbf-4cf5-9c52-35a8bfefe117', 68, 'Anrich Nortje', 'Lucknow Super Giants', 'Bowler', 'BOWL', 'BOWL', 'B', 71, 'OVERSEAS', 'South African', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/11427/anrich-nortje', 48.0, NULL, NULL, NULL, 61.0, 9.07, 27.16, NULL, NULL, NULL, 54, 43.0, 55.0, 80.0, NULL, NULL, NULL),
('e50ddc35-059e-4877-ab45-23599389caf9', 35, 'Deepak Chahar', 'Mumbai Indians', 'Bowler', 'BOWL', 'BOWL', 'B', 78, 'INDIAN', 'Indian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/7836/deepak-chahar', 95.0, NULL, NULL, NULL, 88.0, 8.14, 29.51, NULL, NULL, NULL, 77, 60.0, 70.0, 75.0, NULL, NULL, NULL),
('0e7d7ba2-b91f-4907-9b8d-0c441b32e8e0', 28, 'Kuldeep Yadav', 'Delhi Capitals', 'Bowler', 'BOWL', 'BOWL', 'B', 83, 'INDIAN', 'Indian', 1, false, NULL, NULL, 2, 'https://www.cricbuzz.com/profiles/8292/kuldeep-yadav', 98.0, NULL, NULL, NULL, 102.0, 8.04, 26.95, NULL, NULL, NULL, 79, 69.0, 71.0, 80.0, NULL, NULL, NULL),
('9278e241-90af-404d-9e5e-2852126b1ca5', 102, 'Angkrish Raghuvanshi', 'Kolkata Knight Riders', 'Batsman', 'BAT', 'BAT_WK', 'C', 65, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/22566/angkrish-raghuvanshi', 22.0, 463.0, 144.69, 28.94, NULL, NULL, NULL, 12.0, 75.0, 72.0, 41, NULL, NULL, NULL, NULL, NULL, NULL),
('caa8eb11-2062-426e-aa67-b8b7107e11da', 106, 'Sarfaraz Khan', 'Chennai Super Kings', 'Batsman', 'BAT', 'BAT_WK', 'C', 64, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/9429/sarfaraz-khan', 50.0, 585.0, 130.59, 22.5, NULL, NULL, NULL, 15.0, 65.0, 56.0, 55, NULL, NULL, NULL, NULL, NULL, NULL),
('33d31d19-6ac1-495e-82f1-29174ceba049', 52, 'Rahul Tripathi', 'Kolkata Knight Riders', 'Batsman', 'BAT', 'BAT_WK', 'B', 74, 'INDIAN', 'Indian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/9012/rahul-tripathi', 100.0, 2291.0, 137.85, 26.03, NULL, NULL, NULL, 46.0, 70.0, 65.0, 80, NULL, NULL, NULL, NULL, NULL, NULL),
('fc12af13-6900-49e2-ab19-b6ff64bc0535', 130, 'Sameer Rizvi', 'Delhi Capitals', 'Batsman', 'BAT', 'BAT_WK', 'C', 60, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/14700/sameer-rizvi', 13.0, 172.0, 140.99, 24.57, NULL, NULL, NULL, 7.0, 72.0, 61.0, 36, NULL, NULL, NULL, NULL, NULL, NULL),
('18740f30-f9a0-4d13-a67c-844c8f7ae1a0', 18, 'Rashid Khan', 'Gujarat Titans', 'Bowling Allrounder', 'AR', 'AR', 'A', 89, 'OVERSEAS', 'Afghan', 2, false, NULL, NULL, 8, 'https://www.cricbuzz.com/profiles/10738/rashid-khan', 136.0, 585.0, NULL, NULL, 158.0, NULL, NULL, NULL, NULL, NULL, 98, NULL, NULL, NULL, 51.0, 82.0, 51.0),
('9307a54c-a3ff-4e3c-849e-b543af41d680', 62, 'Shimron Hetmyer', 'Rajasthan Royals', 'Batsman', 'BAT', 'BAT_WK', 'B', 72, 'OVERSEAS', 'West Indian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/9789/shimron-hetmyer', 86.0, 1482.0, 151.85, 29.06, NULL, NULL, NULL, 31.0, 79.0, 72.0, 73, NULL, NULL, NULL, NULL, NULL, NULL),
('090869fe-0813-4a2c-a792-d467e0bc800a', 79, 'Prabhsimran Singh', 'Punjab Kings', 'WK-Batsman', 'WK', 'BAT_WK', 'C', 69, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/14254/prabhsimran-singh', 51.0, 1305.0, 151.93, 25.59, NULL, NULL, NULL, 28.0, 79.0, 64.0, 55, NULL, NULL, NULL, NULL, NULL, NULL),
('021c89cf-8040-49b3-a284-b05aa9f87891', 141, 'Eshan Malinga', 'Sunrisers Hyderabad', 'Bowler', 'BOWL', 'BOWL', 'C', 58, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/46926/eshan-malinga', 7.0, NULL, NULL, NULL, 13.0, 8.93, 18.31, NULL, NULL, NULL, 33, 12.0, 57.0, 99.0, NULL, NULL, NULL),
('03f16310-5975-4ad8-8623-983acbde5d68', 40, 'Rahul Chahar', 'Chennai Super Kings', 'Bowler', 'BOWL', 'BOWL', 'B', 77, 'INDIAN', 'Indian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/12087/rahul-chahar', 79.0, NULL, NULL, NULL, 75.0, 7.72, 28.67, NULL, NULL, NULL, 69, 52.0, 76.0, 77.0, NULL, NULL, NULL),
('e381a4b3-d9cd-40a1-ab24-8d1663fb0b55', 65, 'Tilak Varma', 'Mumbai Indians', 'Batsman', 'BAT', 'BAT_WK', 'B', 72, 'INDIAN', 'Indian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/14504/tilak-varma', 54.0, 1499.0, 144.42, 37.48, NULL, NULL, NULL, 31.0, 74.0, 93.0, 57, NULL, NULL, NULL, NULL, NULL, NULL),
('876feabb-59f3-48c4-83f4-bea2b3ef3ffe', 99, 'Yash Dayal', 'Royal Challengers Bengaluru', 'Bowler', 'BOWL', 'BOWL', 'C', 66, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/14172/yash-dayal', 43.0, NULL, NULL, NULL, 41.0, 9.58, 33.9, NULL, NULL, NULL, 51, 30.0, 46.0, 66.0, NULL, NULL, NULL),
('4bf729ec-c192-4b00-856b-c81972f63127', 16, 'Suryakumar Yadav', 'Mumbai Indians', 'Batsman', 'BAT', 'BAT_WK', 'A', 89, 'INDIAN', 'Indian', 2, false, NULL, NULL, 2, 'https://www.cricbuzz.com/profiles/7915/suryakumar-yadav', 166.0, 4311.0, 148.66, 35.05, NULL, NULL, NULL, 82.0, 77.0, 87.0, 99, NULL, NULL, NULL, NULL, NULL, NULL),
('c790f672-fe7b-4e6f-9e5c-1f07eed77e07', 138, 'Azmatullah Omarzai', 'Punjab Kings', 'Bowling Allrounder', 'AR', 'AR', 'C', 58, 'OVERSEAS', 'Afghan', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/13214/azmatullah-omarzai', 16.0, 99.0, NULL, NULL, 12.0, NULL, NULL, NULL, NULL, NULL, 38, NULL, NULL, NULL, 31.0, 25.0, 25.0),
('693286b8-fba4-41d4-bee5-33706e563188', 136, 'Arshad Khan', 'Gujarat Titans', 'Bowling Allrounder', 'AR', 'AR', 'C', 58, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/18637/arshad-khan', 19.0, 124.0, NULL, NULL, 12.0, NULL, NULL, NULL, NULL, NULL, 39, NULL, NULL, NULL, 39.0, 18.0, 18.0),
('861717d8-be6a-48e1-afda-d068ab2f4186', 22, 'Kagiso Rabada', 'Gujarat Titans', 'Bowler', 'BOWL', 'BOWL', 'A', 85, 'OVERSEAS', 'South African', 2, true, 'The Super Over Specialist (Grade A)', 'I burst onto the IPL scene by delivering a legendary, pinpoint Super Over yorker that even peak Andre Russell couldn’t touch. Known for my giant smile and terrifying pace, I formed half of the most feared South African bowling duo in Delhi before packing my bags for Punjab. Now, I’m bringing my fiery heat to the world''s biggest stadium to hunt wickets for the Titans. Who am I?', 2, 'https://www.cricbuzz.com/profiles/9585/kagiso-rabada', 84.0, NULL, NULL, NULL, 119.0, 8.62, 22.96, NULL, NULL, NULL, 72, 80.0, 62.0, 89.0, NULL, NULL, NULL),
('ac89b08d-8eb1-4ae1-977e-0ff91890d5d5', 72, 'Aiden Markram', 'Lucknow Super Giants', 'Batsman', 'BAT', 'BAT_WK', 'B', 70, 'OVERSEAS', 'South African', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/9582/aiden-markram', 57.0, 1440.0, 135.09, 31.3, NULL, NULL, NULL, 30.0, 68.0, 78.0, 58, NULL, NULL, NULL, NULL, NULL, NULL),
('7e6c3fc2-527f-44b1-bf83-97df7df673cb', 10, 'Harshal Patel', 'Sunrisers Hyderabad', 'Bowler', 'BOWL', 'BOWL', 'A', 94, 'INDIAN', 'Indian', 2, false, NULL, NULL, 6, 'https://www.cricbuzz.com/profiles/8175/harshal-patel', 119.0, NULL, NULL, NULL, 151.0, 8.86, 23.7, NULL, NULL, NULL, 89, 99.0, 58.0, 87.0, NULL, NULL, NULL),
('bf575334-cd9e-4aee-93f0-031d68617752', 90, 'Naman Dhir', 'Mumbai Indians', 'Batsman', 'BAT', 'BAT_WK', 'C', 67, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/36139/naman-dhir', 23.0, 392.0, 180.65, 28.0, NULL, NULL, NULL, 11.0, 99.0, 70.0, 41, NULL, NULL, NULL, NULL, NULL, NULL),
('822d01b3-0a37-459e-a062-8134763b12df', 116, 'Sherfane Rutherford', 'Mumbai Indians', 'Batting Allrounder', 'AR', 'AR', 'C', 62, 'OVERSEAS', 'West Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/13748/sherfane-rutherford', 23.0, 397.0, NULL, NULL, 1.0, NULL, NULL, NULL, NULL, NULL, 41, NULL, NULL, NULL, 48.0, 17.0, 17.0),
('db478908-3b57-4a71-9f46-868e9d3ecf5d', 25, 'Marcus Stoinis', 'Punjab Kings', 'Batting Allrounder', 'AR', 'AR', 'B', 83, 'OVERSEAS', 'Australian', 1, false, NULL, NULL, 4, 'https://www.cricbuzz.com/profiles/8989/marcus-stoinis', 109.0, 2026.0, NULL, NULL, 44.0, NULL, NULL, NULL, NULL, NULL, 84, NULL, NULL, NULL, 90.0, 37.0, 37.0),
('4f6e12cf-20a3-45ab-88fe-196b6856b32e', 110, 'Josh Inglis', 'Lucknow Super Giants', 'WK-Batsman', 'WK', 'BAT_WK', 'C', 63, 'OVERSEAS', 'Australian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/10637/josh-inglis', 11.0, 278.0, 162.58, 30.89, NULL, NULL, NULL, 9.0, 87.0, 77.0, 35, NULL, NULL, NULL, NULL, NULL, NULL),
('308c4b62-04e4-4d20-a5a7-822e90053e80', 134, 'Vipraj Nigam', 'Delhi Capitals', 'Bowler', 'BOWL', 'BOWL', 'C', 59, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/1431811/vipraj-nigam', 14.0, NULL, NULL, NULL, 11.0, 9.13, 32.36, NULL, NULL, NULL, 37, 10.0, 54.0, 69.0, NULL, NULL, NULL),
('8e7a0dc3-7cdf-4ad7-9754-ade4fa0220b9', 129, 'Anuj Rawat', 'Gujarat Titans', 'WK-Batsman', 'WK', 'BAT_WK', 'C', 60, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/13135/anuj-rawat', 24.0, 318.0, 119.11, 19.88, NULL, NULL, NULL, 10.0, 57.0, 50.0, 42, NULL, NULL, NULL, NULL, NULL, NULL),
('24451b82-bca6-4626-922a-3db92063fddf', 9, 'KL Rahul', 'Delhi Capitals', 'WK-Batsman', 'WK', 'BAT_WK', 'A', 95, 'INDIAN', 'Indian', 2, false, NULL, NULL, 4, 'https://www.cricbuzz.com/profiles/8733/kl-rahul', 145.0, 5222.0, 136.03, 46.21, NULL, NULL, NULL, 99.0, 69.0, 99.0, 99, NULL, NULL, NULL, NULL, NULL, NULL),
('bdaaf8b6-9c09-4126-b77c-24396912f76b', 140, 'Mukesh Choudhary', 'Chennai Super Kings', 'Bowler', 'BOWL', 'BOWL', 'C', 58, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/13184/mukesh-choudhary', 16.0, NULL, NULL, NULL, 17.0, 9.94, 30.71, NULL, NULL, NULL, 38, 14.0, 40.0, 72.0, NULL, NULL, NULL),
('fbbbc90f-bd8b-450f-af50-9ca91b185c64', 66, 'Philip Salt', 'Royal Challengers Bengaluru', 'WK-Batsman', 'WK', 'BAT_WK', 'B', 71, 'OVERSEAS', 'English', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/10479/philip-salt', 34.0, 1056.0, 175.71, 34.06, NULL, NULL, NULL, 23.0, 95.0, 84.0, 47, NULL, NULL, NULL, NULL, NULL, NULL),
('87b9b5ea-a37e-4d53-bda7-f305179b5d1c', 45, 'Shivam Dube', 'Chennai Super Kings', 'Batting Allrounder', 'AR', 'AR', 'B', 76, 'INDIAN', 'Indian', 1, false, NULL, NULL, 2, 'https://www.cricbuzz.com/profiles/11195/shivam-dube', 79.0, 1859.0, NULL, NULL, 5.0, NULL, NULL, NULL, NULL, NULL, 69, NULL, NULL, NULL, 88.0, 20.0, 20.0),
('dc466533-8bc8-4b15-aa4f-025eaaed1d53', 122, 'Ashutosh Sharma', 'Delhi Capitals', 'Batting Allrounder', 'AR', 'AR', 'C', 61, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/13497/ashutosh-sharma', 24.0, 393.0, NULL, NULL, 0.0, NULL, NULL, NULL, NULL, NULL, 42, NULL, NULL, NULL, 56.0, 0.0, 0.0),
('7d1610b8-0474-4a62-a862-5db7d9a30175', 8, 'MS Dhoni', 'Chennai Super Kings', 'WK-Batsman', 'WK', 'BAT_WK', 'A', 95, 'INDIAN', 'Indian', 2, false, NULL, NULL, 4, 'https://www.cricbuzz.com/profiles/265/ms-dhoni', 278.0, 5439.0, 137.46, 38.3, NULL, NULL, NULL, 99.0, 70.0, 95.0, 99, NULL, NULL, NULL, NULL, NULL, NULL),
('87f192e0-8998-42d9-bb32-2f5ab9e4a0ae', 48, 'Pat Cummins', 'Sunrisers Hyderabad', 'Bowler', 'BOWL', 'BOWL', 'B', 75, 'OVERSEAS', 'Australian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/8095/pat-cummins', 72.0, NULL, NULL, NULL, 79.0, 8.81, 30.04, NULL, NULL, NULL, 66, 54.0, 59.0, 74.0, NULL, NULL, NULL),
('9e9dd5ab-8b6c-49b1-8ad1-a76abf851677', 53, 'Prasidh Krishna', 'Gujarat Titans', 'Bowler', 'BOWL', 'BOWL', 'B', 74, 'INDIAN', 'Indian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/10551/prasidh-krishna', 66.0, NULL, NULL, NULL, 74.0, 8.77, 29.61, NULL, NULL, NULL, 63, 51.0, 59.0, 75.0, NULL, NULL, NULL),
('1c036446-43b7-4d3d-a97e-25dd1d8ba824', 75, 'Karun Nair', 'Delhi Capitals', 'Batsman', 'BAT', 'BAT_WK', 'B', 70, 'INDIAN', 'Indian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/8257/karun-nair', 84.0, 1694.0, 131.73, 23.86, NULL, NULL, NULL, 35.0, 66.0, 60.0, 72, NULL, NULL, NULL, NULL, NULL, NULL),
('8f660678-9bfd-4606-a354-223a71ba9674', 21, 'Krunal Pandya', 'Royal Challengers Bengaluru', 'Batting Allrounder', 'AR', 'AR', 'A', 86, 'INDIAN', 'Indian', 2, false, NULL, NULL, 4, 'https://www.cricbuzz.com/profiles/11311/krunal-pandya', 142.0, 1748.0, NULL, NULL, 93.0, NULL, NULL, NULL, NULL, NULL, 99, NULL, NULL, NULL, 77.0, 60.0, 60.0),
('b1475203-7636-495b-b9e5-c64385921ccb', 39, 'Nicholas Pooran', 'Lucknow Super Giants', 'WK-Batsman', 'WK', 'BAT_WK', 'B', 78, 'OVERSEAS', 'West Indian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/9406/nicholas-pooran', 90.0, 2293.0, 168.98, 34.22, NULL, NULL, NULL, 46.0, 91.0, 85.0, 75, NULL, NULL, NULL, NULL, NULL, NULL),
('53175187-9156-4017-9858-0c362d62e0ec', 2, 'Yuzvendra Chahal', 'Punjab Kings', 'Bowler', 'BOWL', 'BOWL', 'A', 99, 'INDIAN', 'Indian', 2, false, NULL, NULL, 10, 'https://www.cricbuzz.com/profiles/7910/yuzvendra-chahal', 174.0, NULL, NULL, NULL, 221.0, 7.96, 22.77, NULL, NULL, NULL, 99, 99.0, 73.0, 89.0, NULL, NULL, NULL),
('a6ef794b-7694-48ea-a05d-2d9a0a47cd96', 27, 'Shreyas Iyer', 'Punjab Kings', 'Batsman', 'BAT', 'BAT_WK', 'B', 83, 'INDIAN', 'Indian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/9428/shreyas-iyer', 132.0, 3731.0, 133.35, 34.23, NULL, NULL, NULL, 72.0, 67.0, 85.0, 96, NULL, NULL, NULL, NULL, NULL, NULL),
('b09b90cd-a33c-4abd-830a-b9c21fd6e649', 14, 'Ajinkya Rahane', 'Kolkata Knight Riders', 'Batsman', 'BAT', 'BAT_WK', 'A', 91, 'INDIAN', 'Indian', 2, false, NULL, NULL, 4, 'https://www.cricbuzz.com/profiles/1447/ajinkya-rahane', 198.0, 5032.0, 125.02, 30.5, NULL, NULL, NULL, 95.0, 61.0, 76.0, 99, NULL, NULL, NULL, NULL, NULL, NULL),
('b1138b4c-2d33-42d9-88b4-ca11e92dee03', 56, 'Josh Hazlewood', 'Royal Challengers Bengaluru', 'Bowler', 'BOWL', 'BOWL', 'B', 73, 'OVERSEAS', 'Australian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/6258/josh-hazlewood', 39.0, NULL, NULL, NULL, 57.0, 8.28, 20.98, NULL, NULL, NULL, 49, 40.0, 67.0, 93.0, NULL, NULL, NULL),
('216411d7-1e2b-4a94-b639-68cf16323c41', 12, 'Trent Boult', 'Mumbai Indians', 'Bowler', 'BOWL', 'BOWL', 'A', 92, 'OVERSEAS', 'New Zealander', 2, false, NULL, NULL, 4, 'https://www.cricbuzz.com/profiles/8117/trent-boult', 119.0, NULL, NULL, NULL, 143.0, 8.38, 26.2, NULL, NULL, NULL, 89, 96.0, 66.0, 82.0, NULL, NULL, NULL),
('bec5ed16-cc46-4b14-a041-cbf4fb59c979', 148, 'Vignesh Puthur', 'Rajasthan Royals', 'Bowler', 'BOWL', 'BOWL', 'C', 57, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/1447337/vignesh-puthur', 5.0, NULL, NULL, NULL, 6.0, 9.08, 18.17, NULL, NULL, NULL, 32, 7.0, 54.0, 99.0, NULL, NULL, NULL),
('1c31e6e8-6337-49f4-95dd-8c165d4ad91a', 76, 'Tristan Stubbs', 'Delhi Capitals', 'WK-Batsman', 'WK', 'BAT_WK', 'B', 70, 'OVERSEAS', 'South African', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/19243/tristan-stubbs', 32.0, 705.0, 163.2, 41.47, NULL, NULL, NULL, 17.0, 87.0, 99.0, 46, NULL, NULL, NULL, NULL, NULL, NULL),
('f4401a86-e6f8-4d3c-971e-e58a80de083b', 98, 'Shivam Mavi', 'Sunrisers Hyderabad', 'Bowler', 'BOWL', 'BOWL', 'C', 66, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/12345/shivam-mavi', 32.0, NULL, NULL, NULL, 30.0, 8.71, 31.4, NULL, NULL, NULL, 46, 23.0, 60.0, 71.0, NULL, NULL, NULL),
('42f1a8a1-37f6-4b2b-9ba1-68265cd0f9fa', 70, 'Venkatesh Iyer', 'Royal Challengers Bengaluru', 'Batting Allrounder', 'AR', 'AR', 'B', 70, 'INDIAN', 'Indian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/10917/venkatesh-iyer', 61.0, 1468.0, NULL, NULL, 3.0, NULL, NULL, NULL, NULL, NULL, 60, NULL, NULL, NULL, 77.0, 16.0, 16.0),
('0aa4f1bb-c8aa-49f9-a2b3-687f171498d4', 156, 'Matthew Short', 'Chennai Super Kings', 'Batsman', 'BAT', 'BAT_WK', 'C', 55, 'OVERSEAS', 'Australian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/9456/matthew-short', 6.0, 117.0, 127.18, 19.5, NULL, NULL, NULL, 6.0, 63.0, 49.0, 33, NULL, NULL, NULL, NULL, NULL, NULL),
('76dbf014-2c8e-413e-bf5e-69432fd3148c', 15, 'Sanju Samson', 'Chennai Super Kings', 'WK-Batsman', 'WK', 'BAT_WK', 'A', 89, 'INDIAN', 'Indian', 2, false, NULL, NULL, 2, 'https://www.cricbuzz.com/profiles/8271/sanju-samson', 176.0, 4704.0, 139.05, 30.75, NULL, NULL, NULL, 89.0, 71.0, 76.0, 99, NULL, NULL, NULL, NULL, NULL, NULL),
('4909e1d7-3834-4515-97fe-3dee9484bb7d', 121, 'Suyash Sharma', 'Royal Challengers Bengaluru', 'Bowler', 'BOWL', 'BOWL', 'C', 61, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/36487/suyash-sharma', 27.0, NULL, NULL, NULL, 18.0, 8.75, 45.22, NULL, NULL, NULL, 43, 15.0, 60.0, 41.0, NULL, NULL, NULL),
('f00bf997-2780-4671-a6fa-12bb0960572f', 7, 'Ravindra Jadeja', 'Rajasthan Royals', 'Bowling Allrounder', 'AR', 'AR', 'A', 95, 'INDIAN', 'Indian', 2, false, NULL, NULL, 8, 'https://www.cricbuzz.com/profiles/587/ravindra-jadeja', 254.0, 3260.0, NULL, NULL, 170.0, NULL, NULL, NULL, NULL, NULL, 99, NULL, NULL, NULL, 85.0, 78.0, 78.0),
('1f49219d-30ba-455c-8957-26c240b6abfd', 104, 'Lungi Ngidi', 'Delhi Capitals', 'Bowler', 'BOWL', 'BOWL', 'C', 64, 'OVERSEAS', 'South African', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/9603/lungi-ngidi', 16.0, NULL, NULL, NULL, 29.0, 8.53, 18.24, NULL, NULL, NULL, 38, 22.0, 63.0, 99.0, NULL, NULL, NULL),
('ceae5983-917d-4b06-ab04-829ed91f2f06', 77, 'Rinku Singh', 'Kolkata Knight Riders', 'Batsman', 'BAT', 'BAT_WK', 'C', 69, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/10896/rinku-singh', 58.0, 1099.0, 145.18, 30.53, NULL, NULL, NULL, 24.0, 75.0, 76.0, 59, NULL, NULL, NULL, NULL, NULL, NULL),
('d7a7e805-1b82-4282-8268-de25a36c1176', 24, 'Varun Chakaravarthy', 'Kolkata Knight Riders', 'Bowler', 'BOWL', 'BOWL', 'B', 84, 'INDIAN', 'Indian', 1, false, NULL, NULL, 2, 'https://www.cricbuzz.com/profiles/12926/varun-chakaravarthy', 83.0, NULL, NULL, NULL, 100.0, 7.58, 23.85, NULL, NULL, NULL, 71, 68.0, 79.0, 87.0, NULL, NULL, NULL),
('b3f181a3-0e3f-499d-9e6d-853a12d797ef', 87, 'Tushar Deshpande', 'Rajasthan Royals', 'Bowler', 'BOWL', 'BOWL', 'C', 67, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/11307/tushar-deshpande', 46.0, NULL, NULL, NULL, 51.0, 9.84, 31.04, NULL, NULL, NULL, 53, 36.0, 42.0, 72.0, NULL, NULL, NULL),
('8521ab9a-c4e4-4285-b04d-0a30cdad1547', 59, 'Rahul Tewatia', 'Gujarat Titans', 'Batting Allrounder', 'AR', 'AR', 'B', 73, 'INDIAN', 'Indian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/9693/rahul-tewatia', 108.0, 1112.0, NULL, NULL, 32.0, NULL, NULL, NULL, NULL, NULL, 84, NULL, NULL, NULL, 64.0, 38.0, 38.0),
('00b082d3-9f36-490e-ba88-52ce13fd48e1', 81, 'Harpreet Brar', 'Punjab Kings', 'Bowler', 'BOWL', 'BOWL', 'C', 68, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/14452/harpreet-brar', 49.0, NULL, NULL, NULL, 35.0, 8.03, 31.0, NULL, NULL, NULL, 54, 26.0, 71.0, 72.0, NULL, NULL, NULL),
('f090e2b4-97a5-46ee-ac17-41e34dc7fe43', 1, 'Virat Kohli', 'Royal Challengers Bengaluru', 'Batsman', 'BAT', 'BAT_WK', 'A', 99, 'INDIAN', 'Indian', 2, false, NULL, NULL, 10, 'https://www.cricbuzz.com/profiles/1413/virat-kohli', 267.0, 8661.0, 132.86, 39.55, NULL, NULL, NULL, 99.0, 67.0, 98.0, 99, NULL, NULL, NULL, NULL, NULL, NULL),
('38b9615b-fdb9-490b-b096-3162e30bbacd', 49, 'Ravi Bishnoi', 'Rajasthan Royals', 'Bowler', 'BOWL', 'BOWL', 'B', 75, 'INDIAN', 'Indian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/14659/ravi-bishnoi', 77.0, NULL, NULL, NULL, 72.0, 8.22, 31.07, NULL, NULL, NULL, 68, 50.0, 68.0, 72.0, NULL, NULL, NULL),
('c196238a-1dae-4606-9efd-0bdc3a00dcfb', 151, 'Dushmantha Chameera', 'Delhi Capitals', 'Bowler', 'BOWL', 'BOWL', 'C', 56, 'OVERSEAS', 'Sri Lankan', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/8393/dushmantha-chameera', 19.0, NULL, NULL, NULL, 13.0, 9.73, 46.38, NULL, NULL, NULL, 39, 12.0, 44.0, 39.0, NULL, NULL, NULL),
('73b64d84-1c0f-4cdc-8257-6d3a2a958d20', 5, 'Bhuvneshwar Kumar', 'Royal Challengers Bengaluru', 'Bowler', 'BOWL', 'BOWL', 'A', 98, 'INDIAN', 'Indian', 2, false, NULL, NULL, 8, 'https://www.cricbuzz.com/profiles/1726/bhuvneshwar-kumar', 190.0, NULL, NULL, NULL, 198.0, 7.69, 27.33, NULL, NULL, NULL, 99, 99.0, 77.0, 80.0, NULL, NULL, NULL);

INSERT INTO "AuctionPlayer" (id, player_id, status) VALUES
('d2eb8540-d1b5-4bad-b702-57dd03b89e02', 'a3946b74-9fba-4689-a6fa-8d4c2b43875b', 'UNSOLD'),
('0b07210d-a3ee-4c13-8966-19d66255f1fc', '83bfc46a-90ce-40e9-80b0-14983f67e2f5', 'UNSOLD'),
('5d26e171-e7de-41c2-b40b-db0794b5ac92', '456555e6-0107-4dd9-8478-776821b563e0', 'UNSOLD'),
('9423e080-69ff-4f1d-a7df-905855e22f4e', 'a042c540-951a-4324-80ba-19b83adacda7', 'UNSOLD'),
('657dc0f7-aef6-441c-9baa-1e19841808d6', 'ac561c3b-3818-4845-88a7-940090f82c4a', 'UNSOLD'),
('85e97812-5fc0-433e-a059-f9a83b14e881', 'da65b344-a67e-423b-9e4d-0ed8b39722de', 'UNSOLD'),
('cd62ab97-bace-47a1-905b-cae6455dd23c', '2fe541a6-ac78-423d-840f-f1728273739b', 'UNSOLD'),
('552e9b22-867f-4d54-9291-620e5ba52051', 'd18de589-b119-4038-b25d-afba997b561e', 'UNSOLD'),
('e87ef9f5-7506-4284-ba27-0dc942f4d672', 'f6859668-42ad-4a1d-a272-b03434069d85', 'UNSOLD'),
('0984787e-9d57-49bc-83f0-ba990f170804', 'd8a551b8-cb30-4cd2-846e-9814fa54d20e', 'UNSOLD'),
('10c0ea96-d2c1-42ab-980d-f16fce5adc07', 'b0951b0f-3c08-46c9-90f4-34babd903c90', 'UNSOLD'),
('4f817c10-4589-4fe2-919c-c3d5508a5ab0', '3f1e8fb5-9682-4833-b312-dd6883d2b59e', 'UNSOLD'),
('0f29e9f9-3019-4fd7-a3da-6455c09d9194', '24ed192f-7162-4329-a965-a4bf5315e4e8', 'UNSOLD'),
('f0dc0b09-a55f-439c-a6bd-fa1e2ccbcad1', 'b1e7ed9b-97dc-404c-8e4b-ca725225a00a', 'UNSOLD'),
('c0a24afb-e627-4e13-9939-33f9548c7bf1', '0062df71-85f6-4400-83e9-0f7941b7fc8a', 'UNSOLD'),
('dcce99f3-6843-4a2c-9cc3-0f8674ef5e12', '1f2d4109-4971-4475-99aa-b8643f2e8a98', 'UNSOLD'),
('56b4546f-0ac7-478c-8fdf-602823372d00', 'ddff0c92-dc3c-439d-a98e-2c615a4bee5e', 'UNSOLD'),
('245e789e-cff0-4f66-8886-2baba2af88cc', '9e9f004f-950d-441b-a039-63b765dee692', 'UNSOLD'),
('106309ae-c715-4efe-88f3-1ffbfa58a33b', 'e5bafdc7-9e62-439a-8839-7dedc647261a', 'UNSOLD'),
('e4a266a2-18f2-480a-aabb-e1b1c5335c8c', 'c3fed97e-e15a-4f04-99be-1efed761671a', 'UNSOLD'),
('2e97f815-67cf-413a-a070-c1beceeeab42', 'f2182dd2-589d-4e11-b299-5064510d3476', 'UNSOLD'),
('cf2d95f8-c739-45ac-946b-aa4f7f71fe89', '91510bc2-a050-4bea-a9c6-c7d0c6591033', 'UNSOLD'),
('92e56980-ae73-45c8-91b2-c0f38c2efc5e', 'e957d068-2796-4943-8797-f4f23a56c5f2', 'UNSOLD'),
('e1973100-6a0d-44f1-a9ac-fd393a5c982d', 'b60644be-5d74-447f-8f49-03f92a389018', 'UNSOLD'),
('124dbdc9-c594-43f7-9c74-9799f3a647b9', 'a99580a3-300b-47d1-8e1c-a227a9692487', 'UNSOLD'),
('066fcbb9-63ba-4366-a2e6-ff26b6dd07dd', '77325df4-4a9d-4c84-94c0-304c8604d22b', 'UNSOLD'),
('cb7a5e08-c323-4d9a-81aa-e7f93dcf810e', '675a3bf9-b16d-4a29-aee1-4bb5ec8cec5a', 'UNSOLD'),
('a796bf77-de3e-408a-9a02-3326c570a9e3', '5cca6b6d-e618-4287-98c1-6ff10d68c646', 'UNSOLD'),
('b1d01584-a60f-453b-8eca-1093adc25ec4', '5e6f66c0-976f-43da-b664-b6a75e5e508f', 'UNSOLD'),
('b393a69e-1ca5-4ef1-8f9b-261f99a51ca7', 'adcee4e3-c7f9-4501-a20d-014658995863', 'UNSOLD'),
('c6fb664f-3445-4a6b-b4e4-c765fc0d8bba', 'caf6010e-f84e-422d-9d3a-8654a699995c', 'UNSOLD'),
('06ea5821-c356-424b-9a8a-a2be649b6dd0', '3be49f0b-aa81-469d-b56b-9f699236976a', 'UNSOLD'),
('28507f7f-5096-4b29-abba-a4a84fd04bf0', '5cdce19f-7316-455c-9e63-b7679a5f0693', 'UNSOLD'),
('86414052-de15-4ca0-915d-57eb8847c50d', 'db35e715-8231-442b-a03e-37401d30e0d4', 'UNSOLD'),
('4b9543ad-537d-4b8c-bede-2f84ac7cd4ee', '805f2c04-c31c-419a-86ba-6111c56a00b2', 'UNSOLD'),
('d98ae591-6be7-4156-bc58-48c3373c020e', 'ea3b9c0d-08b3-40ec-9539-0c36f7f24f1d', 'UNSOLD'),
('d73b0786-4ad2-4a6b-9974-939a6dcf1c26', 'dc753bff-6611-4261-a45a-1545d72f4946', 'UNSOLD'),
('def14aa3-bc14-4742-bc43-922829654cac', '1a6cf871-9dca-4a8e-8ea4-5fe221949c44', 'UNSOLD'),
('e2dd307e-cfa6-4ff2-9a55-3a941d956ea5', '12105c1c-3bc0-4059-af9b-5764e9bbcc99', 'UNSOLD'),
('63e9d4b3-52aa-4e37-9af6-5de9c5936443', '3bb74ae5-f0a1-4178-a1da-1c5e6763fded', 'UNSOLD'),
('94a84e91-1c79-408e-b5e4-6eaeb70c3e48', '18d26609-3e49-49ed-b6b0-6c93534e0405', 'UNSOLD'),
('60d9c59b-2c76-4085-8e2f-19d64eb7a518', 'fb4da53d-3df8-431f-b82d-ab52a680502f', 'UNSOLD'),
('203b63a3-dfc3-45a9-9b2a-fd51e9b7ef67', '8ef7f5ca-2440-447d-a125-7a5e6c6ebe89', 'UNSOLD'),
('cc9eb032-c1fd-42af-8f06-d550e18f1a18', '05b94bb9-1630-46ee-aa55-2ca2729a1c02', 'UNSOLD'),
('9e0113e3-b2f6-4641-8906-79556a851d56', 'ca0632d4-e42f-4e47-9a84-85847869d148', 'UNSOLD'),
('55dbd984-6a60-477f-820d-b29c8f68f195', '0880c773-dbbb-441d-bb6b-c2ffd9710029', 'UNSOLD'),
('296312ce-e9da-4450-8f06-3bcb385cf21b', '4286fb43-1d63-4372-a1b8-0e0a6cc85112', 'UNSOLD'),
('c3384dbc-c852-42b7-a36d-048648e729b5', 'ac469b7e-0aaf-4fe5-ac6a-25fbf1a04ca1', 'UNSOLD'),
('8d0a0bc4-8167-41db-846d-5916e358afa9', '7c0caf2b-f990-4a36-979a-1875b10c23e6', 'UNSOLD'),
('3ac4dad9-d314-47e6-b71c-6f677b8ec18b', '71b291ce-ceed-4b6e-a45f-bd04e8070e0a', 'UNSOLD'),
('a3e9a6bc-c884-4a45-bc10-33746606f02c', 'd0bd331b-e8cc-4657-81dd-a8e1d19a84f2', 'UNSOLD'),
('3f55fd5e-668f-45e1-8b9f-24c38ea73fcc', '1637b9a9-628f-4490-baa5-5c64761ddfe6', 'UNSOLD'),
('a71a19ad-1ddd-4621-8cc7-9befcf15e899', '305c6f3c-b2cb-4052-a961-47e4ee2f9277', 'UNSOLD'),
('8a9dda76-1336-49b2-a446-572c79fc7416', '7ed29c8a-d089-4501-bbb6-1179af3bd4b9', 'UNSOLD'),
('bea8d90e-b3bd-45b7-9c42-2f9da2fde77f', '098f5230-e2fb-432c-bf01-4c45b8843f5e', 'UNSOLD'),
('5b6c6c09-3d36-47c1-9901-b455ad11d64f', '428d12a5-5662-43d6-913b-d67090ac1b68', 'UNSOLD'),
('834d2cb3-30e8-49be-b9bc-a2bed597e77f', '001527c9-92ae-410b-924d-98a93dda9746', 'UNSOLD'),
('1455537f-005a-43ea-80b1-b4f3f154b7fe', 'fd529108-da77-41d1-aa00-9dc3632dadd6', 'UNSOLD'),
('1518a8d9-8456-49d2-b553-f2bca562f1ab', '2918ddb2-8699-4fe9-93f3-b5808a31f399', 'UNSOLD'),
('fdda44fb-7463-4a77-957e-57aacb616619', 'a00ab5ad-f8bf-4d09-8ea8-0889cd6f139f', 'UNSOLD'),
('73fd5a6d-d8d5-4c3b-8dd2-19fac6113118', '2494ee1a-a8aa-4263-a776-620090745f06', 'UNSOLD'),
('6f1e319c-08af-4ca9-b4f4-23e498515011', '76c3bd05-eab2-46e8-a1f2-8252e3a1045c', 'UNSOLD'),
('58320b89-0c48-4374-8683-965a123ffe94', '59d1d7c3-9ad1-4da7-b3c3-6304645dc908', 'UNSOLD'),
('6583eedf-f2b7-4e29-9d9b-5c8321ac0492', 'f45567a5-1804-43ec-9ce0-decac7e5b5cc', 'UNSOLD'),
('8740329f-2ade-4d61-8b9b-4f546a6913f7', '8db9f605-62d2-4ab2-ba0e-fd469f3ec71b', 'UNSOLD'),
('8ac92e37-1f84-40c3-aa9d-bcc8b974d0e9', 'ad594da7-9679-4fb2-97f2-2543e3013557', 'UNSOLD'),
('321c8971-081e-453d-9841-3fe9da1fcb1a', '8ca3d793-5559-4056-af4d-950ff5b6c141', 'UNSOLD'),
('6797f3b4-e8ed-4b10-82da-5743c47aa567', '78de0983-36c2-408a-9261-8f0b68622f44', 'UNSOLD'),
('458a69e7-c4ba-49a6-93da-78986d6f0ec0', '387db1e3-b44c-4c8b-920d-ef49bf00a941', 'UNSOLD'),
('187fa130-13ae-4afa-9ff8-dfaa97f17fa3', '512ca56e-fa51-4dba-9e4c-9e536233ba87', 'UNSOLD'),
('fbe78971-5277-4a6a-8b62-ffe4dd97bb84', '16b5bb97-6b05-4c85-8bd9-7fe21a853cc2', 'UNSOLD'),
('321bf497-2ffc-4ba4-be62-bfaa52b845a9', '5833d939-e2f0-42ec-bb87-e3ef972d95f6', 'UNSOLD'),
('d71b11a5-cf50-44e6-b43a-4ec7129ce2bf', '3d65ab42-52df-4587-be40-e6e4d7adceaa', 'UNSOLD'),
('8c69cf2d-6da6-4892-b84c-6a46b9b04d2e', '5806cc6a-7e69-41a9-8cbe-818ac4563e72', 'UNSOLD'),
('be47371f-3f43-49f8-8d1c-27cc79622a3d', 'edecf274-71ef-4507-95d9-3a968e68bba9', 'UNSOLD'),
('56804255-2407-4bcc-adc3-7ae6a9d24b3e', '575c20c2-5342-4a24-8f65-28095977bb5f', 'UNSOLD'),
('9c546ec6-e001-4981-8a19-c5e30fd2f6b8', '10fef280-ad03-4f22-acfd-e56db2386265', 'UNSOLD'),
('6971082a-91ba-4c35-93d6-79bf4810a3cf', '001420db-2cdf-43d7-8827-73ca2fd2cce2', 'UNSOLD'),
('ecd6cffd-f9e5-4a04-a363-4e9e1f9c6a74', '0ed582ab-8d49-4943-a915-1da3e3a15e74', 'UNSOLD'),
('a6e7f712-b413-4677-86d8-b9bac60a864d', '3f28afd1-1ca7-4d8d-a47d-ead97d61ca75', 'UNSOLD'),
('0a2690b0-0d74-4ee3-a9d1-b80a42d52599', 'da97db01-cf02-42f9-97bb-183893fe6551', 'UNSOLD'),
('e64ce7c7-8c1e-4611-8bfe-c4dcaff19ef6', 'cd95f8e6-8393-401b-b30f-2c35766ec3c6', 'UNSOLD'),
('554b298b-2ba5-4332-a048-02ed4230acba', 'd24911f7-5609-4dd7-b3ae-6782e31b7be3', 'UNSOLD'),
('a68ca5b0-7ff2-42e3-a4ad-85e948b58e99', '7408cea3-60ed-4f29-bfb1-6a733e3400cb', 'UNSOLD'),
('8dee416a-993a-43bf-ab26-3ae400535497', '5ec47e33-6eac-40c5-bc24-620ded89abf2', 'UNSOLD'),
('ea9bbfeb-9f75-4755-9a9c-1f2e7594881d', 'd1280668-66ce-49fb-bffc-058013ecc2f0', 'UNSOLD'),
('594202b5-0cff-42be-827c-6b1ac2de51d3', 'aa2b658f-2e14-4b86-a7c1-822ffe448bae', 'UNSOLD'),
('2967072c-97ed-4f6c-8da6-22608007671a', '002b1b5e-54c2-4e60-9a28-42566aee4ff1', 'UNSOLD'),
('72864262-d6a5-4828-a435-c0e88edb69d5', 'c083f43d-f151-49dc-8a6c-67ae39fab6f1', 'UNSOLD'),
('1b7561f8-7ca1-4d1c-9609-104631acdb48', 'ad9227bd-8a76-4504-8507-40a3cc0f3a62', 'UNSOLD'),
('459a1e70-07b9-46fb-9d4c-80e64bf226bb', '77e0541d-b97e-4e0e-8e82-85160825b473', 'UNSOLD'),
('16bf1fbd-76e5-41d1-9293-9997b13593b3', '47467a82-c6ee-4648-a0dd-e0237059fab4', 'UNSOLD'),
('7cf6dacc-81bd-4a09-b2b5-299e258452b1', 'c2c0b20c-f6f7-4a86-b81d-e8a7dd20c92d', 'UNSOLD'),
('414248ca-d62b-43f3-aff1-94b00c729824', 'f1321474-a53a-4ca5-8d89-010e84d45df9', 'UNSOLD'),
('fcedcaee-1038-4cdc-a818-2689bf7d3590', '952e798d-42df-443d-8d24-30e267221c0b', 'UNSOLD'),
('3b92851b-903e-4a4d-8099-464e28eed2a9', 'b369db55-6a41-4273-9577-0a6d8941edc5', 'UNSOLD'),
('b01aa49f-bb77-4206-9954-918ca86797d3', 'a8dae344-6b62-4a09-97d9-1963154ee67c', 'UNSOLD'),
('b085e95b-4090-47ad-9b17-9484cec8a6d9', 'ffa7d862-59dd-4efb-87e2-f1fcc424b160', 'UNSOLD'),
('ba9a8082-624b-4db8-bccc-f5f6898376c5', '12fd3429-a772-4ae4-b131-fb606830c58e', 'UNSOLD'),
('e0ed027f-e46b-49e8-9bf6-4a41ca09b9e9', 'bd657050-6dbf-4cf5-9c52-35a8bfefe117', 'UNSOLD'),
('2066bcf4-4cba-49aa-b628-a069e1c93396', 'e50ddc35-059e-4877-ab45-23599389caf9', 'UNSOLD'),
('fa8b310c-4e8c-48e1-ad0d-eaa629334c7a', '0e7d7ba2-b91f-4907-9b8d-0c441b32e8e0', 'UNSOLD'),
('7b3a708e-794f-4314-99b5-1b372f65492b', '9278e241-90af-404d-9e5e-2852126b1ca5', 'UNSOLD'),
('e2814231-f2ab-42f1-b203-bc41ea6e6dd6', 'caa8eb11-2062-426e-aa67-b8b7107e11da', 'UNSOLD'),
('05150374-1aec-44a6-9162-2b58c9331396', '33d31d19-6ac1-495e-82f1-29174ceba049', 'UNSOLD'),
('87f50a8f-0a2d-4b85-ae60-c393a8198f78', 'fc12af13-6900-49e2-ab19-b6ff64bc0535', 'UNSOLD'),
('077bd9ee-a9ac-4087-a7b3-cd600fcae08e', '18740f30-f9a0-4d13-a67c-844c8f7ae1a0', 'UNSOLD'),
('b2a83cb7-826f-4d1c-94c6-bb5a83926cd9', '9307a54c-a3ff-4e3c-849e-b543af41d680', 'UNSOLD'),
('42a6d172-bcdb-4620-9b42-52a1d5078fe9', '090869fe-0813-4a2c-a792-d467e0bc800a', 'UNSOLD'),
('7019f9e5-0811-49f6-9fa5-0e26e154a802', '021c89cf-8040-49b3-a284-b05aa9f87891', 'UNSOLD'),
('4868062b-1176-4f53-b406-4537010833d8', '03f16310-5975-4ad8-8623-983acbde5d68', 'UNSOLD'),
('1f663b94-6a57-4644-8379-29aef6908eb2', 'e381a4b3-d9cd-40a1-ab24-8d1663fb0b55', 'UNSOLD'),
('4074c9ee-60dc-44d0-acc4-28a98671d1f5', '876feabb-59f3-48c4-83f4-bea2b3ef3ffe', 'UNSOLD'),
('6e4dd728-c4f5-4ef6-8f4c-9d71e251a0b5', '4bf729ec-c192-4b00-856b-c81972f63127', 'UNSOLD'),
('0ee782c5-ade0-48bd-af4e-9971cad46378', 'c790f672-fe7b-4e6f-9e5c-1f07eed77e07', 'UNSOLD'),
('385b7668-62c4-4a67-8390-d8c89d991003', '693286b8-fba4-41d4-bee5-33706e563188', 'UNSOLD'),
('b5583712-5896-4d0e-a7ce-aad4e430e14e', '861717d8-be6a-48e1-afda-d068ab2f4186', 'UNSOLD'),
('5aef8f6f-b214-4faf-8fbb-09ad059c0334', 'ac89b08d-8eb1-4ae1-977e-0ff91890d5d5', 'UNSOLD'),
('f07c7c59-d298-4917-8396-151938717996', '7e6c3fc2-527f-44b1-bf83-97df7df673cb', 'UNSOLD'),
('4fda3ae1-16ca-4cc0-a1c8-11ff649c14c4', 'bf575334-cd9e-4aee-93f0-031d68617752', 'UNSOLD'),
('dcde2bf3-8ce1-4064-b25c-d371f4e782f7', '822d01b3-0a37-459e-a062-8134763b12df', 'UNSOLD'),
('613692fc-d9f7-438e-ace9-2659f7bb493a', 'db478908-3b57-4a71-9f46-868e9d3ecf5d', 'UNSOLD'),
('58a29bee-222f-4d70-a06d-63460a51d0da', '4f6e12cf-20a3-45ab-88fe-196b6856b32e', 'UNSOLD'),
('d0612794-beb3-4233-9dbb-b80f1f764283', '308c4b62-04e4-4d20-a5a7-822e90053e80', 'UNSOLD'),
('f74a135d-80d8-41ea-9f50-683a37afa429', '8e7a0dc3-7cdf-4ad7-9754-ade4fa0220b9', 'UNSOLD'),
('b9b15583-9c89-4c70-b7e9-913aa05b958b', '24451b82-bca6-4626-922a-3db92063fddf', 'UNSOLD'),
('934b3424-6cdc-4bd6-868d-3ef5d4896e52', 'bdaaf8b6-9c09-4126-b77c-24396912f76b', 'UNSOLD'),
('e7c6f687-39ae-47bb-85d2-d52258bb5646', 'fbbbc90f-bd8b-450f-af50-9ca91b185c64', 'UNSOLD'),
('19af0e06-ac14-44c7-9232-0d049cacee6f', '87b9b5ea-a37e-4d53-bda7-f305179b5d1c', 'UNSOLD'),
('964e06f2-2a6d-423f-82c1-8496dedfdaad', 'dc466533-8bc8-4b15-aa4f-025eaaed1d53', 'UNSOLD'),
('69df4bf5-715c-4936-aefc-c8cef0a144c9', '7d1610b8-0474-4a62-a862-5db7d9a30175', 'UNSOLD'),
('8eddeade-f243-47f1-a8d4-9f22ac86eee9', '87f192e0-8998-42d9-bb32-2f5ab9e4a0ae', 'UNSOLD'),
('96457e7a-dc6f-42b8-8eb9-43ec3d99be23', '9e9dd5ab-8b6c-49b1-8ad1-a76abf851677', 'UNSOLD'),
('737fa8af-d27b-4286-b2a0-1fc34f85fc90', '1c036446-43b7-4d3d-a97e-25dd1d8ba824', 'UNSOLD'),
('c202db82-c60e-445a-b1dd-28b0b688200d', '8f660678-9bfd-4606-a354-223a71ba9674', 'UNSOLD'),
('2fd6d657-fecf-4688-af77-6b2cbdf50626', 'b1475203-7636-495b-b9e5-c64385921ccb', 'UNSOLD'),
('c849756b-1acb-4899-98ca-15ab72d74c5b', '53175187-9156-4017-9858-0c362d62e0ec', 'UNSOLD'),
('89406ce6-0c9e-4f15-b69a-f22efdbfb121', 'a6ef794b-7694-48ea-a05d-2d9a0a47cd96', 'UNSOLD'),
('d78b095c-2f70-4bc2-8743-2bc0c74f8d60', 'b09b90cd-a33c-4abd-830a-b9c21fd6e649', 'UNSOLD'),
('53fbe940-f0e1-4868-a27c-8265df4a6eda', 'b1138b4c-2d33-42d9-88b4-ca11e92dee03', 'UNSOLD'),
('1706c7d9-318a-4bef-8278-d3ce5d7c6920', '216411d7-1e2b-4a94-b639-68cf16323c41', 'UNSOLD'),
('950f22f5-2b51-46dd-a999-79d6d290b421', 'bec5ed16-cc46-4b14-a041-cbf4fb59c979', 'UNSOLD'),
('4952c5b0-ed0c-47de-b481-977c19ff4b71', '1c31e6e8-6337-49f4-95dd-8c165d4ad91a', 'UNSOLD'),
('df258ae6-3116-4b8d-9e0f-890bf00bff28', 'f4401a86-e6f8-4d3c-971e-e58a80de083b', 'UNSOLD'),
('494bba38-e89c-4ff4-aedd-2acd38032427', '42f1a8a1-37f6-4b2b-9ba1-68265cd0f9fa', 'UNSOLD'),
('1ff97ea9-2131-4e2a-b75b-4245079f21c2', '0aa4f1bb-c8aa-49f9-a2b3-687f171498d4', 'UNSOLD'),
('61564884-055d-4697-923a-3a332bb5a5a2', '76dbf014-2c8e-413e-bf5e-69432fd3148c', 'UNSOLD'),
('a1f1bb78-4810-4828-8f29-07f6ba2a547e', '4909e1d7-3834-4515-97fe-3dee9484bb7d', 'UNSOLD'),
('9973f05d-8809-439a-95e9-a1090b7dc0fc', 'f00bf997-2780-4671-a6fa-12bb0960572f', 'UNSOLD'),
('24997941-bf87-43dd-8d50-bdbee088cb1e', '1f49219d-30ba-455c-8957-26c240b6abfd', 'UNSOLD'),
('8efae2bc-bf51-4fdd-8e96-74a6e792d99b', 'ceae5983-917d-4b06-ab04-829ed91f2f06', 'UNSOLD'),
('83a363eb-eb84-4cfb-a244-88f7c5a7cc72', 'd7a7e805-1b82-4282-8268-de25a36c1176', 'UNSOLD'),
('079b886f-5ef1-40bd-888d-2e2d7627719b', 'b3f181a3-0e3f-499d-9e6d-853a12d797ef', 'UNSOLD'),
('062bfe91-dacd-4f88-9a34-4a7fc488f55c', '8521ab9a-c4e4-4285-b04d-0a30cdad1547', 'UNSOLD'),
('b6ad7fd1-ab52-4e14-9373-e055db0b204f', '00b082d3-9f36-490e-ba88-52ce13fd48e1', 'UNSOLD'),
('895f9790-7050-4e4d-889f-2abfd206f7cc', 'f090e2b4-97a5-46ee-ac17-41e34dc7fe43', 'UNSOLD'),
('3d03bead-9a63-4b5d-bb1b-c79e8a5e05f4', '38b9615b-fdb9-490b-b096-3162e30bbacd', 'UNSOLD'),
('4a0bbdcc-adf7-40f0-a163-6f181529284f', 'c196238a-1dae-4606-9efd-0bdc3a00dcfb', 'UNSOLD'),
('730dd4dd-999b-42af-a36b-2bef789451cc', '73b64d84-1c0f-4cdc-8257-6d3a2a958d20', 'UNSOLD');

INSERT INTO "AdminUser" (id, username, password_hash, role) VALUES
('87b650a1-0eb0-49c1-a883-1a07664adcd0', 'admin', '$2b$10$fsAv4VZmRBc0Jpy39wtvx.y5R.ASWmPpUawKMSh0DtYHrYBvxCfGO', 'ADMIN'),
('0ac5221c-c62a-47f9-b7cf-9da1701c589d', 'screen', '$2b$10$dX.5bb2w28cpN2XpcOm2h.pG7hYhWsS.KETImnVwmZYtv1dSzHipG', 'SCREEN');

INSERT INTO "AuctionSequence" (id, name, type, sequence_items) VALUES
(1, 'Franchise Auction', 'FRANCHISE', '[3,7,1,9,5,10,2,6,8,4]');

INSERT INTO "AuctionSequence" (id, name, type, sequence_items) VALUES
(2, 'Power Card Auction', 'POWER_CARD', '["GOD_EYE","MULLIGAN","FINAL_STRIKE","BID_FREEZER"]');

INSERT INTO "AuctionSequence" (id, name, type, sequence_items) VALUES
(3, 'Player Auction 4', 'PLAYER', '[34,143,82,149,152,127,50,117,19,147,30,135,112,37,92,36,142,41,109,23,100,26,33,69,119,159,123,89,80,155,47,101,111,73,43,88,58,63,115,114,32,85,57,150,61,46,13,158,125,60,137,3,103,84,6,133,94,17,139,157,42,97,132,128,54,29,154,107,95,96,64,51,126,11,118,78,144,44,83,31,91,67,153,105,86,38,55,131,20,120,113,4,108,93,146,145,71,74,124,68,35,28,102,106,52,130,18,62,79,141,40,65,99,16,138,136,22,72,10,90,116,25,110,134,129,9,140,66,45,122,8,48,53,75,21,39,2,27,14,56,12,148,76,98,70,156,15,121,7,104,77,24,87,59,81,1,49,151,5]');

INSERT INTO "AuctionState" (id, phase, auction_day) VALUES (1, 'NOT_STARTED', 'Day 1');

