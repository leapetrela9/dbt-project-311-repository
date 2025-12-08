{{ config(materialized='table') }}

with locations as (

    select distinct
        borough,
        incident_zip      as zipcode,
        community_board,
        latitude,
        longitude
    from {{ ref('raw_311_complaints') }}
    where bbl     is not null
      and borough is not null

)

select
    row_number() over (
        order by
            borough,
            zipcode,
            community_board,
            latitude,
            longitude
    ) as location_dim_id,
    borough,
    zipcode,
    community_board,
    latitude,
    longitude
from locations
order by
    borough,
    zipcode,
    community_board,
    latitude,
    longitude
