-- ============================================
-- THEME 1: CONTENT FORMAT STRATEGY
-- Business Pillar: Content
-- Executive Question: Are we pivoting from 
-- Movies to TV Shows for longer retention?
-- Techniques: CTE, CASE WHEN, LAG(), YoY%
-- ============================================

WITH yearly_format AS (
    SELECT
        year_added,
        COUNT(*) AS total_content,
        SUM(CASE WHEN type = 'Movie' THEN 1 ELSE 0 END) AS total_movies,
        SUM(CASE WHEN type = 'TV Show' THEN 1 ELSE 0 END) AS total_tvshows
    FROM netflix_cleaned
    WHERE year_added IS NOT NULL
    GROUP BY year_added
),
percentage_wise AS (
    SELECT
        year_added,
        total_content,
        total_movies,
        total_tvshows,
        ROUND(total_movies * 100.0 / total_content, 2) AS movie_pct,
        ROUND(total_tvshows * 100.0 / total_content, 2) AS tvshow_pct
    FROM yearly_format
),
with_lag AS (
    SELECT
        year_added,
        total_content,
        total_movies,
        total_tvshows,
        movie_pct,
        tvshow_pct,
        LAG(total_tvshows) OVER (ORDER BY year_added) AS prev_year_tvshows,
        LAG(total_movies)  OVER (ORDER BY year_added) AS prev_year_movies
    FROM percentage_wise
),
with_growth AS (
    SELECT
        year_added,
        total_content,
        total_movies,
        total_tvshows,
        movie_pct,
        tvshow_pct,
        ROUND(
            (total_tvshows - prev_year_tvshows) * 100.0 /
            NULLIF(prev_year_tvshows, 0)
        , 2) AS tvshow_growth_pct,
        ROUND(
            (total_movies - prev_year_movies) * 100.0 /
            NULLIF(prev_year_movies, 0)
        , 2) AS movie_growth_pct
    FROM with_lag
)
SELECT
    year_added,
    total_content,
    total_movies,
    total_tvshows,
    movie_pct,
    tvshow_pct,
    tvshow_growth_pct,
    movie_growth_pct,
    CASE
        WHEN tvshow_pct > movie_pct               THEN 'TV Show Dominant'
        WHEN movie_pct > 70                       THEN 'Heavy Movie Investment'
        WHEN tvshow_growth_pct > movie_growth_pct THEN 'TV Show Momentum'
        ELSE                                           'Movie Dominant'
    END AS platform_strategy
FROM with_growth
ORDER BY year_added;

-- ============================================
-- KEY INSIGHT:
-- Netflix operated as Heavy Movie Investment
-- platform from 2008-2014. TV Show Momentum
-- began in 2015 (+420%) peaking at 2016 (+576%)
-- TV Show Momentum returned in 2020 and held
-- through 2021 confirming retention-first pivot
-- ============================================
