-- ============================================
-- THEME 12: COUNTRY VS RATING INTELLIGENCE
-- Business Pillar: Audience
-- Executive Question: Do Eastern vs Western 
-- markets need different content strategies?
-- Techniques: CTE, RANK() OVER(),
--             PARTITION BY, CASE WHEN
-- ============================================

WITH country_rating AS (
    SELECT
        country,
        rating,
        COUNT(*)                                AS total_titles
    FROM netflix_cleaned
    WHERE country != 'Unknown'
    AND country IS NOT NULL
    AND rating IS NOT NULL
    AND country IN (
        'United States', 'India',
        'United Kingdom', 'Japan',
        'South Korea', 'Canada',
        'Spain', 'France',
        'Egypt', 'Nigeria'
    )
    GROUP BY country, rating
),
country_ranked AS (
    SELECT
        country,
        rating,
        total_titles,
        -- Rank ratings within each country
        RANK() OVER (
            PARTITION BY country
            ORDER BY total_titles DESC
        )                                       AS rating_rank
    FROM country_rating
)

SELECT
    country,
    rating,
    total_titles,
    rating_rank,
    -- Market Strategy Label
    CASE
        WHEN rating = 'TV-MA' 
             AND rating_rank = 1 THEN 'Adult Premium Market'
        WHEN rating = 'TV-14' 
             AND rating_rank = 1 THEN 'Teen Dominant Market'
        WHEN rating IN ('TV-Y','TV-G','G')
             AND rating_rank = 1 THEN 'Family Market'
        ELSE                          'Mixed Market'
    END                                         AS market_strategy
FROM country_ranked
WHERE rating_rank <= 3
ORDER BY country, rating_rank;

-- ============================================
-- KEY INSIGHT:
-- Clear East vs West content divide confirmed.
-- Every Western market (US, UK, Canada, France,
-- Spain) is TV-MA dominant. All Eastern markets
-- (India, Japan, Egypt, Nigeria) are TV-14
-- dominant requiring completely different
-- regional strategies. South Korea unique
-- hybrid with TV-MA and TV-14 separated by
-- just 2 titles. R rating appears exclusively
-- in US top 3 — uniquely American classification
-- ============================================
