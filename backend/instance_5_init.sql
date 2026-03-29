-- INSTANCE 5 INITIALIZATION
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



-- ── DATA FOR INSTANCE 5 ──

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
('ba392d7e-2fd2-43a7-a101-02d931107027', 'Freak Factor', 'Freak Factor', '$2b$10$sMS5vjdf4IZv5vbOTsIje.o2SPNtQr.N6UlY9ZDF5NRhJG07rtCkS', 120, 0),
('d46bf78c-5e28-4d8a-9308-e598530dcacb', 'Mard Mavle', 'Mard Mavle', '$2b$10$yqGkvL4MJZ8YTigim/rGM.qb.WSxps/XvTRqb1o6kzU.6P.WypAXS', 120, 0),
('8358f5d2-4f69-4333-a928-05c324d4c764', 'Tapri Titans', 'Tapri Titans', '$2b$10$asns02klMTz5BTeZ4Up9teZJ2WgtCgfcEfFMfocbw6LpxY1N8fPOe', 120, 0),
('0acb9169-0580-4af2-9cb2-ab88aceb8ceb', 'Bad dies XI', 'Bad dies XI', '$2b$10$GsTGrAZ2cCNFO2h28zPNvu/8eGkcyY50JZlMbiUtGs4crXC7gL6wq', 120, 0),
('2fb3ce6b-43c0-41b3-9a24-d541f7cc676f', 'Auction Acers', 'Auction Acers', '$2b$10$WKYAaeE5lcs8f3moBxxVm.5g2fD6PYZYQKHUkTdgiPOmeEEVtSne.', 120, 0),
('6c707633-c13f-4282-94c6-b163e3db75b1', 'Mumbai Super Kings (MSK)', 'Mumbai Super Kings (MSK)', '$2b$10$0ldj1JVC3e7SsbWAOrJksu2GqcUZgzmvPZYfaqGf0u.pNKCfklAea', 120, 0),
('063f18f5-15f4-4fae-bcbf-58084fcfeaf2', 'Triple Strikers', 'Triple Strikers', '$2b$10$fBPSFlQ9PS8CyTVpVYw8VO0JkGF51U0bhTDLy28LsdFtLglBykWYi', 120, 0),
('171574a7-cb16-4a44-9737-60a28e11d0c0', 'Vadapav Lovers', 'Vadapav Lovers', '$2b$10$6JMUTuUhD3oe93RAwaA6OuQDZIRFgIvZjYoK.RFsBv/ynRgH7wWY6', 120, 0),
('2c4d19f5-733a-4232-b3e9-414649d90f43', 'Major XI', 'Major XI', '$2b$10$0zXjVV7WAKpp4zniesJa7.4LrivTHKCOrE9zJteED8UtVX34mdixu', 120, 0),
('239cc571-5fbc-4099-af3f-26b36550058e', 'Team challengers', 'Team challengers', '$2b$10$VnrqmRLzNgxRe5Ta7R2I5O7hLSBA8JU/OrAG8klUH3jxMVNQT6zSW', 120, 0);

INSERT INTO "Player" (id, rank, name, team, role, category, pool, grade, rating, nationality, nationality_raw, base_price, is_riddle, riddle_title, riddle_question, legacy, url, matches, bat_runs, bat_sr, bat_average, bowl_wickets, bowl_eco, bowl_avg, sub_scoring, sub_impact, sub_consistency, sub_experience, sub_wicket_taking, sub_economy, sub_efficiency, sub_batting, sub_bowling, sub_versatility) VALUES
('0e2e87e0-76ca-4a37-8bc6-a14ff0f84cfc', 152, 'Anukul Roy', 'Kolkata Knight Riders', 'Batting Allrounder', 'AR', 'AR', 'C', 56, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/12344/anukul-roy', 11.0, 26.0, NULL, NULL, 6.0, NULL, NULL, NULL, NULL, NULL, 35, NULL, NULL, NULL, 17.0, 29.0, 17.0),
('dc425208-829c-4326-80dd-a7b0ec3aca45', 75, 'Karun Nair', 'Delhi Capitals', 'Batsman', 'BAT', 'BAT_WK', 'B', 70, 'INDIAN', 'Indian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/8257/karun-nair', 84.0, 1694.0, 131.73, 23.86, NULL, NULL, NULL, 35.0, 66.0, 60.0, 72, NULL, NULL, NULL, NULL, NULL, NULL),
('4f7a72e7-c6ae-4c68-8d03-1dd50d5ca823', 154, 'Nuwan Thushara', 'Royal Challengers Bengaluru', 'Bowler', 'BOWL', 'BOWL', 'C', 56, 'OVERSEAS', 'Sri Lankan', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/18509/nuwan-thushara', 8.0, NULL, NULL, NULL, 9.0, 9.43, 31.44, NULL, NULL, NULL, 34, 9.0, 49.0, 71.0, NULL, NULL, NULL),
('70ffbd28-6872-4c80-9bf2-3a1258a96b7a', 16, 'Suryakumar Yadav', 'Mumbai Indians', 'Batsman', 'BAT', 'BAT_WK', 'A', 89, 'INDIAN', 'Indian', 2, false, NULL, NULL, 2, 'https://www.cricbuzz.com/profiles/7915/suryakumar-yadav', 166.0, 4311.0, 148.66, 35.05, NULL, NULL, NULL, 82.0, 77.0, 87.0, 99, NULL, NULL, NULL, NULL, NULL, NULL),
('e22cfc45-efa6-4b3c-9e21-2c4afea67ede', 138, 'Azmatullah Omarzai', 'Punjab Kings', 'Bowling Allrounder', 'AR', 'AR', 'C', 58, 'OVERSEAS', 'Afghan', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/13214/azmatullah-omarzai', 16.0, 99.0, NULL, NULL, 12.0, NULL, NULL, NULL, NULL, NULL, 38, NULL, NULL, NULL, 31.0, 25.0, 25.0),
('53da16ce-6664-448a-b956-ed3fa8a76fc8', 73, 'Tim David', 'Royal Challengers Bengaluru', 'Batsman', 'BAT', 'BAT_WK', 'B', 70, 'OVERSEAS', 'Singaporean', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/13169/tim-david', 50.0, 846.0, 173.37, 32.54, NULL, NULL, NULL, 19.0, 94.0, 81.0, 55, NULL, NULL, NULL, NULL, NULL, NULL),
('8b4b3cc3-196e-47be-a424-425b11570c8f', 106, 'Sarfaraz Khan', 'Chennai Super Kings', 'Batsman', 'BAT', 'BAT_WK', 'C', 64, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/9429/sarfaraz-khan', 50.0, 585.0, 130.59, 22.5, NULL, NULL, NULL, 15.0, 65.0, 56.0, 55, NULL, NULL, NULL, NULL, NULL, NULL),
('31212896-7925-48f1-b7a8-64ee618e63b8', 90, 'Naman Dhir', 'Mumbai Indians', 'Batsman', 'BAT', 'BAT_WK', 'C', 67, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/36139/naman-dhir', 23.0, 392.0, 180.65, 28.0, NULL, NULL, NULL, 11.0, 99.0, 70.0, 41, NULL, NULL, NULL, NULL, NULL, NULL),
('0f88e4a0-8e45-4959-b9a9-3bc135f00121', 155, 'Swapnil Singh', 'Royal Challengers Bengaluru', 'Bowling Allrounder', 'AR', 'AR', 'C', 56, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/10238/swapnil-singh', 14.0, 51.0, NULL, NULL, 7.0, NULL, NULL, NULL, NULL, NULL, 37, NULL, NULL, NULL, 23.0, 27.0, 23.0),
('d09f60d7-6c96-4334-983a-62a7bdc7d494', 100, 'Abishek Porel', 'Delhi Capitals', 'WK-Batsman', 'WK', 'BAT_WK', 'C', 66, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/24326/abishek-porel', 31.0, 661.0, 149.89, 25.42, NULL, NULL, NULL, 16.0, 78.0, 63.0, 45, NULL, NULL, NULL, NULL, NULL, NULL),
('3f5eddd6-0183-4264-8c9b-c0366cf9c1be', 80, 'Lockie Ferguson', 'Punjab Kings', 'Bowler', 'BOWL', 'BOWL', 'C', 69, 'OVERSEAS', 'New Zealander', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/10692/lockie-ferguson', 49.0, NULL, NULL, NULL, 51.0, 8.97, 30.0, NULL, NULL, NULL, 54, 36.0, 56.0, 74.0, NULL, NULL, NULL),
('c851ab26-d6f9-455f-89dc-189a497ac2df', 93, 'Washington Sundar', 'Gujarat Titans', 'Bowling Allrounder', 'AR', 'AR', 'C', 67, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/10945/washington-sundar', 66.0, 511.0, NULL, NULL, 39.0, NULL, NULL, NULL, NULL, NULL, 63, NULL, NULL, NULL, 42.0, 40.0, 40.0),
('f8231710-59f6-45af-9e06-564eb676c7cd', 41, 'Nitish Rana', 'Delhi Capitals', 'Batsman', 'BAT', 'BAT_WK', 'B', 77, 'INDIAN', 'Indian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/9204/nitish-rana', 118.0, 2853.0, 136.77, 27.7, NULL, NULL, NULL, 56.0, 69.0, 69.0, 89, NULL, NULL, NULL, NULL, NULL, NULL),
('ec2652d3-9b9e-42db-a9b4-a410a133e029', 118, 'Aniket Verma', 'Sunrisers Hyderabad', 'Batsman', 'BAT', 'BAT_WK', 'C', 62, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/1447065/aniket-verma', 14.0, 236.0, 166.2, 26.22, NULL, NULL, NULL, 8.0, 89.0, 65.0, 37, NULL, NULL, NULL, NULL, NULL, NULL),
('4e22b5df-d599-47c2-9776-cc79b40a56e3', 18, 'Rashid Khan', 'Gujarat Titans', 'Bowling Allrounder', 'AR', 'AR', 'A', 89, 'OVERSEAS', 'Afghan', 2, false, NULL, NULL, 8, 'https://www.cricbuzz.com/profiles/10738/rashid-khan', 136.0, 585.0, NULL, NULL, 158.0, NULL, NULL, NULL, NULL, NULL, 98, NULL, NULL, NULL, 51.0, 82.0, 51.0),
('92eb74fc-2849-465b-aedd-34622f94ca1d', 69, 'Liam Livingstone', 'Sunrisers Hyderabad', 'Batting Allrounder', 'AR', 'AR', 'B', 70, 'OVERSEAS', 'English', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/10045/liam-livingstone', 49.0, 1051.0, NULL, NULL, 13.0, NULL, NULL, NULL, NULL, NULL, 54, NULL, NULL, NULL, 70.0, 28.0, 28.0),
('2d6bb7ca-c263-4d04-a8fc-555bd14b5421', 103, 'Priyansh Arya', 'Punjab Kings', 'Batsman', 'BAT', 'BAT_WK', 'C', 64, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/14689/priyansh-arya', 17.0, 475.0, 179.25, 27.94, NULL, NULL, NULL, 13.0, 98.0, 70.0, 38, NULL, NULL, NULL, NULL, NULL, NULL),
('dfaefc7b-dcdd-4960-8a1c-f28d1ae6aecd', 105, 'Mukesh Kumar', 'Delhi Capitals', 'Bowler', 'BOWL', 'BOWL', 'C', 64, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/10754/mukesh-kumar', 32.0, NULL, NULL, NULL, 36.0, 10.4, 30.61, NULL, NULL, NULL, 46, 27.0, 33.0, 73.0, NULL, NULL, NULL),
('973d7f83-e923-434d-9325-db836fa4f10e', 102, 'Angkrish Raghuvanshi', 'Kolkata Knight Riders', 'Batsman', 'BAT', 'BAT_WK', 'C', 65, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/22566/angkrish-raghuvanshi', 22.0, 463.0, 144.69, 28.94, NULL, NULL, NULL, 12.0, 75.0, 72.0, 41, NULL, NULL, NULL, NULL, NULL, NULL),
('42e90d5c-f73c-4c6d-a4e3-bb7c18cdd4e5', 88, 'Harshit Rana', 'Kolkata Knight Riders', 'Bowler', 'BOWL', 'BOWL', 'C', 67, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/24729/harshit-rana', 33.0, NULL, NULL, NULL, 40.0, 9.51, 25.73, NULL, NULL, NULL, 46, 29.0, 47.0, 83.0, NULL, NULL, NULL),
('6e715a39-597e-4339-9ba5-343607c1f804', 126, 'Nathan Ellis', 'Chennai Super Kings', 'Bowler', 'BOWL', 'BOWL', 'C', 61, 'OVERSEAS', 'Australian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/15480/nathan-ellis', 17.0, NULL, NULL, NULL, 19.0, 8.67, 28.74, NULL, NULL, NULL, 38, 16.0, 61.0, 77.0, NULL, NULL, NULL),
('4935cc52-d3e7-4acf-b24c-e8338e9c21cd', 136, 'Arshad Khan', 'Gujarat Titans', 'Bowling Allrounder', 'AR', 'AR', 'C', 58, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/18637/arshad-khan', 19.0, 124.0, NULL, NULL, 12.0, NULL, NULL, NULL, NULL, NULL, 39, NULL, NULL, NULL, 39.0, 18.0, 18.0),
('106fd531-055b-4753-86a0-99c275d2cfc2', 115, 'Rachin Ravindra', 'Kolkata Knight Riders', 'Batting Allrounder', 'AR', 'AR', 'C', 62, 'OVERSEAS', 'New Zealander', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/11177/rachin-ravindra', 18.0, 413.0, NULL, NULL, 0.0, NULL, NULL, NULL, NULL, NULL, 39, NULL, NULL, NULL, 49.0, 29.0, 29.0),
('a1fd4985-abaf-48d4-927c-0c148cd443a8', 129, 'Anuj Rawat', 'Gujarat Titans', 'WK-Batsman', 'WK', 'BAT_WK', 'C', 60, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/13135/anuj-rawat', 24.0, 318.0, 119.11, 19.88, NULL, NULL, NULL, 10.0, 57.0, 50.0, 42, NULL, NULL, NULL, NULL, NULL, NULL),
('5a0b6743-0a33-4b31-8afe-5c9fcd9547a5', 68, 'Anrich Nortje', 'Lucknow Super Giants', 'Bowler', 'BOWL', 'BOWL', 'B', 71, 'OVERSEAS', 'South African', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/11427/anrich-nortje', 48.0, NULL, NULL, NULL, 61.0, 9.07, 27.16, NULL, NULL, NULL, 54, 43.0, 55.0, 80.0, NULL, NULL, NULL),
('0bf987a4-8a25-45c9-8af7-13ca75c61496', 44, 'Khaleel Ahmed', 'Chennai Super Kings', 'Bowler', 'BOWL', 'BOWL', 'B', 77, 'INDIAN', 'Indian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/10952/khaleel-ahmed', 71.0, NULL, NULL, NULL, 89.0, 8.98, 26.16, NULL, NULL, NULL, 65, 61.0, 56.0, 82.0, NULL, NULL, NULL),
('d501c92c-c959-43cf-8a11-db6b745d7f58', 150, 'Adam Milne', 'Rajasthan Royals', 'Bowler', 'BOWL', 'BOWL', 'C', 56, 'OVERSEAS', 'New Zealander', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/7625/adam-milne', 10.0, NULL, NULL, NULL, 7.0, 9.48, 46.71, NULL, NULL, NULL, 35, 8.0, 48.0, 38.0, NULL, NULL, NULL),
('5b38697e-f8a5-4d19-aa1f-289116f39c2b', 157, 'Manimaran Siddharth', 'Lucknow Super Giants', 'Bowler', 'BOWL', 'BOWL', 'C', 55, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/12930/manimaran-siddharth', 5.0, NULL, NULL, NULL, 3.0, 8.63, 46.0, NULL, NULL, NULL, 32, 5.0, 62.0, 40.0, NULL, NULL, NULL),
('3845b323-535a-499d-8806-8e888cf91957', 14, 'Ajinkya Rahane', 'Kolkata Knight Riders', 'Batsman', 'BAT', 'BAT_WK', 'A', 91, 'INDIAN', 'Indian', 2, false, NULL, NULL, 4, 'https://www.cricbuzz.com/profiles/1447/ajinkya-rahane', 198.0, 5032.0, 125.02, 30.5, NULL, NULL, NULL, 95.0, 61.0, 76.0, 99, NULL, NULL, NULL, NULL, NULL, NULL),
('1c552872-2cf8-4471-a2e6-f15329310a0d', 65, 'Tilak Varma', 'Mumbai Indians', 'Batsman', 'BAT', 'BAT_WK', 'B', 72, 'INDIAN', 'Indian', 1, true, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/14504/tilak-varma', 54.0, 1499.0, 144.42, 37.48, NULL, NULL, NULL, 31.0, 74.0, 93.0, 57, NULL, NULL, NULL, NULL, NULL, NULL),
('2ccff873-235b-4176-888e-58dcbc22948e', 4, 'Sunil Narine', 'Kolkata Knight Riders', 'Bowling Allrounder', 'AR', 'AR', 'A', 98, 'OVERSEAS', 'West Indian', 2, false, NULL, NULL, 10, 'https://www.cricbuzz.com/profiles/2276/sunil-narine', 188.0, 1780.0, NULL, NULL, 192.0, NULL, NULL, NULL, NULL, NULL, 99, NULL, NULL, NULL, 84.0, 83.0, 83.0),
('d4604a3c-f819-4ebb-bc3b-efa8c9677e93', 127, 'Digvesh Singh Rathi', 'Lucknow Super Giants', 'Bowler', 'BOWL', 'BOWL', 'C', 61, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/1448289/digvesh-singh-rathi', 13.0, NULL, NULL, NULL, 14.0, 8.25, 30.64, NULL, NULL, NULL, 36, 12.0, 68.0, 72.0, NULL, NULL, NULL),
('736766d1-5901-4aeb-8b07-4bd78c6cbf93', 140, 'Mukesh Choudhary', 'Chennai Super Kings', 'Bowler', 'BOWL', 'BOWL', 'C', 58, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/13184/mukesh-choudhary', 16.0, NULL, NULL, NULL, 17.0, 9.94, 30.71, NULL, NULL, NULL, 38, 14.0, 40.0, 72.0, NULL, NULL, NULL),
('cf1aeb37-8a79-4c64-acdf-995a132e918c', 91, 'Shahrukh Khan', 'Gujarat Titans', 'Batting Allrounder', 'AR', 'AR', 'C', 67, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/10226/shahrukh-khan', 55.0, 732.0, NULL, NULL, 1.0, NULL, NULL, NULL, NULL, NULL, 57, NULL, NULL, NULL, 56.0, 27.0, 27.0),
('30a41e46-a7c7-4060-9ccd-b29cd1268954', 142, 'Kamindu Mendis', 'Sunrisers Hyderabad', 'Batting Allrounder', 'AR', 'AR', 'C', 57, 'OVERSEAS', 'Sri Lankan', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/10940/kamindu-mendis', 5.0, 92.0, NULL, NULL, 2.0, NULL, NULL, NULL, NULL, NULL, 32, NULL, NULL, NULL, 38.0, 29.0, 29.0),
('d12e2125-f0f9-4b72-b97e-53b7e6712b0f', 144, 'Vijaykumar Vyshak', 'Punjab Kings', 'Bowler', 'BOWL', 'BOWL', 'C', 57, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/10486/vijaykumar-vyshak', 16.0, NULL, NULL, NULL, 17.0, 10.38, 33.88, NULL, NULL, NULL, 38, 14.0, 33.0, 66.0, NULL, NULL, NULL),
('be505a59-91c5-4404-a309-e15d26636706', 28, 'Kuldeep Yadav', 'Delhi Capitals', 'Bowler', 'BOWL', 'BOWL', 'B', 83, 'INDIAN', 'Indian', 1, false, NULL, NULL, 2, 'https://www.cricbuzz.com/profiles/8292/kuldeep-yadav', 98.0, NULL, NULL, NULL, 102.0, 8.04, 26.95, NULL, NULL, NULL, 79, 69.0, 71.0, 80.0, NULL, NULL, NULL),
('83b10ea5-6581-47ef-b46c-dafeecb05166', 58, 'Riyan Parag', 'Rajasthan Royals', 'Batting Allrounder', 'AR', 'AR', 'B', 73, 'INDIAN', 'Indian', 1, false, NULL, NULL, 2, 'https://www.cricbuzz.com/profiles/12305/riyan-parag', 83.0, 1566.0, NULL, NULL, 7.0, NULL, NULL, NULL, NULL, NULL, 71, NULL, NULL, NULL, 78.0, 16.0, 16.0),
('54e38964-d614-4cf4-81de-8a5f87a3c306', 82, 'Jitesh Sharma', 'Royal Challengers Bengaluru', 'WK-Batsman', 'WK', 'BAT_WK', 'C', 68, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/10214/jitesh-sharma', 55.0, 991.0, 157.06, 25.41, NULL, NULL, NULL, 22.0, 83.0, 63.0, 57, NULL, NULL, NULL, NULL, NULL, NULL),
('84c809d6-5722-4d5d-a77c-ec8b36f87d33', 50, 'Mitchell Marsh', 'Lucknow Super Giants', 'Batting Allrounder', 'AR', 'AR', 'B', 74, 'OVERSEAS', 'Australian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/6250/mitchell-marsh', 55.0, 1292.0, NULL, NULL, 37.0, NULL, NULL, NULL, NULL, NULL, 57, NULL, NULL, NULL, 72.0, 43.0, 43.0),
('ad644579-5543-4a3c-b630-d68851d27629', 43, 'Abhishek Sharma', 'Sunrisers Hyderabad', 'Batting Allrounder', 'AR', 'AR', 'B', 77, 'INDIAN', 'Indian', 1, false, NULL, NULL, 2, 'https://www.cricbuzz.com/profiles/12086/abhishek-sharma', 77.0, 1815.0, NULL, NULL, 11.0, NULL, NULL, NULL, NULL, NULL, 68, NULL, NULL, NULL, 90.0, 24.0, 24.0),
('289c6fcb-1cd6-4f66-8e10-55a0b4dd539f', 34, 'Quinton de Kock', 'Mumbai Indians', 'WK-Batsman', 'WK', 'BAT_WK', 'B', 79, 'OVERSEAS', 'South African', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/8520/quinton-de-kock', 115.0, 3309.0, 134.03, 30.64, NULL, NULL, NULL, 64.0, 67.0, 76.0, 87, NULL, NULL, NULL, NULL, NULL, NULL),
('ea86f200-9f70-444d-bf5d-93729247313d', 143, 'Prashant Solanki', 'Kolkata Knight Riders', 'Bowler', 'BOWL', 'BOWL', 'C', 57, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/12805/prashant-solanki', 2.0, NULL, NULL, NULL, 2.0, 6.33, 19.0, NULL, NULL, NULL, 31, 5.0, 99.0, 97.0, NULL, NULL, NULL),
('5a5d6c46-be1d-47ce-b63b-bf2cda04ca3e', 119, 'Wanindu Hasaranga', 'Lucknow Super Giants', 'Bowling Allrounder', 'AR', 'AR', 'C', 62, 'OVERSEAS', 'Sri Lankan', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/10926/wanindu-hasaranga', 37.0, 81.0, NULL, NULL, 46.0, NULL, NULL, NULL, NULL, NULL, 48, NULL, NULL, NULL, 15.0, 45.0, 15.0),
('5d2ba425-cc1a-48db-96c4-d1f655890d53', 37, 'Ishan Kishan', 'Sunrisers Hyderabad', 'WK-Batsman', 'WK', 'BAT_WK', 'B', 78, 'INDIAN', 'Indian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/10276/ishan-kishan', 119.0, 2998.0, 137.65, 29.11, NULL, NULL, NULL, 58.0, 70.0, 72.0, 89, NULL, NULL, NULL, NULL, NULL, NULL),
('d0269444-c27d-4186-9b10-8e37056c8338', 123, 'Ayush Mhatre', 'Chennai Super Kings', 'Batsman', 'BAT', 'BAT_WK', 'C', 61, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/1431163/ayush-mhatre', 7.0, 240.0, 188.98, 34.29, NULL, NULL, NULL, 8.0, 99.0, 85.0, 33, NULL, NULL, NULL, NULL, NULL, NULL),
('cc69b7a6-0854-4910-9724-0bd2a50d6f44', 23, 'Shubman Gill', 'Gujarat Titans', 'Batsman', 'BAT', 'BAT_WK', 'B', 84, 'INDIAN', 'Indian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/11808/shubman-gill', 118.0, 3866.0, 138.72, 39.45, NULL, NULL, NULL, 74.0, 70.0, 98.0, 89, NULL, NULL, NULL, NULL, NULL, NULL),
('da88f280-3f85-41ea-ada4-de624fffc059', 89, 'Dhruv Jurel', 'Rajasthan Royals', 'WK-Batsman', 'WK', 'BAT_WK', 'C', 67, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/14691/dhruv-jurel', 41.0, 680.0, 153.85, 28.33, NULL, NULL, NULL, 16.0, 81.0, 71.0, 50, NULL, NULL, NULL, NULL, NULL, NULL),
('808f96c0-2b1f-4ce9-b7f2-87e248ed1737', 64, 'Shreyas Gopal', 'Chennai Super Kings', 'Bowler', 'BOWL', 'BOWL', 'B', 72, 'INDIAN', 'Indian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/9746/shreyas-gopal', 52.0, NULL, NULL, NULL, 52.0, 8.16, 25.92, NULL, NULL, NULL, 56, 37.0, 69.0, 83.0, NULL, NULL, NULL),
('1622571d-71a3-4ec6-8f86-09efefe710d6', 24, 'Varun Chakaravarthy', 'Kolkata Knight Riders', 'Bowler', 'BOWL', 'BOWL', 'B', 84, 'INDIAN', 'Indian', 1, false, NULL, NULL, 2, 'https://www.cricbuzz.com/profiles/12926/varun-chakaravarthy', 83.0, NULL, NULL, NULL, 100.0, 7.58, 23.85, NULL, NULL, NULL, 71, 68.0, 79.0, 87.0, NULL, NULL, NULL),
('1f9a3167-1087-4b5b-9d91-df3916ba6342', 85, 'Mohsin Khan', 'Lucknow Super Giants', 'Bowler', 'BOWL', 'BOWL', 'C', 67, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/13534/mohsin-khan', 24.0, NULL, NULL, NULL, 27.0, 8.51, 25.52, NULL, NULL, NULL, 42, 21.0, 64.0, 83.0, NULL, NULL, NULL),
('10c56279-472b-479e-8dd8-7c43f80f0d4b', 62, 'Shimron Hetmyer', 'Rajasthan Royals', 'Batsman', 'BAT', 'BAT_WK', 'B', 72, 'OVERSEAS', 'West Indian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/9789/shimron-hetmyer', 86.0, 1482.0, 151.85, 29.06, NULL, NULL, NULL, 31.0, 79.0, 72.0, 73, NULL, NULL, NULL, NULL, NULL, NULL),
('4d87bb74-e76e-481e-8fa7-16f021a84bc8', 148, 'Vignesh Puthur', 'Rajasthan Royals', 'Bowler', 'BOWL', 'BOWL', 'C', 57, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/1447337/vignesh-puthur', 5.0, NULL, NULL, NULL, 6.0, 9.08, 18.17, NULL, NULL, NULL, 32, 7.0, 54.0, 99.0, NULL, NULL, NULL),
('62d2be22-bd37-4418-be44-059cd3153f73', 149, 'Glenn Phillips', 'Gujarat Titans', 'Batting Allrounder', 'AR', 'AR', 'C', 56, 'OVERSEAS', 'New Zealander', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/10693/glenn-phillips', 8.0, 65.0, NULL, NULL, 2.0, NULL, NULL, NULL, NULL, NULL, 34, NULL, NULL, NULL, 24.0, 34.0, 24.0),
('bb6bed35-1965-433b-b447-77e33df6e3c7', 96, 'Vaibhav Arora', 'Kolkata Knight Riders', 'Bowler', 'BOWL', 'BOWL', 'C', 66, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/15861/vaibhav-arora', 32.0, NULL, NULL, NULL, 36.0, 9.55, 28.22, NULL, NULL, NULL, 46, 27.0, 47.0, 78.0, NULL, NULL, NULL),
('39149d6d-db56-450a-b097-bbfa99e8516e', 63, 'T Natarajan', 'Delhi Capitals', 'Bowler', 'BOWL', 'BOWL', 'B', 72, 'INDIAN', 'Indian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/10225/t-natarajan', 63.0, NULL, NULL, NULL, 67.0, 8.94, 30.12, NULL, NULL, NULL, 61, 47.0, 57.0, 74.0, NULL, NULL, NULL),
('5a220052-d15e-4097-b923-6470800af4e1', 98, 'Shivam Mavi', 'Sunrisers Hyderabad', 'Bowler', 'BOWL', 'BOWL', 'C', 66, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/12345/shivam-mavi', 32.0, NULL, NULL, NULL, 30.0, 8.71, 31.4, NULL, NULL, NULL, 46, 23.0, 60.0, 71.0, NULL, NULL, NULL),
('01640d31-a2b3-43d8-9d3b-e401ea67ed4f', 45, 'Shivam Dube', 'Chennai Super Kings', 'Batting Allrounder', 'AR', 'AR', 'B', 76, 'INDIAN', 'Indian', 1, false, NULL, NULL, 2, 'https://www.cricbuzz.com/profiles/11195/shivam-dube', 79.0, 1859.0, NULL, NULL, 5.0, NULL, NULL, NULL, NULL, NULL, 69, NULL, NULL, NULL, 88.0, 20.0, 20.0),
('5afd91bd-7973-4dc1-a207-c5e8b5550adc', 15, 'Sanju Samson', 'Chennai Super Kings', 'WK-Batsman', 'WK', 'BAT_WK', 'A', 89, 'INDIAN', 'Indian', 2, false, NULL, NULL, 2, 'https://www.cricbuzz.com/profiles/8271/sanju-samson', 176.0, 4704.0, 139.05, 30.75, NULL, NULL, NULL, 89.0, 71.0, 76.0, 99, NULL, NULL, NULL, NULL, NULL, NULL),
('ed81460f-da92-43d2-8d8e-e341046e6220', 87, 'Tushar Deshpande', 'Rajasthan Royals', 'Bowler', 'BOWL', 'BOWL', 'C', 67, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/11307/tushar-deshpande', 46.0, NULL, NULL, NULL, 51.0, 9.84, 31.04, NULL, NULL, NULL, 53, 36.0, 42.0, 72.0, NULL, NULL, NULL),
('2c6f042b-fa12-41ef-918d-594fa3641279', 70, 'Venkatesh Iyer', 'Royal Challengers Bengaluru', 'Batting Allrounder', 'AR', 'AR', 'B', 70, 'INDIAN', 'Indian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/10917/venkatesh-iyer', 61.0, 1468.0, NULL, NULL, 3.0, NULL, NULL, NULL, NULL, NULL, 60, NULL, NULL, NULL, 77.0, 16.0, 16.0),
('38518730-d396-47c5-93c4-2172bf403389', 101, 'Umran Malik', 'Kolkata Knight Riders', 'Bowler', 'BOWL', 'BOWL', 'C', 65, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/19027/umran-malik', 26.0, NULL, NULL, NULL, 29.0, 9.4, 26.62, NULL, NULL, NULL, 43, 22.0, 49.0, 81.0, NULL, NULL, NULL),
('8bcc42e4-6bbb-4f29-b954-0e3354d0240e', 32, 'David Miller', 'Delhi Capitals', 'Batsman', 'BAT', 'BAT_WK', 'B', 80, 'OVERSEAS', 'South African', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/6349/david-miller', 141.0, 3077.0, 138.61, 35.78, NULL, NULL, NULL, 60.0, 70.0, 89.0, 99, NULL, NULL, NULL, NULL, NULL, NULL),
('14c82dfa-b263-4bf5-9f06-62955c1593ac', 10, 'Harshal Patel', 'Sunrisers Hyderabad', 'Bowler', 'BOWL', 'BOWL', 'A', 94, 'INDIAN', 'Indian', 2, false, NULL, NULL, 6, 'https://www.cricbuzz.com/profiles/8175/harshal-patel', 119.0, NULL, NULL, NULL, 151.0, 8.86, 23.7, NULL, NULL, NULL, 89, 99.0, 58.0, 87.0, NULL, NULL, NULL),
('cc9b6b4d-73a3-4000-b4d4-e4ba148db9e7', 67, 'Ayush Badoni', 'Lucknow Super Giants', 'Batting Allrounder', 'AR', 'AR', 'B', 71, 'INDIAN', 'Indian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/13907/ayush-badoni', 56.0, 963.0, NULL, NULL, 4.0, NULL, NULL, NULL, NULL, NULL, 58, NULL, NULL, NULL, 63.0, 37.0, 37.0),
('e2387c47-bbb9-41de-972f-68dec780077f', 35, 'Deepak Chahar', 'Mumbai Indians', 'Bowler', 'BOWL', 'BOWL', 'B', 78, 'INDIAN', 'Indian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/7836/deepak-chahar', 95.0, NULL, NULL, NULL, 88.0, 8.14, 29.51, NULL, NULL, NULL, 77, 60.0, 70.0, 75.0, NULL, NULL, NULL),
('0a2ff117-76f7-4475-86af-e06ee12d5d21', 132, 'Kuldeep Sen', 'Rajasthan Royals', 'Bowler', 'BOWL', 'BOWL', 'C', 59, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/14336/kuldeep-sen', 12.0, NULL, NULL, NULL, 14.0, 9.63, 27.64, NULL, NULL, NULL, 36, 12.0, 45.0, 79.0, NULL, NULL, NULL),
('165f1cc0-b848-45cd-82f1-8d601e3d1f9a', 27, 'Shreyas Iyer', 'Punjab Kings', 'Batsman', 'BAT', 'BAT_WK', 'B', 83, 'INDIAN', 'Indian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/9428/shreyas-iyer', 132.0, 3731.0, 133.35, 34.23, NULL, NULL, NULL, 72.0, 67.0, 85.0, 96, NULL, NULL, NULL, NULL, NULL, NULL),
('1cae4d15-17a7-4ede-baf0-462513d2d42a', 153, 'Urvil Patel', 'Chennai Super Kings', 'WK-Batsman', 'WK', 'BAT_WK', 'C', 56, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/13476/urvil-patel', 3.0, 68.0, 212.5, 22.67, NULL, NULL, NULL, 5.0, 99.0, 57.0, 31, NULL, NULL, NULL, NULL, NULL, NULL),
('19531183-eeeb-4554-a620-6fbc243724a2', 130, 'Sameer Rizvi', 'Delhi Capitals', 'Batsman', 'BAT', 'BAT_WK', 'C', 60, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/14700/sameer-rizvi', 13.0, 172.0, 140.99, 24.57, NULL, NULL, NULL, 7.0, 72.0, 61.0, 36, NULL, NULL, NULL, NULL, NULL, NULL),
('bcc87189-99f8-46cc-9c9b-6f1cdd4867d2', 159, 'Rasikh Dar Salam', 'Royal Challengers Bengaluru', 'Bowler', 'BOWL', 'BOWL', 'C', 55, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/14274/rasikh-dar-salam', 13.0, NULL, NULL, NULL, 10.0, 10.62, 40.9, NULL, NULL, NULL, 36, 10.0, 29.0, 51.0, NULL, NULL, NULL),
('b2d70be7-7ba9-4464-b219-edb90e8e565b', 33, 'Ishant Sharma', 'Gujarat Titans', 'Bowler', 'BOWL', 'BOWL', 'B', 79, 'INDIAN', 'Indian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/702/ishant-sharma', 117.0, NULL, NULL, NULL, 96.0, 8.38, 35.18, NULL, NULL, NULL, 88, 65.0, 66.0, 63.0, NULL, NULL, NULL),
('263c0112-17ea-463b-af18-ca42cdeefab7', 12, 'Trent Boult', 'Mumbai Indians', 'Bowler', 'BOWL', 'BOWL', 'A', 92, 'OVERSEAS', 'New Zealander', 2, false, NULL, NULL, 4, 'https://www.cricbuzz.com/profiles/8117/trent-boult', 119.0, NULL, NULL, NULL, 143.0, 8.38, 26.2, NULL, NULL, NULL, 89, 96.0, 66.0, 82.0, NULL, NULL, NULL),
('8bf856c7-0168-4992-a024-b8ba0ec5134f', 66, 'Philip Salt', 'Royal Challengers Bengaluru', 'WK-Batsman', 'WK', 'BAT_WK', 'B', 71, 'OVERSEAS', 'English', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/10479/philip-salt', 34.0, 1056.0, 175.71, 34.06, NULL, NULL, NULL, 23.0, 95.0, 84.0, 47, NULL, NULL, NULL, NULL, NULL, NULL),
('a742a647-4bc2-4f66-b7bf-7ad575939ca1', 79, 'Prabhsimran Singh', 'Punjab Kings', 'WK-Batsman', 'WK', 'BAT_WK', 'C', 69, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/14254/prabhsimran-singh', 51.0, 1305.0, 151.93, 25.59, NULL, NULL, NULL, 28.0, 79.0, 64.0, 55, NULL, NULL, NULL, NULL, NULL, NULL),
('4793fe87-8b81-4f67-b13a-ce14c26ca8ce', 133, 'Kyle Jamieson', 'Delhi Capitals', 'Bowler', 'BOWL', 'BOWL', 'C', 59, 'OVERSEAS', 'New Zealander', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/9441/kyle-jamieson', 13.0, NULL, NULL, NULL, 14.0, 9.67, 29.71, NULL, NULL, NULL, 36, 12.0, 45.0, 74.0, NULL, NULL, NULL),
('bd99434d-6c2e-4f35-87ad-8baf360ef0db', 1, 'Virat Kohli', 'Royal Challengers Bengaluru', 'Batsman', 'BAT', 'BAT_WK', 'A', 99, 'INDIAN', 'Indian', 2, false, NULL, NULL, 10, 'https://www.cricbuzz.com/profiles/1413/virat-kohli', 267.0, 8661.0, 132.86, 39.55, NULL, NULL, NULL, 99.0, 67.0, 98.0, 99, NULL, NULL, NULL, NULL, NULL, NULL),
('693c19fd-f117-4b87-944c-55e29b0cd442', 156, 'Matthew Short', 'Chennai Super Kings', 'Batsman', 'BAT', 'BAT_WK', 'C', 55, 'OVERSEAS', 'Australian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/9456/matthew-short', 6.0, 117.0, 127.18, 19.5, NULL, NULL, NULL, 6.0, 63.0, 49.0, 33, NULL, NULL, NULL, NULL, NULL, NULL),
('890d8fc1-49ec-4476-9b4e-5877c642042e', 125, 'Vaibhav Suryavanshi', 'Rajasthan Royals', 'Batsman', 'BAT', 'BAT_WK', 'C', 61, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/51791/vaibhav-suryavanshi', 7.0, 252.0, 206.56, 36.0, NULL, NULL, NULL, 9.0, 99.0, 89.0, 33, NULL, NULL, NULL, NULL, NULL, NULL),
('b89342f6-8d2b-45af-a2e6-d1e1968134fd', 120, 'Ravisrinivasan Sai Kishore', 'Gujarat Titans', 'Bowling Allrounder', 'AR', 'AR', 'C', 61, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/11595/ravisrinivasan-sai-kishore', 25.0, 18.0, NULL, NULL, 32.0, NULL, NULL, NULL, NULL, NULL, 42, NULL, NULL, NULL, 19.0, 41.0, 19.0),
('22026f87-8848-4502-ad20-f7640ccd4265', 59, 'Rahul Tewatia', 'Gujarat Titans', 'Batting Allrounder', 'AR', 'AR', 'B', 73, 'INDIAN', 'Indian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/9693/rahul-tewatia', 108.0, 1112.0, NULL, NULL, 32.0, NULL, NULL, NULL, NULL, NULL, 84, NULL, NULL, NULL, 64.0, 38.0, 38.0),
('f14a1377-216f-44ac-af7f-266f416f7485', 83, 'Jason Holder', 'Gujarat Titans', 'Bowling Allrounder', 'AR', 'AR', 'C', 68, 'OVERSEAS', 'West Indian', 0.5, false, NULL, NULL, 2, 'https://www.cricbuzz.com/profiles/8313/jason-holder', 46.0, 259.0, NULL, NULL, 53.0, NULL, NULL, NULL, NULL, NULL, 53, NULL, NULL, NULL, 32.0, 45.0, 32.0),
('160978e8-bc6b-491a-b418-949d299fca0e', 84, 'Cameron Green', 'Kolkata Knight Riders', 'Batting Allrounder', 'AR', 'AR', 'C', 68, 'OVERSEAS', 'Australian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/12225/cameron-green', 29.0, 707.0, NULL, NULL, 16.0, NULL, NULL, NULL, NULL, NULL, 44, NULL, NULL, NULL, 64.0, 27.0, 27.0),
('8b8091b1-eeb1-4bd2-a91b-ac5bbdb9561d', 74, 'Devdutt Padikkal', 'Royal Challengers Bengaluru', 'Batsman', 'BAT', 'BAT_WK', 'B', 70, 'INDIAN', 'Indian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/13088/devdutt-padikkal', 74.0, 1806.0, 126.3, 25.44, NULL, NULL, NULL, 37.0, 62.0, 64.0, 67, NULL, NULL, NULL, NULL, NULL, NULL),
('a258d64f-7d33-41e1-9732-82fcda36b400', 121, 'Suyash Sharma', 'Royal Challengers Bengaluru', 'Bowler', 'BOWL', 'BOWL', 'C', 61, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/36487/suyash-sharma', 27.0, NULL, NULL, NULL, 18.0, 8.75, 45.22, NULL, NULL, NULL, 43, 15.0, 60.0, 41.0, NULL, NULL, NULL),
('127d1b3f-e717-4b88-87e3-be5cad97c12c', 146, 'Anshul Kamboj', 'Chennai Super Kings', 'Bowling Allrounder', 'AR', 'AR', 'C', 57, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/14598/anshul-kamboj', 11.0, 16.0, NULL, NULL, 10.0, NULL, NULL, NULL, NULL, NULL, 35, NULL, NULL, NULL, 21.0, 30.0, 21.0),
('58e0da80-0251-4dcf-8814-bdff489aee13', 141, 'Eshan Malinga', 'Sunrisers Hyderabad', 'Bowler', 'BOWL', 'BOWL', 'C', 58, 'OVERSEAS', 'Sri Lankan', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/46926/eshan-malinga', 7.0, NULL, NULL, NULL, 13.0, 8.93, 18.31, NULL, NULL, NULL, 33, 12.0, 57.0, 99.0, NULL, NULL, NULL),
('857db191-f7ea-4cb7-a115-4d0b5588bb13', 117, 'Dewald Brevis', 'Chennai Super Kings', 'Batsman', 'BAT', 'BAT_WK', 'C', 62, 'OVERSEAS', 'South African', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/20538/dewald-brevis', 16.0, 455.0, 153.2, 28.44, NULL, NULL, NULL, 12.0, 80.0, 71.0, 38, NULL, NULL, NULL, NULL, NULL, NULL),
('88064204-efef-43ab-a18e-0acabe019786', 124, 'Shubham Dubey', 'Rajasthan Royals', 'Batsman', 'BAT', 'BAT_WK', 'C', 61, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/19328/shubham-dubey', 13.0, 139.0, 163.53, 23.17, NULL, NULL, NULL, 6.0, 87.0, 58.0, 36, NULL, NULL, NULL, NULL, NULL, NULL),
('dd76f4be-b3c6-4b55-b654-8fcf6abe080f', 97, 'Ramandeep Singh', 'Kolkata Knight Riders', 'Batting Allrounder', 'AR', 'AR', 'C', 66, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/12337/ramandeep-singh', 30.0, 217.0, NULL, NULL, 6.0, NULL, NULL, NULL, NULL, NULL, 45, NULL, NULL, NULL, 46.0, 35.0, 35.0),
('a89a55d0-3409-4a2e-8c1d-519a6e8060e9', 139, 'Nandre Burger', 'Rajasthan Royals', 'Bowler', 'BOWL', 'BOWL', 'C', 58, 'OVERSEAS', 'South African', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/13630/nandre-burger', 5.0, NULL, NULL, NULL, 7.0, 8.53, 20.71, NULL, NULL, NULL, 32, 8.0, 63.0, 94.0, NULL, NULL, NULL),
('20fbb741-1a79-4225-873b-2b5e97a34e69', 52, 'Rahul Tripathi', 'Kolkata Knight Riders', 'Batsman', 'BAT', 'BAT_WK', 'B', 74, 'INDIAN', 'Indian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/9012/rahul-tripathi', 100.0, 2291.0, 137.85, 26.03, NULL, NULL, NULL, 46.0, 70.0, 65.0, 80, NULL, NULL, NULL, NULL, NULL, NULL),
('a5b804ac-78b6-45e0-beaa-00e56f1eab97', 51, 'Sam Curran', 'Rajasthan Royals', 'Bowling Allrounder', 'AR', 'AR', 'B', 74, 'OVERSEAS', 'English', 1, false, NULL, NULL, 2, 'https://www.cricbuzz.com/profiles/10420/sam-curran', 64.0, 997.0, NULL, NULL, 59.0, NULL, NULL, NULL, NULL, NULL, 62, NULL, NULL, NULL, 62.0, 41.0, 41.0),
('7b68e627-d668-4209-9571-d2860074e388', 107, 'Shahbaz Ahmed', 'Lucknow Super Giants', 'Bowling Allrounder', 'AR', 'AR', 'C', 64, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/14606/shahbaz-ahmed', 58.0, 545.0, NULL, NULL, 22.0, NULL, NULL, NULL, NULL, NULL, 59, NULL, NULL, NULL, 43.0, 27.0, 27.0),
('49f98336-5439-47ed-a6a1-87b20cd227c7', 72, 'Aiden Markram', 'Lucknow Super Giants', 'Batsman', 'BAT', 'BAT_WK', 'B', 70, 'OVERSEAS', 'South African', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/9582/aiden-markram', 57.0, 1440.0, 135.09, 31.3, NULL, NULL, NULL, 30.0, 68.0, 78.0, 58, NULL, NULL, NULL, NULL, NULL, NULL),
('450051d5-3924-4c45-a142-918fb8b84197', 86, 'Mayank Markande', 'Mumbai Indians', 'Bowler', 'BOWL', 'BOWL', 'C', 67, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/12627/mayank-markande', 37.0, NULL, NULL, NULL, 37.0, 8.91, 28.89, NULL, NULL, NULL, 48, 27.0, 57.0, 76.0, NULL, NULL, NULL),
('436d1d4e-dc29-4a19-90f1-66f4d623ab57', 39, 'Nicholas Pooran', 'Lucknow Super Giants', 'WK-Batsman', 'WK', 'BAT_WK', 'B', 78, 'OVERSEAS', 'West Indian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/9406/nicholas-pooran', 90.0, 2293.0, 168.98, 34.22, NULL, NULL, NULL, 46.0, 91.0, 85.0, 75, NULL, NULL, NULL, NULL, NULL, NULL),
('0c222980-46b1-44fd-b9e4-749ff4c9c920', 29, 'Mohammed Siraj', 'Gujarat Titans', 'Bowler', 'BOWL', 'BOWL', 'B', 83, 'INDIAN', 'Indian', 1, false, NULL, NULL, 2, 'https://www.cricbuzz.com/profiles/10808/mohammed-siraj', 108.0, NULL, NULL, NULL, 109.0, 8.74, 30.72, NULL, NULL, NULL, 84, 74.0, 60.0, 72.0, NULL, NULL, NULL),
('8cecfc6d-b1ad-498c-80ba-dadc6e43189d', 108, 'Rovman Powell', 'Kolkata Knight Riders', 'Batsman', 'BAT', 'BAT_WK', 'C', 63, 'OVERSEAS', 'West Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/11445/rovman-powell', 28.0, 365.0, 146.59, 18.25, NULL, NULL, NULL, 11.0, 76.0, 46.0, 44, NULL, NULL, NULL, NULL, NULL, NULL),
('416e8f3b-c01c-4df1-a6fb-7cde7b7f3f3e', 135, 'Kartik Tyagi', 'Kolkata Knight Riders', 'Bowler', 'BOWL', 'BOWL', 'C', 58, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/13136/kartik-tyagi', 20.0, NULL, NULL, NULL, 15.0, 10.14, 47.53, NULL, NULL, NULL, 40, 13.0, 37.0, 37.0, NULL, NULL, NULL),
('6c4b0b31-22ad-4507-8942-454ba2d0f894', 3, 'Jasprit Bumrah', 'Mumbai Indians', 'Bowler', 'BOWL', 'BOWL', 'A', 99, 'INDIAN', 'Indian', 2, false, NULL, NULL, 8, 'https://www.cricbuzz.com/profiles/9311/jasprit-bumrah', 145.0, NULL, NULL, NULL, 183.0, 7.25, 22.03, NULL, NULL, NULL, 99, 99.0, 84.0, 91.0, NULL, NULL, NULL),
('fb53d648-1add-4ae7-bbc7-b21e23e8c19c', 60, 'Noor Ahmad', 'Chennai Super Kings', 'Bowler', 'BOWL', 'BOWL', 'B', 72, 'OVERSEAS', 'Afghan', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/15452/noor-ahmad', 37.0, NULL, NULL, NULL, 48.0, 8.08, 22.23, NULL, NULL, NULL, 48, 34.0, 71.0, 90.0, NULL, NULL, NULL),
('abf7b433-8df8-410c-912d-6e21b228b8f2', 110, 'Josh Inglis', 'Lucknow Super Giants', 'WK-Batsman', 'WK', 'BAT_WK', 'C', 63, 'OVERSEAS', 'Australian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/10637/josh-inglis', 11.0, 278.0, 162.58, 30.89, NULL, NULL, NULL, 9.0, 87.0, 77.0, 35, NULL, NULL, NULL, NULL, NULL, NULL),
('b01dc5bc-a907-4778-ba01-156a7110d091', 158, 'Arjun Tendulkar', 'Lucknow Super Giants', 'Bowling Allrounder', 'AR', 'AR', 'C', 55, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/13747/arjun-tendulkar', 5.0, 13.0, NULL, NULL, 3.0, NULL, NULL, NULL, NULL, NULL, 32, NULL, NULL, NULL, 32.0, 23.0, 23.0),
('fa41dc64-2675-40dc-893a-e341a48510e2', 77, 'Rinku Singh', 'Kolkata Knight Riders', 'Batsman', 'BAT', 'BAT_WK', 'C', 69, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/10896/rinku-singh', 58.0, 1099.0, 145.18, 30.53, NULL, NULL, NULL, 24.0, 75.0, 76.0, 59, NULL, NULL, NULL, NULL, NULL, NULL),
('1ed83588-4731-4b68-9bc9-e31b5771f2f6', 9, 'KL Rahul', 'Delhi Capitals', 'WK-Batsman', 'WK', 'BAT_WK', 'A', 95, 'INDIAN', 'Indian', 2, false, NULL, NULL, 4, 'https://www.cricbuzz.com/profiles/8733/kl-rahul', 145.0, 5222.0, 136.03, 46.21, NULL, NULL, NULL, 99.0, 69.0, 99.0, 99, NULL, NULL, NULL, NULL, NULL, NULL),
('272b7381-4aad-48e7-9a48-0b76d1aa6bfe', 31, 'Manish Pandey', 'Kolkata Knight Riders', 'Batsman', 'BAT', 'BAT_WK', 'B', 82, 'INDIAN', 'Indian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/1836/manish-pandey', 174.0, 3942.0, 121.52, 29.42, NULL, NULL, NULL, 76.0, 59.0, 73.0, 99, NULL, NULL, NULL, NULL, NULL, NULL),
('04cb3e72-a0a1-440a-af2a-504995eb2eba', 95, 'Nehal Wadhera', 'Punjab Kings', 'Batsman', 'BAT', 'BAT_WK', 'C', 66, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/13915/nehal-wadhera', 36.0, 719.0, 142.95, 26.63, NULL, NULL, NULL, 17.0, 73.0, 66.0, 48, NULL, NULL, NULL, NULL, NULL, NULL),
('fcda1153-b51a-474b-8cf6-55022b8ffdf0', 81, 'Harpreet Brar', 'Punjab Kings', 'Bowler', 'BOWL', 'BOWL', 'C', 68, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/14452/harpreet-brar', 49.0, NULL, NULL, NULL, 35.0, 8.03, 31.0, NULL, NULL, NULL, 54, 26.0, 71.0, 72.0, NULL, NULL, NULL),
('e8b9b8ad-39b3-4b10-be76-3b7c4838216b', 49, 'Ravi Bishnoi', 'Rajasthan Royals', 'Bowler', 'BOWL', 'BOWL', 'B', 75, 'INDIAN', 'Indian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/14659/ravi-bishnoi', 77.0, NULL, NULL, NULL, 72.0, 8.22, 31.07, NULL, NULL, NULL, 68, 50.0, 68.0, 72.0, NULL, NULL, NULL),
('bf644ace-a7e2-4864-887b-fc682ed222b1', 151, 'Dushmantha Chameera', 'Delhi Capitals', 'Bowler', 'BOWL', 'BOWL', 'C', 56, 'OVERSEAS', 'Sri Lankan', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/8393/dushmantha-chameera', 19.0, NULL, NULL, NULL, 13.0, 9.73, 46.38, NULL, NULL, NULL, 39, 12.0, 44.0, 39.0, NULL, NULL, NULL),
('75b6db1d-e829-4523-a35a-4ef79eef4bdf', 113, 'Marco Jansen', 'Punjab Kings', 'Bowling Allrounder', 'AR', 'AR', 'C', 62, 'OVERSEAS', 'South African', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/14565/marco-jansen', 35.0, 141.0, NULL, NULL, 36.0, NULL, NULL, NULL, NULL, NULL, 47, NULL, NULL, NULL, 26.0, 36.0, 26.0),
('3cea56e5-17d9-443f-9f57-10086979a686', 109, 'Abdul Samad', 'Lucknow Super Giants', 'Batting Allrounder', 'AR', 'AR', 'C', 63, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/14628/abdul-samad', 63.0, 741.0, NULL, NULL, 2.0, NULL, NULL, NULL, NULL, NULL, 61, NULL, NULL, NULL, 57.0, 5.0, 5.0),
('13e9d10d-c35d-4027-94c8-0699207b92e5', 111, 'Ryan Rickelton', 'Mumbai Indians', 'WK-Batsman', 'WK', 'BAT_WK', 'C', 62, 'OVERSEAS', 'South African', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/13070/ryan-rickelton', 14.0, 388.0, 150.98, 29.85, NULL, NULL, NULL, 11.0, 79.0, 74.0, 37, NULL, NULL, NULL, NULL, NULL, NULL),
('cf5625dc-b5d7-4bc0-8bf9-957b38a57d7c', 116, 'Sherfane Rutherford', 'Mumbai Indians', 'Batting Allrounder', 'AR', 'AR', 'C', 62, 'OVERSEAS', 'West Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/13748/sherfane-rutherford', 23.0, 397.0, NULL, NULL, 1.0, NULL, NULL, NULL, NULL, NULL, 41, NULL, NULL, NULL, 48.0, 17.0, 17.0),
('664dfff5-6c02-444e-a0cf-ce889c4f164d', 54, 'Heinrich Klaasen', 'Sunrisers Hyderabad', 'WK-Batsman', 'WK', 'BAT_WK', 'B', 74, 'OVERSEAS', 'South African', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/10209/heinrich-klaasen', 49.0, 1480.0, 169.73, 40.0, NULL, NULL, NULL, 31.0, 91.0, 99.0, 54, NULL, NULL, NULL, NULL, NULL, NULL),
('4f611c41-cc28-4b7d-a24e-ad5de88ae335', 122, 'Ashutosh Sharma', 'Delhi Capitals', 'Batting Allrounder', 'AR', 'AR', 'C', 61, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/13497/ashutosh-sharma', 24.0, 393.0, NULL, NULL, 0.0, NULL, NULL, NULL, NULL, NULL, 42, NULL, NULL, NULL, 56.0, 7, 14),
('79278035-b774-4e90-9c68-f3deeaaa96fc', 137, 'Jayant Yadav', 'Gujarat Titans', 'Bowling Allrounder', 'AR', 'AR', 'C', 58, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/8182/jayant-yadav', 20.0, 40.0, NULL, NULL, 8.0, NULL, NULL, NULL, NULL, NULL, 40, NULL, NULL, NULL, 22.0, 25.0, 22.0),
('3f0c2f99-d3c0-458f-9a95-23d3c52f7322', 26, 'Jaydev Unadkat', 'Sunrisers Hyderabad', 'Bowler', 'BOWL', 'BOWL', 'B', 83, 'INDIAN', 'Indian', 1, false, NULL, NULL, 2, 'https://www.cricbuzz.com/profiles/6327/jaydev-unadkat', 112.0, NULL, NULL, NULL, 110.0, 8.88, 30.58, NULL, NULL, NULL, 86, 74.0, 58.0, 73.0, NULL, NULL, NULL),
('a8295153-f7ed-4e88-96c7-2b7e3637bb5a', 40, 'Rahul Chahar', 'Chennai Super Kings', 'Bowler', 'BOWL', 'BOWL', 'B', 77, 'INDIAN', 'Indian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/12087/rahul-chahar', 79.0, NULL, NULL, NULL, 75.0, 7.72, 28.67, NULL, NULL, NULL, 69, 52.0, 76.0, 77.0, NULL, NULL, NULL),
('dc3f00bb-4c5e-451a-95dc-6254d3a8836d', 92, 'Shashank Singh', 'Punjab Kings', 'Batting Allrounder', 'AR', 'AR', 'C', 67, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/10919/shashank-singh', 41.0, 773.0, NULL, NULL, 1.0, NULL, NULL, NULL, NULL, NULL, 50, NULL, NULL, NULL, 67.0, 14.0, 14.0),
('540cbb3f-5781-4b86-88c2-b589edab76da', 71, 'Matheesha Pathirana', 'Kolkata Knight Riders', 'Bowler', 'BOWL', 'BOWL', 'B', 70, 'OVERSEAS', 'Sri Lankan', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/16458/matheesha-pathirana', 32.0, NULL, NULL, NULL, 47.0, 8.68, 21.62, NULL, NULL, NULL, 46, 34.0, 61.0, 92.0, NULL, NULL, NULL),
('3ece84a7-914d-4bc1-99a1-9943293d4cfc', 20, 'Jos Buttler', 'Gujarat Titans', 'WK-Batsman', 'WK', 'BAT_WK', 'A', 88, 'OVERSEAS', 'English', 2, false, NULL, NULL, 2, 'https://www.cricbuzz.com/profiles/2258/jos-buttler', 121.0, 4120.0, 149.39, 40.0, NULL, NULL, NULL, 79.0, 78.0, 99.0, 90, NULL, NULL, NULL, NULL, NULL, NULL),
('33bda1d9-81f5-4b94-9515-674093898dc7', 57, 'Jofra Archer', 'Rajasthan Royals', 'Bowler', 'BOWL', 'BOWL', 'B', 73, 'OVERSEAS', 'English', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/11540/jofra-archer', 52.0, NULL, NULL, NULL, 59.0, 7.89, 27.15, NULL, NULL, NULL, 56, 41.0, 74.0, 80.0, NULL, NULL, NULL),
('ec7c2299-fb3f-498a-b4a3-bd1650bb568c', 36, 'Arshdeep Singh', 'Punjab Kings', 'Bowler', 'BOWL', 'BOWL', 'B', 78, 'INDIAN', 'Indian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/13217/arshdeep-singh', 82.0, NULL, NULL, NULL, 97.0, 9.0, 26.49, NULL, NULL, NULL, 71, 66.0, 56.0, 81.0, NULL, NULL, NULL),
('fff35337-fc8c-4963-9495-89f27387474f', 53, 'Prasidh Krishna', 'Gujarat Titans', 'Bowler', 'BOWL', 'BOWL', 'B', 74, 'INDIAN', 'Indian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/10551/prasidh-krishna', 66.0, NULL, NULL, NULL, 74.0, 8.77, 29.61, NULL, NULL, NULL, 63, 51.0, 59.0, 75.0, NULL, NULL, NULL),
('d1826436-a921-4650-ac2f-885086cb7968', 11, 'Sandeep Sharma', 'Rajasthan Royals', 'Bowler', 'BOWL', 'BOWL', 'A', 93, 'INDIAN', 'Indian', 2, false, NULL, NULL, 4, 'https://www.cricbuzz.com/profiles/8356/sandeep-sharma', 136.0, NULL, NULL, NULL, 146.0, 8.03, 27.88, NULL, NULL, NULL, 98, 98.0, 71.0, 78.0, NULL, NULL, NULL),
('80d36971-121e-4ef6-b24e-2db8619a066c', 47, 'Yashasvi Jaiswal', 'Rajasthan Royals', 'Batsman', 'BAT', 'BAT_WK', 'B', 75, 'INDIAN', 'Indian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/13940/yashasvi-jaiswal', 66.0, 2166.0, 152.86, 34.38, NULL, NULL, NULL, 43.0, 80.0, 85.0, 63, NULL, NULL, NULL, NULL, NULL, NULL),
('318ba9e2-5124-4b4d-9d37-1e7e55786c1c', 42, 'Ruturaj Gaikwad', 'Chennai Super Kings', 'Batsman', 'BAT', 'BAT_WK', 'B', 77, 'INDIAN', 'Indian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/11813/ruturaj-gaikwad', 71.0, 2502.0, 137.48, 40.35, NULL, NULL, NULL, 49.0, 70.0, 99.0, 65, NULL, NULL, NULL, NULL, NULL, NULL),
('b19ac349-b53e-43fb-82f4-37a80a78cea0', 6, 'Rohit Sharma', 'Mumbai Indians', 'Batsman', 'BAT', 'BAT_WK', 'A', 96, 'INDIAN', 'Indian', 2, false, NULL, NULL, 8, 'https://www.cricbuzz.com/profiles/576/rohit-sharma', 272.0, 7046.0, 132.1, 29.73, NULL, NULL, NULL, 99.0, 66.0, 74.0, 99, NULL, NULL, NULL, NULL, NULL, NULL),
('5b4d7eeb-ccb5-42cd-94c6-48dea30ee8d4', 145, 'Akash Maharaj Singh', 'Lucknow Super Giants', 'Bowler', 'BOWL', 'BOWL', 'C', 57, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/14696/akash-maharaj-singh', 10.0, NULL, NULL, NULL, 9.0, 9.54, 36.22, NULL, NULL, NULL, 35, 9.0, 47.0, 61.0, NULL, NULL, NULL),
('d591f515-c0e4-4962-8a14-fbeb5021bfcc', 114, 'Mitchell Santner', 'Mumbai Indians', 'Bowling Allrounder', 'AR', 'AR', 'C', 62, 'OVERSEAS', 'New Zealander', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/10100/mitchell-santner', 31.0, 110.0, NULL, NULL, 25.0, NULL, NULL, NULL, NULL, NULL, 45, NULL, NULL, NULL, 25.0, 40.0, 25.0),
('05cae075-8f33-4a6c-a97c-4b316de2b058', 7, 'Ravindra Jadeja', 'Rajasthan Royals', 'Bowling Allrounder', 'AR', 'AR', 'A', 95, 'INDIAN', 'Indian', 2, false, NULL, NULL, 8, 'https://www.cricbuzz.com/profiles/587/ravindra-jadeja', 254.0, 3260.0, NULL, NULL, 170.0, NULL, NULL, NULL, NULL, NULL, 99, NULL, NULL, NULL, 85.0, 78.0, 78.0),
('dfe7ba9b-7267-497a-a661-789835cdf6c6', 134, 'Vipraj Nigam', 'Delhi Capitals', 'Bowler', 'BOWL', 'BOWL', 'C', 59, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/1431811/vipraj-nigam', 14.0, NULL, NULL, NULL, 11.0, 9.13, 32.36, NULL, NULL, NULL, 37, 10.0, 54.0, 69.0, NULL, NULL, NULL),
('aa63b853-b4f7-4844-975a-b4ec08acb6a8', 112, 'Nitish Kumar Reddy', 'Sunrisers Hyderabad', 'Batting Allrounder', 'AR', 'AR', 'C', 62, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/14701/nitish-kumar-reddy', 28.0, 485.0, NULL, NULL, 5.0, NULL, NULL, NULL, NULL, NULL, 44, NULL, NULL, NULL, 50.0, 14.0, 14.0),
('75fbe29a-23b3-468e-b348-68aa12c1bd50', 30, 'Rishabh Pant', 'Lucknow Super Giants', 'WK-Batsman', 'WK', 'BAT_WK', 'B', 82, 'INDIAN', 'Indian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/10744/rishabh-pant', 125.0, 3553.0, 147.62, 34.16, NULL, NULL, NULL, 68.0, 76.0, 85.0, 92, NULL, NULL, NULL, NULL, NULL, NULL),
('c08658ae-6c8b-42a0-9fdf-e1c50f48fa80', 2, 'Yuzvendra Chahal', 'Punjab Kings', 'Bowler', 'BOWL', 'BOWL', 'A', 99, 'INDIAN', 'Indian', 2, false, NULL, NULL, 10, 'https://www.cricbuzz.com/profiles/7910/yuzvendra-chahal', 174.0, NULL, NULL, NULL, 221.0, 7.96, 22.77, NULL, NULL, NULL, 99, 99.0, 73.0, 89.0, NULL, NULL, NULL),
('b0d088b0-d3cc-4d53-b83c-1cb17f2cb1a6', 25, 'Marcus Stoinis', 'Punjab Kings', 'Batting Allrounder', 'AR', 'AR', 'B', 83, 'OVERSEAS', 'Australian', 1, false, NULL, NULL, 4, 'https://www.cricbuzz.com/profiles/8989/marcus-stoinis', 109.0, 2026.0, NULL, NULL, 44.0, NULL, NULL, NULL, NULL, NULL, 84, NULL, NULL, NULL, 90.0, 37.0, 37.0),
('1f112ed9-eb29-4b97-ad14-ef80bd782323', 94, 'Will Jacks', 'Mumbai Indians', 'Batting Allrounder', 'AR', 'AR', 'C', 66, 'OVERSEAS', 'English', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/12258/will-jacks', 21.0, 463.0, NULL, NULL, 8.0, NULL, NULL, NULL, NULL, NULL, 40, NULL, NULL, NULL, 55.0, 28.0, 28.0),
('f07b8940-d559-4f4b-872a-5deb6d09c09f', 38, 'Shardul Thakur', 'Mumbai Indians', 'Bowling Allrounder', 'AR', 'AR', 'B', 78, 'INDIAN', 'Indian', 1, false, NULL, NULL, 6, 'https://www.cricbuzz.com/profiles/8683/shardul-thakur', 105.0, 325.0, NULL, NULL, 107.0, NULL, NULL, NULL, NULL, NULL, 82, NULL, NULL, NULL, 38.0, 59.0, 38.0),
('7cfbf0f9-24f4-4af4-9cbe-34f59b261ad6', 76, 'Tristan Stubbs', 'Delhi Capitals', 'WK-Batsman', 'WK', 'BAT_WK', 'B', 70, 'OVERSEAS', 'South African', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/19243/tristan-stubbs', 32.0, 705.0, 163.2, 41.47, NULL, NULL, NULL, 17.0, 87.0, 99.0, 46, NULL, NULL, NULL, NULL, NULL, NULL),
('c66f7e7d-f2a6-43da-818d-55032776b12c', 131, 'Romario Shepherd', 'Royal Challengers Bengaluru', 'Bowling Allrounder', 'AR', 'AR', 'C', 60, 'OVERSEAS', 'West Indian', 0.5, true, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/13646/romario-shepherd', 18.0, 185.0, NULL, NULL, 10.0, NULL, NULL, NULL, NULL, NULL, 39, NULL, NULL, NULL, 52.0, 18.0, 18.0),
('a0c5aa38-f9d8-41e1-83b8-d5fcd6df2d55', 17, 'Mohammed Shami', 'Lucknow Super Giants', 'Bowler', 'BOWL', 'BOWL', 'A', 89, 'INDIAN', 'Indian', 2, false, NULL, NULL, 4, 'https://www.cricbuzz.com/profiles/7909/mohammed-shami', 119.0, NULL, NULL, NULL, 133.0, 8.63, 28.18, NULL, NULL, NULL, 89, 89.0, 62.0, 78.0, NULL, NULL, NULL),
('6bfd2f1c-d2f4-4ef6-977c-e83c42563e3d', 46, 'Avesh Khan', 'Lucknow Super Giants', 'Bowler', 'BOWL', 'BOWL', 'B', 76, 'INDIAN', 'Indian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/9781/avesh-khan', 75.0, NULL, NULL, NULL, 87.0, 9.12, 28.29, NULL, NULL, NULL, 67, 60.0, 54.0, 77.0, NULL, NULL, NULL),
('e0b056ce-39d6-4ec8-ad8e-0031c9f9b8a3', 19, 'Hardik Pandya', 'Mumbai Indians', 'Batting Allrounder', 'AR', 'AR', 'A', 89, 'INDIAN', 'Indian', 2, false, NULL, NULL, 6, 'https://www.cricbuzz.com/profiles/9647/hardik-pandya', 152.0, 2749.0, NULL, NULL, 78.0, NULL, NULL, NULL, NULL, NULL, 99, NULL, NULL, NULL, 90.0, 50.0, 50.0),
('de068d39-cc14-4146-857c-15c41fb8e94a', 56, 'Josh Hazlewood', 'Royal Challengers Bengaluru', 'Bowler', 'BOWL', 'BOWL', 'B', 73, 'OVERSEAS', 'Australian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/6258/josh-hazlewood', 39.0, NULL, NULL, NULL, 57.0, 8.28, 20.98, NULL, NULL, NULL, 49, 40.0, 67.0, 93.0, NULL, NULL, NULL),
('d1cca7c6-87fe-487e-b52c-101c899e8f8e', 21, 'Krunal Pandya', 'Royal Challengers Bengaluru', 'Batting Allrounder', 'AR', 'AR', 'A', 86, 'INDIAN', 'Indian', 2, false, NULL, NULL, 4, 'https://www.cricbuzz.com/profiles/11311/krunal-pandya', 142.0, 1748.0, NULL, NULL, 93.0, NULL, NULL, NULL, NULL, NULL, 99, NULL, NULL, NULL, 77.0, 60.0, 60.0),
('17534bd5-2c29-4a46-b889-b5672adaafd5', 104, 'Lungi Ngidi', 'Delhi Capitals', 'Bowler', 'BOWL', 'BOWL', 'C', 64, 'OVERSEAS', 'South African', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/9603/lungi-ngidi', 16.0, NULL, NULL, NULL, 29.0, 8.53, 18.24, NULL, NULL, NULL, 38, 22.0, 63.0, 99.0, NULL, NULL, NULL),
('174a0260-3c7d-4b4d-ad14-7a892d9b81ca', 99, 'Yash Dayal', 'Royal Challengers Bengaluru', 'Bowler', 'BOWL', 'BOWL', 'C', 66, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/14172/yash-dayal', 43.0, NULL, NULL, NULL, 41.0, 9.58, 33.9, NULL, NULL, NULL, 51, 30.0, 46.0, 66.0, NULL, NULL, NULL),
('f3757c12-106f-454a-a735-958acd6d97d1', 5, 'Bhuvneshwar Kumar', 'Royal Challengers Bengaluru', 'Bowler', 'BOWL', 'BOWL', 'A', 98, 'INDIAN', 'Indian', 2, false, NULL, NULL, 8, 'https://www.cricbuzz.com/profiles/1726/bhuvneshwar-kumar', 190.0, NULL, NULL, NULL, 198.0, 7.69, 27.33, NULL, NULL, NULL, 99, 99.0, 77.0, 80.0, NULL, NULL, NULL),
('3c3867d1-58be-4399-9eb2-eb271f0ee29c', 147, 'Mayank Yadav', 'Lucknow Super Giants', 'Bowler', 'BOWL', 'BOWL', 'C', 57, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/22401/mayank-yadav', 6.0, NULL, NULL, NULL, 9.0, 9.17, 20.56, NULL, NULL, NULL, 33, 9.0, 53.0, 94.0, NULL, NULL, NULL),
('3669a903-87b6-432d-af81-88bbcaf9318e', 61, 'Travis Head', 'Sunrisers Hyderabad', 'Batsman', 'BAT', 'BAT_WK', 'B', 72, 'OVERSEAS', 'Australian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/8497/travis-head', 38.0, 1146.0, 170.03, 34.73, NULL, NULL, NULL, 25.0, 92.0, 86.0, 49, NULL, NULL, NULL, NULL, NULL, NULL),
('f8f6bcbc-70de-428d-bc79-a9136899877f', 48, 'Pat Cummins', 'Sunrisers Hyderabad', 'Bowler', 'BOWL', 'BOWL', 'B', 75, 'OVERSEAS', 'Australian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/8095/pat-cummins', 72.0, NULL, NULL, NULL, 79.0, 8.81, 30.04, NULL, NULL, NULL, 66, 54.0, 59.0, 74.0, NULL, NULL, NULL),
('25f6a57c-f3ba-4998-b7f8-3c361be73d9d', 8, 'MS Dhoni', 'Chennai Super Kings', 'WK-Batsman', 'WK', 'BAT_WK', 'A', 95, 'INDIAN', 'Indian', 2, false, NULL, NULL, 4, 'https://www.cricbuzz.com/profiles/265/ms-dhoni', 278.0, 5439.0, 137.46, 38.3, NULL, NULL, NULL, 99.0, 70.0, 95.0, 99, NULL, NULL, NULL, NULL, NULL, NULL),
('2f5882df-ef40-4fb8-9aa4-e54505b5c8b0', 78, 'Rajat Patidar', 'Royal Challengers Bengaluru', 'Batsman', 'BAT', 'BAT_WK', 'C', 69, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/10636/rajat-patidar', 42.0, 1111.0, 154.31, 30.86, NULL, NULL, NULL, 24.0, 81.0, 77.0, 51, NULL, NULL, NULL, NULL, NULL, NULL),
('979cfc0f-30f9-42cb-8418-92ea3c70ef68', 22, 'Kagiso Rabada', 'Gujarat Titans', 'Bowler', 'BOWL', 'BOWL', 'A', 85, 'OVERSEAS', 'South African', 2, false, NULL, NULL, 2, 'https://www.cricbuzz.com/profiles/9585/kagiso-rabada', 84.0, NULL, NULL, NULL, 119.0, 8.62, 22.96, NULL, NULL, NULL, 72, 80.0, 62.0, 89.0, NULL, NULL, NULL),
('5b486774-1561-4ec5-8852-b49674b52d3b', 55, 'Mitchell Starc', 'Delhi Capitals', 'Bowler', 'BOWL', 'BOWL', 'B', 73, 'OVERSEAS', 'Australian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/7710/mitchell-starc', 51.0, NULL, NULL, NULL, 65.0, 8.61, 23.12, NULL, NULL, NULL, 55, 45.0, 62.0, 88.0, NULL, NULL, NULL),
('13a01aa4-4df3-4dfb-901c-260034874787', 13, 'Axar Patel', 'Delhi Capitals', 'Bowling Allrounder', 'AR', 'AR', 'A', 91, 'INDIAN', 'Indian', 2, false, NULL, NULL, 6, 'https://www.cricbuzz.com/profiles/8808/axar-patel', 162.0, 1916.0, NULL, NULL, 128.0, NULL, NULL, NULL, NULL, NULL, 99, NULL, NULL, NULL, 82.0, 72.0, 72.0),
('196c3d5c-378c-4498-ae21-06d6947fa3ad', 128, 'Yash Thakur', 'Punjab Kings', 'Bowler', 'BOWL', 'BOWL', 'C', 61, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/12096/yash-thakur', 21.0, NULL, NULL, NULL, 25.0, 10.43, 30.8, NULL, NULL, NULL, 40, 20.0, 32.0, 72.0, NULL, NULL, NULL);

INSERT INTO "AuctionPlayer" (id, player_id, status) VALUES
('61828cb6-9b1e-455b-9f05-7a8b0e6d2027', '0e2e87e0-76ca-4a37-8bc6-a14ff0f84cfc', 'UNSOLD'),
('154023c4-852c-4d8b-ab25-78419c78780c', 'dc425208-829c-4326-80dd-a7b0ec3aca45', 'UNSOLD'),
('9bdffb99-e8dc-41ae-a6ce-69d4c2cba510', '4f7a72e7-c6ae-4c68-8d03-1dd50d5ca823', 'UNSOLD'),
('954c3e5a-002a-4d6b-832a-c44e9d69550f', '70ffbd28-6872-4c80-9bf2-3a1258a96b7a', 'UNSOLD'),
('b666fef1-6017-4068-939f-fd6d4920bc8f', 'e22cfc45-efa6-4b3c-9e21-2c4afea67ede', 'UNSOLD'),
('cfb75743-97da-4f75-b388-0633b0c4f5db', '53da16ce-6664-448a-b956-ed3fa8a76fc8', 'UNSOLD'),
('79e8c797-54be-4079-b48b-fe18fb6646e0', '8b4b3cc3-196e-47be-a424-425b11570c8f', 'UNSOLD'),
('485c47df-09ff-4a41-868e-185b4f1c8c13', '31212896-7925-48f1-b7a8-64ee618e63b8', 'UNSOLD'),
('f7599968-4065-42c8-8524-8316d04957c5', '0f88e4a0-8e45-4959-b9a9-3bc135f00121', 'UNSOLD'),
('6e7d02f7-b807-4b65-bdee-ab6bfe27422d', 'd09f60d7-6c96-4334-983a-62a7bdc7d494', 'UNSOLD'),
('0eb434cf-1ea6-481c-b3b7-d98419f3b45d', '3f5eddd6-0183-4264-8c9b-c0366cf9c1be', 'UNSOLD'),
('ba6e896e-6384-4f0c-b18f-07e85d387d6b', 'c851ab26-d6f9-455f-89dc-189a497ac2df', 'UNSOLD'),
('37c95f1b-3197-4806-96a4-9504482d7d51', 'f8231710-59f6-45af-9e06-564eb676c7cd', 'UNSOLD'),
('1476eb9e-9782-4ef9-aab1-be61794e3f2e', 'ec2652d3-9b9e-42db-a9b4-a410a133e029', 'UNSOLD'),
('3910d4b2-d886-4d3b-a576-177329f9aad0', '4e22b5df-d599-47c2-9776-cc79b40a56e3', 'UNSOLD'),
('32d67585-b149-4138-a4ef-d962d61d553a', '92eb74fc-2849-465b-aedd-34622f94ca1d', 'UNSOLD'),
('231b886f-7d65-4d57-a9af-c614a071de64', '2d6bb7ca-c263-4d04-a8fc-555bd14b5421', 'UNSOLD'),
('f5b7ff64-10b6-4194-b725-45fa7b0795c9', 'dfaefc7b-dcdd-4960-8a1c-f28d1ae6aecd', 'UNSOLD'),
('9cfdae6d-8891-47a1-b15a-6840e3efc4d1', '973d7f83-e923-434d-9325-db836fa4f10e', 'UNSOLD'),
('0944a127-bcb5-4871-bcb3-545ba1d7ba60', '42e90d5c-f73c-4c6d-a4e3-bb7c18cdd4e5', 'UNSOLD'),
('a12c5b5b-5c83-4318-9afb-45092466793e', '6e715a39-597e-4339-9ba5-343607c1f804', 'UNSOLD'),
('4f26d22c-aa4d-473e-8410-53ca4b9217c2', '4935cc52-d3e7-4acf-b24c-e8338e9c21cd', 'UNSOLD'),
('a34c2a5d-8691-49f9-a3f7-35e3d172cf3b', '106fd531-055b-4753-86a0-99c275d2cfc2', 'UNSOLD'),
('ac850b7a-cd8a-4353-9e9b-76a738c19097', 'a1fd4985-abaf-48d4-927c-0c148cd443a8', 'UNSOLD'),
('f711c8d2-97cc-4804-a7c5-c8e62ddef025', '5a0b6743-0a33-4b31-8afe-5c9fcd9547a5', 'UNSOLD'),
('71dac54d-93d5-4073-9674-61ad66f5b952', '0bf987a4-8a25-45c9-8af7-13ca75c61496', 'UNSOLD'),
('073706f5-acb9-48bc-94de-34a4193ee9d9', 'd501c92c-c959-43cf-8a11-db6b745d7f58', 'UNSOLD'),
('7da45bfd-0104-469b-8f1e-dcbc254546f1', '5b38697e-f8a5-4d19-aa1f-289116f39c2b', 'UNSOLD'),
('83c6f61c-dea5-4ef5-9f19-d09211f00dff', '3845b323-535a-499d-8806-8e888cf91957', 'UNSOLD'),
('f2f6bf2c-9f71-414b-a8bd-85370bce5704', '1c552872-2cf8-4471-a2e6-f15329310a0d', 'UNSOLD'),
('b420675e-500c-48fd-ba96-9f470c9631da', '2ccff873-235b-4176-888e-58dcbc22948e', 'UNSOLD'),
('00356242-ce48-4933-9b0e-25f968d69a8c', 'd4604a3c-f819-4ebb-bc3b-efa8c9677e93', 'UNSOLD'),
('c10222a4-3a8a-40c2-b370-8b6763f6ae1c', '736766d1-5901-4aeb-8b07-4bd78c6cbf93', 'UNSOLD'),
('6c579a6a-7b60-4e99-8f0d-4a6e00ccbc84', 'cf1aeb37-8a79-4c64-acdf-995a132e918c', 'UNSOLD'),
('554cf5df-99d3-4839-b673-33ce275c07ac', '30a41e46-a7c7-4060-9ccd-b29cd1268954', 'UNSOLD'),
('84be17b8-31e0-4eab-b25a-fe0fda0eb6ac', 'd12e2125-f0f9-4b72-b97e-53b7e6712b0f', 'UNSOLD'),
('a7a0b29f-c493-47f4-8a76-608e9a25e496', 'be505a59-91c5-4404-a309-e15d26636706', 'UNSOLD'),
('5c35d1f3-08d4-4f31-8b2d-6c7d26b12570', '83b10ea5-6581-47ef-b46c-dafeecb05166', 'UNSOLD'),
('cbccf824-8b7a-416e-a2f9-6fab69b73fa7', '54e38964-d614-4cf4-81de-8a5f87a3c306', 'UNSOLD'),
('60d9e6f1-c103-4b95-8739-d278d6a5cf31', '84c809d6-5722-4d5d-a77c-ec8b36f87d33', 'UNSOLD'),
('cfe12efe-718a-448c-b6bb-d8c9af1973c8', 'ad644579-5543-4a3c-b630-d68851d27629', 'UNSOLD'),
('5197b799-e13c-4425-a1f0-06ae3abe42ed', '289c6fcb-1cd6-4f66-8e10-55a0b4dd539f', 'UNSOLD'),
('c0a60660-aae2-4497-ad4c-b1a11cf1f159', 'ea86f200-9f70-444d-bf5d-93729247313d', 'UNSOLD'),
('1e8a5ad3-3267-4f04-bb3d-99efccac375a', '5a5d6c46-be1d-47ce-b63b-bf2cda04ca3e', 'UNSOLD'),
('cb0f7a83-243b-4361-8edb-eac57190d4bb', '5d2ba425-cc1a-48db-96c4-d1f655890d53', 'UNSOLD'),
('b31cee3f-5544-401e-b5b5-6a92e972fb33', 'd0269444-c27d-4186-9b10-8e37056c8338', 'UNSOLD'),
('5e0007c0-b04d-46d4-af29-461899115338', 'cc69b7a6-0854-4910-9724-0bd2a50d6f44', 'UNSOLD'),
('c87a2937-43f4-4bac-a094-9bb723ab4470', 'da88f280-3f85-41ea-ada4-de624fffc059', 'UNSOLD'),
('c1afbfcc-d47a-4e5f-ab39-5c1f2cb4889f', '808f96c0-2b1f-4ce9-b7f2-87e248ed1737', 'UNSOLD'),
('ffb01cee-c772-42ab-9b66-7bdc428e4379', '1622571d-71a3-4ec6-8f86-09efefe710d6', 'UNSOLD'),
('83a5114a-2ec7-4fd7-843c-6798b47578e0', '1f9a3167-1087-4b5b-9d91-df3916ba6342', 'UNSOLD'),
('e332aa5c-2212-4fca-afa0-8ff24912d4d0', '10c56279-472b-479e-8dd8-7c43f80f0d4b', 'UNSOLD'),
('a0353baa-bcb0-43b9-a662-4c7aa51f3c5b', '4d87bb74-e76e-481e-8fa7-16f021a84bc8', 'UNSOLD'),
('758678df-0542-4d4c-b208-738abab6e27a', '62d2be22-bd37-4418-be44-059cd3153f73', 'UNSOLD'),
('f39a0ca6-25ef-45ea-b66d-fe88adfb4e68', 'bb6bed35-1965-433b-b447-77e33df6e3c7', 'UNSOLD'),
('5b515da2-de30-480f-bcf7-2a835a847b0e', '39149d6d-db56-450a-b097-bbfa99e8516e', 'UNSOLD'),
('03e08b0a-640f-40de-b615-a43cfce3eae5', '5a220052-d15e-4097-b923-6470800af4e1', 'UNSOLD'),
('0d743a55-95ee-4c48-ac19-b6a8e74f16c1', '01640d31-a2b3-43d8-9d3b-e401ea67ed4f', 'UNSOLD'),
('6ee4eaf3-fe55-47f6-a72a-a86b2607eb82', '5afd91bd-7973-4dc1-a207-c5e8b5550adc', 'UNSOLD'),
('72bcb907-1de9-4dde-a36c-d88067977a77', 'ed81460f-da92-43d2-8d8e-e341046e6220', 'UNSOLD'),
('037aae1d-fad5-4022-98a7-baf47aa7ba3c', '2c6f042b-fa12-41ef-918d-594fa3641279', 'UNSOLD'),
('2dd12bdc-779d-4275-971c-090cc0d1d109', '38518730-d396-47c5-93c4-2172bf403389', 'UNSOLD'),
('7fb3b352-cd7a-4ec0-898b-0eca444e326e', '8bcc42e4-6bbb-4f29-b954-0e3354d0240e', 'UNSOLD'),
('90dc25d9-1f86-4f77-bab4-3f1dc5134f61', '14c82dfa-b263-4bf5-9f06-62955c1593ac', 'UNSOLD'),
('c917415e-f9ef-4ec8-bd00-db379d6eee10', 'cc9b6b4d-73a3-4000-b4d4-e4ba148db9e7', 'UNSOLD'),
('9160c1a1-ddd4-43e9-be72-662c503b2970', 'e2387c47-bbb9-41de-972f-68dec780077f', 'UNSOLD'),
('aa469cc0-1a2d-42a4-8a6d-cf1d0e38eb0c', '0a2ff117-76f7-4475-86af-e06ee12d5d21', 'UNSOLD'),
('328549da-450f-48cb-aade-a6cccf909040', '165f1cc0-b848-45cd-82f1-8d601e3d1f9a', 'UNSOLD'),
('a0c60aff-7a34-457c-b105-0e1befc3a10c', '1cae4d15-17a7-4ede-baf0-462513d2d42a', 'UNSOLD'),
('cb29af78-4d88-42a8-927d-85be0877482a', '19531183-eeeb-4554-a620-6fbc243724a2', 'UNSOLD'),
('e58158ba-2749-4d8c-93d8-0f7f68f6ac22', 'bcc87189-99f8-46cc-9c9b-6f1cdd4867d2', 'UNSOLD'),
('0db60265-edf0-43f6-8ea7-e6b702ef9efb', 'b2d70be7-7ba9-4464-b219-edb90e8e565b', 'UNSOLD'),
('e5294380-a7c1-4d01-8213-a8c860230e3f', '263c0112-17ea-463b-af18-ca42cdeefab7', 'UNSOLD'),
('67d4dd62-67bc-4a71-9cd6-bbd0f80f2f73', '8bf856c7-0168-4992-a024-b8ba0ec5134f', 'UNSOLD'),
('794e1242-6591-4db7-a27f-a8c0efa48e63', 'a742a647-4bc2-4f66-b7bf-7ad575939ca1', 'UNSOLD'),
('a8be8bf3-dee3-4e1b-9de0-2a60208597af', '4793fe87-8b81-4f67-b13a-ce14c26ca8ce', 'UNSOLD'),
('a30e8b3e-45b9-48fa-84dc-7b44534ef46e', 'bd99434d-6c2e-4f35-87ad-8baf360ef0db', 'UNSOLD'),
('ba03b5ce-4441-46da-b110-d1d8af79b635', '693c19fd-f117-4b87-944c-55e29b0cd442', 'UNSOLD'),
('32bad85e-2072-456f-b7df-cf32069cf2cb', '890d8fc1-49ec-4476-9b4e-5877c642042e', 'UNSOLD'),
('1fea1742-ad27-4491-b88e-ec2b0b4c98ee', 'b89342f6-8d2b-45af-a2e6-d1e1968134fd', 'UNSOLD'),
('1bdf880d-77f6-467a-9754-b27676f13d48', '22026f87-8848-4502-ad20-f7640ccd4265', 'UNSOLD'),
('6fdac3df-9855-477e-9513-da688940cd0b', 'f14a1377-216f-44ac-af7f-266f416f7485', 'UNSOLD'),
('25a4c2bb-a118-4239-950a-a9f9d9c52cfa', '160978e8-bc6b-491a-b418-949d299fca0e', 'UNSOLD'),
('a6388b75-f9d0-41b4-ad6c-a46a0e95f525', '8b8091b1-eeb1-4bd2-a91b-ac5bbdb9561d', 'UNSOLD'),
('de476ac7-e353-42ed-a519-602dd8672624', 'a258d64f-7d33-41e1-9732-82fcda36b400', 'UNSOLD'),
('a55cd337-2b1a-4fcf-86e3-4583c47b4e49', '127d1b3f-e717-4b88-87e3-be5cad97c12c', 'UNSOLD'),
('d29da5f6-1423-41ae-9af5-82bb40edef40', '58e0da80-0251-4dcf-8814-bdff489aee13', 'UNSOLD'),
('a2d4d272-fbdb-4bc7-ba8a-8b22ef8bf51d', '857db191-f7ea-4cb7-a115-4d0b5588bb13', 'UNSOLD'),
('85bb6491-84bd-4fba-9e0e-c9a16662365f', '88064204-efef-43ab-a18e-0acabe019786', 'UNSOLD'),
('fe8b580e-3131-4e17-bccd-c497ef5fe56d', 'dd76f4be-b3c6-4b55-b654-8fcf6abe080f', 'UNSOLD'),
('9c54bcef-27f0-40aa-af4a-56c72e166e54', 'a89a55d0-3409-4a2e-8c1d-519a6e8060e9', 'UNSOLD'),
('78bae673-a524-4c7f-bb44-3ef1cbf1b3fa', '20fbb741-1a79-4225-873b-2b5e97a34e69', 'UNSOLD'),
('bffa549a-6694-4cbb-bd1b-a2b2858a139d', 'a5b804ac-78b6-45e0-beaa-00e56f1eab97', 'UNSOLD'),
('d7cc9952-b7b7-4ca9-8efd-01a51c3068c7', '7b68e627-d668-4209-9571-d2860074e388', 'UNSOLD'),
('6b026499-ee40-4b92-a935-333339f2fd42', '49f98336-5439-47ed-a6a1-87b20cd227c7', 'UNSOLD'),
('7f6c0f6a-e53a-4d14-9222-61ade21b73c7', '450051d5-3924-4c45-a142-918fb8b84197', 'UNSOLD'),
('1b8d5dd6-a4db-405f-8625-d72825514bac', '436d1d4e-dc29-4a19-90f1-66f4d623ab57', 'UNSOLD'),
('71b43cae-7b9f-41d2-8867-ab0ecdfaa190', '0c222980-46b1-44fd-b9e4-749ff4c9c920', 'UNSOLD'),
('06e4b8bb-9214-48d6-a562-dbffeaed4185', '8cecfc6d-b1ad-498c-80ba-dadc6e43189d', 'UNSOLD'),
('3725a52b-3c15-433c-97cf-01f409e1ab4c', '416e8f3b-c01c-4df1-a6fb-7cde7b7f3f3e', 'UNSOLD'),
('b9906b3d-0bd8-4b89-a187-9e75310fec4c', '6c4b0b31-22ad-4507-8942-454ba2d0f894', 'UNSOLD'),
('7d235789-06d9-484d-94cd-e18ecfd94e4a', 'fb53d648-1add-4ae7-bbc7-b21e23e8c19c', 'UNSOLD'),
('78b959fe-7fa7-4967-9552-49c08b4dbcc8', 'abf7b433-8df8-410c-912d-6e21b228b8f2', 'UNSOLD'),
('a53308e1-520a-44db-8c19-e61b2096921d', 'b01dc5bc-a907-4778-ba01-156a7110d091', 'UNSOLD'),
('17b3fb20-d7ee-43d8-9924-02d09e64a5da', 'fa41dc64-2675-40dc-893a-e341a48510e2', 'UNSOLD'),
('81089ee3-b8eb-41e7-8daa-e1523a85965e', '1ed83588-4731-4b68-9bc9-e31b5771f2f6', 'UNSOLD'),
('173463af-4f27-4217-b9dc-c5ece3e8db07', '272b7381-4aad-48e7-9a48-0b76d1aa6bfe', 'UNSOLD'),
('fde445ea-4023-4b17-92c6-a6d06224f273', '04cb3e72-a0a1-440a-af2a-504995eb2eba', 'UNSOLD'),
('e2201732-3a01-472a-ad00-19e352c32d84', 'fcda1153-b51a-474b-8cf6-55022b8ffdf0', 'UNSOLD'),
('d765485a-bfc6-4d1a-a214-da2a47e30866', 'e8b9b8ad-39b3-4b10-be76-3b7c4838216b', 'UNSOLD'),
('1e2219b3-4dbc-434d-82c2-3db00c757029', 'bf644ace-a7e2-4864-887b-fc682ed222b1', 'UNSOLD'),
('1955f508-6809-46f4-b474-2d87361e89fb', '75b6db1d-e829-4523-a35a-4ef79eef4bdf', 'UNSOLD'),
('1aeaf637-478c-435e-a355-5eee86d9a98a', '3cea56e5-17d9-443f-9f57-10086979a686', 'UNSOLD'),
('36349dbc-dda5-4ec0-9e13-21408dde2762', '13e9d10d-c35d-4027-94c8-0699207b92e5', 'UNSOLD'),
('0350e1e1-9650-4ab7-9e4e-02dfab765efb', 'cf5625dc-b5d7-4bc0-8bf9-957b38a57d7c', 'UNSOLD'),
('8e409652-16db-4217-b767-d28a098d0ad6', '664dfff5-6c02-444e-a0cf-ce889c4f164d', 'UNSOLD'),
('30f2f0ac-bf64-422a-bb31-f2f49caa908d', '4f611c41-cc28-4b7d-a24e-ad5de88ae335', 'UNSOLD'),
('15bc59ab-a035-450d-976f-d77116474b20', '79278035-b774-4e90-9c68-f3deeaaa96fc', 'UNSOLD'),
('0a43b699-05e5-4304-810b-c34d17bea0eb', '3f0c2f99-d3c0-458f-9a95-23d3c52f7322', 'UNSOLD'),
('5eab5044-9601-409d-8464-4be30abf7005', 'a8295153-f7ed-4e88-96c7-2b7e3637bb5a', 'UNSOLD'),
('2a1d30ba-accb-4b68-b618-08a35d045bda', 'dc3f00bb-4c5e-451a-95dc-6254d3a8836d', 'UNSOLD'),
('5c05bea4-6c8c-40e8-baad-b6258839f9f7', '540cbb3f-5781-4b86-88c2-b589edab76da', 'UNSOLD'),
('e3e1a0e6-01c2-4a22-bb21-a7c5054e9f31', '3ece84a7-914d-4bc1-99a1-9943293d4cfc', 'UNSOLD'),
('a80f96c5-b54f-46a2-bbf7-ccc1fe98d8fa', '33bda1d9-81f5-4b94-9515-674093898dc7', 'UNSOLD'),
('e69fa07e-0e48-4e67-b0e3-d8100c9dc6f3', 'ec7c2299-fb3f-498a-b4a3-bd1650bb568c', 'UNSOLD'),
('95a1bbfd-1862-40f3-9325-d669ba8a17e0', 'fff35337-fc8c-4963-9495-89f27387474f', 'UNSOLD'),
('d07f27ac-399f-462d-8758-2e6d67b770ed', 'd1826436-a921-4650-ac2f-885086cb7968', 'UNSOLD'),
('cad1750a-166b-48be-9d9c-188d36909337', '80d36971-121e-4ef6-b24e-2db8619a066c', 'UNSOLD'),
('47f5c298-fc70-4cfb-9c77-9d9b98e55f80', '318ba9e2-5124-4b4d-9d37-1e7e55786c1c', 'UNSOLD'),
('f39ef6ac-7051-4e96-836b-f728c238b43b', 'b19ac349-b53e-43fb-82f4-37a80a78cea0', 'UNSOLD'),
('67319903-90c0-4e25-8b47-2bbaa98fa48c', '5b4d7eeb-ccb5-42cd-94c6-48dea30ee8d4', 'UNSOLD'),
('3d783e48-5e65-4b0e-ad05-d23aa30a9294', 'd591f515-c0e4-4962-8a14-fbeb5021bfcc', 'UNSOLD'),
('98667850-c62b-4393-9153-15e25f5f0029', '05cae075-8f33-4a6c-a97c-4b316de2b058', 'UNSOLD'),
('0fcd8ce1-427e-4e23-bc1a-5e4e7918310e', 'dfe7ba9b-7267-497a-a661-789835cdf6c6', 'UNSOLD'),
('5c9fe152-f53a-485c-8148-18aef3b1b4e8', 'aa63b853-b4f7-4844-975a-b4ec08acb6a8', 'UNSOLD'),
('af8ffd94-5aec-4d6e-af16-bff2a0523966', '75fbe29a-23b3-468e-b348-68aa12c1bd50', 'UNSOLD'),
('30fbcd95-dd02-4607-b664-79b9743140a9', 'c08658ae-6c8b-42a0-9fdf-e1c50f48fa80', 'UNSOLD'),
('9cce5843-7b4d-4960-9157-8494f8bc2063', 'b0d088b0-d3cc-4d53-b83c-1cb17f2cb1a6', 'UNSOLD'),
('2993dbf9-7922-4410-89bb-6bbef19f809a', '1f112ed9-eb29-4b97-ad14-ef80bd782323', 'UNSOLD'),
('5e0fe1bf-0127-4d3f-ba66-f01aa07d320b', 'f07b8940-d559-4f4b-872a-5deb6d09c09f', 'UNSOLD'),
('84165ed3-b679-4590-b270-d5eb57cc198c', '7cfbf0f9-24f4-4af4-9cbe-34f59b261ad6', 'UNSOLD'),
('db7b90a4-e6b4-4cb4-9630-ec572a508281', 'c66f7e7d-f2a6-43da-818d-55032776b12c', 'UNSOLD'),
('469692af-ac35-4312-8ef2-2dc450269093', 'a0c5aa38-f9d8-41e1-83b8-d5fcd6df2d55', 'UNSOLD'),
('9d9258ca-0f41-4e8c-ab7b-d14e5daa7309', '6bfd2f1c-d2f4-4ef6-977c-e83c42563e3d', 'UNSOLD'),
('7effbd95-24fa-4892-8330-5723a4837d1f', 'e0b056ce-39d6-4ec8-ad8e-0031c9f9b8a3', 'UNSOLD'),
('6e72abd0-bf66-4ee6-a12e-d04c63c6ec91', 'de068d39-cc14-4146-857c-15c41fb8e94a', 'UNSOLD'),
('8ba5cac4-55e5-44cc-a581-a73643a28ee2', 'd1cca7c6-87fe-487e-b52c-101c899e8f8e', 'UNSOLD'),
('f12a9d94-d593-46d8-8c6b-974b68b0827f', '17534bd5-2c29-4a46-b889-b5672adaafd5', 'UNSOLD'),
('e3dd898c-df8b-456d-9346-f0f094fc0621', '174a0260-3c7d-4b4d-ad14-7a892d9b81ca', 'UNSOLD'),
('f761f63c-3353-4849-b904-51f3edc0e251', 'f3757c12-106f-454a-a735-958acd6d97d1', 'UNSOLD'),
('d53dc442-38d4-4963-bfc6-8770225f6608', '3c3867d1-58be-4399-9eb2-eb271f0ee29c', 'UNSOLD'),
('9a20311e-407b-4b69-ab61-1e8f0c9610f6', '3669a903-87b6-432d-af81-88bbcaf9318e', 'UNSOLD'),
('42186091-1742-4eec-a900-2035611c27ec', 'f8f6bcbc-70de-428d-bc79-a9136899877f', 'UNSOLD'),
('5047a9ac-2876-49db-9ddc-d3c2e9d9bf7d', '25f6a57c-f3ba-4998-b7f8-3c361be73d9d', 'UNSOLD'),
('16e1404f-8636-4ea5-bceb-87a49a8372eb', '2f5882df-ef40-4fb8-9aa4-e54505b5c8b0', 'UNSOLD'),
('a5039958-7427-4b04-8feb-a98c9fcc914f', '979cfc0f-30f9-42cb-8418-92ea3c70ef68', 'UNSOLD'),
('bb06e83c-2b0a-47ca-90e4-0d541112e821', '5b486774-1561-4ec5-8852-b49674b52d3b', 'UNSOLD'),
('cb7a34af-91d4-48cd-b84f-d9fbb16c2bf5', '13a01aa4-4df3-4dfb-901c-260034874787', 'UNSOLD'),
('82fc5a92-d896-4e3e-a908-1713c4aa0cbb', '196c3d5c-378c-4498-ae21-06d6947fa3ad', 'UNSOLD');

INSERT INTO "AdminUser" (id, username, password_hash, role) VALUES
('f98eefde-fb3e-4511-a1fe-9d9650148d66', 'admin', '$2b$10$aCb0IBsmb.mDrZVusvZ3fO01qZA5FQGr7FbhuOTDFi7HvAFZYJiGq', 'ADMIN'),
('64676e56-fdb5-4871-8acf-73c0f2e996bb', 'screen', '$2b$10$1v4.I0n8msvqv7U7hbqfYub3RHqK35.t31L7YrsIYNhjWtx5f46Dq', 'SCREEN');

INSERT INTO "AuctionSequence" (id, name, type, sequence_items) VALUES
(1, 'Franchise Auction', 'FRANCHISE', '[3,7,1,9,5,10,2,6,8,4]');

INSERT INTO "AuctionSequence" (id, name, type, sequence_items) VALUES
(2, 'Power Card Auction', 'POWER_CARD', '["GOD_EYE","MULLIGAN","FINAL_STRIKE","BID_FREEZER"]');

INSERT INTO "AuctionSequence" (id, name, type, sequence_items) VALUES
(3, 'Player Auction 5', 'PLAYER', '[152,75,154,16,138,73,106,90,155,100,80,93,41,118,18,69,103,105,102,88,126,136,115,129,68,44,150,157,14,65,4,127,140,91,142,144,28,58,82,50,43,34,143,119,37,123,23,89,64,24,85,62,148,149,96,63,98,45,15,87,70,101,32,10,67,35,132,27,153,130,159,33,12,66,79,133,1,156,125,120,59,83,84,74,121,146,141,117,124,97,139,52,51,107,72,86,39,29,108,135,3,60,110,158,77,9,31,95,81,49,151,113,109,111,116,54,122,137,26,40,92,71,20,57,36,53,11,47,42,6,145,114,7,134,112,30,2,25,94,38,76,131,17,46,19,56,21,104,99,5,147,61,48,8,78,22,55,13,128]');

INSERT INTO "AuctionState" (id, phase, auction_day) VALUES (1, 'NOT_STARTED', 'Day 2');

