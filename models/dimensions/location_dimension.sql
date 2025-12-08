{{ config(materialized='table') }}

with from_311 as (

    select distinct
        bbl,
        borough,
        cast(incident_zip      as string) as zipcode,
        cast(community_board   as string) as community_board,
        cast(council_district  as string) as council_district,
        cast(census_tract      as string) as census_tract,
        latitude,
        longitude
    from {{ ref('raw_311_complaints') }}
    where borough      is not null
      and incident_zip is not null
      and latitude     is not null
      and longitude    is not null

),

from_dohmh as (

    select distinct
        bbl,
        boro                         as borough,
        cast(zipcode          as string) as zipcode,
        cast(community_board  as string) as community_board,
        cast(council_district as string) as council_district,
        cast(census_tract     as string) as census_tract,
        latitude,
        longitude
    from {{ ref('raw_dohmh') }}
    where boro     is not null
      and zipcode  is not null
      and latitude is not null
      and longitude is not null

),

locations as (

    select
        bbl,
        borough,
        zipcode,
        community_board,
        council_district,
        census_tract,
        latitude,
        longitude
    from from_311

    union distinct

    select
        bbl,
        borough,
        zipcode,
        community_board,
        council_district,
        census_tract,
        latitude,
        longitude
    from from_dohmh
)

select
    row_number() over (
        order by
            borough,
            zipcode,
            community_board,
            council_district,
            census_tract,
            bbl,
            latitude,
            longitude
    ) as location_dim_id,
    bbl,
    borough,
    zipcode,
    community_board,
    council_district,
    census_tract,
    latitude,
    longitude
from locations
order by
    borough,
    zipcode,
    community_board,
    council_district,
    census_tract,
    bbl,
    latitude,
    longitude
