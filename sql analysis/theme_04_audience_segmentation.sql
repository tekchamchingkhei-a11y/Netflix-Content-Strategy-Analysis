-- ============================================
-- THEME 4: AUDIENCE SEGMENTATION
-- Business Pillar: Audience
-- Executive Question: Is Netflix abandoning 
-- Kids/Family to chase high paying adults?
-- Techniques: CASE WHEN, CTE, COUNT(),
--             SUM() OVER(), ROUND()
-- ============================================

-- QUERY 1: Label Every Title
SELECT
    type,
    title,
    rating,
    CASE
        WHEN rating IN ('TV-Y', 'TV-Y7',
             'TV-G', 'G')           THEN 'Kids & Family'
        WHEN rating IN ('TV-PG', 'PG',
             'PG-13', 'TV-14')      THEN 'Teen & Young Adult'
        WHEN rating IN ('TV-MA',
             'R', 'NC-17')          THEN 'Adult & Premium'
        ELSE                             'Unrated'
    END AS audience_segment
FROM netflix_cleaned
WHERE rating IS NOT NULL
ORDER BY audience_segment;

-- ============================================

-- QUERY 2: Summary With CTE
WITH audience_segments AS (
    SELECT
        type,
        title,
        rating,
        CASE
            WHEN rating IN ('TV-Y', 'TV-Y7',
                 'TV-G', 'G')           THEN 'Kids & Family'
            WHEN rating IN ('TV-PG', 'PG',
                 'PG-13', 'TV-14')      THEN 'Teen & Young Adult'
            WHEN rating IN ('TV-MA',
                 'R', 'NC-17')          THEN 'Adult & Premium'
            ELSE                             'Unrated'
        END AS audience_segment
    FROM netflix_cleaned
    WHERE rating IS NOT NULL
)
SELECT
    audience_segment,
    COUNT(*)                                     AS total_titles,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*))
    OVER(), 2)                                   AS percentage
FROM audience_segments
GROUP BY audience_segment
ORDER BY total_titles DESC;

-- ============================================
-- KEY INSIGHT:
-- 88.72% of Netflix content targets Adults and
-- Teenagers. Kids & Family represents only
-- 10.23% confirming Netflix deliberately
-- positions against Disney+ by focusing on
-- premium adult subscribers
-- ============================================
