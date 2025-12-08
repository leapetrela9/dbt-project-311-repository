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
        phone,
        cuisine_description   -- change to `cuisine` if that's your column name
    FROM {{ ref('raw_dohmh') }}   -- or whatever your DOHMH raw model is named
    WHERE camis IS NOT NULL
)

SELECT
    ROW_NUMBER() OVER (ORDER BY camis, dba) AS restaurant_dim_id,
    camis,
    dba                 AS restaurant_name,
    boro,
    building,
    street,
    zipcode,
    phone,
    cuisine_description AS cuisine
FROM restaurants
ORDER BY camis, restaurant_name
