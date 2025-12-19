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

location_dimension AS (
    SELECT * 
    FROM {{ ref('location_dimension') }}
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
        ROUND(CAST(latitude AS FLOAT64), 4) AS latitude,
        ROUND(CAST(longitude AS FLOAT64), 4) AS longitude,
        status,
        resolution_description
    FROM {{ ref('raw_311_complaints') }}
    WHERE latitude IS NOT NULL
      AND longitude IS NOT NULL
)

SELECT
    ad.agency_dim_id,
    ctd.complaint_type_dim_id,
    ld.location_key,
    sd.status_dim_id,
    dd_created.date_dim_id AS created_date_dim_id,
    1 AS complaint_count

FROM all_complaints ac

INNER JOIN agency_dimension ad
    USING (agency_name)

INNER JOIN complaint_type_dimension ctd
    USING (complaint_type, descriptor)

INNER JOIN location_dimension ld
    ON ac.latitude = ld.latitude
   AND ac.longitude = ld.longitude

INNER JOIN status_dimension sd
    USING (status, resolution_description)

INNER JOIN date_dimension dd_created
    ON EXTRACT(DATE FROM ac.created_date) = dd_created.full_date
