{{ config(materialized='table') }}

WITH source AS (
    SELECT
        camis,
        dba AS restaurant_name,
        boro AS borough,
        building,
        street,
        zipcode,
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

        TRUNC(CAST(latitude AS FLOAT64), 4)  AS latitude,
        TRUNC(CAST(longitude AS FLOAT64), 4) AS longitude

    FROM {{ ref('raw_dohmh') }}
    WHERE inspection_date IS NOT NULL
      AND latitude IS NOT NULL
      AND longitude IS NOT NULL
      AND CAST(latitude AS FLOAT64) != 0
      AND CAST(longitude AS FLOAT64) != 0
),

date_join AS (
    SELECT
        s.*,
        d.date_dim_id AS inspection_date_dim_id
    FROM source s
    LEFT JOIN {{ ref('date_dimension') }} d
        ON DATE(s.inspection_date) = d.full_date
),

location_join AS (
    SELECT
        dj.*,
        ld.location_key
    FROM date_join dj
    LEFT JOIN {{ ref('location_dimension') }} ld
        ON dj.latitude  = ld.latitude
       AND dj.longitude = ld.longitude
),

restaurant_join AS (
    SELECT
        lj.*,
        rd.restaurant_dim_id
    FROM location_join lj
    LEFT JOIN {{ ref('restaurant_dimension') }} rd
        ON lj.camis = rd.camis
),

cuisine_join AS (
    SELECT
        rj.*,
        cd.cuisine_dim_id
    FROM restaurant_join rj
    LEFT JOIN {{ ref('cuisine_dimension') }} cd
        ON rj.cuisine_description = cd.cuisine_description
),

action_join AS (
    SELECT
        cj.*,
        ad.action_dim_id
    FROM cuisine_join cj
    LEFT JOIN {{ ref('action_dimension') }} ad
        ON cj.action = ad.action
),

violation_join AS (
    SELECT
        aj.*,
        vd.violation_dim_id
    FROM action_join aj
    LEFT JOIN {{ ref('violation_dimension') }} vd
        ON aj.violation_code        = vd.violation_code
       AND aj.violation_description = vd.violation_description
)

SELECT
    ROW_NUMBER() OVER (ORDER BY camis, inspection_date) AS dohmh_fact_id,
    restaurant_dim_id,
    location_key,
    cuisine_dim_id,
    action_dim_id,
    violation_dim_id,
    inspection_date_dim_id,
    camis,
    restaurant_name,
    score,
    CASE WHEN critical_flag = 'Y' THEN 1 ELSE 0 END AS is_critical_violation,
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

    -- ✅ NEW: fill missing grade based on score thresholds
    COALESCE(
        grade,
        CASE
            WHEN score BETWEEN 0 AND 13 THEN 'A'
            WHEN score BETWEEN 14 AND 27 THEN 'B'
            WHEN score >= 28 THEN 'C'
        END
    ) AS grade_final,

    inspection_type,
    grade_date,
    record_date
FROM violation_join
