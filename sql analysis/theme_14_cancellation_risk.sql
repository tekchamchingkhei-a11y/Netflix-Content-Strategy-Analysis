-- ============================================
-- THEME 14: ONE SEASON CANCELLATION RISK
-- Business Pillar: Risk/Investment
-- Executive Question: Are we burning money on
-- multi-season epics or 1-season tests?
-- Techniques: CTE, CASE WHEN buckets,
--             COUNT(), SUM() OVER(), ROUND()
-- ============================================

WITH show_seasons AS (
    SELECT
        title,
        duration_value,
        year_added,
        CASE
            WHEN duration_value = 1  THEN '1 Season'
            WHEN duration_value = 2  THEN '2 Seasons'
            WHEN duration_value = 3  THEN '3 Seasons'
            WHEN duration_value BETWEEN 4 AND 6
                                     THEN '4-6 Seasons'
            ELSE                          '7+ Seasons'
        END                             AS season_bucket
    FROM netflix_cleaned
    WHERE type = 'TV Show'
    AND duration_value IS NOT NULL
),
season_summary AS (
    SELECT
        season_bucket,
        COUNT(*)                        AS total_shows,
        ROUND(COUNT(*) * 100.0 /
              SUM(COUNT(*)) OVER()
        , 2)                            AS percentage
    FROM show_seasons
    GROUP BY season_bucket
)

SELECT
    season_bucket,
    total_shows,
    percentage,
    -- Risk Label
    CASE
        WHEN season_bucket = '1 Season'    THEN 'Safe Bet'
        WHEN season_bucket = '2 Seasons'   THEN 'Early Commitment'
        WHEN season_bucket = '3 Seasons'   THEN 'Medium Investment'
        WHEN season_bucket = '4-6 Seasons' THEN 'High Investment'
        ELSE                                    'Legacy Franchise'
    END                                     AS investment_risk,
    -- Financial Impact Label
    CASE
        WHEN season_bucket = '1 Season'    THEN 'Low Budget Risk'
        WHEN season_bucket = '2 Seasons'   THEN 'Medium Budget Risk'
        WHEN season_bucket = '3 Seasons'   THEN 'High Budget Risk'
        WHEN season_bucket = '4-6 Seasons' THEN 'Very High Budget Risk'
        ELSE                                    'Maximum Budget Risk'
    END                                     AS financial_impact
FROM season_summary
ORDER BY total_shows DESC;

-- ============================================
-- KEY INSIGHT:
-- 67.25% of all shows receive just 1 season
-- meaning Netflix cancels 76% of content after
-- initial test. Only 2.36% achieve Legacy
-- Franchise status (7+ seasons). Netflix is a
-- testing platform not a legacy TV network.
-- Low risk strategy protects budget from
-- expensive failures explaining the platform's
-- reputation for aggressive cancellations
-- ============================================
