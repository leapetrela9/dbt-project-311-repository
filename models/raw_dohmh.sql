{{
    config(
        materialized='table'
    )
}}

WITH union_dohmh AS
(
    SELECT
        camis,
        dba,
        boro,
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
        inspection_type
    FROM `theta-mile-479604-h9.nyc_food_safety_raw.dohmh_2020`
    WHERE camis != 'CAMIS'

    UNION ALL

    SELECT
        camis,
        dba,
        boro,
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
        inspection_type
    FROM `theta-mile-479604-h9.nyc_food_safety_raw.dohmh_2021`
    WHERE camis != 'CAMIS'

    UNION ALL

    SELECT
        camis,
        dba,
        boro,
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
        inspection_type
    FROM `theta-mile-479604-h9.nyc_food_safety_raw.dohmh_2022`
    WHERE camis != 'CAMIS'

    UNION ALL

    SELECT
        camis,
        dba,
        boro,
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
        inspection_type
    FROM `theta-mile-479604-h9.nyc_food_safety_raw.dohmh_2024`
    WHERE camis != 'CAMIS'

    UNION ALL

    SELECT
        camis,
        dba,
        boro,
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
        inspection_type
    FROM `theta-mile-479604-h9.nyc_food_safety_raw.dohmh_2025`
    WHERE camis != 'CAMIS'
)

SELECT
    *,
    current_timestamp() AS loaded_at
FROM union_dohmh
