-- ============================================
-- THEME 6: GLOBAL MARKET DOMINANCE
-- Business Pillar: Growth
-- Executive Question: Which countries dominate 
-- our pipeline and who is threatening US?
-- Techniques: CTE, RANK() OVER(),
--             CASE WHEN, SUM() OVER()
-- ============================================

WITH country_content AS (
    SELECT
        country,
        COUNT(*)                                AS total_titles,
        SUM(CASE WHEN type = 'Movie'
            THEN 1 ELSE 0 END)                  AS total_movies,
        SUM(CASE WHEN type = 'TV Show'
            THEN 1 ELSE 0 END)                  AS total_tvshows
    FROM netflix_cleaned
    WHERE country != 'Unknown'
    AND country IS NOT NULL
    GROUP BY country
)

SELECT
    country,
    total_titles,
    total_movies,
    total_tvshows,
    RANK() OVER (ORDER BY total_titles DESC)     AS country_rank,
    ROUND(total_movies * 100.0 /
          total_titles, 2)                       AS movie_pct,
    ROUND(total_tvshows * 100.0 /
          total_titles, 2)                       AS tvshow_pct,
    -- Market Type Label
    CASE
        WHEN ROUND(total_movies * 100.0 /
             total_titles, 2) >= 70 THEN 'Movie Dominant Market'
        WHEN ROUND(total_tvshows * 100.0 /
             total_titles, 2) >= 70 THEN 'TV Show Dominant Market'
        ELSE                             'Balanced Market'
    END                                          AS market_type
FROM country_content
ORDER BY total_titles DESC
LIMIT 15;

-- ============================================
-- KEY INSIGHT:
-- US leads with 2809 titles (32%) but India
-- closing fast at 972 (11%). Asian markets
-- are TV Show powerhouses — South Korea 79.4%
-- Japan 68.85% Taiwan 83.95%. India and
-- Indonesia remain pure Movie markets at 90%+
-- Egypt and Nigeria entering top 15 confirms
-- aggressive global expansion strategy
-- ============================================
