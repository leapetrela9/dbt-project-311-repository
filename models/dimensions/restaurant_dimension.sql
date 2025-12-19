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
        ROUND(CAST(latitude AS FLOAT64), 4)  AS latitude,
        ROUND(CAST(longitude AS FLOAT64), 4) AS longitude
    FROM {{ ref('raw_dohmh') }}
    WHERE camis IS NOT NULL
      AND latitude IS NOT NULL
      AND longitude IS NOT NULL
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

  
    TO_HEX(MD5(CONCAT(
        CAST(latitude AS STRING), '|',
        CAST(longitude AS STRING)
    ))) AS location_key

FROM restaurants
ORDER BY camis, restaurant_name
