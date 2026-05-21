-- ============================================
-- THEME 10: GENRE SATURATION & GAPS
-- Business Pillar: Content
-- Executive Question: Which genres are over
-- saturated and where are untapped gaps?
-- Techniques: CASE WHEN, LIKE, CTE,
--             COUNT(), SUM() OVER()
-- ============================================

-- QUERY 1: Label Every Title By Genre
SELECT
    title,
    listed_in,
    CASE
        WHEN listed_in LIKE '%International Movies%' THEN 'International Movies'
        WHEN listed_in LIKE '%Dramas%'               THEN 'Dramas'
        WHEN listed_in LIKE '%Comedies%'             THEN 'Comedies'
        WHEN listed_in LIKE '%Documentaries%'        THEN 'Documentaries'
        WHEN listed_in LIKE '%Action & Adventure%'   THEN 'Action & Adventure'
        WHEN listed_in LIKE '%Romantic Movies%'      THEN 'Romantic Movies'
        WHEN listed_in LIKE '%Thrillers%'            THEN 'Thrillers'
        WHEN listed_in LIKE '%Horror Movies%'        THEN 'Horror Movies'
        WHEN listed_in LIKE '%Kids TV%'              THEN 'Kids TV'
        WHEN listed_in LIKE '%Stand-Up Comedy%'      THEN 'Stand-Up Comedy'
        WHEN listed_in LIKE '%Anime%'                THEN 'Anime'
        WHEN listed_in LIKE '%Reality TV%'           THEN 'Reality TV'
        WHEN listed_in LIKE '%Crime TV%'             THEN 'Crime TV'
        WHEN listed_in LIKE '%Science & Nature%'     THEN 'Science & Nature'
        ELSE                                              'Other'
    END AS genre
FROM netflix_cleaned
WHERE listed_in IS NOT NULL
ORDER BY genre;

-- ============================================

-- QUERY 2: Summary With Saturation Label
SELECT
    CASE
        WHEN listed_in LIKE '%International Movies%' THEN 'International Movies'
        WHEN listed_in LIKE '%Dramas%'               THEN 'Dramas'
        WHEN listed_in LIKE '%Comedies%'             THEN 'Comedies'
        WHEN listed_in LIKE '%Documentaries%'        THEN 'Documentaries'
        WHEN listed_in LIKE '%Action & Adventure%'   THEN 'Action & Adventure'
        WHEN listed_in LIKE '%Romantic Movies%'      THEN 'Romantic Movies'
        WHEN listed_in LIKE '%Thrillers%'            THEN 'Thrillers'
        WHEN listed_in LIKE '%Horror Movies%'        THEN 'Horror Movies'
        WHEN listed_in LIKE '%Kids TV%'              THEN 'Kids TV'
        WHEN listed_in LIKE '%Stand-Up Comedy%'      THEN 'Stand-Up Comedy'
        WHEN listed_in LIKE '%Anime%'                THEN 'Anime'
        WHEN listed_in LIKE '%Reality TV%'           THEN 'Reality TV'
        WHEN listed_in LIKE '%Crime TV%'             THEN 'Crime TV'
        WHEN listed_in LIKE '%Science & Nature%'     THEN 'Science & Nature'
        ELSE                                              'Other'
    END AS genre,
    COUNT(*)                                        AS total_titles,
    CASE
        WHEN COUNT(*) >= 1000 THEN 'Over Saturated'
        WHEN COUNT(*) >= 300  THEN 'Competitive'
        WHEN COUNT(*) >= 100  THEN 'Opportunity Zone'
        ELSE                       'Untapped Gap'
    END                                             AS market_status
FROM netflix_cleaned
WHERE listed_in IS NOT NULL
GROUP BY genre
ORDER BY total_titles DESC;

-- ============================================
-- KEY INSIGHT:
-- International Movies, Dramas and Comedies
-- account for 63% of all titles — dangerously
-- concentrated. Biggest gaps: Horror (92),
-- Science & Nature (77) and Romantic Movies
-- with only 6 titles despite being one of
-- the most consumed genres globally
-- ============================================
