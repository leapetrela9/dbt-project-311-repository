{{ config(materialized='table') }}

WITH source AS (

    SELECT
        camis,
        dba AS restaurant_name,
        boro AS borough,
        building,
        street,
        zipcode,
        phone,
        cuisine_description,
        inspection_date,
        action,
        violation_code,
        violation_description,
        critical_flag,
        score,
        grade,
        grade_date,
        record_date,
        inspection_type,
        latitude,
        longitude
    FROM {{ ref('raw_dohmh') }}
    WHERE inspection_date IS NOT NULL

),

-- ======================================================
-- 1. Map inspection_date to Date Dimension
-- ======================================================
date_join AS (

    SELECT
        s.*,
        d.date_dim_id AS inspection_date_dim_id
    FROM source s
    LEFT JOIN {{ ref('date_dimension') }} d
        ON DATE(s.inspection_date) = d.date_value
),

-- ======================================================
-- 2. Map borough/zipcode/lat/long to Location Dimension
-- ======================================================
location_join AS (

    SELECT
        dj.*,
        ld.location_dim_id
    FROM date_join dj
    LEFT JOIN {{ ref('location_dimension') }} ld
        ON dj.borough = ld.borough
       AND dj.zipcode = ld.zipcode
       AND dj.latitude = ld.latitude
       AND dj.longitude = ld.longitude
)

-- ======================================================
-- 3. Final Fact Table
-- ======================================================
SELECT
    -- Fact PK (surrogate)
    ROW_NUMBER() OVER (ORDER BY camis, inspection_date) AS inspection_fact_id,

    -- Foreign Keys
    location_dim_id,
    inspection_date_dim_id,

    -- Natural Keys
    camis,
    restaurant_name,

    -- Measures
    score,
    CASE 
        WHEN critical_flag = 'Y' THEN 1 
        ELSE 0 
    END AS is_critical_violation,

    -- Descriptive Fields
    borough,
    building,
    street,
    zipcode,
    cuisine_description,
    action,
    violation_code,
    violation_description,
    critical_flag,
    grade,
    inspection_type,
    grade_date,
    record_date

FROM location_join;
