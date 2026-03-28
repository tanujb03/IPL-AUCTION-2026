-- INSTANCE 3 INITIALIZATION
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



-- ── DATA FOR INSTANCE 3 ──

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
('25d3b270-bbac-4bf6-a8f8-77c85f6a467c', 'The jews', 'thejews', '$2b$10$5y1xoebFYYwzi.fa3fres.7Nb5Cx/o8EpHgBwMQRCZjEcBuscL4cy', 120, 0),
('d86c0a21-ed05-4929-b3b2-b058112f671c', 'Tech_Spaces 11', 'techspaces11', '$2b$10$2VN/1F5VOde.DmwPLXmpkOvRkAQfYIOstSwxWkf6IymfwoFWkzIhC', 120, 0),
('db3829df-d003-4ba0-99b7-4bcc1d9ffe5c', 'Hyderabadi chicken biryani', 'hyderabadichickenbir', '$2b$10$R.VpHjD.IuNkZSk2Q9w1JO2rBR1MWlQDSxV7FjLfapFzbxQ3M4amq', 120, 0),
('b00313f0-ecbf-4868-9970-d7380910c945', 'Pillukombdi', 'pillukombdi', '$2b$10$FpUSmw6F2Bc8HsIUw/ANJeRykjvDKTuBqNF60oc7AFAVixjkCkqlC', 120, 0),
('8b5e4bf3-3db8-402c-8ea8-516a91dcd1a9', 'Bidmasters XI', 'bidmastersxi', '$2b$10$lGRmrgG0l/HV40aSIpmZXOw.tiPMtASzfK6DlCof3OFWO.j2Jasfu', 120, 0),
('5edcd56f-19f7-44d1-a4b0-082d361fd2c1', 'Thunder Strikers', 'thunderstrikers', '$2b$10$c/ksggnWcpaC64VejFfJnerw9zWeZAT26E0779Am2oBSfzM6iB2q2', 120, 0),
('b5f365b6-415b-4045-bba8-d8f91f93d7bb', '401', '401', '$2b$10$uVupXWRYLpYkjD3i19C1RuU0.IAiYeNfW1MLufCewpU53y69Gxyf.', 120, 0),
('c56ef5b3-2ddf-4553-a8df-3fa306c696a5', 'Ipl ka tambu', 'iplkatambu', '$2b$10$MfPNqBw5/EzQUBu6i9hofewZytvKdZVwf/.3pvTMMWv59dAc/R6Vu', 120, 0),
('91290ff1-e2a5-4f79-be28-a598397690d3', 'Dhoni Ka Bambu', 'dhonikabambu', '$2b$10$fm28fxpNmLNx2CzaJtea4OjbfMPMQzRlMp2gowsnEHVQBt/N2JrTG', 120, 0),
('4202b69e-d799-4582-b1d9-52800572eed7', 'Choco 11', 'choco11', '$2b$10$pHynAsA/rlLDHoMzqwcF3OerCuRTtuTn7Sq8JMJPpk7B9f4A8XNbW', 120, 0);

INSERT INTO "Player" (id, rank, name, team, role, category, pool, grade, rating, nationality, nationality_raw, base_price, is_riddle, legacy, url, matches, bat_runs, bat_sr, bat_average, bowl_wickets, bowl_eco, bowl_avg, sub_scoring, sub_impact, sub_consistency, sub_experience, sub_wicket_taking, sub_economy, sub_efficiency, sub_batting, sub_bowling, sub_versatility) VALUES
('b51be22c-fee8-4a2a-951b-e22c7b0ca573', 134, 'Vipraj Nigam', 'Delhi Capitals', 'Bowler', 'BOWL', 'BOWL', 'C', 59, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/1431811/vipraj-nigam', 14.0, NULL, NULL, NULL, 11.0, 9.13, 32.36, NULL, NULL, NULL, 37, 10.0, 54.0, 69.0, NULL, NULL, NULL),
('5bbe4b7b-95e9-48f7-ba37-96cb70044f46', 137, 'Jayant Yadav', 'Gujarat Titans', 'Bowling Allrounder', 'AR', 'AR', 'C', 58, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/8182/jayant-yadav', 20.0, 40.0, NULL, NULL, 8.0, NULL, NULL, NULL, NULL, NULL, 40, NULL, NULL, NULL, 22.0, 25.0, 22.0),
('40891aa1-e5ae-436f-9305-85c18f06d726', 104, 'Lungi Ngidi', 'Delhi Capitals', 'Bowler', 'BOWL', 'BOWL', 'C', 64, 'OVERSEAS', 'South African', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/9603/lungi-ngidi', 16.0, NULL, NULL, NULL, 29.0, 8.53, 18.24, NULL, NULL, NULL, 38, 22.0, 63.0, 99.0, NULL, NULL, NULL),
('62cdf92e-ece2-4d26-94c7-63ae97994d93', 138, 'Azmatullah Omarzai', 'Punjab Kings', 'Bowling Allrounder', 'AR', 'AR', 'C', 58, 'OVERSEAS', 'Afghan', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/13214/azmatullah-omarzai', 16.0, 99.0, NULL, NULL, 12.0, NULL, NULL, NULL, NULL, NULL, 38, NULL, NULL, NULL, 31.0, 25.0, 25.0),
('550cd8f0-f658-46ee-a9cc-4e51b314742d', 100, 'Abishek Porel', 'Delhi Capitals', 'WK-Batsman', 'WK', 'BAT_WK', 'C', 66, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/24326/abishek-porel', 31.0, 661.0, 149.89, 25.42, NULL, NULL, NULL, 16.0, 78.0, 63.0, 45, NULL, NULL, NULL, NULL, NULL, NULL),
('5102b994-1756-4cbc-bbcc-ed58a876b90a', 115, 'Rachin Ravindra', 'Kolkata Knight Riders', 'Batting Allrounder', 'AR', 'AR', 'C', 62, 'OVERSEAS', 'New Zealander', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/11177/rachin-ravindra', 18.0, 413.0, NULL, NULL, 0.0, NULL, NULL, NULL, NULL, NULL, 39, NULL, NULL, NULL, 49.0, 29.0, 29.0),
('a4bc4f7f-dcd1-44c8-b2a4-b35af590e780', 117, 'Dewald Brevis', 'Chennai Super Kings', 'Batsman', 'BAT', 'BAT_WK', 'C', 62, 'OVERSEAS', 'South African', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/20538/dewald-brevis', 16.0, 455.0, 153.2, 28.44, NULL, NULL, NULL, 12.0, 80.0, 71.0, 38, NULL, NULL, NULL, NULL, NULL, NULL),
('70dacb37-b3e5-4412-9eb0-09cefb0b7e93', 37, 'Ishan Kishan', 'Sunrisers Hyderabad', 'WK-Batsman', 'WK', 'BAT_WK', 'B', 78, 'INDIAN', 'Indian', 1, false, 0, 'https://www.cricbuzz.com/profiles/10276/ishan-kishan', 119.0, 2998.0, 137.65, 29.11, NULL, NULL, NULL, 58.0, 70.0, 72.0, 89, NULL, NULL, NULL, NULL, NULL, NULL),
('7d0d1f21-6102-4702-b7d7-0d2f65e1c6fd', 87, 'Tushar Deshpande', 'Rajasthan Royals', 'Bowler', 'BOWL', 'BOWL', 'C', 67, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/11307/tushar-deshpande', 46.0, NULL, NULL, NULL, 51.0, 9.84, 31.04, NULL, NULL, NULL, 53, 36.0, 42.0, 72.0, NULL, NULL, NULL),
('dfe1f4d7-54a9-4ab5-b92f-9909f021acbc', 141, 'Eshan Malinga', 'Sunrisers Hyderabad', 'Bowler', 'BOWL', 'BOWL', 'C', 58, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/46926/eshan-malinga', 7.0, NULL, NULL, NULL, 13.0, 8.93, 18.31, NULL, NULL, NULL, 33, 12.0, 57.0, 99.0, NULL, NULL, NULL),
('8b5cff79-2753-4475-95c2-48a152d61a93', 53, 'Prasidh Krishna', 'Gujarat Titans', 'Bowler', 'BOWL', 'BOWL', 'B', 74, 'INDIAN', 'Indian', 1, false, 0, 'https://www.cricbuzz.com/profiles/10551/prasidh-krishna', 66.0, NULL, NULL, NULL, 74.0, 8.77, 29.61, NULL, NULL, NULL, 63, 51.0, 59.0, 75.0, NULL, NULL, NULL),
('f411e109-f403-4215-b2aa-321cec10a197', 143, 'Prashant Solanki', 'Kolkata Knight Riders', 'Bowler', 'BOWL', 'BOWL', 'C', 57, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/12805/prashant-solanki', 2.0, NULL, NULL, NULL, 2.0, 6.33, 19.0, NULL, NULL, NULL, 31, 5.0, 99.0, 97.0, NULL, NULL, NULL),
('6ab761a9-0dd7-431a-a944-db880b1ad6b2', 29, 'Mohammed Siraj', 'Gujarat Titans', 'Bowler', 'BOWL', 'BOWL', 'B', 83, 'INDIAN', 'Indian', 1, false, 2, 'https://www.cricbuzz.com/profiles/10808/mohammed-siraj', 108.0, NULL, NULL, NULL, 109.0, 8.74, 30.72, NULL, NULL, NULL, 84, 74.0, 60.0, 72.0, NULL, NULL, NULL),
('a71af688-4c1a-4f47-b24f-ed19ad35cd25', 5, 'Bhuvneshwar Kumar', 'Royal Challengers Bengaluru', 'Bowler', 'BOWL', 'BOWL', 'A', 98, 'INDIAN', 'Indian', 2, false, 8, 'https://www.cricbuzz.com/profiles/1726/bhuvneshwar-kumar', 190.0, NULL, NULL, NULL, 198.0, 7.69, 27.33, NULL, NULL, NULL, 99, 99.0, 77.0, 80.0, NULL, NULL, NULL),
('54ccb7a4-bf00-4019-b2eb-d64b8d2e9e2a', 42, 'Ruturaj Gaikwad', 'Chennai Super Kings', 'Batsman', 'BAT', 'BAT_WK', 'B', 77, 'INDIAN', 'Indian', 1, false, 0, 'https://www.cricbuzz.com/profiles/11813/ruturaj-gaikwad', 71.0, 2502.0, 137.48, 40.35, NULL, NULL, NULL, 49.0, 70.0, 99.0, 65, NULL, NULL, NULL, NULL, NULL, NULL),
('51c33aca-5e9d-4de6-9dba-c49d021bf248', 78, 'Rajat Patidar', 'Royal Challengers Bengaluru', 'Batsman', 'BAT', 'BAT_WK', 'C', 69, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/10636/rajat-patidar', 42.0, 1111.0, 154.31, 30.86, NULL, NULL, NULL, 24.0, 81.0, 77.0, 51, NULL, NULL, NULL, NULL, NULL, NULL),
('53d9dc29-2f08-4668-9985-482da7f57409', 86, 'Mayank Markande', 'Mumbai Indians', 'Bowler', 'BOWL', 'BOWL', 'C', 67, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/12627/mayank-markande', 37.0, NULL, NULL, NULL, 37.0, 8.91, 28.89, NULL, NULL, NULL, 48, 27.0, 57.0, 76.0, NULL, NULL, NULL),
('44ed33d4-9b0e-4bd3-b7dc-4990df80ce5e', 154, 'Nuwan Thushara', 'Royal Challengers Bengaluru', 'Bowler', 'BOWL', 'BOWL', 'C', 56, 'OVERSEAS', 'Sri Lankan', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/18509/nuwan-thushara', 8.0, NULL, NULL, NULL, 9.0, 9.43, 31.44, NULL, NULL, NULL, 34, 9.0, 49.0, 71.0, NULL, NULL, NULL),
('55301671-26ed-49db-bc10-5a35dd34aced', 71, 'Matheesha Pathirana', 'Kolkata Knight Riders', 'Bowler', 'BOWL', 'BOWL', 'B', 70, 'OVERSEAS', 'Sri Lankan', 1, false, 0, 'https://www.cricbuzz.com/profiles/16458/matheesha-pathirana', 32.0, NULL, NULL, NULL, 47.0, 8.68, 21.62, NULL, NULL, NULL, 46, 34.0, 61.0, 92.0, NULL, NULL, NULL),
('73628791-56a7-42dd-9d4d-96f1f266b475', 131, 'Romario Shepherd', 'Royal Challengers Bengaluru', 'Bowling Allrounder', 'AR', 'AR', 'C', 60, 'OVERSEAS', 'West Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/13646/romario-shepherd', 18.0, 185.0, NULL, NULL, 10.0, NULL, NULL, NULL, NULL, NULL, 39, NULL, NULL, NULL, 52.0, 18.0, 18.0),
('42b59ef3-ed72-42da-8c49-fc0ed0120699', 105, 'Mukesh Kumar', 'Delhi Capitals', 'Bowler', 'BOWL', 'BOWL', 'C', 64, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/10754/mukesh-kumar', 32.0, NULL, NULL, NULL, 36.0, 10.4, 30.61, NULL, NULL, NULL, 46, 27.0, 33.0, 73.0, NULL, NULL, NULL),
('f1157cf6-39a5-4b54-aee3-988cb3e98cf8', 32, 'David Miller', 'Delhi Capitals', 'Batsman', 'BAT', 'BAT_WK', 'B', 80, 'OVERSEAS', 'South African', 1, false, 0, 'https://www.cricbuzz.com/profiles/6349/david-miller', 141.0, 3077.0, 138.61, 35.78, NULL, NULL, NULL, 60.0, 70.0, 89.0, 99, NULL, NULL, NULL, NULL, NULL, NULL),
('f2c81381-d8b7-4443-a845-349a485eea45', 116, 'Sherfane Rutherford', 'Mumbai Indians', 'Batting Allrounder', 'AR', 'AR', 'C', 62, 'OVERSEAS', 'West Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/13748/sherfane-rutherford', 23.0, 397.0, NULL, NULL, 1.0, NULL, NULL, NULL, NULL, NULL, 41, NULL, NULL, NULL, 48.0, 17.0, 17.0),
('c5b0a05f-32cf-43de-a19b-ff4317860280', 91, 'Shahrukh Khan', 'Gujarat Titans', 'Batting Allrounder', 'AR', 'AR', 'C', 67, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/10226/shahrukh-khan', 55.0, 732.0, NULL, NULL, 1.0, NULL, NULL, NULL, NULL, NULL, 57, NULL, NULL, NULL, 56.0, 27.0, 27.0),
('ed581503-eadf-4aa8-8b90-d4ddb65af4e6', 118, 'Aniket Verma', 'Sunrisers Hyderabad', 'Batsman', 'BAT', 'BAT_WK', 'C', 62, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/1447065/aniket-verma', 14.0, 236.0, 166.2, 26.22, NULL, NULL, NULL, 8.0, 89.0, 65.0, 37, NULL, NULL, NULL, NULL, NULL, NULL),
('fd99773e-bbb8-4afc-aaff-a13346047276', 94, 'Will Jacks', 'Mumbai Indians', 'Batting Allrounder', 'AR', 'AR', 'C', 66, 'OVERSEAS', 'English', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/12258/will-jacks', 21.0, 463.0, NULL, NULL, 8.0, NULL, NULL, NULL, NULL, NULL, 40, NULL, NULL, NULL, 55.0, 28.0, 28.0),
('af8fe6af-f1ac-4fed-8140-6cb73f717854', 54, 'Heinrich Klaasen', 'Sunrisers Hyderabad', 'WK-Batsman', 'WK', 'BAT_WK', 'B', 74, 'OVERSEAS', 'South African', 1, false, 0, 'https://www.cricbuzz.com/profiles/10209/heinrich-klaasen', 49.0, 1480.0, 169.73, 40.0, NULL, NULL, NULL, 31.0, 91.0, 99.0, 54, NULL, NULL, NULL, NULL, NULL, NULL),
('b5a95b4d-e236-4a82-850f-4f4959ca8c78', 112, 'Nitish Kumar Reddy', 'Sunrisers Hyderabad', 'Batting Allrounder', 'AR', 'AR', 'C', 62, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/14701/nitish-kumar-reddy', 28.0, 485.0, NULL, NULL, 5.0, NULL, NULL, NULL, NULL, NULL, 44, NULL, NULL, NULL, 50.0, 14.0, 14.0),
('f0b53946-31c5-409b-b835-47f9d9b9e85f', 27, 'Shreyas Iyer', 'Punjab Kings', 'Batsman', 'BAT', 'BAT_WK', 'B', 83, 'INDIAN', 'Indian', 1, false, 0, 'https://www.cricbuzz.com/profiles/9428/shreyas-iyer', 132.0, 3731.0, 133.35, 34.23, NULL, NULL, NULL, 72.0, 67.0, 85.0, 96, NULL, NULL, NULL, NULL, NULL, NULL),
('bca64a44-591c-4f1e-bf80-90038941d832', 90, 'Naman Dhir', 'Mumbai Indians', 'Batsman', 'BAT', 'BAT_WK', 'C', 67, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/36139/naman-dhir', 23.0, 392.0, 180.65, 28.0, NULL, NULL, NULL, 11.0, 99.0, 70.0, 41, NULL, NULL, NULL, NULL, NULL, NULL),
('e7070746-d8a5-41ae-95c5-9cd9dcf50b7c', 119, 'Wanindu Hasaranga', 'Lucknow Super Giants', 'Bowling Allrounder', 'AR', 'AR', 'C', 62, 'OVERSEAS', 'Sri Lankan', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/10926/wanindu-hasaranga', 37.0, 81.0, NULL, NULL, 46.0, NULL, NULL, NULL, NULL, NULL, 48, NULL, NULL, NULL, 15.0, 45.0, 15.0),
('d955f490-60b0-4942-8e90-e1822d100ff6', 25, 'Marcus Stoinis', 'Punjab Kings', 'Batting Allrounder', 'AR', 'AR', 'B', 83, 'OVERSEAS', 'Australian', 1, false, 4, 'https://www.cricbuzz.com/profiles/8989/marcus-stoinis', 109.0, 2026.0, NULL, NULL, 44.0, NULL, NULL, NULL, NULL, NULL, 84, NULL, NULL, NULL, 90.0, 37.0, 37.0),
('9652af8e-6184-48c6-9fde-e43fa8cbdfcc', 65, 'Tilak Varma', 'Mumbai Indians', 'Batsman', 'BAT', 'BAT_WK', 'B', 72, 'INDIAN', 'Indian', 1, false, 0, 'https://www.cricbuzz.com/profiles/14504/tilak-varma', 54.0, 1499.0, 144.42, 37.48, NULL, NULL, NULL, 31.0, 74.0, 93.0, 57, NULL, NULL, NULL, NULL, NULL, NULL),
('d4921bf6-daff-4a64-a66a-23f402804b95', 135, 'Kartik Tyagi', 'Kolkata Knight Riders', 'Bowler', 'BOWL', 'BOWL', 'C', 58, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/13136/kartik-tyagi', 20.0, NULL, NULL, NULL, 15.0, 10.14, 47.53, NULL, NULL, NULL, 40, 13.0, 37.0, 37.0, NULL, NULL, NULL),
('ceeb6beb-0f56-4675-ae27-49d333e0f91c', 103, 'Priyansh Arya', 'Punjab Kings', 'Batsman', 'BAT', 'BAT_WK', 'C', 64, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/14689/priyansh-arya', 17.0, 475.0, 179.25, 27.94, NULL, NULL, NULL, 13.0, 98.0, 70.0, 38, NULL, NULL, NULL, NULL, NULL, NULL),
('6ec3a4fb-9127-497a-bb35-e9ae1c056a60', 108, 'Rovman Powell', 'Kolkata Knight Riders', 'Batsman', 'BAT', 'BAT_WK', 'C', 63, 'OVERSEAS', 'West Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/11445/rovman-powell', 28.0, 365.0, 146.59, 18.25, NULL, NULL, NULL, 11.0, 76.0, 46.0, 44, NULL, NULL, NULL, NULL, NULL, NULL),
('f165ce8d-b108-4b98-9527-80221090831f', 26, 'Jaydev Unadkat', 'Sunrisers Hyderabad', 'Bowler', 'BOWL', 'BOWL', 'B', 83, 'INDIAN', 'Indian', 1, false, 2, 'https://www.cricbuzz.com/profiles/6327/jaydev-unadkat', 112.0, NULL, NULL, NULL, 110.0, 8.88, 30.58, NULL, NULL, NULL, 86, 74.0, 58.0, 73.0, NULL, NULL, NULL),
('55db0447-9c20-4001-b7de-6bf63c275395', 145, 'Akash Maharaj Singh', 'Lucknow Super Giants', 'Bowler', 'BOWL', 'BOWL', 'C', 57, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/14696/akash-maharaj-singh', 10.0, NULL, NULL, NULL, 9.0, 9.54, 36.22, NULL, NULL, NULL, 35, 9.0, 47.0, 61.0, NULL, NULL, NULL),
('50023102-e6e7-4872-881b-7c1f18c10943', 157, 'Manimaran Siddharth', 'Lucknow Super Giants', 'Bowler', 'BOWL', 'BOWL', 'C', 55, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/12930/manimaran-siddharth', 5.0, NULL, NULL, NULL, 3.0, 8.63, 46.0, NULL, NULL, NULL, 32, 5.0, 62.0, 40.0, NULL, NULL, NULL),
('e905bdd0-cfaf-4e95-8f7b-f58e96ba1f81', 150, 'Adam Milne', 'Rajasthan Royals', 'Bowler', 'BOWL', 'BOWL', 'C', 56, 'OVERSEAS', 'New Zealander', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/7625/adam-milne', 10.0, NULL, NULL, NULL, 7.0, 9.48, 46.71, NULL, NULL, NULL, 35, 8.0, 48.0, 38.0, NULL, NULL, NULL),
('5f00d758-c0ca-452b-82f2-ecf7090bc112', 23, 'Shubman Gill', 'Gujarat Titans', 'Batsman', 'BAT', 'BAT_WK', 'B', 84, 'INDIAN', 'Indian', 1, false, 0, 'https://www.cricbuzz.com/profiles/11808/shubman-gill', 118.0, 3866.0, 138.72, 39.45, NULL, NULL, NULL, 74.0, 70.0, 98.0, 89, NULL, NULL, NULL, NULL, NULL, NULL),
('516214b4-958c-46ff-9a61-87c432a53675', 47, 'Yashasvi Jaiswal', 'Rajasthan Royals', 'Batsman', 'BAT', 'BAT_WK', 'B', 75, 'INDIAN', 'Indian', 1, false, 0, 'https://www.cricbuzz.com/profiles/13940/yashasvi-jaiswal', 66.0, 2166.0, 152.86, 34.38, NULL, NULL, NULL, 43.0, 80.0, 85.0, 63, NULL, NULL, NULL, NULL, NULL, NULL),
('eae25ed9-0751-4503-8fa4-419a4172c4c1', 15, 'Sanju Samson', 'Chennai Super Kings', 'WK-Batsman', 'WK', 'BAT_WK', 'A', 89, 'INDIAN', 'Indian', 2, false, 2, 'https://www.cricbuzz.com/profiles/8271/sanju-samson', 176.0, 4704.0, 139.05, 30.75, NULL, NULL, NULL, 89.0, 71.0, 76.0, 99, NULL, NULL, NULL, NULL, NULL, NULL),
('46519a92-8e5f-4491-b306-b55183f45298', 69, 'Liam Livingstone', 'Sunrisers Hyderabad', 'Batting Allrounder', 'AR', 'AR', 'B', 70, 'OVERSEAS', 'English', 1, false, 0, 'https://www.cricbuzz.com/profiles/10045/liam-livingstone', 49.0, 1051.0, NULL, NULL, 13.0, NULL, NULL, NULL, NULL, NULL, 54, NULL, NULL, NULL, 70.0, 28.0, 28.0),
('acba9700-91e3-4e8b-9a80-bb85b3545004', 77, 'Rinku Singh', 'Kolkata Knight Riders', 'Batsman', 'BAT', 'BAT_WK', 'C', 69, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/10896/rinku-singh', 58.0, 1099.0, 145.18, 30.53, NULL, NULL, NULL, 24.0, 75.0, 76.0, 59, NULL, NULL, NULL, NULL, NULL, NULL),
('78ac7792-186f-4a4f-bae6-e46617c96d5a', 123, 'Ayush Mhatre', 'Chennai Super Kings', 'Batsman', 'BAT', 'BAT_WK', 'C', 61, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/1431163/ayush-mhatre', 7.0, 240.0, 188.98, 34.29, NULL, NULL, NULL, 8.0, 99.0, 85.0, 33, NULL, NULL, NULL, NULL, NULL, NULL),
('f49e5da0-ba46-49ba-9cb8-740adf7b22da', 122, 'Ashutosh Sharma', 'Delhi Capitals', 'Batting Allrounder', 'AR', 'AR', 'C', 61, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/13497/ashutosh-sharma', 24.0, 393.0, NULL, NULL, 0.0, NULL, NULL, NULL, NULL, NULL, 42, NULL, NULL, NULL, 56.0, 0.0, 0.0),
('8a27be9f-f0d2-4902-9415-627dd5a67b56', 16, 'Suryakumar Yadav', 'Mumbai Indians', 'Batsman', 'BAT', 'BAT_WK', 'A', 89, 'INDIAN', 'Indian', 2, false, 2, 'https://www.cricbuzz.com/profiles/7915/suryakumar-yadav', 166.0, 4311.0, 148.66, 35.05, NULL, NULL, NULL, 82.0, 77.0, 87.0, 99, NULL, NULL, NULL, NULL, NULL, NULL),
('315a1635-db3f-40c8-ba75-f09ceb6e9d18', 39, 'Nicholas Pooran', 'Lucknow Super Giants', 'WK-Batsman', 'WK', 'BAT_WK', 'B', 78, 'OVERSEAS', 'West Indian', 1, false, 0, 'https://www.cricbuzz.com/profiles/9406/nicholas-pooran', 90.0, 2293.0, 168.98, 34.22, NULL, NULL, NULL, 46.0, 91.0, 85.0, 75, NULL, NULL, NULL, NULL, NULL, NULL),
('248a8e47-4791-43ff-bd84-20e58d15e8d7', 17, 'Mohammed Shami', 'Lucknow Super Giants', 'Bowler', 'BOWL', 'BOWL', 'A', 89, 'INDIAN', 'Indian', 2, false, 4, 'https://www.cricbuzz.com/profiles/7909/mohammed-shami', 119.0, NULL, NULL, NULL, 133.0, 8.63, 28.18, NULL, NULL, NULL, 89, 89.0, 62.0, 78.0, NULL, NULL, NULL),
('4b03bcbf-0019-4513-9349-005bbd47efbe', 44, 'Khaleel Ahmed', 'Chennai Super Kings', 'Bowler', 'BOWL', 'BOWL', 'B', 77, 'INDIAN', 'Indian', 1, false, 0, 'https://www.cricbuzz.com/profiles/10952/khaleel-ahmed', 71.0, NULL, NULL, NULL, 89.0, 8.98, 26.16, NULL, NULL, NULL, 65, 61.0, 56.0, 82.0, NULL, NULL, NULL),
('e1d75270-9066-4b46-ac77-f86e008ef192', 43, 'Abhishek Sharma', 'Sunrisers Hyderabad', 'Batting Allrounder', 'AR', 'AR', 'B', 77, 'INDIAN', 'Indian', 1, false, 2, 'https://www.cricbuzz.com/profiles/12086/abhishek-sharma', 77.0, 1815.0, NULL, NULL, 11.0, NULL, NULL, NULL, NULL, NULL, 68, NULL, NULL, NULL, 90.0, 24.0, 24.0),
('41a82c62-54e5-485f-904e-4625063b845b', 124, 'Shubham Dubey', 'Rajasthan Royals', 'Batsman', 'BAT', 'BAT_WK', 'C', 61, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/19328/shubham-dubey', 13.0, 139.0, 163.53, 23.17, NULL, NULL, NULL, 6.0, 87.0, 58.0, 36, NULL, NULL, NULL, NULL, NULL, NULL),
('705429a0-d014-4d4f-b244-21fc6aa29b3b', 114, 'Mitchell Santner', 'Mumbai Indians', 'Bowling Allrounder', 'AR', 'AR', 'C', 62, 'OVERSEAS', 'New Zealander', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/10100/mitchell-santner', 31.0, 110.0, NULL, NULL, 25.0, NULL, NULL, NULL, NULL, NULL, 45, NULL, NULL, NULL, 25.0, 40.0, 25.0),
('48ed66c9-b2a9-4ba1-b820-ba8079a0a19d', 149, 'Glenn Phillips', 'Gujarat Titans', 'Batting Allrounder', 'AR', 'AR', 'C', 56, 'OVERSEAS', 'New Zealander', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/10693/glenn-phillips', 8.0, 65.0, NULL, NULL, 2.0, NULL, NULL, NULL, NULL, NULL, 34, NULL, NULL, NULL, 24.0, 34.0, 24.0),
('bea4abd4-9987-4dc2-bc8d-ca527872c698', 156, 'Matthew Short', 'Chennai Super Kings', 'Batsman', 'BAT', 'BAT_WK', 'C', 55, 'OVERSEAS', 'Australian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/9456/matthew-short', 6.0, 117.0, 127.18, 19.5, NULL, NULL, NULL, 6.0, 63.0, 49.0, 33, NULL, NULL, NULL, NULL, NULL, NULL),
('e3f31dd5-a160-492b-b951-962222021e46', 140, 'Mukesh Choudhary', 'Chennai Super Kings', 'Bowler', 'BOWL', 'BOWL', 'C', 58, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/13184/mukesh-choudhary', 16.0, NULL, NULL, NULL, 17.0, 9.94, 30.71, NULL, NULL, NULL, 38, 14.0, 40.0, 72.0, NULL, NULL, NULL),
('97111e23-5a69-4a99-a284-51adbc6f2c6a', 158, 'Arjun Tendulkar', 'Lucknow Super Giants', 'Bowling Allrounder', 'AR', 'AR', 'C', 55, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/13747/arjun-tendulkar', 5.0, 13.0, NULL, NULL, 3.0, NULL, NULL, NULL, NULL, NULL, 32, NULL, NULL, NULL, 32.0, 23.0, 23.0),
('c4f9e19b-dbed-458b-af80-a57661f9930b', 130, 'Sameer Rizvi', 'Delhi Capitals', 'Batsman', 'BAT', 'BAT_WK', 'C', 60, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/14700/sameer-rizvi', 13.0, 172.0, 140.99, 24.57, NULL, NULL, NULL, 7.0, 72.0, 61.0, 36, NULL, NULL, NULL, NULL, NULL, NULL),
('75ee8e5d-6981-496f-89e6-1c367df21f56', 75, 'Karun Nair', 'Delhi Capitals', 'Batsman', 'BAT', 'BAT_WK', 'B', 70, 'INDIAN', 'Indian', 1, false, 0, 'https://www.cricbuzz.com/profiles/8257/karun-nair', 84.0, 1694.0, 131.73, 23.86, NULL, NULL, NULL, 35.0, 66.0, 60.0, 72, NULL, NULL, NULL, NULL, NULL, NULL),
('82394290-7d23-4251-965f-9443ed248640', 73, 'Tim David', 'Royal Challengers Bengaluru', 'Batsman', 'BAT', 'BAT_WK', 'B', 70, 'OVERSEAS', 'Singaporean', 1, false, 0, 'https://www.cricbuzz.com/profiles/13169/tim-david', 50.0, 846.0, 173.37, 32.54, NULL, NULL, NULL, 19.0, 94.0, 81.0, 55, NULL, NULL, NULL, NULL, NULL, NULL),
('1acf11af-3298-473b-a262-1ee6a1ec90d0', 88, 'Harshit Rana', 'Kolkata Knight Riders', 'Bowler', 'BOWL', 'BOWL', 'C', 67, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/24729/harshit-rana', 33.0, NULL, NULL, NULL, 40.0, 9.51, 25.73, NULL, NULL, NULL, 46, 29.0, 47.0, 83.0, NULL, NULL, NULL),
('52c4546c-9bcc-4dc8-b288-c80a15725aab', 41, 'Nitish Rana', 'Delhi Capitals', 'Batsman', 'BAT', 'BAT_WK', 'B', 77, 'INDIAN', 'Indian', 1, false, 0, 'https://www.cricbuzz.com/profiles/9204/nitish-rana', 118.0, 2853.0, 136.77, 27.7, NULL, NULL, NULL, 56.0, 69.0, 69.0, 89, NULL, NULL, NULL, NULL, NULL, NULL),
('d3902e7f-3827-4f4b-8088-1e2802c1381e', 56, 'Josh Hazlewood', 'Royal Challengers Bengaluru', 'Bowler', 'BOWL', 'BOWL', 'B', 73, 'OVERSEAS', 'Australian', 1, false, 0, 'https://www.cricbuzz.com/profiles/6258/josh-hazlewood', 39.0, NULL, NULL, NULL, 57.0, 8.28, 20.98, NULL, NULL, NULL, 49, 40.0, 67.0, 93.0, NULL, NULL, NULL),
('1e8d8cfd-55a2-4387-a426-31f743ba8229', 129, 'Anuj Rawat', 'Gujarat Titans', 'WK-Batsman', 'WK', 'BAT_WK', 'C', 60, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/13135/anuj-rawat', 24.0, 318.0, 119.11, 19.88, NULL, NULL, NULL, 10.0, 57.0, 50.0, 42, NULL, NULL, NULL, NULL, NULL, NULL),
('2bf544cf-595f-46d5-bd62-11526b82806f', 120, 'Ravisrinivasan Sai Kishore', 'Gujarat Titans', 'Bowling Allrounder', 'AR', 'AR', 'C', 61, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/11595/ravisrinivasan-sai-kishore', 25.0, 18.0, NULL, NULL, 32.0, NULL, NULL, NULL, NULL, NULL, 42, NULL, NULL, NULL, 19.0, 41.0, 19.0),
('3b6dfe30-a0dc-4ce9-a70d-ceebf8542a5b', 40, 'Rahul Chahar', 'Chennai Super Kings', 'Bowler', 'BOWL', 'BOWL', 'B', 77, 'INDIAN', 'Indian', 1, false, 0, 'https://www.cricbuzz.com/profiles/12087/rahul-chahar', 79.0, NULL, NULL, NULL, 75.0, 7.72, 28.67, NULL, NULL, NULL, 69, 52.0, 76.0, 77.0, NULL, NULL, NULL),
('b2e8fb09-fbc8-44c6-aa1b-475c1ab71d9c', 97, 'Ramandeep Singh', 'Kolkata Knight Riders', 'Batting Allrounder', 'AR', 'AR', 'C', 66, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/12337/ramandeep-singh', 30.0, 217.0, NULL, NULL, 6.0, NULL, NULL, NULL, NULL, NULL, 45, NULL, NULL, NULL, 46.0, 35.0, 35.0),
('ca23c8a2-d213-4bbe-acb4-96c4267fc854', 19, 'Hardik Pandya', 'Mumbai Indians', 'Batting Allrounder', 'AR', 'AR', 'A', 89, 'INDIAN', 'Indian', 2, false, 6, 'https://www.cricbuzz.com/profiles/9647/hardik-pandya', 152.0, 2749.0, NULL, NULL, 78.0, NULL, NULL, NULL, NULL, NULL, 99, NULL, NULL, NULL, 90.0, 50.0, 50.0),
('f1f2c647-587c-4ad7-b917-510c3a5f01af', 93, 'Washington Sundar', 'Gujarat Titans', 'Bowling Allrounder', 'AR', 'AR', 'C', 67, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/10945/washington-sundar', 66.0, 511.0, NULL, NULL, 39.0, NULL, NULL, NULL, NULL, NULL, 63, NULL, NULL, NULL, 42.0, 40.0, 40.0),
('01c1f32a-e1d3-43fe-9e2d-1b5c2a6744eb', 98, 'Shivam Mavi', 'Sunrisers Hyderabad', 'Bowler', 'BOWL', 'BOWL', 'C', 66, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/12345/shivam-mavi', 32.0, NULL, NULL, NULL, 30.0, 8.71, 31.4, NULL, NULL, NULL, 46, 23.0, 60.0, 71.0, NULL, NULL, NULL),
('f1ad9048-e5de-4a64-94f7-118c5df18b18', 109, 'Abdul Samad', 'Lucknow Super Giants', 'Batting Allrounder', 'AR', 'AR', 'C', 63, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/14628/abdul-samad', 63.0, 741.0, NULL, NULL, 2.0, NULL, NULL, NULL, NULL, NULL, 61, NULL, NULL, NULL, 57.0, 5.0, 5.0),
('9326eb26-70c0-465b-a701-3eeea27d246c', 38, 'Shardul Thakur', 'Mumbai Indians', 'Bowling Allrounder', 'AR', 'AR', 'B', 78, 'INDIAN', 'Indian', 1, true, 6, 'https://www.cricbuzz.com/profiles/8683/shardul-thakur', 105.0, 325.0, NULL, NULL, 107.0, NULL, NULL, NULL, NULL, NULL, 82, NULL, NULL, NULL, 38.0, 59.0, 38.0),
('0783fe0d-f72e-4212-8907-32e8f43561a0', 61, 'Travis Head', 'Sunrisers Hyderabad', 'Batsman', 'BAT', 'BAT_WK', 'B', 72, 'OVERSEAS', 'Australian', 1, false, 0, 'https://www.cricbuzz.com/profiles/8497/travis-head', 38.0, 1146.0, 170.03, 34.73, NULL, NULL, NULL, 25.0, 92.0, 86.0, 49, NULL, NULL, NULL, NULL, NULL, NULL),
('163c8ee6-8458-4264-8b66-dbfcce8b920b', 8, 'MS Dhoni', 'Chennai Super Kings', 'WK-Batsman', 'WK', 'BAT_WK', 'A', 95, 'INDIAN', 'Indian', 2, false, 4, 'https://www.cricbuzz.com/profiles/265/ms-dhoni', 278.0, 5439.0, 137.46, 38.3, NULL, NULL, NULL, 99.0, 70.0, 95.0, 99, NULL, NULL, NULL, NULL, NULL, NULL),
('dac87d19-e4c2-46bd-83b9-b43b31f31fbf', 82, 'Jitesh Sharma', 'Royal Challengers Bengaluru', 'WK-Batsman', 'WK', 'BAT_WK', 'C', 68, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/10214/jitesh-sharma', 55.0, 991.0, 157.06, 25.41, NULL, NULL, NULL, 22.0, 83.0, 63.0, 57, NULL, NULL, NULL, NULL, NULL, NULL),
('e96ac5f0-98b4-43dd-bcf2-15d9f5878ec4', 139, 'Nandre Burger', 'Rajasthan Royals', 'Bowler', 'BOWL', 'BOWL', 'C', 58, 'OVERSEAS', 'South African', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/13630/nandre-burger', 5.0, NULL, NULL, NULL, 7.0, 8.53, 20.71, NULL, NULL, NULL, 32, 8.0, 63.0, 94.0, NULL, NULL, NULL),
('80141903-597b-494c-8e3a-2aa9833b60e1', 101, 'Umran Malik', 'Kolkata Knight Riders', 'Bowler', 'BOWL', 'BOWL', 'C', 65, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/19027/umran-malik', 26.0, NULL, NULL, NULL, 29.0, 9.4, 26.62, NULL, NULL, NULL, 43, 22.0, 49.0, 81.0, NULL, NULL, NULL),
('3820abf7-2910-4909-8f33-67905ffab53c', 55, 'Mitchell Starc', 'Delhi Capitals', 'Bowler', 'BOWL', 'BOWL', 'B', 73, 'OVERSEAS', 'Australian', 1, false, 0, 'https://www.cricbuzz.com/profiles/7710/mitchell-starc', 51.0, NULL, NULL, NULL, 65.0, 8.61, 23.12, NULL, NULL, NULL, 55, 45.0, 62.0, 88.0, NULL, NULL, NULL),
('190b3b57-85c2-40ff-9294-eedd5a0e7115', 48, 'Pat Cummins', 'Sunrisers Hyderabad', 'Bowler', 'BOWL', 'BOWL', 'B', 75, 'OVERSEAS', 'Australian', 1, false, 0, 'https://www.cricbuzz.com/profiles/8095/pat-cummins', 72.0, NULL, NULL, NULL, 79.0, 8.81, 30.04, NULL, NULL, NULL, 66, 54.0, 59.0, 74.0, NULL, NULL, NULL),
('19a6a3de-1d0d-4279-89cc-edc7a2a1d89d', 11, 'Sandeep Sharma', 'Rajasthan Royals', 'Bowler', 'BOWL', 'BOWL', 'A', 93, 'INDIAN', 'Indian', 2, false, 4, 'https://www.cricbuzz.com/profiles/8356/sandeep-sharma', 136.0, NULL, NULL, NULL, 146.0, 8.03, 27.88, NULL, NULL, NULL, 98, 98.0, 71.0, 78.0, NULL, NULL, NULL),
('9df284ca-c947-4e48-8970-998e3c948a9b', 84, 'Cameron Green', 'Kolkata Knight Riders', 'Batting Allrounder', 'AR', 'AR', 'C', 68, 'OVERSEAS', 'Australian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/12225/cameron-green', 29.0, 707.0, NULL, NULL, 16.0, NULL, NULL, NULL, NULL, NULL, 44, NULL, NULL, NULL, 64.0, 27.0, 27.0),
('d940d5a1-7117-4226-a38a-8ac10548232e', 142, 'Kamindu Mendis', 'Sunrisers Hyderabad', 'Batting Allrounder', 'AR', 'AR', 'C', 57, 'OVERSEAS', 'Sri Lankan', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/10940/kamindu-mendis', 5.0, 92.0, NULL, NULL, 2.0, NULL, NULL, NULL, NULL, NULL, 32, NULL, NULL, NULL, 38.0, 29.0, 29.0),
('410ee106-be15-4af3-8ac7-b601b16038db', 68, 'Anrich Nortje', 'Lucknow Super Giants', 'Bowler', 'BOWL', 'BOWL', 'B', 71, 'OVERSEAS', 'South African', 1, false, 0, 'https://www.cricbuzz.com/profiles/11427/anrich-nortje', 48.0, NULL, NULL, NULL, 61.0, 9.07, 27.16, NULL, NULL, NULL, 54, 43.0, 55.0, 80.0, NULL, NULL, NULL),
('756c5e9e-8d73-4cfc-8b18-8a455c6ab156', 132, 'Kuldeep Sen', 'Rajasthan Royals', 'Bowler', 'BOWL', 'BOWL', 'C', 59, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/14336/kuldeep-sen', 12.0, NULL, NULL, NULL, 14.0, 9.63, 27.64, NULL, NULL, NULL, 36, 12.0, 45.0, 79.0, NULL, NULL, NULL),
('a0cb483f-d299-4093-af0f-c18ac9f615ae', 95, 'Nehal Wadhera', 'Punjab Kings', 'Batsman', 'BAT', 'BAT_WK', 'C', 66, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/13915/nehal-wadhera', 36.0, 719.0, 142.95, 26.63, NULL, NULL, NULL, 17.0, 73.0, 66.0, 48, NULL, NULL, NULL, NULL, NULL, NULL),
('132ee79c-e821-4416-bc4f-3dd511f2c0d9', 72, 'Aiden Markram', 'Lucknow Super Giants', 'Batsman', 'BAT', 'BAT_WK', 'B', 70, 'OVERSEAS', 'South African', 1, false, 0, 'https://www.cricbuzz.com/profiles/9582/aiden-markram', 57.0, 1440.0, 135.09, 31.3, NULL, NULL, NULL, 30.0, 68.0, 78.0, 58, NULL, NULL, NULL, NULL, NULL, NULL),
('f4050e18-f991-4ae0-9a67-6dc2ccb820bd', 10, 'Harshal Patel', 'Sunrisers Hyderabad', 'Bowler', 'BOWL', 'BOWL', 'A', 94, 'INDIAN', 'Indian', 2, false, 6, 'https://www.cricbuzz.com/profiles/8175/harshal-patel', 119.0, NULL, NULL, NULL, 151.0, 8.86, 23.7, NULL, NULL, NULL, 89, 99.0, 58.0, 87.0, NULL, NULL, NULL),
('def79e7d-a639-4df6-9f36-d17657defb94', 58, 'Riyan Parag', 'Rajasthan Royals', 'Batting Allrounder', 'AR', 'AR', 'B', 73, 'INDIAN', 'Indian', 1, false, 2, 'https://www.cricbuzz.com/profiles/12305/riyan-parag', 83.0, 1566.0, NULL, NULL, 7.0, NULL, NULL, NULL, NULL, NULL, 71, NULL, NULL, NULL, 78.0, 16.0, 16.0),
('5995601a-9149-410f-8536-9d618f3d1bff', 80, 'Lockie Ferguson', 'Punjab Kings', 'Bowler', 'BOWL', 'BOWL', 'C', 69, 'OVERSEAS', 'New Zealander', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/10692/lockie-ferguson', 49.0, NULL, NULL, NULL, 51.0, 8.97, 30.0, NULL, NULL, NULL, 54, 36.0, 56.0, 74.0, NULL, NULL, NULL),
('f61efa3e-aeba-4d43-a2eb-92feb8c56316', 31, 'Manish Pandey', 'Kolkata Knight Riders', 'Batsman', 'BAT', 'BAT_WK', 'B', 82, 'INDIAN', 'Indian', 1, false, 0, 'https://www.cricbuzz.com/profiles/1836/manish-pandey', 174.0, 3942.0, 121.52, 29.42, NULL, NULL, NULL, 76.0, 59.0, 73.0, 99, NULL, NULL, NULL, NULL, NULL, NULL),
('2c7ea4ef-98da-4dcb-b6fd-f96580af7aae', 81, 'Harpreet Brar', 'Punjab Kings', 'Bowler', 'BOWL', 'BOWL', 'C', 68, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/14452/harpreet-brar', 49.0, NULL, NULL, NULL, 35.0, 8.03, 31.0, NULL, NULL, NULL, 54, 26.0, 71.0, 72.0, NULL, NULL, NULL),
('7170d9f9-0e93-40db-aa6e-dd1be1f2b095', 57, 'Jofra Archer', 'Rajasthan Royals', 'Bowler', 'BOWL', 'BOWL', 'B', 73, 'OVERSEAS', 'English', 1, false, 0, 'https://www.cricbuzz.com/profiles/11540/jofra-archer', 52.0, NULL, NULL, NULL, 59.0, 7.89, 27.15, NULL, NULL, NULL, 56, 41.0, 74.0, 80.0, NULL, NULL, NULL),
('cdecd8c1-bff6-48b0-a092-fe000b9b1ca2', 28, 'Kuldeep Yadav', 'Delhi Capitals', 'Bowler', 'BOWL', 'BOWL', 'B', 83, 'INDIAN', 'Indian', 1, false, 2, 'https://www.cricbuzz.com/profiles/8292/kuldeep-yadav', 98.0, NULL, NULL, NULL, 102.0, 8.04, 26.95, NULL, NULL, NULL, 79, 69.0, 71.0, 80.0, NULL, NULL, NULL),
('22a44b4a-0732-4bcf-9566-a60c1b45c6ca', 155, 'Swapnil Singh', 'Royal Challengers Bengaluru', 'Bowling Allrounder', 'AR', 'AR', 'C', 56, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/10238/swapnil-singh', 14.0, 51.0, NULL, NULL, 7.0, NULL, NULL, NULL, NULL, NULL, 37, NULL, NULL, NULL, 23.0, 27.0, 23.0),
('7fbde295-ddc5-41f2-bff8-98dbcc348fb2', 159, 'Rasikh Dar Salam', 'Royal Challengers Bengaluru', 'Bowler', 'BOWL', 'BOWL', 'C', 55, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/14274/rasikh-dar-salam', 13.0, NULL, NULL, NULL, 10.0, 10.62, 40.9, NULL, NULL, NULL, 36, 10.0, 29.0, 51.0, NULL, NULL, NULL),
('1ff072e8-8237-4c4b-ab9e-57313d708c53', 63, 'T Natarajan', 'Delhi Capitals', 'Bowler', 'BOWL', 'BOWL', 'B', 72, 'INDIAN', 'Indian', 1, false, 0, 'https://www.cricbuzz.com/profiles/10225/t-natarajan', 63.0, NULL, NULL, NULL, 67.0, 8.94, 30.12, NULL, NULL, NULL, 61, 47.0, 57.0, 74.0, NULL, NULL, NULL),
('3d20b9a1-e613-4957-a071-b7624654925d', 66, 'Philip Salt', 'Royal Challengers Bengaluru', 'WK-Batsman', 'WK', 'BAT_WK', 'B', 71, 'OVERSEAS', 'English', 1, false, 0, 'https://www.cricbuzz.com/profiles/10479/philip-salt', 34.0, 1056.0, 175.71, 34.06, NULL, NULL, NULL, 23.0, 95.0, 84.0, 47, NULL, NULL, NULL, NULL, NULL, NULL),
('e4f4a3f8-cea4-4427-bd96-1071ce873526', 34, 'Quinton de Kock', 'Mumbai Indians', 'WK-Batsman', 'WK', 'BAT_WK', 'B', 79, 'OVERSEAS', 'South African', 1, false, 0, 'https://www.cricbuzz.com/profiles/8520/quinton-de-kock', 115.0, 3309.0, 134.03, 30.64, NULL, NULL, NULL, 64.0, 67.0, 76.0, 87, NULL, NULL, NULL, NULL, NULL, NULL),
('6eef28a4-5e1e-435d-a974-fd6512d8aca7', 126, 'Nathan Ellis', 'Chennai Super Kings', 'Bowler', 'BOWL', 'BOWL', 'C', 61, 'OVERSEAS', 'Australian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/15480/nathan-ellis', 17.0, NULL, NULL, NULL, 19.0, 8.67, 28.74, NULL, NULL, NULL, 38, 16.0, 61.0, 77.0, NULL, NULL, NULL),
('516232b8-f2ed-436c-a1e7-f1dec38bddb3', 96, 'Vaibhav Arora', 'Kolkata Knight Riders', 'Bowler', 'BOWL', 'BOWL', 'C', 66, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/15861/vaibhav-arora', 32.0, NULL, NULL, NULL, 36.0, 9.55, 28.22, NULL, NULL, NULL, 46, 27.0, 47.0, 78.0, NULL, NULL, NULL),
('074d5745-9aaa-4b33-b987-7f30a2ac465e', 110, 'Josh Inglis', 'Lucknow Super Giants', 'WK-Batsman', 'WK', 'BAT_WK', 'C', 63, 'OVERSEAS', 'Australian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/10637/josh-inglis', 11.0, 278.0, 162.58, 30.89, NULL, NULL, NULL, 9.0, 87.0, 77.0, 35, NULL, NULL, NULL, NULL, NULL, NULL),
('f62730f6-5898-4004-b05a-cf92377b2f62', 36, 'Arshdeep Singh', 'Punjab Kings', 'Bowler', 'BOWL', 'BOWL', 'B', 78, 'INDIAN', 'Indian', 1, false, 0, 'https://www.cricbuzz.com/profiles/13217/arshdeep-singh', 82.0, NULL, NULL, NULL, 97.0, 9.0, 26.49, NULL, NULL, NULL, 71, 66.0, 56.0, 81.0, NULL, NULL, NULL),
('1a4f479c-c606-4ab3-9107-ba63805cd068', 148, 'Vignesh Puthur', 'Rajasthan Royals', 'Bowler', 'BOWL', 'BOWL', 'C', 57, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/1447337/vignesh-puthur', 5.0, NULL, NULL, NULL, 6.0, 9.08, 18.17, NULL, NULL, NULL, 32, 7.0, 54.0, 99.0, NULL, NULL, NULL),
('eb2907d1-410c-4613-94f2-0daec059b24a', 13, 'Axar Patel', 'Delhi Capitals', 'Bowling Allrounder', 'AR', 'AR', 'A', 91, 'INDIAN', 'Indian', 2, false, 6, 'https://www.cricbuzz.com/profiles/8808/axar-patel', 162.0, 1916.0, NULL, NULL, 128.0, NULL, NULL, NULL, NULL, NULL, 99, NULL, NULL, NULL, 82.0, 72.0, 72.0),
('bf206479-5333-4790-947a-dbd355f8df05', 127, 'Digvesh Singh Rathi', 'Lucknow Super Giants', 'Bowler', 'BOWL', 'BOWL', 'C', 61, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/1448289/digvesh-singh-rathi', 13.0, NULL, NULL, NULL, 14.0, 8.25, 30.64, NULL, NULL, NULL, 36, 12.0, 68.0, 72.0, NULL, NULL, NULL),
('fa5f6de7-4342-48aa-a429-b7c28bbbaba8', 153, 'Urvil Patel', 'Chennai Super Kings', 'WK-Batsman', 'WK', 'BAT_WK', 'C', 56, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/13476/urvil-patel', 3.0, 68.0, 212.5, 22.67, NULL, NULL, NULL, 5.0, 99.0, 57.0, 31, NULL, NULL, NULL, NULL, NULL, NULL),
('3a9c7846-767f-49eb-8828-ea7951eb4fb7', 50, 'Mitchell Marsh', 'Lucknow Super Giants', 'Batting Allrounder', 'AR', 'AR', 'B', 74, 'OVERSEAS', 'Australian', 1, false, 0, 'https://www.cricbuzz.com/profiles/6250/mitchell-marsh', 55.0, 1292.0, NULL, NULL, 37.0, NULL, NULL, NULL, NULL, NULL, 57, NULL, NULL, NULL, 72.0, 43.0, 43.0),
('d03489f2-a4b4-494b-b671-d2b69c4318f5', 9, 'KL Rahul', 'Delhi Capitals', 'WK-Batsman', 'WK', 'BAT_WK', 'A', 95, 'INDIAN', 'Indian', 2, false, 4, 'https://www.cricbuzz.com/profiles/8733/kl-rahul', 145.0, 5222.0, 136.03, 46.21, NULL, NULL, NULL, 99.0, 69.0, 99.0, 99, NULL, NULL, NULL, NULL, NULL, NULL),
('d389be2b-585a-4db6-ba28-f6bcd1b3076e', 133, 'Kyle Jamieson', 'Delhi Capitals', 'Bowler', 'BOWL', 'BOWL', 'C', 59, 'OVERSEAS', 'New Zealander', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/9441/kyle-jamieson', 13.0, NULL, NULL, NULL, 14.0, 9.67, 29.71, NULL, NULL, NULL, 36, 12.0, 45.0, 74.0, NULL, NULL, NULL),
('5c7dd905-f73e-4344-85cd-bdbf2520dd6f', 136, 'Arshad Khan', 'Gujarat Titans', 'Bowling Allrounder', 'AR', 'AR', 'C', 58, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/18637/arshad-khan', 19.0, 124.0, NULL, NULL, 12.0, NULL, NULL, NULL, NULL, NULL, 39, NULL, NULL, NULL, 39.0, 18.0, 18.0),
('e4201fbb-2fec-4084-9629-9750c82d32f2', 83, 'Jason Holder', 'Gujarat Titans', 'Bowling Allrounder', 'AR', 'AR', 'C', 68, 'OVERSEAS', 'West Indian', 0.5, false, 2, 'https://www.cricbuzz.com/profiles/8313/jason-holder', 46.0, 259.0, NULL, NULL, 53.0, NULL, NULL, NULL, NULL, NULL, 53, NULL, NULL, NULL, 32.0, 45.0, 32.0),
('61ca7ce1-d2e2-4a59-a9e0-b2f8c39f2cef', 74, 'Devdutt Padikkal', 'Royal Challengers Bengaluru', 'Batsman', 'BAT', 'BAT_WK', 'B', 70, 'INDIAN', 'Indian', 1, false, 0, 'https://www.cricbuzz.com/profiles/13088/devdutt-padikkal', 74.0, 1806.0, 126.3, 25.44, NULL, NULL, NULL, 37.0, 62.0, 64.0, 67, NULL, NULL, NULL, NULL, NULL, NULL),
('9b8d3ccc-97d2-49d6-99d8-cee9a1f0b737', 59, 'Rahul Tewatia', 'Gujarat Titans', 'Batting Allrounder', 'AR', 'AR', 'B', 73, 'INDIAN', 'Indian', 1, false, 0, 'https://www.cricbuzz.com/profiles/9693/rahul-tewatia', 108.0, 1112.0, NULL, NULL, 32.0, NULL, NULL, NULL, NULL, NULL, 84, NULL, NULL, NULL, 64.0, 38.0, 38.0),
('f6f136c7-3a4b-4add-bc60-f01c848a62f2', 60, 'Noor Ahmad', 'Chennai Super Kings', 'Bowler', 'BOWL', 'BOWL', 'B', 72, 'OVERSEAS', 'Afghan', 1, false, 0, 'https://www.cricbuzz.com/profiles/15452/noor-ahmad', 37.0, NULL, NULL, NULL, 48.0, 8.08, 22.23, NULL, NULL, NULL, 48, 34.0, 71.0, 90.0, NULL, NULL, NULL),
('3a4a0b77-b80e-4901-b2ce-69a2a48dffc5', 20, 'Jos Buttler', 'Gujarat Titans', 'WK-Batsman', 'WK', 'BAT_WK', 'A', 88, 'OVERSEAS', 'English', 2, false, 2, 'https://www.cricbuzz.com/profiles/2258/jos-buttler', 121.0, 4120.0, 149.39, 40.0, NULL, NULL, NULL, 79.0, 78.0, 99.0, 90, NULL, NULL, NULL, NULL, NULL, NULL),
('4acb0513-6b98-42a0-b28d-8f3c55dcc61d', 113, 'Marco Jansen', 'Punjab Kings', 'Bowling Allrounder', 'AR', 'AR', 'C', 62, 'OVERSEAS', 'South African', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/14565/marco-jansen', 35.0, 141.0, NULL, NULL, 36.0, NULL, NULL, NULL, NULL, NULL, 47, NULL, NULL, NULL, 26.0, 36.0, 26.0),
('a9854f8d-fd4c-4a47-b428-8f9850a121c3', 102, 'Angkrish Raghuvanshi', 'Kolkata Knight Riders', 'Batsman', 'BAT', 'BAT_WK', 'C', 65, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/22566/angkrish-raghuvanshi', 22.0, 463.0, 144.69, 28.94, NULL, NULL, NULL, 12.0, 75.0, 72.0, 41, NULL, NULL, NULL, NULL, NULL, NULL),
('9d9595af-dba8-440c-8eb5-3daf7436f60a', 14, 'Ajinkya Rahane', 'Kolkata Knight Riders', 'Batsman', 'BAT', 'BAT_WK', 'A', 91, 'INDIAN', 'Indian', 2, false, 4, 'https://www.cricbuzz.com/profiles/1447/ajinkya-rahane', 198.0, 5032.0, 125.02, 30.5, NULL, NULL, NULL, 95.0, 61.0, 76.0, 99, NULL, NULL, NULL, NULL, NULL, NULL),
('8084292b-dd8c-4f63-8e07-74114021db25', 52, 'Rahul Tripathi', 'Kolkata Knight Riders', 'Batsman', 'BAT', 'BAT_WK', 'B', 74, 'INDIAN', 'Indian', 1, false, 0, 'https://www.cricbuzz.com/profiles/9012/rahul-tripathi', 100.0, 2291.0, 137.85, 26.03, NULL, NULL, NULL, 46.0, 70.0, 65.0, 80, NULL, NULL, NULL, NULL, NULL, NULL),
('06c5d51b-18bc-43e0-80fb-6adde8124f58', 106, 'Sarfaraz Khan', 'Chennai Super Kings', 'Batsman', 'BAT', 'BAT_WK', 'C', 64, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/9429/sarfaraz-khan', 50.0, 585.0, 130.59, 22.5, NULL, NULL, NULL, 15.0, 65.0, 56.0, 55, NULL, NULL, NULL, NULL, NULL, NULL),
('284d3aaf-e83c-4616-b05c-ec7dae571a91', 4, 'Sunil Narine', 'Kolkata Knight Riders', 'Bowling Allrounder', 'AR', 'AR', 'A', 98, 'OVERSEAS', 'West Indian', 2, false, 10, 'https://www.cricbuzz.com/profiles/2276/sunil-narine', 188.0, 1780.0, NULL, NULL, 192.0, NULL, NULL, NULL, NULL, NULL, 99, NULL, NULL, NULL, 84.0, 83.0, 83.0),
('ce8ba8bd-7880-4b98-9aa5-140fba69aaa0', 79, 'Prabhsimran Singh', 'Punjab Kings', 'WK-Batsman', 'WK', 'BAT_WK', 'C', 69, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/14254/prabhsimran-singh', 51.0, 1305.0, 151.93, 25.59, NULL, NULL, NULL, 28.0, 79.0, 64.0, 55, NULL, NULL, NULL, NULL, NULL, NULL),
('87d82d36-b1f1-474c-b23d-68e9e26d87e0', 144, 'Vijaykumar Vyshak', 'Punjab Kings', 'Bowler', 'BOWL', 'BOWL', 'C', 57, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/10486/vijaykumar-vyshak', 16.0, NULL, NULL, NULL, 17.0, 10.38, 33.88, NULL, NULL, NULL, 38, 14.0, 33.0, 66.0, NULL, NULL, NULL),
('a5b2f522-bd11-4cd8-b7c5-f16ad4e84be5', 46, 'Avesh Khan', 'Lucknow Super Giants', 'Bowler', 'BOWL', 'BOWL', 'B', 76, 'INDIAN', 'Indian', 1, false, 0, 'https://www.cricbuzz.com/profiles/9781/avesh-khan', 75.0, NULL, NULL, NULL, 87.0, 9.12, 28.29, NULL, NULL, NULL, 67, 60.0, 54.0, 77.0, NULL, NULL, NULL),
('0124e042-c267-4f47-bc7a-b4759fb892d7', 22, 'Kagiso Rabada', 'Gujarat Titans', 'Bowler', 'BOWL', 'BOWL', 'A', 85, 'OVERSEAS', 'South African', 2, false, 2, 'https://www.cricbuzz.com/profiles/9585/kagiso-rabada', 84.0, NULL, NULL, NULL, 119.0, 8.62, 22.96, NULL, NULL, NULL, 72, 80.0, 62.0, 89.0, NULL, NULL, NULL),
('d96c62a5-2db6-4170-998c-c710ffd06960', 51, 'Sam Curran', 'Rajasthan Royals', 'Bowling Allrounder', 'AR', 'AR', 'B', 74, 'OVERSEAS', 'English', 1, false, 2, 'https://www.cricbuzz.com/profiles/10420/sam-curran', 64.0, 997.0, NULL, NULL, 59.0, NULL, NULL, NULL, NULL, NULL, 62, NULL, NULL, NULL, 62.0, 41.0, 41.0),
('b43bece5-dd20-4abb-b5b7-50c8dba1f517', 45, 'Shivam Dube', 'Chennai Super Kings', 'Batting Allrounder', 'AR', 'AR', 'B', 76, 'INDIAN', 'Indian', 1, false, 2, 'https://www.cricbuzz.com/profiles/11195/shivam-dube', 79.0, 1859.0, NULL, NULL, 5.0, NULL, NULL, NULL, NULL, NULL, 69, NULL, NULL, NULL, 88.0, 20.0, 20.0),
('ce4db6a2-7fcb-4038-b111-f93bc1c61fa2', 147, 'Mayank Yadav', 'Lucknow Super Giants', 'Bowler', 'BOWL', 'BOWL', 'C', 57, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/22401/mayank-yadav', 6.0, NULL, NULL, NULL, 9.0, 9.17, 20.56, NULL, NULL, NULL, 33, 9.0, 53.0, 94.0, NULL, NULL, NULL),
('fc44079f-2ea0-45e7-80e4-fa6e1c8df63a', 1, 'Virat Kohli', 'Royal Challengers Bengaluru', 'Batsman', 'BAT', 'BAT_WK', 'A', 99, 'INDIAN', 'Indian', 2, false, 10, 'https://www.cricbuzz.com/profiles/1413/virat-kohli', 267.0, 8661.0, 132.86, 39.55, NULL, NULL, NULL, 99.0, 67.0, 98.0, 99, NULL, NULL, NULL, NULL, NULL, NULL),
('cb7760bb-f38f-40a7-a58f-60edfb72153c', 33, 'Ishant Sharma', 'Gujarat Titans', 'Bowler', 'BOWL', 'BOWL', 'B', 79, 'INDIAN', 'Indian', 1, false, 0, 'https://www.cricbuzz.com/profiles/702/ishant-sharma', 117.0, NULL, NULL, NULL, 96.0, 8.38, 35.18, NULL, NULL, NULL, 88, 65.0, 66.0, 63.0, NULL, NULL, NULL),
('1c09d5fe-d700-43fd-b471-3d6af9d70a32', 152, 'Anukul Roy', 'Kolkata Knight Riders', 'Batting Allrounder', 'AR', 'AR', 'C', 56, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/12344/anukul-roy', 11.0, 26.0, NULL, NULL, 6.0, NULL, NULL, NULL, NULL, NULL, 35, NULL, NULL, NULL, 17.0, 29.0, 17.0),
('0e068e36-87b1-4b0b-9c58-92e50a2f2b9c', 2, 'Yuzvendra Chahal', 'Punjab Kings', 'Bowler', 'BOWL', 'BOWL', 'A', 99, 'INDIAN', 'Indian', 2, false, 10, 'https://www.cricbuzz.com/profiles/7910/yuzvendra-chahal', 174.0, NULL, NULL, NULL, 221.0, 7.96, 22.77, NULL, NULL, NULL, 99, 99.0, 73.0, 89.0, NULL, NULL, NULL),
('4098b2a2-4dfe-461e-b04f-e16c5d3c63bb', 70, 'Venkatesh Iyer', 'Royal Challengers Bengaluru', 'Batting Allrounder', 'AR', 'AR', 'B', 70, 'INDIAN', 'Indian', 1, false, 0, 'https://www.cricbuzz.com/profiles/10917/venkatesh-iyer', 61.0, 1468.0, NULL, NULL, 3.0, NULL, NULL, NULL, NULL, NULL, 60, NULL, NULL, NULL, 77.0, 16.0, 16.0),
('7d5da845-bda1-456e-aaea-f6adf16ba29f', 107, 'Shahbaz Ahmed', 'Lucknow Super Giants', 'Bowling Allrounder', 'AR', 'AR', 'C', 64, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/14606/shahbaz-ahmed', 58.0, 545.0, NULL, NULL, 22.0, NULL, NULL, NULL, NULL, NULL, 59, NULL, NULL, NULL, 43.0, 27.0, 27.0),
('0508607b-e9c8-4d6c-806c-cbf71a29bafd', 121, 'Suyash Sharma', 'Royal Challengers Bengaluru', 'Bowler', 'BOWL', 'BOWL', 'C', 61, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/36487/suyash-sharma', 27.0, NULL, NULL, NULL, 18.0, 8.75, 45.22, NULL, NULL, NULL, 43, 15.0, 60.0, 41.0, NULL, NULL, NULL),
('31739372-487c-4cd1-848e-4d08d0a2a292', 62, 'Shimron Hetmyer', 'Rajasthan Royals', 'Batsman', 'BAT', 'BAT_WK', 'B', 72, 'OVERSEAS', 'West Indian', 1, false, 0, 'https://www.cricbuzz.com/profiles/9789/shimron-hetmyer', 86.0, 1482.0, 151.85, 29.06, NULL, NULL, NULL, 31.0, 79.0, 72.0, 73, NULL, NULL, NULL, NULL, NULL, NULL),
('5187c9d3-6dbe-4902-961b-931e71d6a21b', 99, 'Yash Dayal', 'Royal Challengers Bengaluru', 'Bowler', 'BOWL', 'BOWL', 'C', 66, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/14172/yash-dayal', 43.0, NULL, NULL, NULL, 41.0, 9.58, 33.9, NULL, NULL, NULL, 51, 30.0, 46.0, 66.0, NULL, NULL, NULL),
('d29f71b0-2b3e-43d3-a733-36b0bb0e4052', 35, 'Deepak Chahar', 'Mumbai Indians', 'Bowler', 'BOWL', 'BOWL', 'B', 78, 'INDIAN', 'Indian', 1, false, 0, 'https://www.cricbuzz.com/profiles/7836/deepak-chahar', 95.0, NULL, NULL, NULL, 88.0, 8.14, 29.51, NULL, NULL, NULL, 77, 60.0, 70.0, 75.0, NULL, NULL, NULL),
('6524c9bc-5936-43ea-a697-7fa54c90edfb', 89, 'Dhruv Jurel', 'Rajasthan Royals', 'WK-Batsman', 'WK', 'BAT_WK', 'C', 67, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/14691/dhruv-jurel', 41.0, 680.0, 153.85, 28.33, NULL, NULL, NULL, 16.0, 81.0, 71.0, 50, NULL, NULL, NULL, NULL, NULL, NULL),
('b6299e12-1362-4693-a1ed-1c4961f56cee', 92, 'Shashank Singh', 'Punjab Kings', 'Batting Allrounder', 'AR', 'AR', 'C', 67, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/10919/shashank-singh', 41.0, 773.0, NULL, NULL, 1.0, NULL, NULL, NULL, NULL, NULL, 50, NULL, NULL, NULL, 67.0, 14.0, 14.0),
('bd2de523-da32-487b-be22-051520387124', 128, 'Yash Thakur', 'Punjab Kings', 'Bowler', 'BOWL', 'BOWL', 'C', 61, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/12096/yash-thakur', 21.0, NULL, NULL, NULL, 25.0, 10.43, 30.8, NULL, NULL, NULL, 40, 20.0, 32.0, 72.0, NULL, NULL, NULL),
('04bcf327-5656-4164-a6ef-aff0f8d806de', 12, 'Trent Boult', 'Mumbai Indians', 'Bowler', 'BOWL', 'BOWL', 'A', 92, 'OVERSEAS', 'New Zealander', 2, false, 4, 'https://www.cricbuzz.com/profiles/8117/trent-boult', 119.0, NULL, NULL, NULL, 143.0, 8.38, 26.2, NULL, NULL, NULL, 89, 96.0, 66.0, 82.0, NULL, NULL, NULL),
('b3a13b70-7b72-46ba-9567-dbd14e8d1f40', 151, 'Dushmantha Chameera', 'Delhi Capitals', 'Bowler', 'BOWL', 'BOWL', 'C', 56, 'OVERSEAS', 'Sri Lankan', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/8393/dushmantha-chameera', 19.0, NULL, NULL, NULL, 13.0, 9.73, 46.38, NULL, NULL, NULL, 39, 12.0, 44.0, 39.0, NULL, NULL, NULL),
('056a2830-35e3-45d0-9f45-0bf3ce08234e', 76, 'Tristan Stubbs', 'Delhi Capitals', 'WK-Batsman', 'WK', 'BAT_WK', 'B', 70, 'OVERSEAS', 'South African', 1, false, 0, 'https://www.cricbuzz.com/profiles/19243/tristan-stubbs', 32.0, 705.0, 163.2, 41.47, NULL, NULL, NULL, 17.0, 87.0, 99.0, 46, NULL, NULL, NULL, NULL, NULL, NULL),
('7c165361-5133-4d92-a328-6497326ea06c', 111, 'Ryan Rickelton', 'Mumbai Indians', 'WK-Batsman', 'WK', 'BAT_WK', 'C', 62, 'OVERSEAS', 'South African', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/13070/ryan-rickelton', 14.0, 388.0, 150.98, 29.85, NULL, NULL, NULL, 11.0, 79.0, 74.0, 37, NULL, NULL, NULL, NULL, NULL, NULL),
('e9223148-5e87-4933-abcd-63ec1f2c41b6', 21, 'Krunal Pandya', 'Royal Challengers Bengaluru', 'Batting Allrounder', 'AR', 'AR', 'A', 86, 'INDIAN', 'Indian', 2, false, 4, 'https://www.cricbuzz.com/profiles/11311/krunal-pandya', 142.0, 1748.0, NULL, NULL, 93.0, NULL, NULL, NULL, NULL, NULL, 99, NULL, NULL, NULL, 77.0, 60.0, 60.0),
('9378ea57-95d6-471b-9ba5-81fff21ec73e', 67, 'Ayush Badoni', 'Lucknow Super Giants', 'Batting Allrounder', 'AR', 'AR', 'B', 71, 'INDIAN', 'Indian', 1, false, 0, 'https://www.cricbuzz.com/profiles/13907/ayush-badoni', 56.0, 963.0, NULL, NULL, 4.0, NULL, NULL, NULL, NULL, NULL, 58, NULL, NULL, NULL, 63.0, 37.0, 37.0),
('95cdc3ed-f43f-4a73-9430-32b8db083f2e', 64, 'Shreyas Gopal', 'Chennai Super Kings', 'Bowler', 'BOWL', 'BOWL', 'B', 72, 'INDIAN', 'Indian', 1, false, 0, 'https://www.cricbuzz.com/profiles/9746/shreyas-gopal', 52.0, NULL, NULL, NULL, 52.0, 8.16, 25.92, NULL, NULL, NULL, 56, 37.0, 69.0, 83.0, NULL, NULL, NULL),
('f8d0d056-cf9d-480e-b554-2f5a14cd7109', 30, 'Rishabh Pant', 'Lucknow Super Giants', 'WK-Batsman', 'WK', 'BAT_WK', 'B', 82, 'INDIAN', 'Indian', 1, false, 0, 'https://www.cricbuzz.com/profiles/10744/rishabh-pant', 125.0, 3553.0, 147.62, 34.16, NULL, NULL, NULL, 68.0, 76.0, 85.0, 92, NULL, NULL, NULL, NULL, NULL, NULL),
('b0f1f8ee-0c62-48ec-b774-d0303c722af6', 85, 'Mohsin Khan', 'Lucknow Super Giants', 'Bowler', 'BOWL', 'BOWL', 'C', 67, 'INDIAN', 'Indian', 0.5, true, 0, 'https://www.cricbuzz.com/profiles/13534/mohsin-khan', 24.0, NULL, NULL, NULL, 27.0, 8.51, 25.52, NULL, NULL, NULL, 42, 21.0, 64.0, 83.0, NULL, NULL, NULL),
('8e9af420-d019-41bc-af45-eb5d9daed513', 6, 'Rohit Sharma', 'Mumbai Indians', 'Batsman', 'BAT', 'BAT_WK', 'A', 96, 'INDIAN', 'Indian', 2, false, 8, 'https://www.cricbuzz.com/profiles/576/rohit-sharma', 272.0, 7046.0, 132.1, 29.73, NULL, NULL, NULL, 99.0, 66.0, 74.0, 99, NULL, NULL, NULL, NULL, NULL, NULL),
('aec8bca4-e68d-4ad1-96b5-431491a5569f', 125, 'Vaibhav Suryavanshi', 'Rajasthan Royals', 'Batsman', 'BAT', 'BAT_WK', 'C', 61, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/51791/vaibhav-suryavanshi', 7.0, 252.0, 206.56, 36.0, NULL, NULL, NULL, 9.0, 99.0, 89.0, 33, NULL, NULL, NULL, NULL, NULL, NULL),
('71756fca-9f9b-4dac-8ad0-432ee1459353', 18, 'Rashid Khan', 'Gujarat Titans', 'Bowling Allrounder', 'AR', 'AR', 'A', 89, 'OVERSEAS', 'Afghan', 2, false, 8, 'https://www.cricbuzz.com/profiles/10738/rashid-khan', 136.0, 585.0, NULL, NULL, 158.0, NULL, NULL, NULL, NULL, NULL, 98, NULL, NULL, NULL, 51.0, 82.0, 51.0),
('a3534a44-b9f4-417a-a091-b91ea7accd34', 49, 'Ravi Bishnoi', 'Rajasthan Royals', 'Bowler', 'BOWL', 'BOWL', 'B', 75, 'INDIAN', 'Indian', 1, false, 0, 'https://www.cricbuzz.com/profiles/14659/ravi-bishnoi', 77.0, NULL, NULL, NULL, 72.0, 8.22, 31.07, NULL, NULL, NULL, 68, 50.0, 68.0, 72.0, NULL, NULL, NULL),
('6f686e5c-89ae-4d68-97d1-41f0c3a53fb2', 7, 'Ravindra Jadeja', 'Rajasthan Royals', 'Bowling Allrounder', 'AR', 'AR', 'A', 95, 'INDIAN', 'Indian', 2, false, 8, 'https://www.cricbuzz.com/profiles/587/ravindra-jadeja', 254.0, 3260.0, NULL, NULL, 170.0, NULL, NULL, NULL, NULL, NULL, 99, NULL, NULL, NULL, 85.0, 78.0, 78.0),
('a0ffcdb4-9c0e-4cab-94d6-af79e0f97dfc', 24, 'Varun Chakaravarthy', 'Kolkata Knight Riders', 'Bowler', 'BOWL', 'BOWL', 'B', 84, 'INDIAN', 'Indian', 1, false, 2, 'https://www.cricbuzz.com/profiles/12926/varun-chakaravarthy', 83.0, NULL, NULL, NULL, 100.0, 7.58, 23.85, NULL, NULL, NULL, 71, 68.0, 79.0, 87.0, NULL, NULL, NULL),
('505f46d8-9df5-4537-bb5b-371ee1f49f9d', 146, 'Anshul Kamboj', 'Chennai Super Kings', 'Bowling Allrounder', 'AR', 'AR', 'C', 57, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/14598/anshul-kamboj', 11.0, 16.0, NULL, NULL, 10.0, NULL, NULL, NULL, NULL, NULL, 35, NULL, NULL, NULL, 21.0, 30.0, 21.0),
('73b14502-2f8e-4ab1-9201-6f76f3fb88a7', 3, 'Jasprit Bumrah', 'Mumbai Indians', 'Bowler', 'BOWL', 'BOWL', 'A', 99, 'INDIAN', 'Indian', 2, false, 8, 'https://www.cricbuzz.com/profiles/9311/jasprit-bumrah', 145.0, NULL, NULL, NULL, 183.0, 7.25, 22.03, NULL, NULL, NULL, 99, 99.0, 84.0, 91.0, NULL, NULL, NULL);

INSERT INTO "AuctionPlayer" (id, player_id, status) VALUES
('e00019f6-667e-4ba4-a330-41d3470f40a8', 'b51be22c-fee8-4a2a-951b-e22c7b0ca573', 'UNSOLD'),
('957a8793-62b7-4ef7-95fd-a8df6524f9b7', '5bbe4b7b-95e9-48f7-ba37-96cb70044f46', 'UNSOLD'),
('6b1c6769-3553-4bff-86eb-40ed9d873db6', '40891aa1-e5ae-436f-9305-85c18f06d726', 'UNSOLD'),
('5e65bf9f-a713-4513-b8fd-e257c5004249', '62cdf92e-ece2-4d26-94c7-63ae97994d93', 'UNSOLD'),
('1765ec2e-5c5a-43cc-b7f9-9e3358c1a995', '550cd8f0-f658-46ee-a9cc-4e51b314742d', 'UNSOLD'),
('c707d6e3-56c3-4a1d-a662-261a16df16bf', '5102b994-1756-4cbc-bbcc-ed58a876b90a', 'UNSOLD'),
('2ffcc71a-11f2-47da-8d0d-276ea9f8385c', 'a4bc4f7f-dcd1-44c8-b2a4-b35af590e780', 'UNSOLD'),
('1aea8519-6947-4c97-b33c-83e64046f075', '70dacb37-b3e5-4412-9eb0-09cefb0b7e93', 'UNSOLD'),
('ebba3918-d084-4e14-9cbd-d88343c53688', '7d0d1f21-6102-4702-b7d7-0d2f65e1c6fd', 'UNSOLD'),
('1a011ec2-7249-48e2-9a2c-cf238df04ae3', 'dfe1f4d7-54a9-4ab5-b92f-9909f021acbc', 'UNSOLD'),
('2e1ecdec-1081-4aef-86ec-87e17b89d22f', '8b5cff79-2753-4475-95c2-48a152d61a93', 'UNSOLD'),
('73e2a18f-ec87-49df-8900-e012de1bb1e3', 'f411e109-f403-4215-b2aa-321cec10a197', 'UNSOLD'),
('6f546ad3-21e1-4dad-aee7-73f609a8cf37', '6ab761a9-0dd7-431a-a944-db880b1ad6b2', 'UNSOLD'),
('3a41087a-c2f6-4b0f-9ac1-74d6438f2b22', 'a71af688-4c1a-4f47-b24f-ed19ad35cd25', 'UNSOLD'),
('c4003d4c-45d2-4eec-8659-292467f1a7f4', '54ccb7a4-bf00-4019-b2eb-d64b8d2e9e2a', 'UNSOLD'),
('9c4f188f-c891-4245-9fd5-495ab29f8f78', '51c33aca-5e9d-4de6-9dba-c49d021bf248', 'UNSOLD'),
('c5b03dbe-80a1-48e2-999f-2458d3e22c01', '53d9dc29-2f08-4668-9985-482da7f57409', 'UNSOLD'),
('f96ee3f2-db1a-45f8-aa25-4054a47410b0', '44ed33d4-9b0e-4bd3-b7dc-4990df80ce5e', 'UNSOLD'),
('49a19afc-2c00-4aea-8fa3-3d6e931dc160', '55301671-26ed-49db-bc10-5a35dd34aced', 'UNSOLD'),
('cd42cbd6-effb-4133-a525-d5f984f057c8', '73628791-56a7-42dd-9d4d-96f1f266b475', 'UNSOLD'),
('866bca8c-0d6b-4ae1-af2b-dbc335b0453a', '42b59ef3-ed72-42da-8c49-fc0ed0120699', 'UNSOLD'),
('da681c21-c764-419c-b62b-68a9f732c975', 'f1157cf6-39a5-4b54-aee3-988cb3e98cf8', 'UNSOLD'),
('edfd2fbd-92f6-44e2-9ac4-5ad98225a93c', 'f2c81381-d8b7-4443-a845-349a485eea45', 'UNSOLD'),
('8c5caa64-9640-4afc-9c6c-5c4efe011c83', 'c5b0a05f-32cf-43de-a19b-ff4317860280', 'UNSOLD'),
('36e03841-e37a-417e-9fa9-2e0a8a610cd3', 'ed581503-eadf-4aa8-8b90-d4ddb65af4e6', 'UNSOLD'),
('73999e18-2237-40dc-b07b-37a8a34155a6', 'fd99773e-bbb8-4afc-aaff-a13346047276', 'UNSOLD'),
('55c6be39-b7f8-4d40-9d71-f83562fe24d7', 'af8fe6af-f1ac-4fed-8140-6cb73f717854', 'UNSOLD'),
('6e27d916-cfdb-4102-a2d0-0eb2c169df11', 'b5a95b4d-e236-4a82-850f-4f4959ca8c78', 'UNSOLD'),
('f3324bdd-e365-437c-9fc7-cfa2c025b018', 'f0b53946-31c5-409b-b835-47f9d9b9e85f', 'UNSOLD'),
('98bec4c7-5fea-483e-b08b-829f97814885', 'bca64a44-591c-4f1e-bf80-90038941d832', 'UNSOLD'),
('3c9a76d0-fe1e-4af9-865c-b8548f9a0ffe', 'e7070746-d8a5-41ae-95c5-9cd9dcf50b7c', 'UNSOLD'),
('dc62c066-f2ff-4e2a-9454-4597c5f20458', 'd955f490-60b0-4942-8e90-e1822d100ff6', 'UNSOLD'),
('33b4e9d0-5c60-4e31-aeee-6f49a94d46e0', '9652af8e-6184-48c6-9fde-e43fa8cbdfcc', 'UNSOLD'),
('ad7ac5a4-d0f0-4123-9d86-59c643b71d59', 'd4921bf6-daff-4a64-a66a-23f402804b95', 'UNSOLD'),
('d9b6069d-f5bd-4c19-9d6a-f3c26644e6a6', 'ceeb6beb-0f56-4675-ae27-49d333e0f91c', 'UNSOLD'),
('2ac0186b-3851-4dee-90d1-cf952c770b48', '6ec3a4fb-9127-497a-bb35-e9ae1c056a60', 'UNSOLD'),
('ccee5057-628d-4202-98a8-3de44d6ce286', 'f165ce8d-b108-4b98-9527-80221090831f', 'UNSOLD'),
('ed484d5d-af94-40ed-a789-75c96075d208', '55db0447-9c20-4001-b7de-6bf63c275395', 'UNSOLD'),
('1f3770ee-0bec-4af0-a27d-d63d5b490d00', '50023102-e6e7-4872-881b-7c1f18c10943', 'UNSOLD'),
('48398536-08b9-4e59-a1b7-2dfbcf9a9881', 'e905bdd0-cfaf-4e95-8f7b-f58e96ba1f81', 'UNSOLD'),
('b46d1859-9dd9-4231-9a64-fea914ea9a48', '5f00d758-c0ca-452b-82f2-ecf7090bc112', 'UNSOLD'),
('ea185b0c-a3ad-49d5-9ab1-fd747c01346a', '516214b4-958c-46ff-9a61-87c432a53675', 'UNSOLD'),
('265ba246-2399-490c-a41a-b1eabcc2765e', 'eae25ed9-0751-4503-8fa4-419a4172c4c1', 'UNSOLD'),
('ebd6d024-00df-417a-b854-27753acf6c49', '46519a92-8e5f-4491-b306-b55183f45298', 'UNSOLD'),
('f43b53b3-0885-4ea7-ac1d-5063f4c95ffb', 'acba9700-91e3-4e8b-9a80-bb85b3545004', 'UNSOLD'),
('4207b2f4-42f8-41f0-8150-4461ecd851fd', '78ac7792-186f-4a4f-bae6-e46617c96d5a', 'UNSOLD'),
('cff1f1ec-3df9-4287-9d4c-d99ab537cd37', 'f49e5da0-ba46-49ba-9cb8-740adf7b22da', 'UNSOLD'),
('92537a91-1b5b-42c4-9f34-f1985d71f4f7', '8a27be9f-f0d2-4902-9415-627dd5a67b56', 'UNSOLD'),
('e0ab57af-2ad5-49aa-96ad-bf1b21796475', '315a1635-db3f-40c8-ba75-f09ceb6e9d18', 'UNSOLD'),
('a9848b04-27dd-45e0-9d07-9cbcba7e3887', '248a8e47-4791-43ff-bd84-20e58d15e8d7', 'UNSOLD'),
('2d85268a-6a9d-41d3-9df7-7a93ac45291b', '4b03bcbf-0019-4513-9349-005bbd47efbe', 'UNSOLD'),
('20601d14-5355-4d33-98db-9c2a15351782', 'e1d75270-9066-4b46-ac77-f86e008ef192', 'UNSOLD'),
('80c652a3-5977-43d0-adfc-1e2ddf6ac3c5', '41a82c62-54e5-485f-904e-4625063b845b', 'UNSOLD'),
('9d00fc72-0433-4e0a-857d-c81f02713dcb', '705429a0-d014-4d4f-b244-21fc6aa29b3b', 'UNSOLD'),
('ab7e8586-936a-435e-a359-cbc66aca2b8f', '48ed66c9-b2a9-4ba1-b820-ba8079a0a19d', 'UNSOLD'),
('b63631c1-738a-492a-b51a-ce73035ab193', 'bea4abd4-9987-4dc2-bc8d-ca527872c698', 'UNSOLD'),
('cbd899a3-2831-49a4-8970-a6d8ffaadd6e', 'e3f31dd5-a160-492b-b951-962222021e46', 'UNSOLD'),
('e7521bac-31c6-44d8-84c6-8591c32910e5', '97111e23-5a69-4a99-a284-51adbc6f2c6a', 'UNSOLD'),
('627c7ddc-6a9e-4866-874e-c783fd7ed72c', 'c4f9e19b-dbed-458b-af80-a57661f9930b', 'UNSOLD'),
('f57dd86e-e938-4c33-a8f6-fda5ffab1ec4', '75ee8e5d-6981-496f-89e6-1c367df21f56', 'UNSOLD'),
('c0539836-bcaf-4599-8803-5a22b4c9e071', '82394290-7d23-4251-965f-9443ed248640', 'UNSOLD'),
('46260990-c34d-4f90-ba79-3ca1dc165f24', '1acf11af-3298-473b-a262-1ee6a1ec90d0', 'UNSOLD'),
('70255155-2a43-48a1-b32f-eacc8cb39de2', '52c4546c-9bcc-4dc8-b288-c80a15725aab', 'UNSOLD'),
('65cd0978-297f-4b2f-93ce-3be52a9e5569', 'd3902e7f-3827-4f4b-8088-1e2802c1381e', 'UNSOLD'),
('30fa670e-3475-431b-82c2-70dda60b0499', '1e8d8cfd-55a2-4387-a426-31f743ba8229', 'UNSOLD'),
('aca58f9e-38dd-41a7-8294-04c6fcc6161a', '2bf544cf-595f-46d5-bd62-11526b82806f', 'UNSOLD'),
('cebdf04e-ba87-4984-859a-08313c1a77e3', '3b6dfe30-a0dc-4ce9-a70d-ceebf8542a5b', 'UNSOLD'),
('0a39a141-6f50-45b4-893e-b8d1ae40edac', 'b2e8fb09-fbc8-44c6-aa1b-475c1ab71d9c', 'UNSOLD'),
('6fa431dc-32f7-4d6f-9f04-4e4c0758ccf4', 'ca23c8a2-d213-4bbe-acb4-96c4267fc854', 'UNSOLD'),
('52afb0a2-0b13-4583-9055-548bd3c83ba2', 'f1f2c647-587c-4ad7-b917-510c3a5f01af', 'UNSOLD'),
('a290ff00-dcf7-4128-b5cb-723877ef33c4', '01c1f32a-e1d3-43fe-9e2d-1b5c2a6744eb', 'UNSOLD'),
('73aa22b3-20ba-4790-a889-d1ea682e6277', 'f1ad9048-e5de-4a64-94f7-118c5df18b18', 'UNSOLD'),
('34b5bb2f-e26f-448e-ba7f-b7b793e3e186', '9326eb26-70c0-465b-a701-3eeea27d246c', 'UNSOLD'),
('86fe1c11-583f-4346-97ec-98ddb9df4964', '0783fe0d-f72e-4212-8907-32e8f43561a0', 'UNSOLD'),
('f34d8d93-2f27-4f7b-b90e-c8a25aaae9c6', '163c8ee6-8458-4264-8b66-dbfcce8b920b', 'UNSOLD'),
('2503df3f-7f55-4754-9f51-0ab87a91cc4e', 'dac87d19-e4c2-46bd-83b9-b43b31f31fbf', 'UNSOLD'),
('bd8a51f5-7fe8-4891-aab1-a391547760b1', 'e96ac5f0-98b4-43dd-bcf2-15d9f5878ec4', 'UNSOLD'),
('b8781fed-3e30-4c0b-a91f-634c7decb3e8', '80141903-597b-494c-8e3a-2aa9833b60e1', 'UNSOLD'),
('fcca8ec3-ffbc-4a33-ab07-54f94daae55f', '3820abf7-2910-4909-8f33-67905ffab53c', 'UNSOLD'),
('f02db12c-a385-4544-85b9-ad81e1592d3a', '190b3b57-85c2-40ff-9294-eedd5a0e7115', 'UNSOLD'),
('c01d5f2e-6428-441c-b94b-ec26bd736e8c', '19a6a3de-1d0d-4279-89cc-edc7a2a1d89d', 'UNSOLD'),
('e173455d-0c99-4dbf-ba9a-4ef1d752fd6e', '9df284ca-c947-4e48-8970-998e3c948a9b', 'UNSOLD'),
('d4173314-dd48-41ac-8289-ffd430999297', 'd940d5a1-7117-4226-a38a-8ac10548232e', 'UNSOLD'),
('fac38984-a120-47fc-a446-deb97c3dfe69', '410ee106-be15-4af3-8ac7-b601b16038db', 'UNSOLD'),
('c12fa546-ec25-4592-9ad9-c030d78deeae', '756c5e9e-8d73-4cfc-8b18-8a455c6ab156', 'UNSOLD'),
('a2b78590-cb57-4a57-a6e2-bd99ceac37bf', 'a0cb483f-d299-4093-af0f-c18ac9f615ae', 'UNSOLD'),
('640918ce-f2e3-440f-8ce0-dfcd89c1643e', '132ee79c-e821-4416-bc4f-3dd511f2c0d9', 'UNSOLD'),
('9f78ff6c-91ab-4707-a8f5-61ee8bcfd47b', 'f4050e18-f991-4ae0-9a67-6dc2ccb820bd', 'UNSOLD'),
('94b5a536-44d7-445d-9f50-4db47e238c28', 'def79e7d-a639-4df6-9f36-d17657defb94', 'UNSOLD'),
('f2718a12-1fae-49ed-862e-5ee14898319d', '5995601a-9149-410f-8536-9d618f3d1bff', 'UNSOLD'),
('b1b4c87e-45b8-4d7b-b9d9-93fba16cd594', 'f61efa3e-aeba-4d43-a2eb-92feb8c56316', 'UNSOLD'),
('1af04c5b-b5ae-46b7-92f9-48e7b2a02534', '2c7ea4ef-98da-4dcb-b6fd-f96580af7aae', 'UNSOLD'),
('f78f2e04-d679-4245-9e4d-d7994a8ca894', '7170d9f9-0e93-40db-aa6e-dd1be1f2b095', 'UNSOLD'),
('32eeef69-ddc3-492d-8571-7237e3b78fda', 'cdecd8c1-bff6-48b0-a092-fe000b9b1ca2', 'UNSOLD'),
('21d71472-c8e2-4d05-88d3-3130f0811cf3', '22a44b4a-0732-4bcf-9566-a60c1b45c6ca', 'UNSOLD'),
('ccc641c4-d333-4097-9208-be0d67575f35', '7fbde295-ddc5-41f2-bff8-98dbcc348fb2', 'UNSOLD'),
('b9bf324e-5b35-42ab-977e-a706c898be0f', '1ff072e8-8237-4c4b-ab9e-57313d708c53', 'UNSOLD'),
('ddd0e2f9-fc10-4175-9e59-67d2339d2ed0', '3d20b9a1-e613-4957-a071-b7624654925d', 'UNSOLD'),
('af9bf069-ceba-4fed-b6da-b17ca2672a65', 'e4f4a3f8-cea4-4427-bd96-1071ce873526', 'UNSOLD'),
('dd3b512d-3546-4b61-8871-af4e791ee5d2', '6eef28a4-5e1e-435d-a974-fd6512d8aca7', 'UNSOLD'),
('a0cc5141-b16f-45b7-b91b-e3720e67a03f', '516232b8-f2ed-436c-a1e7-f1dec38bddb3', 'UNSOLD'),
('c89e07cf-e744-40e3-93e5-fbb44b3affd9', '074d5745-9aaa-4b33-b987-7f30a2ac465e', 'UNSOLD'),
('f4b04709-56dd-4a03-ab87-030c29bdfbe4', 'f62730f6-5898-4004-b05a-cf92377b2f62', 'UNSOLD'),
('eb50770a-1ea3-48a7-a298-7757963d20c5', '1a4f479c-c606-4ab3-9107-ba63805cd068', 'UNSOLD'),
('ea09b88c-2625-4300-ba39-7929b83fd7ed', 'eb2907d1-410c-4613-94f2-0daec059b24a', 'UNSOLD'),
('bc8e1827-7331-4c15-802f-55d36804c95d', 'bf206479-5333-4790-947a-dbd355f8df05', 'UNSOLD'),
('96c35f1f-02cf-4891-bf0c-5a6c1011f35a', 'fa5f6de7-4342-48aa-a429-b7c28bbbaba8', 'UNSOLD'),
('fcd3ec83-124e-432a-bab4-4d48da6ca698', '3a9c7846-767f-49eb-8828-ea7951eb4fb7', 'UNSOLD'),
('43733fb3-87ea-4296-a1cb-d26993ced7af', 'd03489f2-a4b4-494b-b671-d2b69c4318f5', 'UNSOLD'),
('fd6608a4-7920-4579-a666-4cbcc7d387cf', 'd389be2b-585a-4db6-ba28-f6bcd1b3076e', 'UNSOLD'),
('53833746-3ed6-4786-b40e-58edc02049f8', '5c7dd905-f73e-4344-85cd-bdbf2520dd6f', 'UNSOLD'),
('2d2dcc99-458d-4eb4-b786-91b329a71d5b', 'e4201fbb-2fec-4084-9629-9750c82d32f2', 'UNSOLD'),
('fc416d97-60e8-42b4-a987-d36430463582', '61ca7ce1-d2e2-4a59-a9e0-b2f8c39f2cef', 'UNSOLD'),
('88304833-ee08-4c85-ad91-661cae6e49b7', '9b8d3ccc-97d2-49d6-99d8-cee9a1f0b737', 'UNSOLD'),
('e4a42489-12f5-4cfc-99fe-b0c58d40426d', 'f6f136c7-3a4b-4add-bc60-f01c848a62f2', 'UNSOLD'),
('679b445f-5ed5-491c-918b-caaf4138033e', '3a4a0b77-b80e-4901-b2ce-69a2a48dffc5', 'UNSOLD'),
('de15d75f-58c2-4ced-a491-0067bf4f4f0f', '4acb0513-6b98-42a0-b28d-8f3c55dcc61d', 'UNSOLD'),
('c7041f35-7db0-44fa-a35b-04584f3a25e6', 'a9854f8d-fd4c-4a47-b428-8f9850a121c3', 'UNSOLD'),
('b5ec64ab-efd0-4f6b-82e7-8d8dac93c07d', '9d9595af-dba8-440c-8eb5-3daf7436f60a', 'UNSOLD'),
('553547c6-0090-472d-b6fd-7b2357a2d85a', '8084292b-dd8c-4f63-8e07-74114021db25', 'UNSOLD'),
('ce82bf52-93e9-4344-a333-2587982167b9', '06c5d51b-18bc-43e0-80fb-6adde8124f58', 'UNSOLD'),
('794dcba7-d9cb-4f93-be60-385deb1acdb2', '284d3aaf-e83c-4616-b05c-ec7dae571a91', 'UNSOLD'),
('7d37633b-b2ed-47e9-b7f1-70d2794c93c1', 'ce8ba8bd-7880-4b98-9aa5-140fba69aaa0', 'UNSOLD'),
('dd5248bc-d511-444e-a236-588a6cc99c6f', '87d82d36-b1f1-474c-b23d-68e9e26d87e0', 'UNSOLD'),
('8bc4cc7d-f4eb-4bdc-a64c-5f6c3041941e', 'a5b2f522-bd11-4cd8-b7c5-f16ad4e84be5', 'UNSOLD'),
('0d9cd512-dcea-4b77-8b86-1da92ad2c1e3', '0124e042-c267-4f47-bc7a-b4759fb892d7', 'UNSOLD'),
('54cf1b61-b254-45cb-9d93-fc67ca9096c6', 'd96c62a5-2db6-4170-998c-c710ffd06960', 'UNSOLD'),
('de125fad-b038-42ca-841c-cb9a9a755fb0', 'b43bece5-dd20-4abb-b5b7-50c8dba1f517', 'UNSOLD'),
('5d4bedd9-2b2b-408e-9fc8-5236f8d94d70', 'ce4db6a2-7fcb-4038-b111-f93bc1c61fa2', 'UNSOLD'),
('7f2e8115-a39f-4c0f-87f3-1deec4db0829', 'fc44079f-2ea0-45e7-80e4-fa6e1c8df63a', 'UNSOLD'),
('ec65311d-a138-4973-83a8-eb6e1021aea6', 'cb7760bb-f38f-40a7-a58f-60edfb72153c', 'UNSOLD'),
('48764333-6f21-4fd2-ad75-1453986cc6ea', '1c09d5fe-d700-43fd-b471-3d6af9d70a32', 'UNSOLD'),
('f7b55fdd-56cb-403f-a230-ecb0fe4a9e48', '0e068e36-87b1-4b0b-9c58-92e50a2f2b9c', 'UNSOLD'),
('bab02d18-ebf4-4fb8-9527-0547b727a950', '4098b2a2-4dfe-461e-b04f-e16c5d3c63bb', 'UNSOLD'),
('b8202add-2942-4599-857e-d33e7c5b9d1a', '7d5da845-bda1-456e-aaea-f6adf16ba29f', 'UNSOLD'),
('e2e732e4-682c-4e16-b00b-ae6bf44c5f7a', '0508607b-e9c8-4d6c-806c-cbf71a29bafd', 'UNSOLD'),
('813d8710-1017-4f17-bbba-56ac81bdbfac', '31739372-487c-4cd1-848e-4d08d0a2a292', 'UNSOLD'),
('e0a47ee2-9477-4ea1-ab8e-8e768d557f4c', '5187c9d3-6dbe-4902-961b-931e71d6a21b', 'UNSOLD'),
('e087cbf1-c032-4a47-a67b-f8e97680b1e5', 'd29f71b0-2b3e-43d3-a733-36b0bb0e4052', 'UNSOLD'),
('823ea87e-19af-4763-9d7e-6baa2b06b247', '6524c9bc-5936-43ea-a697-7fa54c90edfb', 'UNSOLD'),
('d6d3a1f2-19ed-41c5-990b-cf9af3c943fc', 'b6299e12-1362-4693-a1ed-1c4961f56cee', 'UNSOLD'),
('211fd021-bbce-458f-9523-0ee48f175155', 'bd2de523-da32-487b-be22-051520387124', 'UNSOLD'),
('f6436e97-f295-41ee-b01f-7d0baf88da1b', '04bcf327-5656-4164-a6ef-aff0f8d806de', 'UNSOLD'),
('354d0b05-8c1f-4fb0-947b-fcb7fa4c1f40', 'b3a13b70-7b72-46ba-9567-dbd14e8d1f40', 'UNSOLD'),
('7b3ae981-17fe-4d14-8763-29463b02004d', '056a2830-35e3-45d0-9f45-0bf3ce08234e', 'UNSOLD'),
('29a9cc65-6ffc-4d4c-bde0-da47c8740cbd', '7c165361-5133-4d92-a328-6497326ea06c', 'UNSOLD'),
('d2b1ea80-f382-4256-897f-34ea8cc31482', 'e9223148-5e87-4933-abcd-63ec1f2c41b6', 'UNSOLD'),
('c6658c39-cb3d-4e5d-ab64-86c347b4eb48', '9378ea57-95d6-471b-9ba5-81fff21ec73e', 'UNSOLD'),
('afc29ad7-ebc3-4c21-be40-108c8616cf88', '95cdc3ed-f43f-4a73-9430-32b8db083f2e', 'UNSOLD'),
('ef68d4c1-1959-4455-9c20-47675f8bc6c4', 'f8d0d056-cf9d-480e-b554-2f5a14cd7109', 'UNSOLD'),
('a803bf7a-528a-4dc2-8d5f-c49b84e744f9', 'b0f1f8ee-0c62-48ec-b774-d0303c722af6', 'UNSOLD'),
('4a0bbe0e-9727-4d18-9555-d6c68f9bbe42', '8e9af420-d019-41bc-af45-eb5d9daed513', 'UNSOLD'),
('d1afc9c6-0ece-4806-9b08-1942933b1965', 'aec8bca4-e68d-4ad1-96b5-431491a5569f', 'UNSOLD'),
('d82bcec2-f945-4cff-9c4f-2c81e5bf2ce6', '71756fca-9f9b-4dac-8ad0-432ee1459353', 'UNSOLD'),
('5a580d11-beec-419c-a5a9-e117c43a89ca', 'a3534a44-b9f4-417a-a091-b91ea7accd34', 'UNSOLD'),
('8dd9b37b-f6e6-4bc1-adab-732a50cf9cd3', '6f686e5c-89ae-4d68-97d1-41f0c3a53fb2', 'UNSOLD'),
('f5d0c7ab-3bf4-4777-a20f-eb3d3cb1629b', 'a0ffcdb4-9c0e-4cab-94d6-af79e0f97dfc', 'UNSOLD'),
('8475944f-3ee8-466c-9dd9-9d268a385158', '505f46d8-9df5-4537-bb5b-371ee1f49f9d', 'UNSOLD'),
('6c70e5a8-43e5-4220-a236-ed8a59395bfd', '73b14502-2f8e-4ab1-9201-6f76f3fb88a7', 'UNSOLD');

INSERT INTO "AdminUser" (id, username, password_hash, role) VALUES
('8bc0c636-5eaa-4d6f-a51c-527e9da9e7b0', 'admin', '$2b$10$vU6wiSt7CUA/LDFMs9VTYu4/YCqbIDxyVivlAMCw8b/fd8UOE7o2K', 'ADMIN'),
('74487976-bc89-4c7f-bc1e-3618e8d97d89', 'screen', '$2b$10$wyGb9fv97JXPX.OrxjNEP.tQMAZwbdV9F1V2CW2uZQ4sl0vioKvTS', 'SCREEN');

INSERT INTO "AuctionSequence" (id, name, type, sequence_items) VALUES
(1, 'Franchise Auction', 'FRANCHISE', '[3,7,1,9,5,10,2,6,8,4]');

INSERT INTO "AuctionSequence" (id, name, type, sequence_items) VALUES
(2, 'Power Card Auction', 'POWER_CARD', '["GOD_EYE","MULLIGAN","FINAL_STRIKE","BID_FREEZER"]');

INSERT INTO "AuctionSequence" (id, name, type, sequence_items) VALUES
(3, 'Player Auction 3', 'PLAYER', '[134,137,104,138,100,115,117,37,87,141,53,143,29,5,42,78,86,154,71,131,105,32,116,91,118,94,54,112,27,90,119,25,65,135,103,108,26,145,157,150,23,47,15,69,77,123,122,16,39,17,44,43,124,114,149,156,140,158,130,75,73,88,41,56,129,120,40,97,19,93,98,109,38,61,8,82,139,101,55,48,11,84,142,68,132,95,72,10,58,80,31,81,57,28,155,159,63,66,34,126,96,110,36,148,13,127,153,50,9,133,136,83,74,59,60,20,113,102,14,52,106,4,79,144,46,22,51,45,147,1,33,152,2,70,107,121,62,99,35,89,92,128,12,151,76,111,21,67,64,30,85,6,125,18,49,7,24,146,3]');

INSERT INTO "AuctionState" (id, phase, auction_day) VALUES (1, 'NOT_STARTED', 'Day 1');

