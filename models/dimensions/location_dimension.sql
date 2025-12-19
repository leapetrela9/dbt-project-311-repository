{{ config(materialized='table') }}

WITH from_311 AS (
    SELECT DISTINCT
        borough,
        incident_zip AS zipcode,
        CAST(community_board AS STRING) AS community_board,
        CAST(latitude AS FLOAT64) AS latitude,
        CAST(longitude AS FLOAT64) AS longitude
    FROM {{ ref('raw_311_complaints') }}
    WHERE borough IS NOT NULL
      AND incident_zip IS NOT NULL
      AND latitude IS NOT NULL
      AND longitude IS NOT NULL
),

from_dohmh AS (
    SELECT DISTINCT
        boro AS borough,
        zipcode,
        CAST(NULL AS STRING) AS community_board,
        CAST(latitude AS FLOAT64) AS latitude,
        CAST(longitude AS FLOAT64) AS longitude
    FROM {{ ref('raw_dohmh') }}
    WHERE boro IS NOT NULL
      AND zipcode IS NOT NULL
      AND latitude IS NOT NULL
      AND longitude IS NOT NULL
),

locations AS (
    SELECT DISTINCT
        borough,
        zipcode,
        community_board,
        ROUND(latitude, 4) AS latitude,      -- rounding makes matching realistic
        ROUND(longitude, 4) AS longitude
    FROM from_311

    UNION DISTINCT

    SELECT DISTINCT
        borough,
        zipcode,
        community_board,
        ROUND(latitude, 4) AS latitude,
        ROUND(longitude, 4) AS longitude
    FROM from_dohmh
)

SELECT
    -- stable surrogate key (same input location = same key every run)
    TO_HEX(MD5(CONCAT(
        COALESCE(borough, ''), '|',
        COALESCE(CAST(zipcode AS STRING), ''), '|',
        COALESCE(community_board, ''), '|',
        COALESCE(CAST(latitude AS STRING), ''), '|',
        COALESCE(CAST(longitude AS STRING), '')
    ))) AS location_key,

    borough,
    zipcode,
    community_board,
    latitude,
    longitude
FROM locations
