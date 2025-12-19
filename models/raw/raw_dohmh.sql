SELECT
    camis,
    dba,
    boro,
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
    latitude,
    longitude
FROM `theta-mile-479604-h9.nyc_food_safety_raw.dohmh_2020`

UNION ALL

SELECT
    camis,
    dba,
    boro,
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
    latitude,
    longitude
FROM `theta-mile-479604-h9.nyc_food_safety_raw.dohmh_2021`

UNION ALL

SELECT
    camis,
    dba,
    boro,
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
    latitude,
    longitude
FROM `theta-mile-479604-h9.nyc_food_safety_raw.dohmh_2022`

UNION ALL

SELECT
    camis,
    dba,
    boro,
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
    latitude,
    longitude
FROM `theta-mile-479604-h9.nyc_food_safety_raw.dohmh_2023`