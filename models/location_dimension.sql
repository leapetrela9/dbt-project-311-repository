{{ config(materialized='table') }}

WITH from_311 AS (

    SELECT DISTINCT
        borough,
        incident_zip      AS zipcode,
        community_board,
        latitude,
        longitude
    FROM {{ ref('raw_311_complaints') }}
    WHERE borough        IS NOT NULL
      AND incident_zip   IS NOT NULL
      AND latitude       IS NOT NULL
      AND longitude      IS NOT NULL

),

from_dohmh AS (

    SELECT DISTINCT
        boro              AS borough,
        zipcode,
        community_board,
        latitude,
        longitude
    FROM {{ ref('raw_dohmh') }}
    WHERE boro           IS NOT NULL
      AND zipcode        IS NOT NULL
      AND latitude       IS NOT NULL
      AND longitude      IS NOT NULL

),

locations AS (

    SELECT DISTINCT
        borough,
        zipcode,
        community_board,
        latitude,
        longitude
    FROM from_311

    UNION DISTINCT

    SELECT
        borough,
        zipcode,
        community_board,
        latitude,
        longitude
    FROM from_dohmh
)

SELECT
    ROW_NUMBER() OVER (
        ORDER BY
            borough,
            zipcode,
            community_board,
            latitude,
            longitude
    ) AS location_dim_id,
    borough,
    zipcode,
    community_board,
    latitude,
    longitude
FROM locations
ORDER BY
    borough,
    zipcode,
    community_board,
    latitude,
    longitude
