-- ============================================================
-- Tournament & Course Analysis
-- ============================================================
SELECT
  Tournament,
  Course,
  COUNT(*) AS Rounds,
  ROUND(AVG(Score), 2) AS AverageScore,
  ROUND(AVG(ScoreToPar), 2) AS AverageScoreToPar,
  ROUND(AVG(DriveDistance), 2) AS AverageDriveDistance,
  ROUND(AVG(GIR), 2) AS AverageGIR,
  ROUND(AVG(Putts), 2) AS AveragePutts,
  ROUND(AVG(Birdies), 2) AS AverageBirdies,
  ROUND(AVG(Bogeys), 2) AS AverageBogeys,
  ROUND(AVG(StrokesGainedTotal), 2) AS AverageStrokesGained,
  ROUND(SUM(Earnings), 2) AS TotalEarnings
FROM `fictional-golf-analysis.golf_analytics.golf_performance`
GROUP BY
  Tournament,
  Course
ORDER BY AverageScore;

-- Course Difficulty
SELECT
    Course,
    COUNT(*) AS Rounds,
    ROUND(AVG(Score), 2) AS AverageScore,
    ROUND(AVG(ScoreToPar), 2) AS AverageScoreToPar,
    ROUND(AVG(GIR), 2) AS AverageGIR,
    ROUND(AVG(Birdies), 2) AS AverageBirdies,
    ROUND(AVG(Bogeys), 2) AS AverageBogeys
FROM `fictional-golf-analysis.golf_analytics.golf_performance`
GROUP BY Course
ORDER BY AverageScore DESC;

-- Course Performance by Round
SELECT
    Course,
    Round,
    ROUND(AVG(Score), 2) AS AverageScore,
    ROUND(AVG(GIR), 2) AS AverageGIR,
    ROUND(AVG(Putts), 2) AS AveragePutts
FROM `fictional-golf-analysis.golf_analytics.golf_performance`
GROUP BY
    Course,
    Round
ORDER BY
    Course,
    Round;

-- Earnings Analysis
SELECT
    Tournament,
    ROUND(SUM(Earnings), 2) AS TotalEarnings,
    ROUND(AVG(Earnings), 2) AS AverageEarnings
FROM `fictional-golf-analysis.golf_analytics.golf_performance`
GROUP BY Tournament
ORDER BY TotalEarnings DESC;

-- Top Earners
SELECT
    PlayerID,
    FirstName,
    LastName,
    ROUND(SUM(Earnings), 2) AS TotalEarnings,
    ROUND(AVG(Score), 2) AS AverageScore,
    ROUND(AVG(StrokesGainedTotal), 2) AS AverageStrokesGained,
    ROUND(AVG(GIR), 2) AS AverageGIR
FROM `fictional-golf-analysis.golf_analytics.golf_performance`
GROUP BY
    PlayerID,
    FirstName,
    LastName
ORDER BY TotalEarnings DESC
LIMIT 10;

-- Earnings Per Stroke
SELECT
    PlayerID,
    FirstName,
    LastName,
    ROUND(AVG(EarningsPerStroke), 2) AS AvgEarningsPerStroke,
    ROUND(AVG(Score), 2) AS AverageScore,
    ROUND(SUM(Earnings), 2) AS TotalEarnings
FROM `fictional-golf-analysis.golf_analytics.golf_performance`
GROUP BY
    PlayerID,
    FirstName,
    LastName
ORDER BY AvgEarningsPerStroke DESC
LIMIT 10;

--Advanced Player Analysis
WITH player_performance AS (

    SELECT
        PlayerID,
        FirstName,
        LastName,
        AVG(Score) AS AverageScore,
        AVG(GIR) AS AverageGIR,
        AVG(Birdies) AS AverageBirdies,
        AVG(Bogeys) AS AverageBogeys,
        AVG(StrokesGainedTotal) AS AverageStrokesGained,
        SUM(Earnings) AS TotalEarnings

    FROM `fictional-golf-analysis.golf_analytics.golf_performance`

    GROUP BY
        PlayerID,
        FirstName,
        LastName
)

SELECT
    PlayerID,
    FirstName,
    LastName,
    ROUND(AverageScore, 2) AS AverageScore,
    ROUND(AverageGIR, 2) AS AverageGIR,
    ROUND(AverageBirdies, 2) AS AverageBirdies,
    ROUND(AverageBogeys, 2) AS AverageBogeys,
    ROUND(AverageStrokesGained, 2) AS AverageStrokesGained,
    ROUND(TotalEarnings, 2) AS TotalEarnings
FROM player_performance
WHERE AverageGIR >= 13
ORDER BY AverageScore ASC;

-- Performance Segmentation
WITH player_summary AS (

    SELECT
        PlayerID,
        FirstName,
        LastName,
        AVG(Score) AS AverageScore,
        AVG(StrokesGainedTotal) AS AverageStrokesGained,
        AVG(GIR) AS AverageGIR

    FROM `fictional-golf-analysis.golf_analytics.golf_performance`

    GROUP BY
        PlayerID,
        FirstName,
        LastName
)

SELECT
    PlayerID,
    FirstName,
    LastName,
    ROUND(AverageScore, 2) AS AverageScore,
    ROUND(AverageStrokesGained, 2) AS AverageStrokesGained,
    ROUND(AverageGIR, 2) AS AverageGIR,

    CASE
        WHEN AverageScore <= 68 THEN 'Elite Scoring'
        WHEN AverageScore <= 71 THEN 'Strong Scoring'
        WHEN AverageScore <= 74 THEN 'Average Scoring'
        ELSE 'Higher Scoring'
    END AS PerformanceGroup

FROM player_summary
ORDER BY AverageScore;

-- Players with Strong Overall Performance
WITH player_summary AS (

    SELECT
        PlayerID,
        FirstName,
        LastName,
        AVG(Score) AS AverageScore,
        AVG(GIR) AS AverageGIR,
        AVG(Birdies) AS AverageBirdies,
        AVG(Bogeys) AS AverageBogeys,
        AVG(StrokesGainedTotal) AS AverageStrokesGained,
        SUM(Earnings) AS TotalEarnings

    FROM `fictional-golf-analysis.golf_analytics.golf_performance`

    GROUP BY
        PlayerID,
        FirstName,
        LastName
)

SELECT
    PlayerID,
    FirstName,
    LastName,
    ROUND(AverageScore, 2) AS AverageScore,
    ROUND(AverageGIR, 2) AS AverageGIR,
    ROUND(AverageBirdies, 2) AS AverageBirdies,
    ROUND(AverageBogeys, 2) AS AverageBogeys,
    ROUND(AverageStrokesGained, 2) AS AverageStrokesGained,
    ROUND(TotalEarnings, 2) AS TotalEarnings

FROM player_summary

WHERE AverageScore < 70
  AND AverageGIR >= 12
  AND AverageStrokesGained > 0

ORDER BY AverageScore ASC;

-- Final Analytical Dataset
CREATE OR REPLACE TABLE
`fictional-golf-analysis.golf_analytics.player_performance_summary` AS

SELECT
    PlayerID,
    FirstName,
    LastName,

    COUNT(*) AS RoundsPlayed,

    ROUND(AVG(Score), 2) AS AverageScore,
    ROUND(AVG(ScoreToPar), 2) AS AverageScoreToPar,

    ROUND(AVG(DriveDistance), 2) AS AverageDriveDistance,
    ROUND(AVG(FairwaysHit), 2) AS AverageFairwaysHit,

    ROUND(AVG(GIR), 2) AS AverageGIR,
    ROUND(AVG(Putts), 2) AS AveragePutts,

    ROUND(AVG(Birdies), 2) AS AverageBirdies,
    ROUND(AVG(Bogeys), 2) AS AverageBogeys,

    ROUND(AVG(StrokesGainedTotal), 2) AS AverageStrokesGained,

    ROUND(SUM(Earnings), 2) AS TotalEarnings

FROM `fictional-golf-analysis.golf_analytics.golf_performance`

GROUP BY
    PlayerID,
    FirstName,
    LastName;

SELECT *
FROM `fictional-golf-analysis.golf_analytics.player_performance_summary`
LIMIT 10;

SELECT COUNT(*) AS player_count
FROM `fictional-golf-analysis.golf_analytics.player_performance_summary`;

-- Tournament Summary Table
CREATE OR REPLACE TABLE
`fictional-golf-analysis.golf_analytics.tournament_performance_summary` AS

SELECT
    Tournament,
    Course,

    COUNT(*) AS Rounds,

    ROUND(AVG(Score), 2) AS AverageScore,
    ROUND(AVG(ScoreToPar), 2) AS AverageScoreToPar,

    ROUND(AVG(DriveDistance), 2) AS AverageDriveDistance,
    ROUND(AVG(FairwaysHit), 2) AS AverageFairwaysHit,

    ROUND(AVG(GIR), 2) AS AverageGIR,
    ROUND(AVG(Putts), 2) AS AveragePutts,

    ROUND(AVG(Birdies), 2) AS AverageBirdies,
    ROUND(AVG(Bogeys), 2) AS AverageBogeys,

    ROUND(AVG(StrokesGainedTotal), 2) AS AverageStrokesGained,

    ROUND(SUM(Earnings), 2) AS TotalEarnings

FROM `fictional-golf-analysis.golf_analytics.golf_performance`

GROUP BY
    Tournament,
    Course;

SELECT *
FROM `fictional-golf-analysis.golf_analytics.tournament_performance_summary`
ORDER BY AverageScore;











