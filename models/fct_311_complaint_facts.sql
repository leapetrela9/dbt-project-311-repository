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

-- Normalize raw complaints to match dim natural keys
all_complaints AS (
    SELECT
        unique_key,
        created_date,
        agency_name,
        complaint_type,
        descriptor,
        borough,
        incident_zip      AS zipcode,
        community_board,
        latitude,
        longitude,
        status,
        resolution_description
    FROM {{ ref('raw_311_complaints') }}
)

SELECT
    -- Optional surrogate PK if you want one:
    -- ROW_NUMBER() OVER (ORDER BY ac.unique_key) AS complaint_fact_id,

    ad.agency_dim_id,
    ctd.complaint_type_dim_id,
    ld.location_dim_id,
    sd.status_dim_id,

    dd_created.date_dim_id AS created_date_dim_id,

    1 AS complaint_count

FROM all_complaints ac

-- matches agency_dimension (agency_name only)
INNER JOIN agency_dimension ad
    USING (agency_name)

-- matches complaint_type_dimension (complaint_type, descriptor)
INNER JOIN complaint_type_dimension ctd
    USING (complaint_type, descriptor)

-- matches location_dimension (borough, zipcode, community_board, latitude, longitude)
INNER JOIN location_dimension ld
    USING (borough, zipcode, community_board, latitude, longitude)

-- matches status_dimension (status, resolution_description)
INNER JOIN status_dimension sd
    USING (status, resolution_description)

-- Date dimension (created_date only for now)
INNER JOIN date_dimension dd_created
    ON EXTRACT(DATE FROM ac.created_date) = dd_created.full_date
