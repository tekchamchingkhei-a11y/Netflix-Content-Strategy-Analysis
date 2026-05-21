-- ============================================
-- THEME 2: SPEED TO PLATFORM
-- Business Pillar: Content
-- Executive Question: Are we acquiring fresh 
-- premium content or cheap old catalogs?
-- Techniques: DATE math, CASE WHEN, CTE,
--             SUM() OVER()
-- ============================================

-- QUERY 1: Individual Title Level
SELECT
    type,
    title,
    release_year,
    year_added,
    (year_added - release_year) AS years_to_platform,
    CASE
        WHEN (year_added - release_year) = 0  THEN 'Same Year Release'
        WHEN (year_added - release_year) <= 2 THEN 'Fresh Content'
        WHEN (year_added - release_year) <= 5 THEN 'Mid Age Content'
        WHEN (year_added - release_year) <= 10 THEN 'Old Content'
        ELSE                                        'Vintage Catalog'
    END AS content_freshness
FROM netflix_cleaned
WHERE year_added IS NOT NULL
AND release_year IS NOT NULL
AND (year_added - release_year) >= 0
ORDER BY years_to_platform ASC;

-- ============================================

-- QUERY 2: Summary Level
WITH freshness_table AS (
    SELECT
        CASE
            WHEN (year_added - release_year) = 0  THEN 'Same Year Release'
            WHEN (year_added - release_year) <= 2  THEN 'Fresh Content'
            WHEN (year_added - release_year) <= 5  THEN 'Mid Age Content'
            WHEN (year_added - release_year) <= 10 THEN 'Old Content'
            ELSE                                        'Vintage Catalog'
        END AS content_freshness
    FROM netflix_cleaned
    WHERE year_added IS NOT NULL
    AND release_year IS NOT NULL
    AND (year_added - release_year) >= 0
)
SELECT
    content_freshness,
    COUNT(*)                                    AS total_titles,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*))
    OVER(), 2)                                  AS percentage
FROM freshness_table
GROUP BY content_freshness
ORDER BY total_titles DESC;

-- ============================================
-- KEY INSIGHT:
-- 63% of Netflix content arrives within 2 years
-- of original release confirming premium acquisition
-- strategy. Only 13.72% is vintage content —
-- disproving the cheap catalog assumption
-- ============================================
