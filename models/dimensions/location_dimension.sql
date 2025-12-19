{{ config(materialized='table') }}

WITH from_311 AS (
    SELECT DISTINCT
        ROUND(CAST(latitude AS FLOAT64), 4) AS latitude,
        ROUND(CAST(longitude AS FLOAT64), 4) AS longitude
    FROM {{ ref('raw_311_complaints') }}
    WHERE latitude IS NOT NULL
      AND longitude IS NOT NULL
),

from_dohmh AS (
    SELECT DISTINCT
        ROUND(CAST(latitude AS FLOAT64), 4) AS latitude,
        ROUND(CAST(longitude AS FLOAT64), 4) AS longitude
    FROM {{ ref('raw_dohmh') }}
    WHERE latitude IS NOT NULL
      AND longitude IS NOT NULL
),

locations AS (
    SELECT latitude, longitude FROM from_311
    UNION DISTINCT
    SELECT latitude, longitude FROM from_dohmh
)

SELECT
    -- 
    TO_HEX(MD5(CONCAT(
        CAST(latitude AS STRING), '|',
        CAST(longitude AS STRING)
    ))) AS location_key,

    latitude,
    longitude
FROM locations