{{ config(materialized='table') }}

select 
    unique_key,
    created_date,
    agency_name,
    complaint_type,
    descriptor,
    location_type,
    incident_zip,
    incident_address,
    street_name,
    address_type,
    city,
    borough,
    latitude,
    longitude,
    location,
    status,
    community_board,
    open_data_channel_type,
    resolution_description,
    bbl
from `theta-mile-479604-h9.nyc_food_safety_raw.complaints_2020`

union all

select 
    unique_key,
    created_date,
    agency_name,
    complaint_type,
    descriptor,
    location_type,
    incident_zip,
    incident_address,
    street_name,
    address_type,
    city,
    borough,
    latitude,
    longitude,
    location,
    status,
    community_board,
    open_data_channel_type,
    resolution_description,
    bbl
from `theta-mile-479604-h9.nyc_food_safety_raw.complaints_2021`

union all

select 
    unique_key,
    created_date,
    agency_name,
    complaint_type,
    descriptor,
    location_type,
    incident_zip,
    incident_address,
    street_name,
    address_type,
    city,
    borough,
    latitude,
    longitude,
    location,
    status,
    community_board,
    open_data_channel_type,
    resolution_description,
    bbl
from `theta-mile-479604-h9.nyc_food_safety_raw.complaints_2022`

union all

select 
    unique_key,
    created_date,
    agency_name,
    complaint_type,
    descriptor,
    location_type,
    incident_zip,
    incident_address,
    street_name,
    address_type,
    city,
    borough,
    latitude,
    longitude,
    location,
    status,
    community_board,
    open_data_channel_type,
    resolution_description,
    bbl
from `theta-mile-479604-h9.nyc_food_safety_raw.complaints_2023`

union all

select 
    unique_key,
    created_date,
    agency_name,
    complaint_type,
    descriptor,
    location_type,
    incident_zip,
    incident_address,
    street_name,
    address_type,
    city,
    borough,
    latitude,
    longitude,
    location,
    status,
    community_board,
    open_data_channel_type,
    resolution_description,
    bbl
from `theta-mile-479604-h9.nyc_food_safety_raw.complaints_2024`

union all

select 
    unique_key,
    created_date,
    agency_name,
    complaint_type,
    descriptor,
    location_type,
    incident_zip,
    incident_address,
    street_name,
    address_type,
    city,
    borough,
    latitude,
    longitude,
    location,
    status,
    community_board,
    open_data_channel_type,
    resolution_description,
    bbl
from `theta-mile-479604-h9.nyc_food_safety_raw.complaints_2025`
