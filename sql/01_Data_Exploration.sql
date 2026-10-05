-- ============================================================
-- Golf Analytics Portfolio Project
-- Phase 3: SQL Analysis
-- ============================================================
--
-- Purpose:
-- Explore and analyze the cleaned golf performance dataset
-- using SQL.
--
-- Dataset:
-- 25,000 golf performance observations
-- 500 players
-- 12 tournaments
--
-- Objectives:
-- 1. Validate the dataset
-- 2. Analyze overall performance
-- 3. Analyze player performance
-- 4. Analyze tournament/course performance
-- 5. Identify relationships between performance metrics
-- 6. Prepare analytical data for dashboard development
-- ============================================================

SELECT *
FROM `fictional-golf-analysis.golf_analytics.golf_performance`
LIMIT 10;

SELECT COUNT(*) AS total_rows
FROM `fictional-golf-analysis.golf_analytics.golf_performance`;

SELECT COUNT(DISTINCT PlayerID) AS unique_players
FROM `fictional-golf-analysis.golf_analytics.golf_performance`;

SELECT COUNT(DISTINCT Tournament) AS unique_tournaments
FROM `fictional-golf-analysis.golf_analytics.golf_performance`;

-- Basic Exploration
SELECT *
FROM `fictional-golf-analysis.golf_analytics.golf_performance`
LIMIT 5;

SELECT 
  Tournament,
  COUNT(*) AS rounds
FROM `fictional-golf-analysis.golf_analytics.golf_performance`
GROUP BY Tournament
ORDER BY rounds DESC;

-- Data Quality Checks
SELECT 
  COUNTIF(PlayerID IS NULL) AS null_player_id,
  COUNTIF(Score IS NULL) AS null_score,
  COUNTIF(GIR IS NULL) AS null_gir,
  COUNTIF(Putts IS NULL) AS null_putts,
  COUNTIF(Earnings IS NULL) AS null_earnings
FROM `fictional-golf-analysis.golf_analytics.golf_performance`;

SELECT 
  PlayerID,
  Tournament,
  Course,
  Round,
  Date,
  COUNT(*) AS record_count
FROM `fictional-golf-analysis.golf_analytics.golf_performance`
GROUP BY
  PlayerID,
  Tournament,
  Course,
  Round,
  Date
HAVING COUNT(*) > 1
ORDER BY record_count DESC;