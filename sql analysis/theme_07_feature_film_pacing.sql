-- ============================================
-- THEME 7: FEATURE FILM PACING
-- Business Pillar: Content
-- Executive Question: Are movies getting 
-- shorter to match shrinking attention spans?
-- Techniques: CTE, AVG() OVER(), LAG(),
--             MIN(), MAX(), ROUND()
-- ============================================

WITH movie_duration AS (
    SELECT
        release_year,
        ROUND(AVG(duration_value), 2)    AS avg_duration,
        COUNT(*)                          AS total_movies,
        MIN(duration_value)               AS shortest_movie,
        MAX(duration_value)               AS longest_movie
    FROM netflix_cleaned
    WHERE type = 'Movie'
    AND duration_value IS NOT NULL
    AND release_year IS NOT NULL
    GROUP BY release_year
)

SELECT
    release_year,
    avg_duration,
    total_movies,
    shortest_movie,
    longest_movie,
    -- Compare with previous year
    LAG(avg_duration) OVER
        (ORDER BY release_year)          AS prev_year_avg,
    -- Difference from previous year
    ROUND(avg_duration - LAG(avg_duration)
        OVER (ORDER BY release_year)
    , 2)                                 AS duration_change,
    -- Trend Label
    CASE
        WHEN avg_duration - LAG(avg_duration)
             OVER (ORDER BY release_year) > 0 THEN 'Getting Longer'
        WHEN avg_duration - LAG(avg_duration)
             OVER (ORDER BY release_year) < 0 THEN 'Getting Shorter'
        ELSE                                       'No Change'
    END                                  AS duration_trend
FROM movie_duration
WHERE release_year >= 2000
ORDER BY release_year ASC;

-- ============================================
-- KEY INSIGHT:
-- Netflix movies shrunk by 18 mins over 20
-- years from 111 mins in 2000 to historic low
-- of 93 mins in 2019. 2016 content explosion
-- accelerated this trend. Slight recovery in
-- 2021 (96 mins) suggests Netflix reinvesting
-- in longer prestige content post COVID
-- ============================================
