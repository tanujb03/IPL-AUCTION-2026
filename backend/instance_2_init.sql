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
('eb7d60d0-0116-4b28-9d66-5472bf64fed8', 'Yashowardhan Deshmukh', 'yashowardhandeshmukh', '$2b$10$NGLMzS2W4hPMCyvq0zY72.ezxZU3nZM3tdP.HUXaQIoqpUWAFcQfq', 120, 0),
('c642b58b-9512-49fc-b239-f3d28c4a580f', 'Strategic Strikers', 'strategicstrikers', '$2b$10$WKqbktXwVhw6k8lVLgkiHO1HsH5dDPUeanD0cjcFFZvk3/euVnaKK', 120, 0),
('cb73f40d-aab0-42bd-9e66-c05c2fadb907', 'Royal Challengers Mumbai', 'royalchallengersmumb', '$2b$10$6tEZTifnZUwoF/Ho4RLtJOJRXmmlzEWl7ZrBCJXuaElRU3BnccVU6', 120, 0),
('052e08d1-751b-4cd6-9030-e075ce53f069', 'Gully Gang', 'gullygang', '$2b$10$jg/8REK3rrzuQwFXyclkHueoUeDJFfawAqNYOVjwDO0O23ITTnhbi', 120, 0),
('6a572f9c-7442-4c2f-b1d5-058b38fdf68e', 'Rangers', 'rangers', '$2b$10$Ftq0qel3LIc6588b3DSrtOXpumrGMVHk4I.TIuIMWHVZvhjOtO48i', 120, 0),
('ecf8f57b-ae14-4b8f-8457-283f2bc926ea', 'DOPA', 'dopa', '$2b$10$1Byzhpl2hUX158auL5i1H.js64XLQ8H4YUSmdaEUDQWy8e53gVxc6', 120, 0),
('cb96c14b-6595-4355-9906-4659831401a6', 'Conquerors', 'conquerors', '$2b$10$thgG/xEjF/HoZXkS20aYau2sYbJCuxnnBS16VgAXyBdYTY1ULShBu', 120, 0),
('10921e19-9fab-4f11-bbbd-d8b2aaa5101e', 'chambal ke daaku', 'chambalkedaaku', '$2b$10$RfrvEyVl7tN3HQfR1KgrmOzQgbE9pL1TvxdCXGxv37aMnA/3rlQ.q', 120, 0),
('145459dc-6b07-47e7-9cb5-2decdc74b3f6', 'Bibtya Warriors', 'bibtyawarriors', '$2b$10$9hatn6hvqqDVS25BucmvA.1xqzGKbD.GUbMRFP1iZSCxFYGru28NW', 120, 0),
('6ea77a36-bc63-4449-9860-4622b3d413e5', 'AN1227', 'an1227', '$2b$10$IwwKwTOYvasjTSh5lLRoqem5EtrMx5qv/SgUc1nBbYDh6A2BQH7eW', 120, 0);

INSERT INTO "Player" (id, rank, name, team, role, category, pool, grade, rating, nationality, nationality_raw, base_price, is_riddle, legacy, url, matches, bat_runs, bat_sr, bat_average, bowl_wickets, bowl_eco, bowl_avg, sub_scoring, sub_impact, sub_consistency, sub_experience, sub_wicket_taking, sub_economy, sub_efficiency, sub_batting, sub_bowling, sub_versatility) VALUES
('44c18873-44d1-4659-be69-aaaba8a124f0', 131, 'Romario Shepherd', 'Royal Challengers Bengaluru', 'Bowling Allrounder', 'AR', 'AR', 'C', 60, 'OVERSEAS', 'West Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/13646/romario-shepherd', 18.0, 185.0, NULL, NULL, 10.0, NULL, NULL, NULL, NULL, NULL, 39, NULL, NULL, NULL, 52.0, 18.0, 18.0),
('e6d3ce09-f799-4e01-b9cb-1df2cb6ada4f', 134, 'Vipraj Nigam', 'Delhi Capitals', 'Bowler', 'BOWL', 'BOWL', 'C', 59, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/1431811/vipraj-nigam', 14.0, NULL, NULL, NULL, 11.0, 9.13, 32.36, NULL, NULL, NULL, 37, 10.0, 54.0, 69.0, NULL, NULL, NULL),
('72e52cd7-c274-454c-a039-4d2bf18c6daa', 149, 'Glenn Phillips', 'Gujarat Titans', 'Batting Allrounder', 'AR', 'AR', 'C', 56, 'OVERSEAS', 'New Zealander', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/10693/glenn-phillips', 8.0, 65.0, NULL, NULL, 2.0, NULL, NULL, NULL, NULL, NULL, 34, NULL, NULL, NULL, 24.0, 34.0, 24.0),
('bccbc76f-ff37-4594-ab34-62c0ddff2c6e', 69, 'Liam Livingstone', 'Sunrisers Hyderabad', 'Batting Allrounder', 'AR', 'AR', 'B', 70, 'OVERSEAS', 'English', 1, false, 0, 'https://www.cricbuzz.com/profiles/10045/liam-livingstone', 49.0, 1051.0, NULL, NULL, 13.0, NULL, NULL, NULL, NULL, NULL, 54, NULL, NULL, NULL, 70.0, 28.0, 28.0),
('3d60cfa6-faeb-4d0b-8ab0-4da87542bbd5', 81, 'Harpreet Brar', 'Punjab Kings', 'Bowler', 'BOWL', 'BOWL', 'C', 68, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/14452/harpreet-brar', 49.0, NULL, NULL, NULL, 35.0, 8.03, 31.0, NULL, NULL, NULL, 54, 26.0, 71.0, 72.0, NULL, NULL, NULL),
('0424ca04-7214-40eb-8296-ded31ba268e6', 66, 'Philip Salt', 'Royal Challengers Bengaluru', 'WK-Batsman', 'WK', 'BAT_WK', 'B', 71, 'OVERSEAS', 'English', 1, false, 0, 'https://www.cricbuzz.com/profiles/10479/philip-salt', 34.0, 1056.0, 175.71, 34.06, NULL, NULL, NULL, 23.0, 95.0, 84.0, 47, NULL, NULL, NULL, NULL, NULL, NULL),
('f3208bad-dc99-4450-94af-9989b4723bda', 26, 'Jaydev Unadkat', 'Sunrisers Hyderabad', 'Bowler', 'BOWL', 'BOWL', 'B', 83, 'INDIAN', 'Indian', 1, false, 2, 'https://www.cricbuzz.com/profiles/6327/jaydev-unadkat', 112.0, NULL, NULL, NULL, 110.0, 8.88, 30.58, NULL, NULL, NULL, 86, 74.0, 58.0, 73.0, NULL, NULL, NULL),
('3399eca1-6f04-43bc-aead-a637290f415f', 34, 'Quinton de Kock', 'Mumbai Indians', 'WK-Batsman', 'WK', 'BAT_WK', 'B', 79, 'OVERSEAS', 'South African', 1, false, 0, 'https://www.cricbuzz.com/profiles/8520/quinton-de-kock', 115.0, 3309.0, 134.03, 30.64, NULL, NULL, NULL, 64.0, 67.0, 76.0, 87, NULL, NULL, NULL, NULL, NULL, NULL),
('dc97e782-09e9-4eda-aa9e-7626197282ee', 84, 'Cameron Green', 'Kolkata Knight Riders', 'Batting Allrounder', 'AR', 'AR', 'C', 68, 'OVERSEAS', 'Australian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/12225/cameron-green', 29.0, 707.0, NULL, NULL, 16.0, NULL, NULL, NULL, NULL, NULL, 44, NULL, NULL, NULL, 64.0, 27.0, 27.0),
('d663efe7-4094-4e49-bd44-8b6f5b4328f7', 23, 'Shubman Gill', 'Gujarat Titans', 'Batsman', 'BAT', 'BAT_WK', 'B', 84, 'INDIAN', 'Indian', 1, false, 0, 'https://www.cricbuzz.com/profiles/11808/shubman-gill', 118.0, 3866.0, 138.72, 39.45, NULL, NULL, NULL, 74.0, 70.0, 98.0, 89, NULL, NULL, NULL, NULL, NULL, NULL),
('85dce70e-d096-442d-b1cf-41ebf7749e2d', 116, 'Sherfane Rutherford', 'Mumbai Indians', 'Batting Allrounder', 'AR', 'AR', 'C', 62, 'OVERSEAS', 'West Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/13748/sherfane-rutherford', 23.0, 397.0, NULL, NULL, 1.0, NULL, NULL, NULL, NULL, NULL, 41, NULL, NULL, NULL, 48.0, 17.0, 17.0),
('3c28b853-73b0-431f-a9a8-a7d7d9ed5da3', 155, 'Swapnil Singh', 'Royal Challengers Bengaluru', 'Bowling Allrounder', 'AR', 'AR', 'C', 56, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/10238/swapnil-singh', 14.0, 51.0, NULL, NULL, 7.0, NULL, NULL, NULL, NULL, NULL, 37, NULL, NULL, NULL, 23.0, 27.0, 23.0),
('8771c813-890d-4ffc-ab38-b9a34312c806', 123, 'Ayush Mhatre', 'Chennai Super Kings', 'Batsman', 'BAT', 'BAT_WK', 'C', 61, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/1431163/ayush-mhatre', 7.0, 240.0, 188.98, 34.29, NULL, NULL, NULL, 8.0, 99.0, 85.0, 33, NULL, NULL, NULL, NULL, NULL, NULL),
('09db7b17-fd87-4029-8daa-79a7dbf36be3', 124, 'Shubham Dubey', 'Rajasthan Royals', 'Batsman', 'BAT', 'BAT_WK', 'C', 61, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/19328/shubham-dubey', 13.0, 139.0, 163.53, 23.17, NULL, NULL, NULL, 6.0, 87.0, 58.0, 36, NULL, NULL, NULL, NULL, NULL, NULL),
('d1799865-086b-4770-9b19-ba2bd904d92a', 142, 'Kamindu Mendis', 'Sunrisers Hyderabad', 'Batting Allrounder', 'AR', 'AR', 'C', 57, 'OVERSEAS', 'Sri Lankan', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/10940/kamindu-mendis', 5.0, 92.0, NULL, NULL, 2.0, NULL, NULL, NULL, NULL, NULL, 32, NULL, NULL, NULL, 38.0, 29.0, 29.0),
('12774762-fb80-4d7c-80fc-932eee368142', 148, 'Vignesh Puthur', 'Rajasthan Royals', 'Bowler', 'BOWL', 'BOWL', 'C', 57, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/1447337/vignesh-puthur', 5.0, NULL, NULL, NULL, 6.0, 9.08, 18.17, NULL, NULL, NULL, 32, 7.0, 54.0, 99.0, NULL, NULL, NULL),
('265e1735-5adc-4871-8605-b2d1e8fed200', 101, 'Umran Malik', 'Kolkata Knight Riders', 'Bowler', 'BOWL', 'BOWL', 'C', 65, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/19027/umran-malik', 26.0, NULL, NULL, NULL, 29.0, 9.4, 26.62, NULL, NULL, NULL, 43, 22.0, 49.0, 81.0, NULL, NULL, NULL),
('b61bc9e3-6840-41bb-b347-ad5363dea9f6', 94, 'Will Jacks', 'Mumbai Indians', 'Batting Allrounder', 'AR', 'AR', 'C', 66, 'OVERSEAS', 'English', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/12258/will-jacks', 21.0, 463.0, NULL, NULL, 8.0, NULL, NULL, NULL, NULL, NULL, 40, NULL, NULL, NULL, 55.0, 28.0, 28.0),
('a8075d31-2eae-47c8-b984-401f92d14e80', 119, 'Wanindu Hasaranga', 'Lucknow Super Giants', 'Bowling Allrounder', 'AR', 'AR', 'C', 62, 'OVERSEAS', 'Sri Lankan', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/10926/wanindu-hasaranga', 37.0, 81.0, NULL, NULL, 46.0, NULL, NULL, NULL, NULL, NULL, 48, NULL, NULL, NULL, 15.0, 45.0, 15.0),
('b347396e-5f55-46dd-96f1-b84cc072d569', 76, 'Tristan Stubbs', 'Delhi Capitals', 'WK-Batsman', 'WK', 'BAT_WK', 'B', 70, 'OVERSEAS', 'South African', 1, false, 0, 'https://www.cricbuzz.com/profiles/19243/tristan-stubbs', 32.0, 705.0, 163.2, 41.47, NULL, NULL, NULL, 17.0, 87.0, 99.0, 46, NULL, NULL, NULL, NULL, NULL, NULL),
('ee193787-bf84-48b3-b4d6-4a085e5e504d', 135, 'Kartik Tyagi', 'Kolkata Knight Riders', 'Bowler', 'BOWL', 'BOWL', 'C', 58, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/13136/kartik-tyagi', 20.0, NULL, NULL, NULL, 15.0, 10.14, 47.53, NULL, NULL, NULL, 40, 13.0, 37.0, 37.0, NULL, NULL, NULL),
('c47ccfa5-f45a-4689-9e1c-674c7ed5c0fd', 115, 'Rachin Ravindra', 'Kolkata Knight Riders', 'Batting Allrounder', 'AR', 'AR', 'C', 62, 'OVERSEAS', 'New Zealander', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/11177/rachin-ravindra', 18.0, 413.0, NULL, NULL, 0.0, NULL, NULL, NULL, NULL, NULL, 39, NULL, NULL, NULL, 49.0, 29.0, 29.0),
('5ac53d63-de3c-424a-9323-a7b4f4da3350', 147, 'Mayank Yadav', 'Lucknow Super Giants', 'Bowler', 'BOWL', 'BOWL', 'C', 57, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/22401/mayank-yadav', 6.0, NULL, NULL, NULL, 9.0, 9.17, 20.56, NULL, NULL, NULL, 33, 9.0, 53.0, 94.0, NULL, NULL, NULL),
('008b5400-1c12-415b-bf55-d52819e6c20a', 19, 'Hardik Pandya', 'Mumbai Indians', 'Batting Allrounder', 'AR', 'AR', 'A', 89, 'INDIAN', 'Indian', 2, false, 6, 'https://www.cricbuzz.com/profiles/9647/hardik-pandya', 152.0, 2749.0, NULL, NULL, 78.0, NULL, NULL, NULL, NULL, NULL, 99, NULL, NULL, NULL, 90.0, 50.0, 50.0),
('3f754dc4-39e7-4ed7-b307-5cfe27fc0390', 43, 'Abhishek Sharma', 'Sunrisers Hyderabad', 'Batting Allrounder', 'AR', 'AR', 'B', 77, 'INDIAN', 'Indian', 1, false, 2, 'https://www.cricbuzz.com/profiles/12086/abhishek-sharma', 77.0, 1815.0, NULL, NULL, 11.0, NULL, NULL, NULL, NULL, NULL, 68, NULL, NULL, NULL, 90.0, 24.0, 24.0),
('de5a99bf-5131-4e92-9cf3-5cf455296395', 1, 'Virat Kohli', 'Royal Challengers Bengaluru', 'Batsman', 'BAT', 'BAT_WK', 'A', 99, 'INDIAN', 'Indian', 2, false, 10, 'https://www.cricbuzz.com/profiles/1413/virat-kohli', 267.0, 8661.0, 132.86, 39.55, NULL, NULL, NULL, 99.0, 67.0, 98.0, 99, NULL, NULL, NULL, NULL, NULL, NULL),
('c535d5fe-8104-4aa1-a47e-e8f7afbabae7', 80, 'Lockie Ferguson', 'Punjab Kings', 'Bowler', 'BOWL', 'BOWL', 'C', 69, 'OVERSEAS', 'New Zealander', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/10692/lockie-ferguson', 49.0, NULL, NULL, NULL, 51.0, 8.97, 30.0, NULL, NULL, NULL, 54, 36.0, 56.0, 74.0, NULL, NULL, NULL),
('38cd3885-f023-4e1b-8548-135d88553f7f', 30, 'Rishabh Pant', 'Lucknow Super Giants', 'WK-Batsman', 'WK', 'BAT_WK', 'B', 82, 'INDIAN', 'Indian', 1, false, 0, 'https://www.cricbuzz.com/profiles/10744/rishabh-pant', 125.0, 3553.0, 147.62, 34.16, NULL, NULL, NULL, 68.0, 76.0, 85.0, 92, NULL, NULL, NULL, NULL, NULL, NULL),
('17022962-17fd-4dc9-88f8-2b1db2de97d1', 68, 'Anrich Nortje', 'Lucknow Super Giants', 'Bowler', 'BOWL', 'BOWL', 'B', 71, 'OVERSEAS', 'South African', 1, false, 0, 'https://www.cricbuzz.com/profiles/11427/anrich-nortje', 48.0, NULL, NULL, NULL, 61.0, 9.07, 27.16, NULL, NULL, NULL, 54, 43.0, 55.0, 80.0, NULL, NULL, NULL),
('70abe131-0c12-47d2-b949-4204662127d5', 85, 'Mohsin Khan', 'Lucknow Super Giants', 'Bowler', 'BOWL', 'BOWL', 'C', 67, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/13534/mohsin-khan', 24.0, NULL, NULL, NULL, 27.0, 8.51, 25.52, NULL, NULL, NULL, 42, 21.0, 64.0, 83.0, NULL, NULL, NULL),
('1ce5a248-af23-4790-8af3-d89f35d89f23', 109, 'Abdul Samad', 'Lucknow Super Giants', 'Batting Allrounder', 'AR', 'AR', 'C', 63, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/14628/abdul-samad', 63.0, 741.0, NULL, NULL, 2.0, NULL, NULL, NULL, NULL, NULL, 61, NULL, NULL, NULL, 57.0, 5.0, 5.0),
('43cde79c-4390-4c28-84b6-f7a95e81b1cb', 118, 'Aniket Verma', 'Sunrisers Hyderabad', 'Batsman', 'BAT', 'BAT_WK', 'C', 62, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/1447065/aniket-verma', 14.0, 236.0, 166.2, 26.22, NULL, NULL, NULL, 8.0, 89.0, 65.0, 37, NULL, NULL, NULL, NULL, NULL, NULL),
('329678d9-8ad8-4bf0-b210-60d8266b18e7', 100, 'Abishek Porel', 'Delhi Capitals', 'WK-Batsman', 'WK', 'BAT_WK', 'C', 66, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/24326/abishek-porel', 31.0, 661.0, 149.89, 25.42, NULL, NULL, NULL, 16.0, 78.0, 63.0, 45, NULL, NULL, NULL, NULL, NULL, NULL),
('b4e91f94-5c22-40ab-b809-c7fbc9e0281a', 58, 'Riyan Parag', 'Rajasthan Royals', 'Batting Allrounder', 'AR', 'AR', 'B', 73, 'INDIAN', 'Indian', 1, false, 2, 'https://www.cricbuzz.com/profiles/12305/riyan-parag', 83.0, 1566.0, NULL, NULL, 7.0, NULL, NULL, NULL, NULL, NULL, 71, NULL, NULL, NULL, 78.0, 16.0, 16.0),
('3cdc0b2a-dd97-450b-9ac3-b545817203e7', 7, 'Ravindra Jadeja', 'Rajasthan Royals', 'Bowling Allrounder', 'AR', 'AR', 'A', 95, 'INDIAN', 'Indian', 2, false, 8, 'https://www.cricbuzz.com/profiles/587/ravindra-jadeja', 254.0, 3260.0, NULL, NULL, 170.0, NULL, NULL, NULL, NULL, NULL, 99, NULL, NULL, NULL, 85.0, 78.0, 78.0),
('b560e0a8-8a13-4670-9fc0-2886c6130159', 120, 'Ravisrinivasan Sai Kishore', 'Gujarat Titans', 'Bowling Allrounder', 'AR', 'AR', 'C', 61, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/11595/ravisrinivasan-sai-kishore', 25.0, 18.0, NULL, NULL, 32.0, NULL, NULL, NULL, NULL, NULL, 42, NULL, NULL, NULL, 19.0, 41.0, 19.0),
('39ac2c90-a5f8-45a9-bf30-6f92775529a0', 122, 'Ashutosh Sharma', 'Delhi Capitals', 'Batting Allrounder', 'AR', 'AR', 'C', 61, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/13497/ashutosh-sharma', 24.0, 393.0, NULL, NULL, 0.0, NULL, NULL, NULL, NULL, NULL, 42, NULL, NULL, NULL, 56.0, 0.0, 0.0),
('8636f8bd-db09-4a12-956e-536b3959a00c', 128, 'Yash Thakur', 'Punjab Kings', 'Bowler', 'BOWL', 'BOWL', 'C', 61, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/12096/yash-thakur', 21.0, NULL, NULL, NULL, 25.0, 10.43, 30.8, NULL, NULL, NULL, 40, 20.0, 32.0, 72.0, NULL, NULL, NULL),
('c3669fe8-09b3-4456-b3bb-98931e45f68f', 130, 'Sameer Rizvi', 'Delhi Capitals', 'Batsman', 'BAT', 'BAT_WK', 'C', 60, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/14700/sameer-rizvi', 13.0, 172.0, 140.99, 24.57, NULL, NULL, NULL, 7.0, 72.0, 61.0, 36, NULL, NULL, NULL, NULL, NULL, NULL),
('48fcf98b-fbff-4ad2-8b3a-c5d1a0f2a05c', 64, 'Shreyas Gopal', 'Chennai Super Kings', 'Bowler', 'BOWL', 'BOWL', 'B', 72, 'INDIAN', 'Indian', 1, false, 0, 'https://www.cricbuzz.com/profiles/9746/shreyas-gopal', 52.0, NULL, NULL, NULL, 52.0, 8.16, 25.92, NULL, NULL, NULL, 56, 37.0, 69.0, 83.0, NULL, NULL, NULL),
('00ae5710-2a38-4ac0-9cd9-0cdc5f632518', 121, 'Suyash Sharma', 'Royal Challengers Bengaluru', 'Bowler', 'BOWL', 'BOWL', 'C', 61, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/36487/suyash-sharma', 27.0, NULL, NULL, NULL, 18.0, 8.75, 45.22, NULL, NULL, NULL, 43, 15.0, 60.0, 41.0, NULL, NULL, NULL),
('257450b8-d8a2-436f-bfbd-ba00a3704dae', 144, 'Vijaykumar Vyshak', 'Punjab Kings', 'Bowler', 'BOWL', 'BOWL', 'C', 57, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/10486/vijaykumar-vyshak', 16.0, NULL, NULL, NULL, 17.0, 10.38, 33.88, NULL, NULL, NULL, 38, 14.0, 33.0, 66.0, NULL, NULL, NULL),
('5527a784-c7c6-4881-a195-a89b54616cb9', 24, 'Varun Chakaravarthy', 'Kolkata Knight Riders', 'Bowler', 'BOWL', 'BOWL', 'B', 84, 'INDIAN', 'Indian', 1, false, 2, 'https://www.cricbuzz.com/profiles/12926/varun-chakaravarthy', 83.0, NULL, NULL, NULL, 100.0, 7.58, 23.85, NULL, NULL, NULL, 71, 68.0, 79.0, 87.0, NULL, NULL, NULL),
('8b7cc084-e1ac-4bbc-9bdb-8af890b4d158', 42, 'Ruturaj Gaikwad', 'Chennai Super Kings', 'Batsman', 'BAT', 'BAT_WK', 'B', 77, 'INDIAN', 'Indian', 1, false, 0, 'https://www.cricbuzz.com/profiles/11813/ruturaj-gaikwad', 71.0, 2502.0, 137.48, 40.35, NULL, NULL, NULL, 49.0, 70.0, 99.0, 65, NULL, NULL, NULL, NULL, NULL, NULL),
('940c8c29-53df-4323-ad38-0ce4790ce96c', 137, 'Jayant Yadav', 'Gujarat Titans', 'Bowling Allrounder', 'AR', 'AR', 'C', 58, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/8182/jayant-yadav', 20.0, 40.0, NULL, NULL, 8.0, NULL, NULL, NULL, NULL, NULL, 40, NULL, NULL, NULL, 22.0, 25.0, 22.0),
('ee186de3-47ef-490c-883a-fb9015ef37c5', 133, 'Kyle Jamieson', 'Delhi Capitals', 'Bowler', 'BOWL', 'BOWL', 'C', 59, 'OVERSEAS', 'New Zealander', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/9441/kyle-jamieson', 13.0, NULL, NULL, NULL, 14.0, 9.67, 29.71, NULL, NULL, NULL, 36, 12.0, 45.0, 74.0, NULL, NULL, NULL),
('d9269ee7-8006-4c74-856c-f91a90a14b4c', 141, 'Eshan Malinga', 'Sunrisers Hyderabad', 'Bowler', 'BOWL', 'BOWL', 'C', 58, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/46926/eshan-malinga', 7.0, NULL, NULL, NULL, 13.0, 8.93, 18.31, NULL, NULL, NULL, 33, 12.0, 57.0, 99.0, NULL, NULL, NULL),
('ac2adf30-bee4-4181-b26d-2b3ef2b2bf49', 88, 'Harshit Rana', 'Kolkata Knight Riders', 'Bowler', 'BOWL', 'BOWL', 'C', 67, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/24729/harshit-rana', 33.0, NULL, NULL, NULL, 40.0, 9.51, 25.73, NULL, NULL, NULL, 46, 29.0, 47.0, 83.0, NULL, NULL, NULL),
('8380be81-464a-4b1d-a1eb-f7bf9b9f2be0', 74, 'Devdutt Padikkal', 'Royal Challengers Bengaluru', 'Batsman', 'BAT', 'BAT_WK', 'B', 70, 'INDIAN', 'Indian', 1, false, 0, 'https://www.cricbuzz.com/profiles/13088/devdutt-padikkal', 74.0, 1806.0, 126.3, 25.44, NULL, NULL, NULL, 37.0, 62.0, 64.0, 67, NULL, NULL, NULL, NULL, NULL, NULL),
('4c21ab08-47e0-4f5c-9b1c-2c66bfab3f8d', 60, 'Noor Ahmad', 'Chennai Super Kings', 'Bowler', 'BOWL', 'BOWL', 'B', 72, 'OVERSEAS', 'Afghan', 1, false, 0, 'https://www.cricbuzz.com/profiles/15452/noor-ahmad', 37.0, NULL, NULL, NULL, 48.0, 8.08, 22.23, NULL, NULL, NULL, 48, 34.0, 71.0, 90.0, NULL, NULL, NULL),
('000b16a4-8ca9-4ce3-8153-833c35833af2', 29, 'Mohammed Siraj', 'Gujarat Titans', 'Bowler', 'BOWL', 'BOWL', 'B', 83, 'INDIAN', 'Indian', 1, false, 2, 'https://www.cricbuzz.com/profiles/10808/mohammed-siraj', 108.0, NULL, NULL, NULL, 109.0, 8.74, 30.72, NULL, NULL, NULL, 84, 74.0, 60.0, 72.0, NULL, NULL, NULL),
('d4054c1c-4c38-4093-9078-fbadcc916f64', 106, 'Sarfaraz Khan', 'Chennai Super Kings', 'Batsman', 'BAT', 'BAT_WK', 'C', 64, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/9429/sarfaraz-khan', 50.0, 585.0, 130.59, 22.5, NULL, NULL, NULL, 15.0, 65.0, 56.0, 55, NULL, NULL, NULL, NULL, NULL, NULL),
('31ec3905-5c6a-4e30-bac6-fcff4095ba94', 159, 'Rasikh Dar Salam', 'Royal Challengers Bengaluru', 'Bowler', 'BOWL', 'BOWL', 'C', 55, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/14274/rasikh-dar-salam', 13.0, NULL, NULL, NULL, 10.0, 10.62, 40.9, NULL, NULL, NULL, 36, 10.0, 29.0, 51.0, NULL, NULL, NULL),
('0aa8d972-7875-4a97-9dbb-180288e47379', 59, 'Rahul Tewatia', 'Gujarat Titans', 'Batting Allrounder', 'AR', 'AR', 'B', 73, 'INDIAN', 'Indian', 1, false, 0, 'https://www.cricbuzz.com/profiles/9693/rahul-tewatia', 108.0, 1112.0, NULL, NULL, 32.0, NULL, NULL, NULL, NULL, NULL, 84, NULL, NULL, NULL, 64.0, 38.0, 38.0),
('a96fee5e-091d-4ed3-8366-f3113fcf0412', 97, 'Ramandeep Singh', 'Kolkata Knight Riders', 'Batting Allrounder', 'AR', 'AR', 'C', 66, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/12337/ramandeep-singh', 30.0, 217.0, NULL, NULL, 6.0, NULL, NULL, NULL, NULL, NULL, 45, NULL, NULL, NULL, 46.0, 35.0, 35.0),
('7cb5b1c6-794a-4be5-8350-799dccb9116b', 49, 'Ravi Bishnoi', 'Rajasthan Royals', 'Bowler', 'BOWL', 'BOWL', 'B', 75, 'INDIAN', 'Indian', 1, false, 0, 'https://www.cricbuzz.com/profiles/14659/ravi-bishnoi', 77.0, NULL, NULL, NULL, 72.0, 8.22, 31.07, NULL, NULL, NULL, 68, 50.0, 68.0, 72.0, NULL, NULL, NULL),
('604238a8-1559-439b-850e-036aa36dd8c0', 92, 'Shashank Singh', 'Punjab Kings', 'Batting Allrounder', 'AR', 'AR', 'C', 67, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/10919/shashank-singh', 41.0, 773.0, NULL, NULL, 1.0, NULL, NULL, NULL, NULL, NULL, 50, NULL, NULL, NULL, 67.0, 14.0, 14.0),
('797a5605-2494-4e99-bbee-153e1ffe4466', 78, 'Rajat Patidar', 'Royal Challengers Bengaluru', 'Batsman', 'BAT', 'BAT_WK', 'C', 69, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/10636/rajat-patidar', 42.0, 1111.0, 154.31, 30.86, NULL, NULL, NULL, 24.0, 81.0, 77.0, 51, NULL, NULL, NULL, NULL, NULL, NULL),
('f3e8922d-e6dc-42a7-af65-484e095e65dc', 151, 'Dushmantha Chameera', 'Delhi Capitals', 'Bowler', 'BOWL', 'BOWL', 'C', 56, 'OVERSEAS', 'Sri Lankan', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/8393/dushmantha-chameera', 19.0, NULL, NULL, NULL, 13.0, 9.73, 46.38, NULL, NULL, NULL, 39, 12.0, 44.0, 39.0, NULL, NULL, NULL),
('65a02bb1-4582-49ca-a0b9-6c6d9c907595', 47, 'Yashasvi Jaiswal', 'Rajasthan Royals', 'Batsman', 'BAT', 'BAT_WK', 'B', 75, 'INDIAN', 'Indian', 1, false, 0, 'https://www.cricbuzz.com/profiles/13940/yashasvi-jaiswal', 66.0, 2166.0, 152.86, 34.38, NULL, NULL, NULL, 43.0, 80.0, 85.0, 63, NULL, NULL, NULL, NULL, NULL, NULL),
('47cf61ca-d62c-4ec9-be83-a82b4da0e92b', 82, 'Jitesh Sharma', 'Royal Challengers Bengaluru', 'WK-Batsman', 'WK', 'BAT_WK', 'C', 68, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/10214/jitesh-sharma', 55.0, 991.0, 157.06, 25.41, NULL, NULL, NULL, 22.0, 83.0, 63.0, 57, NULL, NULL, NULL, NULL, NULL, NULL),
('e75f7576-39aa-458d-9c02-d1e3a52580e2', 77, 'Rinku Singh', 'Kolkata Knight Riders', 'Batsman', 'BAT', 'BAT_WK', 'C', 69, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/10896/rinku-singh', 58.0, 1099.0, 145.18, 30.53, NULL, NULL, NULL, 24.0, 75.0, 76.0, 59, NULL, NULL, NULL, NULL, NULL, NULL),
('6c7a089b-25dd-49f2-af68-23be724c8dad', 140, 'Mukesh Choudhary', 'Chennai Super Kings', 'Bowler', 'BOWL', 'BOWL', 'C', 58, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/13184/mukesh-choudhary', 16.0, NULL, NULL, NULL, 17.0, 9.94, 30.71, NULL, NULL, NULL, 38, 14.0, 40.0, 72.0, NULL, NULL, NULL),
('b440c0df-e2d5-45d1-ae83-7325c3bb0018', 98, 'Shivam Mavi', 'Sunrisers Hyderabad', 'Bowler', 'BOWL', 'BOWL', 'C', 66, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/12345/shivam-mavi', 32.0, NULL, NULL, NULL, 30.0, 8.71, 31.4, NULL, NULL, NULL, 46, 23.0, 60.0, 71.0, NULL, NULL, NULL),
('a3cc4bbc-af11-4a44-9d56-85583a5b4df0', 72, 'Aiden Markram', 'Lucknow Super Giants', 'Batsman', 'BAT', 'BAT_WK', 'B', 70, 'OVERSEAS', 'South African', 1, false, 0, 'https://www.cricbuzz.com/profiles/9582/aiden-markram', 57.0, 1440.0, 135.09, 31.3, NULL, NULL, NULL, 30.0, 68.0, 78.0, 58, NULL, NULL, NULL, NULL, NULL, NULL),
('e4b66235-61fc-4994-8289-0dc39f487824', 62, 'Shimron Hetmyer', 'Rajasthan Royals', 'Batsman', 'BAT', 'BAT_WK', 'B', 72, 'OVERSEAS', 'West Indian', 1, false, 0, 'https://www.cricbuzz.com/profiles/9789/shimron-hetmyer', 86.0, 1482.0, 151.85, 29.06, NULL, NULL, NULL, 31.0, 79.0, 72.0, 73, NULL, NULL, NULL, NULL, NULL, NULL),
('f64c0063-2a61-4b71-94d6-c6c09cf1ee21', 102, 'Angkrish Raghuvanshi', 'Kolkata Knight Riders', 'Batsman', 'BAT', 'BAT_WK', 'C', 65, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/22566/angkrish-raghuvanshi', 22.0, 463.0, 144.69, 28.94, NULL, NULL, NULL, 12.0, 75.0, 72.0, 41, NULL, NULL, NULL, NULL, NULL, NULL),
('9f17fa18-46a5-4d07-b352-e10e0c8b7b93', 63, 'T Natarajan', 'Delhi Capitals', 'Bowler', 'BOWL', 'BOWL', 'B', 72, 'INDIAN', 'Indian', 1, false, 0, 'https://www.cricbuzz.com/profiles/10225/t-natarajan', 63.0, NULL, NULL, NULL, 67.0, 8.94, 30.12, NULL, NULL, NULL, 61, 47.0, 57.0, 74.0, NULL, NULL, NULL),
('70925775-85ed-45fa-9a1b-2e646c783cde', 5, 'Bhuvneshwar Kumar', 'Royal Challengers Bengaluru', 'Bowler', 'BOWL', 'BOWL', 'A', 98, 'INDIAN', 'Indian', 2, false, 8, 'https://www.cricbuzz.com/profiles/1726/bhuvneshwar-kumar', 190.0, NULL, NULL, NULL, 198.0, 7.69, 27.33, NULL, NULL, NULL, 99, 99.0, 77.0, 80.0, NULL, NULL, NULL),
('399bc596-d565-42cf-ace6-19e6c19d4dbd', 136, 'Arshad Khan', 'Gujarat Titans', 'Bowling Allrounder', 'AR', 'AR', 'C', 58, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/18637/arshad-khan', 19.0, 124.0, NULL, NULL, 12.0, NULL, NULL, NULL, NULL, NULL, 39, NULL, NULL, NULL, 39.0, 18.0, 18.0),
('3f54b768-c8c3-4a33-ad8d-82d71f68c18b', 93, 'Washington Sundar', 'Gujarat Titans', 'Bowling Allrounder', 'AR', 'AR', 'C', 67, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/10945/washington-sundar', 66.0, 511.0, NULL, NULL, 39.0, NULL, NULL, NULL, NULL, NULL, 63, NULL, NULL, NULL, 42.0, 40.0, 40.0),
('3577e59e-71e8-45bc-93bd-734c6d0f1c85', 71, 'Matheesha Pathirana', 'Kolkata Knight Riders', 'Bowler', 'BOWL', 'BOWL', 'B', 70, 'OVERSEAS', 'Sri Lankan', 1, false, 0, 'https://www.cricbuzz.com/profiles/16458/matheesha-pathirana', 32.0, NULL, NULL, NULL, 47.0, 8.68, 21.62, NULL, NULL, NULL, 46, 34.0, 61.0, 92.0, NULL, NULL, NULL),
('947e3ceb-7e76-4e47-a592-240e1c944a03', 146, 'Anshul Kamboj', 'Chennai Super Kings', 'Bowling Allrounder', 'AR', 'AR', 'C', 57, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/14598/anshul-kamboj', 11.0, 16.0, NULL, NULL, 10.0, NULL, NULL, NULL, NULL, NULL, 35, NULL, NULL, NULL, 21.0, 30.0, 21.0),
('b0ccca77-6ae7-49a7-8a56-0967140112e5', 153, 'Urvil Patel', 'Chennai Super Kings', 'WK-Batsman', 'WK', 'BAT_WK', 'C', 56, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/13476/urvil-patel', 3.0, 68.0, 212.5, 22.67, NULL, NULL, NULL, 5.0, 99.0, 57.0, 31, NULL, NULL, NULL, NULL, NULL, NULL),
('e9deccdb-0a0e-4516-b6ae-8606ff426b33', 40, 'Rahul Chahar', 'Chennai Super Kings', 'Bowler', 'BOWL', 'BOWL', 'B', 77, 'INDIAN', 'Indian', 1, false, 0, 'https://www.cricbuzz.com/profiles/12087/rahul-chahar', 79.0, NULL, NULL, NULL, 75.0, 7.72, 28.67, NULL, NULL, NULL, 69, 52.0, 76.0, 77.0, NULL, NULL, NULL),
('6c83e3cd-61d7-4dd8-800a-c527fd04c3b5', 113, 'Marco Jansen', 'Punjab Kings', 'Bowling Allrounder', 'AR', 'AR', 'C', 62, 'OVERSEAS', 'South African', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/14565/marco-jansen', 35.0, 141.0, NULL, NULL, 36.0, NULL, NULL, NULL, NULL, NULL, 47, NULL, NULL, NULL, 26.0, 36.0, 26.0),
('a55185d0-cc1c-49d3-9e00-75281c95fedf', 48, 'Pat Cummins', 'Sunrisers Hyderabad', 'Bowler', 'BOWL', 'BOWL', 'B', 75, 'OVERSEAS', 'Australian', 1, false, 0, 'https://www.cricbuzz.com/profiles/8095/pat-cummins', 72.0, NULL, NULL, NULL, 79.0, 8.81, 30.04, NULL, NULL, NULL, 66, 54.0, 59.0, 74.0, NULL, NULL, NULL),
('1002983f-d44d-4a7c-b7d1-22f9077fbac0', 4, 'Sunil Narine', 'Kolkata Knight Riders', 'Bowling Allrounder', 'AR', 'AR', 'A', 98, 'OVERSEAS', 'West Indian', 2, false, 10, 'https://www.cricbuzz.com/profiles/2276/sunil-narine', 188.0, 1780.0, NULL, NULL, 192.0, NULL, NULL, NULL, NULL, NULL, 99, NULL, NULL, NULL, 84.0, 83.0, 83.0),
('1db4bdeb-ed63-4cd1-a9da-5fd706142e00', 139, 'Nandre Burger', 'Rajasthan Royals', 'Bowler', 'BOWL', 'BOWL', 'C', 58, 'OVERSEAS', 'South African', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/13630/nandre-burger', 5.0, NULL, NULL, NULL, 7.0, 8.53, 20.71, NULL, NULL, NULL, 32, 8.0, 63.0, 94.0, NULL, NULL, NULL),
('08f117ff-f162-46b2-99e2-ec8b01a381ec', 55, 'Mitchell Starc', 'Delhi Capitals', 'Bowler', 'BOWL', 'BOWL', 'B', 73, 'OVERSEAS', 'Australian', 1, false, 0, 'https://www.cricbuzz.com/profiles/7710/mitchell-starc', 51.0, NULL, NULL, NULL, 65.0, 8.61, 23.12, NULL, NULL, NULL, 55, 45.0, 62.0, 88.0, NULL, NULL, NULL),
('07a10fac-dd43-4365-a87f-d4a63e16b572', 107, 'Shahbaz Ahmed', 'Lucknow Super Giants', 'Bowling Allrounder', 'AR', 'AR', 'C', 64, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/14606/shahbaz-ahmed', 58.0, 545.0, NULL, NULL, 22.0, NULL, NULL, NULL, NULL, NULL, 59, NULL, NULL, NULL, 43.0, 27.0, 27.0),
('e3a00cfa-c38b-4882-8ded-959d8265e5f3', 36, 'Arshdeep Singh', 'Punjab Kings', 'Bowler', 'BOWL', 'BOWL', 'B', 78, 'INDIAN', 'Indian', 1, false, 0, 'https://www.cricbuzz.com/profiles/13217/arshdeep-singh', 82.0, NULL, NULL, NULL, 97.0, 9.0, 26.49, NULL, NULL, NULL, 71, 66.0, 56.0, 81.0, NULL, NULL, NULL),
('2c6ba30e-699d-47a4-b42d-a7d68188821a', 143, 'Prashant Solanki', 'Kolkata Knight Riders', 'Bowler', 'BOWL', 'BOWL', 'C', 57, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/12805/prashant-solanki', 2.0, NULL, NULL, NULL, 2.0, 6.33, 19.0, NULL, NULL, NULL, 31, 5.0, 99.0, 97.0, NULL, NULL, NULL),
('56b7abe0-fb2e-406d-bee7-e166a6f43b36', 99, 'Yash Dayal', 'Royal Challengers Bengaluru', 'Bowler', 'BOWL', 'BOWL', 'C', 66, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/14172/yash-dayal', 43.0, NULL, NULL, NULL, 41.0, 9.58, 33.9, NULL, NULL, NULL, 51, 30.0, 46.0, 66.0, NULL, NULL, NULL),
('a928d465-2c4f-44a9-bbb0-4954b65c1fb8', 41, 'Nitish Rana', 'Delhi Capitals', 'Batsman', 'BAT', 'BAT_WK', 'B', 77, 'INDIAN', 'Indian', 1, false, 0, 'https://www.cricbuzz.com/profiles/9204/nitish-rana', 118.0, 2853.0, 136.77, 27.7, NULL, NULL, NULL, 56.0, 69.0, 69.0, 89, NULL, NULL, NULL, NULL, NULL, NULL),
('071ced7e-36c0-4505-ba3b-39b55b1b2aa1', 152, 'Anukul Roy', 'Kolkata Knight Riders', 'Batting Allrounder', 'AR', 'AR', 'C', 56, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/12344/anukul-roy', 11.0, 26.0, NULL, NULL, 6.0, NULL, NULL, NULL, NULL, NULL, 35, NULL, NULL, NULL, 17.0, 29.0, 17.0),
('716da6eb-d339-423d-aa9b-f47d47d5a1b9', 20, 'Jos Buttler', 'Gujarat Titans', 'WK-Batsman', 'WK', 'BAT_WK', 'A', 88, 'OVERSEAS', 'English', 2, false, 2, 'https://www.cricbuzz.com/profiles/2258/jos-buttler', 121.0, 4120.0, 149.39, 40.0, NULL, NULL, NULL, 79.0, 78.0, 99.0, 90, NULL, NULL, NULL, NULL, NULL, NULL),
('f30714f9-4d12-4002-94d8-ec2333ac5ce4', 54, 'Heinrich Klaasen', 'Sunrisers Hyderabad', 'WK-Batsman', 'WK', 'BAT_WK', 'B', 74, 'OVERSEAS', 'South African', 1, false, 0, 'https://www.cricbuzz.com/profiles/10209/heinrich-klaasen', 49.0, 1480.0, 169.73, 40.0, NULL, NULL, NULL, 31.0, 91.0, 99.0, 54, NULL, NULL, NULL, NULL, NULL, NULL),
('c3d22e2a-f9b7-4edf-8e18-e299815aaaee', 95, 'Nehal Wadhera', 'Punjab Kings', 'Batsman', 'BAT', 'BAT_WK', 'C', 66, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/13915/nehal-wadhera', 36.0, 719.0, 142.95, 26.63, NULL, NULL, NULL, 17.0, 73.0, 66.0, 48, NULL, NULL, NULL, NULL, NULL, NULL),
('316da252-8cf2-4db1-9e15-e8082bd48c79', 32, 'David Miller', 'Delhi Capitals', 'Batsman', 'BAT', 'BAT_WK', 'B', 80, 'OVERSEAS', 'South African', 1, false, 0, 'https://www.cricbuzz.com/profiles/6349/david-miller', 141.0, 3077.0, 138.61, 35.78, NULL, NULL, NULL, 60.0, 70.0, 89.0, 99, NULL, NULL, NULL, NULL, NULL, NULL),
('ef9e5b47-b462-4ff9-94f6-f2814809130d', 103, 'Priyansh Arya', 'Punjab Kings', 'Batsman', 'BAT', 'BAT_WK', 'C', 64, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/14689/priyansh-arya', 17.0, 475.0, 179.25, 27.94, NULL, NULL, NULL, 13.0, 98.0, 70.0, 38, NULL, NULL, NULL, NULL, NULL, NULL),
('0d1415a7-dccf-44ae-8def-acdeda58a57d', 111, 'Ryan Rickelton', 'Mumbai Indians', 'WK-Batsman', 'WK', 'BAT_WK', 'C', 62, 'OVERSEAS', 'South African', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/13070/ryan-rickelton', 14.0, 388.0, 150.98, 29.85, NULL, NULL, NULL, 11.0, 79.0, 74.0, 37, NULL, NULL, NULL, NULL, NULL, NULL),
('8a4db8bb-0667-43cd-a687-6127730864de', 38, 'Shardul Thakur', 'Mumbai Indians', 'Bowling Allrounder', 'AR', 'AR', 'B', 78, 'INDIAN', 'Indian', 1, false, 6, 'https://www.cricbuzz.com/profiles/8683/shardul-thakur', 105.0, 325.0, NULL, NULL, 107.0, NULL, NULL, NULL, NULL, NULL, 82, NULL, NULL, NULL, 38.0, 59.0, 38.0),
('4e1e0f0e-a4ba-4155-94da-08bcf4061049', 90, 'Naman Dhir', 'Mumbai Indians', 'Batsman', 'BAT', 'BAT_WK', 'C', 67, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/36139/naman-dhir', 23.0, 392.0, 180.65, 28.0, NULL, NULL, NULL, 11.0, 99.0, 70.0, 41, NULL, NULL, NULL, NULL, NULL, NULL),
('33c03a6a-7966-468d-adc0-c64a5845ccfe', 79, 'Prabhsimran Singh', 'Punjab Kings', 'WK-Batsman', 'WK', 'BAT_WK', 'C', 69, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/14254/prabhsimran-singh', 51.0, 1305.0, 151.93, 25.59, NULL, NULL, NULL, 28.0, 79.0, 64.0, 55, NULL, NULL, NULL, NULL, NULL, NULL),
('a30ecd4d-a0dd-4803-a300-446fef6c5d0d', 96, 'Vaibhav Arora', 'Kolkata Knight Riders', 'Bowler', 'BOWL', 'BOWL', 'C', 66, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/15861/vaibhav-arora', 32.0, NULL, NULL, NULL, 36.0, 9.55, 28.22, NULL, NULL, NULL, 46, 27.0, 47.0, 78.0, NULL, NULL, NULL),
('80401b69-decb-43a4-8fc7-30a01d2417da', 12, 'Trent Boult', 'Mumbai Indians', 'Bowler', 'BOWL', 'BOWL', 'A', 92, 'OVERSEAS', 'New Zealander', 2, true, 4, 'https://www.cricbuzz.com/profiles/8117/trent-boult', 119.0, NULL, NULL, NULL, 143.0, 8.38, 26.2, NULL, NULL, NULL, 89, 96.0, 66.0, 82.0, NULL, NULL, NULL),
('d0520542-8330-4c27-85ab-93fc58cb547f', 86, 'Mayank Markande', 'Mumbai Indians', 'Bowler', 'BOWL', 'BOWL', 'C', 67, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/12627/mayank-markande', 37.0, NULL, NULL, NULL, 37.0, 8.91, 28.89, NULL, NULL, NULL, 48, 27.0, 57.0, 76.0, NULL, NULL, NULL),
('10cdd936-4f04-4e6a-9769-54ffc228f295', 158, 'Arjun Tendulkar', 'Lucknow Super Giants', 'Bowling Allrounder', 'AR', 'AR', 'C', 55, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/13747/arjun-tendulkar', 5.0, 13.0, NULL, NULL, 3.0, NULL, NULL, NULL, NULL, NULL, 32, NULL, NULL, NULL, 32.0, 23.0, 23.0),
('43d1145a-5141-49a4-b864-127f48edca69', 46, 'Avesh Khan', 'Lucknow Super Giants', 'Bowler', 'BOWL', 'BOWL', 'B', 76, 'INDIAN', 'Indian', 1, false, 0, 'https://www.cricbuzz.com/profiles/9781/avesh-khan', 75.0, NULL, NULL, NULL, 87.0, 9.12, 28.29, NULL, NULL, NULL, 67, 60.0, 54.0, 77.0, NULL, NULL, NULL),
('fbeaedd1-89b1-4a25-9610-9212da8d95a6', 104, 'Lungi Ngidi', 'Delhi Capitals', 'Bowler', 'BOWL', 'BOWL', 'C', 64, 'OVERSEAS', 'South African', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/9603/lungi-ngidi', 16.0, NULL, NULL, NULL, 29.0, 8.53, 18.24, NULL, NULL, NULL, 38, 22.0, 63.0, 99.0, NULL, NULL, NULL),
('35fa65a7-e454-4747-bcbc-488d34269aa3', 75, 'Karun Nair', 'Delhi Capitals', 'Batsman', 'BAT', 'BAT_WK', 'B', 70, 'INDIAN', 'Indian', 1, false, 0, 'https://www.cricbuzz.com/profiles/8257/karun-nair', 84.0, 1694.0, 131.73, 23.86, NULL, NULL, NULL, 35.0, 66.0, 60.0, 72, NULL, NULL, NULL, NULL, NULL, NULL),
('1dbbaf0f-b2d1-4257-a9bd-fdbaf203467b', 18, 'Rashid Khan', 'Gujarat Titans', 'Bowling Allrounder', 'AR', 'AR', 'A', 89, 'OVERSEAS', 'Afghan', 2, false, 8, 'https://www.cricbuzz.com/profiles/10738/rashid-khan', 136.0, 585.0, NULL, NULL, 158.0, NULL, NULL, NULL, NULL, NULL, 98, NULL, NULL, NULL, 51.0, 82.0, 51.0),
('91b4de1f-70f1-4cd0-ab5c-afcc6cb68b91', 129, 'Anuj Rawat', 'Gujarat Titans', 'WK-Batsman', 'WK', 'BAT_WK', 'C', 60, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/13135/anuj-rawat', 24.0, 318.0, 119.11, 19.88, NULL, NULL, NULL, 10.0, 57.0, 50.0, 42, NULL, NULL, NULL, NULL, NULL, NULL),
('832ff96f-3ac9-4570-ac8c-9e7cb8898b19', 57, 'Jofra Archer', 'Rajasthan Royals', 'Bowler', 'BOWL', 'BOWL', 'B', 73, 'OVERSEAS', 'English', 1, false, 0, 'https://www.cricbuzz.com/profiles/11540/jofra-archer', 52.0, NULL, NULL, NULL, 59.0, 7.89, 27.15, NULL, NULL, NULL, 56, 41.0, 74.0, 80.0, NULL, NULL, NULL),
('e0ef727e-3a94-43b8-8322-15de3e514a98', 105, 'Mukesh Kumar', 'Delhi Capitals', 'Bowler', 'BOWL', 'BOWL', 'C', 64, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/10754/mukesh-kumar', 32.0, NULL, NULL, NULL, 36.0, 10.4, 30.61, NULL, NULL, NULL, 46, 27.0, 33.0, 73.0, NULL, NULL, NULL),
('fde0d524-2af7-447c-b8cf-b010b1e55b7b', 89, 'Dhruv Jurel', 'Rajasthan Royals', 'WK-Batsman', 'WK', 'BAT_WK', 'C', 67, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/14691/dhruv-jurel', 41.0, 680.0, 153.85, 28.33, NULL, NULL, NULL, 16.0, 81.0, 71.0, 50, NULL, NULL, NULL, NULL, NULL, NULL),
('e2b56b3e-f1ce-4b73-9fcd-686e3b6acfa0', 154, 'Nuwan Thushara', 'Royal Challengers Bengaluru', 'Bowler', 'BOWL', 'BOWL', 'C', 56, 'OVERSEAS', 'Sri Lankan', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/18509/nuwan-thushara', 8.0, NULL, NULL, NULL, 9.0, 9.43, 31.44, NULL, NULL, NULL, 34, 9.0, 49.0, 71.0, NULL, NULL, NULL),
('295c724d-b48f-4dc4-b202-649682f046f9', 44, 'Khaleel Ahmed', 'Chennai Super Kings', 'Bowler', 'BOWL', 'BOWL', 'B', 77, 'INDIAN', 'Indian', 1, false, 0, 'https://www.cricbuzz.com/profiles/10952/khaleel-ahmed', 71.0, NULL, NULL, NULL, 89.0, 8.98, 26.16, NULL, NULL, NULL, 65, 61.0, 56.0, 82.0, NULL, NULL, NULL),
('42eb4503-d5e6-4a8c-a6f0-ed40bc4efdb0', 16, 'Suryakumar Yadav', 'Mumbai Indians', 'Batsman', 'BAT', 'BAT_WK', 'A', 89, 'INDIAN', 'Indian', 2, false, 2, 'https://www.cricbuzz.com/profiles/7915/suryakumar-yadav', 166.0, 4311.0, 148.66, 35.05, NULL, NULL, NULL, 82.0, 77.0, 87.0, 99, NULL, NULL, NULL, NULL, NULL, NULL),
('d626fe12-ed5d-4f92-a9f7-4c58be927cab', 117, 'Dewald Brevis', 'Chennai Super Kings', 'Batsman', 'BAT', 'BAT_WK', 'C', 62, 'OVERSEAS', 'South African', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/20538/dewald-brevis', 16.0, 455.0, 153.2, 28.44, NULL, NULL, NULL, 12.0, 80.0, 71.0, 38, NULL, NULL, NULL, NULL, NULL, NULL),
('a04636cf-3d19-4d73-9ce1-2153275ae358', 39, 'Nicholas Pooran', 'Lucknow Super Giants', 'WK-Batsman', 'WK', 'BAT_WK', 'B', 78, 'OVERSEAS', 'West Indian', 1, false, 0, 'https://www.cricbuzz.com/profiles/9406/nicholas-pooran', 90.0, 2293.0, 168.98, 34.22, NULL, NULL, NULL, 46.0, 91.0, 85.0, 75, NULL, NULL, NULL, NULL, NULL, NULL),
('e83d948c-63ad-4438-80bd-1a163d26abb8', 108, 'Rovman Powell', 'Kolkata Knight Riders', 'Batsman', 'BAT', 'BAT_WK', 'C', 63, 'OVERSEAS', 'West Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/11445/rovman-powell', 28.0, 365.0, 146.59, 18.25, NULL, NULL, NULL, 11.0, 76.0, 46.0, 44, NULL, NULL, NULL, NULL, NULL, NULL),
('1e0319f8-4b20-44ef-9d9b-82f45b9bde17', 35, 'Deepak Chahar', 'Mumbai Indians', 'Bowler', 'BOWL', 'BOWL', 'B', 78, 'INDIAN', 'Indian', 1, false, 0, 'https://www.cricbuzz.com/profiles/7836/deepak-chahar', 95.0, NULL, NULL, NULL, 88.0, 8.14, 29.51, NULL, NULL, NULL, 77, 60.0, 70.0, 75.0, NULL, NULL, NULL),
('e089e9e2-d28f-4732-995c-fb3a0fd3c199', 8, 'MS Dhoni', 'Chennai Super Kings', 'WK-Batsman', 'WK', 'BAT_WK', 'A', 95, 'INDIAN', 'Indian', 2, false, 4, 'https://www.cricbuzz.com/profiles/265/ms-dhoni', 278.0, 5439.0, 137.46, 38.3, NULL, NULL, NULL, 99.0, 70.0, 95.0, 99, NULL, NULL, NULL, NULL, NULL, NULL),
('fe155921-2c47-4fe2-8bf2-5cfa73516a60', 33, 'Ishant Sharma', 'Gujarat Titans', 'Bowler', 'BOWL', 'BOWL', 'B', 79, 'INDIAN', 'Indian', 1, false, 0, 'https://www.cricbuzz.com/profiles/702/ishant-sharma', 117.0, NULL, NULL, NULL, 96.0, 8.38, 35.18, NULL, NULL, NULL, 88, 65.0, 66.0, 63.0, NULL, NULL, NULL),
('13a78d6a-d71b-4d80-9758-62e3ddd6ca18', 67, 'Ayush Badoni', 'Lucknow Super Giants', 'Batting Allrounder', 'AR', 'AR', 'B', 71, 'INDIAN', 'Indian', 1, false, 0, 'https://www.cricbuzz.com/profiles/13907/ayush-badoni', 56.0, 963.0, NULL, NULL, 4.0, NULL, NULL, NULL, NULL, NULL, 58, NULL, NULL, NULL, 63.0, 37.0, 37.0),
('8dfc46aa-ea23-4daa-9e95-ae081cfef91c', 13, 'Axar Patel', 'Delhi Capitals', 'Bowling Allrounder', 'AR', 'AR', 'A', 91, 'INDIAN', 'Indian', 2, false, 6, 'https://www.cricbuzz.com/profiles/8808/axar-patel', 162.0, 1916.0, NULL, NULL, 128.0, NULL, NULL, NULL, NULL, NULL, 99, NULL, NULL, NULL, 82.0, 72.0, 72.0),
('988e8267-46e2-4023-af57-85dc198f9509', 125, 'Vaibhav Suryavanshi', 'Rajasthan Royals', 'Batsman', 'BAT', 'BAT_WK', 'C', 61, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/51791/vaibhav-suryavanshi', 7.0, 252.0, 206.56, 36.0, NULL, NULL, NULL, 9.0, 99.0, 89.0, 33, NULL, NULL, NULL, NULL, NULL, NULL),
('52eb31fb-cf82-4766-9cbc-0e00bd04abb7', 150, 'Adam Milne', 'Rajasthan Royals', 'Bowler', 'BOWL', 'BOWL', 'C', 56, 'OVERSEAS', 'New Zealander', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/7625/adam-milne', 10.0, NULL, NULL, NULL, 7.0, 9.48, 46.71, NULL, NULL, NULL, 35, 8.0, 48.0, 38.0, NULL, NULL, NULL),
('473a2ca2-9bd1-420f-a0fe-5caf49c74ab9', 52, 'Rahul Tripathi', 'Kolkata Knight Riders', 'Batsman', 'BAT', 'BAT_WK', 'B', 74, 'INDIAN', 'Indian', 1, false, 0, 'https://www.cricbuzz.com/profiles/9012/rahul-tripathi', 100.0, 2291.0, 137.85, 26.03, NULL, NULL, NULL, 46.0, 70.0, 65.0, 80, NULL, NULL, NULL, NULL, NULL, NULL),
('f43a4c0b-4027-4b3a-ac3e-e021ed2129b8', 138, 'Azmatullah Omarzai', 'Punjab Kings', 'Bowling Allrounder', 'AR', 'AR', 'C', 58, 'OVERSEAS', 'Afghan', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/13214/azmatullah-omarzai', 16.0, 99.0, NULL, NULL, 12.0, NULL, NULL, NULL, NULL, NULL, 38, NULL, NULL, NULL, 31.0, 25.0, 25.0),
('69b0e066-4611-48fd-88aa-86f17376e781', 31, 'Manish Pandey', 'Kolkata Knight Riders', 'Batsman', 'BAT', 'BAT_WK', 'B', 82, 'INDIAN', 'Indian', 1, false, 0, 'https://www.cricbuzz.com/profiles/1836/manish-pandey', 174.0, 3942.0, 121.52, 29.42, NULL, NULL, NULL, 76.0, 59.0, 73.0, 99, NULL, NULL, NULL, NULL, NULL, NULL),
('a1eadc7e-ba35-45da-b80a-bd6d23a1eb5f', 126, 'Nathan Ellis', 'Chennai Super Kings', 'Bowler', 'BOWL', 'BOWL', 'C', 61, 'OVERSEAS', 'Australian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/15480/nathan-ellis', 17.0, NULL, NULL, NULL, 19.0, 8.67, 28.74, NULL, NULL, NULL, 38, 16.0, 61.0, 77.0, NULL, NULL, NULL),
('4d9cc9a0-58d1-4009-ac05-47b215cac874', 157, 'Manimaran Siddharth', 'Lucknow Super Giants', 'Bowler', 'BOWL', 'BOWL', 'C', 55, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/12930/manimaran-siddharth', 5.0, NULL, NULL, NULL, 3.0, 8.63, 46.0, NULL, NULL, NULL, 32, 5.0, 62.0, 40.0, NULL, NULL, NULL),
('c9c2ef14-0a5a-4f88-9d3d-0057a12c64a8', 87, 'Tushar Deshpande', 'Rajasthan Royals', 'Bowler', 'BOWL', 'BOWL', 'C', 67, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/11307/tushar-deshpande', 46.0, NULL, NULL, NULL, 51.0, 9.84, 31.04, NULL, NULL, NULL, 53, 36.0, 42.0, 72.0, NULL, NULL, NULL),
('d8a991d3-0879-4e5b-8e9b-66c15fac90ec', 10, 'Harshal Patel', 'Sunrisers Hyderabad', 'Bowler', 'BOWL', 'BOWL', 'A', 94, 'INDIAN', 'Indian', 2, false, 6, 'https://www.cricbuzz.com/profiles/8175/harshal-patel', 119.0, NULL, NULL, NULL, 151.0, 8.86, 23.7, NULL, NULL, NULL, 89, 99.0, 58.0, 87.0, NULL, NULL, NULL),
('4c05bcaf-4b85-48d9-bd01-3fa3ae6fb270', 114, 'Mitchell Santner', 'Mumbai Indians', 'Bowling Allrounder', 'AR', 'AR', 'C', 62, 'OVERSEAS', 'New Zealander', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/10100/mitchell-santner', 31.0, 110.0, NULL, NULL, 25.0, NULL, NULL, NULL, NULL, NULL, 45, NULL, NULL, NULL, 25.0, 40.0, 25.0),
('504eb99c-4177-4f90-b868-b00b51c0f6d7', 73, 'Tim David', 'Royal Challengers Bengaluru', 'Batsman', 'BAT', 'BAT_WK', 'B', 70, 'OVERSEAS', 'Singaporean', 1, false, 0, 'https://www.cricbuzz.com/profiles/13169/tim-david', 50.0, 846.0, 173.37, 32.54, NULL, NULL, NULL, 19.0, 94.0, 81.0, 55, NULL, NULL, NULL, NULL, NULL, NULL),
('dba869a8-7d92-4bb3-aee8-deeab09fc25c', 83, 'Jason Holder', 'Gujarat Titans', 'Bowling Allrounder', 'AR', 'AR', 'C', 68, 'OVERSEAS', 'West Indian', 0.5, false, 2, 'https://www.cricbuzz.com/profiles/8313/jason-holder', 46.0, 259.0, NULL, NULL, 53.0, NULL, NULL, NULL, NULL, NULL, 53, NULL, NULL, NULL, 32.0, 45.0, 32.0),
('b8b2f949-16df-4775-98f6-2e48a2329bf2', 2, 'Yuzvendra Chahal', 'Punjab Kings', 'Bowler', 'BOWL', 'BOWL', 'A', 99, 'INDIAN', 'Indian', 2, false, 10, 'https://www.cricbuzz.com/profiles/7910/yuzvendra-chahal', 174.0, NULL, NULL, NULL, 221.0, 7.96, 22.77, NULL, NULL, NULL, 99, 99.0, 73.0, 89.0, NULL, NULL, NULL),
('d7372bb9-32e8-4c06-a0ae-86bbb79f90ba', 25, 'Marcus Stoinis', 'Punjab Kings', 'Batting Allrounder', 'AR', 'AR', 'B', 83, 'OVERSEAS', 'Australian', 1, false, 4, 'https://www.cricbuzz.com/profiles/8989/marcus-stoinis', 109.0, 2026.0, NULL, NULL, 44.0, NULL, NULL, NULL, NULL, NULL, 84, NULL, NULL, NULL, 90.0, 37.0, 37.0),
('9dc70fb7-56d8-4e60-afb1-148b9a7dbfaf', 15, 'Sanju Samson', 'Chennai Super Kings', 'WK-Batsman', 'WK', 'BAT_WK', 'A', 89, 'INDIAN', 'Indian', 2, false, 2, 'https://www.cricbuzz.com/profiles/8271/sanju-samson', 176.0, 4704.0, 139.05, 30.75, NULL, NULL, NULL, 89.0, 71.0, 76.0, 99, NULL, NULL, NULL, NULL, NULL, NULL),
('f95adb13-8606-4d4b-b94a-7088c95c04fc', 45, 'Shivam Dube', 'Chennai Super Kings', 'Batting Allrounder', 'AR', 'AR', 'B', 76, 'INDIAN', 'Indian', 1, false, 2, 'https://www.cricbuzz.com/profiles/11195/shivam-dube', 79.0, 1859.0, NULL, NULL, 5.0, NULL, NULL, NULL, NULL, NULL, 69, NULL, NULL, NULL, 88.0, 20.0, 20.0),
('d9cb1a9e-2337-424f-ad39-7bee5229998e', 56, 'Josh Hazlewood', 'Royal Challengers Bengaluru', 'Bowler', 'BOWL', 'BOWL', 'B', 73, 'OVERSEAS', 'Australian', 1, false, 0, 'https://www.cricbuzz.com/profiles/6258/josh-hazlewood', 39.0, NULL, NULL, NULL, 57.0, 8.28, 20.98, NULL, NULL, NULL, 49, 40.0, 67.0, 93.0, NULL, NULL, NULL),
('f7ba3036-9296-483a-8696-28ffbe35433a', 53, 'Prasidh Krishna', 'Gujarat Titans', 'Bowler', 'BOWL', 'BOWL', 'B', 74, 'INDIAN', 'Indian', 1, false, 0, 'https://www.cricbuzz.com/profiles/10551/prasidh-krishna', 66.0, NULL, NULL, NULL, 74.0, 8.77, 29.61, NULL, NULL, NULL, 63, 51.0, 59.0, 75.0, NULL, NULL, NULL),
('a6bac60d-8bef-48b8-9cf0-67b75996a870', 127, 'Digvesh Singh Rathi', 'Lucknow Super Giants', 'Bowler', 'BOWL', 'BOWL', 'C', 61, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/1448289/digvesh-singh-rathi', 13.0, NULL, NULL, NULL, 14.0, 8.25, 30.64, NULL, NULL, NULL, 36, 12.0, 68.0, 72.0, NULL, NULL, NULL),
('e345bcf2-2039-47a1-9253-9ed61c0281a4', 11, 'Sandeep Sharma', 'Rajasthan Royals', 'Bowler', 'BOWL', 'BOWL', 'A', 93, 'INDIAN', 'Indian', 2, false, 4, 'https://www.cricbuzz.com/profiles/8356/sandeep-sharma', 136.0, NULL, NULL, NULL, 146.0, 8.03, 27.88, NULL, NULL, NULL, 98, 98.0, 71.0, 78.0, NULL, NULL, NULL),
('65c1be8c-9ba5-434f-b009-02d04a95ad9f', 156, 'Matthew Short', 'Chennai Super Kings', 'Batsman', 'BAT', 'BAT_WK', 'C', 55, 'OVERSEAS', 'Australian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/9456/matthew-short', 6.0, 117.0, 127.18, 19.5, NULL, NULL, NULL, 6.0, 63.0, 49.0, 33, NULL, NULL, NULL, NULL, NULL, NULL),
('9c7a3892-301d-438d-92e5-39e6f5a77ec2', 21, 'Krunal Pandya', 'Royal Challengers Bengaluru', 'Batting Allrounder', 'AR', 'AR', 'A', 86, 'INDIAN', 'Indian', 2, false, 4, 'https://www.cricbuzz.com/profiles/11311/krunal-pandya', 142.0, 1748.0, NULL, NULL, 93.0, NULL, NULL, NULL, NULL, NULL, 99, NULL, NULL, NULL, 77.0, 60.0, 60.0),
('ee1ab1e3-dbb7-4d30-89cf-a70a5ccbd5fc', 51, 'Sam Curran', 'Rajasthan Royals', 'Bowling Allrounder', 'AR', 'AR', 'B', 74, 'OVERSEAS', 'English', 1, false, 2, 'https://www.cricbuzz.com/profiles/10420/sam-curran', 64.0, 997.0, NULL, NULL, 59.0, NULL, NULL, NULL, NULL, NULL, 62, NULL, NULL, NULL, 62.0, 41.0, 41.0),
('99671d42-7a1d-4a91-bb18-c089e00d9cbc', 65, 'Tilak Varma', 'Mumbai Indians', 'Batsman', 'BAT', 'BAT_WK', 'B', 72, 'INDIAN', 'Indian', 1, false, 0, 'https://www.cricbuzz.com/profiles/14504/tilak-varma', 54.0, 1499.0, 144.42, 37.48, NULL, NULL, NULL, 31.0, 74.0, 93.0, 57, NULL, NULL, NULL, NULL, NULL, NULL),
('b8888ff3-c6af-46f2-af0a-55cabb58415f', 28, 'Kuldeep Yadav', 'Delhi Capitals', 'Bowler', 'BOWL', 'BOWL', 'B', 83, 'INDIAN', 'Indian', 1, false, 2, 'https://www.cricbuzz.com/profiles/8292/kuldeep-yadav', 98.0, NULL, NULL, NULL, 102.0, 8.04, 26.95, NULL, NULL, NULL, 79, 69.0, 71.0, 80.0, NULL, NULL, NULL),
('681dce4b-3ca0-4099-9727-f67215f2229e', 112, 'Nitish Kumar Reddy', 'Sunrisers Hyderabad', 'Batting Allrounder', 'AR', 'AR', 'C', 62, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/14701/nitish-kumar-reddy', 28.0, 485.0, NULL, NULL, 5.0, NULL, NULL, NULL, NULL, NULL, 44, NULL, NULL, NULL, 50.0, 14.0, 14.0),
('c84fb1b7-7ef9-4fb9-82e1-d16bc391d188', 70, 'Venkatesh Iyer', 'Royal Challengers Bengaluru', 'Batting Allrounder', 'AR', 'AR', 'B', 70, 'INDIAN', 'Indian', 1, false, 0, 'https://www.cricbuzz.com/profiles/10917/venkatesh-iyer', 61.0, 1468.0, NULL, NULL, 3.0, NULL, NULL, NULL, NULL, NULL, 60, NULL, NULL, NULL, 77.0, 16.0, 16.0),
('7c789f03-4899-46da-b49c-67e7276ee2cc', 22, 'Kagiso Rabada', 'Gujarat Titans', 'Bowler', 'BOWL', 'BOWL', 'A', 85, 'OVERSEAS', 'South African', 2, false, 2, 'https://www.cricbuzz.com/profiles/9585/kagiso-rabada', 84.0, NULL, NULL, NULL, 119.0, 8.62, 22.96, NULL, NULL, NULL, 72, 80.0, 62.0, 89.0, NULL, NULL, NULL),
('1485a7cb-848c-4adf-a988-6573d839ab8e', 61, 'Travis Head', 'Sunrisers Hyderabad', 'Batsman', 'BAT', 'BAT_WK', 'B', 72, 'OVERSEAS', 'Australian', 1, false, 0, 'https://www.cricbuzz.com/profiles/8497/travis-head', 38.0, 1146.0, 170.03, 34.73, NULL, NULL, NULL, 25.0, 92.0, 86.0, 49, NULL, NULL, NULL, NULL, NULL, NULL),
('5b51cec4-2fe6-452f-9cc9-b345a506f39b', 17, 'Mohammed Shami', 'Lucknow Super Giants', 'Bowler', 'BOWL', 'BOWL', 'A', 89, 'INDIAN', 'Indian', 2, false, 4, 'https://www.cricbuzz.com/profiles/7909/mohammed-shami', 119.0, NULL, NULL, NULL, 133.0, 8.63, 28.18, NULL, NULL, NULL, 89, 89.0, 62.0, 78.0, NULL, NULL, NULL),
('0d137e76-7e71-4b0b-a5ed-a70d26acb250', 91, 'Shahrukh Khan', 'Gujarat Titans', 'Batting Allrounder', 'AR', 'AR', 'C', 67, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/10226/shahrukh-khan', 55.0, 732.0, NULL, NULL, 1.0, NULL, NULL, NULL, NULL, NULL, 57, NULL, NULL, NULL, 56.0, 27.0, 27.0),
('8182775a-0050-47f8-b3aa-a7b683e5a905', 9, 'KL Rahul', 'Delhi Capitals', 'WK-Batsman', 'WK', 'BAT_WK', 'A', 95, 'INDIAN', 'Indian', 2, true, 4, 'https://www.cricbuzz.com/profiles/8733/kl-rahul', 145.0, 5222.0, 136.03, 46.21, NULL, NULL, NULL, 99.0, 69.0, 99.0, 99, NULL, NULL, NULL, NULL, NULL, NULL),
('b2939e35-6248-4491-aea0-6d3479204e6a', 50, 'Mitchell Marsh', 'Lucknow Super Giants', 'Batting Allrounder', 'AR', 'AR', 'B', 74, 'OVERSEAS', 'Australian', 1, false, 0, 'https://www.cricbuzz.com/profiles/6250/mitchell-marsh', 55.0, 1292.0, NULL, NULL, 37.0, NULL, NULL, NULL, NULL, NULL, 57, NULL, NULL, NULL, 72.0, 43.0, 43.0),
('19c152c2-f332-45cc-a71b-c37e8f51857e', 6, 'Rohit Sharma', 'Mumbai Indians', 'Batsman', 'BAT', 'BAT_WK', 'A', 96, 'INDIAN', 'Indian', 2, false, 8, 'https://www.cricbuzz.com/profiles/576/rohit-sharma', 272.0, 7046.0, 132.1, 29.73, NULL, NULL, NULL, 99.0, 66.0, 74.0, 99, NULL, NULL, NULL, NULL, NULL, NULL),
('5be42919-1be5-4920-b3bf-6bb753744d9a', 132, 'Kuldeep Sen', 'Rajasthan Royals', 'Bowler', 'BOWL', 'BOWL', 'C', 59, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/14336/kuldeep-sen', 12.0, NULL, NULL, NULL, 14.0, 9.63, 27.64, NULL, NULL, NULL, 36, 12.0, 45.0, 79.0, NULL, NULL, NULL),
('50cbb1ba-b492-4842-968b-9df8a75ae5e7', 145, 'Akash Maharaj Singh', 'Lucknow Super Giants', 'Bowler', 'BOWL', 'BOWL', 'C', 57, 'INDIAN', 'Indian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/14696/akash-maharaj-singh', 10.0, NULL, NULL, NULL, 9.0, 9.54, 36.22, NULL, NULL, NULL, 35, 9.0, 47.0, 61.0, NULL, NULL, NULL),
('0cb7d82c-5e29-4345-80bb-745cf8e97375', 3, 'Jasprit Bumrah', 'Mumbai Indians', 'Bowler', 'BOWL', 'BOWL', 'A', 99, 'INDIAN', 'Indian', 2, false, 8, 'https://www.cricbuzz.com/profiles/9311/jasprit-bumrah', 145.0, NULL, NULL, NULL, 183.0, 7.25, 22.03, NULL, NULL, NULL, 99, 99.0, 84.0, 91.0, NULL, NULL, NULL),
('72e40937-669f-49fa-8124-ea1bea6ae925', 27, 'Shreyas Iyer', 'Punjab Kings', 'Batsman', 'BAT', 'BAT_WK', 'B', 83, 'INDIAN', 'Indian', 1, false, 0, 'https://www.cricbuzz.com/profiles/9428/shreyas-iyer', 132.0, 3731.0, 133.35, 34.23, NULL, NULL, NULL, 72.0, 67.0, 85.0, 96, NULL, NULL, NULL, NULL, NULL, NULL),
('507d6866-077e-46a2-81d6-788b2f60e50b', 110, 'Josh Inglis', 'Lucknow Super Giants', 'WK-Batsman', 'WK', 'BAT_WK', 'C', 63, 'OVERSEAS', 'Australian', 0.5, false, 0, 'https://www.cricbuzz.com/profiles/10637/josh-inglis', 11.0, 278.0, 162.58, 30.89, NULL, NULL, NULL, 9.0, 87.0, 77.0, 35, NULL, NULL, NULL, NULL, NULL, NULL),
('f9a3373f-3d60-4a68-93c1-c4286d0749f8', 37, 'Ishan Kishan', 'Sunrisers Hyderabad', 'WK-Batsman', 'WK', 'BAT_WK', 'B', 78, 'INDIAN', 'Indian', 1, false, 0, 'https://www.cricbuzz.com/profiles/10276/ishan-kishan', 119.0, 2998.0, 137.65, 29.11, NULL, NULL, NULL, 58.0, 70.0, 72.0, 89, NULL, NULL, NULL, NULL, NULL, NULL),
('2ec25b23-3d2d-4fe9-b6bf-3eba423d39ad', 14, 'Ajinkya Rahane', 'Kolkata Knight Riders', 'Batsman', 'BAT', 'BAT_WK', 'A', 91, 'INDIAN', 'Indian', 2, false, 4, 'https://www.cricbuzz.com/profiles/1447/ajinkya-rahane', 198.0, 5032.0, 125.02, 30.5, NULL, NULL, NULL, 95.0, 61.0, 76.0, 99, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT INTO "AuctionPlayer" (id, player_id, status) VALUES
('e70cfd1a-b850-4e44-9c95-179f5ac2532d', '44c18873-44d1-4659-be69-aaaba8a124f0', 'UNSOLD'),
('e24844d9-8240-4df7-bde5-74c8e5e655d6', 'e6d3ce09-f799-4e01-b9cb-1df2cb6ada4f', 'UNSOLD'),
('5164db59-1896-41ac-9b47-4e5f36ce24e1', '72e52cd7-c274-454c-a039-4d2bf18c6daa', 'UNSOLD'),
('f4756517-5b17-40c9-8f64-d6a9f8459380', 'bccbc76f-ff37-4594-ab34-62c0ddff2c6e', 'UNSOLD'),
('5afb2ed1-5a6d-485d-b104-314b97118e02', '3d60cfa6-faeb-4d0b-8ab0-4da87542bbd5', 'UNSOLD'),
('000864e0-c0b5-4463-9861-3306dce3ec5d', '0424ca04-7214-40eb-8296-ded31ba268e6', 'UNSOLD'),
('250c5066-e1e1-4cbc-b738-522b524f92a0', 'f3208bad-dc99-4450-94af-9989b4723bda', 'UNSOLD'),
('a48a46ed-f81a-4384-9c64-d37f8f1a46c4', '3399eca1-6f04-43bc-aead-a637290f415f', 'UNSOLD'),
('a473cd0f-6dc0-4b59-aa78-537a27dbccbd', 'dc97e782-09e9-4eda-aa9e-7626197282ee', 'UNSOLD'),
('c9926f58-1efa-429c-8cde-8138873cdd64', 'd663efe7-4094-4e49-bd44-8b6f5b4328f7', 'UNSOLD'),
('5e7f718d-a2e7-4639-aea5-9a47b118132d', '85dce70e-d096-442d-b1cf-41ebf7749e2d', 'UNSOLD'),
('c97558cc-a261-4d88-be5a-4cb4a01b8b5f', '3c28b853-73b0-431f-a9a8-a7d7d9ed5da3', 'UNSOLD'),
('89153027-ada7-4f29-906d-0993401d66ec', '8771c813-890d-4ffc-ab38-b9a34312c806', 'UNSOLD'),
('bc4a8206-ed0c-4299-8620-39ee19ad7973', '09db7b17-fd87-4029-8daa-79a7dbf36be3', 'UNSOLD'),
('85d3c479-f827-460c-86ec-e1a764cd79ff', 'd1799865-086b-4770-9b19-ba2bd904d92a', 'UNSOLD'),
('27e948f3-602e-4a12-9278-6845df772589', '12774762-fb80-4d7c-80fc-932eee368142', 'UNSOLD'),
('4d33a942-573a-438d-87da-f13106816d7b', '265e1735-5adc-4871-8605-b2d1e8fed200', 'UNSOLD'),
('15385fcc-3c39-49a3-9393-6469b192ae8b', 'b61bc9e3-6840-41bb-b347-ad5363dea9f6', 'UNSOLD'),
('bd244eea-f09f-4c29-880d-e85f59daa83d', 'a8075d31-2eae-47c8-b984-401f92d14e80', 'UNSOLD'),
('95ff5661-c3b1-42cc-9996-1ab9959041bf', 'b347396e-5f55-46dd-96f1-b84cc072d569', 'UNSOLD'),
('312f1ced-18fc-44ae-b277-977ab8936696', 'ee193787-bf84-48b3-b4d6-4a085e5e504d', 'UNSOLD'),
('24a0bcc1-ca5b-473b-9779-e9cae649f7d7', 'c47ccfa5-f45a-4689-9e1c-674c7ed5c0fd', 'UNSOLD'),
('28ddc4b6-8072-44e4-8b9a-f11ce325ba78', '5ac53d63-de3c-424a-9323-a7b4f4da3350', 'UNSOLD'),
('9091b693-3d8d-4a59-8779-fe6b120dec09', '008b5400-1c12-415b-bf55-d52819e6c20a', 'UNSOLD'),
('6590bc22-9a28-4956-9b2a-ef0aef3ad779', '3f754dc4-39e7-4ed7-b307-5cfe27fc0390', 'UNSOLD'),
('f97f6bc3-3e5d-4e5d-8adc-b4e1430efe8b', 'de5a99bf-5131-4e92-9cf3-5cf455296395', 'UNSOLD'),
('4c8dea21-7785-4df0-a308-bc5ebcb17e8a', 'c535d5fe-8104-4aa1-a47e-e8f7afbabae7', 'UNSOLD'),
('f270f36c-ba65-4c93-95f4-7a10f4b93b66', '38cd3885-f023-4e1b-8548-135d88553f7f', 'UNSOLD'),
('81896020-3661-4df3-9971-b479fb20fce5', '17022962-17fd-4dc9-88f8-2b1db2de97d1', 'UNSOLD'),
('f0cc8cf5-fb88-4484-9fd4-aa157f557316', '70abe131-0c12-47d2-b949-4204662127d5', 'UNSOLD'),
('0e945675-c0b6-4d46-ae6b-d848ddeef385', '1ce5a248-af23-4790-8af3-d89f35d89f23', 'UNSOLD'),
('d2e11e69-3153-4472-a31b-77b31e7ff361', '43cde79c-4390-4c28-84b6-f7a95e81b1cb', 'UNSOLD'),
('5f2dfa44-6fa7-4035-8522-a6b8af6dbed7', '329678d9-8ad8-4bf0-b210-60d8266b18e7', 'UNSOLD'),
('812ca4e6-e783-424a-a320-f1d51efdd042', 'b4e91f94-5c22-40ab-b809-c7fbc9e0281a', 'UNSOLD'),
('6c0ff9f6-ff73-43c1-894a-12df2ed93f2d', '3cdc0b2a-dd97-450b-9ac3-b545817203e7', 'UNSOLD'),
('d6061a22-1ace-420e-9380-a07ef97105db', 'b560e0a8-8a13-4670-9fc0-2886c6130159', 'UNSOLD'),
('229b405d-7a31-4d6c-846a-2739927fb5e0', '39ac2c90-a5f8-45a9-bf30-6f92775529a0', 'UNSOLD'),
('9739d29c-2c5a-41bf-ae47-3a1b37ae63ff', '8636f8bd-db09-4a12-956e-536b3959a00c', 'UNSOLD'),
('66f46da8-cce5-4c7e-a215-f6683bb4d82d', 'c3669fe8-09b3-4456-b3bb-98931e45f68f', 'UNSOLD'),
('72fafcbb-5a02-484e-b684-dd8bfd306f5a', '48fcf98b-fbff-4ad2-8b3a-c5d1a0f2a05c', 'UNSOLD'),
('8b2f88e0-04f8-4599-abd6-efc515b8b39c', '00ae5710-2a38-4ac0-9cd9-0cdc5f632518', 'UNSOLD'),
('76de4b78-332b-4ebd-a477-af03b3d9cd9e', '257450b8-d8a2-436f-bfbd-ba00a3704dae', 'UNSOLD'),
('353b4c9e-9ddd-497f-84f9-9e0931dd779d', '5527a784-c7c6-4881-a195-a89b54616cb9', 'UNSOLD'),
('ff002374-3142-43df-9de9-922fdd878318', '8b7cc084-e1ac-4bbc-9bdb-8af890b4d158', 'UNSOLD'),
('e5363dfc-79ff-46d8-85d6-99d4fec39864', '940c8c29-53df-4323-ad38-0ce4790ce96c', 'UNSOLD'),
('08a8066e-5783-40e4-b1af-42c605d0e8be', 'ee186de3-47ef-490c-883a-fb9015ef37c5', 'UNSOLD'),
('b57c9765-71d4-415d-b545-745190f4d854', 'd9269ee7-8006-4c74-856c-f91a90a14b4c', 'UNSOLD'),
('4bc414d1-ce1c-4407-82e4-c636c0a7668d', 'ac2adf30-bee4-4181-b26d-2b3ef2b2bf49', 'UNSOLD'),
('e3666b06-28f2-45b8-85ea-529213c59f1b', '8380be81-464a-4b1d-a1eb-f7bf9b9f2be0', 'UNSOLD'),
('773be7e6-6beb-417b-99c7-b4474bedb0ad', '4c21ab08-47e0-4f5c-9b1c-2c66bfab3f8d', 'UNSOLD'),
('0aa4e884-cbee-4dbe-a05d-c8b330618544', '000b16a4-8ca9-4ce3-8153-833c35833af2', 'UNSOLD'),
('29b03737-d2b0-4544-8e3a-933d51e7afc5', 'd4054c1c-4c38-4093-9078-fbadcc916f64', 'UNSOLD'),
('7f81d77b-f29a-4cf6-8539-67050b613d5a', '31ec3905-5c6a-4e30-bac6-fcff4095ba94', 'UNSOLD'),
('f11084d9-8e1e-4528-896a-51fb0788b781', '0aa8d972-7875-4a97-9dbb-180288e47379', 'UNSOLD'),
('b82938df-1309-42ed-ac4c-4d50205049d7', 'a96fee5e-091d-4ed3-8366-f3113fcf0412', 'UNSOLD'),
('15debf60-9b6b-4bdf-b22f-6a5f79ed690c', '7cb5b1c6-794a-4be5-8350-799dccb9116b', 'UNSOLD'),
('8f4f3fb6-36f1-45f9-b60d-c30286ce48e1', '604238a8-1559-439b-850e-036aa36dd8c0', 'UNSOLD'),
('f7934d89-2210-4906-a9e5-350eba2e8918', '797a5605-2494-4e99-bbee-153e1ffe4466', 'UNSOLD'),
('eba7bec7-f31a-4719-bae8-525a3fd25fce', 'f3e8922d-e6dc-42a7-af65-484e095e65dc', 'UNSOLD'),
('23c66fc9-01e8-4ec0-bde4-6bf36358ac8f', '65a02bb1-4582-49ca-a0b9-6c6d9c907595', 'UNSOLD'),
('18bbb672-d232-4e21-812b-4a470d0cc2d5', '47cf61ca-d62c-4ec9-be83-a82b4da0e92b', 'UNSOLD'),
('a4ee4684-9aad-4d79-9d72-c84aed171909', 'e75f7576-39aa-458d-9c02-d1e3a52580e2', 'UNSOLD'),
('4c8cfb22-2479-4d75-a6ab-273b1fd2ebc6', '6c7a089b-25dd-49f2-af68-23be724c8dad', 'UNSOLD'),
('6172143b-c988-4f81-a089-67f130fd7477', 'b440c0df-e2d5-45d1-ae83-7325c3bb0018', 'UNSOLD'),
('45991ca0-3f58-4118-8954-47328ef6143f', 'a3cc4bbc-af11-4a44-9d56-85583a5b4df0', 'UNSOLD'),
('60106d64-c912-47fd-8d6e-3115d4deab87', 'e4b66235-61fc-4994-8289-0dc39f487824', 'UNSOLD'),
('c6b79cca-8e67-48f2-8924-b1e9f89ffef8', 'f64c0063-2a61-4b71-94d6-c6c09cf1ee21', 'UNSOLD'),
('ada04576-59f7-4b56-97b1-5db32c085a59', '9f17fa18-46a5-4d07-b352-e10e0c8b7b93', 'UNSOLD'),
('12f7386a-27da-40c0-b82e-cd2140572faf', '70925775-85ed-45fa-9a1b-2e646c783cde', 'UNSOLD'),
('44bb7611-bfc9-491c-b0a0-f2482b2afa8d', '399bc596-d565-42cf-ace6-19e6c19d4dbd', 'UNSOLD'),
('ac31c451-800f-4608-a070-a2a2435d17fa', '3f54b768-c8c3-4a33-ad8d-82d71f68c18b', 'UNSOLD'),
('924e558c-7f8d-4557-be13-a079b80d8c9c', '3577e59e-71e8-45bc-93bd-734c6d0f1c85', 'UNSOLD'),
('c2ed650c-314e-4235-a333-29021cc56ac2', '947e3ceb-7e76-4e47-a592-240e1c944a03', 'UNSOLD'),
('1631d67e-d607-4fea-8827-677bdf8ffe5e', 'b0ccca77-6ae7-49a7-8a56-0967140112e5', 'UNSOLD'),
('a8c6f5df-4db2-4f83-837c-129351bc34f1', 'e9deccdb-0a0e-4516-b6ae-8606ff426b33', 'UNSOLD'),
('ae8537b7-b2d6-49df-8b2e-2ef12ba07ddd', '6c83e3cd-61d7-4dd8-800a-c527fd04c3b5', 'UNSOLD'),
('5ae0938f-be5f-49c1-a2a2-7865583fd3e3', 'a55185d0-cc1c-49d3-9e00-75281c95fedf', 'UNSOLD'),
('1277f025-a1f5-4714-870a-eee02e8dbd96', '1002983f-d44d-4a7c-b7d1-22f9077fbac0', 'UNSOLD'),
('6142214e-e1a0-4f15-8142-96836252954b', '1db4bdeb-ed63-4cd1-a9da-5fd706142e00', 'UNSOLD'),
('4c3e89ac-0e4c-4357-907a-0bffcbcbc10c', '08f117ff-f162-46b2-99e2-ec8b01a381ec', 'UNSOLD'),
('637b61a9-d040-45e2-bbd1-09bb87f21bc4', '07a10fac-dd43-4365-a87f-d4a63e16b572', 'UNSOLD'),
('94dead6b-0c2b-4ed4-a6d5-a2fd30133b5a', 'e3a00cfa-c38b-4882-8ded-959d8265e5f3', 'UNSOLD'),
('bc186dae-7152-4290-8a49-0fa355bff4dc', '2c6ba30e-699d-47a4-b42d-a7d68188821a', 'UNSOLD'),
('675d0e64-5611-4c82-89b6-125fa3e0fcee', '56b7abe0-fb2e-406d-bee7-e166a6f43b36', 'UNSOLD'),
('47694647-2387-453d-8d76-8f0c4c1542b2', 'a928d465-2c4f-44a9-bbb0-4954b65c1fb8', 'UNSOLD'),
('e5c5b67f-5e11-448b-bf9f-56c775bd91c9', '071ced7e-36c0-4505-ba3b-39b55b1b2aa1', 'UNSOLD'),
('23fe17ab-fa35-4fd3-af56-b93209517757', '716da6eb-d339-423d-aa9b-f47d47d5a1b9', 'UNSOLD'),
('89fb99ea-8740-4d38-aced-dce060ecf6a4', 'f30714f9-4d12-4002-94d8-ec2333ac5ce4', 'UNSOLD'),
('12caef86-6244-4286-9506-c19ba8ed6f36', 'c3d22e2a-f9b7-4edf-8e18-e299815aaaee', 'UNSOLD'),
('0978f0bb-de59-4e23-aa18-9bf7bea7223b', '316da252-8cf2-4db1-9e15-e8082bd48c79', 'UNSOLD'),
('95762b7a-628e-4832-bf0f-c36b6e37b284', 'ef9e5b47-b462-4ff9-94f6-f2814809130d', 'UNSOLD'),
('294973e4-0913-4976-aa31-4402b3dc47a6', '0d1415a7-dccf-44ae-8def-acdeda58a57d', 'UNSOLD'),
('6f4079b5-cde4-4759-989f-98375008007c', '8a4db8bb-0667-43cd-a687-6127730864de', 'UNSOLD'),
('201e3f96-31d8-4c9a-82a2-d3f09c727020', '4e1e0f0e-a4ba-4155-94da-08bcf4061049', 'UNSOLD'),
('25cbffa9-053b-4539-a88b-10733457cbc1', '33c03a6a-7966-468d-adc0-c64a5845ccfe', 'UNSOLD'),
('84997e4c-dac4-4be3-9fde-6ffa749a6a04', 'a30ecd4d-a0dd-4803-a300-446fef6c5d0d', 'UNSOLD'),
('cbbe5cd4-db4e-4e40-a79a-0544e2f8206c', '80401b69-decb-43a4-8fc7-30a01d2417da', 'UNSOLD'),
('de9bf454-3912-44f0-b368-38a643c21d31', 'd0520542-8330-4c27-85ab-93fc58cb547f', 'UNSOLD'),
('fa00fe09-0cef-4a66-adad-8c8616af06fa', '10cdd936-4f04-4e6a-9769-54ffc228f295', 'UNSOLD'),
('3e245eca-3b1c-419a-83ee-a7960413fafc', '43d1145a-5141-49a4-b864-127f48edca69', 'UNSOLD'),
('3f97c97b-09c1-4f8b-ac8e-1990ea3ff1f8', 'fbeaedd1-89b1-4a25-9610-9212da8d95a6', 'UNSOLD'),
('642e592e-7f6e-4987-9975-f970283d21dc', '35fa65a7-e454-4747-bcbc-488d34269aa3', 'UNSOLD'),
('dac49826-5357-4b3b-9146-279edf60665d', '1dbbaf0f-b2d1-4257-a9bd-fdbaf203467b', 'UNSOLD'),
('02f13c0b-7bba-40ab-a5af-dad930114985', '91b4de1f-70f1-4cd0-ab5c-afcc6cb68b91', 'UNSOLD'),
('2521e4dd-7f80-46be-b3e9-baa1f6879dab', '832ff96f-3ac9-4570-ac8c-9e7cb8898b19', 'UNSOLD'),
('c9661e83-d468-4246-8b4d-94c14d8ac4a8', 'e0ef727e-3a94-43b8-8322-15de3e514a98', 'UNSOLD'),
('33e411e0-6796-47d3-9b7e-63e05a38e538', 'fde0d524-2af7-447c-b8cf-b010b1e55b7b', 'UNSOLD'),
('e52c9750-071b-4b89-b748-7af8beeaa85c', 'e2b56b3e-f1ce-4b73-9fcd-686e3b6acfa0', 'UNSOLD'),
('c4e71100-c0f3-4e9f-84e5-e0b9f7f6573b', '295c724d-b48f-4dc4-b202-649682f046f9', 'UNSOLD'),
('a935f4c9-2e66-4add-a4c7-b4453d348a6a', '42eb4503-d5e6-4a8c-a6f0-ed40bc4efdb0', 'UNSOLD'),
('e3a4bef8-481b-4202-b27a-ac30af7e2245', 'd626fe12-ed5d-4f92-a9f7-4c58be927cab', 'UNSOLD'),
('dd4e1132-e25a-48f6-b6cf-003dfd2aa953', 'a04636cf-3d19-4d73-9ce1-2153275ae358', 'UNSOLD'),
('74d5ad30-a283-43d5-9f0c-0c91159426d8', 'e83d948c-63ad-4438-80bd-1a163d26abb8', 'UNSOLD'),
('b92a0592-8332-489a-904e-45ab1dc742db', '1e0319f8-4b20-44ef-9d9b-82f45b9bde17', 'UNSOLD'),
('918804f3-702e-4a35-b322-86913eba7730', 'e089e9e2-d28f-4732-995c-fb3a0fd3c199', 'UNSOLD'),
('0988a7ab-f629-4b8b-ac20-680fd9ef9ad4', 'fe155921-2c47-4fe2-8bf2-5cfa73516a60', 'UNSOLD'),
('a544b297-9275-4a38-9194-d1bf3f8af23a', '13a78d6a-d71b-4d80-9758-62e3ddd6ca18', 'UNSOLD'),
('95084c07-5fc1-4a16-80c0-b84d1d7d3b17', '8dfc46aa-ea23-4daa-9e95-ae081cfef91c', 'UNSOLD'),
('f3cdbc54-a06e-440e-966f-0c506de3a019', '988e8267-46e2-4023-af57-85dc198f9509', 'UNSOLD'),
('20706bee-cd41-498d-a9f8-aa07730636f1', '52eb31fb-cf82-4766-9cbc-0e00bd04abb7', 'UNSOLD'),
('ab44bc9a-9475-4ba0-bbec-73ee28c32b65', '473a2ca2-9bd1-420f-a0fe-5caf49c74ab9', 'UNSOLD'),
('8dfda234-d4f2-4a26-ac14-1c523e16a695', 'f43a4c0b-4027-4b3a-ac3e-e021ed2129b8', 'UNSOLD'),
('6a7b0a0b-0592-420c-8cbb-2cd7aa79a249', '69b0e066-4611-48fd-88aa-86f17376e781', 'UNSOLD'),
('9e99f1f5-32aa-4933-9157-46b913c13e1c', 'a1eadc7e-ba35-45da-b80a-bd6d23a1eb5f', 'UNSOLD'),
('25d3e62d-450f-4f34-92bd-67ec8bcb6ab5', '4d9cc9a0-58d1-4009-ac05-47b215cac874', 'UNSOLD'),
('e5218dde-f040-4ebf-a6f3-cf8d364787e3', 'c9c2ef14-0a5a-4f88-9d3d-0057a12c64a8', 'UNSOLD'),
('8c31f420-b999-4ca9-bd45-f5a6da9d8485', 'd8a991d3-0879-4e5b-8e9b-66c15fac90ec', 'UNSOLD'),
('11181621-7c31-4f0e-96ea-249277c0b7bf', '4c05bcaf-4b85-48d9-bd01-3fa3ae6fb270', 'UNSOLD'),
('aa6e39a8-18f4-4f86-9b10-576cd2163a6a', '504eb99c-4177-4f90-b868-b00b51c0f6d7', 'UNSOLD'),
('3edf4fd0-e900-449d-ab31-bb31ce043fe0', 'dba869a8-7d92-4bb3-aee8-deeab09fc25c', 'UNSOLD'),
('922c84fe-b848-4953-82e6-52828521bee1', 'b8b2f949-16df-4775-98f6-2e48a2329bf2', 'UNSOLD'),
('5a228025-da86-435b-ab01-e3a94540e924', 'd7372bb9-32e8-4c06-a0ae-86bbb79f90ba', 'UNSOLD'),
('06dbe439-5ec8-47b6-a29e-c008ea346712', '9dc70fb7-56d8-4e60-afb1-148b9a7dbfaf', 'UNSOLD'),
('ee8fef49-2963-471a-b6d9-29e5221bf73a', 'f95adb13-8606-4d4b-b94a-7088c95c04fc', 'UNSOLD'),
('7a10537f-8b93-492f-9df2-996f094232e9', 'd9cb1a9e-2337-424f-ad39-7bee5229998e', 'UNSOLD'),
('0dc8f523-e6bb-430a-941d-7bce6a966bff', 'f7ba3036-9296-483a-8696-28ffbe35433a', 'UNSOLD'),
('eeac725f-9044-496e-9c72-90e98884fad0', 'a6bac60d-8bef-48b8-9cf0-67b75996a870', 'UNSOLD'),
('bb726906-8012-4bc0-a760-9b64a6bd858a', 'e345bcf2-2039-47a1-9253-9ed61c0281a4', 'UNSOLD'),
('5eb9903a-a2f0-49f1-8d7d-8a2ee452799d', '65c1be8c-9ba5-434f-b009-02d04a95ad9f', 'UNSOLD'),
('d22a147f-2467-443b-bf3b-515d6c2b70b4', '9c7a3892-301d-438d-92e5-39e6f5a77ec2', 'UNSOLD'),
('972ef778-bd72-4982-b5b2-733f30a8a9ad', 'ee1ab1e3-dbb7-4d30-89cf-a70a5ccbd5fc', 'UNSOLD'),
('ca51b001-3ab5-4099-874c-c6d3726b0f8a', '99671d42-7a1d-4a91-bb18-c089e00d9cbc', 'UNSOLD'),
('7efe9d7d-0d9a-4678-9970-23ee65ba7deb', 'b8888ff3-c6af-46f2-af0a-55cabb58415f', 'UNSOLD'),
('0ffbba5a-30fa-42d8-bc99-0fd4e47f7f5c', '681dce4b-3ca0-4099-9727-f67215f2229e', 'UNSOLD'),
('8b0fc59b-db56-479a-bbeb-6a2ce895e456', 'c84fb1b7-7ef9-4fb9-82e1-d16bc391d188', 'UNSOLD'),
('c8ab62f7-deff-4795-a0ed-f52300171e88', '7c789f03-4899-46da-b49c-67e7276ee2cc', 'UNSOLD'),
('7192ad15-aa66-4125-9e38-bb8632d4a2b6', '1485a7cb-848c-4adf-a988-6573d839ab8e', 'UNSOLD'),
('1aba10dc-16e7-4822-8868-6cd74e92d83b', '5b51cec4-2fe6-452f-9cc9-b345a506f39b', 'UNSOLD'),
('ff0765f9-c1f8-4ea4-b755-7c2e59d442f3', '0d137e76-7e71-4b0b-a5ed-a70d26acb250', 'UNSOLD'),
('fc9e55ad-f190-4a88-80e8-e416c9825723', '8182775a-0050-47f8-b3aa-a7b683e5a905', 'UNSOLD'),
('46069f65-e373-480a-9bdc-5bb6bfd7f00a', 'b2939e35-6248-4491-aea0-6d3479204e6a', 'UNSOLD'),
('e3304300-f89e-4617-b906-39e99a025cc3', '19c152c2-f332-45cc-a71b-c37e8f51857e', 'UNSOLD'),
('84e11f02-6a5c-45bf-8ecb-590dddd92839', '5be42919-1be5-4920-b3bf-6bb753744d9a', 'UNSOLD'),
('fad16323-0c53-4d62-8d01-6917bbfa2b68', '50cbb1ba-b492-4842-968b-9df8a75ae5e7', 'UNSOLD'),
('f8254959-0bc1-497f-b319-d59bca286d11', '0cb7d82c-5e29-4345-80bb-745cf8e97375', 'UNSOLD'),
('8727901a-1974-4aa8-831a-5d2d2f435da9', '72e40937-669f-49fa-8124-ea1bea6ae925', 'UNSOLD'),
('0963aa83-ce93-40a6-a2ba-c66866597b98', '507d6866-077e-46a2-81d6-788b2f60e50b', 'UNSOLD'),
('05523a57-4ba6-40a4-a1a5-330ed99d5d7c', 'f9a3373f-3d60-4a68-93c1-c4286d0749f8', 'UNSOLD'),
('8bcf136a-0ab8-41ad-a7ac-e94bce67629c', '2ec25b23-3d2d-4fe9-b6bf-3eba423d39ad', 'UNSOLD');

INSERT INTO "AdminUser" (id, username, password_hash, role) VALUES
('39229430-5248-4a5c-9bea-46d5934f39e1', 'admin', '$2b$10$wkPPlICB5aiKZ691qBFyu.RX4KgAs0V9NLWpWeJrAS8WPP6GAyTxC', 'ADMIN'),
('43b480dd-0b00-48fd-8cd6-913293211059', 'screen', '$2b$10$uH5fAsrC7lrHzHdvO1pGteIPXu7lgF6YQFNv0tC8.2.h6jYPhCA6K', 'SCREEN');

INSERT INTO "AuctionSequence" (id, name, type, sequence_items) VALUES
(1, 'Franchise Auction', 'FRANCHISE', '[3,7,1,9,5,10,2,6,8,4]');

INSERT INTO "AuctionSequence" (id, name, type, sequence_items) VALUES
(2, 'Power Card Auction', 'POWER_CARD', '["GOD_EYE","MULLIGAN","FINAL_STRIKE","BID_FREEZER"]');

INSERT INTO "AuctionSequence" (id, name, type, sequence_items) VALUES
(3, 'Player Auction 2', 'PLAYER', '[131,134,149,69,81,66,26,34,84,23,116,155,123,124,142,148,101,94,119,76,135,115,147,19,43,1,80,30,68,85,109,118,100,58,7,120,122,128,130,64,121,144,24,42,137,133,141,88,74,60,29,106,159,59,97,49,92,78,151,47,82,77,140,98,72,62,102,63,5,136,93,71,146,153,40,113,48,4,139,55,107,36,143,99,41,152,20,54,95,32,103,111,38,90,79,96,12,86,158,46,104,75,18,129,57,105,89,154,44,16,117,39,108,35,8,33,67,13,125,150,52,138,31,126,157,87,10,114,73,83,2,25,15,45,56,53,127,11,156,21,51,65,28,112,70,22,61,17,91,9,50,6,132,145,3,27,110,37,14]');

INSERT INTO "AuctionState" (id, phase, auction_day) VALUES (1, 'NOT_STARTED', 'Day 1');

