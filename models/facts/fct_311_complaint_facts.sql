{{
    config(
        materialized='table'
    )
}}

WITH agency_dimension AS (
    SELECT * 
    FROM {{ ref('agency_dimension') }}
),

complaint_type_dimension AS (
    SELECT * 
    FROM {{ ref('complaint_type_dimension') }}
),

status_dimension AS (
    SELECT * 
    FROM {{ ref('status_dimension') }}
),

date_dimension AS (
    SELECT * 
    FROM {{ ref('date_dimension') }}
),

all_complaints AS (
    SELECT
        unique_key,
        created_date,
        agency_name,
        complaint_type,
        descriptor,

        -- ✅ TRUNC (not ROUND) so it matches restaurants
        TRUNC(CAST(latitude AS FLOAT64), 5)  AS latitude,
        TRUNC(CAST(longitude AS FLOAT64), 5) AS longitude,

        status,
        resolution_description
    FROM {{ ref('raw_311_complaints') }}
    WHERE latitude IS NOT NULL
      AND longitude IS NOT NULL
      AND CAST(latitude AS FLOAT64) != 0
      AND CAST(longitude AS FLOAT64) != 0
)

SELECT
    ad.agency_dim_id,
    ctd.complaint_type_dim_id,

    -- ✅ build the SAME key as restaurant_dimension
    TO_HEX(MD5(CONCAT(
        CAST(ac.latitude AS STRING), '|',
        CAST(ac.longitude AS STRING)
    ))) AS location_key,

    sd.status_dim_id,
    dd_created.date_dim_id AS created_date_dim_id,
    1 AS complaint_count

FROM all_complaints ac

INNER JOIN agency_dimension ad
    USING (agency_name)

INNER JOIN complaint_type_dimension ctd
    USING (complaint_type, descriptor)

INNER JOIN status_dimension sd
    USING (status, resolution_description)

INNER JOIN date_dimension dd_created
    ON EXTRACT(DATE FROM ac.created_date) = dd_created.full_date
