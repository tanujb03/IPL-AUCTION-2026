-- INSTANCE 7 INITIALIZATION
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



-- ── DATA FOR INSTANCE 7 ──

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
('fde46455-1ef9-4fe0-83ba-b3885fc21be4', 'Hitman warriors', 'Hitman warriors', '$2b$10$hSGSsA74usMSCk8DaS.r1ub3uVT2sgOA6of92epHVYjgYZR65CjJS', 120, 0),
('2d679b90-e5c3-4411-80ed-a6c36a797086', 'Team Sher', 'Team Sher', '$2b$10$qV1Q3qvU71S9ijTCR5CAjuICajEy/xm0VXdZwrIIuvz21U6rIEtke', 120, 0),
('b473dcbc-0698-4fc9-ae0a-5eb6569bfecc', 'Crowned Killers', 'Crowned Killers', '$2b$10$VcG9BWs4OHeLULbjZb1f2ePr/029/atzgawUXM.cIKWjWAkkiiGM2', 120, 0),
('34e44b0d-b5f7-4cc1-91be-5254db54efd0', 'Elex Titans XI', 'Elex Titans XI', '$2b$10$Oy.nOAX1VUOKzynHx4CjhOo26TO1z3AKzoKotKX2Cg8g1FacK319a', 120, 0),
('2815f12d-f363-4ec5-b44a-1644a012249f', 'Royal Challengers Bhavans (RCB)', 'Royal Challengers Bhavans (RCB)', '$2b$10$kPkOLxaA6AahRwOmDogOau6ulSrr/hCM84YnwPBSOb9itS9fQjmG.', 120, 0),
('1c133cd9-1275-4056-a324-cbbe5e305f0b', 'Mumbai Indians', 'Mumbai Indians', '$2b$10$Q8La9tcaz/BxFC2EpHrQ..tOEylgB6syih9Iqub6d.UP.QtsBoEPS', 120, 0),
('a6852de8-9146-49cb-a330-8c571daf2dfd', 'Imperial Warriors', 'Imperial Warriors', '$2b$10$hr.maxYLcX41E8lOImA7f.EtoOXMDgFdVautOsDErQ4KK7ezBrD16', 120, 0),
('062fe77e-42b3-4543-9e04-018c3cf7f2c0', 'Heavy Balls XI', 'Heavy Balls XI', '$2b$10$IyiIbrT73eYyM9Db4T2lmeI6a3NJH8NMA.MS4Tom7GTLYglSeieJe', 120, 0),
('628080f2-3715-451b-8c79-a1813834662b', 'Reverse cowboys', 'Reverse cowboys', '$2b$10$G9xUf0giuiBqkIqXOkKuQ.v5vjRd0Zz0a.gyXSqsvXZNfGPGzx8xm', 120, 0),
('53957050-3e0a-4894-b60a-59b4df978c3e', 'Broke But Bidding', 'Broke But Bidding', '$2b$10$rNWnMQ/RqPkQPncZZgs.w.o4OvAUn96pyR2uiYGMwwhMq5gQhMs/G', 120, 0);

INSERT INTO "Player" (id, rank, name, team, role, category, pool, grade, rating, nationality, nationality_raw, base_price, is_riddle, riddle_title, riddle_question, legacy, url, matches, bat_runs, bat_sr, bat_average, bowl_wickets, bowl_eco, bowl_avg, sub_scoring, sub_impact, sub_consistency, sub_experience, sub_wicket_taking, sub_economy, sub_efficiency, sub_batting, sub_bowling, sub_versatility) VALUES
('8d318ddc-4e0a-4073-b729-f04102a552f9', 66, 'Philip Salt', 'Royal Challengers Bengaluru', 'WK-Batsman', 'WK', 'BAT_WK', 'B', 71, 'OVERSEAS', 'English', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/10479/philip-salt', 34.0, 1056.0, 175.71, 34.06, NULL, NULL, NULL, 23.0, 95.0, 84.0, 47, NULL, NULL, NULL, NULL, NULL, NULL),
('d17be77a-5c81-4612-96b6-5f53f0607cf1', 55, 'Mitchell Starc', 'Delhi Capitals', 'Bowler', 'BOWL', 'BOWL', 'B', 73, 'OVERSEAS', 'Australian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/7710/mitchell-starc', 51.0, NULL, NULL, NULL, 65.0, 8.61, 23.12, NULL, NULL, NULL, 55, 45.0, 62.0, 88.0, NULL, NULL, NULL),
('2fcd743a-db88-4f7f-b5f9-998d02a8795a', 24, 'Varun Chakaravarthy', 'Kolkata Knight Riders', 'Bowler', 'BOWL', 'BOWL', 'B', 84, 'INDIAN', 'Indian', 1, false, NULL, NULL, 2, 'https://www.cricbuzz.com/profiles/12926/varun-chakaravarthy', 83.0, NULL, NULL, NULL, 100.0, 7.58, 23.85, NULL, NULL, NULL, 71, 68.0, 79.0, 87.0, NULL, NULL, NULL),
('a1d844f2-317c-4b40-a7f7-f592ab59200c', 83, 'Jason Holder', 'Gujarat Titans', 'Bowling Allrounder', 'AR', 'AR', 'C', 68, 'OVERSEAS', 'West Indian', 0.5, false, NULL, NULL, 2, 'https://www.cricbuzz.com/profiles/8313/jason-holder', 46.0, 259.0, NULL, NULL, 53.0, NULL, NULL, NULL, NULL, NULL, 53, NULL, NULL, NULL, 32.0, 45.0, 32.0),
('9aa9e4b9-d24f-4d38-bc1f-693c244a382f', 111, 'Ryan Rickelton', 'Mumbai Indians', 'WK-Batsman', 'WK', 'BAT_WK', 'C', 62, 'OVERSEAS', 'South African', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/13070/ryan-rickelton', 14.0, 388.0, 150.98, 29.85, NULL, NULL, NULL, 11.0, 79.0, 74.0, 37, NULL, NULL, NULL, NULL, NULL, NULL),
('c9be7f08-4e2c-453c-a882-b63698d3df4e', 137, 'Jayant Yadav', 'Gujarat Titans', 'Bowling Allrounder', 'AR', 'AR', 'C', 58, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/8182/jayant-yadav', 20.0, 40.0, NULL, NULL, 8.0, NULL, NULL, NULL, NULL, NULL, 40, NULL, NULL, NULL, 22.0, 25.0, 22.0),
('68fcb5df-5f68-4967-ba85-823fce59f5af', 101, 'Umran Malik', 'Kolkata Knight Riders', 'Bowler', 'BOWL', 'BOWL', 'C', 65, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/19027/umran-malik', 26.0, NULL, NULL, NULL, 29.0, 9.4, 26.62, NULL, NULL, NULL, 43, 22.0, 49.0, 81.0, NULL, NULL, NULL),
('f20c41c0-75f0-4502-8926-b1178c5dd019', 86, 'Mayank Markande', 'Mumbai Indians', 'Bowler', 'BOWL', 'BOWL', 'C', 67, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/12627/mayank-markande', 37.0, NULL, NULL, NULL, 37.0, 8.91, 28.89, NULL, NULL, NULL, 48, 27.0, 57.0, 76.0, NULL, NULL, NULL),
('6f89b332-5f5c-482c-9bcd-11d833d0c741', 67, 'Ayush Badoni', 'Lucknow Super Giants', 'Batting Allrounder', 'AR', 'AR', 'B', 71, 'INDIAN', 'Indian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/13907/ayush-badoni', 56.0, 963.0, NULL, NULL, 4.0, NULL, NULL, NULL, NULL, NULL, 58, NULL, NULL, NULL, 63.0, 37.0, 37.0),
('7865c5fc-9884-4325-b8fa-70f89dead846', 110, 'Josh Inglis', 'Lucknow Super Giants', 'WK-Batsman', 'WK', 'BAT_WK', 'C', 63, 'OVERSEAS', 'Australian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/10637/josh-inglis', 11.0, 278.0, 162.58, 30.89, NULL, NULL, NULL, 9.0, 87.0, 77.0, 35, NULL, NULL, NULL, NULL, NULL, NULL),
('0fc769a9-07e9-4fa5-a9e8-d833003e7b8c', 14, 'Ajinkya Rahane', 'Kolkata Knight Riders', 'Batsman', 'BAT', 'BAT_WK', 'A', 91, 'INDIAN', 'Indian', 2, false, NULL, NULL, 4, 'https://www.cricbuzz.com/profiles/1447/ajinkya-rahane', 198.0, 5032.0, 125.02, 30.5, NULL, NULL, NULL, 95.0, 61.0, 76.0, 99, NULL, NULL, NULL, NULL, NULL, NULL),
('325214ec-1edb-4683-b75e-48073e65d702', 141, 'Eshan Malinga', 'Sunrisers Hyderabad', 'Bowler', 'BOWL', 'BOWL', 'C', 58, 'OVERSEAS', 'Sri Lankan', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/46926/eshan-malinga', 7.0, NULL, NULL, NULL, 13.0, 8.93, 18.31, NULL, NULL, NULL, 33, 12.0, 57.0, 99.0, NULL, NULL, NULL),
('e4f61daf-99d3-4d82-8e9b-d076216fd8ae', 106, 'Sarfaraz Khan', 'Chennai Super Kings', 'Batsman', 'BAT', 'BAT_WK', 'C', 64, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/9429/sarfaraz-khan', 50.0, 585.0, 130.59, 22.5, NULL, NULL, NULL, 15.0, 65.0, 56.0, 55, NULL, NULL, NULL, NULL, NULL, NULL),
('ed9249e7-e70c-44a2-8ad3-7ff40890d262', 85, 'Mohsin Khan', 'Lucknow Super Giants', 'Bowler', 'BOWL', 'BOWL', 'C', 67, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/13534/mohsin-khan', 24.0, NULL, NULL, NULL, 27.0, 8.51, 25.52, NULL, NULL, NULL, 42, 21.0, 64.0, 83.0, NULL, NULL, NULL),
('9fae6059-2fae-4571-88fc-718e723d45f0', 114, 'Mitchell Santner', 'Mumbai Indians', 'Bowling Allrounder', 'AR', 'AR', 'C', 62, 'OVERSEAS', 'New Zealander', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/10100/mitchell-santner', 31.0, 110.0, NULL, NULL, 25.0, NULL, NULL, NULL, NULL, NULL, 45, NULL, NULL, NULL, 25.0, 40.0, 25.0),
('e0f0a8f8-040e-4456-b996-599fec522222', 120, 'Ravisrinivasan Sai Kishore', 'Gujarat Titans', 'Bowling Allrounder', 'AR', 'AR', 'C', 61, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/11595/ravisrinivasan-sai-kishore', 25.0, 18.0, NULL, NULL, 32.0, NULL, NULL, NULL, NULL, NULL, 42, NULL, NULL, NULL, 19.0, 41.0, 19.0),
('7e113640-6447-4607-919a-6aaf5990eb20', 69, 'Liam Livingstone', 'Sunrisers Hyderabad', 'Batting Allrounder', 'AR', 'AR', 'B', 70, 'OVERSEAS', 'English', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/10045/liam-livingstone', 49.0, 1051.0, NULL, NULL, 13.0, NULL, NULL, NULL, NULL, NULL, 54, NULL, NULL, NULL, 70.0, 28.0, 28.0),
('fe1f1179-7a96-4e26-b1df-6f571b8eac0e', 133, 'Kyle Jamieson', 'Delhi Capitals', 'Bowler', 'BOWL', 'BOWL', 'C', 59, 'OVERSEAS', 'New Zealander', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/9441/kyle-jamieson', 13.0, NULL, NULL, NULL, 14.0, 9.67, 29.71, NULL, NULL, NULL, 36, 12.0, 45.0, 74.0, NULL, NULL, NULL),
('6c59451d-7e00-4802-9476-ba4c327f3b50', 92, 'Shashank Singh', 'Punjab Kings', 'Batting Allrounder', 'AR', 'AR', 'C', 67, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/10919/shashank-singh', 41.0, 773.0, NULL, NULL, 1.0, NULL, NULL, NULL, NULL, NULL, 50, NULL, NULL, NULL, 67.0, 14.0, 14.0),
('4dbe8adc-43e6-4874-a86b-ca3b70c1f889', 78, 'Rajat Patidar', 'Royal Challengers Bengaluru', 'Batsman', 'BAT', 'BAT_WK', 'C', 69, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/10636/rajat-patidar', 42.0, 1111.0, 154.31, 30.86, NULL, NULL, NULL, 24.0, 81.0, 77.0, 51, NULL, NULL, NULL, NULL, NULL, NULL),
('6cf1c007-456c-4f73-b81a-0cf047fe1bef', 118, 'Aniket Verma', 'Sunrisers Hyderabad', 'Batsman', 'BAT', 'BAT_WK', 'C', 62, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/1447065/aniket-verma', 14.0, 236.0, 166.2, 26.22, NULL, NULL, NULL, 8.0, 89.0, 65.0, 37, NULL, NULL, NULL, NULL, NULL, NULL),
('58b972fd-dfab-4df4-a538-85b6ffc8b3af', 59, 'Rahul Tewatia', 'Gujarat Titans', 'Batting Allrounder', 'AR', 'AR', 'B', 73, 'INDIAN', 'Indian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/9693/rahul-tewatia', 108.0, 1112.0, NULL, NULL, 32.0, NULL, NULL, NULL, NULL, NULL, 84, NULL, NULL, NULL, 64.0, 38.0, 38.0),
('e9d03683-2581-48dc-b6af-514f5c59a5ef', 115, 'Rachin Ravindra', 'Kolkata Knight Riders', 'Batting Allrounder', 'AR', 'AR', 'C', 62, 'OVERSEAS', 'New Zealander', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/11177/rachin-ravindra', 18.0, 413.0, NULL, NULL, 0.0, NULL, NULL, NULL, NULL, NULL, 39, NULL, NULL, NULL, 49.0, 29.0, 29.0),
('5024d56b-3332-4572-a622-29bc3e154a07', 58, 'Riyan Parag', 'Rajasthan Royals', 'Batting Allrounder', 'AR', 'AR', 'B', 73, 'INDIAN', 'Indian', 1, false, NULL, NULL, 2, 'https://www.cricbuzz.com/profiles/12305/riyan-parag', 83.0, 1566.0, NULL, NULL, 7.0, NULL, NULL, NULL, NULL, NULL, 71, NULL, NULL, NULL, 78.0, 16.0, 16.0),
('46f45824-2515-44f1-9693-870b5eb86549', 155, 'Swapnil Singh', 'Royal Challengers Bengaluru', 'Bowling Allrounder', 'AR', 'AR', 'C', 56, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/10238/swapnil-singh', 14.0, 51.0, NULL, NULL, 7.0, NULL, NULL, NULL, NULL, NULL, 37, NULL, NULL, NULL, 23.0, 27.0, 23.0),
('58dfffa9-ce49-4548-be60-db18898f991a', 72, 'Aiden Markram', 'Lucknow Super Giants', 'Batsman', 'BAT', 'BAT_WK', 'B', 70, 'OVERSEAS', 'South African', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/9582/aiden-markram', 57.0, 1440.0, 135.09, 31.3, NULL, NULL, NULL, 30.0, 68.0, 78.0, 58, NULL, NULL, NULL, NULL, NULL, NULL),
('a0be2249-60e6-4aa5-bd0c-13a05d931923', 80, 'Lockie Ferguson', 'Punjab Kings', 'Bowler', 'BOWL', 'BOWL', 'C', 69, 'OVERSEAS', 'New Zealander', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/10692/lockie-ferguson', 49.0, NULL, NULL, NULL, 51.0, 8.97, 30.0, NULL, NULL, NULL, 54, 36.0, 56.0, 74.0, NULL, NULL, NULL),
('cab50594-cdeb-4643-afb7-54b9377b9263', 43, 'Abhishek Sharma', 'Sunrisers Hyderabad', 'Batting Allrounder', 'AR', 'AR', 'B', 77, 'INDIAN', 'Indian', 1, false, NULL, NULL, 2, 'https://www.cricbuzz.com/profiles/12086/abhishek-sharma', 77.0, 1815.0, NULL, NULL, 11.0, NULL, NULL, NULL, NULL, NULL, 68, NULL, NULL, NULL, 90.0, 24.0, 24.0),
('186f3aed-1921-4a48-a6c7-2494e96b3fe8', 135, 'Kartik Tyagi', 'Kolkata Knight Riders', 'Bowler', 'BOWL', 'BOWL', 'C', 58, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/13136/kartik-tyagi', 20.0, NULL, NULL, NULL, 15.0, 10.14, 47.53, NULL, NULL, NULL, 40, 13.0, 37.0, 37.0, NULL, NULL, NULL),
('cd6b5059-1b14-4569-b619-ec4138846386', 32, 'David Miller', 'Delhi Capitals', 'Batsman', 'BAT', 'BAT_WK', 'B', 80, 'OVERSEAS', 'South African', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/6349/david-miller', 141.0, 3077.0, 138.61, 35.78, NULL, NULL, NULL, 60.0, 70.0, 89.0, 99, NULL, NULL, NULL, NULL, NULL, NULL),
('6e40a385-9d34-40c5-b17c-9b8e0c27cf3a', 36, 'Arshdeep Singh', 'Punjab Kings', 'Bowler', 'BOWL', 'BOWL', 'B', 78, 'INDIAN', 'Indian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/13217/arshdeep-singh', 82.0, NULL, NULL, NULL, 97.0, 9.0, 26.49, NULL, NULL, NULL, 71, 66.0, 56.0, 81.0, NULL, NULL, NULL),
('b1896dd1-6ba7-4fd6-9628-ac1aaa2565a7', 145, 'Akash Maharaj Singh', 'Lucknow Super Giants', 'Bowler', 'BOWL', 'BOWL', 'C', 57, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/14696/akash-maharaj-singh', 10.0, NULL, NULL, NULL, 9.0, 9.54, 36.22, NULL, NULL, NULL, 35, 9.0, 47.0, 61.0, NULL, NULL, NULL),
('bdaa8a80-a255-4943-aa78-e667f51d8bf2', 98, 'Shivam Mavi', 'Sunrisers Hyderabad', 'Bowler', 'BOWL', 'BOWL', 'C', 66, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/12345/shivam-mavi', 32.0, NULL, NULL, NULL, 30.0, 8.71, 31.4, NULL, NULL, NULL, 46, 23.0, 60.0, 71.0, NULL, NULL, NULL),
('4f659b22-9f57-4ed4-9cbc-09fe03182c0c', 16, 'Suryakumar Yadav', 'Mumbai Indians', 'Batsman', 'BAT', 'BAT_WK', 'A', 89, 'INDIAN', 'Indian', 2, false, NULL, NULL, 2, 'https://www.cricbuzz.com/profiles/7915/suryakumar-yadav', 166.0, 4311.0, 148.66, 35.05, NULL, NULL, NULL, 82.0, 77.0, 87.0, 99, NULL, NULL, NULL, NULL, NULL, NULL),
('820fc955-aef3-452b-8fe1-81e5ed1df3e9', 100, 'Abishek Porel', 'Delhi Capitals', 'WK-Batsman', 'WK', 'BAT_WK', 'C', 66, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/24326/abishek-porel', 31.0, 661.0, 149.89, 25.42, NULL, NULL, NULL, 16.0, 78.0, 63.0, 45, NULL, NULL, NULL, NULL, NULL, NULL),
('cdf868d8-6fcb-4fb8-9d6f-ecb8f00c1151', 143, 'Prashant Solanki', 'Kolkata Knight Riders', 'Bowler', 'BOWL', 'BOWL', 'C', 57, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/12805/prashant-solanki', 2.0, NULL, NULL, NULL, 2.0, 6.33, 19.0, NULL, NULL, NULL, 31, 5.0, 99.0, 97.0, NULL, NULL, NULL),
('f716783c-3894-4a86-a4b8-aa1e8023b0e5', 147, 'Mayank Yadav', 'Lucknow Super Giants', 'Bowler', 'BOWL', 'BOWL', 'C', 57, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/22401/mayank-yadav', 6.0, NULL, NULL, NULL, 9.0, 9.17, 20.56, NULL, NULL, NULL, 33, 9.0, 53.0, 94.0, NULL, NULL, NULL),
('aa6eee81-2645-4b0e-97e1-e1f47073e170', 158, 'Arjun Tendulkar', 'Lucknow Super Giants', 'Bowling Allrounder', 'AR', 'AR', 'C', 55, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/13747/arjun-tendulkar', 5.0, 13.0, NULL, NULL, 3.0, NULL, NULL, NULL, NULL, NULL, 32, NULL, NULL, NULL, 32.0, 23.0, 23.0),
('ce6ea39c-14f7-4d0a-afea-60d92d59fc5f', 126, 'Nathan Ellis', 'Chennai Super Kings', 'Bowler', 'BOWL', 'BOWL', 'C', 61, 'OVERSEAS', 'Australian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/15480/nathan-ellis', 17.0, NULL, NULL, NULL, 19.0, 8.67, 28.74, NULL, NULL, NULL, 38, 16.0, 61.0, 77.0, NULL, NULL, NULL),
('49906079-3acb-4b35-bcd7-153bf7fc086a', 47, 'Yashasvi Jaiswal', 'Rajasthan Royals', 'Batsman', 'BAT', 'BAT_WK', 'B', 75, 'INDIAN', 'Indian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/13940/yashasvi-jaiswal', 66.0, 2166.0, 152.86, 34.38, NULL, NULL, NULL, 43.0, 80.0, 85.0, 63, NULL, NULL, NULL, NULL, NULL, NULL),
('988440aa-cd3e-44d2-96a4-245f212236c0', 124, 'Shubham Dubey', 'Rajasthan Royals', 'Batsman', 'BAT', 'BAT_WK', 'C', 61, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/19328/shubham-dubey', 13.0, 139.0, 163.53, 23.17, NULL, NULL, NULL, 6.0, 87.0, 58.0, 36, NULL, NULL, NULL, NULL, NULL, NULL),
('7a9edbfa-ccfe-4e3e-9e9f-173f6df800b1', 93, 'Washington Sundar', 'Gujarat Titans', 'Bowling Allrounder', 'AR', 'AR', 'C', 67, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/10945/washington-sundar', 66.0, 511.0, NULL, NULL, 39.0, NULL, NULL, NULL, NULL, NULL, 63, NULL, NULL, NULL, 42.0, 40.0, 40.0),
('be00467e-8341-473f-9267-d6781312bf6f', 87, 'Tushar Deshpande', 'Rajasthan Royals', 'Bowler', 'BOWL', 'BOWL', 'C', 67, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/11307/tushar-deshpande', 46.0, NULL, NULL, NULL, 51.0, 9.84, 31.04, NULL, NULL, NULL, 53, 36.0, 42.0, 72.0, NULL, NULL, NULL),
('02eab9d5-fd45-462f-97f3-6ceed4819f5d', 33, 'Ishant Sharma', 'Gujarat Titans', 'Bowler', 'BOWL', 'BOWL', 'B', 79, 'INDIAN', 'Indian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/702/ishant-sharma', 117.0, NULL, NULL, NULL, 96.0, 8.38, 35.18, NULL, NULL, NULL, 88, 65.0, 66.0, 63.0, NULL, NULL, NULL),
('84fa750e-ac13-4538-8901-db2fbc89dcb8', 94, 'Will Jacks', 'Mumbai Indians', 'Batting Allrounder', 'AR', 'AR', 'C', 66, 'OVERSEAS', 'English', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/12258/will-jacks', 21.0, 463.0, NULL, NULL, 8.0, NULL, NULL, NULL, NULL, NULL, 40, NULL, NULL, NULL, 55.0, 28.0, 28.0),
('ae8b5d64-449a-4d20-aa60-0dff9f8cf2cb', 79, 'Prabhsimran Singh', 'Punjab Kings', 'WK-Batsman', 'WK', 'BAT_WK', 'C', 69, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/14254/prabhsimran-singh', 51.0, 1305.0, 151.93, 25.59, NULL, NULL, NULL, 28.0, 79.0, 64.0, 55, NULL, NULL, NULL, NULL, NULL, NULL),
('054f9b13-f4c5-4e94-ae9a-62b6acf09036', 76, 'Tristan Stubbs', 'Delhi Capitals', 'WK-Batsman', 'WK', 'BAT_WK', 'B', 70, 'OVERSEAS', 'South African', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/19243/tristan-stubbs', 32.0, 705.0, 163.2, 41.47, NULL, NULL, NULL, 17.0, 87.0, 99.0, 46, NULL, NULL, NULL, NULL, NULL, NULL),
('f9485725-afdc-4c7b-8a72-5a3ccfd62b4e', 68, 'Anrich Nortje', 'Lucknow Super Giants', 'Bowler', 'BOWL', 'BOWL', 'B', 71, 'OVERSEAS', 'South African', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/11427/anrich-nortje', 48.0, NULL, NULL, NULL, 61.0, 9.07, 27.16, NULL, NULL, NULL, 54, 43.0, 55.0, 80.0, NULL, NULL, NULL),
('9706cf98-8127-4b94-8f0d-b669a3558d06', 31, 'Manish Pandey', 'Kolkata Knight Riders', 'Batsman', 'BAT', 'BAT_WK', 'B', 82, 'INDIAN', 'Indian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/1836/manish-pandey', 174.0, 3942.0, 121.52, 29.42, NULL, NULL, NULL, 76.0, 59.0, 73.0, 99, NULL, NULL, NULL, NULL, NULL, NULL),
('2332ad10-1ddb-459c-8bbc-a797f1dfe515', 140, 'Mukesh Choudhary', 'Chennai Super Kings', 'Bowler', 'BOWL', 'BOWL', 'C', 58, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/13184/mukesh-choudhary', 16.0, NULL, NULL, NULL, 17.0, 9.94, 30.71, NULL, NULL, NULL, 38, 14.0, 40.0, 72.0, NULL, NULL, NULL),
('e4934ee6-69ee-4c90-babe-1a3864128d8c', 130, 'Sameer Rizvi', 'Delhi Capitals', 'Batsman', 'BAT', 'BAT_WK', 'C', 60, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/14700/sameer-rizvi', 13.0, 172.0, 140.99, 24.57, NULL, NULL, NULL, 7.0, 72.0, 61.0, 36, NULL, NULL, NULL, NULL, NULL, NULL),
('f0cbf40d-eda4-4392-8e9d-1a15a63a808c', 104, 'Lungi Ngidi', 'Delhi Capitals', 'Bowler', 'BOWL', 'BOWL', 'C', 64, 'OVERSEAS', 'South African', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/9603/lungi-ngidi', 16.0, NULL, NULL, NULL, 29.0, 8.53, 18.24, NULL, NULL, NULL, 38, 22.0, 63.0, 99.0, NULL, NULL, NULL),
('ca5fa390-bcdb-4a83-a2f4-9bf983c05aee', 19, 'Hardik Pandya', 'Mumbai Indians', 'Batting Allrounder', 'AR', 'AR', 'A', 89, 'INDIAN', 'Indian', 2, false, NULL, NULL, 6, 'https://www.cricbuzz.com/profiles/9647/hardik-pandya', 152.0, 2749.0, NULL, NULL, 78.0, NULL, NULL, NULL, NULL, NULL, 99, NULL, NULL, NULL, 90.0, 50.0, 50.0),
('534a9eea-e433-4576-9686-dba93c290c3c', 71, 'Matheesha Pathirana', 'Kolkata Knight Riders', 'Bowler', 'BOWL', 'BOWL', 'B', 70, 'OVERSEAS', 'Sri Lankan', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/16458/matheesha-pathirana', 32.0, NULL, NULL, NULL, 47.0, 8.68, 21.62, NULL, NULL, NULL, 46, 34.0, 61.0, 92.0, NULL, NULL, NULL),
('2c228000-eea8-47e6-ac65-6f9172d5c877', 125, 'Vaibhav Suryavanshi', 'Rajasthan Royals', 'Batsman', 'BAT', 'BAT_WK', 'C', 61, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/51791/vaibhav-suryavanshi', 7.0, 252.0, 206.56, 36.0, NULL, NULL, NULL, 9.0, 99.0, 89.0, 33, NULL, NULL, NULL, NULL, NULL, NULL),
('163488e1-a894-4bbd-89b6-b4ba2d717664', 138, 'Azmatullah Omarzai', 'Punjab Kings', 'Bowling Allrounder', 'AR', 'AR', 'C', 58, 'OVERSEAS', 'Afghan', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/13214/azmatullah-omarzai', 16.0, 99.0, NULL, NULL, 12.0, NULL, NULL, NULL, NULL, NULL, 38, NULL, NULL, NULL, 31.0, 25.0, 25.0),
('71e7807b-40d3-496d-af3b-99dd8dc82066', 159, 'Rasikh Dar Salam', 'Royal Challengers Bengaluru', 'Bowler', 'BOWL', 'BOWL', 'C', 55, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/14274/rasikh-dar-salam', 13.0, NULL, NULL, NULL, 10.0, 10.62, 40.9, NULL, NULL, NULL, 36, 10.0, 29.0, 51.0, NULL, NULL, NULL),
('1861edbb-d2a8-45b1-bca5-9066aee709c1', 44, 'Khaleel Ahmed', 'Chennai Super Kings', 'Bowler', 'BOWL', 'BOWL', 'B', 77, 'INDIAN', 'Indian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/10952/khaleel-ahmed', 71.0, NULL, NULL, NULL, 89.0, 8.98, 26.16, NULL, NULL, NULL, 65, 61.0, 56.0, 82.0, NULL, NULL, NULL),
('c2ded8b0-f55a-466d-a920-ec708043e2c9', 123, 'Ayush Mhatre', 'Chennai Super Kings', 'Batsman', 'BAT', 'BAT_WK', 'C', 61, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/1431163/ayush-mhatre', 7.0, 240.0, 188.98, 34.29, NULL, NULL, NULL, 8.0, 99.0, 85.0, 33, NULL, NULL, NULL, NULL, NULL, NULL),
('6b9d94b7-5e31-40ce-b866-13e3ff4f07bb', 38, 'Shardul Thakur', 'Mumbai Indians', 'Bowling Allrounder', 'AR', 'AR', 'B', 78, 'INDIAN', 'Indian', 1, false, NULL, NULL, 6, 'https://www.cricbuzz.com/profiles/8683/shardul-thakur', 105.0, 325.0, NULL, NULL, 107.0, NULL, NULL, NULL, NULL, NULL, 82, NULL, NULL, NULL, 38.0, 59.0, 38.0),
('45e27ed1-e747-4327-9f1c-dfa77ae8ae96', 63, 'T Natarajan', 'Delhi Capitals', 'Bowler', 'BOWL', 'BOWL', 'B', 72, 'INDIAN', 'Indian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/10225/t-natarajan', 63.0, NULL, NULL, NULL, 67.0, 8.94, 30.12, NULL, NULL, NULL, 61, 47.0, 57.0, 74.0, NULL, NULL, NULL),
('7d5f6098-a9ee-4286-b214-892bde0fa0e3', 27, 'Shreyas Iyer', 'Punjab Kings', 'Batsman', 'BAT', 'BAT_WK', 'B', 83, 'INDIAN', 'Indian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/9428/shreyas-iyer', 132.0, 3731.0, 133.35, 34.23, NULL, NULL, NULL, 72.0, 67.0, 85.0, 96, NULL, NULL, NULL, NULL, NULL, NULL),
('aa3e753f-8414-468c-b299-ff350926cf80', 97, 'Ramandeep Singh', 'Kolkata Knight Riders', 'Batting Allrounder', 'AR', 'AR', 'C', 66, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/12337/ramandeep-singh', 30.0, 217.0, NULL, NULL, 6.0, NULL, NULL, NULL, NULL, NULL, 45, NULL, NULL, NULL, 46.0, 35.0, 35.0),
('75f42b4b-54ee-442d-9985-afed195d3634', 129, 'Anuj Rawat', 'Gujarat Titans', 'WK-Batsman', 'WK', 'BAT_WK', 'C', 60, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/13135/anuj-rawat', 24.0, 318.0, 119.11, 19.88, NULL, NULL, NULL, 10.0, 57.0, 50.0, 42, NULL, NULL, NULL, NULL, NULL, NULL),
('6e743407-8520-42de-bac1-7ec176814a74', 142, 'Kamindu Mendis', 'Sunrisers Hyderabad', 'Batting Allrounder', 'AR', 'AR', 'C', 57, 'OVERSEAS', 'Sri Lankan', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/10940/kamindu-mendis', 5.0, 92.0, NULL, NULL, 2.0, NULL, NULL, NULL, NULL, NULL, 32, NULL, NULL, NULL, 38.0, 29.0, 29.0),
('bf254bda-085e-4181-90ab-87c906fcfb76', 95, 'Nehal Wadhera', 'Punjab Kings', 'Batsman', 'BAT', 'BAT_WK', 'C', 66, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/13915/nehal-wadhera', 36.0, 719.0, 142.95, 26.63, NULL, NULL, NULL, 17.0, 73.0, 66.0, 48, NULL, NULL, NULL, NULL, NULL, NULL),
('d9a795e3-f7b3-4c90-ad83-d74eefcf2a9d', 73, 'Tim David', 'Royal Challengers Bengaluru', 'Batsman', 'BAT', 'BAT_WK', 'B', 70, 'OVERSEAS', 'Singaporean', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/13169/tim-david', 50.0, 846.0, 173.37, 32.54, NULL, NULL, NULL, 19.0, 94.0, 81.0, 55, NULL, NULL, NULL, NULL, NULL, NULL),
('6810d4a5-1de6-4e4d-a587-2fbc254dd990', 60, 'Noor Ahmad', 'Chennai Super Kings', 'Bowler', 'BOWL', 'BOWL', 'B', 72, 'OVERSEAS', 'Afghan', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/15452/noor-ahmad', 37.0, NULL, NULL, NULL, 48.0, 8.08, 22.23, NULL, NULL, NULL, 48, 34.0, 71.0, 90.0, NULL, NULL, NULL),
('35cb64c7-3d0f-402f-a4f6-2e17e78d3747', 81, 'Harpreet Brar', 'Punjab Kings', 'Bowler', 'BOWL', 'BOWL', 'C', 68, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/14452/harpreet-brar', 49.0, NULL, NULL, NULL, 35.0, 8.03, 31.0, NULL, NULL, NULL, 54, 26.0, 71.0, 72.0, NULL, NULL, NULL),
('805dd354-2120-4498-a9b6-0fecbc2d4064', 121, 'Suyash Sharma', 'Royal Challengers Bengaluru', 'Bowler', 'BOWL', 'BOWL', 'C', 61, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/36487/suyash-sharma', 27.0, NULL, NULL, NULL, 18.0, 8.75, 45.22, NULL, NULL, NULL, 43, 15.0, 60.0, 41.0, NULL, NULL, NULL),
('9828d675-65a2-4eb8-96d1-7fcc60c2feef', 82, 'Jitesh Sharma', 'Royal Challengers Bengaluru', 'WK-Batsman', 'WK', 'BAT_WK', 'C', 68, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/10214/jitesh-sharma', 55.0, 991.0, 157.06, 25.41, NULL, NULL, NULL, 22.0, 83.0, 63.0, 57, NULL, NULL, NULL, NULL, NULL, NULL),
('bc824693-99f5-4fff-9a96-cd5f6527cf16', 51, 'Sam Curran', 'Rajasthan Royals', 'Bowling Allrounder', 'AR', 'AR', 'B', 74, 'OVERSEAS', 'English', 1, false, NULL, NULL, 2, 'https://www.cricbuzz.com/profiles/10420/sam-curran', 64.0, 997.0, NULL, NULL, 59.0, NULL, NULL, NULL, NULL, NULL, 62, NULL, NULL, NULL, 62.0, 41.0, 41.0),
('23e1afab-44d1-422d-b0c9-db8430895184', 77, 'Rinku Singh', 'Kolkata Knight Riders', 'Batsman', 'BAT', 'BAT_WK', 'C', 69, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/10896/rinku-singh', 58.0, 1099.0, 145.18, 30.53, NULL, NULL, NULL, 24.0, 75.0, 76.0, 59, NULL, NULL, NULL, NULL, NULL, NULL),
('20ee9b46-b6d5-44f7-9e3b-8a850659b0f4', 70, 'Venkatesh Iyer', 'Royal Challengers Bengaluru', 'Batting Allrounder', 'AR', 'AR', 'B', 70, 'INDIAN', 'Indian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/10917/venkatesh-iyer', 61.0, 1468.0, NULL, NULL, 3.0, NULL, NULL, NULL, NULL, NULL, 60, NULL, NULL, NULL, 77.0, 16.0, 16.0),
('d81a4620-8e13-4350-90f7-9e23df05c59e', 88, 'Harshit Rana', 'Kolkata Knight Riders', 'Bowler', 'BOWL', 'BOWL', 'C', 67, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/24729/harshit-rana', 33.0, NULL, NULL, NULL, 40.0, 9.51, 25.73, NULL, NULL, NULL, 46, 29.0, 47.0, 83.0, NULL, NULL, NULL),
('f8863468-8891-4726-a4cb-e1488f03245e', 116, 'Sherfane Rutherford', 'Mumbai Indians', 'Batting Allrounder', 'AR', 'AR', 'C', 62, 'OVERSEAS', 'West Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/13748/sherfane-rutherford', 23.0, 397.0, NULL, NULL, 1.0, NULL, NULL, NULL, NULL, NULL, 41, NULL, NULL, NULL, 48.0, 17.0, 17.0),
('49741b0d-904f-4c3b-b1af-078378ac824a', 139, 'Nandre Burger', 'Rajasthan Royals', 'Bowler', 'BOWL', 'BOWL', 'C', 58, 'OVERSEAS', 'South African', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/13630/nandre-burger', 5.0, NULL, NULL, NULL, 7.0, 8.53, 20.71, NULL, NULL, NULL, 32, 8.0, 63.0, 94.0, NULL, NULL, NULL),
('920f1e66-ebbf-4485-8558-2f5adf9840a3', 102, 'Angkrish Raghuvanshi', 'Kolkata Knight Riders', 'Batsman', 'BAT', 'BAT_WK', 'C', 65, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/22566/angkrish-raghuvanshi', 22.0, 463.0, 144.69, 28.94, NULL, NULL, NULL, 12.0, 75.0, 72.0, 41, NULL, NULL, NULL, NULL, NULL, NULL),
('78faf99b-731a-4694-a149-47f1c49cf507', 74, 'Devdutt Padikkal', 'Royal Challengers Bengaluru', 'Batsman', 'BAT', 'BAT_WK', 'B', 70, 'INDIAN', 'Indian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/13088/devdutt-padikkal', 74.0, 1806.0, 126.3, 25.44, NULL, NULL, NULL, 37.0, 62.0, 64.0, 67, NULL, NULL, NULL, NULL, NULL, NULL),
('72abba88-88ae-4838-b082-82469dbcd886', 131, 'Romario Shepherd', 'Royal Challengers Bengaluru', 'Bowling Allrounder', 'AR', 'AR', 'C', 60, 'OVERSEAS', 'West Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/13646/romario-shepherd', 18.0, 185.0, NULL, NULL, 10.0, NULL, NULL, NULL, NULL, NULL, 39, NULL, NULL, NULL, 52.0, 18.0, 18.0),
('56ba50f5-2699-412a-991f-73d293ceba84', 48, 'Pat Cummins', 'Sunrisers Hyderabad', 'Bowler', 'BOWL', 'BOWL', 'B', 75, 'OVERSEAS', 'Australian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/8095/pat-cummins', 72.0, NULL, NULL, NULL, 79.0, 8.81, 30.04, NULL, NULL, NULL, 66, 54.0, 59.0, 74.0, NULL, NULL, NULL),
('c53b9a46-1f0f-4f99-9794-b9621059499d', 40, 'Rahul Chahar', 'Chennai Super Kings', 'Bowler', 'BOWL', 'BOWL', 'B', 77, 'INDIAN', 'Indian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/12087/rahul-chahar', 79.0, NULL, NULL, NULL, 75.0, 7.72, 28.67, NULL, NULL, NULL, 69, 52.0, 76.0, 77.0, NULL, NULL, NULL),
('eb0ae01f-6a97-4810-b3cc-4f9eacb6cb50', 122, 'Ashutosh Sharma', 'Delhi Capitals', 'Batting Allrounder', 'AR', 'AR', 'C', 61, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/13497/ashutosh-sharma', 24.0, 393.0, NULL, NULL, 0.0, NULL, NULL, NULL, NULL, NULL, 42, NULL, NULL, NULL, 56.0, 7, 14),
('d85243c7-50c7-4ab8-8e40-e8d1c1b9085d', 157, 'Manimaran Siddharth', 'Lucknow Super Giants', 'Bowler', 'BOWL', 'BOWL', 'C', 55, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/12930/manimaran-siddharth', 5.0, NULL, NULL, NULL, 3.0, 8.63, 46.0, NULL, NULL, NULL, 32, 5.0, 62.0, 40.0, NULL, NULL, NULL),
('70702806-efc8-4971-8fa7-85e1ebb5c106', 132, 'Kuldeep Sen', 'Rajasthan Royals', 'Bowler', 'BOWL', 'BOWL', 'C', 59, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/14336/kuldeep-sen', 12.0, NULL, NULL, NULL, 14.0, 9.63, 27.64, NULL, NULL, NULL, 36, 12.0, 45.0, 79.0, NULL, NULL, NULL),
('e4787495-874f-4c18-8d27-33bfb22d6177', 154, 'Nuwan Thushara', 'Royal Challengers Bengaluru', 'Bowler', 'BOWL', 'BOWL', 'C', 56, 'OVERSEAS', 'Sri Lankan', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/18509/nuwan-thushara', 8.0, NULL, NULL, NULL, 9.0, 9.43, 31.44, NULL, NULL, NULL, 34, 9.0, 49.0, 71.0, NULL, NULL, NULL),
('02e8442a-02f8-4fec-85f1-dba5e9c919a4', 65, 'Tilak Varma', 'Mumbai Indians', 'Batsman', 'BAT', 'BAT_WK', 'B', 72, 'INDIAN', 'Indian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/14504/tilak-varma', 54.0, 1499.0, 144.42, 37.48, NULL, NULL, NULL, 31.0, 74.0, 93.0, 57, NULL, NULL, NULL, NULL, NULL, NULL),
('56cfb166-1157-4ad9-982d-f68702a6564b', 1, 'Virat Kohli', 'Royal Challengers Bengaluru', 'Batsman', 'BAT', 'BAT_WK', 'A', 99, 'INDIAN', 'Indian', 2, false, NULL, NULL, 10, 'https://www.cricbuzz.com/profiles/1413/virat-kohli', 267.0, 8661.0, 132.86, 39.55, NULL, NULL, NULL, 99.0, 67.0, 98.0, 99, NULL, NULL, NULL, NULL, NULL, NULL),
('7d1450b8-8462-4f7f-9c3f-b1eae2b4c2da', 50, 'Mitchell Marsh', 'Lucknow Super Giants', 'Batting Allrounder', 'AR', 'AR', 'B', 74, 'OVERSEAS', 'Australian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/6250/mitchell-marsh', 55.0, 1292.0, NULL, NULL, 37.0, NULL, NULL, NULL, NULL, NULL, 57, NULL, NULL, NULL, 72.0, 43.0, 43.0),
('dbb25dfe-ef9e-4fc5-a741-d52c5ca67817', 39, 'Nicholas Pooran', 'Lucknow Super Giants', 'WK-Batsman', 'WK', 'BAT_WK', 'B', 78, 'OVERSEAS', 'West Indian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/9406/nicholas-pooran', 90.0, 2293.0, 168.98, 34.22, NULL, NULL, NULL, 46.0, 91.0, 85.0, 75, NULL, NULL, NULL, NULL, NULL, NULL),
('51d33340-b25a-4818-86f5-3312c5a3476b', 75, 'Karun Nair', 'Delhi Capitals', 'Batsman', 'BAT', 'BAT_WK', 'B', 70, 'INDIAN', 'Indian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/8257/karun-nair', 84.0, 1694.0, 131.73, 23.86, NULL, NULL, NULL, 35.0, 66.0, 60.0, 72, NULL, NULL, NULL, NULL, NULL, NULL),
('d9066687-e9bf-4316-961d-abddfb7b63cf', 128, 'Yash Thakur', 'Punjab Kings', 'Bowler', 'BOWL', 'BOWL', 'C', 61, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/12096/yash-thakur', 21.0, NULL, NULL, NULL, 25.0, 10.43, 30.8, NULL, NULL, NULL, 40, 20.0, 32.0, 72.0, NULL, NULL, NULL),
('ba9bb094-baf8-4372-983e-c3aa6fad55dd', 64, 'Shreyas Gopal', 'Chennai Super Kings', 'Bowler', 'BOWL', 'BOWL', 'B', 72, 'INDIAN', 'Indian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/9746/shreyas-gopal', 52.0, NULL, NULL, NULL, 52.0, 8.16, 25.92, NULL, NULL, NULL, 56, 37.0, 69.0, 83.0, NULL, NULL, NULL),
('731281d4-a30a-4b7e-bdbf-62700a17152f', 10, 'Harshal Patel', 'Sunrisers Hyderabad', 'Bowler', 'BOWL', 'BOWL', 'A', 94, 'INDIAN', 'Indian', 2, false, NULL, NULL, 6, 'https://www.cricbuzz.com/profiles/8175/harshal-patel', 119.0, NULL, NULL, NULL, 151.0, 8.86, 23.7, NULL, NULL, NULL, 89, 99.0, 58.0, 87.0, NULL, NULL, NULL),
('b6e19898-5169-4509-b861-2299680a56a4', 57, 'Jofra Archer', 'Rajasthan Royals', 'Bowler', 'BOWL', 'BOWL', 'B', 73, 'OVERSEAS', 'English', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/11540/jofra-archer', 52.0, NULL, NULL, NULL, 59.0, 7.89, 27.15, NULL, NULL, NULL, 56, 41.0, 74.0, 80.0, NULL, NULL, NULL),
('ecabec1d-3e96-42ce-8fa8-a59d82588bd9', 149, 'Glenn Phillips', 'Gujarat Titans', 'Batting Allrounder', 'AR', 'AR', 'C', 56, 'OVERSEAS', 'New Zealander', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/10693/glenn-phillips', 8.0, 65.0, NULL, NULL, 2.0, NULL, NULL, NULL, NULL, NULL, 34, NULL, NULL, NULL, 24.0, 34.0, 24.0),
('d900dc2e-e4c8-467b-ad5c-49921724f7f8', 112, 'Nitish Kumar Reddy', 'Sunrisers Hyderabad', 'Batting Allrounder', 'AR', 'AR', 'C', 62, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/14701/nitish-kumar-reddy', 28.0, 485.0, NULL, NULL, 5.0, NULL, NULL, NULL, NULL, NULL, 44, NULL, NULL, NULL, 50.0, 14.0, 14.0),
('c7a95a9f-385c-4062-845a-eb4a4b86a2e1', 46, 'Avesh Khan', 'Lucknow Super Giants', 'Bowler', 'BOWL', 'BOWL', 'B', 76, 'INDIAN', 'Indian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/9781/avesh-khan', 75.0, NULL, NULL, NULL, 87.0, 9.12, 28.29, NULL, NULL, NULL, 67, 60.0, 54.0, 77.0, NULL, NULL, NULL),
('9e0716a8-e4ba-408a-8b2a-2db97f667c85', 96, 'Vaibhav Arora', 'Kolkata Knight Riders', 'Bowler', 'BOWL', 'BOWL', 'C', 66, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/15861/vaibhav-arora', 32.0, NULL, NULL, NULL, 36.0, 9.55, 28.22, NULL, NULL, NULL, 46, 27.0, 47.0, 78.0, NULL, NULL, NULL),
('94111560-fd49-4cf4-ade6-00d6a2477308', 13, 'Axar Patel', 'Delhi Capitals', 'Bowling Allrounder', 'AR', 'AR', 'A', 91, 'INDIAN', 'Indian', 2, false, NULL, NULL, 6, 'https://www.cricbuzz.com/profiles/8808/axar-patel', 162.0, 1916.0, NULL, NULL, 128.0, NULL, NULL, NULL, NULL, NULL, 99, NULL, NULL, NULL, 82.0, 72.0, 72.0),
('ba146c89-1bdf-4c62-ae81-9b8dbca223a2', 28, 'Kuldeep Yadav', 'Delhi Capitals', 'Bowler', 'BOWL', 'BOWL', 'B', 83, 'INDIAN', 'Indian', 1, false, NULL, NULL, 2, 'https://www.cricbuzz.com/profiles/8292/kuldeep-yadav', 98.0, NULL, NULL, NULL, 102.0, 8.04, 26.95, NULL, NULL, NULL, 79, 69.0, 71.0, 80.0, NULL, NULL, NULL),
('a3b648aa-0a37-48b6-944c-b8a3885a98dd', 117, 'Dewald Brevis', 'Chennai Super Kings', 'Batsman', 'BAT', 'BAT_WK', 'C', 62, 'OVERSEAS', 'South African', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/20538/dewald-brevis', 16.0, 455.0, 153.2, 28.44, NULL, NULL, NULL, 12.0, 80.0, 71.0, 38, NULL, NULL, NULL, NULL, NULL, NULL),
('876e592e-f303-47d3-b362-967f510a6609', 61, 'Travis Head', 'Sunrisers Hyderabad', 'Batsman', 'BAT', 'BAT_WK', 'B', 72, 'OVERSEAS', 'Australian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/8497/travis-head', 38.0, 1146.0, 170.03, 34.73, NULL, NULL, NULL, 25.0, 92.0, 86.0, 49, NULL, NULL, NULL, NULL, NULL, NULL),
('97b74711-6dd7-4243-a32a-c370794ff449', 41, 'Nitish Rana', 'Delhi Capitals', 'Batsman', 'BAT', 'BAT_WK', 'B', 77, 'INDIAN', 'Indian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/9204/nitish-rana', 118.0, 2853.0, 136.77, 27.7, NULL, NULL, NULL, 56.0, 69.0, 69.0, 89, NULL, NULL, NULL, NULL, NULL, NULL),
('75fd9914-35ac-415d-8dd0-5fb382b5874a', 105, 'Mukesh Kumar', 'Delhi Capitals', 'Bowler', 'BOWL', 'BOWL', 'C', 64, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/10754/mukesh-kumar', 32.0, NULL, NULL, NULL, 36.0, 10.4, 30.61, NULL, NULL, NULL, 46, 27.0, 33.0, 73.0, NULL, NULL, NULL),
('a51a7b7a-db25-4714-8108-38acbabad237', 108, 'Rovman Powell', 'Kolkata Knight Riders', 'Batsman', 'BAT', 'BAT_WK', 'C', 63, 'OVERSEAS', 'West Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/11445/rovman-powell', 28.0, 365.0, 146.59, 18.25, NULL, NULL, NULL, 11.0, 76.0, 46.0, 44, NULL, NULL, NULL, NULL, NULL, NULL),
('9ca2716c-708c-45f5-bc4c-719bbf6e7168', 35, 'Deepak Chahar', 'Mumbai Indians', 'Bowler', 'BOWL', 'BOWL', 'B', 78, 'INDIAN', 'Indian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/7836/deepak-chahar', 95.0, NULL, NULL, NULL, 88.0, 8.14, 29.51, NULL, NULL, NULL, 77, 60.0, 70.0, 75.0, NULL, NULL, NULL),
('1bf41e62-3c3f-46ec-9510-81acaae7551e', 52, 'Rahul Tripathi', 'Kolkata Knight Riders', 'Batsman', 'BAT', 'BAT_WK', 'B', 74, 'INDIAN', 'Indian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/9012/rahul-tripathi', 100.0, 2291.0, 137.85, 26.03, NULL, NULL, NULL, 46.0, 70.0, 65.0, 80, NULL, NULL, NULL, NULL, NULL, NULL),
('83e47ae7-f7cf-4858-905c-700fed6c4ff6', 29, 'Mohammed Siraj', 'Gujarat Titans', 'Bowler', 'BOWL', 'BOWL', 'B', 83, 'INDIAN', 'Indian', 1, false, NULL, NULL, 2, 'https://www.cricbuzz.com/profiles/10808/mohammed-siraj', 108.0, NULL, NULL, NULL, 109.0, 8.74, 30.72, NULL, NULL, NULL, 84, 74.0, 60.0, 72.0, NULL, NULL, NULL),
('d5c71630-31d3-4b80-9ec5-b92fc339de03', 144, 'Vijaykumar Vyshak', 'Punjab Kings', 'Bowler', 'BOWL', 'BOWL', 'C', 57, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/10486/vijaykumar-vyshak', 16.0, NULL, NULL, NULL, 17.0, 10.38, 33.88, NULL, NULL, NULL, 38, 14.0, 33.0, 66.0, NULL, NULL, NULL),
('3a4817e7-ab45-4131-ad0e-ce357868187b', 37, 'Ishan Kishan', 'Sunrisers Hyderabad', 'WK-Batsman', 'WK', 'BAT_WK', 'B', 78, 'INDIAN', 'Indian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/10276/ishan-kishan', 119.0, 2998.0, 137.65, 29.11, NULL, NULL, NULL, 58.0, 70.0, 72.0, 89, NULL, NULL, NULL, NULL, NULL, NULL),
('2fec83be-492a-4844-8873-2c75e4ca4adb', 119, 'Wanindu Hasaranga', 'Lucknow Super Giants', 'Bowling Allrounder', 'AR', 'AR', 'C', 62, 'OVERSEAS', 'Sri Lankan', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/10926/wanindu-hasaranga', 37.0, 81.0, NULL, NULL, 46.0, NULL, NULL, NULL, NULL, NULL, 48, NULL, NULL, NULL, 15.0, 45.0, 15.0),
('db3540b4-1f02-4ea0-b599-4af9c0c78fc8', 99, 'Yash Dayal', 'Royal Challengers Bengaluru', 'Bowler', 'BOWL', 'BOWL', 'C', 66, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/14172/yash-dayal', 43.0, NULL, NULL, NULL, 41.0, 9.58, 33.9, NULL, NULL, NULL, 51, 30.0, 46.0, 66.0, NULL, NULL, NULL),
('99a4539b-98a8-477e-b98c-d44b04d65309', 11, 'Sandeep Sharma', 'Rajasthan Royals', 'Bowler', 'BOWL', 'BOWL', 'A', 93, 'INDIAN', 'Indian', 2, false, NULL, NULL, 4, 'https://www.cricbuzz.com/profiles/8356/sandeep-sharma', 136.0, NULL, NULL, NULL, 146.0, 8.03, 27.88, NULL, NULL, NULL, 98, 98.0, 71.0, 78.0, NULL, NULL, NULL),
('51a2df8a-3af7-4c5a-bb98-5328e89b7896', 109, 'Abdul Samad', 'Lucknow Super Giants', 'Batting Allrounder', 'AR', 'AR', 'C', 63, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/14628/abdul-samad', 63.0, 741.0, NULL, NULL, 2.0, NULL, NULL, NULL, NULL, NULL, 61, NULL, NULL, NULL, 57.0, 5.0, 5.0),
('a652c24c-fab3-49e4-9615-7cd0f208f664', 148, 'Vignesh Puthur', 'Rajasthan Royals', 'Bowler', 'BOWL', 'BOWL', 'C', 57, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/1447337/vignesh-puthur', 5.0, NULL, NULL, NULL, 6.0, 9.08, 18.17, NULL, NULL, NULL, 32, 7.0, 54.0, 99.0, NULL, NULL, NULL),
('32b02c5e-58d2-4ef8-83ba-b588bc634a13', 15, 'Sanju Samson', 'Chennai Super Kings', 'WK-Batsman', 'WK', 'BAT_WK', 'A', 89, 'INDIAN', 'Indian', 2, false, NULL, NULL, 2, 'https://www.cricbuzz.com/profiles/8271/sanju-samson', 176.0, 4704.0, 139.05, 30.75, NULL, NULL, NULL, 89.0, 71.0, 76.0, 99, NULL, NULL, NULL, NULL, NULL, NULL),
('f451adf4-37fc-453b-9f5a-d91a4bbf7e5d', 30, 'Rishabh Pant', 'Lucknow Super Giants', 'WK-Batsman', 'WK', 'BAT_WK', 'B', 82, 'INDIAN', 'Indian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/10744/rishabh-pant', 125.0, 3553.0, 147.62, 34.16, NULL, NULL, NULL, 68.0, 76.0, 85.0, 92, NULL, NULL, NULL, NULL, NULL, NULL),
('327d3254-8501-4c8f-a7a9-bcfe7e52079c', 127, 'Digvesh Singh Rathi', 'Lucknow Super Giants', 'Bowler', 'BOWL', 'BOWL', 'C', 61, 'INDIAN', 'Indian', 0.5, true, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/1448289/digvesh-singh-rathi', 13.0, NULL, NULL, NULL, 14.0, 8.25, 30.64, NULL, NULL, NULL, 36, 12.0, 68.0, 72.0, NULL, NULL, NULL),
('a2d2f4ae-03ca-4f51-8bfa-f16b49297ff5', 12, 'Trent Boult', 'Mumbai Indians', 'Bowler', 'BOWL', 'BOWL', 'A', 92, 'OVERSEAS', 'New Zealander', 2, false, NULL, NULL, 4, 'https://www.cricbuzz.com/profiles/8117/trent-boult', 119.0, NULL, NULL, NULL, 143.0, 8.38, 26.2, NULL, NULL, NULL, 89, 96.0, 66.0, 82.0, NULL, NULL, NULL),
('ab0d4750-8350-4aaf-8da1-5d95e05576d6', 62, 'Shimron Hetmyer', 'Rajasthan Royals', 'Batsman', 'BAT', 'BAT_WK', 'B', 72, 'OVERSEAS', 'West Indian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/9789/shimron-hetmyer', 86.0, 1482.0, 151.85, 29.06, NULL, NULL, NULL, 31.0, 79.0, 72.0, 73, NULL, NULL, NULL, NULL, NULL, NULL),
('ec4bdc79-9985-44f8-b458-47b0f3767da2', 17, 'Mohammed Shami', 'Lucknow Super Giants', 'Bowler', 'BOWL', 'BOWL', 'A', 89, 'INDIAN', 'Indian', 2, false, NULL, NULL, 4, 'https://www.cricbuzz.com/profiles/7909/mohammed-shami', 119.0, NULL, NULL, NULL, 133.0, 8.63, 28.18, NULL, NULL, NULL, 89, 89.0, 62.0, 78.0, NULL, NULL, NULL),
('dd369e38-a008-4687-9397-ce9c69528b31', 156, 'Matthew Short', 'Chennai Super Kings', 'Batsman', 'BAT', 'BAT_WK', 'C', 55, 'OVERSEAS', 'Australian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/9456/matthew-short', 6.0, 117.0, 127.18, 19.5, NULL, NULL, NULL, 6.0, 63.0, 49.0, 33, NULL, NULL, NULL, NULL, NULL, NULL),
('fd10a28e-6052-4319-b3a0-8acb6dd7ccde', 5, 'Bhuvneshwar Kumar', 'Royal Challengers Bengaluru', 'Bowler', 'BOWL', 'BOWL', 'A', 98, 'INDIAN', 'Indian', 2, false, NULL, NULL, 8, 'https://www.cricbuzz.com/profiles/1726/bhuvneshwar-kumar', 190.0, NULL, NULL, NULL, 198.0, 7.69, 27.33, NULL, NULL, NULL, 99, 99.0, 77.0, 80.0, NULL, NULL, NULL),
('a28fd532-9697-4791-b0a5-1f62575503d9', 84, 'Cameron Green', 'Kolkata Knight Riders', 'Batting Allrounder', 'AR', 'AR', 'C', 68, 'OVERSEAS', 'Australian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/12225/cameron-green', 29.0, 707.0, NULL, NULL, 16.0, NULL, NULL, NULL, NULL, NULL, 44, NULL, NULL, NULL, 64.0, 27.0, 27.0),
('fed3d22d-93dc-4955-b43e-d25d5cba49e9', 21, 'Krunal Pandya', 'Royal Challengers Bengaluru', 'Batting Allrounder', 'AR', 'AR', 'A', 86, 'INDIAN', 'Indian', 2, false, NULL, NULL, 4, 'https://www.cricbuzz.com/profiles/11311/krunal-pandya', 142.0, 1748.0, NULL, NULL, 93.0, NULL, NULL, NULL, NULL, NULL, 99, NULL, NULL, NULL, 77.0, 60.0, 60.0),
('857d266e-8c94-48a2-83be-b0e4924ba8ed', 150, 'Adam Milne', 'Rajasthan Royals', 'Bowler', 'BOWL', 'BOWL', 'C', 56, 'OVERSEAS', 'New Zealander', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/7625/adam-milne', 10.0, NULL, NULL, NULL, 7.0, 9.48, 46.71, NULL, NULL, NULL, 35, 8.0, 48.0, 38.0, NULL, NULL, NULL),
('2ee108f6-4887-4db7-9884-cea846e857f2', 42, 'Ruturaj Gaikwad', 'Chennai Super Kings', 'Batsman', 'BAT', 'BAT_WK', 'B', 77, 'INDIAN', 'Indian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/11813/ruturaj-gaikwad', 71.0, 2502.0, 137.48, 40.35, NULL, NULL, NULL, 49.0, 70.0, 99.0, 65, NULL, NULL, NULL, NULL, NULL, NULL),
('cc33c633-9fd0-466c-a318-7fdbdb562a04', 89, 'Dhruv Jurel', 'Rajasthan Royals', 'WK-Batsman', 'WK', 'BAT_WK', 'C', 67, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/14691/dhruv-jurel', 41.0, 680.0, 153.85, 28.33, NULL, NULL, NULL, 16.0, 81.0, 71.0, 50, NULL, NULL, NULL, NULL, NULL, NULL),
('2f1988c9-a84a-4c99-a918-7cc47f5999dc', 25, 'Marcus Stoinis', 'Punjab Kings', 'Batting Allrounder', 'AR', 'AR', 'B', 83, 'OVERSEAS', 'Australian', 1, false, NULL, NULL, 4, 'https://www.cricbuzz.com/profiles/8989/marcus-stoinis', 109.0, 2026.0, NULL, NULL, 44.0, NULL, NULL, NULL, NULL, NULL, 84, NULL, NULL, NULL, 90.0, 37.0, 37.0),
('3fac62b4-598e-452e-8a4f-b82c4f186d59', 34, 'Quinton de Kock', 'Mumbai Indians', 'WK-Batsman', 'WK', 'BAT_WK', 'B', 79, 'OVERSEAS', 'South African', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/8520/quinton-de-kock', 115.0, 3309.0, 134.03, 30.64, NULL, NULL, NULL, 64.0, 67.0, 76.0, 87, NULL, NULL, NULL, NULL, NULL, NULL),
('d18d4f24-dd22-442d-8899-1f72baeb0286', 90, 'Naman Dhir', 'Mumbai Indians', 'Batsman', 'BAT', 'BAT_WK', 'C', 67, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/36139/naman-dhir', 23.0, 392.0, 180.65, 28.0, NULL, NULL, NULL, 11.0, 99.0, 70.0, 41, NULL, NULL, NULL, NULL, NULL, NULL),
('51d500f7-1a2a-4194-803a-04cf8437a3d7', 2, 'Yuzvendra Chahal', 'Punjab Kings', 'Bowler', 'BOWL', 'BOWL', 'A', 99, 'INDIAN', 'Indian', 2, false, NULL, NULL, 10, 'https://www.cricbuzz.com/profiles/7910/yuzvendra-chahal', 174.0, NULL, NULL, NULL, 221.0, 7.96, 22.77, NULL, NULL, NULL, 99, 99.0, 73.0, 89.0, NULL, NULL, NULL),
('99d15775-751d-4663-b92c-9cfd61f926f6', 56, 'Josh Hazlewood', 'Royal Challengers Bengaluru', 'Bowler', 'BOWL', 'BOWL', 'B', 73, 'OVERSEAS', 'Australian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/6258/josh-hazlewood', 39.0, NULL, NULL, NULL, 57.0, 8.28, 20.98, NULL, NULL, NULL, 49, 40.0, 67.0, 93.0, NULL, NULL, NULL),
('3cb6a524-ab11-4001-b407-646b82839dff', 6, 'Rohit Sharma', 'Mumbai Indians', 'Batsman', 'BAT', 'BAT_WK', 'A', 96, 'INDIAN', 'Indian', 2, false, NULL, NULL, 8, 'https://www.cricbuzz.com/profiles/576/rohit-sharma', 272.0, 7046.0, 132.1, 29.73, NULL, NULL, NULL, 99.0, 66.0, 74.0, 99, NULL, NULL, NULL, NULL, NULL, NULL),
('3da2f8b8-cf18-4a6e-9cc0-00ec3e6eaf60', 113, 'Marco Jansen', 'Punjab Kings', 'Bowling Allrounder', 'AR', 'AR', 'C', 62, 'OVERSEAS', 'South African', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/14565/marco-jansen', 35.0, 141.0, NULL, NULL, 36.0, NULL, NULL, NULL, NULL, NULL, 47, NULL, NULL, NULL, 26.0, 36.0, 26.0),
('54ab5b86-dc9e-4340-89f7-ba38c1f67d11', 7, 'Ravindra Jadeja', 'Rajasthan Royals', 'Bowling Allrounder', 'AR', 'AR', 'A', 95, 'INDIAN', 'Indian', 2, false, NULL, NULL, 8, 'https://www.cricbuzz.com/profiles/587/ravindra-jadeja', 254.0, 3260.0, NULL, NULL, 170.0, NULL, NULL, NULL, NULL, NULL, 99, NULL, NULL, NULL, 85.0, 78.0, 78.0),
('48c5456d-efe5-47cc-a272-6c277b169a28', 151, 'Dushmantha Chameera', 'Delhi Capitals', 'Bowler', 'BOWL', 'BOWL', 'C', 56, 'OVERSEAS', 'Sri Lankan', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/8393/dushmantha-chameera', 19.0, NULL, NULL, NULL, 13.0, 9.73, 46.38, NULL, NULL, NULL, 39, 12.0, 44.0, 39.0, NULL, NULL, NULL),
('46751dbf-d637-455d-8202-5bc7dce9b4f3', 20, 'Jos Buttler', 'Gujarat Titans', 'WK-Batsman', 'WK', 'BAT_WK', 'A', 88, 'OVERSEAS', 'English', 2, false, NULL, NULL, 2, 'https://www.cricbuzz.com/profiles/2258/jos-buttler', 121.0, 4120.0, 149.39, 40.0, NULL, NULL, NULL, 79.0, 78.0, 99.0, 90, NULL, NULL, NULL, NULL, NULL, NULL),
('0821d612-0acb-4897-8769-5c60dd01c83e', 146, 'Anshul Kamboj', 'Chennai Super Kings', 'Bowling Allrounder', 'AR', 'AR', 'C', 57, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/14598/anshul-kamboj', 11.0, 16.0, NULL, NULL, 10.0, NULL, NULL, NULL, NULL, NULL, 35, NULL, NULL, NULL, 21.0, 30.0, 21.0),
('04b2d6c5-40ed-42ef-9b80-c7b61aa3fdcf', 49, 'Ravi Bishnoi', 'Rajasthan Royals', 'Bowler', 'BOWL', 'BOWL', 'B', 75, 'INDIAN', 'Indian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/14659/ravi-bishnoi', 77.0, NULL, NULL, NULL, 72.0, 8.22, 31.07, NULL, NULL, NULL, 68, 50.0, 68.0, 72.0, NULL, NULL, NULL),
('0978f850-1d98-4c25-91e9-9d394593e2d7', 18, 'Rashid Khan', 'Gujarat Titans', 'Bowling Allrounder', 'AR', 'AR', 'A', 89, 'OVERSEAS', 'Afghan', 2, false, NULL, NULL, 8, 'https://www.cricbuzz.com/profiles/10738/rashid-khan', 136.0, 585.0, NULL, NULL, 158.0, NULL, NULL, NULL, NULL, NULL, 98, NULL, NULL, NULL, 51.0, 82.0, 51.0),
('bf269d4e-7807-491f-b4f5-a1335223acdc', 153, 'Urvil Patel', 'Chennai Super Kings', 'WK-Batsman', 'WK', 'BAT_WK', 'C', 56, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/13476/urvil-patel', 3.0, 68.0, 212.5, 22.67, NULL, NULL, NULL, 5.0, 99.0, 57.0, 31, NULL, NULL, NULL, NULL, NULL, NULL),
('929447ea-2130-469a-acd1-a4c0bef37fb5', 4, 'Sunil Narine', 'Kolkata Knight Riders', 'Bowling Allrounder', 'AR', 'AR', 'A', 98, 'OVERSEAS', 'West Indian', 2, false, NULL, NULL, 10, 'https://www.cricbuzz.com/profiles/2276/sunil-narine', 188.0, 1780.0, NULL, NULL, 192.0, NULL, NULL, NULL, NULL, NULL, 99, NULL, NULL, NULL, 84.0, 83.0, 83.0),
('232d9d57-500f-4323-a696-dbbb7bf29c16', 45, 'Shivam Dube', 'Chennai Super Kings', 'Batting Allrounder', 'AR', 'AR', 'B', 76, 'INDIAN', 'Indian', 1, false, NULL, NULL, 2, 'https://www.cricbuzz.com/profiles/11195/shivam-dube', 79.0, 1859.0, NULL, NULL, 5.0, NULL, NULL, NULL, NULL, NULL, 69, NULL, NULL, NULL, 88.0, 20.0, 20.0),
('6b809c21-ce4f-4e07-b793-f40f7251bec1', 103, 'Priyansh Arya', 'Punjab Kings', 'Batsman', 'BAT', 'BAT_WK', 'C', 64, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/14689/priyansh-arya', 17.0, 475.0, 179.25, 27.94, NULL, NULL, NULL, 13.0, 98.0, 70.0, 38, NULL, NULL, NULL, NULL, NULL, NULL),
('0c6f345a-6102-47f0-bd0c-0b13d4d5fe0e', 152, 'Anukul Roy', 'Kolkata Knight Riders', 'Batting Allrounder', 'AR', 'AR', 'C', 56, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/12344/anukul-roy', 11.0, 26.0, NULL, NULL, 6.0, NULL, NULL, NULL, NULL, NULL, 35, NULL, NULL, NULL, 17.0, 29.0, 17.0),
('d273dbb9-36a3-45ed-8b5b-3c2afe86b45b', 23, 'Shubman Gill', 'Gujarat Titans', 'Batsman', 'BAT', 'BAT_WK', 'B', 84, 'INDIAN', 'Indian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/11808/shubman-gill', 118.0, 3866.0, 138.72, 39.45, NULL, NULL, NULL, 74.0, 70.0, 98.0, 89, NULL, NULL, NULL, NULL, NULL, NULL),
('03c13afa-a67e-40d9-a8c3-756631b2e44a', 134, 'Vipraj Nigam', 'Delhi Capitals', 'Bowler', 'BOWL', 'BOWL', 'C', 59, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/1431811/vipraj-nigam', 14.0, NULL, NULL, NULL, 11.0, 9.13, 32.36, NULL, NULL, NULL, 37, 10.0, 54.0, 69.0, NULL, NULL, NULL),
('47b61db2-0f05-4991-a2dc-1b4bbe3271db', 107, 'Shahbaz Ahmed', 'Lucknow Super Giants', 'Bowling Allrounder', 'AR', 'AR', 'C', 64, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/14606/shahbaz-ahmed', 58.0, 545.0, NULL, NULL, 22.0, NULL, NULL, NULL, NULL, NULL, 59, NULL, NULL, NULL, 43.0, 27.0, 27.0),
('9acceac4-e5ba-46f2-80f7-10f4b80c37c9', 8, 'MS Dhoni', 'Chennai Super Kings', 'WK-Batsman', 'WK', 'BAT_WK', 'A', 95, 'INDIAN', 'Indian', 2, false, NULL, NULL, 4, 'https://www.cricbuzz.com/profiles/265/ms-dhoni', 278.0, 5439.0, 137.46, 38.3, NULL, NULL, NULL, 99.0, 70.0, 95.0, 99, NULL, NULL, NULL, NULL, NULL, NULL),
('3f9edd79-7c3f-4191-b0eb-56114a8c1c7b', 26, 'Jaydev Unadkat', 'Sunrisers Hyderabad', 'Bowler', 'BOWL', 'BOWL', 'B', 83, 'INDIAN', 'Indian', 1, false, NULL, NULL, 2, 'https://www.cricbuzz.com/profiles/6327/jaydev-unadkat', 112.0, NULL, NULL, NULL, 110.0, 8.88, 30.58, NULL, NULL, NULL, 86, 74.0, 58.0, 73.0, NULL, NULL, NULL),
('7edbd5ed-c74b-441c-94c6-91a17d110b15', 3, 'Jasprit Bumrah', 'Mumbai Indians', 'Bowler', 'BOWL', 'BOWL', 'A', 99, 'INDIAN', 'Indian', 2, false, NULL, NULL, 8, 'https://www.cricbuzz.com/profiles/9311/jasprit-bumrah', 145.0, NULL, NULL, NULL, 183.0, 7.25, 22.03, NULL, NULL, NULL, 99, 99.0, 84.0, 91.0, NULL, NULL, NULL),
('0a09ea24-5377-49cc-ae3b-642755d95828', 53, 'Prasidh Krishna', 'Gujarat Titans', 'Bowler', 'BOWL', 'BOWL', 'B', 74, 'INDIAN', 'Indian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/10551/prasidh-krishna', 66.0, NULL, NULL, NULL, 74.0, 8.77, 29.61, NULL, NULL, NULL, 63, 51.0, 59.0, 75.0, NULL, NULL, NULL),
('4c7883c6-90e3-437e-8c21-94a2965e3086', 136, 'Arshad Khan', 'Gujarat Titans', 'Bowling Allrounder', 'AR', 'AR', 'C', 58, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/18637/arshad-khan', 19.0, 124.0, NULL, NULL, 12.0, NULL, NULL, NULL, NULL, NULL, 39, NULL, NULL, NULL, 39.0, 18.0, 18.0),
('6f3e8fe9-6098-4706-ace0-af35cdf38e7c', 9, 'KL Rahul', 'Delhi Capitals', 'WK-Batsman', 'WK', 'BAT_WK', 'A', 95, 'INDIAN', 'Indian', 2, false, NULL, NULL, 4, 'https://www.cricbuzz.com/profiles/8733/kl-rahul', 145.0, 5222.0, 136.03, 46.21, NULL, NULL, NULL, 99.0, 69.0, 99.0, 99, NULL, NULL, NULL, NULL, NULL, NULL),
('993fb58d-4d7a-4479-843f-30d50d988009', 54, 'Heinrich Klaasen', 'Sunrisers Hyderabad', 'WK-Batsman', 'WK', 'BAT_WK', 'B', 74, 'OVERSEAS', 'South African', 1, true, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/10209/heinrich-klaasen', 49.0, 1480.0, 169.73, 40.0, NULL, NULL, NULL, 31.0, 91.0, 99.0, 54, NULL, NULL, NULL, NULL, NULL, NULL),
('ff441c7d-68e5-44e3-94c0-23eabfa900df', 22, 'Kagiso Rabada', 'Gujarat Titans', 'Bowler', 'BOWL', 'BOWL', 'A', 85, 'OVERSEAS', 'South African', 2, false, NULL, NULL, 2, 'https://www.cricbuzz.com/profiles/9585/kagiso-rabada', 84.0, NULL, NULL, NULL, 119.0, 8.62, 22.96, NULL, NULL, NULL, 72, 80.0, 62.0, 89.0, NULL, NULL, NULL),
('9efcdb0f-9484-4b18-8116-48cf04711dba', 91, 'Shahrukh Khan', 'Gujarat Titans', 'Batting Allrounder', 'AR', 'AR', 'C', 67, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/10226/shahrukh-khan', 55.0, 732.0, NULL, NULL, 1.0, NULL, NULL, NULL, NULL, NULL, 57, NULL, NULL, NULL, 56.0, 27.0, 27.0);

INSERT INTO "AuctionPlayer" (id, player_id, status) VALUES
('b42b59e0-5e87-4eef-865f-c7ad5834074b', '8d318ddc-4e0a-4073-b729-f04102a552f9', 'UNSOLD'),
('137b703f-29ab-4f9d-a279-dbe9aaa04579', 'd17be77a-5c81-4612-96b6-5f53f0607cf1', 'UNSOLD'),
('bef6ef90-a737-4c76-9cff-808a2291a20a', '2fcd743a-db88-4f7f-b5f9-998d02a8795a', 'UNSOLD'),
('f6c86c98-aeb0-4a9b-9a9a-ec5f759f7687', 'a1d844f2-317c-4b40-a7f7-f592ab59200c', 'UNSOLD'),
('bd877312-0c65-4f08-969c-e59be50fba33', '9aa9e4b9-d24f-4d38-bc1f-693c244a382f', 'UNSOLD'),
('1873fd2b-572d-42a3-8cff-18ba8650b1b0', 'c9be7f08-4e2c-453c-a882-b63698d3df4e', 'UNSOLD'),
('2cd51715-5816-40d4-8fdd-c3cc26d489b3', '68fcb5df-5f68-4967-ba85-823fce59f5af', 'UNSOLD'),
('df4fd4e0-7b4d-473c-b41a-a32a8140a254', 'f20c41c0-75f0-4502-8926-b1178c5dd019', 'UNSOLD'),
('171952a5-2c73-4184-a381-38a258c65c5d', '6f89b332-5f5c-482c-9bcd-11d833d0c741', 'UNSOLD'),
('64c623eb-558d-4c08-b34f-432a5fed4c6c', '7865c5fc-9884-4325-b8fa-70f89dead846', 'UNSOLD'),
('8850f247-5653-4f85-b015-7252ff67069a', '0fc769a9-07e9-4fa5-a9e8-d833003e7b8c', 'UNSOLD'),
('d3710931-c271-4bbb-a6c0-1a7cd0854a31', '325214ec-1edb-4683-b75e-48073e65d702', 'UNSOLD'),
('195fb5c9-89ec-40b7-afd0-2e9cb36dcdb2', 'e4f61daf-99d3-4d82-8e9b-d076216fd8ae', 'UNSOLD'),
('6a998120-1e0b-4270-ac0f-299c69d4f3f5', 'ed9249e7-e70c-44a2-8ad3-7ff40890d262', 'UNSOLD'),
('96dab3bd-26f3-4889-8cbb-0f026b5b233e', '9fae6059-2fae-4571-88fc-718e723d45f0', 'UNSOLD'),
('df9aefc8-49ee-4a4b-b852-832de3e30131', 'e0f0a8f8-040e-4456-b996-599fec522222', 'UNSOLD'),
('b3ed30e3-c867-46c3-8e51-9999c3243275', '7e113640-6447-4607-919a-6aaf5990eb20', 'UNSOLD'),
('c4b19d54-a183-4638-94ef-6cefb31fffac', 'fe1f1179-7a96-4e26-b1df-6f571b8eac0e', 'UNSOLD'),
('9d77c9bd-af85-4e7e-8779-bfc2db7611f5', '6c59451d-7e00-4802-9476-ba4c327f3b50', 'UNSOLD'),
('edd83f9c-6962-4c8b-9932-5003137ae5a8', '4dbe8adc-43e6-4874-a86b-ca3b70c1f889', 'UNSOLD'),
('ecd3bd31-1e5e-4cda-b572-b357314633f0', '6cf1c007-456c-4f73-b81a-0cf047fe1bef', 'UNSOLD'),
('66c6c301-4c8a-45c2-9a95-45516b39223c', '58b972fd-dfab-4df4-a538-85b6ffc8b3af', 'UNSOLD'),
('777a4c0d-c5aa-42a9-ae8e-1bd2bb129afa', 'e9d03683-2581-48dc-b6af-514f5c59a5ef', 'UNSOLD'),
('584c8e7b-ee4d-4047-93b8-f9331e5a5229', '5024d56b-3332-4572-a622-29bc3e154a07', 'UNSOLD'),
('32fb1db2-cd14-4064-b148-dc348e1926fd', '46f45824-2515-44f1-9693-870b5eb86549', 'UNSOLD'),
('fedc6e27-488f-4766-82e5-c55cf1934082', '58dfffa9-ce49-4548-be60-db18898f991a', 'UNSOLD'),
('7ff230c2-b093-42f3-9054-cecfb5a34e31', 'a0be2249-60e6-4aa5-bd0c-13a05d931923', 'UNSOLD'),
('7fa4cf91-0e72-4d30-a469-edac2d1dc876', 'cab50594-cdeb-4643-afb7-54b9377b9263', 'UNSOLD'),
('3c79ab5f-224d-432c-98e0-5cf89f30258e', '186f3aed-1921-4a48-a6c7-2494e96b3fe8', 'UNSOLD'),
('b8b73566-cef7-42c7-8ae5-4f411ebe724e', 'cd6b5059-1b14-4569-b619-ec4138846386', 'UNSOLD'),
('a76ae734-d50f-413f-a2e6-133521577081', '6e40a385-9d34-40c5-b17c-9b8e0c27cf3a', 'UNSOLD'),
('0c92f5c5-9bcb-4223-a68f-854fc8afb408', 'b1896dd1-6ba7-4fd6-9628-ac1aaa2565a7', 'UNSOLD'),
('4ee8f934-7e37-4372-874a-c778ead2556b', 'bdaa8a80-a255-4943-aa78-e667f51d8bf2', 'UNSOLD'),
('ea224844-2f05-4974-867d-22b87ea4ce69', '4f659b22-9f57-4ed4-9cbc-09fe03182c0c', 'UNSOLD'),
('b42f20f1-08bc-4537-808b-e240c663e09c', '820fc955-aef3-452b-8fe1-81e5ed1df3e9', 'UNSOLD'),
('2e6bbf6f-7398-4ab4-9b47-f073895117fd', 'cdf868d8-6fcb-4fb8-9d6f-ecb8f00c1151', 'UNSOLD'),
('66643a1e-1740-48d2-9668-500a929cd8cc', 'f716783c-3894-4a86-a4b8-aa1e8023b0e5', 'UNSOLD'),
('d59c11b8-d38c-4f53-b6a4-4a698ace5ebb', 'aa6eee81-2645-4b0e-97e1-e1f47073e170', 'UNSOLD'),
('8860301e-fbc0-490a-88bd-c468e6705aa5', 'ce6ea39c-14f7-4d0a-afea-60d92d59fc5f', 'UNSOLD'),
('523fd23f-43d1-4e6e-99a2-fef35b175c21', '49906079-3acb-4b35-bcd7-153bf7fc086a', 'UNSOLD'),
('17000f9a-6cd5-417d-b2a9-4d3da3f0ed12', '988440aa-cd3e-44d2-96a4-245f212236c0', 'UNSOLD'),
('43d0120e-f8e3-47d1-b2c3-af597a13857b', '7a9edbfa-ccfe-4e3e-9e9f-173f6df800b1', 'UNSOLD'),
('ab490508-d5d5-495c-b2d1-be8f52d9e44b', 'be00467e-8341-473f-9267-d6781312bf6f', 'UNSOLD'),
('8d9d71d4-30b7-409d-b568-3aae05a15d98', '02eab9d5-fd45-462f-97f3-6ceed4819f5d', 'UNSOLD'),
('4ae481e5-6b5b-43cb-a323-aa848f7e1281', '84fa750e-ac13-4538-8901-db2fbc89dcb8', 'UNSOLD'),
('7c20b454-0296-4eaf-bf44-61e6e58228d0', 'ae8b5d64-449a-4d20-aa60-0dff9f8cf2cb', 'UNSOLD'),
('35ee5c4e-57bc-4b0b-9fb7-d2b7550ea7ac', '054f9b13-f4c5-4e94-ae9a-62b6acf09036', 'UNSOLD'),
('4f65cd15-bbcb-42da-b40f-7c0bbc6389d6', 'f9485725-afdc-4c7b-8a72-5a3ccfd62b4e', 'UNSOLD'),
('880610e4-24f1-460b-ae1d-7da12d71377e', '9706cf98-8127-4b94-8f0d-b669a3558d06', 'UNSOLD'),
('262fa0ab-a3ef-41ae-8971-6a872f14e4ab', '2332ad10-1ddb-459c-8bbc-a797f1dfe515', 'UNSOLD'),
('97c33ec1-a872-422d-b2f2-7ad98e2e7f72', 'e4934ee6-69ee-4c90-babe-1a3864128d8c', 'UNSOLD'),
('72e0d115-7631-4528-985c-46e621307e75', 'f0cbf40d-eda4-4392-8e9d-1a15a63a808c', 'UNSOLD'),
('bf288512-6817-451b-8687-09b3467d747e', 'ca5fa390-bcdb-4a83-a2f4-9bf983c05aee', 'UNSOLD'),
('4421b74c-e326-4bd9-9069-c8a00fe99e6d', '534a9eea-e433-4576-9686-dba93c290c3c', 'UNSOLD'),
('7e141bbd-9f1e-40f3-94aa-d9f40379eded', '2c228000-eea8-47e6-ac65-6f9172d5c877', 'UNSOLD'),
('1e9d91ad-2871-4b2a-9124-c43e62a5f2b4', '163488e1-a894-4bbd-89b6-b4ba2d717664', 'UNSOLD'),
('65965526-cda5-4a92-8083-333929e4d2c4', '71e7807b-40d3-496d-af3b-99dd8dc82066', 'UNSOLD'),
('d6fa2649-ea67-4499-b4dc-350219fe970b', '1861edbb-d2a8-45b1-bca5-9066aee709c1', 'UNSOLD'),
('e84d2daa-6d9e-4002-8bde-8bdd554abffd', 'c2ded8b0-f55a-466d-a920-ec708043e2c9', 'UNSOLD'),
('c05440ac-85b5-4beb-8223-13d672c8a1b2', '6b9d94b7-5e31-40ce-b866-13e3ff4f07bb', 'UNSOLD'),
('6b0673f1-1cb0-4073-974a-444211da286a', '45e27ed1-e747-4327-9f1c-dfa77ae8ae96', 'UNSOLD'),
('b4b16f2b-4154-4c40-b338-1c161b720bd3', '7d5f6098-a9ee-4286-b214-892bde0fa0e3', 'UNSOLD'),
('5e228778-b236-4232-a169-aaf45eb0cfc9', 'aa3e753f-8414-468c-b299-ff350926cf80', 'UNSOLD'),
('3ea5ec42-6951-4fab-8212-a935bdd23cab', '75f42b4b-54ee-442d-9985-afed195d3634', 'UNSOLD'),
('33301243-ec2f-4711-b135-34086e1fe3c1', '6e743407-8520-42de-bac1-7ec176814a74', 'UNSOLD'),
('20d0ed39-dc75-45d5-8585-abae3f017d7d', 'bf254bda-085e-4181-90ab-87c906fcfb76', 'UNSOLD'),
('b3c12f16-63d4-479e-b490-80723c2ea54f', 'd9a795e3-f7b3-4c90-ad83-d74eefcf2a9d', 'UNSOLD'),
('ca57a81b-7e6c-413e-b4ea-16d525b1c095', '6810d4a5-1de6-4e4d-a587-2fbc254dd990', 'UNSOLD'),
('fe5bbeca-13b1-40dd-a8b8-97416ef1224c', '35cb64c7-3d0f-402f-a4f6-2e17e78d3747', 'UNSOLD'),
('23002ca0-631b-46eb-bfa6-2933e34ebed4', '805dd354-2120-4498-a9b6-0fecbc2d4064', 'UNSOLD'),
('2b6d2c23-028b-41a2-8011-595ea14f5897', '9828d675-65a2-4eb8-96d1-7fcc60c2feef', 'UNSOLD'),
('0f4954a0-4b22-4776-a615-04a399bb6dfa', 'bc824693-99f5-4fff-9a96-cd5f6527cf16', 'UNSOLD'),
('4eb5f0d4-9ad4-4cbc-9a72-b994939d8133', '23e1afab-44d1-422d-b0c9-db8430895184', 'UNSOLD'),
('1caa59fe-1ffa-48f4-8d65-f94dc7e4bd13', '20ee9b46-b6d5-44f7-9e3b-8a850659b0f4', 'UNSOLD'),
('07db9a1e-58bc-4e85-99c0-38a19b8fcf5b', 'd81a4620-8e13-4350-90f7-9e23df05c59e', 'UNSOLD'),
('2e6693a3-82c2-4ae3-ab3f-6c912b350e45', 'f8863468-8891-4726-a4cb-e1488f03245e', 'UNSOLD'),
('9fb86c2f-f130-4c94-b4e1-3588f6b3444e', '49741b0d-904f-4c3b-b1af-078378ac824a', 'UNSOLD'),
('7666f5c9-0908-44bf-84b8-3dfb84e5bcc8', '920f1e66-ebbf-4485-8558-2f5adf9840a3', 'UNSOLD'),
('3ccda9aa-d108-428f-a39f-92763983ae8e', '78faf99b-731a-4694-a149-47f1c49cf507', 'UNSOLD'),
('6062ae1e-65c0-4376-aca1-d3f9a8215250', '72abba88-88ae-4838-b082-82469dbcd886', 'UNSOLD'),
('900b46e0-4bbc-4416-8262-b395f8d028b8', '56ba50f5-2699-412a-991f-73d293ceba84', 'UNSOLD'),
('b9211f77-11ef-43c3-a9fd-5feeb5053848', 'c53b9a46-1f0f-4f99-9794-b9621059499d', 'UNSOLD'),
('8270c9bd-0e63-41ef-a128-9d46fa0cb6b9', 'eb0ae01f-6a97-4810-b3cc-4f9eacb6cb50', 'UNSOLD'),
('2703cd86-060d-4ac5-9991-650194e3e742', 'd85243c7-50c7-4ab8-8e40-e8d1c1b9085d', 'UNSOLD'),
('40760040-2333-4a1f-8f45-9d1796eb0ff1', '70702806-efc8-4971-8fa7-85e1ebb5c106', 'UNSOLD'),
('8f5ec3ab-1eff-451c-8b90-909862795fa4', 'e4787495-874f-4c18-8d27-33bfb22d6177', 'UNSOLD'),
('53e72aad-ce10-4639-9ebf-ea4325b92781', '02e8442a-02f8-4fec-85f1-dba5e9c919a4', 'UNSOLD'),
('c72e9bd3-2ebb-4f2c-be15-bb75267b2f18', '56cfb166-1157-4ad9-982d-f68702a6564b', 'UNSOLD'),
('c1aacf74-4286-4870-9fce-a3f544161595', '7d1450b8-8462-4f7f-9c3f-b1eae2b4c2da', 'UNSOLD'),
('d66d2e8b-dc7c-4af5-b481-2526a293d8d9', 'dbb25dfe-ef9e-4fc5-a741-d52c5ca67817', 'UNSOLD'),
('c30b9a4e-951a-46fb-b7b7-91e0bc369ac8', '51d33340-b25a-4818-86f5-3312c5a3476b', 'UNSOLD'),
('9d6c50d3-2f8e-40b8-aca0-c87efbb39800', 'd9066687-e9bf-4316-961d-abddfb7b63cf', 'UNSOLD'),
('e38bf3f4-fb12-4fdf-9239-68422355c75a', 'ba9bb094-baf8-4372-983e-c3aa6fad55dd', 'UNSOLD'),
('94535148-cb6e-4931-8c9b-47de8c383bfe', '731281d4-a30a-4b7e-bdbf-62700a17152f', 'UNSOLD'),
('cde21023-190e-49a5-9643-97fa0885683d', 'b6e19898-5169-4509-b861-2299680a56a4', 'UNSOLD'),
('f36f2536-6d48-408d-a757-9544bdb0e508', 'ecabec1d-3e96-42ce-8fa8-a59d82588bd9', 'UNSOLD'),
('cc96b534-b240-4e7f-9f70-fbe3f640389d', 'd900dc2e-e4c8-467b-ad5c-49921724f7f8', 'UNSOLD'),
('ac6a7839-bde1-4baf-82ce-483bf14160d3', 'c7a95a9f-385c-4062-845a-eb4a4b86a2e1', 'UNSOLD'),
('2766e8a9-f782-419d-9f9d-99c0d45a94a3', '9e0716a8-e4ba-408a-8b2a-2db97f667c85', 'UNSOLD'),
('f18a56d5-fc37-4ea4-bd27-458adbfba3ef', '94111560-fd49-4cf4-ade6-00d6a2477308', 'UNSOLD'),
('cdae2a73-81fc-4cb2-bca4-34ea9da63f03', 'ba146c89-1bdf-4c62-ae81-9b8dbca223a2', 'UNSOLD'),
('9368b637-51cd-41c7-97df-dd0e741ca16e', 'a3b648aa-0a37-48b6-944c-b8a3885a98dd', 'UNSOLD'),
('55c4eaff-c5a1-4213-bbe9-fe0bd497ef71', '876e592e-f303-47d3-b362-967f510a6609', 'UNSOLD'),
('6ba6b91f-044e-4f20-949e-32206780340b', '97b74711-6dd7-4243-a32a-c370794ff449', 'UNSOLD'),
('da2c7bcf-eaa5-4168-be7d-9d90e14883ce', '75fd9914-35ac-415d-8dd0-5fb382b5874a', 'UNSOLD'),
('70faf171-4739-44b2-bb81-50db832c93c2', 'a51a7b7a-db25-4714-8108-38acbabad237', 'UNSOLD'),
('7ddcf7ff-fa9e-49cd-be39-45959715be5c', '9ca2716c-708c-45f5-bc4c-719bbf6e7168', 'UNSOLD'),
('c3cb7949-b336-408e-8964-6b43cf80979c', '1bf41e62-3c3f-46ec-9510-81acaae7551e', 'UNSOLD'),
('8e8fd117-57e8-439c-b448-71f6c40a5415', '83e47ae7-f7cf-4858-905c-700fed6c4ff6', 'UNSOLD'),
('c82684a2-aa40-4d5c-bc91-fcfabd73b2d3', 'd5c71630-31d3-4b80-9ec5-b92fc339de03', 'UNSOLD'),
('fe59460b-7e9f-4a73-88a5-0cd38963135a', '3a4817e7-ab45-4131-ad0e-ce357868187b', 'UNSOLD'),
('f12e7377-233b-4a53-b6ca-0c89c2c894f8', '2fec83be-492a-4844-8873-2c75e4ca4adb', 'UNSOLD'),
('bbd97338-dcb0-4d64-9970-af04975e87fb', 'db3540b4-1f02-4ea0-b599-4af9c0c78fc8', 'UNSOLD'),
('775d8f67-b367-449a-89b9-4a682e681082', '99a4539b-98a8-477e-b98c-d44b04d65309', 'UNSOLD'),
('ac282015-9212-49e8-b10a-578133ee4c0b', '51a2df8a-3af7-4c5a-bb98-5328e89b7896', 'UNSOLD'),
('302a6e84-8eb8-4d79-93de-faf8422087fb', 'a652c24c-fab3-49e4-9615-7cd0f208f664', 'UNSOLD'),
('b99b8eaf-8a99-4667-97c3-8e92992fac6a', '32b02c5e-58d2-4ef8-83ba-b588bc634a13', 'UNSOLD'),
('98908296-2c62-4ebb-bf79-88d8eef470e6', 'f451adf4-37fc-453b-9f5a-d91a4bbf7e5d', 'UNSOLD'),
('e33c1cc9-8177-4320-a71c-fc7a62835a3f', '327d3254-8501-4c8f-a7a9-bcfe7e52079c', 'UNSOLD'),
('9b141776-822a-4e37-a5ff-1313685cc72c', 'a2d2f4ae-03ca-4f51-8bfa-f16b49297ff5', 'UNSOLD'),
('50ed5395-0a0f-431c-a7dd-8dbe6c563b90', 'ab0d4750-8350-4aaf-8da1-5d95e05576d6', 'UNSOLD'),
('dc9e1a7b-4a8d-40dc-9020-7a242b8f887f', 'ec4bdc79-9985-44f8-b458-47b0f3767da2', 'UNSOLD'),
('b6d6becc-ea7d-423d-aebc-9b99608bc8d6', 'dd369e38-a008-4687-9397-ce9c69528b31', 'UNSOLD'),
('6fa9a881-a551-4f2a-9953-9df45419fd43', 'fd10a28e-6052-4319-b3a0-8acb6dd7ccde', 'UNSOLD'),
('ef3a73c3-82b0-4cee-9824-427e1a671e74', 'a28fd532-9697-4791-b0a5-1f62575503d9', 'UNSOLD'),
('10b5dde6-7507-447c-88ca-60b3150a2c6b', 'fed3d22d-93dc-4955-b43e-d25d5cba49e9', 'UNSOLD'),
('d39e5b36-c469-4c99-91f4-864841512432', '857d266e-8c94-48a2-83be-b0e4924ba8ed', 'UNSOLD'),
('1c34085a-f050-44fb-a4b8-d4fb14188468', '2ee108f6-4887-4db7-9884-cea846e857f2', 'UNSOLD'),
('11638564-a218-4e9d-88eb-668dd162ae73', 'cc33c633-9fd0-466c-a318-7fdbdb562a04', 'UNSOLD'),
('dfe44b6c-9da0-4288-a137-5d1a501143a8', '2f1988c9-a84a-4c99-a918-7cc47f5999dc', 'UNSOLD'),
('bf3fc974-5531-4e3f-add0-68edc41c12e4', '3fac62b4-598e-452e-8a4f-b82c4f186d59', 'UNSOLD'),
('1aec6e27-9c2d-43d2-9338-a1481e42efae', 'd18d4f24-dd22-442d-8899-1f72baeb0286', 'UNSOLD'),
('1e847983-e2eb-4059-a9d8-f3c50f360d01', '51d500f7-1a2a-4194-803a-04cf8437a3d7', 'UNSOLD'),
('e039f1dd-0fbe-4632-82d1-c5db7920755a', '99d15775-751d-4663-b92c-9cfd61f926f6', 'UNSOLD'),
('8aa4a543-bfcf-4e9e-9a09-df749398213b', '3cb6a524-ab11-4001-b407-646b82839dff', 'UNSOLD'),
('1bd0f748-db08-4e88-b119-64c3777681e5', '3da2f8b8-cf18-4a6e-9cc0-00ec3e6eaf60', 'UNSOLD'),
('73f78619-f775-44f6-a958-9baf7c296d06', '54ab5b86-dc9e-4340-89f7-ba38c1f67d11', 'UNSOLD'),
('84d39eee-5d33-43a4-8626-2e9f97b8bb43', '48c5456d-efe5-47cc-a272-6c277b169a28', 'UNSOLD'),
('91e51022-1b22-4c38-8c01-f4517601bef7', '46751dbf-d637-455d-8202-5bc7dce9b4f3', 'UNSOLD'),
('55837648-73a5-432b-acf8-33c2794fa333', '0821d612-0acb-4897-8769-5c60dd01c83e', 'UNSOLD'),
('304fc27a-05bb-4489-9e88-783f0169cfe6', '04b2d6c5-40ed-42ef-9b80-c7b61aa3fdcf', 'UNSOLD'),
('8ff3775c-6309-478b-84f1-19de95adfcde', '0978f850-1d98-4c25-91e9-9d394593e2d7', 'UNSOLD'),
('91457fcd-69c8-4523-b0e4-e6383365cdf8', 'bf269d4e-7807-491f-b4f5-a1335223acdc', 'UNSOLD'),
('90d4872b-738e-457f-baed-1fc6ac15830f', '929447ea-2130-469a-acd1-a4c0bef37fb5', 'UNSOLD'),
('51929bce-4dfb-4cf2-9f30-9577a4265035', '232d9d57-500f-4323-a696-dbbb7bf29c16', 'UNSOLD'),
('94737503-b668-4010-9372-c72e5548c737', '6b809c21-ce4f-4e07-b793-f40f7251bec1', 'UNSOLD'),
('d8594e62-bfdd-4350-ae94-010927219cd2', '0c6f345a-6102-47f0-bd0c-0b13d4d5fe0e', 'UNSOLD'),
('cfafc7d0-10a4-411a-9815-691bb3eb2d5e', 'd273dbb9-36a3-45ed-8b5b-3c2afe86b45b', 'UNSOLD'),
('a58264e8-c326-4b4f-b38d-b0aba52a1af4', '03c13afa-a67e-40d9-a8c3-756631b2e44a', 'UNSOLD'),
('e2e7fdb1-7e91-4f89-a58a-92a918e1f27e', '47b61db2-0f05-4991-a2dc-1b4bbe3271db', 'UNSOLD'),
('e0a47531-7380-4a75-95d4-442285cef843', '9acceac4-e5ba-46f2-80f7-10f4b80c37c9', 'UNSOLD'),
('da365aa2-9d55-44fa-9af9-f18263cf406d', '3f9edd79-7c3f-4191-b0eb-56114a8c1c7b', 'UNSOLD'),
('f68cd3c1-5b02-4cf2-9d4d-a89c59def705', '7edbd5ed-c74b-441c-94c6-91a17d110b15', 'UNSOLD'),
('757aeb7f-2a46-4518-b374-8bd7d0118ce4', '0a09ea24-5377-49cc-ae3b-642755d95828', 'UNSOLD'),
('32601af2-3aae-4ee0-a402-5de58c462bf0', '4c7883c6-90e3-437e-8c21-94a2965e3086', 'UNSOLD'),
('91dc2dc3-218c-40b8-83b4-8231d7920870', '6f3e8fe9-6098-4706-ace0-af35cdf38e7c', 'UNSOLD'),
('7f513e68-dced-42d1-943d-87d28632fc79', '993fb58d-4d7a-4479-843f-30d50d988009', 'UNSOLD'),
('30991652-33ae-4f9f-b4ca-6599b443c6d9', 'ff441c7d-68e5-44e3-94c0-23eabfa900df', 'UNSOLD'),
('f2ef2fd8-f235-400d-920c-aee4830ceb1e', '9efcdb0f-9484-4b18-8116-48cf04711dba', 'UNSOLD');

INSERT INTO "AdminUser" (id, username, password_hash, role) VALUES
('4e462e01-5372-417a-8498-a282e5de9500', 'admin', '$2b$10$mKc11zi7NTBY3/koE/bppOosSe/CMd4vmE1H8QgZYaWN7XAQmx9BK', 'ADMIN'),
('34ed8ece-7cba-4469-bb51-dfb709ecdca5', 'screen', '$2b$10$f0Hc0BjyEF.jiTUy.QsVJeBaM2X4er35zHpketgaA3l3VN2lEJo42', 'SCREEN');

INSERT INTO "AuctionSequence" (id, name, type, sequence_items) VALUES
(1, 'Franchise Auction', 'FRANCHISE', '[3,7,1,9,5,10,2,6,8,4]');

INSERT INTO "AuctionSequence" (id, name, type, sequence_items) VALUES
(2, 'Power Card Auction', 'POWER_CARD', '["GOD_EYE","MULLIGAN","FINAL_STRIKE","BID_FREEZER"]');

INSERT INTO "AuctionSequence" (id, name, type, sequence_items) VALUES
(3, 'Player Auction 7', 'PLAYER', '[66,55,24,83,111,137,101,86,67,110,14,141,106,85,114,120,69,133,92,78,118,59,115,58,155,72,80,43,135,32,36,145,98,16,100,143,147,158,126,47,124,93,87,33,94,79,76,68,31,140,130,104,19,71,125,138,159,44,123,38,63,27,97,129,142,95,73,60,81,121,82,51,77,70,88,116,139,102,74,131,48,40,122,157,132,154,65,1,50,39,75,128,64,10,57,149,112,46,96,13,28,117,61,41,105,108,35,52,29,144,37,119,99,11,109,148,15,30,127,12,62,17,156,5,84,21,150,42,89,25,34,90,2,56,6,113,7,151,20,146,49,18,153,4,45,103,152,23,134,107,8,26,3,53,136,9,54,22,91]');

INSERT INTO "AuctionState" (id, phase, auction_day) VALUES (1, 'NOT_STARTED', 'Day 2');

