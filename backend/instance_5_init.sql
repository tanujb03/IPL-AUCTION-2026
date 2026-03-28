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
('e3e24ec8-01c6-4649-ba3e-6b4c0d1c8d65', 'Team Alpha', 'alpha', '$2b$10$cSzEDBp9OQeuKa24q94uy.BGtzj7u8oYTpeMiSoumAm1hmIQAG4KO', 120, 0),
('0567fccd-30e6-4289-b748-16e50d3e55f5', 'Team Bravo', 'bravo', '$2b$10$08lozza9UC9ojiKiNWKYgu5DXg0em3lXeId3sMTyJPYihsudem2mC', 120, 0),
('1eda1e7b-c036-49c3-bd92-81a210624a3f', 'Team Charlie', 'charlie', '$2b$10$KxNHDLKQCCkcq8u1UPpTve1ak.4GBreeD2IvKZre98w.Qz/HtzX/e', 120, 0),
('09a1cda3-81c7-4fcf-becd-c62b1aa6ac88', 'Team Delta', 'delta', '$2b$10$9S4yqnM4EbLVU.BPYetE8OtE.PC2FR/h1c2rXCSfN5i.VCDAJWt76', 120, 0),
('47eb24c0-ced7-4d37-a069-022ac2c8c9c1', 'Team Echo', 'echo', '$2b$10$XXn14lAvme01QZnurnXZYO8waxBcgLAq8odD6Zdpm92Ygh/lmk4MO', 120, 0),
('308fbcd5-bf06-4ded-a660-33fae42cadca', 'Team Foxtrot', 'foxtrot', '$2b$10$flW7V4Wng.BOy.fdCrCl4ODrxth1E9pyJ5b5.C5VTo.FCSuA3ApGq', 120, 0),
('227b2d84-18c9-461d-a041-cbaca23d163d', 'Team Golf', 'golf', '$2b$10$cNcjCUGdBEcaGRoggay8hucufjUNRTZl766t94wjCOJBE9Ut0JA6y', 120, 0),
('c37f06a4-dccb-4ee2-a462-c4cd2661ce37', 'Team Hotel', 'hotel', '$2b$10$.ZpGS1kC1mwZrPyGgrp/ye3PIEoPLb5DpeuF6Rd0Y9y/kXMvtPhTe', 120, 0),
('3bd37941-ce9e-4d24-99df-e2b4f619ad71', 'Team India', 'india', '$2b$10$4X7sh01eB60B8K5NCPu3Gu.t5N2AUNpO31/hYOIhamQMC8CZudsRC', 120, 0),
('a6632405-7b8f-494e-bb89-fb10b2dface6', 'Team Juliet', 'juliet', '$2b$10$tuFoaI8MC0l.9vRTKX5U7eqdV56tQZDKDuTLOMhEZJjD28aA5X996', 120, 0);

INSERT INTO "Player" (id, rank, name, team, role, category, pool, grade, rating, nationality, nationality_raw, base_price, is_riddle, legacy, url, matches, bat_runs, bat_sr, bat_average, bowl_wickets, bowl_eco, bowl_avg, sub_scoring, sub_impact, sub_consistency, sub_experience, sub_wicket_taking, sub_economy, sub_efficiency, sub_batting, sub_bowling, sub_versatility) VALUES
('a01ce68c-1679-4ebc-8d4e-9747b80bf9a8', 152, 'Anukul Roy', 'Kolkata Knight Riders', 'Batting Allrounder', 'AR', 'AR', 'C', 56, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/12344/anukul-roy', 11.0, 26.0, NULL, NULL, 6.0, NULL, NULL, NULL, NULL, NULL, 35, NULL, NULL, NULL, 17.0, 29.0, 17.0),
('1c7dd826-a7e2-4b73-89ef-0f8768b58a08', 75, 'Karun Nair', 'Delhi Capitals', 'Batsman', 'BAT', 'BAT_WK', 'B', 70, 'INDIAN', 'Indian', 1, false, 0, 'https://www.cricbuzz.com/profiles/8257/karun-nair', 84.0, 1694.0, 131.73, 23.86, NULL, NULL, NULL, 35.0, 66.0, 60.0, 72, NULL, NULL, NULL, NULL, NULL, NULL),
('1edbf9e9-a83b-4c32-93ee-8b1175678e9d', 154, 'Nuwan Thushara', 'Royal Challengers Bengaluru', 'Bowler', 'BOWL', 'BOWL', 'C', 56, 'OVERSEAS', 'Sri Lankan', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/18509/nuwan-thushara', 8.0, NULL, NULL, NULL, 9.0, 9.43, 31.44, NULL, NULL, NULL, 34, 9.0, 49.0, 71.0, NULL, NULL, NULL),
('8776b8ff-b233-4bcb-9188-67449661af1e', 16, 'Suryakumar Yadav', 'Mumbai Indians', 'Batsman', 'BAT', 'BAT_WK', 'A', 89, 'INDIAN', 'Indian', 2, false, 2, 'https://www.cricbuzz.com/profiles/7915/suryakumar-yadav', 166.0, 4311.0, 148.66, 35.05, NULL, NULL, NULL, 82.0, 77.0, 87.0, 99, NULL, NULL, NULL, NULL, NULL, NULL),
('fde3bdcf-1c05-424f-8a55-f1486ffa4240', 138, 'Azmatullah Omarzai', 'Punjab Kings', 'Bowling Allrounder', 'AR', 'AR', 'C', 58, 'OVERSEAS', 'Afghan', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/13214/azmatullah-omarzai', 16.0, 99.0, NULL, NULL, 12.0, NULL, NULL, NULL, NULL, NULL, 38, NULL, NULL, NULL, 31.0, 25.0, 25.0),
('f799339a-579d-4753-9feb-682c213e7f05', 73, 'Tim David', 'Royal Challengers Bengaluru', 'Batsman', 'BAT', 'BAT_WK', 'B', 70, 'OVERSEAS', 'Singaporean', 1, false, 0, 'https://www.cricbuzz.com/profiles/13169/tim-david', 50.0, 846.0, 173.37, 32.54, NULL, NULL, NULL, 19.0, 94.0, 81.0, 55, NULL, NULL, NULL, NULL, NULL, NULL),
('f9bbc338-8e02-47cb-a740-aacdf3259995', 106, 'Sarfaraz Khan', 'Chennai Super Kings', 'Batsman', 'BAT', 'BAT_WK', 'C', 64, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/9429/sarfaraz-khan', 50.0, 585.0, 130.59, 22.5, NULL, NULL, NULL, 15.0, 65.0, 56.0, 55, NULL, NULL, NULL, NULL, NULL, NULL),
('fa734342-3ef8-40f8-b480-eb38b2f8dd2a', 90, 'Naman Dhir', 'Mumbai Indians', 'Batsman', 'BAT', 'BAT_WK', 'C', 67, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/36139/naman-dhir', 23.0, 392.0, 180.65, 28.0, NULL, NULL, NULL, 11.0, 99.0, 70.0, 41, NULL, NULL, NULL, NULL, NULL, NULL),
('4f10ef26-9643-42ae-8a31-38d7a0bf2f33', 155, 'Swapnil Singh', 'Royal Challengers Bengaluru', 'Bowling Allrounder', 'AR', 'AR', 'C', 56, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/10238/swapnil-singh', 14.0, 51.0, NULL, NULL, 7.0, NULL, NULL, NULL, NULL, NULL, 37, NULL, NULL, NULL, 23.0, 27.0, 23.0),
('60d879b9-fee9-4089-9655-6ad854284288', 100, 'Abishek Porel', 'Delhi Capitals', 'WK-Batsman', 'WK', 'BAT_WK', 'C', 66, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/24326/abishek-porel', 31.0, 661.0, 149.89, 25.42, NULL, NULL, NULL, 16.0, 78.0, 63.0, 45, NULL, NULL, NULL, NULL, NULL, NULL),
('052e6a0e-565f-4da2-bfc4-36e56a745151', 80, 'Lockie Ferguson', 'Punjab Kings', 'Bowler', 'BOWL', 'BOWL', 'C', 69, 'OVERSEAS', 'New Zealander', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/10692/lockie-ferguson', 49.0, NULL, NULL, NULL, 51.0, 8.97, 30.0, NULL, NULL, NULL, 54, 36.0, 56.0, 74.0, NULL, NULL, NULL),
('a20390a2-e729-4338-bddb-f3bcee147aa9', 93, 'Washington Sundar', 'Gujarat Titans', 'Bowling Allrounder', 'AR', 'AR', 'C', 67, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/10945/washington-sundar', 66.0, 511.0, NULL, NULL, 39.0, NULL, NULL, NULL, NULL, NULL, 63, NULL, NULL, NULL, 42.0, 40.0, 40.0),
('6ea037cb-b00e-4e35-b9d8-487c3671c5d4', 41, 'Nitish Rana', 'Delhi Capitals', 'Batsman', 'BAT', 'BAT_WK', 'B', 77, 'INDIAN', 'Indian', 1, false, 0, 'https://www.cricbuzz.com/profiles/9204/nitish-rana', 118.0, 2853.0, 136.77, 27.7, NULL, NULL, NULL, 56.0, 69.0, 69.0, 89, NULL, NULL, NULL, NULL, NULL, NULL),
('7e4bdee2-160d-4cbc-8d60-e3b38b8a0c64', 118, 'Aniket Verma', 'Sunrisers Hyderabad', 'Batsman', 'BAT', 'BAT_WK', 'C', 62, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/1447065/aniket-verma', 14.0, 236.0, 166.2, 26.22, NULL, NULL, NULL, 8.0, 89.0, 65.0, 37, NULL, NULL, NULL, NULL, NULL, NULL),
('25b05cd5-09b3-4d0d-8cff-53c5e1467ea3', 18, 'Rashid Khan', 'Gujarat Titans', 'Bowling Allrounder', 'AR', 'AR', 'A', 89, 'OVERSEAS', 'Afghan', 2, false, 8, 'https://www.cricbuzz.com/profiles/10738/rashid-khan', 136.0, 585.0, NULL, NULL, 158.0, NULL, NULL, NULL, NULL, NULL, 98, NULL, NULL, NULL, 51.0, 82.0, 51.0),
('90d6d192-b97d-43b3-930c-02b2f6b653ce', 69, 'Liam Livingstone', 'Sunrisers Hyderabad', 'Batting Allrounder', 'AR', 'AR', 'B', 70, 'OVERSEAS', 'English', 1, false, 0, 'https://www.cricbuzz.com/profiles/10045/liam-livingstone', 49.0, 1051.0, NULL, NULL, 13.0, NULL, NULL, NULL, NULL, NULL, 54, NULL, NULL, NULL, 70.0, 28.0, 28.0),
('fdc37fc5-3852-46e9-88f5-d69969505343', 103, 'Priyansh Arya', 'Punjab Kings', 'Batsman', 'BAT', 'BAT_WK', 'C', 64, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/14689/priyansh-arya', 17.0, 475.0, 179.25, 27.94, NULL, NULL, NULL, 13.0, 98.0, 70.0, 38, NULL, NULL, NULL, NULL, NULL, NULL),
('578c7874-69c0-43db-a604-c6ef17fcd7d1', 105, 'Mukesh Kumar', 'Delhi Capitals', 'Bowler', 'BOWL', 'BOWL', 'C', 64, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/10754/mukesh-kumar', 32.0, NULL, NULL, NULL, 36.0, 10.4, 30.61, NULL, NULL, NULL, 46, 27.0, 33.0, 73.0, NULL, NULL, NULL),
('e933726a-88d7-4db7-9fad-09b5cb92c685', 102, 'Angkrish Raghuvanshi', 'Kolkata Knight Riders', 'Batsman', 'BAT', 'BAT_WK', 'C', 65, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/22566/angkrish-raghuvanshi', 22.0, 463.0, 144.69, 28.94, NULL, NULL, NULL, 12.0, 75.0, 72.0, 41, NULL, NULL, NULL, NULL, NULL, NULL),
('a270df74-809f-47be-b6d3-d4ea3defa19b', 88, 'Harshit Rana', 'Kolkata Knight Riders', 'Bowler', 'BOWL', 'BOWL', 'C', 67, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/24729/harshit-rana', 33.0, NULL, NULL, NULL, 40.0, 9.51, 25.73, NULL, NULL, NULL, 46, 29.0, 47.0, 83.0, NULL, NULL, NULL),
('a482a5c3-7a11-4017-af44-2d6ce263aedd', 126, 'Nathan Ellis', 'Chennai Super Kings', 'Bowler', 'BOWL', 'BOWL', 'C', 61, 'OVERSEAS', 'Australian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/15480/nathan-ellis', 17.0, NULL, NULL, NULL, 19.0, 8.67, 28.74, NULL, NULL, NULL, 38, 16.0, 61.0, 77.0, NULL, NULL, NULL),
('7a830a64-41eb-433b-8f11-d80bd72a069a', 136, 'Arshad Khan', 'Gujarat Titans', 'Bowling Allrounder', 'AR', 'AR', 'C', 58, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/18637/arshad-khan', 19.0, 124.0, NULL, NULL, 12.0, NULL, NULL, NULL, NULL, NULL, 39, NULL, NULL, NULL, 39.0, 18.0, 18.0),
('bc18e222-aab7-4531-b2c2-09a66421f95c', 115, 'Rachin Ravindra', 'Kolkata Knight Riders', 'Batting Allrounder', 'AR', 'AR', 'C', 62, 'OVERSEAS', 'New Zealander', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/11177/rachin-ravindra', 18.0, 413.0, NULL, NULL, 0.0, NULL, NULL, NULL, NULL, NULL, 39, NULL, NULL, NULL, 49.0, 29.0, 29.0),
('46403b4d-7525-475c-9b81-5300e6a973bd', 129, 'Anuj Rawat', 'Gujarat Titans', 'WK-Batsman', 'WK', 'BAT_WK', 'C', 60, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/13135/anuj-rawat', 24.0, 318.0, 119.11, 19.88, NULL, NULL, NULL, 10.0, 57.0, 50.0, 42, NULL, NULL, NULL, NULL, NULL, NULL),
('099291bb-b76a-415a-843c-7a5f98e5d1be', 68, 'Anrich Nortje', 'Lucknow Super Giants', 'Bowler', 'BOWL', 'BOWL', 'B', 71, 'OVERSEAS', 'South African', 1, false, 0, 'https://www.cricbuzz.com/profiles/11427/anrich-nortje', 48.0, NULL, NULL, NULL, 61.0, 9.07, 27.16, NULL, NULL, NULL, 54, 43.0, 55.0, 80.0, NULL, NULL, NULL),
('4f10a84f-12ae-4147-a208-a4b56ccc207c', 44, 'Khaleel Ahmed', 'Chennai Super Kings', 'Bowler', 'BOWL', 'BOWL', 'B', 77, 'INDIAN', 'Indian', 1, false, 0, 'https://www.cricbuzz.com/profiles/10952/khaleel-ahmed', 71.0, NULL, NULL, NULL, 89.0, 8.98, 26.16, NULL, NULL, NULL, 65, 61.0, 56.0, 82.0, NULL, NULL, NULL),
('1e4eb95a-3d3e-46aa-8c92-0be7051680e3', 150, 'Adam Milne', 'Rajasthan Royals', 'Bowler', 'BOWL', 'BOWL', 'C', 56, 'OVERSEAS', 'New Zealander', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/7625/adam-milne', 10.0, NULL, NULL, NULL, 7.0, 9.48, 46.71, NULL, NULL, NULL, 35, 8.0, 48.0, 38.0, NULL, NULL, NULL),
('c1b2fae1-d296-4bc0-b978-849baee57924', 157, 'Manimaran Siddharth', 'Lucknow Super Giants', 'Bowler', 'BOWL', 'BOWL', 'C', 55, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/12930/manimaran-siddharth', 5.0, NULL, NULL, NULL, 3.0, 8.63, 46.0, NULL, NULL, NULL, 32, 5.0, 62.0, 40.0, NULL, NULL, NULL),
('20f4aad5-e975-4241-a523-5499e9ea0acb', 14, 'Ajinkya Rahane', 'Kolkata Knight Riders', 'Batsman', 'BAT', 'BAT_WK', 'A', 91, 'INDIAN', 'Indian', 2, false, 4, 'https://www.cricbuzz.com/profiles/1447/ajinkya-rahane', 198.0, 5032.0, 125.02, 30.5, NULL, NULL, NULL, 95.0, 61.0, 76.0, 99, NULL, NULL, NULL, NULL, NULL, NULL),
('243840bb-6f7f-48db-91ed-2e121ad02e36', 65, 'Tilak Varma', 'Mumbai Indians', 'Batsman', 'BAT', 'BAT_WK', 'B', 72, 'INDIAN', 'Indian', 1, false, 0, 'https://www.cricbuzz.com/profiles/14504/tilak-varma', 54.0, 1499.0, 144.42, 37.48, NULL, NULL, NULL, 31.0, 74.0, 93.0, 57, NULL, NULL, NULL, NULL, NULL, NULL),
('692b2df2-0a56-4286-8b8f-20c3c67cb230', 4, 'Sunil Narine', 'Kolkata Knight Riders', 'Bowling Allrounder', 'AR', 'AR', 'A', 98, 'OVERSEAS', 'West Indian', 2, false, 10, 'https://www.cricbuzz.com/profiles/2276/sunil-narine', 188.0, 1780.0, NULL, NULL, 192.0, NULL, NULL, NULL, NULL, NULL, 99, NULL, NULL, NULL, 84.0, 83.0, 83.0),
('1dc17803-662c-4622-be73-5d084a244271', 127, 'Digvesh Singh Rathi', 'Lucknow Super Giants', 'Bowler', 'BOWL', 'BOWL', 'C', 61, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/1448289/digvesh-singh-rathi', 13.0, NULL, NULL, NULL, 14.0, 8.25, 30.64, NULL, NULL, NULL, 36, 12.0, 68.0, 72.0, NULL, NULL, NULL),
('8c6ed68e-c1fd-4c67-8ef3-e3a8827afb80', 140, 'Mukesh Choudhary', 'Chennai Super Kings', 'Bowler', 'BOWL', 'BOWL', 'C', 58, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/13184/mukesh-choudhary', 16.0, NULL, NULL, NULL, 17.0, 9.94, 30.71, NULL, NULL, NULL, 38, 14.0, 40.0, 72.0, NULL, NULL, NULL),
('a04416da-5fb5-465d-b8b2-f5701ed8af39', 91, 'Shahrukh Khan', 'Gujarat Titans', 'Batting Allrounder', 'AR', 'AR', 'C', 67, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/10226/shahrukh-khan', 55.0, 732.0, NULL, NULL, 1.0, NULL, NULL, NULL, NULL, NULL, 57, NULL, NULL, NULL, 56.0, 27.0, 27.0),
('34cb40a9-f7dc-4846-8f0b-f7ad1fd29d36', 142, 'Kamindu Mendis', 'Sunrisers Hyderabad', 'Batting Allrounder', 'AR', 'AR', 'C', 57, 'OVERSEAS', 'Sri Lankan', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/10940/kamindu-mendis', 5.0, 92.0, NULL, NULL, 2.0, NULL, NULL, NULL, NULL, NULL, 32, NULL, NULL, NULL, 38.0, 29.0, 29.0),
('58c6351e-64c5-4d1c-b198-8a1b443cfb60', 144, 'Vijaykumar Vyshak', 'Punjab Kings', 'Bowler', 'BOWL', 'BOWL', 'C', 57, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/10486/vijaykumar-vyshak', 16.0, NULL, NULL, NULL, 17.0, 10.38, 33.88, NULL, NULL, NULL, 38, 14.0, 33.0, 66.0, NULL, NULL, NULL),
('e3efb923-a17d-45b4-af86-8cb82392ee1c', 28, 'Kuldeep Yadav', 'Delhi Capitals', 'Bowler', 'BOWL', 'BOWL', 'B', 83, 'INDIAN', 'Indian', 1, false, 2, 'https://www.cricbuzz.com/profiles/8292/kuldeep-yadav', 98.0, NULL, NULL, NULL, 102.0, 8.04, 26.95, NULL, NULL, NULL, 79, 69.0, 71.0, 80.0, NULL, NULL, NULL),
('f4c53c57-83c3-4ff3-b2bd-08eb398081ac', 58, 'Riyan Parag', 'Rajasthan Royals', 'Batting Allrounder', 'AR', 'AR', 'B', 73, 'INDIAN', 'Indian', 1, false, 2, 'https://www.cricbuzz.com/profiles/12305/riyan-parag', 83.0, 1566.0, NULL, NULL, 7.0, NULL, NULL, NULL, NULL, NULL, 71, NULL, NULL, NULL, 78.0, 16.0, 16.0),
('494b90db-1528-416e-b1b1-d781765a6f6a', 82, 'Jitesh Sharma', 'Royal Challengers Bengaluru', 'WK-Batsman', 'WK', 'BAT_WK', 'C', 68, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/10214/jitesh-sharma', 55.0, 991.0, 157.06, 25.41, NULL, NULL, NULL, 22.0, 83.0, 63.0, 57, NULL, NULL, NULL, NULL, NULL, NULL),
('526e91f3-baa6-4a7a-bc6f-bb9870b05510', 50, 'Mitchell Marsh', 'Lucknow Super Giants', 'Batting Allrounder', 'AR', 'AR', 'B', 74, 'OVERSEAS', 'Australian', 1, false, 0, 'https://www.cricbuzz.com/profiles/6250/mitchell-marsh', 55.0, 1292.0, NULL, NULL, 37.0, NULL, NULL, NULL, NULL, NULL, 57, NULL, NULL, NULL, 72.0, 43.0, 43.0),
('06de1d79-f4c7-472c-9e79-1cc8dd7afcaf', 43, 'Abhishek Sharma', 'Sunrisers Hyderabad', 'Batting Allrounder', 'AR', 'AR', 'B', 77, 'INDIAN', 'Indian', 1, false, 2, 'https://www.cricbuzz.com/profiles/12086/abhishek-sharma', 77.0, 1815.0, NULL, NULL, 11.0, NULL, NULL, NULL, NULL, NULL, 68, NULL, NULL, NULL, 90.0, 24.0, 24.0),
('e358dedd-d046-4c9e-bc03-998c281b24eb', 34, 'Quinton de Kock', 'Mumbai Indians', 'WK-Batsman', 'WK', 'BAT_WK', 'B', 79, 'OVERSEAS', 'South African', 1, false, 0, 'https://www.cricbuzz.com/profiles/8520/quinton-de-kock', 115.0, 3309.0, 134.03, 30.64, NULL, NULL, NULL, 64.0, 67.0, 76.0, 87, NULL, NULL, NULL, NULL, NULL, NULL),
('5871e856-9e3a-45d9-8d35-da33e1bc7ad4', 143, 'Prashant Solanki', 'Kolkata Knight Riders', 'Bowler', 'BOWL', 'BOWL', 'C', 57, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/12805/prashant-solanki', 2.0, NULL, NULL, NULL, 2.0, 6.33, 19.0, NULL, NULL, NULL, 31, 5.0, 99.0, 97.0, NULL, NULL, NULL),
('b7f01bd3-3c1e-4105-8a40-5648688ef890', 119, 'Wanindu Hasaranga', 'Lucknow Super Giants', 'Bowling Allrounder', 'AR', 'AR', 'C', 62, 'OVERSEAS', 'Sri Lankan', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/10926/wanindu-hasaranga', 37.0, 81.0, NULL, NULL, 46.0, NULL, NULL, NULL, NULL, NULL, 48, NULL, NULL, NULL, 15.0, 45.0, 15.0),
('d9f99047-b867-4f71-acbf-7fab1e21f14f', 37, 'Ishan Kishan', 'Sunrisers Hyderabad', 'WK-Batsman', 'WK', 'BAT_WK', 'B', 78, 'INDIAN', 'Indian', 1, false, 0, 'https://www.cricbuzz.com/profiles/10276/ishan-kishan', 119.0, 2998.0, 137.65, 29.11, NULL, NULL, NULL, 58.0, 70.0, 72.0, 89, NULL, NULL, NULL, NULL, NULL, NULL),
('917c3436-0eb0-465a-8603-761f9845761a', 123, 'Ayush Mhatre', 'Chennai Super Kings', 'Batsman', 'BAT', 'BAT_WK', 'C', 61, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/1431163/ayush-mhatre', 7.0, 240.0, 188.98, 34.29, NULL, NULL, NULL, 8.0, 99.0, 85.0, 33, NULL, NULL, NULL, NULL, NULL, NULL),
('b5e480b7-e1be-4615-824a-b9539a586273', 23, 'Shubman Gill', 'Gujarat Titans', 'Batsman', 'BAT', 'BAT_WK', 'B', 84, 'INDIAN', 'Indian', 1, false, 0, 'https://www.cricbuzz.com/profiles/11808/shubman-gill', 118.0, 3866.0, 138.72, 39.45, NULL, NULL, NULL, 74.0, 70.0, 98.0, 89, NULL, NULL, NULL, NULL, NULL, NULL),
('ed390f3a-fde3-4fd7-a5aa-b00ebed1399b', 89, 'Dhruv Jurel', 'Rajasthan Royals', 'WK-Batsman', 'WK', 'BAT_WK', 'C', 67, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/14691/dhruv-jurel', 41.0, 680.0, 153.85, 28.33, NULL, NULL, NULL, 16.0, 81.0, 71.0, 50, NULL, NULL, NULL, NULL, NULL, NULL),
('1a35b702-cefd-4ac8-8e09-2421fcdbacaf', 64, 'Shreyas Gopal', 'Chennai Super Kings', 'Bowler', 'BOWL', 'BOWL', 'B', 72, 'INDIAN', 'Indian', 1, false, 0, 'https://www.cricbuzz.com/profiles/9746/shreyas-gopal', 52.0, NULL, NULL, NULL, 52.0, 8.16, 25.92, NULL, NULL, NULL, 56, 37.0, 69.0, 83.0, NULL, NULL, NULL),
('5f12ec4d-0104-4d97-89f9-9a664eec4a14', 24, 'Varun Chakaravarthy', 'Kolkata Knight Riders', 'Bowler', 'BOWL', 'BOWL', 'B', 84, 'INDIAN', 'Indian', 1, false, 2, 'https://www.cricbuzz.com/profiles/12926/varun-chakaravarthy', 83.0, NULL, NULL, NULL, 100.0, 7.58, 23.85, NULL, NULL, NULL, 71, 68.0, 79.0, 87.0, NULL, NULL, NULL),
('102b5d58-51dc-470b-b4ee-cb459b71236a', 85, 'Mohsin Khan', 'Lucknow Super Giants', 'Bowler', 'BOWL', 'BOWL', 'C', 67, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/13534/mohsin-khan', 24.0, NULL, NULL, NULL, 27.0, 8.51, 25.52, NULL, NULL, NULL, 42, 21.0, 64.0, 83.0, NULL, NULL, NULL),
('bcdc0e0f-5bc6-4360-bfbc-0d251ac5c3b4', 62, 'Shimron Hetmyer', 'Rajasthan Royals', 'Batsman', 'BAT', 'BAT_WK', 'B', 72, 'OVERSEAS', 'West Indian', 1, false, 0, 'https://www.cricbuzz.com/profiles/9789/shimron-hetmyer', 86.0, 1482.0, 151.85, 29.06, NULL, NULL, NULL, 31.0, 79.0, 72.0, 73, NULL, NULL, NULL, NULL, NULL, NULL),
('d57f86a7-3585-481c-bbef-6e3c7c283e0e', 148, 'Vignesh Puthur', 'Rajasthan Royals', 'Bowler', 'BOWL', 'BOWL', 'C', 57, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/1447337/vignesh-puthur', 5.0, NULL, NULL, NULL, 6.0, 9.08, 18.17, NULL, NULL, NULL, 32, 7.0, 54.0, 99.0, NULL, NULL, NULL),
('7b1fcea3-e03c-4470-8fce-ba8a47c09522', 149, 'Glenn Phillips', 'Gujarat Titans', 'Batting Allrounder', 'AR', 'AR', 'C', 56, 'OVERSEAS', 'New Zealander', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/10693/glenn-phillips', 8.0, 65.0, NULL, NULL, 2.0, NULL, NULL, NULL, NULL, NULL, 34, NULL, NULL, NULL, 24.0, 34.0, 24.0),
('bb91b1b3-ce90-410c-a99d-9301f31211ab', 96, 'Vaibhav Arora', 'Kolkata Knight Riders', 'Bowler', 'BOWL', 'BOWL', 'C', 66, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/15861/vaibhav-arora', 32.0, NULL, NULL, NULL, 36.0, 9.55, 28.22, NULL, NULL, NULL, 46, 27.0, 47.0, 78.0, NULL, NULL, NULL),
('281c4b8a-3fce-4aa7-b57a-4b717170d3c3', 63, 'T Natarajan', 'Delhi Capitals', 'Bowler', 'BOWL', 'BOWL', 'B', 72, 'INDIAN', 'Indian', 1, false, 0, 'https://www.cricbuzz.com/profiles/10225/t-natarajan', 63.0, NULL, NULL, NULL, 67.0, 8.94, 30.12, NULL, NULL, NULL, 61, 47.0, 57.0, 74.0, NULL, NULL, NULL),
('cb021023-1685-4739-bb08-51db0e488e00', 98, 'Shivam Mavi', 'Sunrisers Hyderabad', 'Bowler', 'BOWL', 'BOWL', 'C', 66, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/12345/shivam-mavi', 32.0, NULL, NULL, NULL, 30.0, 8.71, 31.4, NULL, NULL, NULL, 46, 23.0, 60.0, 71.0, NULL, NULL, NULL),
('73393dc8-0de3-4ba4-a308-d7e17633a3f7', 45, 'Shivam Dube', 'Chennai Super Kings', 'Batting Allrounder', 'AR', 'AR', 'B', 76, 'INDIAN', 'Indian', 1, false, 2, 'https://www.cricbuzz.com/profiles/11195/shivam-dube', 79.0, 1859.0, NULL, NULL, 5.0, NULL, NULL, NULL, NULL, NULL, 69, NULL, NULL, NULL, 88.0, 20.0, 20.0),
('063a22fb-d409-4806-8c41-81e42024469c', 15, 'Sanju Samson', 'Chennai Super Kings', 'WK-Batsman', 'WK', 'BAT_WK', 'A', 89, 'INDIAN', 'Indian', 2, false, 2, 'https://www.cricbuzz.com/profiles/8271/sanju-samson', 176.0, 4704.0, 139.05, 30.75, NULL, NULL, NULL, 89.0, 71.0, 76.0, 99, NULL, NULL, NULL, NULL, NULL, NULL),
('3a5f94ec-a4fc-4bbb-951a-74f9634f1c57', 87, 'Tushar Deshpande', 'Rajasthan Royals', 'Bowler', 'BOWL', 'BOWL', 'C', 67, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/11307/tushar-deshpande', 46.0, NULL, NULL, NULL, 51.0, 9.84, 31.04, NULL, NULL, NULL, 53, 36.0, 42.0, 72.0, NULL, NULL, NULL),
('a482f65c-ef80-403e-9913-e96aebd8d930', 70, 'Venkatesh Iyer', 'Royal Challengers Bengaluru', 'Batting Allrounder', 'AR', 'AR', 'B', 70, 'INDIAN', 'Indian', 1, false, 0, 'https://www.cricbuzz.com/profiles/10917/venkatesh-iyer', 61.0, 1468.0, NULL, NULL, 3.0, NULL, NULL, NULL, NULL, NULL, 60, NULL, NULL, NULL, 77.0, 16.0, 16.0),
('f1c9a658-4854-44e1-96a9-46f56f040889', 101, 'Umran Malik', 'Kolkata Knight Riders', 'Bowler', 'BOWL', 'BOWL', 'C', 65, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/19027/umran-malik', 26.0, NULL, NULL, NULL, 29.0, 9.4, 26.62, NULL, NULL, NULL, 43, 22.0, 49.0, 81.0, NULL, NULL, NULL),
('416e34b8-cc64-4f11-b088-5e56e1e2efed', 32, 'David Miller', 'Delhi Capitals', 'Batsman', 'BAT', 'BAT_WK', 'B', 80, 'OVERSEAS', 'South African', 1, false, 0, 'https://www.cricbuzz.com/profiles/6349/david-miller', 141.0, 3077.0, 138.61, 35.78, NULL, NULL, NULL, 60.0, 70.0, 89.0, 99, NULL, NULL, NULL, NULL, NULL, NULL),
('39a5d83b-4fc6-4ba6-b5ab-219eb0de9a4f', 10, 'Harshal Patel', 'Sunrisers Hyderabad', 'Bowler', 'BOWL', 'BOWL', 'A', 94, 'INDIAN', 'Indian', 2, false, 6, 'https://www.cricbuzz.com/profiles/8175/harshal-patel', 119.0, NULL, NULL, NULL, 151.0, 8.86, 23.7, NULL, NULL, NULL, 89, 99.0, 58.0, 87.0, NULL, NULL, NULL),
('70b70d06-3734-4bbc-a89d-e5ebc7af5c15', 67, 'Ayush Badoni', 'Lucknow Super Giants', 'Batting Allrounder', 'AR', 'AR', 'B', 71, 'INDIAN', 'Indian', 1, false, 0, 'https://www.cricbuzz.com/profiles/13907/ayush-badoni', 56.0, 963.0, NULL, NULL, 4.0, NULL, NULL, NULL, NULL, NULL, 58, NULL, NULL, NULL, 63.0, 37.0, 37.0),
('9427ed2a-b740-43cb-a27e-e84f9be4d65e', 35, 'Deepak Chahar', 'Mumbai Indians', 'Bowler', 'BOWL', 'BOWL', 'B', 78, 'INDIAN', 'Indian', 1, false, 0, 'https://www.cricbuzz.com/profiles/7836/deepak-chahar', 95.0, NULL, NULL, NULL, 88.0, 8.14, 29.51, NULL, NULL, NULL, 77, 60.0, 70.0, 75.0, NULL, NULL, NULL),
('ecf67775-233c-4817-8307-dde6cc17564b', 132, 'Kuldeep Sen', 'Rajasthan Royals', 'Bowler', 'BOWL', 'BOWL', 'C', 59, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/14336/kuldeep-sen', 12.0, NULL, NULL, NULL, 14.0, 9.63, 27.64, NULL, NULL, NULL, 36, 12.0, 45.0, 79.0, NULL, NULL, NULL),
('2f014af0-6f53-4775-954d-2e90434a7833', 27, 'Shreyas Iyer', 'Punjab Kings', 'Batsman', 'BAT', 'BAT_WK', 'B', 83, 'INDIAN', 'Indian', 1, false, 0, 'https://www.cricbuzz.com/profiles/9428/shreyas-iyer', 132.0, 3731.0, 133.35, 34.23, NULL, NULL, NULL, 72.0, 67.0, 85.0, 96, NULL, NULL, NULL, NULL, NULL, NULL),
('054d7ec4-4c8b-4023-abf6-4251e5d0c855', 153, 'Urvil Patel', 'Chennai Super Kings', 'WK-Batsman', 'WK', 'BAT_WK', 'C', 56, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/13476/urvil-patel', 3.0, 68.0, 212.5, 22.67, NULL, NULL, NULL, 5.0, 99.0, 57.0, 31, NULL, NULL, NULL, NULL, NULL, NULL),
('7000f2fe-1c8e-41f0-a7e3-2fbb2b9b911b', 130, 'Sameer Rizvi', 'Delhi Capitals', 'Batsman', 'BAT', 'BAT_WK', 'C', 60, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/14700/sameer-rizvi', 13.0, 172.0, 140.99, 24.57, NULL, NULL, NULL, 7.0, 72.0, 61.0, 36, NULL, NULL, NULL, NULL, NULL, NULL),
('dd7978da-148a-40e6-9230-c36700b614fb', 159, 'Rasikh Dar Salam', 'Royal Challengers Bengaluru', 'Bowler', 'BOWL', 'BOWL', 'C', 55, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/14274/rasikh-dar-salam', 13.0, NULL, NULL, NULL, 10.0, 10.62, 40.9, NULL, NULL, NULL, 36, 10.0, 29.0, 51.0, NULL, NULL, NULL),
('a422e94e-fd6d-45fc-bffd-fb70ca329b71', 33, 'Ishant Sharma', 'Gujarat Titans', 'Bowler', 'BOWL', 'BOWL', 'B', 79, 'INDIAN', 'Indian', 1, false, 0, 'https://www.cricbuzz.com/profiles/702/ishant-sharma', 117.0, NULL, NULL, NULL, 96.0, 8.38, 35.18, NULL, NULL, NULL, 88, 65.0, 66.0, 63.0, NULL, NULL, NULL),
('be99ce63-869a-490f-87c7-c30764e8cccf', 12, 'Trent Boult', 'Mumbai Indians', 'Bowler', 'BOWL', 'BOWL', 'A', 92, 'OVERSEAS', 'New Zealander', 2, false, 4, 'https://www.cricbuzz.com/profiles/8117/trent-boult', 119.0, NULL, NULL, NULL, 143.0, 8.38, 26.2, NULL, NULL, NULL, 89, 96.0, 66.0, 82.0, NULL, NULL, NULL),
('3ae2f289-4a77-4dad-9e8a-952cb37e685d', 66, 'Philip Salt', 'Royal Challengers Bengaluru', 'WK-Batsman', 'WK', 'BAT_WK', 'B', 71, 'OVERSEAS', 'English', 1, false, 0, 'https://www.cricbuzz.com/profiles/10479/philip-salt', 34.0, 1056.0, 175.71, 34.06, NULL, NULL, NULL, 23.0, 95.0, 84.0, 47, NULL, NULL, NULL, NULL, NULL, NULL),
('102d85e9-d9f8-4e7f-884d-ba44d4e35fdb', 79, 'Prabhsimran Singh', 'Punjab Kings', 'WK-Batsman', 'WK', 'BAT_WK', 'C', 69, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/14254/prabhsimran-singh', 51.0, 1305.0, 151.93, 25.59, NULL, NULL, NULL, 28.0, 79.0, 64.0, 55, NULL, NULL, NULL, NULL, NULL, NULL),
('fa5423f3-7164-4655-a65f-81d04c95df7a', 133, 'Kyle Jamieson', 'Delhi Capitals', 'Bowler', 'BOWL', 'BOWL', 'C', 59, 'OVERSEAS', 'New Zealander', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/9441/kyle-jamieson', 13.0, NULL, NULL, NULL, 14.0, 9.67, 29.71, NULL, NULL, NULL, 36, 12.0, 45.0, 74.0, NULL, NULL, NULL),
('a42d6b42-d219-42e7-b502-023e0a8db9a8', 1, 'Virat Kohli', 'Royal Challengers Bengaluru', 'Batsman', 'BAT', 'BAT_WK', 'A', 99, 'INDIAN', 'Indian', 2, false, 10, 'https://www.cricbuzz.com/profiles/1413/virat-kohli', 267.0, 8661.0, 132.86, 39.55, NULL, NULL, NULL, 99.0, 67.0, 98.0, 99, NULL, NULL, NULL, NULL, NULL, NULL),
('575fe83f-f13a-4ff4-b032-a86259821f1a', 156, 'Matthew Short', 'Chennai Super Kings', 'Batsman', 'BAT', 'BAT_WK', 'C', 55, 'OVERSEAS', 'Australian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/9456/matthew-short', 6.0, 117.0, 127.18, 19.5, NULL, NULL, NULL, 6.0, 63.0, 49.0, 33, NULL, NULL, NULL, NULL, NULL, NULL),
('e7259039-b1d4-43fb-9185-2c7440959e3f', 125, 'Vaibhav Suryavanshi', 'Rajasthan Royals', 'Batsman', 'BAT', 'BAT_WK', 'C', 61, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/51791/vaibhav-suryavanshi', 7.0, 252.0, 206.56, 36.0, NULL, NULL, NULL, 9.0, 99.0, 89.0, 33, NULL, NULL, NULL, NULL, NULL, NULL),
('8f3b67a7-394e-45e1-a6bb-f2eb61aaeac7', 120, 'Ravisrinivasan Sai Kishore', 'Gujarat Titans', 'Bowling Allrounder', 'AR', 'AR', 'C', 61, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/11595/ravisrinivasan-sai-kishore', 25.0, 18.0, NULL, NULL, 32.0, NULL, NULL, NULL, NULL, NULL, 42, NULL, NULL, NULL, 19.0, 41.0, 19.0),
('84ba1ece-05a5-4fd9-9679-56fec7bad250', 59, 'Rahul Tewatia', 'Gujarat Titans', 'Batting Allrounder', 'AR', 'AR', 'B', 73, 'INDIAN', 'Indian', 1, false, 0, 'https://www.cricbuzz.com/profiles/9693/rahul-tewatia', 108.0, 1112.0, NULL, NULL, 32.0, NULL, NULL, NULL, NULL, NULL, 84, NULL, NULL, NULL, 64.0, 38.0, 38.0),
('77d3888a-d81f-4bf7-aca5-ec6b28c3c555', 83, 'Jason Holder', 'Gujarat Titans', 'Bowling Allrounder', 'AR', 'AR', 'C', 68, 'OVERSEAS', 'West Indian', 0.5, false, 2, 'https://www.cricbuzz.com/profiles/8313/jason-holder', 46.0, 259.0, NULL, NULL, 53.0, NULL, NULL, NULL, NULL, NULL, 53, NULL, NULL, NULL, 32.0, 45.0, 32.0),
('d148fe94-2b77-4894-91c7-fee7830d95b9', 84, 'Cameron Green', 'Kolkata Knight Riders', 'Batting Allrounder', 'AR', 'AR', 'C', 68, 'OVERSEAS', 'Australian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/12225/cameron-green', 29.0, 707.0, NULL, NULL, 16.0, NULL, NULL, NULL, NULL, NULL, 44, NULL, NULL, NULL, 64.0, 27.0, 27.0),
('953afdd3-0106-4df6-aa75-f17fd323dd5c', 74, 'Devdutt Padikkal', 'Royal Challengers Bengaluru', 'Batsman', 'BAT', 'BAT_WK', 'B', 70, 'INDIAN', 'Indian', 1, false, 0, 'https://www.cricbuzz.com/profiles/13088/devdutt-padikkal', 74.0, 1806.0, 126.3, 25.44, NULL, NULL, NULL, 37.0, 62.0, 64.0, 67, NULL, NULL, NULL, NULL, NULL, NULL),
('47faa5c2-5fa0-4513-ab9e-9fbdc4666036', 121, 'Suyash Sharma', 'Royal Challengers Bengaluru', 'Bowler', 'BOWL', 'BOWL', 'C', 61, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/36487/suyash-sharma', 27.0, NULL, NULL, NULL, 18.0, 8.75, 45.22, NULL, NULL, NULL, 43, 15.0, 60.0, 41.0, NULL, NULL, NULL),
('066d9e33-79ba-40e9-92d1-c9d56a399996', 146, 'Anshul Kamboj', 'Chennai Super Kings', 'Bowling Allrounder', 'AR', 'AR', 'C', 57, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/14598/anshul-kamboj', 11.0, 16.0, NULL, NULL, 10.0, NULL, NULL, NULL, NULL, NULL, 35, NULL, NULL, NULL, 21.0, 30.0, 21.0),
('6538b113-71d2-4849-bd25-8635065f24fc', 141, 'Eshan Malinga', 'Sunrisers Hyderabad', 'Bowler', 'BOWL', 'BOWL', 'C', 58, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/46926/eshan-malinga', 7.0, NULL, NULL, NULL, 13.0, 8.93, 18.31, NULL, NULL, NULL, 33, 12.0, 57.0, 99.0, NULL, NULL, NULL),
('e1beb58b-e34a-49a8-808d-a2f105875e0b', 117, 'Dewald Brevis', 'Chennai Super Kings', 'Batsman', 'BAT', 'BAT_WK', 'C', 62, 'OVERSEAS', 'South African', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/20538/dewald-brevis', 16.0, 455.0, 153.2, 28.44, NULL, NULL, NULL, 12.0, 80.0, 71.0, 38, NULL, NULL, NULL, NULL, NULL, NULL),
('c0d88595-7e8f-4d06-b1ab-f38b7c604762', 124, 'Shubham Dubey', 'Rajasthan Royals', 'Batsman', 'BAT', 'BAT_WK', 'C', 61, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/19328/shubham-dubey', 13.0, 139.0, 163.53, 23.17, NULL, NULL, NULL, 6.0, 87.0, 58.0, 36, NULL, NULL, NULL, NULL, NULL, NULL),
('41a83f40-933b-4737-b0a1-7ebbca5f4f53', 97, 'Ramandeep Singh', 'Kolkata Knight Riders', 'Batting Allrounder', 'AR', 'AR', 'C', 66, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/12337/ramandeep-singh', 30.0, 217.0, NULL, NULL, 6.0, NULL, NULL, NULL, NULL, NULL, 45, NULL, NULL, NULL, 46.0, 35.0, 35.0),
('71b8acb7-4d45-4f40-9386-2521c7a54912', 139, 'Nandre Burger', 'Rajasthan Royals', 'Bowler', 'BOWL', 'BOWL', 'C', 58, 'OVERSEAS', 'South African', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/13630/nandre-burger', 5.0, NULL, NULL, NULL, 7.0, 8.53, 20.71, NULL, NULL, NULL, 32, 8.0, 63.0, 94.0, NULL, NULL, NULL),
('6acea564-c0dc-4a29-8b7b-f089ff7a5d70', 52, 'Rahul Tripathi', 'Kolkata Knight Riders', 'Batsman', 'BAT', 'BAT_WK', 'B', 74, 'INDIAN', 'Indian', 1, false, 0, 'https://www.cricbuzz.com/profiles/9012/rahul-tripathi', 100.0, 2291.0, 137.85, 26.03, NULL, NULL, NULL, 46.0, 70.0, 65.0, 80, NULL, NULL, NULL, NULL, NULL, NULL),
('4b87a12a-b138-443b-af98-c485a5621100', 51, 'Sam Curran', 'Rajasthan Royals', 'Bowling Allrounder', 'AR', 'AR', 'B', 74, 'OVERSEAS', 'English', 1, false, 2, 'https://www.cricbuzz.com/profiles/10420/sam-curran', 64.0, 997.0, NULL, NULL, 59.0, NULL, NULL, NULL, NULL, NULL, 62, NULL, NULL, NULL, 62.0, 41.0, 41.0),
('7b4ae361-d05e-422c-9118-f72d4c4b4a3b', 107, 'Shahbaz Ahmed', 'Lucknow Super Giants', 'Bowling Allrounder', 'AR', 'AR', 'C', 64, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/14606/shahbaz-ahmed', 58.0, 545.0, NULL, NULL, 22.0, NULL, NULL, NULL, NULL, NULL, 59, NULL, NULL, NULL, 43.0, 27.0, 27.0),
('9966fc3f-be7c-4b8b-805e-5319e8dda289', 72, 'Aiden Markram', 'Lucknow Super Giants', 'Batsman', 'BAT', 'BAT_WK', 'B', 70, 'OVERSEAS', 'South African', 1, false, 0, 'https://www.cricbuzz.com/profiles/9582/aiden-markram', 57.0, 1440.0, 135.09, 31.3, NULL, NULL, NULL, 30.0, 68.0, 78.0, 58, NULL, NULL, NULL, NULL, NULL, NULL),
('1ae4e018-9303-4934-b8af-1d79d0e527d9', 86, 'Mayank Markande', 'Mumbai Indians', 'Bowler', 'BOWL', 'BOWL', 'C', 67, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/12627/mayank-markande', 37.0, NULL, NULL, NULL, 37.0, 8.91, 28.89, NULL, NULL, NULL, 48, 27.0, 57.0, 76.0, NULL, NULL, NULL),
('a89c4b16-766d-45a8-8a41-e4765823440e', 39, 'Nicholas Pooran', 'Lucknow Super Giants', 'WK-Batsman', 'WK', 'BAT_WK', 'B', 78, 'OVERSEAS', 'West Indian', 1, false, 0, 'https://www.cricbuzz.com/profiles/9406/nicholas-pooran', 90.0, 2293.0, 168.98, 34.22, NULL, NULL, NULL, 46.0, 91.0, 85.0, 75, NULL, NULL, NULL, NULL, NULL, NULL),
('12b4c50c-92dc-46ce-bea3-856d9a133f3c', 29, 'Mohammed Siraj', 'Gujarat Titans', 'Bowler', 'BOWL', 'BOWL', 'B', 83, 'INDIAN', 'Indian', 1, false, 2, 'https://www.cricbuzz.com/profiles/10808/mohammed-siraj', 108.0, NULL, NULL, NULL, 109.0, 8.74, 30.72, NULL, NULL, NULL, 84, 74.0, 60.0, 72.0, NULL, NULL, NULL),
('f6582afd-549e-47b7-91f0-f17c7c106096', 108, 'Rovman Powell', 'Kolkata Knight Riders', 'Batsman', 'BAT', 'BAT_WK', 'C', 63, 'OVERSEAS', 'West Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/11445/rovman-powell', 28.0, 365.0, 146.59, 18.25, NULL, NULL, NULL, 11.0, 76.0, 46.0, 44, NULL, NULL, NULL, NULL, NULL, NULL),
('0a762af0-3950-4cde-ae66-fbfe5c366537', 135, 'Kartik Tyagi', 'Kolkata Knight Riders', 'Bowler', 'BOWL', 'BOWL', 'C', 58, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/13136/kartik-tyagi', 20.0, NULL, NULL, NULL, 15.0, 10.14, 47.53, NULL, NULL, NULL, 40, 13.0, 37.0, 37.0, NULL, NULL, NULL),
('fc113c91-b465-4160-b274-8415e05d8d98', 3, 'Jasprit Bumrah', 'Mumbai Indians', 'Bowler', 'BOWL', 'BOWL', 'A', 99, 'INDIAN', 'Indian', 2, false, 8, 'https://www.cricbuzz.com/profiles/9311/jasprit-bumrah', 145.0, NULL, NULL, NULL, 183.0, 7.25, 22.03, NULL, NULL, NULL, 99, 99.0, 84.0, 91.0, NULL, NULL, NULL),
('74db87c3-37b5-49f7-bc80-82c854fd5eed', 60, 'Noor Ahmad', 'Chennai Super Kings', 'Bowler', 'BOWL', 'BOWL', 'B', 72, 'OVERSEAS', 'Afghan', 1, false, 0, 'https://www.cricbuzz.com/profiles/15452/noor-ahmad', 37.0, NULL, NULL, NULL, 48.0, 8.08, 22.23, NULL, NULL, NULL, 48, 34.0, 71.0, 90.0, NULL, NULL, NULL),
('6b11b640-385c-4f10-b688-f947fe76d107', 110, 'Josh Inglis', 'Lucknow Super Giants', 'WK-Batsman', 'WK', 'BAT_WK', 'C', 63, 'OVERSEAS', 'Australian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/10637/josh-inglis', 11.0, 278.0, 162.58, 30.89, NULL, NULL, NULL, 9.0, 87.0, 77.0, 35, NULL, NULL, NULL, NULL, NULL, NULL),
('add6bb04-de99-43be-a2d9-4d43e0cd919b', 158, 'Arjun Tendulkar', 'Lucknow Super Giants', 'Bowling Allrounder', 'AR', 'AR', 'C', 55, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/13747/arjun-tendulkar', 5.0, 13.0, NULL, NULL, 3.0, NULL, NULL, NULL, NULL, NULL, 32, NULL, NULL, NULL, 32.0, 23.0, 23.0),
('d87fb772-3d0f-4437-8a44-5fbe0e12d27d', 77, 'Rinku Singh', 'Kolkata Knight Riders', 'Batsman', 'BAT', 'BAT_WK', 'C', 69, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/10896/rinku-singh', 58.0, 1099.0, 145.18, 30.53, NULL, NULL, NULL, 24.0, 75.0, 76.0, 59, NULL, NULL, NULL, NULL, NULL, NULL),
('50853853-2c5a-4d46-b68d-07f35e47e011', 9, 'KL Rahul', 'Delhi Capitals', 'WK-Batsman', 'WK', 'BAT_WK', 'A', 95, 'INDIAN', 'Indian', 2, false, 4, 'https://www.cricbuzz.com/profiles/8733/kl-rahul', 145.0, 5222.0, 136.03, 46.21, NULL, NULL, NULL, 99.0, 69.0, 99.0, 99, NULL, NULL, NULL, NULL, NULL, NULL),
('77ded673-8345-4b12-b3f3-10d242fd62f0', 31, 'Manish Pandey', 'Kolkata Knight Riders', 'Batsman', 'BAT', 'BAT_WK', 'B', 82, 'INDIAN', 'Indian', 1, false, 0, 'https://www.cricbuzz.com/profiles/1836/manish-pandey', 174.0, 3942.0, 121.52, 29.42, NULL, NULL, NULL, 76.0, 59.0, 73.0, 99, NULL, NULL, NULL, NULL, NULL, NULL),
('7e22f102-3c54-401c-9c99-a89c5240143d', 95, 'Nehal Wadhera', 'Punjab Kings', 'Batsman', 'BAT', 'BAT_WK', 'C', 66, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/13915/nehal-wadhera', 36.0, 719.0, 142.95, 26.63, NULL, NULL, NULL, 17.0, 73.0, 66.0, 48, NULL, NULL, NULL, NULL, NULL, NULL),
('7cde1ea5-8cd9-4b43-a815-849e8bf77985', 81, 'Harpreet Brar', 'Punjab Kings', 'Bowler', 'BOWL', 'BOWL', 'C', 68, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/14452/harpreet-brar', 49.0, NULL, NULL, NULL, 35.0, 8.03, 31.0, NULL, NULL, NULL, 54, 26.0, 71.0, 72.0, NULL, NULL, NULL),
('2cd7a25d-de32-4722-affd-50145250a177', 49, 'Ravi Bishnoi', 'Rajasthan Royals', 'Bowler', 'BOWL', 'BOWL', 'B', 75, 'INDIAN', 'Indian', 1, false, 0, 'https://www.cricbuzz.com/profiles/14659/ravi-bishnoi', 77.0, NULL, NULL, NULL, 72.0, 8.22, 31.07, NULL, NULL, NULL, 68, 50.0, 68.0, 72.0, NULL, NULL, NULL),
('c4f653e4-2d43-4aa0-908e-6823857609fa', 151, 'Dushmantha Chameera', 'Delhi Capitals', 'Bowler', 'BOWL', 'BOWL', 'C', 56, 'OVERSEAS', 'Sri Lankan', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/8393/dushmantha-chameera', 19.0, NULL, NULL, NULL, 13.0, 9.73, 46.38, NULL, NULL, NULL, 39, 12.0, 44.0, 39.0, NULL, NULL, NULL),
('6222bb35-17c8-473b-9258-67c48780c498', 113, 'Marco Jansen', 'Punjab Kings', 'Bowling Allrounder', 'AR', 'AR', 'C', 62, 'OVERSEAS', 'South African', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/14565/marco-jansen', 35.0, 141.0, NULL, NULL, 36.0, NULL, NULL, NULL, NULL, NULL, 47, NULL, NULL, NULL, 26.0, 36.0, 26.0),
('9e9fd091-d70e-4012-be66-91a82cf863e3', 109, 'Abdul Samad', 'Lucknow Super Giants', 'Batting Allrounder', 'AR', 'AR', 'C', 63, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/14628/abdul-samad', 63.0, 741.0, NULL, NULL, 2.0, NULL, NULL, NULL, NULL, NULL, 61, NULL, NULL, NULL, 57.0, 5.0, 5.0),
('81f0a96c-0b38-4670-9339-cf4e74049cd1', 111, 'Ryan Rickelton', 'Mumbai Indians', 'WK-Batsman', 'WK', 'BAT_WK', 'C', 62, 'OVERSEAS', 'South African', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/13070/ryan-rickelton', 14.0, 388.0, 150.98, 29.85, NULL, NULL, NULL, 11.0, 79.0, 74.0, 37, NULL, NULL, NULL, NULL, NULL, NULL),
('276f5ee9-90a1-4168-bcec-bab51f98d68c', 116, 'Sherfane Rutherford', 'Mumbai Indians', 'Batting Allrounder', 'AR', 'AR', 'C', 62, 'OVERSEAS', 'West Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/13748/sherfane-rutherford', 23.0, 397.0, NULL, NULL, 1.0, NULL, NULL, NULL, NULL, NULL, 41, NULL, NULL, NULL, 48.0, 17.0, 17.0),
('7e1297e7-752c-4186-b8e6-77f2c21c7eed', 54, 'Heinrich Klaasen', 'Sunrisers Hyderabad', 'WK-Batsman', 'WK', 'BAT_WK', 'B', 74, 'OVERSEAS', 'South African', 1, false, 0, 'https://www.cricbuzz.com/profiles/10209/heinrich-klaasen', 49.0, 1480.0, 169.73, 40.0, NULL, NULL, NULL, 31.0, 91.0, 99.0, 54, NULL, NULL, NULL, NULL, NULL, NULL),
('0bc2cb23-2774-4531-96cc-0aafe31e094d', 122, 'Ashutosh Sharma', 'Delhi Capitals', 'Batting Allrounder', 'AR', 'AR', 'C', 61, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/13497/ashutosh-sharma', 24.0, 393.0, NULL, NULL, 0.0, NULL, NULL, NULL, NULL, NULL, 42, NULL, NULL, NULL, 56.0, 0.0, 0.0),
('03808d39-b87e-42d8-8689-31d673f4e485', 137, 'Jayant Yadav', 'Gujarat Titans', 'Bowling Allrounder', 'AR', 'AR', 'C', 58, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/8182/jayant-yadav', 20.0, 40.0, NULL, NULL, 8.0, NULL, NULL, NULL, NULL, NULL, 40, NULL, NULL, NULL, 22.0, 25.0, 22.0),
('10eb91c8-3ba0-4d71-bcc4-acac2042642d', 26, 'Jaydev Unadkat', 'Sunrisers Hyderabad', 'Bowler', 'BOWL', 'BOWL', 'B', 83, 'INDIAN', 'Indian', 1, false, 2, 'https://www.cricbuzz.com/profiles/6327/jaydev-unadkat', 112.0, NULL, NULL, NULL, 110.0, 8.88, 30.58, NULL, NULL, NULL, 86, 74.0, 58.0, 73.0, NULL, NULL, NULL),
('f37657df-7db0-48b0-be4b-4e76b536a6a1', 40, 'Rahul Chahar', 'Chennai Super Kings', 'Bowler', 'BOWL', 'BOWL', 'B', 77, 'INDIAN', 'Indian', 1, false, 0, 'https://www.cricbuzz.com/profiles/12087/rahul-chahar', 79.0, NULL, NULL, NULL, 75.0, 7.72, 28.67, NULL, NULL, NULL, 69, 52.0, 76.0, 77.0, NULL, NULL, NULL),
('53992ab0-1f58-495c-b525-058bb3ed02c0', 92, 'Shashank Singh', 'Punjab Kings', 'Batting Allrounder', 'AR', 'AR', 'C', 67, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/10919/shashank-singh', 41.0, 773.0, NULL, NULL, 1.0, NULL, NULL, NULL, NULL, NULL, 50, NULL, NULL, NULL, 67.0, 14.0, 14.0),
('4bdd351e-66e8-4175-beae-bf3a8e4af960', 71, 'Matheesha Pathirana', 'Kolkata Knight Riders', 'Bowler', 'BOWL', 'BOWL', 'B', 70, 'OVERSEAS', 'Sri Lankan', 1, false, 0, 'https://www.cricbuzz.com/profiles/16458/matheesha-pathirana', 32.0, NULL, NULL, NULL, 47.0, 8.68, 21.62, NULL, NULL, NULL, 46, 34.0, 61.0, 92.0, NULL, NULL, NULL),
('057a37a9-734f-47fa-9e9c-6e9c23b977a3', 20, 'Jos Buttler', 'Gujarat Titans', 'WK-Batsman', 'WK', 'BAT_WK', 'A', 88, 'OVERSEAS', 'English', 2, true, 2, 'https://www.cricbuzz.com/profiles/2258/jos-buttler', 121.0, 4120.0, 149.39, 40.0, NULL, NULL, NULL, 79.0, 78.0, 99.0, 90, NULL, NULL, NULL, NULL, NULL, NULL),
('01efc327-5153-48d9-8874-9fa6a8130269', 57, 'Jofra Archer', 'Rajasthan Royals', 'Bowler', 'BOWL', 'BOWL', 'B', 73, 'OVERSEAS', 'English', 1, false, 0, 'https://www.cricbuzz.com/profiles/11540/jofra-archer', 52.0, NULL, NULL, NULL, 59.0, 7.89, 27.15, NULL, NULL, NULL, 56, 41.0, 74.0, 80.0, NULL, NULL, NULL),
('c6d126c8-7d66-4650-af23-0cebad06b855', 36, 'Arshdeep Singh', 'Punjab Kings', 'Bowler', 'BOWL', 'BOWL', 'B', 78, 'INDIAN', 'Indian', 1, false, 0, 'https://www.cricbuzz.com/profiles/13217/arshdeep-singh', 82.0, NULL, NULL, NULL, 97.0, 9.0, 26.49, NULL, NULL, NULL, 71, 66.0, 56.0, 81.0, NULL, NULL, NULL),
('6912f3a9-463d-4110-8506-8db987593835', 53, 'Prasidh Krishna', 'Gujarat Titans', 'Bowler', 'BOWL', 'BOWL', 'B', 74, 'INDIAN', 'Indian', 1, false, 0, 'https://www.cricbuzz.com/profiles/10551/prasidh-krishna', 66.0, NULL, NULL, NULL, 74.0, 8.77, 29.61, NULL, NULL, NULL, 63, 51.0, 59.0, 75.0, NULL, NULL, NULL),
('4f93b528-8036-4cb7-8a2f-ecf478805bba', 11, 'Sandeep Sharma', 'Rajasthan Royals', 'Bowler', 'BOWL', 'BOWL', 'A', 93, 'INDIAN', 'Indian', 2, false, 4, 'https://www.cricbuzz.com/profiles/8356/sandeep-sharma', 136.0, NULL, NULL, NULL, 146.0, 8.03, 27.88, NULL, NULL, NULL, 98, 98.0, 71.0, 78.0, NULL, NULL, NULL),
('797682f8-e55b-431b-8cc5-5f06e81e6f57', 47, 'Yashasvi Jaiswal', 'Rajasthan Royals', 'Batsman', 'BAT', 'BAT_WK', 'B', 75, 'INDIAN', 'Indian', 1, false, 0, 'https://www.cricbuzz.com/profiles/13940/yashasvi-jaiswal', 66.0, 2166.0, 152.86, 34.38, NULL, NULL, NULL, 43.0, 80.0, 85.0, 63, NULL, NULL, NULL, NULL, NULL, NULL),
('64987b25-8218-4d41-b132-d3b089349896', 42, 'Ruturaj Gaikwad', 'Chennai Super Kings', 'Batsman', 'BAT', 'BAT_WK', 'B', 77, 'INDIAN', 'Indian', 1, false, 0, 'https://www.cricbuzz.com/profiles/11813/ruturaj-gaikwad', 71.0, 2502.0, 137.48, 40.35, NULL, NULL, NULL, 49.0, 70.0, 99.0, 65, NULL, NULL, NULL, NULL, NULL, NULL),
('5c6e6b17-4433-46d5-b46d-c4b65662f072', 6, 'Rohit Sharma', 'Mumbai Indians', 'Batsman', 'BAT', 'BAT_WK', 'A', 96, 'INDIAN', 'Indian', 2, true, 8, 'https://www.cricbuzz.com/profiles/576/rohit-sharma', 272.0, 7046.0, 132.1, 29.73, NULL, NULL, NULL, 99.0, 66.0, 74.0, 99, NULL, NULL, NULL, NULL, NULL, NULL),
('44239389-cf8f-49b4-b304-241be55ac433', 145, 'Akash Maharaj Singh', 'Lucknow Super Giants', 'Bowler', 'BOWL', 'BOWL', 'C', 57, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/14696/akash-maharaj-singh', 10.0, NULL, NULL, NULL, 9.0, 9.54, 36.22, NULL, NULL, NULL, 35, 9.0, 47.0, 61.0, NULL, NULL, NULL),
('d43b63c9-6211-4ab9-978a-5138926cdfd3', 114, 'Mitchell Santner', 'Mumbai Indians', 'Bowling Allrounder', 'AR', 'AR', 'C', 62, 'OVERSEAS', 'New Zealander', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/10100/mitchell-santner', 31.0, 110.0, NULL, NULL, 25.0, NULL, NULL, NULL, NULL, NULL, 45, NULL, NULL, NULL, 25.0, 40.0, 25.0),
('bd377bdc-d6c2-43f7-8e44-9d529d2fd41d', 7, 'Ravindra Jadeja', 'Rajasthan Royals', 'Bowling Allrounder', 'AR', 'AR', 'A', 95, 'INDIAN', 'Indian', 2, false, 8, 'https://www.cricbuzz.com/profiles/587/ravindra-jadeja', 254.0, 3260.0, NULL, NULL, 170.0, NULL, NULL, NULL, NULL, NULL, 99, NULL, NULL, NULL, 85.0, 78.0, 78.0),
('7678fb6d-b893-442f-a813-47040d70faf7', 134, 'Vipraj Nigam', 'Delhi Capitals', 'Bowler', 'BOWL', 'BOWL', 'C', 59, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/1431811/vipraj-nigam', 14.0, NULL, NULL, NULL, 11.0, 9.13, 32.36, NULL, NULL, NULL, 37, 10.0, 54.0, 69.0, NULL, NULL, NULL),
('b6c247cd-b51e-437a-b64c-3f9abd0cd245', 112, 'Nitish Kumar Reddy', 'Sunrisers Hyderabad', 'Batting Allrounder', 'AR', 'AR', 'C', 62, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/14701/nitish-kumar-reddy', 28.0, 485.0, NULL, NULL, 5.0, NULL, NULL, NULL, NULL, NULL, 44, NULL, NULL, NULL, 50.0, 14.0, 14.0),
('af701c5f-a02b-4dd6-aad4-e691a9977c97', 30, 'Rishabh Pant', 'Lucknow Super Giants', 'WK-Batsman', 'WK', 'BAT_WK', 'B', 82, 'INDIAN', 'Indian', 1, false, 0, 'https://www.cricbuzz.com/profiles/10744/rishabh-pant', 125.0, 3553.0, 147.62, 34.16, NULL, NULL, NULL, 68.0, 76.0, 85.0, 92, NULL, NULL, NULL, NULL, NULL, NULL),
('0132385a-f99c-4a53-971f-a195b15f3f5e', 2, 'Yuzvendra Chahal', 'Punjab Kings', 'Bowler', 'BOWL', 'BOWL', 'A', 99, 'INDIAN', 'Indian', 2, false, 10, 'https://www.cricbuzz.com/profiles/7910/yuzvendra-chahal', 174.0, NULL, NULL, NULL, 221.0, 7.96, 22.77, NULL, NULL, NULL, 99, 99.0, 73.0, 89.0, NULL, NULL, NULL),
('6376af77-1cdc-4bb5-b381-ec239b576c08', 25, 'Marcus Stoinis', 'Punjab Kings', 'Batting Allrounder', 'AR', 'AR', 'B', 83, 'OVERSEAS', 'Australian', 1, false, 4, 'https://www.cricbuzz.com/profiles/8989/marcus-stoinis', 109.0, 2026.0, NULL, NULL, 44.0, NULL, NULL, NULL, NULL, NULL, 84, NULL, NULL, NULL, 90.0, 37.0, 37.0),
('c2015b50-10f7-41e9-8f35-fd2b71db843b', 94, 'Will Jacks', 'Mumbai Indians', 'Batting Allrounder', 'AR', 'AR', 'C', 66, 'OVERSEAS', 'English', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/12258/will-jacks', 21.0, 463.0, NULL, NULL, 8.0, NULL, NULL, NULL, NULL, NULL, 40, NULL, NULL, NULL, 55.0, 28.0, 28.0),
('8561f05f-f063-4018-8c75-6e3918a5a5cd', 38, 'Shardul Thakur', 'Mumbai Indians', 'Bowling Allrounder', 'AR', 'AR', 'B', 78, 'INDIAN', 'Indian', 1, false, 6, 'https://www.cricbuzz.com/profiles/8683/shardul-thakur', 105.0, 325.0, NULL, NULL, 107.0, NULL, NULL, NULL, NULL, NULL, 82, NULL, NULL, NULL, 38.0, 59.0, 38.0),
('bacbf686-78a6-435d-8192-a37007b0dcf2', 76, 'Tristan Stubbs', 'Delhi Capitals', 'WK-Batsman', 'WK', 'BAT_WK', 'B', 70, 'OVERSEAS', 'South African', 1, false, 0, 'https://www.cricbuzz.com/profiles/19243/tristan-stubbs', 32.0, 705.0, 163.2, 41.47, NULL, NULL, NULL, 17.0, 87.0, 99.0, 46, NULL, NULL, NULL, NULL, NULL, NULL),
('a489841a-14e0-4cfe-a09b-f56db45203ea', 131, 'Romario Shepherd', 'Royal Challengers Bengaluru', 'Bowling Allrounder', 'AR', 'AR', 'C', 60, 'OVERSEAS', 'West Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/13646/romario-shepherd', 18.0, 185.0, NULL, NULL, 10.0, NULL, NULL, NULL, NULL, NULL, 39, NULL, NULL, NULL, 52.0, 18.0, 18.0),
('1fd393dc-7abe-41c6-8f34-778906592549', 17, 'Mohammed Shami', 'Lucknow Super Giants', 'Bowler', 'BOWL', 'BOWL', 'A', 89, 'INDIAN', 'Indian', 2, false, 4, 'https://www.cricbuzz.com/profiles/7909/mohammed-shami', 119.0, NULL, NULL, NULL, 133.0, 8.63, 28.18, NULL, NULL, NULL, 89, 89.0, 62.0, 78.0, NULL, NULL, NULL),
('1577e22a-0f67-4a11-bff3-9dcbbbd89684', 46, 'Avesh Khan', 'Lucknow Super Giants', 'Bowler', 'BOWL', 'BOWL', 'B', 76, 'INDIAN', 'Indian', 1, false, 0, 'https://www.cricbuzz.com/profiles/9781/avesh-khan', 75.0, NULL, NULL, NULL, 87.0, 9.12, 28.29, NULL, NULL, NULL, 67, 60.0, 54.0, 77.0, NULL, NULL, NULL),
('bd304e80-000d-4d13-942a-e6e0af2b0104', 19, 'Hardik Pandya', 'Mumbai Indians', 'Batting Allrounder', 'AR', 'AR', 'A', 89, 'INDIAN', 'Indian', 2, false, 6, 'https://www.cricbuzz.com/profiles/9647/hardik-pandya', 152.0, 2749.0, NULL, NULL, 78.0, NULL, NULL, NULL, NULL, NULL, 99, NULL, NULL, NULL, 90.0, 50.0, 50.0),
('0d40b398-11bd-4d5e-a201-fcd590a55ea3', 56, 'Josh Hazlewood', 'Royal Challengers Bengaluru', 'Bowler', 'BOWL', 'BOWL', 'B', 73, 'OVERSEAS', 'Australian', 1, false, 0, 'https://www.cricbuzz.com/profiles/6258/josh-hazlewood', 39.0, NULL, NULL, NULL, 57.0, 8.28, 20.98, NULL, NULL, NULL, 49, 40.0, 67.0, 93.0, NULL, NULL, NULL),
('86779bf9-e3e1-4527-8411-691e45ce8cd7', 21, 'Krunal Pandya', 'Royal Challengers Bengaluru', 'Batting Allrounder', 'AR', 'AR', 'A', 86, 'INDIAN', 'Indian', 2, false, 4, 'https://www.cricbuzz.com/profiles/11311/krunal-pandya', 142.0, 1748.0, NULL, NULL, 93.0, NULL, NULL, NULL, NULL, NULL, 99, NULL, NULL, NULL, 77.0, 60.0, 60.0),
('97a2d1d4-cff8-468d-b932-ee4841f28a59', 104, 'Lungi Ngidi', 'Delhi Capitals', 'Bowler', 'BOWL', 'BOWL', 'C', 64, 'OVERSEAS', 'South African', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/9603/lungi-ngidi', 16.0, NULL, NULL, NULL, 29.0, 8.53, 18.24, NULL, NULL, NULL, 38, 22.0, 63.0, 99.0, NULL, NULL, NULL),
('7ca67034-31ac-4b89-96a1-bbc1ff80944e', 99, 'Yash Dayal', 'Royal Challengers Bengaluru', 'Bowler', 'BOWL', 'BOWL', 'C', 66, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/14172/yash-dayal', 43.0, NULL, NULL, NULL, 41.0, 9.58, 33.9, NULL, NULL, NULL, 51, 30.0, 46.0, 66.0, NULL, NULL, NULL),
('22ac4991-dea2-45e0-854b-84c35df717c0', 5, 'Bhuvneshwar Kumar', 'Royal Challengers Bengaluru', 'Bowler', 'BOWL', 'BOWL', 'A', 98, 'INDIAN', 'Indian', 2, false, 8, 'https://www.cricbuzz.com/profiles/1726/bhuvneshwar-kumar', 190.0, NULL, NULL, NULL, 198.0, 7.69, 27.33, NULL, NULL, NULL, 99, 99.0, 77.0, 80.0, NULL, NULL, NULL),
('c04d2b83-e414-40d1-afc5-da87a2636457', 147, 'Mayank Yadav', 'Lucknow Super Giants', 'Bowler', 'BOWL', 'BOWL', 'C', 57, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/22401/mayank-yadav', 6.0, NULL, NULL, NULL, 9.0, 9.17, 20.56, NULL, NULL, NULL, 33, 9.0, 53.0, 94.0, NULL, NULL, NULL),
('2b143922-6a43-4ca8-9496-9ba4090b8a23', 61, 'Travis Head', 'Sunrisers Hyderabad', 'Batsman', 'BAT', 'BAT_WK', 'B', 72, 'OVERSEAS', 'Australian', 1, false, 0, 'https://www.cricbuzz.com/profiles/8497/travis-head', 38.0, 1146.0, 170.03, 34.73, NULL, NULL, NULL, 25.0, 92.0, 86.0, 49, NULL, NULL, NULL, NULL, NULL, NULL),
('d151e121-54f6-4bd6-bfab-1de898d5aeef', 48, 'Pat Cummins', 'Sunrisers Hyderabad', 'Bowler', 'BOWL', 'BOWL', 'B', 75, 'OVERSEAS', 'Australian', 1, false, 0, 'https://www.cricbuzz.com/profiles/8095/pat-cummins', 72.0, NULL, NULL, NULL, 79.0, 8.81, 30.04, NULL, NULL, NULL, 66, 54.0, 59.0, 74.0, NULL, NULL, NULL),
('b9d91d68-d094-49f8-9f6b-94bd7d040956', 8, 'MS Dhoni', 'Chennai Super Kings', 'WK-Batsman', 'WK', 'BAT_WK', 'A', 95, 'INDIAN', 'Indian', 2, false, 4, 'https://www.cricbuzz.com/profiles/265/ms-dhoni', 278.0, 5439.0, 137.46, 38.3, NULL, NULL, NULL, 99.0, 70.0, 95.0, 99, NULL, NULL, NULL, NULL, NULL, NULL),
('f982456d-bf46-4013-b734-e85059e4326b', 78, 'Rajat Patidar', 'Royal Challengers Bengaluru', 'Batsman', 'BAT', 'BAT_WK', 'C', 69, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/10636/rajat-patidar', 42.0, 1111.0, 154.31, 30.86, NULL, NULL, NULL, 24.0, 81.0, 77.0, 51, NULL, NULL, NULL, NULL, NULL, NULL),
('29e7823f-59dd-47a3-8b96-90e258af3daa', 22, 'Kagiso Rabada', 'Gujarat Titans', 'Bowler', 'BOWL', 'BOWL', 'A', 85, 'OVERSEAS', 'South African', 2, false, 2, 'https://www.cricbuzz.com/profiles/9585/kagiso-rabada', 84.0, NULL, NULL, NULL, 119.0, 8.62, 22.96, NULL, NULL, NULL, 72, 80.0, 62.0, 89.0, NULL, NULL, NULL),
('7f0c7b1a-f76b-40cd-93d1-b92960563676', 55, 'Mitchell Starc', 'Delhi Capitals', 'Bowler', 'BOWL', 'BOWL', 'B', 73, 'OVERSEAS', 'Australian', 1, false, 0, 'https://www.cricbuzz.com/profiles/7710/mitchell-starc', 51.0, NULL, NULL, NULL, 65.0, 8.61, 23.12, NULL, NULL, NULL, 55, 45.0, 62.0, 88.0, NULL, NULL, NULL),
('b07df209-18c1-4c71-9b07-6edcc461ab54', 13, 'Axar Patel', 'Delhi Capitals', 'Bowling Allrounder', 'AR', 'AR', 'A', 91, 'INDIAN', 'Indian', 2, false, 6, 'https://www.cricbuzz.com/profiles/8808/axar-patel', 162.0, 1916.0, NULL, NULL, 128.0, NULL, NULL, NULL, NULL, NULL, 99, NULL, NULL, NULL, 82.0, 72.0, 72.0),
('d3e0f06a-af29-414c-9623-1409e1bd87ab', 128, 'Yash Thakur', 'Punjab Kings', 'Bowler', 'BOWL', 'BOWL', 'C', 61, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/12096/yash-thakur', 21.0, NULL, NULL, NULL, 25.0, 10.43, 30.8, NULL, NULL, NULL, 40, 20.0, 32.0, 72.0, NULL, NULL, NULL);

INSERT INTO "AuctionPlayer" (id, player_id, status) VALUES
('422f3ccf-2f08-4848-b23a-54ebe3a9442f', 'a01ce68c-1679-4ebc-8d4e-9747b80bf9a8', 'UNSOLD'),
('d2b13004-6842-45fc-964c-e25988c975b7', '1c7dd826-a7e2-4b73-89ef-0f8768b58a08', 'UNSOLD'),
('23315589-c477-424c-a616-9956e33d3c1b', '1edbf9e9-a83b-4c32-93ee-8b1175678e9d', 'UNSOLD'),
('44925c86-859a-4601-9484-d2052f95b0f7', '8776b8ff-b233-4bcb-9188-67449661af1e', 'UNSOLD'),
('9121fcb6-e483-4746-8d19-97d5d5fa7f8d', 'fde3bdcf-1c05-424f-8a55-f1486ffa4240', 'UNSOLD'),
('a1c8c1a7-742c-42a1-91e0-b172b0a45c23', 'f799339a-579d-4753-9feb-682c213e7f05', 'UNSOLD'),
('de1ecaa5-a79c-45b7-8d89-ccbbfbd55884', 'f9bbc338-8e02-47cb-a740-aacdf3259995', 'UNSOLD'),
('5426cc15-5328-459b-be9d-9b3b0199f095', 'fa734342-3ef8-40f8-b480-eb38b2f8dd2a', 'UNSOLD'),
('aba3fd5d-5448-4ed4-9d12-7a381f5b1c50', '4f10ef26-9643-42ae-8a31-38d7a0bf2f33', 'UNSOLD'),
('14d6eac1-cba2-427d-9b09-a20ac71472e1', '60d879b9-fee9-4089-9655-6ad854284288', 'UNSOLD'),
('f3a40773-0592-4e3a-a283-2116d1fcdc37', '052e6a0e-565f-4da2-bfc4-36e56a745151', 'UNSOLD'),
('2ae64f89-7009-456b-925a-7ab08f8d4723', 'a20390a2-e729-4338-bddb-f3bcee147aa9', 'UNSOLD'),
('739ced57-7a4e-443f-862d-d824a359c63d', '6ea037cb-b00e-4e35-b9d8-487c3671c5d4', 'UNSOLD'),
('836af2a8-0c0b-4028-8356-28a422ca7499', '7e4bdee2-160d-4cbc-8d60-e3b38b8a0c64', 'UNSOLD'),
('25c6f4f8-9627-4ccd-be91-1dce601d7d9a', '25b05cd5-09b3-4d0d-8cff-53c5e1467ea3', 'UNSOLD'),
('e33c6386-0cd1-4b7d-b672-8b2b87da1827', '90d6d192-b97d-43b3-930c-02b2f6b653ce', 'UNSOLD'),
('80a1767d-ddaf-43a4-9579-0b64ac087e52', 'fdc37fc5-3852-46e9-88f5-d69969505343', 'UNSOLD'),
('3ab0b7b7-909b-43b8-b4e8-ec4d880754ac', '578c7874-69c0-43db-a604-c6ef17fcd7d1', 'UNSOLD'),
('fe4508db-9408-4b86-ab3f-7a33d01f46e9', 'e933726a-88d7-4db7-9fad-09b5cb92c685', 'UNSOLD'),
('18565350-529c-4768-a804-5ef2d1a9ea19', 'a270df74-809f-47be-b6d3-d4ea3defa19b', 'UNSOLD'),
('a4053445-efdf-4332-ac0b-2be1a1e0cdf3', 'a482a5c3-7a11-4017-af44-2d6ce263aedd', 'UNSOLD'),
('d1edc304-787e-4ff6-90ad-225a33123f72', '7a830a64-41eb-433b-8f11-d80bd72a069a', 'UNSOLD'),
('bed63161-86b3-4d2e-a322-b6891ab067d8', 'bc18e222-aab7-4531-b2c2-09a66421f95c', 'UNSOLD'),
('a15cbb2f-833f-444b-b376-467190c21dc9', '46403b4d-7525-475c-9b81-5300e6a973bd', 'UNSOLD'),
('fdfabfb3-a9ea-4582-b6dc-10cdcec1b69a', '099291bb-b76a-415a-843c-7a5f98e5d1be', 'UNSOLD'),
('a498597b-5540-4c0a-887e-7e63fcd29c94', '4f10a84f-12ae-4147-a208-a4b56ccc207c', 'UNSOLD'),
('a8829606-dfe5-463f-aeff-cfb66b87147c', '1e4eb95a-3d3e-46aa-8c92-0be7051680e3', 'UNSOLD'),
('9b0a31ac-5778-4010-9d96-a7808bb6dbb8', 'c1b2fae1-d296-4bc0-b978-849baee57924', 'UNSOLD'),
('aafb19a6-f28d-4f92-8375-0e70c3c722c6', '20f4aad5-e975-4241-a523-5499e9ea0acb', 'UNSOLD'),
('ea499ff0-1d72-4611-b709-afbc8acb5e83', '243840bb-6f7f-48db-91ed-2e121ad02e36', 'UNSOLD'),
('71f27914-ede6-434f-963e-b531d9cb3507', '692b2df2-0a56-4286-8b8f-20c3c67cb230', 'UNSOLD'),
('4a644019-defe-457b-895f-25ac1cb8d416', '1dc17803-662c-4622-be73-5d084a244271', 'UNSOLD'),
('947a25e0-0131-41a1-9f7b-a77f6dfbf063', '8c6ed68e-c1fd-4c67-8ef3-e3a8827afb80', 'UNSOLD'),
('296a1d61-4470-44d1-86bd-06e887a20663', 'a04416da-5fb5-465d-b8b2-f5701ed8af39', 'UNSOLD'),
('3b06b141-efa6-4558-9765-87fc552bc86c', '34cb40a9-f7dc-4846-8f0b-f7ad1fd29d36', 'UNSOLD'),
('364fcb45-6d78-4cad-86d2-09bc17e11c33', '58c6351e-64c5-4d1c-b198-8a1b443cfb60', 'UNSOLD'),
('29557eee-2571-448e-9c5e-674b2e709276', 'e3efb923-a17d-45b4-af86-8cb82392ee1c', 'UNSOLD'),
('a67e5c63-c9ee-47c3-879e-02c5ca858ee6', 'f4c53c57-83c3-4ff3-b2bd-08eb398081ac', 'UNSOLD'),
('00e859c3-889b-406d-9106-60938c903e06', '494b90db-1528-416e-b1b1-d781765a6f6a', 'UNSOLD'),
('ac55bddf-7ea1-40d3-925d-dd9f3b011163', '526e91f3-baa6-4a7a-bc6f-bb9870b05510', 'UNSOLD'),
('85b5f8e7-982f-428c-8a28-47b5296b5ea1', '06de1d79-f4c7-472c-9e79-1cc8dd7afcaf', 'UNSOLD'),
('c47407fb-47ba-4309-b0c8-287a0013a71f', 'e358dedd-d046-4c9e-bc03-998c281b24eb', 'UNSOLD'),
('881aab0d-33b3-4092-a46e-d31ab13a8975', '5871e856-9e3a-45d9-8d35-da33e1bc7ad4', 'UNSOLD'),
('0b47ac00-6b2f-42ba-8b2f-ee32d1d4fb7b', 'b7f01bd3-3c1e-4105-8a40-5648688ef890', 'UNSOLD'),
('27696ab7-3c0b-4151-b3e1-aa33fe050283', 'd9f99047-b867-4f71-acbf-7fab1e21f14f', 'UNSOLD'),
('9935b755-48a2-4b2a-9c54-43c37b305fe5', '917c3436-0eb0-465a-8603-761f9845761a', 'UNSOLD'),
('79e04855-3a27-483c-9fbf-34fde909a0ce', 'b5e480b7-e1be-4615-824a-b9539a586273', 'UNSOLD'),
('e1571ff1-ad85-4ec3-8d50-4fb53b074320', 'ed390f3a-fde3-4fd7-a5aa-b00ebed1399b', 'UNSOLD'),
('62cbcaf7-3a70-4a99-a062-164a463ba323', '1a35b702-cefd-4ac8-8e09-2421fcdbacaf', 'UNSOLD'),
('22d15774-08b6-49c5-a103-8e29a2e23a4b', '5f12ec4d-0104-4d97-89f9-9a664eec4a14', 'UNSOLD'),
('8a03d2c5-a045-42a6-9350-04deadf83c76', '102b5d58-51dc-470b-b4ee-cb459b71236a', 'UNSOLD'),
('769d2076-4003-45e6-9887-271bfa73b08e', 'bcdc0e0f-5bc6-4360-bfbc-0d251ac5c3b4', 'UNSOLD'),
('0ba22a81-3646-4a9b-818c-cb25758f106b', 'd57f86a7-3585-481c-bbef-6e3c7c283e0e', 'UNSOLD'),
('15755996-72da-41c3-8f4a-22c81ce001bf', '7b1fcea3-e03c-4470-8fce-ba8a47c09522', 'UNSOLD'),
('4446efb7-3d05-42ca-8007-2b1e9e67b8a1', 'bb91b1b3-ce90-410c-a99d-9301f31211ab', 'UNSOLD'),
('46c75825-2a2a-4e99-a8c7-1f63ffb9fee7', '281c4b8a-3fce-4aa7-b57a-4b717170d3c3', 'UNSOLD'),
('be831dcb-5ab2-4f4d-9244-3a265479a719', 'cb021023-1685-4739-bb08-51db0e488e00', 'UNSOLD'),
('06e47789-ccf0-4bcd-848d-83e0cb8acc29', '73393dc8-0de3-4ba4-a308-d7e17633a3f7', 'UNSOLD'),
('60b53c86-05c6-4ae8-b745-a256a7c3c191', '063a22fb-d409-4806-8c41-81e42024469c', 'UNSOLD'),
('6b719270-0cba-438e-a460-6682e5e7508b', '3a5f94ec-a4fc-4bbb-951a-74f9634f1c57', 'UNSOLD'),
('1e8986aa-a3af-47f2-855d-6dd436d93833', 'a482f65c-ef80-403e-9913-e96aebd8d930', 'UNSOLD'),
('e065cf01-ecc4-4bd2-b843-462089dad880', 'f1c9a658-4854-44e1-96a9-46f56f040889', 'UNSOLD'),
('bdd35a77-c02a-4a6b-a0e3-73e183086108', '416e34b8-cc64-4f11-b088-5e56e1e2efed', 'UNSOLD'),
('672daf8e-f078-4086-8dae-efcea1926403', '39a5d83b-4fc6-4ba6-b5ab-219eb0de9a4f', 'UNSOLD'),
('ffe103ef-06b9-45ac-8ef0-245c77774259', '70b70d06-3734-4bbc-a89d-e5ebc7af5c15', 'UNSOLD'),
('3d159fd1-de70-453f-ad00-629386865eb0', '9427ed2a-b740-43cb-a27e-e84f9be4d65e', 'UNSOLD'),
('ab9d115c-21fa-4b02-b6ee-fdd1eaf7765c', 'ecf67775-233c-4817-8307-dde6cc17564b', 'UNSOLD'),
('c94c7dd9-6957-4b3d-97a6-9f5c28dccda5', '2f014af0-6f53-4775-954d-2e90434a7833', 'UNSOLD'),
('d65d3c18-2c26-487e-9b32-89cd38c3426b', '054d7ec4-4c8b-4023-abf6-4251e5d0c855', 'UNSOLD'),
('7d141747-58f4-4dcb-bda5-d9584c5f9853', '7000f2fe-1c8e-41f0-a7e3-2fbb2b9b911b', 'UNSOLD'),
('f25ea4cf-1577-442d-85fd-8b29e714e25f', 'dd7978da-148a-40e6-9230-c36700b614fb', 'UNSOLD'),
('dfb93bc9-dfd9-4f44-ab1a-e226f9045ecd', 'a422e94e-fd6d-45fc-bffd-fb70ca329b71', 'UNSOLD'),
('98d5cd68-0e13-42d1-ad44-39a6979d7faf', 'be99ce63-869a-490f-87c7-c30764e8cccf', 'UNSOLD'),
('bb91ae86-1de2-490e-80fb-628232b19d6c', '3ae2f289-4a77-4dad-9e8a-952cb37e685d', 'UNSOLD'),
('abfc98e6-dd5a-4b54-b5aa-280cc33d1d15', '102d85e9-d9f8-4e7f-884d-ba44d4e35fdb', 'UNSOLD'),
('414b2fa2-f937-41c4-8d49-aceb39500040', 'fa5423f3-7164-4655-a65f-81d04c95df7a', 'UNSOLD'),
('de9f056e-0dba-40a7-b161-05277fe70b5c', 'a42d6b42-d219-42e7-b502-023e0a8db9a8', 'UNSOLD'),
('a54fa2b7-d691-40e9-b245-068e181fd5f3', '575fe83f-f13a-4ff4-b032-a86259821f1a', 'UNSOLD'),
('ddfa1fae-6a08-4a3a-aa8c-d927e980c784', 'e7259039-b1d4-43fb-9185-2c7440959e3f', 'UNSOLD'),
('98b6b9fa-9df2-495e-a20d-5ccc5f8ea7ef', '8f3b67a7-394e-45e1-a6bb-f2eb61aaeac7', 'UNSOLD'),
('ee840604-a97e-429e-a7f7-d2a0ef259bbe', '84ba1ece-05a5-4fd9-9679-56fec7bad250', 'UNSOLD'),
('dcd79531-d455-4d9a-a35e-d0dd92de4435', '77d3888a-d81f-4bf7-aca5-ec6b28c3c555', 'UNSOLD'),
('8f6834f1-27bd-4fee-a99a-e6c00ec049a6', 'd148fe94-2b77-4894-91c7-fee7830d95b9', 'UNSOLD'),
('0fc1b344-0c3a-47b6-ad72-d71995c41dc4', '953afdd3-0106-4df6-aa75-f17fd323dd5c', 'UNSOLD'),
('219caf5c-9743-4b3f-bfea-a78edcae7ba5', '47faa5c2-5fa0-4513-ab9e-9fbdc4666036', 'UNSOLD'),
('83dbcd9d-c4c2-481e-8475-d0a08ea41b8c', '066d9e33-79ba-40e9-92d1-c9d56a399996', 'UNSOLD'),
('7b858f54-a7e2-4e27-b867-4e30db51df54', '6538b113-71d2-4849-bd25-8635065f24fc', 'UNSOLD'),
('b3aac348-2079-4f74-9c75-acbf7b1cd2ef', 'e1beb58b-e34a-49a8-808d-a2f105875e0b', 'UNSOLD'),
('11371198-ff1e-43fc-b9b5-f36eb4830ac9', 'c0d88595-7e8f-4d06-b1ab-f38b7c604762', 'UNSOLD'),
('74e4e879-3b83-4520-8429-1f04fd0bdb7e', '41a83f40-933b-4737-b0a1-7ebbca5f4f53', 'UNSOLD'),
('957c0c27-3970-4618-a62f-bbb1ab61541c', '71b8acb7-4d45-4f40-9386-2521c7a54912', 'UNSOLD'),
('1b77c7a4-e0c6-46ff-8391-5543222ea76f', '6acea564-c0dc-4a29-8b7b-f089ff7a5d70', 'UNSOLD'),
('d4491e76-5ec4-4ac5-83ce-95f4ec977a39', '4b87a12a-b138-443b-af98-c485a5621100', 'UNSOLD'),
('72d090a7-44df-46da-a637-ea3e974ba96c', '7b4ae361-d05e-422c-9118-f72d4c4b4a3b', 'UNSOLD'),
('81fb9502-56d5-41e8-8ff3-ccd05218416d', '9966fc3f-be7c-4b8b-805e-5319e8dda289', 'UNSOLD'),
('da2dbcb4-0d13-44eb-ac51-1586befd4b07', '1ae4e018-9303-4934-b8af-1d79d0e527d9', 'UNSOLD'),
('a359b427-4425-4650-a21d-8870b2e8fb09', 'a89c4b16-766d-45a8-8a41-e4765823440e', 'UNSOLD'),
('31c55b72-83fc-4172-b184-ff54db78f2cb', '12b4c50c-92dc-46ce-bea3-856d9a133f3c', 'UNSOLD'),
('ac509311-92ab-4a96-8585-c92d11b62fc0', 'f6582afd-549e-47b7-91f0-f17c7c106096', 'UNSOLD'),
('c760fba3-a002-4e51-87f7-80fdb0b74efd', '0a762af0-3950-4cde-ae66-fbfe5c366537', 'UNSOLD'),
('12c7f7c9-ddcb-4897-8b35-29f2807de5c5', 'fc113c91-b465-4160-b274-8415e05d8d98', 'UNSOLD'),
('2b3cae9c-c78e-44bf-bf00-970b54e8a226', '74db87c3-37b5-49f7-bc80-82c854fd5eed', 'UNSOLD'),
('2eff8fbb-750e-4d73-b995-9b1a5161f7db', '6b11b640-385c-4f10-b688-f947fe76d107', 'UNSOLD'),
('66fe113a-87e9-41e4-a836-b363a0e3a559', 'add6bb04-de99-43be-a2d9-4d43e0cd919b', 'UNSOLD'),
('2b7dbc6c-c7b2-4f69-8f0b-86c7324af892', 'd87fb772-3d0f-4437-8a44-5fbe0e12d27d', 'UNSOLD'),
('bf932bcd-c0be-4626-a5b5-29c80c92d74f', '50853853-2c5a-4d46-b68d-07f35e47e011', 'UNSOLD'),
('c73db583-8601-48ff-a402-5fcb73b0cd38', '77ded673-8345-4b12-b3f3-10d242fd62f0', 'UNSOLD'),
('a7785eea-5c24-4880-a338-2cd00d23c341', '7e22f102-3c54-401c-9c99-a89c5240143d', 'UNSOLD'),
('98774556-7ee3-4659-b9a7-53d27bbda9be', '7cde1ea5-8cd9-4b43-a815-849e8bf77985', 'UNSOLD'),
('fe07313c-19bd-4a64-a4d8-4bd44e259ee7', '2cd7a25d-de32-4722-affd-50145250a177', 'UNSOLD'),
('3690c8fa-9595-4242-b990-fb546ed4ab1d', 'c4f653e4-2d43-4aa0-908e-6823857609fa', 'UNSOLD'),
('aa137155-9e9e-4198-9962-166f898c08fd', '6222bb35-17c8-473b-9258-67c48780c498', 'UNSOLD'),
('0e336b17-74e9-4e0f-9f71-738c05f7b4bd', '9e9fd091-d70e-4012-be66-91a82cf863e3', 'UNSOLD'),
('38bea7a8-1548-45ea-b2dd-ed9d02b4d14e', '81f0a96c-0b38-4670-9339-cf4e74049cd1', 'UNSOLD'),
('00654b99-2a9a-4c23-8063-08c0d0d20557', '276f5ee9-90a1-4168-bcec-bab51f98d68c', 'UNSOLD'),
('36f0e561-0103-41cf-aadb-0f95441e4911', '7e1297e7-752c-4186-b8e6-77f2c21c7eed', 'UNSOLD'),
('5a444ed1-d871-49b8-ba36-b501c3e38f29', '0bc2cb23-2774-4531-96cc-0aafe31e094d', 'UNSOLD'),
('7e1a0b2a-63d3-4396-b435-222ac5ca1c86', '03808d39-b87e-42d8-8689-31d673f4e485', 'UNSOLD'),
('6f906d9b-3536-4d8e-a88b-5ab50bd36cb2', '10eb91c8-3ba0-4d71-bcc4-acac2042642d', 'UNSOLD'),
('7305214a-9e38-4e4c-b559-27fada344292', 'f37657df-7db0-48b0-be4b-4e76b536a6a1', 'UNSOLD'),
('4407f463-b15d-4bf1-96af-948cdf7b4aab', '53992ab0-1f58-495c-b525-058bb3ed02c0', 'UNSOLD'),
('2783797b-39bb-4b55-81ad-ade76c5cb0d5', '4bdd351e-66e8-4175-beae-bf3a8e4af960', 'UNSOLD'),
('af223a02-8755-43da-aa3c-14860bb8147c', '057a37a9-734f-47fa-9e9c-6e9c23b977a3', 'UNSOLD'),
('77dea302-12df-4c25-98b1-b58ebe509d93', '01efc327-5153-48d9-8874-9fa6a8130269', 'UNSOLD'),
('6ea80f3f-689d-401b-a0fb-2f306be86360', 'c6d126c8-7d66-4650-af23-0cebad06b855', 'UNSOLD'),
('2be325bd-e4f8-483d-aaea-8a71298b6882', '6912f3a9-463d-4110-8506-8db987593835', 'UNSOLD'),
('b26a04d8-a938-43c4-9658-024c703aa202', '4f93b528-8036-4cb7-8a2f-ecf478805bba', 'UNSOLD'),
('5b9f3857-4318-4d16-a3fe-d0515fdfcb77', '797682f8-e55b-431b-8cc5-5f06e81e6f57', 'UNSOLD'),
('ac92046d-1c0b-4028-b33d-e6e103087c92', '64987b25-8218-4d41-b132-d3b089349896', 'UNSOLD'),
('b6a25f5d-11d5-46fd-9d12-c570863b08ae', '5c6e6b17-4433-46d5-b46d-c4b65662f072', 'UNSOLD'),
('18a3c77b-a63a-48e7-97ca-6f00edf27313', '44239389-cf8f-49b4-b304-241be55ac433', 'UNSOLD'),
('748fd278-d248-49ab-86d2-c2282f4979a4', 'd43b63c9-6211-4ab9-978a-5138926cdfd3', 'UNSOLD'),
('a3e9055f-4773-4434-95e9-0d8453a0114a', 'bd377bdc-d6c2-43f7-8e44-9d529d2fd41d', 'UNSOLD'),
('3aadb0da-c2e7-4903-a44e-c50a0eedb0a3', '7678fb6d-b893-442f-a813-47040d70faf7', 'UNSOLD'),
('af92567e-bd94-47cb-88c6-132e8d740e8c', 'b6c247cd-b51e-437a-b64c-3f9abd0cd245', 'UNSOLD'),
('48b6fed8-d8b9-46d0-aace-fd1ac1ec39a4', 'af701c5f-a02b-4dd6-aad4-e691a9977c97', 'UNSOLD'),
('b60193f1-84c8-446a-b184-5216f958a72a', '0132385a-f99c-4a53-971f-a195b15f3f5e', 'UNSOLD'),
('8a867e33-83d1-4533-a2c4-bce78807765c', '6376af77-1cdc-4bb5-b381-ec239b576c08', 'UNSOLD'),
('587eddf3-1aa9-4aa0-b33e-8e4ff0f5e56e', 'c2015b50-10f7-41e9-8f35-fd2b71db843b', 'UNSOLD'),
('6c748add-b4e5-453a-a676-eb3947d385d5', '8561f05f-f063-4018-8c75-6e3918a5a5cd', 'UNSOLD'),
('38795322-5ad3-4d5e-8e19-66357398f8ea', 'bacbf686-78a6-435d-8192-a37007b0dcf2', 'UNSOLD'),
('a684288b-2fcb-4bae-98f2-3f65a77f3513', 'a489841a-14e0-4cfe-a09b-f56db45203ea', 'UNSOLD'),
('a607df8b-9df9-450d-91d8-480580275d4d', '1fd393dc-7abe-41c6-8f34-778906592549', 'UNSOLD'),
('0f1a9053-7e0b-49bf-a3a6-55a25870ab1c', '1577e22a-0f67-4a11-bff3-9dcbbbd89684', 'UNSOLD'),
('8cde8d75-c719-4c54-8c52-8a93fd485d10', 'bd304e80-000d-4d13-942a-e6e0af2b0104', 'UNSOLD'),
('8bdf2831-38fa-44d9-b104-8386dc587ef6', '0d40b398-11bd-4d5e-a201-fcd590a55ea3', 'UNSOLD'),
('c4dc7fb9-3b38-46f7-8d55-fd723772efb0', '86779bf9-e3e1-4527-8411-691e45ce8cd7', 'UNSOLD'),
('11abc041-fcc0-4e5b-b6da-a66799824d8f', '97a2d1d4-cff8-468d-b932-ee4841f28a59', 'UNSOLD'),
('48492af1-2426-45c4-9804-6a3bfd3595e9', '7ca67034-31ac-4b89-96a1-bbc1ff80944e', 'UNSOLD'),
('be16330c-91e0-4732-9811-97b63a55208b', '22ac4991-dea2-45e0-854b-84c35df717c0', 'UNSOLD'),
('648e8b17-1624-4445-bf33-135c35a93577', 'c04d2b83-e414-40d1-afc5-da87a2636457', 'UNSOLD'),
('b5894944-91ee-4fa7-9d39-33e308dd40e6', '2b143922-6a43-4ca8-9496-9ba4090b8a23', 'UNSOLD'),
('10f7c8c7-39d9-4a32-8a4a-114042e4d228', 'd151e121-54f6-4bd6-bfab-1de898d5aeef', 'UNSOLD'),
('af616a41-f4d9-477a-a8d8-a6840e6234fb', 'b9d91d68-d094-49f8-9f6b-94bd7d040956', 'UNSOLD'),
('946fd691-6b03-407a-bbec-14fff2223b75', 'f982456d-bf46-4013-b734-e85059e4326b', 'UNSOLD'),
('e3c1cd8c-5188-49e2-947a-464d533e98e3', '29e7823f-59dd-47a3-8b96-90e258af3daa', 'UNSOLD'),
('10feac31-bc1b-46dc-9699-996795e36b75', '7f0c7b1a-f76b-40cd-93d1-b92960563676', 'UNSOLD'),
('88f91f96-f31c-4424-b327-9266973bdf33', 'b07df209-18c1-4c71-9b07-6edcc461ab54', 'UNSOLD'),
('1f62304a-e509-4bba-9748-8be28a3e280a', 'd3e0f06a-af29-414c-9623-1409e1bd87ab', 'UNSOLD');

INSERT INTO "AdminUser" (id, username, password_hash, role) VALUES
('e15a8d5c-30e0-4525-a2f8-9e28871486be', 'admin', '$2b$10$yEraTz0fk6jrb6hsA8wvgegYsrYvquSl6TIB9/TM2/rz2B4fqLLHS', 'ADMIN'),
('54b59a28-9979-4d2e-b809-79a57e74c76f', 'screen', '$2b$10$rB76LqZE.fIj6a11dxZ73eFtnOWmDj2YUDXBv4L028l8GGOuRwSQq', 'SCREEN');

INSERT INTO "AuctionSequence" (id, name, type, sequence_items) VALUES
(1, 'Franchise Auction', 'FRANCHISE', '[3,7,1,9,5,10,2,6,8,4]');

INSERT INTO "AuctionSequence" (id, name, type, sequence_items) VALUES
(2, 'Power Card Auction', 'POWER_CARD', '["GOD_EYE","MULLIGAN","FINAL_STRIKE","BID_FREEZER"]');

INSERT INTO "AuctionSequence" (id, name, type, sequence_items) VALUES
(3, 'Player Auction 5', 'PLAYER', '[152,75,154,16,138,73,106,90,155,100,80,93,41,118,18,69,103,105,102,88,126,136,115,129,68,44,150,157,14,65,4,127,140,91,142,144,28,58,82,50,43,34,143,119,37,123,23,89,64,24,85,62,148,149,96,63,98,45,15,87,70,101,32,10,67,35,132,27,153,130,159,33,12,66,79,133,1,156,125,120,59,83,84,74,121,146,141,117,124,97,139,52,51,107,72,86,39,29,108,135,3,60,110,158,77,9,31,95,81,49,151,113,109,111,116,54,122,137,26,40,92,71,20,57,36,53,11,47,42,6,145,114,7,134,112,30,2,25,94,38,76,131,17,46,19,56,21,104,99,5,147,61,48,8,78,22,55,13,128]');

INSERT INTO "AuctionState" (id, phase, auction_day) VALUES (1, 'NOT_STARTED', 'Day 1');

