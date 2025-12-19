{{
    config(
        materialized='table'
    )
}}

WITH restaurants AS (
    SELECT DISTINCT
        camis,
        dba,
        boro,
        building,
        street,
        zipcode,
        cuisine_description,

        -- ✅ TRUNC to match complaint facts
        TRUNC(CAST(latitude AS FLOAT64), 5)  AS latitude,
        TRUNC(CAST(longitude AS FLOAT64), 5) AS longitude

    FROM {{ ref('raw_dohmh') }}
    WHERE camis IS NOT NULL
      AND latitude IS NOT NULL
      AND longitude IS NOT NULL
      AND CAST(latitude AS FLOAT64) != 0
      AND CAST(longitude AS FLOAT64) != 0
)

SELECT
    ROW_NUMBER() OVER (ORDER BY camis, dba) AS restaurant_dim_id,
    camis,
    dba                 AS restaurant_name,
    boro,
    building,
    street,
    zipcode,
    cuisine_description AS cuisine,

    latitude,
    longitude,

    -- ✅ exact same key logic as complaint facts
    TO_HEX(MD5(CONCAT(
        CAST(latitude AS STRING), '|',
        CAST(longitude AS STRING)
    ))) AS location_key

FROM restaurants
ORDER BY camis, restaurant_name
