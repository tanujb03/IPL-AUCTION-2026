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
('873a1b1e-be2c-451e-a942-1e0a6d59c306', 'The jews', 'thejews', '$2b$10$bLYtkegfxsLWOV3J5Cq8JuxOu00bsk6Tyqf8KrR7fhpg52FLZW1Hm', 120, 0),
('0d3e254e-729b-4f64-91e1-f2580d8429b8', 'Tech_Spaces 11', 'techspaces11', '$2b$10$FBRGv27FnyeiO8JN2sJJvejHhpCiCNTwkFPG5Lrb/05XN4aAoFgpq', 120, 0),
('98ea0406-0320-4950-b897-f7a1af7b4c13', 'Hyderabadi chicken biryani', 'hyderabadichickenbir', '$2b$10$HmY8bR7Jbv7r9Ve8wxtpCeicmqqGKjH1WwvwgQYvC5q24lLa4JnaG', 120, 0),
('3a4bee1c-e8f7-435c-bf14-5b4cfb09b588', 'Pillukombdi', 'pillukombdi', '$2b$10$pcatRlP1qUModSRANOdMUOPJ.3QbIuWzFPr.K3Spc7oiqNCRr7ScO', 120, 0),
('4eafbbfd-29dd-4464-87ab-4c870c9e7330', 'Bidmasters XI', 'bidmastersxi', '$2b$10$HYOQbTIZwlc4V6TJKcoqm.EIjzbmfVbD0tHuCyCyF2j8LTNpZnRjK', 120, 0),
('54c05120-bea4-41c9-9804-127e9f1b3899', 'Thunder Strikers', 'thunderstrikers', '$2b$10$filbdRejssCXRWnRthySGu9wrYNq.YSAx7H4TdKnMbYXyF6TYK2Ki', 120, 0),
('9274ca83-08cc-4170-a7b6-5d9874fd5569', '401', '401', '$2b$10$2DZtozrBOExy2Baf3j07wOTug6citLC2WOJbRQBIjEh3y9MUbV3QK', 120, 0),
('c33df27a-8745-4c23-879f-45696494d9a9', 'Ipl ka tambu', 'iplkatambu', '$2b$10$qXAtNZiu94ThEvmXRGcadeyU/uVyxOiCkTpDRCNqP9pC2tRTfh/X6', 120, 0),
('6dad7ce4-a86b-4422-b1af-d7a00930728a', 'Dhoni Ka Bambu', 'dhonikabambu', '$2b$10$jzGjkDQLBM4oeSGx6YwQEOuYPC3tmlZk28orTuz1TrTJw.BNPdaKq', 120, 0),
('6874fff4-42d3-45d9-8944-d258cf5fadc4', 'Choco 11', 'choco11', '$2b$10$35B3qpI9o/99lDA9nr3Be.rll0IeDtY4yiTHrDt.Hm4mrgvuXRiOi', 120, 0);

INSERT INTO "Player" (id, rank, name, team, role, category, pool, grade, rating, nationality, nationality_raw, base_price, is_riddle, riddle_title, riddle_question, legacy, url, matches, bat_runs, bat_sr, bat_average, bowl_wickets, bowl_eco, bowl_avg, sub_scoring, sub_impact, sub_consistency, sub_experience, sub_wicket_taking, sub_economy, sub_efficiency, sub_batting, sub_bowling, sub_versatility) VALUES
('2cf292a5-a2f3-4f6a-af79-333a8e5c495d', 134, 'Vipraj Nigam', 'Delhi Capitals', 'Bowler', 'BOWL', 'BOWL', 'C', 59, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/1431811/vipraj-nigam', 14.0, NULL, NULL, NULL, 11.0, 9.13, 32.36, NULL, NULL, NULL, 37, 10.0, 54.0, 69.0, NULL, NULL, NULL),
('73611099-eaa0-4755-a9a3-af7c4cd0df5e', 137, 'Jayant Yadav', 'Gujarat Titans', 'Bowling Allrounder', 'AR', 'AR', 'C', 58, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/8182/jayant-yadav', 20.0, 40.0, NULL, NULL, 8.0, NULL, NULL, NULL, NULL, NULL, 40, NULL, NULL, NULL, 22.0, 25.0, 22.0),
('dc671d79-39eb-4aa1-a5af-8a58c56560db', 104, 'Lungi Ngidi', 'Delhi Capitals', 'Bowler', 'BOWL', 'BOWL', 'C', 64, 'OVERSEAS', 'South African', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/9603/lungi-ngidi', 16.0, NULL, NULL, NULL, 29.0, 8.53, 18.24, NULL, NULL, NULL, 38, 22.0, 63.0, 99.0, NULL, NULL, NULL),
('aa583568-a6ad-42c2-85cc-614d383a5d63', 138, 'Azmatullah Omarzai', 'Punjab Kings', 'Bowling Allrounder', 'AR', 'AR', 'C', 58, 'OVERSEAS', 'Afghan', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/13214/azmatullah-omarzai', 16.0, 99.0, NULL, NULL, 12.0, NULL, NULL, NULL, NULL, NULL, 38, NULL, NULL, NULL, 31.0, 25.0, 25.0),
('49bd913b-a38c-4fba-b1f7-d0dd2bd83c40', 100, 'Abishek Porel', 'Delhi Capitals', 'WK-Batsman', 'WK', 'BAT_WK', 'C', 66, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/24326/abishek-porel', 31.0, 661.0, 149.89, 25.42, NULL, NULL, NULL, 16.0, 78.0, 63.0, 45, NULL, NULL, NULL, NULL, NULL, NULL),
('060df6a0-cdb2-4d33-8366-2229a6741323', 115, 'Rachin Ravindra', 'Kolkata Knight Riders', 'Batting Allrounder', 'AR', 'AR', 'C', 62, 'OVERSEAS', 'New Zealander', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/11177/rachin-ravindra', 18.0, 413.0, NULL, NULL, 0.0, NULL, NULL, NULL, NULL, NULL, 39, NULL, NULL, NULL, 49.0, 29.0, 29.0),
('23e56464-e3aa-428b-a411-060a2dd3020c', 117, 'Dewald Brevis', 'Chennai Super Kings', 'Batsman', 'BAT', 'BAT_WK', 'C', 62, 'OVERSEAS', 'South African', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/20538/dewald-brevis', 16.0, 455.0, 153.2, 28.44, NULL, NULL, NULL, 12.0, 80.0, 71.0, 38, NULL, NULL, NULL, NULL, NULL, NULL),
('a073d3f7-048b-4bd5-8666-9dc714377476', 37, 'Ishan Kishan', 'Sunrisers Hyderabad', 'WK-Batsman', 'WK', 'BAT_WK', 'B', 78, 'INDIAN', 'Indian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/10276/ishan-kishan', 119.0, 2998.0, 137.65, 29.11, NULL, NULL, NULL, 58.0, 70.0, 72.0, 89, NULL, NULL, NULL, NULL, NULL, NULL),
('670c5b03-56f1-43fc-84ee-add8fba094a7', 87, 'Tushar Deshpande', 'Rajasthan Royals', 'Bowler', 'BOWL', 'BOWL', 'C', 67, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/11307/tushar-deshpande', 46.0, NULL, NULL, NULL, 51.0, 9.84, 31.04, NULL, NULL, NULL, 53, 36.0, 42.0, 72.0, NULL, NULL, NULL),
('d2e12a18-e015-4043-b719-c6a492c48ec0', 141, 'Eshan Malinga', 'Sunrisers Hyderabad', 'Bowler', 'BOWL', 'BOWL', 'C', 58, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/46926/eshan-malinga', 7.0, NULL, NULL, NULL, 13.0, 8.93, 18.31, NULL, NULL, NULL, 33, 12.0, 57.0, 99.0, NULL, NULL, NULL),
('59e180da-a348-4a59-9bf1-6acc9a44beef', 53, 'Prasidh Krishna', 'Gujarat Titans', 'Bowler', 'BOWL', 'BOWL', 'B', 74, 'INDIAN', 'Indian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/10551/prasidh-krishna', 66.0, NULL, NULL, NULL, 74.0, 8.77, 29.61, NULL, NULL, NULL, 63, 51.0, 59.0, 75.0, NULL, NULL, NULL),
('77f24d75-f002-4240-8894-b12ee102d314', 143, 'Prashant Solanki', 'Kolkata Knight Riders', 'Bowler', 'BOWL', 'BOWL', 'C', 57, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/12805/prashant-solanki', 2.0, NULL, NULL, NULL, 2.0, 6.33, 19.0, NULL, NULL, NULL, 31, 5.0, 99.0, 97.0, NULL, NULL, NULL),
('73c940a8-bd21-4cad-816d-08ef9a4e1bf2', 29, 'Mohammed Siraj', 'Gujarat Titans', 'Bowler', 'BOWL', 'BOWL', 'B', 83, 'INDIAN', 'Indian', 1, false, NULL, NULL, 2, 'https://www.cricbuzz.com/profiles/10808/mohammed-siraj', 108.0, NULL, NULL, NULL, 109.0, 8.74, 30.72, NULL, NULL, NULL, 84, 74.0, 60.0, 72.0, NULL, NULL, NULL),
('38e902e8-2b90-476a-8c77-21d591f099b5', 5, 'Bhuvneshwar Kumar', 'Royal Challengers Bengaluru', 'Bowler', 'BOWL', 'BOWL', 'A', 98, 'INDIAN', 'Indian', 2, false, NULL, NULL, 8, 'https://www.cricbuzz.com/profiles/1726/bhuvneshwar-kumar', 190.0, NULL, NULL, NULL, 198.0, 7.69, 27.33, NULL, NULL, NULL, 99, 99.0, 77.0, 80.0, NULL, NULL, NULL),
('fb817804-f222-4444-bca9-c0afa9b824aa', 42, 'Ruturaj Gaikwad', 'Chennai Super Kings', 'Batsman', 'BAT', 'BAT_WK', 'B', 77, 'INDIAN', 'Indian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/11813/ruturaj-gaikwad', 71.0, 2502.0, 137.48, 40.35, NULL, NULL, NULL, 49.0, 70.0, 99.0, 65, NULL, NULL, NULL, NULL, NULL, NULL),
('b1dbf184-1fc8-4a86-869d-457e01cbc841', 78, 'Rajat Patidar', 'Royal Challengers Bengaluru', 'Batsman', 'BAT', 'BAT_WK', 'C', 69, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/10636/rajat-patidar', 42.0, 1111.0, 154.31, 30.86, NULL, NULL, NULL, 24.0, 81.0, 77.0, 51, NULL, NULL, NULL, NULL, NULL, NULL),
('e7cbea04-94fe-4445-9e68-772ffcbdd19a', 86, 'Mayank Markande', 'Mumbai Indians', 'Bowler', 'BOWL', 'BOWL', 'C', 67, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/12627/mayank-markande', 37.0, NULL, NULL, NULL, 37.0, 8.91, 28.89, NULL, NULL, NULL, 48, 27.0, 57.0, 76.0, NULL, NULL, NULL),
('0ae312a8-ea2b-40de-9736-d06bb61d084d', 154, 'Nuwan Thushara', 'Royal Challengers Bengaluru', 'Bowler', 'BOWL', 'BOWL', 'C', 56, 'OVERSEAS', 'Sri Lankan', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/18509/nuwan-thushara', 8.0, NULL, NULL, NULL, 9.0, 9.43, 31.44, NULL, NULL, NULL, 34, 9.0, 49.0, 71.0, NULL, NULL, NULL),
('e8521142-465a-48d0-8585-28dc08a7f968', 71, 'Matheesha Pathirana', 'Kolkata Knight Riders', 'Bowler', 'BOWL', 'BOWL', 'B', 70, 'OVERSEAS', 'Sri Lankan', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/16458/matheesha-pathirana', 32.0, NULL, NULL, NULL, 47.0, 8.68, 21.62, NULL, NULL, NULL, 46, 34.0, 61.0, 92.0, NULL, NULL, NULL),
('f4db4407-a14b-4aff-87b1-fbfbaa1f80f1', 131, 'Romario Shepherd', 'Royal Challengers Bengaluru', 'Bowling Allrounder', 'AR', 'AR', 'C', 60, 'OVERSEAS', 'West Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/13646/romario-shepherd', 18.0, 185.0, NULL, NULL, 10.0, NULL, NULL, NULL, NULL, NULL, 39, NULL, NULL, NULL, 52.0, 18.0, 18.0),
('b1225bd2-2f2f-4a3a-98d6-f0efd723fac1', 105, 'Mukesh Kumar', 'Delhi Capitals', 'Bowler', 'BOWL', 'BOWL', 'C', 64, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/10754/mukesh-kumar', 32.0, NULL, NULL, NULL, 36.0, 10.4, 30.61, NULL, NULL, NULL, 46, 27.0, 33.0, 73.0, NULL, NULL, NULL),
('b8e15fad-34ed-4ba2-823e-0cdb77962d3f', 32, 'David Miller', 'Delhi Capitals', 'Batsman', 'BAT', 'BAT_WK', 'B', 80, 'OVERSEAS', 'South African', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/6349/david-miller', 141.0, 3077.0, 138.61, 35.78, NULL, NULL, NULL, 60.0, 70.0, 89.0, 99, NULL, NULL, NULL, NULL, NULL, NULL),
('38e3dcf1-aadb-4347-8e21-ac06fe20c208', 116, 'Sherfane Rutherford', 'Mumbai Indians', 'Batting Allrounder', 'AR', 'AR', 'C', 62, 'OVERSEAS', 'West Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/13748/sherfane-rutherford', 23.0, 397.0, NULL, NULL, 1.0, NULL, NULL, NULL, NULL, NULL, 41, NULL, NULL, NULL, 48.0, 17.0, 17.0),
('902a8a28-805e-4814-b33f-a93bac8ef18c', 91, 'Shahrukh Khan', 'Gujarat Titans', 'Batting Allrounder', 'AR', 'AR', 'C', 67, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/10226/shahrukh-khan', 55.0, 732.0, NULL, NULL, 1.0, NULL, NULL, NULL, NULL, NULL, 57, NULL, NULL, NULL, 56.0, 27.0, 27.0),
('0574375b-9eb5-4535-b488-52d982004a6f', 118, 'Aniket Verma', 'Sunrisers Hyderabad', 'Batsman', 'BAT', 'BAT_WK', 'C', 62, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/1447065/aniket-verma', 14.0, 236.0, 166.2, 26.22, NULL, NULL, NULL, 8.0, 89.0, 65.0, 37, NULL, NULL, NULL, NULL, NULL, NULL),
('84a03a48-2232-4db6-90ea-ac53b94a5234', 94, 'Will Jacks', 'Mumbai Indians', 'Batting Allrounder', 'AR', 'AR', 'C', 66, 'OVERSEAS', 'English', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/12258/will-jacks', 21.0, 463.0, NULL, NULL, 8.0, NULL, NULL, NULL, NULL, NULL, 40, NULL, NULL, NULL, 55.0, 28.0, 28.0),
('538f8f81-0049-443a-82d2-88518f480cc9', 54, 'Heinrich Klaasen', 'Sunrisers Hyderabad', 'WK-Batsman', 'WK', 'BAT_WK', 'B', 74, 'OVERSEAS', 'South African', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/10209/heinrich-klaasen', 49.0, 1480.0, 169.73, 40.0, NULL, NULL, NULL, 31.0, 91.0, 99.0, 54, NULL, NULL, NULL, NULL, NULL, NULL),
('e87fbdd6-24c6-4197-8a8e-522bb676b0b3', 112, 'Nitish Kumar Reddy', 'Sunrisers Hyderabad', 'Batting Allrounder', 'AR', 'AR', 'C', 62, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/14701/nitish-kumar-reddy', 28.0, 485.0, NULL, NULL, 5.0, NULL, NULL, NULL, NULL, NULL, 44, NULL, NULL, NULL, 50.0, 14.0, 14.0),
('e306859b-ffa5-438e-a67e-242ec9c513ca', 27, 'Shreyas Iyer', 'Punjab Kings', 'Batsman', 'BAT', 'BAT_WK', 'B', 83, 'INDIAN', 'Indian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/9428/shreyas-iyer', 132.0, 3731.0, 133.35, 34.23, NULL, NULL, NULL, 72.0, 67.0, 85.0, 96, NULL, NULL, NULL, NULL, NULL, NULL),
('f5ba6c61-1ba5-4101-88e5-a67f57ab68da', 90, 'Naman Dhir', 'Mumbai Indians', 'Batsman', 'BAT', 'BAT_WK', 'C', 67, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/36139/naman-dhir', 23.0, 392.0, 180.65, 28.0, NULL, NULL, NULL, 11.0, 99.0, 70.0, 41, NULL, NULL, NULL, NULL, NULL, NULL),
('4997d268-eccb-4933-8343-47bacaf8d11c', 119, 'Wanindu Hasaranga', 'Lucknow Super Giants', 'Bowling Allrounder', 'AR', 'AR', 'C', 62, 'OVERSEAS', 'Sri Lankan', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/10926/wanindu-hasaranga', 37.0, 81.0, NULL, NULL, 46.0, NULL, NULL, NULL, NULL, NULL, 48, NULL, NULL, NULL, 15.0, 45.0, 15.0),
('90cef674-42be-4db1-bc8a-8ec4fefe492c', 25, 'Marcus Stoinis', 'Punjab Kings', 'Batting Allrounder', 'AR', 'AR', 'B', 83, 'OVERSEAS', 'Australian', 1, false, NULL, NULL, 4, 'https://www.cricbuzz.com/profiles/8989/marcus-stoinis', 109.0, 2026.0, NULL, NULL, 44.0, NULL, NULL, NULL, NULL, NULL, 84, NULL, NULL, NULL, 90.0, 37.0, 37.0),
('44f6de8b-924a-4b20-8a1e-466a8ccac164', 65, 'Tilak Varma', 'Mumbai Indians', 'Batsman', 'BAT', 'BAT_WK', 'B', 72, 'INDIAN', 'Indian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/14504/tilak-varma', 54.0, 1499.0, 144.42, 37.48, NULL, NULL, NULL, 31.0, 74.0, 93.0, 57, NULL, NULL, NULL, NULL, NULL, NULL),
('4aa79f15-1e92-4b11-b7f6-acbcd3462911', 135, 'Kartik Tyagi', 'Kolkata Knight Riders', 'Bowler', 'BOWL', 'BOWL', 'C', 58, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/13136/kartik-tyagi', 20.0, NULL, NULL, NULL, 15.0, 10.14, 47.53, NULL, NULL, NULL, 40, 13.0, 37.0, 37.0, NULL, NULL, NULL),
('559c1c8e-451e-44ed-a1a0-13a8b51912e4', 103, 'Priyansh Arya', 'Punjab Kings', 'Batsman', 'BAT', 'BAT_WK', 'C', 64, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/14689/priyansh-arya', 17.0, 475.0, 179.25, 27.94, NULL, NULL, NULL, 13.0, 98.0, 70.0, 38, NULL, NULL, NULL, NULL, NULL, NULL),
('df58585a-be29-4afc-a159-83015d8c7672', 108, 'Rovman Powell', 'Kolkata Knight Riders', 'Batsman', 'BAT', 'BAT_WK', 'C', 63, 'OVERSEAS', 'West Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/11445/rovman-powell', 28.0, 365.0, 146.59, 18.25, NULL, NULL, NULL, 11.0, 76.0, 46.0, 44, NULL, NULL, NULL, NULL, NULL, NULL),
('e98b18dc-a51f-4960-88bf-8c974114a64b', 26, 'Jaydev Unadkat', 'Sunrisers Hyderabad', 'Bowler', 'BOWL', 'BOWL', 'B', 83, 'INDIAN', 'Indian', 1, false, NULL, NULL, 2, 'https://www.cricbuzz.com/profiles/6327/jaydev-unadkat', 112.0, NULL, NULL, NULL, 110.0, 8.88, 30.58, NULL, NULL, NULL, 86, 74.0, 58.0, 73.0, NULL, NULL, NULL),
('2b361884-db71-49d9-999c-bf4bb7bb7406', 145, 'Akash Maharaj Singh', 'Lucknow Super Giants', 'Bowler', 'BOWL', 'BOWL', 'C', 57, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/14696/akash-maharaj-singh', 10.0, NULL, NULL, NULL, 9.0, 9.54, 36.22, NULL, NULL, NULL, 35, 9.0, 47.0, 61.0, NULL, NULL, NULL),
('bff008ea-d2f0-4ac6-bce1-6d5d642dc6f9', 157, 'Manimaran Siddharth', 'Lucknow Super Giants', 'Bowler', 'BOWL', 'BOWL', 'C', 55, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/12930/manimaran-siddharth', 5.0, NULL, NULL, NULL, 3.0, 8.63, 46.0, NULL, NULL, NULL, 32, 5.0, 62.0, 40.0, NULL, NULL, NULL),
('66568b87-5d1e-43bf-93b7-2aa6561cce51', 150, 'Adam Milne', 'Rajasthan Royals', 'Bowler', 'BOWL', 'BOWL', 'C', 56, 'OVERSEAS', 'New Zealander', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/7625/adam-milne', 10.0, NULL, NULL, NULL, 7.0, 9.48, 46.71, NULL, NULL, NULL, 35, 8.0, 48.0, 38.0, NULL, NULL, NULL),
('e732810c-865c-4dbd-a81c-29520167d29f', 23, 'Shubman Gill', 'Gujarat Titans', 'Batsman', 'BAT', 'BAT_WK', 'B', 84, 'INDIAN', 'Indian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/11808/shubman-gill', 118.0, 3866.0, 138.72, 39.45, NULL, NULL, NULL, 74.0, 70.0, 98.0, 89, NULL, NULL, NULL, NULL, NULL, NULL),
('763b70fb-96a9-4420-b231-0a4d8ddc9c71', 47, 'Yashasvi Jaiswal', 'Rajasthan Royals', 'Batsman', 'BAT', 'BAT_WK', 'B', 75, 'INDIAN', 'Indian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/13940/yashasvi-jaiswal', 66.0, 2166.0, 152.86, 34.38, NULL, NULL, NULL, 43.0, 80.0, 85.0, 63, NULL, NULL, NULL, NULL, NULL, NULL),
('17f5e4f6-9007-4bb1-bdea-156c0de9b663', 15, 'Sanju Samson', 'Chennai Super Kings', 'WK-Batsman', 'WK', 'BAT_WK', 'A', 89, 'INDIAN', 'Indian', 2, false, NULL, NULL, 2, 'https://www.cricbuzz.com/profiles/8271/sanju-samson', 176.0, 4704.0, 139.05, 30.75, NULL, NULL, NULL, 89.0, 71.0, 76.0, 99, NULL, NULL, NULL, NULL, NULL, NULL),
('fe93e554-866c-4a40-ba17-14965ea75961', 69, 'Liam Livingstone', 'Sunrisers Hyderabad', 'Batting Allrounder', 'AR', 'AR', 'B', 70, 'OVERSEAS', 'English', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/10045/liam-livingstone', 49.0, 1051.0, NULL, NULL, 13.0, NULL, NULL, NULL, NULL, NULL, 54, NULL, NULL, NULL, 70.0, 28.0, 28.0),
('bb85a862-4f46-4d6d-bab0-a6041afda964', 77, 'Rinku Singh', 'Kolkata Knight Riders', 'Batsman', 'BAT', 'BAT_WK', 'C', 69, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/10896/rinku-singh', 58.0, 1099.0, 145.18, 30.53, NULL, NULL, NULL, 24.0, 75.0, 76.0, 59, NULL, NULL, NULL, NULL, NULL, NULL),
('f0891476-ce83-4031-bcf1-3e04b776bd8e', 123, 'Ayush Mhatre', 'Chennai Super Kings', 'Batsman', 'BAT', 'BAT_WK', 'C', 61, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/1431163/ayush-mhatre', 7.0, 240.0, 188.98, 34.29, NULL, NULL, NULL, 8.0, 99.0, 85.0, 33, NULL, NULL, NULL, NULL, NULL, NULL),
('e25c09d8-3b12-4bf1-bdfe-2430ee47ef2b', 122, 'Ashutosh Sharma', 'Delhi Capitals', 'Batting Allrounder', 'AR', 'AR', 'C', 61, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/13497/ashutosh-sharma', 24.0, 393.0, NULL, NULL, 0.0, NULL, NULL, NULL, NULL, NULL, 42, NULL, NULL, NULL, 56.0, 0.0, 0.0),
('365a341b-21c2-4469-b0a7-c18065f32433', 16, 'Suryakumar Yadav', 'Mumbai Indians', 'Batsman', 'BAT', 'BAT_WK', 'A', 89, 'INDIAN', 'Indian', 2, false, NULL, NULL, 2, 'https://www.cricbuzz.com/profiles/7915/suryakumar-yadav', 166.0, 4311.0, 148.66, 35.05, NULL, NULL, NULL, 82.0, 77.0, 87.0, 99, NULL, NULL, NULL, NULL, NULL, NULL),
('56958771-c351-4212-a230-83d87cdc507e', 39, 'Nicholas Pooran', 'Lucknow Super Giants', 'WK-Batsman', 'WK', 'BAT_WK', 'B', 78, 'OVERSEAS', 'West Indian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/9406/nicholas-pooran', 90.0, 2293.0, 168.98, 34.22, NULL, NULL, NULL, 46.0, 91.0, 85.0, 75, NULL, NULL, NULL, NULL, NULL, NULL),
('35829b26-529e-4d7f-9516-6635308d596c', 17, 'Mohammed Shami', 'Lucknow Super Giants', 'Bowler', 'BOWL', 'BOWL', 'A', 89, 'INDIAN', 'Indian', 2, false, NULL, NULL, 4, 'https://www.cricbuzz.com/profiles/7909/mohammed-shami', 119.0, NULL, NULL, NULL, 133.0, 8.63, 28.18, NULL, NULL, NULL, 89, 89.0, 62.0, 78.0, NULL, NULL, NULL),
('275b80e4-553b-4d33-b3d6-972f81132133', 44, 'Khaleel Ahmed', 'Chennai Super Kings', 'Bowler', 'BOWL', 'BOWL', 'B', 77, 'INDIAN', 'Indian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/10952/khaleel-ahmed', 71.0, NULL, NULL, NULL, 89.0, 8.98, 26.16, NULL, NULL, NULL, 65, 61.0, 56.0, 82.0, NULL, NULL, NULL),
('52d93d17-5bd3-436c-910d-64df93fcc3ba', 43, 'Abhishek Sharma', 'Sunrisers Hyderabad', 'Batting Allrounder', 'AR', 'AR', 'B', 77, 'INDIAN', 'Indian', 1, false, NULL, NULL, 2, 'https://www.cricbuzz.com/profiles/12086/abhishek-sharma', 77.0, 1815.0, NULL, NULL, 11.0, NULL, NULL, NULL, NULL, NULL, 68, NULL, NULL, NULL, 90.0, 24.0, 24.0),
('67dc6202-4bcb-42a9-a504-48d914390e08', 124, 'Shubham Dubey', 'Rajasthan Royals', 'Batsman', 'BAT', 'BAT_WK', 'C', 61, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/19328/shubham-dubey', 13.0, 139.0, 163.53, 23.17, NULL, NULL, NULL, 6.0, 87.0, 58.0, 36, NULL, NULL, NULL, NULL, NULL, NULL),
('82207bb3-070f-46c6-9a6d-31bc6620959e', 114, 'Mitchell Santner', 'Mumbai Indians', 'Bowling Allrounder', 'AR', 'AR', 'C', 62, 'OVERSEAS', 'New Zealander', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/10100/mitchell-santner', 31.0, 110.0, NULL, NULL, 25.0, NULL, NULL, NULL, NULL, NULL, 45, NULL, NULL, NULL, 25.0, 40.0, 25.0),
('5ee11b5e-c396-4e3a-8f86-1fc2751b930e', 149, 'Glenn Phillips', 'Gujarat Titans', 'Batting Allrounder', 'AR', 'AR', 'C', 56, 'OVERSEAS', 'New Zealander', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/10693/glenn-phillips', 8.0, 65.0, NULL, NULL, 2.0, NULL, NULL, NULL, NULL, NULL, 34, NULL, NULL, NULL, 24.0, 34.0, 24.0),
('c631b459-1088-41c8-9efb-eee8852ec36c', 156, 'Matthew Short', 'Chennai Super Kings', 'Batsman', 'BAT', 'BAT_WK', 'C', 55, 'OVERSEAS', 'Australian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/9456/matthew-short', 6.0, 117.0, 127.18, 19.5, NULL, NULL, NULL, 6.0, 63.0, 49.0, 33, NULL, NULL, NULL, NULL, NULL, NULL),
('ae869843-c434-455c-a2dc-f720267f782b', 140, 'Mukesh Choudhary', 'Chennai Super Kings', 'Bowler', 'BOWL', 'BOWL', 'C', 58, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/13184/mukesh-choudhary', 16.0, NULL, NULL, NULL, 17.0, 9.94, 30.71, NULL, NULL, NULL, 38, 14.0, 40.0, 72.0, NULL, NULL, NULL),
('ae66ad8d-41c8-472c-98e8-6413143ff545', 158, 'Arjun Tendulkar', 'Lucknow Super Giants', 'Bowling Allrounder', 'AR', 'AR', 'C', 55, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/13747/arjun-tendulkar', 5.0, 13.0, NULL, NULL, 3.0, NULL, NULL, NULL, NULL, NULL, 32, NULL, NULL, NULL, 32.0, 23.0, 23.0),
('53aa5fd7-2118-4c47-86bf-1d84d2730527', 130, 'Sameer Rizvi', 'Delhi Capitals', 'Batsman', 'BAT', 'BAT_WK', 'C', 60, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/14700/sameer-rizvi', 13.0, 172.0, 140.99, 24.57, NULL, NULL, NULL, 7.0, 72.0, 61.0, 36, NULL, NULL, NULL, NULL, NULL, NULL),
('c38e4d50-e74c-465a-9f73-f0a7861cc391', 75, 'Karun Nair', 'Delhi Capitals', 'Batsman', 'BAT', 'BAT_WK', 'B', 70, 'INDIAN', 'Indian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/8257/karun-nair', 84.0, 1694.0, 131.73, 23.86, NULL, NULL, NULL, 35.0, 66.0, 60.0, 72, NULL, NULL, NULL, NULL, NULL, NULL),
('2c867031-b6d9-460a-8b29-f16df484fc48', 73, 'Tim David', 'Royal Challengers Bengaluru', 'Batsman', 'BAT', 'BAT_WK', 'B', 70, 'OVERSEAS', 'Singaporean', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/13169/tim-david', 50.0, 846.0, 173.37, 32.54, NULL, NULL, NULL, 19.0, 94.0, 81.0, 55, NULL, NULL, NULL, NULL, NULL, NULL),
('71fe849b-b883-41a1-ae9b-950c1431e762', 88, 'Harshit Rana', 'Kolkata Knight Riders', 'Bowler', 'BOWL', 'BOWL', 'C', 67, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/24729/harshit-rana', 33.0, NULL, NULL, NULL, 40.0, 9.51, 25.73, NULL, NULL, NULL, 46, 29.0, 47.0, 83.0, NULL, NULL, NULL),
('a9de1679-18d4-4b67-8a43-86f5d90f8c5e', 41, 'Nitish Rana', 'Delhi Capitals', 'Batsman', 'BAT', 'BAT_WK', 'B', 77, 'INDIAN', 'Indian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/9204/nitish-rana', 118.0, 2853.0, 136.77, 27.7, NULL, NULL, NULL, 56.0, 69.0, 69.0, 89, NULL, NULL, NULL, NULL, NULL, NULL),
('b341b006-725e-4b0e-ae3f-407600f57c0e', 56, 'Josh Hazlewood', 'Royal Challengers Bengaluru', 'Bowler', 'BOWL', 'BOWL', 'B', 73, 'OVERSEAS', 'Australian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/6258/josh-hazlewood', 39.0, NULL, NULL, NULL, 57.0, 8.28, 20.98, NULL, NULL, NULL, 49, 40.0, 67.0, 93.0, NULL, NULL, NULL),
('266aa13d-b480-4430-aff5-f484ea5bb847', 129, 'Anuj Rawat', 'Gujarat Titans', 'WK-Batsman', 'WK', 'BAT_WK', 'C', 60, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/13135/anuj-rawat', 24.0, 318.0, 119.11, 19.88, NULL, NULL, NULL, 10.0, 57.0, 50.0, 42, NULL, NULL, NULL, NULL, NULL, NULL),
('9fba0097-ca12-4111-bc6e-05ebc0a8a8c7', 120, 'Ravisrinivasan Sai Kishore', 'Gujarat Titans', 'Bowling Allrounder', 'AR', 'AR', 'C', 61, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/11595/ravisrinivasan-sai-kishore', 25.0, 18.0, NULL, NULL, 32.0, NULL, NULL, NULL, NULL, NULL, 42, NULL, NULL, NULL, 19.0, 41.0, 19.0),
('a5b76cfa-d79a-4de6-9b60-39e8766bac69', 40, 'Rahul Chahar', 'Chennai Super Kings', 'Bowler', 'BOWL', 'BOWL', 'B', 77, 'INDIAN', 'Indian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/12087/rahul-chahar', 79.0, NULL, NULL, NULL, 75.0, 7.72, 28.67, NULL, NULL, NULL, 69, 52.0, 76.0, 77.0, NULL, NULL, NULL),
('c891647a-331b-4c71-a31b-3ff23f41c534', 97, 'Ramandeep Singh', 'Kolkata Knight Riders', 'Batting Allrounder', 'AR', 'AR', 'C', 66, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/12337/ramandeep-singh', 30.0, 217.0, NULL, NULL, 6.0, NULL, NULL, NULL, NULL, NULL, 45, NULL, NULL, NULL, 46.0, 35.0, 35.0),
('8430a3b9-0cc9-4e04-b254-8577c1ebf000', 19, 'Hardik Pandya', 'Mumbai Indians', 'Batting Allrounder', 'AR', 'AR', 'A', 89, 'INDIAN', 'Indian', 2, false, NULL, NULL, 6, 'https://www.cricbuzz.com/profiles/9647/hardik-pandya', 152.0, 2749.0, NULL, NULL, 78.0, NULL, NULL, NULL, NULL, NULL, 99, NULL, NULL, NULL, 90.0, 50.0, 50.0),
('abac1449-87df-4415-ad5d-33d48f3e4fb0', 93, 'Washington Sundar', 'Gujarat Titans', 'Bowling Allrounder', 'AR', 'AR', 'C', 67, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/10945/washington-sundar', 66.0, 511.0, NULL, NULL, 39.0, NULL, NULL, NULL, NULL, NULL, 63, NULL, NULL, NULL, 42.0, 40.0, 40.0),
('bdc17dba-0c88-4385-9b49-7e5f98f5af1e', 98, 'Shivam Mavi', 'Sunrisers Hyderabad', 'Bowler', 'BOWL', 'BOWL', 'C', 66, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/12345/shivam-mavi', 32.0, NULL, NULL, NULL, 30.0, 8.71, 31.4, NULL, NULL, NULL, 46, 23.0, 60.0, 71.0, NULL, NULL, NULL),
('b88aef76-6dc2-4631-b80a-7f7c848dbfa5', 109, 'Abdul Samad', 'Lucknow Super Giants', 'Batting Allrounder', 'AR', 'AR', 'C', 63, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/14628/abdul-samad', 63.0, 741.0, NULL, NULL, 2.0, NULL, NULL, NULL, NULL, NULL, 61, NULL, NULL, NULL, 57.0, 5.0, 5.0),
('9a51bbed-4ad3-4051-85c3-21203d8eaa2f', 38, 'Shardul Thakur', 'Mumbai Indians', 'Bowling Allrounder', 'AR', 'AR', 'B', 78, 'INDIAN', 'Indian', 1, true, 'The ''Golden Arm'' Deity (Grade B)', 'Mere mortals play cricket, but I am universally recognized by the internet as a ''Lord''. After winning trophies in yellow and touring through Delhi and Kolkata, the ''Palghar Express'' is finally pulling into the Wankhede to play for his home city. Who am I?', 6, 'https://www.cricbuzz.com/profiles/8683/shardul-thakur', 105.0, 325.0, NULL, NULL, 107.0, NULL, NULL, NULL, NULL, NULL, 82, NULL, NULL, NULL, 38.0, 59.0, 38.0),
('12af3b2f-9193-48ec-a38e-a257fd07d69b', 61, 'Travis Head', 'Sunrisers Hyderabad', 'Batsman', 'BAT', 'BAT_WK', 'B', 72, 'OVERSEAS', 'Australian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/8497/travis-head', 38.0, 1146.0, 170.03, 34.73, NULL, NULL, NULL, 25.0, 92.0, 86.0, 49, NULL, NULL, NULL, NULL, NULL, NULL),
('12cab5f0-abe9-45ef-ac02-bab5b9f2589a', 8, 'MS Dhoni', 'Chennai Super Kings', 'WK-Batsman', 'WK', 'BAT_WK', 'A', 95, 'INDIAN', 'Indian', 2, false, NULL, NULL, 4, 'https://www.cricbuzz.com/profiles/265/ms-dhoni', 278.0, 5439.0, 137.46, 38.3, NULL, NULL, NULL, 99.0, 70.0, 95.0, 99, NULL, NULL, NULL, NULL, NULL, NULL),
('322f624e-4660-4592-b66d-df7afd4f1724', 82, 'Jitesh Sharma', 'Royal Challengers Bengaluru', 'WK-Batsman', 'WK', 'BAT_WK', 'C', 68, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/10214/jitesh-sharma', 55.0, 991.0, 157.06, 25.41, NULL, NULL, NULL, 22.0, 83.0, 63.0, 57, NULL, NULL, NULL, NULL, NULL, NULL),
('ec02b558-635d-4cf0-853d-4661dcc06ee0', 139, 'Nandre Burger', 'Rajasthan Royals', 'Bowler', 'BOWL', 'BOWL', 'C', 58, 'OVERSEAS', 'South African', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/13630/nandre-burger', 5.0, NULL, NULL, NULL, 7.0, 8.53, 20.71, NULL, NULL, NULL, 32, 8.0, 63.0, 94.0, NULL, NULL, NULL),
('e6bbbcd2-0962-4ab5-a60f-45c10329ebdb', 101, 'Umran Malik', 'Kolkata Knight Riders', 'Bowler', 'BOWL', 'BOWL', 'C', 65, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/19027/umran-malik', 26.0, NULL, NULL, NULL, 29.0, 9.4, 26.62, NULL, NULL, NULL, 43, 22.0, 49.0, 81.0, NULL, NULL, NULL),
('33e44bec-e6af-483e-88b0-fe96cf42a05f', 55, 'Mitchell Starc', 'Delhi Capitals', 'Bowler', 'BOWL', 'BOWL', 'B', 73, 'OVERSEAS', 'Australian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/7710/mitchell-starc', 51.0, NULL, NULL, NULL, 65.0, 8.61, 23.12, NULL, NULL, NULL, 55, 45.0, 62.0, 88.0, NULL, NULL, NULL),
('4efdd0e5-9ace-460f-911c-1704559a3529', 48, 'Pat Cummins', 'Sunrisers Hyderabad', 'Bowler', 'BOWL', 'BOWL', 'B', 75, 'OVERSEAS', 'Australian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/8095/pat-cummins', 72.0, NULL, NULL, NULL, 79.0, 8.81, 30.04, NULL, NULL, NULL, 66, 54.0, 59.0, 74.0, NULL, NULL, NULL),
('584cbb32-f1b1-45c0-a289-e5772afbe2d6', 11, 'Sandeep Sharma', 'Rajasthan Royals', 'Bowler', 'BOWL', 'BOWL', 'A', 93, 'INDIAN', 'Indian', 2, false, NULL, NULL, 4, 'https://www.cricbuzz.com/profiles/8356/sandeep-sharma', 136.0, NULL, NULL, NULL, 146.0, 8.03, 27.88, NULL, NULL, NULL, 98, 98.0, 71.0, 78.0, NULL, NULL, NULL),
('a7b590af-96f0-4063-a325-4eeb32f5c4a5', 84, 'Cameron Green', 'Kolkata Knight Riders', 'Batting Allrounder', 'AR', 'AR', 'C', 68, 'OVERSEAS', 'Australian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/12225/cameron-green', 29.0, 707.0, NULL, NULL, 16.0, NULL, NULL, NULL, NULL, NULL, 44, NULL, NULL, NULL, 64.0, 27.0, 27.0),
('1a0970bd-7094-4823-9530-e74d857152e9', 142, 'Kamindu Mendis', 'Sunrisers Hyderabad', 'Batting Allrounder', 'AR', 'AR', 'C', 57, 'OVERSEAS', 'Sri Lankan', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/10940/kamindu-mendis', 5.0, 92.0, NULL, NULL, 2.0, NULL, NULL, NULL, NULL, NULL, 32, NULL, NULL, NULL, 38.0, 29.0, 29.0),
('d821a8ce-bf1e-47b1-a84a-e7e3d98fb289', 68, 'Anrich Nortje', 'Lucknow Super Giants', 'Bowler', 'BOWL', 'BOWL', 'B', 71, 'OVERSEAS', 'South African', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/11427/anrich-nortje', 48.0, NULL, NULL, NULL, 61.0, 9.07, 27.16, NULL, NULL, NULL, 54, 43.0, 55.0, 80.0, NULL, NULL, NULL),
('a0332ebc-16f3-4c80-92d7-b8494daa1bab', 132, 'Kuldeep Sen', 'Rajasthan Royals', 'Bowler', 'BOWL', 'BOWL', 'C', 59, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/14336/kuldeep-sen', 12.0, NULL, NULL, NULL, 14.0, 9.63, 27.64, NULL, NULL, NULL, 36, 12.0, 45.0, 79.0, NULL, NULL, NULL),
('603a4be1-5125-437f-8de4-c56dab213bf0', 95, 'Nehal Wadhera', 'Punjab Kings', 'Batsman', 'BAT', 'BAT_WK', 'C', 66, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/13915/nehal-wadhera', 36.0, 719.0, 142.95, 26.63, NULL, NULL, NULL, 17.0, 73.0, 66.0, 48, NULL, NULL, NULL, NULL, NULL, NULL),
('8ca2e471-02ba-4b3c-8b7d-dac9db761d23', 72, 'Aiden Markram', 'Lucknow Super Giants', 'Batsman', 'BAT', 'BAT_WK', 'B', 70, 'OVERSEAS', 'South African', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/9582/aiden-markram', 57.0, 1440.0, 135.09, 31.3, NULL, NULL, NULL, 30.0, 68.0, 78.0, 58, NULL, NULL, NULL, NULL, NULL, NULL),
('07205e6d-7485-4e41-a994-73938ddc4050', 10, 'Harshal Patel', 'Sunrisers Hyderabad', 'Bowler', 'BOWL', 'BOWL', 'A', 94, 'INDIAN', 'Indian', 2, false, NULL, NULL, 6, 'https://www.cricbuzz.com/profiles/8175/harshal-patel', 119.0, NULL, NULL, NULL, 151.0, 8.86, 23.7, NULL, NULL, NULL, 89, 99.0, 58.0, 87.0, NULL, NULL, NULL),
('c2243a43-dc13-414f-baf4-b480a006f7cc', 58, 'Riyan Parag', 'Rajasthan Royals', 'Batting Allrounder', 'AR', 'AR', 'B', 73, 'INDIAN', 'Indian', 1, false, NULL, NULL, 2, 'https://www.cricbuzz.com/profiles/12305/riyan-parag', 83.0, 1566.0, NULL, NULL, 7.0, NULL, NULL, NULL, NULL, NULL, 71, NULL, NULL, NULL, 78.0, 16.0, 16.0),
('9b48a1c4-fdec-4591-a156-828c5cdc7049', 80, 'Lockie Ferguson', 'Punjab Kings', 'Bowler', 'BOWL', 'BOWL', 'C', 69, 'OVERSEAS', 'New Zealander', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/10692/lockie-ferguson', 49.0, NULL, NULL, NULL, 51.0, 8.97, 30.0, NULL, NULL, NULL, 54, 36.0, 56.0, 74.0, NULL, NULL, NULL),
('52d28657-460b-485d-a746-4d4a2b9062d0', 31, 'Manish Pandey', 'Kolkata Knight Riders', 'Batsman', 'BAT', 'BAT_WK', 'B', 82, 'INDIAN', 'Indian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/1836/manish-pandey', 174.0, 3942.0, 121.52, 29.42, NULL, NULL, NULL, 76.0, 59.0, 73.0, 99, NULL, NULL, NULL, NULL, NULL, NULL),
('445ae618-f2bc-4014-85ea-b9bd91495137', 81, 'Harpreet Brar', 'Punjab Kings', 'Bowler', 'BOWL', 'BOWL', 'C', 68, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/14452/harpreet-brar', 49.0, NULL, NULL, NULL, 35.0, 8.03, 31.0, NULL, NULL, NULL, 54, 26.0, 71.0, 72.0, NULL, NULL, NULL),
('49bc71ac-1808-4a0f-9e44-07ec0f6a7a7f', 57, 'Jofra Archer', 'Rajasthan Royals', 'Bowler', 'BOWL', 'BOWL', 'B', 73, 'OVERSEAS', 'English', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/11540/jofra-archer', 52.0, NULL, NULL, NULL, 59.0, 7.89, 27.15, NULL, NULL, NULL, 56, 41.0, 74.0, 80.0, NULL, NULL, NULL),
('5d103621-264e-4e6d-b6d6-ca6b0dfd2914', 28, 'Kuldeep Yadav', 'Delhi Capitals', 'Bowler', 'BOWL', 'BOWL', 'B', 83, 'INDIAN', 'Indian', 1, false, NULL, NULL, 2, 'https://www.cricbuzz.com/profiles/8292/kuldeep-yadav', 98.0, NULL, NULL, NULL, 102.0, 8.04, 26.95, NULL, NULL, NULL, 79, 69.0, 71.0, 80.0, NULL, NULL, NULL),
('ddf0d493-91d7-44ae-a6b8-03f51016f4da', 155, 'Swapnil Singh', 'Royal Challengers Bengaluru', 'Bowling Allrounder', 'AR', 'AR', 'C', 56, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/10238/swapnil-singh', 14.0, 51.0, NULL, NULL, 7.0, NULL, NULL, NULL, NULL, NULL, 37, NULL, NULL, NULL, 23.0, 27.0, 23.0),
('bbbc2d22-7a65-48f8-be0b-6f81d5bd4804', 159, 'Rasikh Dar Salam', 'Royal Challengers Bengaluru', 'Bowler', 'BOWL', 'BOWL', 'C', 55, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/14274/rasikh-dar-salam', 13.0, NULL, NULL, NULL, 10.0, 10.62, 40.9, NULL, NULL, NULL, 36, 10.0, 29.0, 51.0, NULL, NULL, NULL),
('bce019ea-5f55-4a49-ab9a-e558422692ec', 63, 'T Natarajan', 'Delhi Capitals', 'Bowler', 'BOWL', 'BOWL', 'B', 72, 'INDIAN', 'Indian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/10225/t-natarajan', 63.0, NULL, NULL, NULL, 67.0, 8.94, 30.12, NULL, NULL, NULL, 61, 47.0, 57.0, 74.0, NULL, NULL, NULL),
('2e82b327-a44d-4e67-9a14-e08a5097f20e', 66, 'Philip Salt', 'Royal Challengers Bengaluru', 'WK-Batsman', 'WK', 'BAT_WK', 'B', 71, 'OVERSEAS', 'English', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/10479/philip-salt', 34.0, 1056.0, 175.71, 34.06, NULL, NULL, NULL, 23.0, 95.0, 84.0, 47, NULL, NULL, NULL, NULL, NULL, NULL),
('21eba79a-78b6-4aca-b6db-a72a425a32cb', 34, 'Quinton de Kock', 'Mumbai Indians', 'WK-Batsman', 'WK', 'BAT_WK', 'B', 79, 'OVERSEAS', 'South African', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/8520/quinton-de-kock', 115.0, 3309.0, 134.03, 30.64, NULL, NULL, NULL, 64.0, 67.0, 76.0, 87, NULL, NULL, NULL, NULL, NULL, NULL),
('43728e84-8f01-4d4b-9aa9-fc1f7153acb7', 126, 'Nathan Ellis', 'Chennai Super Kings', 'Bowler', 'BOWL', 'BOWL', 'C', 61, 'OVERSEAS', 'Australian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/15480/nathan-ellis', 17.0, NULL, NULL, NULL, 19.0, 8.67, 28.74, NULL, NULL, NULL, 38, 16.0, 61.0, 77.0, NULL, NULL, NULL),
('90d810c5-9b69-47e1-816f-f2753caa22dd', 96, 'Vaibhav Arora', 'Kolkata Knight Riders', 'Bowler', 'BOWL', 'BOWL', 'C', 66, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/15861/vaibhav-arora', 32.0, NULL, NULL, NULL, 36.0, 9.55, 28.22, NULL, NULL, NULL, 46, 27.0, 47.0, 78.0, NULL, NULL, NULL),
('1b156bb5-ea2f-4d96-a4dd-ca68dde0f66c', 110, 'Josh Inglis', 'Lucknow Super Giants', 'WK-Batsman', 'WK', 'BAT_WK', 'C', 63, 'OVERSEAS', 'Australian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/10637/josh-inglis', 11.0, 278.0, 162.58, 30.89, NULL, NULL, NULL, 9.0, 87.0, 77.0, 35, NULL, NULL, NULL, NULL, NULL, NULL),
('fd4f7222-80d8-431a-81c0-22839167c0a1', 36, 'Arshdeep Singh', 'Punjab Kings', 'Bowler', 'BOWL', 'BOWL', 'B', 78, 'INDIAN', 'Indian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/13217/arshdeep-singh', 82.0, NULL, NULL, NULL, 97.0, 9.0, 26.49, NULL, NULL, NULL, 71, 66.0, 56.0, 81.0, NULL, NULL, NULL),
('ddaa6ffa-6129-4b3c-83ae-c2f6da05ca8b', 148, 'Vignesh Puthur', 'Rajasthan Royals', 'Bowler', 'BOWL', 'BOWL', 'C', 57, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/1447337/vignesh-puthur', 5.0, NULL, NULL, NULL, 6.0, 9.08, 18.17, NULL, NULL, NULL, 32, 7.0, 54.0, 99.0, NULL, NULL, NULL),
('3a02d9cd-f49f-4255-b059-fe01cf112fb0', 13, 'Axar Patel', 'Delhi Capitals', 'Bowling Allrounder', 'AR', 'AR', 'A', 91, 'INDIAN', 'Indian', 2, false, NULL, NULL, 6, 'https://www.cricbuzz.com/profiles/8808/axar-patel', 162.0, 1916.0, NULL, NULL, 128.0, NULL, NULL, NULL, NULL, NULL, 99, NULL, NULL, NULL, 82.0, 72.0, 72.0),
('0ba7eec1-975d-4ac3-a80e-ed0786568f46', 127, 'Digvesh Singh Rathi', 'Lucknow Super Giants', 'Bowler', 'BOWL', 'BOWL', 'C', 61, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/1448289/digvesh-singh-rathi', 13.0, NULL, NULL, NULL, 14.0, 8.25, 30.64, NULL, NULL, NULL, 36, 12.0, 68.0, 72.0, NULL, NULL, NULL),
('60e573e3-d1b0-4aeb-8a3a-e5d2d726e50f', 153, 'Urvil Patel', 'Chennai Super Kings', 'WK-Batsman', 'WK', 'BAT_WK', 'C', 56, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/13476/urvil-patel', 3.0, 68.0, 212.5, 22.67, NULL, NULL, NULL, 5.0, 99.0, 57.0, 31, NULL, NULL, NULL, NULL, NULL, NULL),
('f58685d3-9fdc-4b68-958a-b5ae096e95c9', 50, 'Mitchell Marsh', 'Lucknow Super Giants', 'Batting Allrounder', 'AR', 'AR', 'B', 74, 'OVERSEAS', 'Australian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/6250/mitchell-marsh', 55.0, 1292.0, NULL, NULL, 37.0, NULL, NULL, NULL, NULL, NULL, 57, NULL, NULL, NULL, 72.0, 43.0, 43.0),
('404e5c6e-a0bc-4212-a88e-6e54a0342a8f', 9, 'KL Rahul', 'Delhi Capitals', 'WK-Batsman', 'WK', 'BAT_WK', 'A', 95, 'INDIAN', 'Indian', 2, false, NULL, NULL, 4, 'https://www.cricbuzz.com/profiles/8733/kl-rahul', 145.0, 5222.0, 136.03, 46.21, NULL, NULL, NULL, 99.0, 69.0, 99.0, 99, NULL, NULL, NULL, NULL, NULL, NULL),
('c3b14f6e-90dd-494d-af92-50818ffd868a', 133, 'Kyle Jamieson', 'Delhi Capitals', 'Bowler', 'BOWL', 'BOWL', 'C', 59, 'OVERSEAS', 'New Zealander', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/9441/kyle-jamieson', 13.0, NULL, NULL, NULL, 14.0, 9.67, 29.71, NULL, NULL, NULL, 36, 12.0, 45.0, 74.0, NULL, NULL, NULL),
('79b0aa13-64f3-4f20-8b20-698fdac1551a', 136, 'Arshad Khan', 'Gujarat Titans', 'Bowling Allrounder', 'AR', 'AR', 'C', 58, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/18637/arshad-khan', 19.0, 124.0, NULL, NULL, 12.0, NULL, NULL, NULL, NULL, NULL, 39, NULL, NULL, NULL, 39.0, 18.0, 18.0),
('c1066f61-2c32-4dd5-ba95-c029f912151e', 83, 'Jason Holder', 'Gujarat Titans', 'Bowling Allrounder', 'AR', 'AR', 'C', 68, 'OVERSEAS', 'West Indian', 0.5, false, NULL, NULL, 2, 'https://www.cricbuzz.com/profiles/8313/jason-holder', 46.0, 259.0, NULL, NULL, 53.0, NULL, NULL, NULL, NULL, NULL, 53, NULL, NULL, NULL, 32.0, 45.0, 32.0),
('8905cd01-6cf9-4e1c-a5e9-3b14cbaf3246', 74, 'Devdutt Padikkal', 'Royal Challengers Bengaluru', 'Batsman', 'BAT', 'BAT_WK', 'B', 70, 'INDIAN', 'Indian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/13088/devdutt-padikkal', 74.0, 1806.0, 126.3, 25.44, NULL, NULL, NULL, 37.0, 62.0, 64.0, 67, NULL, NULL, NULL, NULL, NULL, NULL),
('ec6c3d6a-ea6a-4aaa-b976-c1a59fd130f5', 59, 'Rahul Tewatia', 'Gujarat Titans', 'Batting Allrounder', 'AR', 'AR', 'B', 73, 'INDIAN', 'Indian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/9693/rahul-tewatia', 108.0, 1112.0, NULL, NULL, 32.0, NULL, NULL, NULL, NULL, NULL, 84, NULL, NULL, NULL, 64.0, 38.0, 38.0),
('77b19b81-5258-4089-b2e7-fc71cd7b6954', 60, 'Noor Ahmad', 'Chennai Super Kings', 'Bowler', 'BOWL', 'BOWL', 'B', 72, 'OVERSEAS', 'Afghan', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/15452/noor-ahmad', 37.0, NULL, NULL, NULL, 48.0, 8.08, 22.23, NULL, NULL, NULL, 48, 34.0, 71.0, 90.0, NULL, NULL, NULL),
('74f13e4d-d266-4dd5-a372-1bed09b65ce4', 20, 'Jos Buttler', 'Gujarat Titans', 'WK-Batsman', 'WK', 'BAT_WK', 'A', 88, 'OVERSEAS', 'English', 2, false, NULL, NULL, 2, 'https://www.cricbuzz.com/profiles/2258/jos-buttler', 121.0, 4120.0, 149.39, 40.0, NULL, NULL, NULL, 79.0, 78.0, 99.0, 90, NULL, NULL, NULL, NULL, NULL, NULL),
('618210fc-70b6-4654-86d2-064672249f9e', 113, 'Marco Jansen', 'Punjab Kings', 'Bowling Allrounder', 'AR', 'AR', 'C', 62, 'OVERSEAS', 'South African', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/14565/marco-jansen', 35.0, 141.0, NULL, NULL, 36.0, NULL, NULL, NULL, NULL, NULL, 47, NULL, NULL, NULL, 26.0, 36.0, 26.0),
('30af52da-46e9-46e3-8b4a-1bcd82ec034f', 102, 'Angkrish Raghuvanshi', 'Kolkata Knight Riders', 'Batsman', 'BAT', 'BAT_WK', 'C', 65, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/22566/angkrish-raghuvanshi', 22.0, 463.0, 144.69, 28.94, NULL, NULL, NULL, 12.0, 75.0, 72.0, 41, NULL, NULL, NULL, NULL, NULL, NULL),
('59fa7e9b-8377-4ec8-bdba-c78e109213cb', 14, 'Ajinkya Rahane', 'Kolkata Knight Riders', 'Batsman', 'BAT', 'BAT_WK', 'A', 91, 'INDIAN', 'Indian', 2, false, NULL, NULL, 4, 'https://www.cricbuzz.com/profiles/1447/ajinkya-rahane', 198.0, 5032.0, 125.02, 30.5, NULL, NULL, NULL, 95.0, 61.0, 76.0, 99, NULL, NULL, NULL, NULL, NULL, NULL),
('4231f629-7219-4352-8dc9-bb09717911cc', 52, 'Rahul Tripathi', 'Kolkata Knight Riders', 'Batsman', 'BAT', 'BAT_WK', 'B', 74, 'INDIAN', 'Indian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/9012/rahul-tripathi', 100.0, 2291.0, 137.85, 26.03, NULL, NULL, NULL, 46.0, 70.0, 65.0, 80, NULL, NULL, NULL, NULL, NULL, NULL),
('16d91dfd-fc4a-4b79-89c8-2a21d326b739', 106, 'Sarfaraz Khan', 'Chennai Super Kings', 'Batsman', 'BAT', 'BAT_WK', 'C', 64, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/9429/sarfaraz-khan', 50.0, 585.0, 130.59, 22.5, NULL, NULL, NULL, 15.0, 65.0, 56.0, 55, NULL, NULL, NULL, NULL, NULL, NULL),
('7841501e-e274-4048-afbf-bf4728754790', 4, 'Sunil Narine', 'Kolkata Knight Riders', 'Bowling Allrounder', 'AR', 'AR', 'A', 98, 'OVERSEAS', 'West Indian', 2, false, NULL, NULL, 10, 'https://www.cricbuzz.com/profiles/2276/sunil-narine', 188.0, 1780.0, NULL, NULL, 192.0, NULL, NULL, NULL, NULL, NULL, 99, NULL, NULL, NULL, 84.0, 83.0, 83.0),
('62c5a138-45b7-4058-8f24-8f714974f8ed', 79, 'Prabhsimran Singh', 'Punjab Kings', 'WK-Batsman', 'WK', 'BAT_WK', 'C', 69, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/14254/prabhsimran-singh', 51.0, 1305.0, 151.93, 25.59, NULL, NULL, NULL, 28.0, 79.0, 64.0, 55, NULL, NULL, NULL, NULL, NULL, NULL),
('c12f5624-a5e0-4ab1-bd91-01187e255ccf', 144, 'Vijaykumar Vyshak', 'Punjab Kings', 'Bowler', 'BOWL', 'BOWL', 'C', 57, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/10486/vijaykumar-vyshak', 16.0, NULL, NULL, NULL, 17.0, 10.38, 33.88, NULL, NULL, NULL, 38, 14.0, 33.0, 66.0, NULL, NULL, NULL),
('e86a2820-758f-48fe-963c-ca04802d5fc4', 46, 'Avesh Khan', 'Lucknow Super Giants', 'Bowler', 'BOWL', 'BOWL', 'B', 76, 'INDIAN', 'Indian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/9781/avesh-khan', 75.0, NULL, NULL, NULL, 87.0, 9.12, 28.29, NULL, NULL, NULL, 67, 60.0, 54.0, 77.0, NULL, NULL, NULL),
('2626db0f-cd6c-4656-8e48-a0bc3c7ca62f', 22, 'Kagiso Rabada', 'Gujarat Titans', 'Bowler', 'BOWL', 'BOWL', 'A', 85, 'OVERSEAS', 'South African', 2, false, NULL, NULL, 2, 'https://www.cricbuzz.com/profiles/9585/kagiso-rabada', 84.0, NULL, NULL, NULL, 119.0, 8.62, 22.96, NULL, NULL, NULL, 72, 80.0, 62.0, 89.0, NULL, NULL, NULL),
('e314b6e6-fc2e-4924-af49-41ae1a474d7d', 51, 'Sam Curran', 'Rajasthan Royals', 'Bowling Allrounder', 'AR', 'AR', 'B', 74, 'OVERSEAS', 'English', 1, false, NULL, NULL, 2, 'https://www.cricbuzz.com/profiles/10420/sam-curran', 64.0, 997.0, NULL, NULL, 59.0, NULL, NULL, NULL, NULL, NULL, 62, NULL, NULL, NULL, 62.0, 41.0, 41.0),
('bd08e42a-7060-4b4e-89ee-e5f731460f06', 45, 'Shivam Dube', 'Chennai Super Kings', 'Batting Allrounder', 'AR', 'AR', 'B', 76, 'INDIAN', 'Indian', 1, false, NULL, NULL, 2, 'https://www.cricbuzz.com/profiles/11195/shivam-dube', 79.0, 1859.0, NULL, NULL, 5.0, NULL, NULL, NULL, NULL, NULL, 69, NULL, NULL, NULL, 88.0, 20.0, 20.0),
('346db426-c1f4-4bad-a7da-e5d1d5eec93b', 147, 'Mayank Yadav', 'Lucknow Super Giants', 'Bowler', 'BOWL', 'BOWL', 'C', 57, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/22401/mayank-yadav', 6.0, NULL, NULL, NULL, 9.0, 9.17, 20.56, NULL, NULL, NULL, 33, 9.0, 53.0, 94.0, NULL, NULL, NULL),
('c11e4f08-5fb9-47c2-9793-dcb1c5f1ed94', 1, 'Virat Kohli', 'Royal Challengers Bengaluru', 'Batsman', 'BAT', 'BAT_WK', 'A', 99, 'INDIAN', 'Indian', 2, false, NULL, NULL, 10, 'https://www.cricbuzz.com/profiles/1413/virat-kohli', 267.0, 8661.0, 132.86, 39.55, NULL, NULL, NULL, 99.0, 67.0, 98.0, 99, NULL, NULL, NULL, NULL, NULL, NULL),
('2e09f767-3c8f-4b96-bfcf-b4c1e48b376e', 33, 'Ishant Sharma', 'Gujarat Titans', 'Bowler', 'BOWL', 'BOWL', 'B', 79, 'INDIAN', 'Indian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/702/ishant-sharma', 117.0, NULL, NULL, NULL, 96.0, 8.38, 35.18, NULL, NULL, NULL, 88, 65.0, 66.0, 63.0, NULL, NULL, NULL),
('a8441401-9058-42d9-8943-3e631d39fa49', 152, 'Anukul Roy', 'Kolkata Knight Riders', 'Batting Allrounder', 'AR', 'AR', 'C', 56, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/12344/anukul-roy', 11.0, 26.0, NULL, NULL, 6.0, NULL, NULL, NULL, NULL, NULL, 35, NULL, NULL, NULL, 17.0, 29.0, 17.0),
('d4c03640-042c-49e4-a549-acca90d0423b', 2, 'Yuzvendra Chahal', 'Punjab Kings', 'Bowler', 'BOWL', 'BOWL', 'A', 99, 'INDIAN', 'Indian', 2, false, NULL, NULL, 10, 'https://www.cricbuzz.com/profiles/7910/yuzvendra-chahal', 174.0, NULL, NULL, NULL, 221.0, 7.96, 22.77, NULL, NULL, NULL, 99, 99.0, 73.0, 89.0, NULL, NULL, NULL),
('01d7b0f4-3c9c-47b5-a4b8-f426c7f1b7eb', 70, 'Venkatesh Iyer', 'Royal Challengers Bengaluru', 'Batting Allrounder', 'AR', 'AR', 'B', 70, 'INDIAN', 'Indian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/10917/venkatesh-iyer', 61.0, 1468.0, NULL, NULL, 3.0, NULL, NULL, NULL, NULL, NULL, 60, NULL, NULL, NULL, 77.0, 16.0, 16.0),
('96d9ce6f-f750-4adf-96e3-9f2fe08e4d00', 107, 'Shahbaz Ahmed', 'Lucknow Super Giants', 'Bowling Allrounder', 'AR', 'AR', 'C', 64, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/14606/shahbaz-ahmed', 58.0, 545.0, NULL, NULL, 22.0, NULL, NULL, NULL, NULL, NULL, 59, NULL, NULL, NULL, 43.0, 27.0, 27.0),
('18224a55-f6ac-4bca-b6ed-bb4e11f0ee60', 121, 'Suyash Sharma', 'Royal Challengers Bengaluru', 'Bowler', 'BOWL', 'BOWL', 'C', 61, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/36487/suyash-sharma', 27.0, NULL, NULL, NULL, 18.0, 8.75, 45.22, NULL, NULL, NULL, 43, 15.0, 60.0, 41.0, NULL, NULL, NULL),
('4ff7349d-96cc-4c5c-83a3-4ff6efb39bd0', 62, 'Shimron Hetmyer', 'Rajasthan Royals', 'Batsman', 'BAT', 'BAT_WK', 'B', 72, 'OVERSEAS', 'West Indian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/9789/shimron-hetmyer', 86.0, 1482.0, 151.85, 29.06, NULL, NULL, NULL, 31.0, 79.0, 72.0, 73, NULL, NULL, NULL, NULL, NULL, NULL),
('c07b77ca-37c6-45e3-ac21-7f3565d6be79', 99, 'Yash Dayal', 'Royal Challengers Bengaluru', 'Bowler', 'BOWL', 'BOWL', 'C', 66, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/14172/yash-dayal', 43.0, NULL, NULL, NULL, 41.0, 9.58, 33.9, NULL, NULL, NULL, 51, 30.0, 46.0, 66.0, NULL, NULL, NULL),
('52899a68-c059-400b-bb37-fe525ce4e1ea', 35, 'Deepak Chahar', 'Mumbai Indians', 'Bowler', 'BOWL', 'BOWL', 'B', 78, 'INDIAN', 'Indian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/7836/deepak-chahar', 95.0, NULL, NULL, NULL, 88.0, 8.14, 29.51, NULL, NULL, NULL, 77, 60.0, 70.0, 75.0, NULL, NULL, NULL),
('03a7d115-d3e4-42be-b813-8e260f668848', 89, 'Dhruv Jurel', 'Rajasthan Royals', 'WK-Batsman', 'WK', 'BAT_WK', 'C', 67, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/14691/dhruv-jurel', 41.0, 680.0, 153.85, 28.33, NULL, NULL, NULL, 16.0, 81.0, 71.0, 50, NULL, NULL, NULL, NULL, NULL, NULL),
('f2b155a4-fdf3-4e7f-b64c-ca9c84f64777', 92, 'Shashank Singh', 'Punjab Kings', 'Batting Allrounder', 'AR', 'AR', 'C', 67, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/10919/shashank-singh', 41.0, 773.0, NULL, NULL, 1.0, NULL, NULL, NULL, NULL, NULL, 50, NULL, NULL, NULL, 67.0, 14.0, 14.0),
('3db8f27a-2a51-4b62-8fa7-b0ca19140aa8', 128, 'Yash Thakur', 'Punjab Kings', 'Bowler', 'BOWL', 'BOWL', 'C', 61, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/12096/yash-thakur', 21.0, NULL, NULL, NULL, 25.0, 10.43, 30.8, NULL, NULL, NULL, 40, 20.0, 32.0, 72.0, NULL, NULL, NULL),
('75360760-2210-46cd-a578-bc9fa0002cfb', 12, 'Trent Boult', 'Mumbai Indians', 'Bowler', 'BOWL', 'BOWL', 'A', 92, 'OVERSEAS', 'New Zealander', 2, false, NULL, NULL, 4, 'https://www.cricbuzz.com/profiles/8117/trent-boult', 119.0, NULL, NULL, NULL, 143.0, 8.38, 26.2, NULL, NULL, NULL, 89, 96.0, 66.0, 82.0, NULL, NULL, NULL),
('115aae3f-ecbc-486f-a354-071a258d7108', 151, 'Dushmantha Chameera', 'Delhi Capitals', 'Bowler', 'BOWL', 'BOWL', 'C', 56, 'OVERSEAS', 'Sri Lankan', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/8393/dushmantha-chameera', 19.0, NULL, NULL, NULL, 13.0, 9.73, 46.38, NULL, NULL, NULL, 39, 12.0, 44.0, 39.0, NULL, NULL, NULL),
('8bc329e0-f06c-4b3c-adac-b940091b9241', 76, 'Tristan Stubbs', 'Delhi Capitals', 'WK-Batsman', 'WK', 'BAT_WK', 'B', 70, 'OVERSEAS', 'South African', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/19243/tristan-stubbs', 32.0, 705.0, 163.2, 41.47, NULL, NULL, NULL, 17.0, 87.0, 99.0, 46, NULL, NULL, NULL, NULL, NULL, NULL),
('a73c2e67-ad49-4d2d-99d0-5ef6386b53ad', 111, 'Ryan Rickelton', 'Mumbai Indians', 'WK-Batsman', 'WK', 'BAT_WK', 'C', 62, 'OVERSEAS', 'South African', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/13070/ryan-rickelton', 14.0, 388.0, 150.98, 29.85, NULL, NULL, NULL, 11.0, 79.0, 74.0, 37, NULL, NULL, NULL, NULL, NULL, NULL),
('a4fa903e-298f-4991-8a48-50eacaa79662', 21, 'Krunal Pandya', 'Royal Challengers Bengaluru', 'Batting Allrounder', 'AR', 'AR', 'A', 86, 'INDIAN', 'Indian', 2, false, NULL, NULL, 4, 'https://www.cricbuzz.com/profiles/11311/krunal-pandya', 142.0, 1748.0, NULL, NULL, 93.0, NULL, NULL, NULL, NULL, NULL, 99, NULL, NULL, NULL, 77.0, 60.0, 60.0),
('3ecc8ac6-423d-4820-b175-35ab4adfc2b4', 67, 'Ayush Badoni', 'Lucknow Super Giants', 'Batting Allrounder', 'AR', 'AR', 'B', 71, 'INDIAN', 'Indian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/13907/ayush-badoni', 56.0, 963.0, NULL, NULL, 4.0, NULL, NULL, NULL, NULL, NULL, 58, NULL, NULL, NULL, 63.0, 37.0, 37.0),
('a08af788-727d-4050-bc46-f76b7ff550e2', 64, 'Shreyas Gopal', 'Chennai Super Kings', 'Bowler', 'BOWL', 'BOWL', 'B', 72, 'INDIAN', 'Indian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/9746/shreyas-gopal', 52.0, NULL, NULL, NULL, 52.0, 8.16, 25.92, NULL, NULL, NULL, 56, 37.0, 69.0, 83.0, NULL, NULL, NULL),
('1c4f613e-2efd-4219-ab72-32e44623febd', 30, 'Rishabh Pant', 'Lucknow Super Giants', 'WK-Batsman', 'WK', 'BAT_WK', 'B', 82, 'INDIAN', 'Indian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/10744/rishabh-pant', 125.0, 3553.0, 147.62, 34.16, NULL, NULL, NULL, 68.0, 76.0, 85.0, 92, NULL, NULL, NULL, NULL, NULL, NULL),
('936596dc-9ba3-49c6-85c0-62e890a611d7', 85, 'Mohsin Khan', 'Lucknow Super Giants', 'Bowler', 'BOWL', 'BOWL', 'C', 67, 'INDIAN', 'Indian', 0.5, true, 'The Injury-Defying Giant (Grade C)', 'I might spend a little too much time hanging out in the physio room, but when I’m fit, my tall left-arm pace is an absolute nightmare. My absolute peak IPL moment was coming back from a massive shoulder injury to defend just 11 runs in the final over against Tim David and Cameron Green. While others shuffle around in auctions, I’ve stayed put to lead the pace attack for the Nawabs in the North. Who am I?', 0, 'https://www.cricbuzz.com/profiles/13534/mohsin-khan', 24.0, NULL, NULL, NULL, 27.0, 8.51, 25.52, NULL, NULL, NULL, 42, 21.0, 64.0, 83.0, NULL, NULL, NULL),
('02592396-42a5-4fe4-81fd-56fe6a9edf2a', 6, 'Rohit Sharma', 'Mumbai Indians', 'Batsman', 'BAT', 'BAT_WK', 'A', 96, 'INDIAN', 'Indian', 2, false, NULL, NULL, 8, 'https://www.cricbuzz.com/profiles/576/rohit-sharma', 272.0, 7046.0, 132.1, 29.73, NULL, NULL, NULL, 99.0, 66.0, 74.0, 99, NULL, NULL, NULL, NULL, NULL, NULL),
('f0760eed-5873-416f-8424-fe4a80f3fdfb', 125, 'Vaibhav Suryavanshi', 'Rajasthan Royals', 'Batsman', 'BAT', 'BAT_WK', 'C', 61, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/51791/vaibhav-suryavanshi', 7.0, 252.0, 206.56, 36.0, NULL, NULL, NULL, 9.0, 99.0, 89.0, 33, NULL, NULL, NULL, NULL, NULL, NULL),
('ae4fc310-0831-48c2-9bc2-feb83daf8f33', 18, 'Rashid Khan', 'Gujarat Titans', 'Bowling Allrounder', 'AR', 'AR', 'A', 89, 'OVERSEAS', 'Afghan', 2, false, NULL, NULL, 8, 'https://www.cricbuzz.com/profiles/10738/rashid-khan', 136.0, 585.0, NULL, NULL, 158.0, NULL, NULL, NULL, NULL, NULL, 98, NULL, NULL, NULL, 51.0, 82.0, 51.0),
('17a3bb50-99e1-4a22-a896-b5f290cf147b', 49, 'Ravi Bishnoi', 'Rajasthan Royals', 'Bowler', 'BOWL', 'BOWL', 'B', 75, 'INDIAN', 'Indian', 1, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/14659/ravi-bishnoi', 77.0, NULL, NULL, NULL, 72.0, 8.22, 31.07, NULL, NULL, NULL, 68, 50.0, 68.0, 72.0, NULL, NULL, NULL),
('7a9ceab2-928c-416f-8545-ad867380229e', 7, 'Ravindra Jadeja', 'Rajasthan Royals', 'Bowling Allrounder', 'AR', 'AR', 'A', 95, 'INDIAN', 'Indian', 2, false, NULL, NULL, 8, 'https://www.cricbuzz.com/profiles/587/ravindra-jadeja', 254.0, 3260.0, NULL, NULL, 170.0, NULL, NULL, NULL, NULL, NULL, 99, NULL, NULL, NULL, 85.0, 78.0, 78.0),
('0e74260c-a4e2-4849-a1c9-b229185fb3ab', 24, 'Varun Chakaravarthy', 'Kolkata Knight Riders', 'Bowler', 'BOWL', 'BOWL', 'B', 84, 'INDIAN', 'Indian', 1, false, NULL, NULL, 2, 'https://www.cricbuzz.com/profiles/12926/varun-chakaravarthy', 83.0, NULL, NULL, NULL, 100.0, 7.58, 23.85, NULL, NULL, NULL, 71, 68.0, 79.0, 87.0, NULL, NULL, NULL),
('d2c9373f-1c4c-4103-81c1-69aca0b7caec', 146, 'Anshul Kamboj', 'Chennai Super Kings', 'Bowling Allrounder', 'AR', 'AR', 'C', 57, 'INDIAN', 'Indian', 0.5, false, NULL, NULL, 0, 'https://www.cricbuzz.com/profiles/14598/anshul-kamboj', 11.0, 16.0, NULL, NULL, 10.0, NULL, NULL, NULL, NULL, NULL, 35, NULL, NULL, NULL, 21.0, 30.0, 21.0),
('a524e062-c8cf-4c75-8776-c50b564ad079', 3, 'Jasprit Bumrah', 'Mumbai Indians', 'Bowler', 'BOWL', 'BOWL', 'A', 99, 'INDIAN', 'Indian', 2, false, NULL, NULL, 8, 'https://www.cricbuzz.com/profiles/9311/jasprit-bumrah', 145.0, NULL, NULL, NULL, 183.0, 7.25, 22.03, NULL, NULL, NULL, 99, 99.0, 84.0, 91.0, NULL, NULL, NULL);

INSERT INTO "AuctionPlayer" (id, player_id, status) VALUES
('37c90a9e-fb15-47bb-8767-3738f8cf0595', '2cf292a5-a2f3-4f6a-af79-333a8e5c495d', 'UNSOLD'),
('a2a8d9d5-a4a1-4f0f-9c86-3473246edb65', '73611099-eaa0-4755-a9a3-af7c4cd0df5e', 'UNSOLD'),
('631d53f7-3818-450e-9107-55efee297d6f', 'dc671d79-39eb-4aa1-a5af-8a58c56560db', 'UNSOLD'),
('85d72bb9-7d40-4df6-8706-851f1c18d4cf', 'aa583568-a6ad-42c2-85cc-614d383a5d63', 'UNSOLD'),
('10ec0400-a463-4804-86b2-95795e6a308b', '49bd913b-a38c-4fba-b1f7-d0dd2bd83c40', 'UNSOLD'),
('8956a213-f693-439c-a2a0-7100fd6ddf76', '060df6a0-cdb2-4d33-8366-2229a6741323', 'UNSOLD'),
('0cd86ed7-45b4-4c4a-abed-d91601436fcf', '23e56464-e3aa-428b-a411-060a2dd3020c', 'UNSOLD'),
('8b72f3b4-1e10-4c13-a7a5-657c9c325e9f', 'a073d3f7-048b-4bd5-8666-9dc714377476', 'UNSOLD'),
('251ba345-2371-4edd-910d-44f06c83f222', '670c5b03-56f1-43fc-84ee-add8fba094a7', 'UNSOLD'),
('3ec19855-3876-4df4-a818-825310a2d663', 'd2e12a18-e015-4043-b719-c6a492c48ec0', 'UNSOLD'),
('41dafb47-2034-49e0-83e3-5a0dfc2e6dce', '59e180da-a348-4a59-9bf1-6acc9a44beef', 'UNSOLD'),
('56bc0c82-90d6-478b-8216-3ee40c5beb4d', '77f24d75-f002-4240-8894-b12ee102d314', 'UNSOLD'),
('5f1c382a-e8a5-4bf8-8af1-218c305e2e7c', '73c940a8-bd21-4cad-816d-08ef9a4e1bf2', 'UNSOLD'),
('e3f7de7d-fcac-4e78-93c3-f1e7c4a7e0a3', '38e902e8-2b90-476a-8c77-21d591f099b5', 'UNSOLD'),
('809522f5-5fce-4bb9-a0ff-76728f9bdad6', 'fb817804-f222-4444-bca9-c0afa9b824aa', 'UNSOLD'),
('23b9fb21-0005-4724-982c-70873bf7094e', 'b1dbf184-1fc8-4a86-869d-457e01cbc841', 'UNSOLD'),
('e3c53c8f-44f9-4877-8222-2f7ca3740946', 'e7cbea04-94fe-4445-9e68-772ffcbdd19a', 'UNSOLD'),
('5a08d71a-45c6-4984-973e-581ea84fb51f', '0ae312a8-ea2b-40de-9736-d06bb61d084d', 'UNSOLD'),
('432f0c43-3db5-4a34-8a35-620571e3fb1c', 'e8521142-465a-48d0-8585-28dc08a7f968', 'UNSOLD'),
('5e55dab7-503f-40aa-899b-9c9089fe0dcd', 'f4db4407-a14b-4aff-87b1-fbfbaa1f80f1', 'UNSOLD'),
('916ecaf2-b423-4082-a2e1-c32666ab72e0', 'b1225bd2-2f2f-4a3a-98d6-f0efd723fac1', 'UNSOLD'),
('d2dcb672-0d0d-420a-b330-11953b46f3ca', 'b8e15fad-34ed-4ba2-823e-0cdb77962d3f', 'UNSOLD'),
('aab6a293-a764-45e2-922c-7be2f2e3d473', '38e3dcf1-aadb-4347-8e21-ac06fe20c208', 'UNSOLD'),
('99dfd884-7766-4fca-8a17-0b4ad99a3003', '902a8a28-805e-4814-b33f-a93bac8ef18c', 'UNSOLD'),
('346552dc-d9f7-4c7b-97eb-02495b70b812', '0574375b-9eb5-4535-b488-52d982004a6f', 'UNSOLD'),
('47347bbd-49f3-458b-b06e-638e11e31467', '84a03a48-2232-4db6-90ea-ac53b94a5234', 'UNSOLD'),
('86aff876-4583-483c-8479-38946b7a1266', '538f8f81-0049-443a-82d2-88518f480cc9', 'UNSOLD'),
('dd95462e-c79a-4bc6-9fd8-62ec6117f697', 'e87fbdd6-24c6-4197-8a8e-522bb676b0b3', 'UNSOLD'),
('e6006530-31f2-46fc-8d17-063bffccdb6a', 'e306859b-ffa5-438e-a67e-242ec9c513ca', 'UNSOLD'),
('b7f19008-dea1-4a17-9b42-2ef79e935e12', 'f5ba6c61-1ba5-4101-88e5-a67f57ab68da', 'UNSOLD'),
('dec7f689-0462-445b-abf7-f32a2cda4564', '4997d268-eccb-4933-8343-47bacaf8d11c', 'UNSOLD'),
('a98e97e5-4fc1-4448-938f-304928202def', '90cef674-42be-4db1-bc8a-8ec4fefe492c', 'UNSOLD'),
('15a089df-befd-4229-b14e-06f92494354d', '44f6de8b-924a-4b20-8a1e-466a8ccac164', 'UNSOLD'),
('47894bfc-78ea-4f5b-abb1-2e074a83fc72', '4aa79f15-1e92-4b11-b7f6-acbcd3462911', 'UNSOLD'),
('1fe1f22e-7e3f-4931-864b-036c5fa4d43c', '559c1c8e-451e-44ed-a1a0-13a8b51912e4', 'UNSOLD'),
('54c0d483-ff83-4102-aae4-4106403bd3c7', 'df58585a-be29-4afc-a159-83015d8c7672', 'UNSOLD'),
('c832b53b-fabb-499e-8bb1-de34948441f9', 'e98b18dc-a51f-4960-88bf-8c974114a64b', 'UNSOLD'),
('cfc505c7-7e05-4ebc-b373-aa36b413b887', '2b361884-db71-49d9-999c-bf4bb7bb7406', 'UNSOLD'),
('7e40b7c7-dcbb-437b-9252-e4e0007241b6', 'bff008ea-d2f0-4ac6-bce1-6d5d642dc6f9', 'UNSOLD'),
('a06dca2e-5f2a-4309-a077-838db8507bd5', '66568b87-5d1e-43bf-93b7-2aa6561cce51', 'UNSOLD'),
('af6ff08c-ced6-40b5-a2bf-3091cc5a77b0', 'e732810c-865c-4dbd-a81c-29520167d29f', 'UNSOLD'),
('e77422dd-b4f1-4945-afdc-fb0401afbd65', '763b70fb-96a9-4420-b231-0a4d8ddc9c71', 'UNSOLD'),
('2e9aecef-ba4b-4987-81c9-c3e6ef39e34f', '17f5e4f6-9007-4bb1-bdea-156c0de9b663', 'UNSOLD'),
('6cb4957f-d8af-4415-bf75-b2cceef125fd', 'fe93e554-866c-4a40-ba17-14965ea75961', 'UNSOLD'),
('d7f39c06-5db2-4d7e-bdaf-367253cb43b8', 'bb85a862-4f46-4d6d-bab0-a6041afda964', 'UNSOLD'),
('9a1a97e0-e3c2-4a39-9546-fe843da2282b', 'f0891476-ce83-4031-bcf1-3e04b776bd8e', 'UNSOLD'),
('9de65a84-8203-4c16-a87a-034ac16767de', 'e25c09d8-3b12-4bf1-bdfe-2430ee47ef2b', 'UNSOLD'),
('5ec9d843-2ca0-4a0c-b767-d9105f662b27', '365a341b-21c2-4469-b0a7-c18065f32433', 'UNSOLD'),
('336854f0-8283-49cd-9fe1-2a381d2a8321', '56958771-c351-4212-a230-83d87cdc507e', 'UNSOLD'),
('f78c71e8-6796-4079-9d98-a4df0bacda9f', '35829b26-529e-4d7f-9516-6635308d596c', 'UNSOLD'),
('3b58a182-ccb5-4229-97fc-6a1fc8a2d7d6', '275b80e4-553b-4d33-b3d6-972f81132133', 'UNSOLD'),
('239212f1-6625-430a-af96-1840204002d5', '52d93d17-5bd3-436c-910d-64df93fcc3ba', 'UNSOLD'),
('94151ecb-289c-4c98-901a-12bf8792e73d', '67dc6202-4bcb-42a9-a504-48d914390e08', 'UNSOLD'),
('f8ad9cf3-2225-4e6b-b1b8-3e119ba46b03', '82207bb3-070f-46c6-9a6d-31bc6620959e', 'UNSOLD'),
('e06fbb74-6558-4b72-9f51-669100ca3442', '5ee11b5e-c396-4e3a-8f86-1fc2751b930e', 'UNSOLD'),
('22dc896e-07b0-45b6-a5e6-8f77787747f2', 'c631b459-1088-41c8-9efb-eee8852ec36c', 'UNSOLD'),
('ebb08a64-3bdb-4f13-be91-6fd682e2a7f3', 'ae869843-c434-455c-a2dc-f720267f782b', 'UNSOLD'),
('37cf74e4-9539-428b-ba57-4508779ce23d', 'ae66ad8d-41c8-472c-98e8-6413143ff545', 'UNSOLD'),
('24cea262-625c-4022-8f3f-b36f660cf9cf', '53aa5fd7-2118-4c47-86bf-1d84d2730527', 'UNSOLD'),
('bfd1889b-d9e8-45c2-a5ab-fb3d7e47c979', 'c38e4d50-e74c-465a-9f73-f0a7861cc391', 'UNSOLD'),
('0e40585b-0cdc-4bd8-8c80-fe8da364ccf8', '2c867031-b6d9-460a-8b29-f16df484fc48', 'UNSOLD'),
('5a473e92-c1fe-452f-8b96-01cfbffbc5d6', '71fe849b-b883-41a1-ae9b-950c1431e762', 'UNSOLD'),
('3030584e-4627-46c2-8963-e3e21ee594d2', 'a9de1679-18d4-4b67-8a43-86f5d90f8c5e', 'UNSOLD'),
('77a562d7-ac89-48d2-b25f-e9760b5183ac', 'b341b006-725e-4b0e-ae3f-407600f57c0e', 'UNSOLD'),
('91969c2c-3d56-4e4e-a4f2-2553d6c55859', '266aa13d-b480-4430-aff5-f484ea5bb847', 'UNSOLD'),
('5c5f4e32-5364-4d87-a0e1-1b6649ddcaf9', '9fba0097-ca12-4111-bc6e-05ebc0a8a8c7', 'UNSOLD'),
('a2abb44a-c354-44b3-bcb0-91dafc96f00f', 'a5b76cfa-d79a-4de6-9b60-39e8766bac69', 'UNSOLD'),
('91d1caa2-4763-4ed2-99bc-d163a3aaf7a2', 'c891647a-331b-4c71-a31b-3ff23f41c534', 'UNSOLD'),
('78a02bc6-4a55-4ce6-bb24-6cc4bd6be743', '8430a3b9-0cc9-4e04-b254-8577c1ebf000', 'UNSOLD'),
('42443aca-5732-441a-981a-62883816b0e2', 'abac1449-87df-4415-ad5d-33d48f3e4fb0', 'UNSOLD'),
('70681ea8-f32f-4428-bf7f-5ed3e3f8d72f', 'bdc17dba-0c88-4385-9b49-7e5f98f5af1e', 'UNSOLD'),
('2cab1463-dd21-4ad3-a8ad-e3c904667c48', 'b88aef76-6dc2-4631-b80a-7f7c848dbfa5', 'UNSOLD'),
('d9086420-220d-4a44-8569-71e06f80173e', '9a51bbed-4ad3-4051-85c3-21203d8eaa2f', 'UNSOLD'),
('6ffe8eea-1001-4c57-897d-22f120f68bc8', '12af3b2f-9193-48ec-a38e-a257fd07d69b', 'UNSOLD'),
('b3a5432f-a55d-48bb-b9a3-0c270e8d6bcc', '12cab5f0-abe9-45ef-ac02-bab5b9f2589a', 'UNSOLD'),
('f7a9101b-287c-47fc-aca0-4180505cca4c', '322f624e-4660-4592-b66d-df7afd4f1724', 'UNSOLD'),
('b3f22fe6-f082-4ca8-9bfa-da0bb36f2e35', 'ec02b558-635d-4cf0-853d-4661dcc06ee0', 'UNSOLD'),
('6f0e4b75-c1c0-4a3e-bd19-6b747ab14283', 'e6bbbcd2-0962-4ab5-a60f-45c10329ebdb', 'UNSOLD'),
('062826be-12a2-4ddb-8bb5-77c4c48786e7', '33e44bec-e6af-483e-88b0-fe96cf42a05f', 'UNSOLD'),
('7ad822e0-70d0-46b0-92b9-fa4c8c1f01ed', '4efdd0e5-9ace-460f-911c-1704559a3529', 'UNSOLD'),
('a0e61086-4d4a-46f9-8609-90628b75a3ad', '584cbb32-f1b1-45c0-a289-e5772afbe2d6', 'UNSOLD'),
('c5da0af7-b9ac-42f1-bd27-4df1dc586d43', 'a7b590af-96f0-4063-a325-4eeb32f5c4a5', 'UNSOLD'),
('4185fb27-fbd2-4de9-8a9f-a50c938fab00', '1a0970bd-7094-4823-9530-e74d857152e9', 'UNSOLD'),
('0a4476f5-4c03-482f-a17f-19077f71dc7a', 'd821a8ce-bf1e-47b1-a84a-e7e3d98fb289', 'UNSOLD'),
('52b1697b-2051-4697-93f8-ff25dc73ae9d', 'a0332ebc-16f3-4c80-92d7-b8494daa1bab', 'UNSOLD'),
('6fc7daa2-987b-4d85-83d8-0624a3dfe156', '603a4be1-5125-437f-8de4-c56dab213bf0', 'UNSOLD'),
('134d4096-bdd6-495f-a7ae-5107bdf2e7e4', '8ca2e471-02ba-4b3c-8b7d-dac9db761d23', 'UNSOLD'),
('62dcd53c-7af6-49d3-ac9e-77f18dfc338b', '07205e6d-7485-4e41-a994-73938ddc4050', 'UNSOLD'),
('ddfbd97b-52c1-4a0d-ae9d-f187379c98eb', 'c2243a43-dc13-414f-baf4-b480a006f7cc', 'UNSOLD'),
('c3e2ad9b-e2ec-41f0-a535-44c52db7cc0a', '9b48a1c4-fdec-4591-a156-828c5cdc7049', 'UNSOLD'),
('5dafd18d-e2eb-4e10-be70-2994315137a2', '52d28657-460b-485d-a746-4d4a2b9062d0', 'UNSOLD'),
('a9ac1296-0a22-454a-b22b-915aa02fbecc', '445ae618-f2bc-4014-85ea-b9bd91495137', 'UNSOLD'),
('70d300ed-1a64-4bd4-a79a-a4323d7a2001', '49bc71ac-1808-4a0f-9e44-07ec0f6a7a7f', 'UNSOLD'),
('498b729e-93d4-455a-b6cb-3d017b5f9d0d', '5d103621-264e-4e6d-b6d6-ca6b0dfd2914', 'UNSOLD'),
('d7bebe04-2481-4f92-81c3-7417db574335', 'ddf0d493-91d7-44ae-a6b8-03f51016f4da', 'UNSOLD'),
('3e9bccc5-cdd2-4048-b8f0-21d8ffd6e23d', 'bbbc2d22-7a65-48f8-be0b-6f81d5bd4804', 'UNSOLD'),
('a2e9cfc5-1441-428e-9993-6eda383a150f', 'bce019ea-5f55-4a49-ab9a-e558422692ec', 'UNSOLD'),
('6b4b0f9e-0172-46c9-bd1f-c364a6479c27', '2e82b327-a44d-4e67-9a14-e08a5097f20e', 'UNSOLD'),
('d7ee0e17-067b-4943-a24c-0d1ac26bf865', '21eba79a-78b6-4aca-b6db-a72a425a32cb', 'UNSOLD'),
('1d591c67-af39-477c-9485-517e3a8b348e', '43728e84-8f01-4d4b-9aa9-fc1f7153acb7', 'UNSOLD'),
('88bbf06a-19d5-4246-856c-250fd1dc4a31', '90d810c5-9b69-47e1-816f-f2753caa22dd', 'UNSOLD'),
('66fc30c5-7b1c-4ed5-b76c-8d477d9a13a7', '1b156bb5-ea2f-4d96-a4dd-ca68dde0f66c', 'UNSOLD'),
('683d8699-d1f8-4143-811c-b17ce4c22ebb', 'fd4f7222-80d8-431a-81c0-22839167c0a1', 'UNSOLD'),
('917547f1-9a31-4afc-b5c3-6ec5e99848e0', 'ddaa6ffa-6129-4b3c-83ae-c2f6da05ca8b', 'UNSOLD'),
('e9564bd1-c6d3-4d2f-abec-0f596a65c59d', '3a02d9cd-f49f-4255-b059-fe01cf112fb0', 'UNSOLD'),
('912cfd48-d4ce-4fc5-9642-3c17c4565daf', '0ba7eec1-975d-4ac3-a80e-ed0786568f46', 'UNSOLD'),
('bf20b852-e78f-4d54-b58c-673632284632', '60e573e3-d1b0-4aeb-8a3a-e5d2d726e50f', 'UNSOLD'),
('06c888e8-d73a-45ad-a02e-d08ec413e269', 'f58685d3-9fdc-4b68-958a-b5ae096e95c9', 'UNSOLD'),
('148ebf8b-af49-4978-850f-d54788ddea10', '404e5c6e-a0bc-4212-a88e-6e54a0342a8f', 'UNSOLD'),
('ad12b7af-1754-4a76-9325-1d0b6b588068', 'c3b14f6e-90dd-494d-af92-50818ffd868a', 'UNSOLD'),
('53c2f601-6b6f-4656-9fc3-e0dbb2800057', '79b0aa13-64f3-4f20-8b20-698fdac1551a', 'UNSOLD'),
('556eb3eb-8863-4ace-aad9-6e603f5ace31', 'c1066f61-2c32-4dd5-ba95-c029f912151e', 'UNSOLD'),
('50d4ba4d-144c-413c-940f-01ba081a19be', '8905cd01-6cf9-4e1c-a5e9-3b14cbaf3246', 'UNSOLD'),
('8b134efd-db61-4101-aa78-a24a648fd186', 'ec6c3d6a-ea6a-4aaa-b976-c1a59fd130f5', 'UNSOLD'),
('bbb86091-ba91-4736-b753-3e3ef55cd07f', '77b19b81-5258-4089-b2e7-fc71cd7b6954', 'UNSOLD'),
('7f34d467-77b8-4500-b579-136c605115cb', '74f13e4d-d266-4dd5-a372-1bed09b65ce4', 'UNSOLD'),
('da630b2b-ff5a-443d-971e-ccd0c3cfc794', '618210fc-70b6-4654-86d2-064672249f9e', 'UNSOLD'),
('21ec2505-71aa-4752-9004-e6692e3091a9', '30af52da-46e9-46e3-8b4a-1bcd82ec034f', 'UNSOLD'),
('829b0190-aaac-4e03-910c-00c98b8aa997', '59fa7e9b-8377-4ec8-bdba-c78e109213cb', 'UNSOLD'),
('c0f6a941-dca8-4f5f-a2f1-43f567211685', '4231f629-7219-4352-8dc9-bb09717911cc', 'UNSOLD'),
('bebbaff0-3bc8-40f7-ab45-1fb046cd94b1', '16d91dfd-fc4a-4b79-89c8-2a21d326b739', 'UNSOLD'),
('2db9cb7d-a504-452b-ad01-f517af37b348', '7841501e-e274-4048-afbf-bf4728754790', 'UNSOLD'),
('4cd8c75b-ce77-4f4b-aeae-cd19d21e3803', '62c5a138-45b7-4058-8f24-8f714974f8ed', 'UNSOLD'),
('e4f10cf0-3175-48d4-93eb-941763b73f07', 'c12f5624-a5e0-4ab1-bd91-01187e255ccf', 'UNSOLD'),
('39939457-1e7c-4d37-92df-609fa4e96fae', 'e86a2820-758f-48fe-963c-ca04802d5fc4', 'UNSOLD'),
('eaa417e4-c6a1-4837-82a4-f0b44da5dfbd', '2626db0f-cd6c-4656-8e48-a0bc3c7ca62f', 'UNSOLD'),
('7c9cf016-aa71-4074-9414-bf2f9847207e', 'e314b6e6-fc2e-4924-af49-41ae1a474d7d', 'UNSOLD'),
('f5ac1fa4-0648-4879-a4e7-8fcdb49ef75c', 'bd08e42a-7060-4b4e-89ee-e5f731460f06', 'UNSOLD'),
('ffc75b2d-a04d-4714-a692-a949ec4a9b91', '346db426-c1f4-4bad-a7da-e5d1d5eec93b', 'UNSOLD'),
('e711539a-4085-48d3-b4b2-b477024a604d', 'c11e4f08-5fb9-47c2-9793-dcb1c5f1ed94', 'UNSOLD'),
('1deaf56e-fa2e-417d-81e9-f8d9935766c9', '2e09f767-3c8f-4b96-bfcf-b4c1e48b376e', 'UNSOLD'),
('3100d8ba-ecee-4e38-8cf9-5ded46328e9a', 'a8441401-9058-42d9-8943-3e631d39fa49', 'UNSOLD'),
('1fda8c40-2ca3-4a51-b21b-c5c8558e0f89', 'd4c03640-042c-49e4-a549-acca90d0423b', 'UNSOLD'),
('be816704-d791-4e13-8fa1-893f174dee0b', '01d7b0f4-3c9c-47b5-a4b8-f426c7f1b7eb', 'UNSOLD'),
('29f72d9c-be40-4530-ad7e-52c62fa928dd', '96d9ce6f-f750-4adf-96e3-9f2fe08e4d00', 'UNSOLD'),
('2e966960-3f46-4a29-8afa-0e2624e180e5', '18224a55-f6ac-4bca-b6ed-bb4e11f0ee60', 'UNSOLD'),
('914207e6-cda1-4b11-bcb0-d6d3cda632d0', '4ff7349d-96cc-4c5c-83a3-4ff6efb39bd0', 'UNSOLD'),
('0168a40c-0ae4-4470-8125-a91de67e2e5a', 'c07b77ca-37c6-45e3-ac21-7f3565d6be79', 'UNSOLD'),
('405b0116-c207-409f-a5b3-9aadd36ce8da', '52899a68-c059-400b-bb37-fe525ce4e1ea', 'UNSOLD'),
('91dd2fe5-31ba-445c-a33c-f5504c59280c', '03a7d115-d3e4-42be-b813-8e260f668848', 'UNSOLD'),
('3fdab566-2a1a-47cc-ae6c-182f498ae7bf', 'f2b155a4-fdf3-4e7f-b64c-ca9c84f64777', 'UNSOLD'),
('6f21ff6a-17dd-426d-8407-e2aebd891d71', '3db8f27a-2a51-4b62-8fa7-b0ca19140aa8', 'UNSOLD'),
('ef2725e4-c838-4c62-86bd-15119ffd3464', '75360760-2210-46cd-a578-bc9fa0002cfb', 'UNSOLD'),
('77b93fd0-31d4-4772-9890-4307d49e0508', '115aae3f-ecbc-486f-a354-071a258d7108', 'UNSOLD'),
('dfb6983e-84ff-42c2-a567-e6a63dcc09f7', '8bc329e0-f06c-4b3c-adac-b940091b9241', 'UNSOLD'),
('d2ab6015-eae6-4f3c-a38f-fe11573a797c', 'a73c2e67-ad49-4d2d-99d0-5ef6386b53ad', 'UNSOLD'),
('15d3befd-7c91-4eba-bae3-460c6b3bc09e', 'a4fa903e-298f-4991-8a48-50eacaa79662', 'UNSOLD'),
('e05395bb-f11b-4a7b-b10e-57844fbdc00d', '3ecc8ac6-423d-4820-b175-35ab4adfc2b4', 'UNSOLD'),
('615d7509-11cf-4976-a503-199ef72e4edc', 'a08af788-727d-4050-bc46-f76b7ff550e2', 'UNSOLD'),
('bedf7511-58fd-48aa-b9e4-cffc6925bbfe', '1c4f613e-2efd-4219-ab72-32e44623febd', 'UNSOLD'),
('a7566950-a918-4a3f-9bd0-3f9ceb0828f3', '936596dc-9ba3-49c6-85c0-62e890a611d7', 'UNSOLD'),
('95dde9eb-ce0c-4309-a1a5-39e34d863cff', '02592396-42a5-4fe4-81fd-56fe6a9edf2a', 'UNSOLD'),
('dcc21ea5-4fe7-422e-bcce-a34dcbe03a8a', 'f0760eed-5873-416f-8424-fe4a80f3fdfb', 'UNSOLD'),
('03a96d67-02fa-438a-b0c0-c979dd91a34f', 'ae4fc310-0831-48c2-9bc2-feb83daf8f33', 'UNSOLD'),
('13d515b1-a2e7-494c-8756-dd9404f4825b', '17a3bb50-99e1-4a22-a896-b5f290cf147b', 'UNSOLD'),
('3b0e52e0-8288-4a0a-be87-91ccbc8000bf', '7a9ceab2-928c-416f-8545-ad867380229e', 'UNSOLD'),
('ff1ae2cd-0b5f-4eb0-9a16-73011c1801e4', '0e74260c-a4e2-4849-a1c9-b229185fb3ab', 'UNSOLD'),
('b80e50c3-019a-43ee-8fb8-79fbae794416', 'd2c9373f-1c4c-4103-81c1-69aca0b7caec', 'UNSOLD'),
('5ef2fbfe-9e78-4a36-9cca-7114e3ad3986', 'a524e062-c8cf-4c75-8776-c50b564ad079', 'UNSOLD');

INSERT INTO "AdminUser" (id, username, password_hash, role) VALUES
('b74c0feb-0b04-4ce4-b660-17e9b608e516', 'admin', '$2b$10$rzHxLh7U.MEobsaCKhjUwe4Ud/h8k86gqzzmtVG4LVXYnowxkHOdC', 'ADMIN'),
('e1d87b21-7c63-41a4-8300-2431e999af42', 'screen', '$2b$10$Xwa9PxYFPqt5DyQtJ7GgP.LiQEG1b/2Ak3WuxfvK6q9sH5BswinCe', 'SCREEN');

INSERT INTO "AuctionSequence" (id, name, type, sequence_items) VALUES
(1, 'Franchise Auction', 'FRANCHISE', '[3,7,1,9,5,10,2,6,8,4]');

INSERT INTO "AuctionSequence" (id, name, type, sequence_items) VALUES
(2, 'Power Card Auction', 'POWER_CARD', '["GOD_EYE","MULLIGAN","FINAL_STRIKE","BID_FREEZER"]');

INSERT INTO "AuctionSequence" (id, name, type, sequence_items) VALUES
(3, 'Player Auction 3', 'PLAYER', '[134,137,104,138,100,115,117,37,87,141,53,143,29,5,42,78,86,154,71,131,105,32,116,91,118,94,54,112,27,90,119,25,65,135,103,108,26,145,157,150,23,47,15,69,77,123,122,16,39,17,44,43,124,114,149,156,140,158,130,75,73,88,41,56,129,120,40,97,19,93,98,109,38,61,8,82,139,101,55,48,11,84,142,68,132,95,72,10,58,80,31,81,57,28,155,159,63,66,34,126,96,110,36,148,13,127,153,50,9,133,136,83,74,59,60,20,113,102,14,52,106,4,79,144,46,22,51,45,147,1,33,152,2,70,107,121,62,99,35,89,92,128,12,151,76,111,21,67,64,30,85,6,125,18,49,7,24,146,3]');

INSERT INTO "AuctionState" (id, phase, auction_day) VALUES (1, 'NOT_STARTED', 'Day 1');

