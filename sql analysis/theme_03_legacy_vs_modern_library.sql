-- ============================================
-- THEME 3: LEGACY VS MODERN LIBRARY
-- Business Pillar: Content
-- Executive Question: Are we buying cheap 
-- vintage catalogs or funding new originals?
-- Techniques: CASE WHEN buckets, CTE,
--             SUM() OVER(), ROUND()
-- ============================================

-- QUERY 1: Label Every Title
SELECT
    type,
    title,
    release_year,
    CASE
        WHEN release_year < 1990                THEN 'Classic Era'
        WHEN release_year BETWEEN 1990 AND 1999 THEN 'Legacy Era'
        WHEN release_year BETWEEN 2000 AND 2009 THEN 'Transitional Era'
        WHEN release_year BETWEEN 2010 AND 2017 THEN 'Modern Era'
        ELSE                                         'Netflix Era'
    END AS library_era
FROM netflix_cleaned
WHERE release_year IS NOT NULL
ORDER BY release_year ASC;

-- ============================================

-- QUERY 2: Summary With CTE
WITH library_era AS (
    SELECT
        type,
        title,
        release_year,
        CASE
            WHEN release_year < 1990                THEN 'Classic Era'
            WHEN release_year BETWEEN 1990 AND 1999 THEN 'Legacy Era'
            WHEN release_year BETWEEN 2000 AND 2009 THEN 'Transitional Era'
            WHEN release_year BETWEEN 2010 AND 2017 THEN 'Modern Era'
            ELSE                                         'Netflix Era'
        END AS era
    FROM netflix_cleaned
    WHERE release_year IS NOT NULL
)
SELECT
    era,
    COUNT(*)                                      AS total_titles,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*))
    OVER(), 2)                                    AS percentage
FROM library_era
GROUP BY era
ORDER BY total_titles DESC;

-- ============================================
-- KEY INSIGHT:
-- 84.85% of Netflix catalog comes from 2010
-- onwards with Modern Era (42.54%) and Netflix
-- Era (42.31%) dominating. Only 5.97% is
-- Classic or Legacy content confirming Netflix
-- is a premium modern platform not a cheap
-- vintage catalog service
-- ============================================
