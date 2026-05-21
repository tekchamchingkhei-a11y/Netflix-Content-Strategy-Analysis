-- ============================================
-- THEME 13: VIP TALENT & DIRECTOR ROI
-- Business Pillar: Risk/Investment
-- Executive Question: Who are the most 
-- reliable collaborators deserving big contracts?
-- Techniques: CTE, DENSE_RANK() OVER(),
--             COUNT(DISTINCT), CASE WHEN
-- ============================================

WITH director_stats AS (
    SELECT
        director,
        COUNT(*)                                AS total_titles,
        SUM(CASE WHEN type = 'Movie'
            THEN 1 ELSE 0 END)                  AS total_movies,
        SUM(CASE WHEN type = 'TV Show'
            THEN 1 ELSE 0 END)                  AS total_tvshows,
        COUNT(DISTINCT country)                 AS countries_worked
    FROM netflix_cleaned
    WHERE director != 'Unknown'
    AND director IS NOT NULL
    GROUP BY director
),
director_ranked AS (
    SELECT
        director,
        total_titles,
        total_movies,
        total_tvshows,
        countries_worked,
        DENSE_RANK() OVER (
            ORDER BY total_titles DESC
        )                                       AS productivity_rank,
        -- Global Reach Label
        CASE
            WHEN countries_worked >= 4 THEN 'Global Director'
            WHEN countries_worked >= 2 THEN 'Regional Director'
            ELSE                            'Local Director'
        END                                     AS reach_label,
        -- ROI Tier Label
        CASE
            WHEN total_titles >= 10 THEN 'VIP Director'
            WHEN total_titles >= 5  THEN 'Reliable Director'
            WHEN total_titles >= 3  THEN 'Emerging Director'
            ELSE                         'One Time Director'
        END                                     AS director_tier
    FROM director_stats
)

SELECT
    director,
    total_titles,
    total_movies,
    total_tvshows,
    countries_worked,
    productivity_rank,
    reach_label,
    director_tier
FROM director_ranked
WHERE productivity_rank <= 20
ORDER BY productivity_rank;

-- ============================================
-- KEY INSIGHT:
-- India's Rajiv Chilaka is Netflix's most
-- productive director with 19 titles outranking
-- Hollywood legends Scorsese (12) and
-- Spielberg (11). However Scorsese and Spielberg
-- lead in global reach spanning 5 countries
-- each making them highest ROI for international
-- strategy. Top 20 directors represent 8+
-- nationalities confirming Netflix's commitment
-- to a truly global talent network
-- ============================================
