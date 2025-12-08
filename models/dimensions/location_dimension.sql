{{ config(materialized='table') }}

-- ===========================================
-- 1. Extract location fields from 311 dataset
-- ===========================================
WITH from_311 AS (

    SELECT DISTINCT
        borough,
        incident_zip AS zipcode,
        CAST(community_board AS STRING) AS community_board,
        latitude,
        longitude
    FROM {{ ref('raw_311_complaints') }}
    WHERE borough IS NOT NULL
      AND incident_zip IS NOT NULL
      AND latitude IS NOT NULL
      AND longitude IS NOT NULL
),

-- ===========================================
-- 2. Extract location fields from DOHMH dataset
-- ===========================================
from_dohmh AS (

    SELECT DISTINCT
        boro AS borough,
        zipcode,
        CAST(NULL AS STRING) AS community_board,   -- ensure same type
        latitude,
        longitude
    FROM {{ ref('raw_dohmh') }}
    WHERE boro IS NOT NULL
      AND zipcode IS NOT NULL
      AND latitude IS NOT NULL
      AND longitude IS NOT NULL
),

-- ===========================================
-- 3. UNION the datasets into a shared location set
-- ===========================================
locations AS (

    SELECT DISTINCT
        borough,
        zipcode,
        community_board,
        latitude,
        longitude
    FROM from_311

    UNION DISTINCT

    SELECT DISTINCT
        borough,
        zipcode,
        community_board,
        latitude,
        longitude
    FROM from_dohmh
)

-- ===========================================
-- 4. Generate Location Dimension with PK
-- ===========================================
SELECT
    ROW_NUMBER() OVER(
        ORDER BY borough, zipcode, community_board, latitude, longitude
    ) AS location_dim_id,
    borough,
    zipcode,
    community_board,
    latitude,
    longitude
FROM locations
ORDER BY borough, zipcode, community_board, latitude, longitude
