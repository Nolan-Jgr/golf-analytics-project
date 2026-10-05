-- ============================================================
-- Player Performance Analysis
-- ============================================================
SELECT
    ROUND(AVG(Score), 2) AS avg_score,
    ROUND(AVG(ScoreToPar), 2) AS avg_score_to_par,
    ROUND(AVG(DriveDistance), 2) AS avg_drive_distance,
    ROUND(AVG(FairwaysHit), 2) AS avg_fairways_hit,
    ROUND(AVG(GIR), 2) AS avg_gir,
    ROUND(AVG(Putts), 2) AS avg_putts,
    ROUND(AVG(Birdies), 2) AS avg_birdies,
    ROUND(AVG(Bogeys), 2) AS avg_bogeys,
    ROUND(AVG(StrokesGainedTotal), 2) AS avg_strokes_gained,
    ROUND(AVG(Earnings), 2) AS avg_earnings
FROM `fictional-golf-analysis.golf_analytics.golf_performance`;

-- Player Performance
SELECT
    PlayerID,
    FirstName,
    LastName,
    COUNT(*) AS RoundsPlayed,
    ROUND(AVG(Score), 2) AS AverageScore,
    ROUND(AVG(ScoreToPar), 2) AS AverageScoreToPar,
    ROUND(AVG(DriveDistance), 2) AS AverageDrivingDistance,
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

-- Top Players by Average Score
SELECT
    PlayerID,
    FirstName,
    LastName,
    COUNT(*) AS RoundsPlayed,
    ROUND(AVG(Score), 2) AS AverageScore,
    ROUND(AVG(GIR), 2) AS AverageGIR,
    ROUND(AVG(Birdies), 2) AS AverageBirdies,
    ROUND(AVG(Bogeys), 2) AS AverageBogeys,
    ROUND(AVG(StrokesGainedTotal), 2) AS AverageStrokesGained
FROM `fictional-golf-analysis.golf_analytics.golf_performance`
GROUP BY
    PlayerID,
    FirstName,
    LastName
ORDER BY AverageScore ASC
LIMIT 10;

-- Player Consistency
SELECT
    PlayerID,
    FirstName,
    LastName,
    COUNT(*) AS RoundsPlayed,
    ROUND(AVG(Score), 2) AS AverageScore,
    ROUND(STDDEV(Score), 2) AS ScoreStdDev
FROM `fictional-golf-analysis.golf_analytics.golf_performance`
GROUP BY
    PlayerID,
    FirstName,
    LastName
ORDER BY ScoreStdDev ASC
LIMIT 10;

-- Driving Analysis
SELECT
    ROUND(AVG(DriveDistance), 2) AS AverageDriveDistance,
    ROUND(AVG(FairwaysHit), 2) AS AverageFairwaysHit,
    ROUND(AVG(Score), 2) AS AverageScore
FROM `fictional-golf-analysis.golf_analytics.golf_performance`;

SELECT
    CASE
        WHEN DriveDistance < 270 THEN 'Under 270'
        WHEN DriveDistance < 290 THEN '270-289'
        WHEN DriveDistance < 310 THEN '290-309'
        WHEN DriveDistance < 330 THEN '310-329'
        ELSE '330+'
    END AS DrivingDistanceGroup,

    COUNT(*) AS Rounds,
    ROUND(AVG(Score), 2) AS AverageScore,
    ROUND(AVG(GIR), 2) AS AverageGIR
FROM `fictional-golf-analysis.golf_analytics.golf_performance`
GROUP BY DrivingDistanceGroup
ORDER BY AverageScore ASC;

-- GIR Analysis
SELECT
    CASE
        WHEN GIR <= 6 THEN '0-6'
        WHEN GIR <= 9 THEN '7-9'
        WHEN GIR <= 12 THEN '10-12'
        WHEN GIR <= 15 THEN '13-15'
        ELSE '16-18'
    END AS GIR_Group,

    COUNT(*) AS Rounds,
    ROUND(AVG(Score), 2) AS AverageScore,
    ROUND(AVG(Birdies), 2) AS AverageBirdies,
    ROUND(AVG(Bogeys), 2) AS AverageBogeys
FROM `fictional-golf-analysis.golf_analytics.golf_performance`
GROUP BY GIR_Group
ORDER BY AverageScore;

-- Putting Analysis
SELECT
    CASE
        WHEN Putts <= 27 THEN '27 or fewer'
        WHEN Putts <= 30 THEN '28-30'
        WHEN Putts <= 33 THEN '31-33'
        WHEN Putts <= 36 THEN '34-36'
        ELSE '37+'
    END AS PuttingGroup,

    COUNT(*) AS Rounds,
    ROUND(AVG(Score), 2) AS AverageScore,
    ROUND(AVG(GIR), 2) AS AverageGIR,
    ROUND(AVG(Birdies), 2) AS AverageBirdies
FROM `fictional-golf-analysis.golf_analytics.golf_performance`
GROUP BY PuttingGroup
ORDER BY AverageScore;

-- Birdie/Bogey Analysis
SELECT
    Birdies,
    COUNT(*) AS Rounds,
    ROUND(AVG(Score), 2) AS AverageScore,
    ROUND(AVG(Bogeys), 2) AS AverageBogeys
FROM `fictional-golf-analysis.golf_analytics.golf_performance`
GROUP BY Birdies
ORDER BY Birdies;

SELECT
    Bogeys,
    COUNT(*) AS Rounds,
    ROUND(AVG(Score), 2) AS AverageScore,
    ROUND(AVG(Birdies), 2) AS AverageBirdies
FROM `fictional-golf-analysis.golf_analytics.golf_performance`
GROUP BY Bogeys
ORDER BY Bogeys;

SELECT
    Birdies - Bogeys AS BirdieBogeyBalance,
    COUNT(*) AS Rounds,
    ROUND(AVG(Score), 2) AS AverageScore
FROM `fictional-golf-analysis.golf_analytics.golf_performance`
GROUP BY BirdieBogeyBalance
ORDER BY BirdieBogeyBalance;

-- Strokes Gained Analysis
SELECT
    CASE
        WHEN StrokesGainedTotal < -2 THEN 'Below -2'
        WHEN StrokesGainedTotal < 0 THEN '-2 to 0'
        WHEN StrokesGainedTotal < 2 THEN '0 to 2'
        WHEN StrokesGainedTotal < 4 THEN '2 to 4'
        ELSE '4+'
    END AS StrokesGainedGroup,

    COUNT(*) AS Rounds,
    ROUND(AVG(Score), 2) AS AverageScore,
    ROUND(AVG(GIR), 2) AS AverageGIR,
    ROUND(AVG(Birdies), 2) AS AverageBirdies
FROM `fictional-golf-analysis.golf_analytics.golf_performance`
GROUP BY StrokesGainedGroup
ORDER BY AverageScore;