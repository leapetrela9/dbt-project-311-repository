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
        cuisine_description   
    FROM {{ ref('raw_dohmh') }} 
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
