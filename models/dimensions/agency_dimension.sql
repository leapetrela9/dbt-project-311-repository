{{ config(materialized='table') }}

with agencies as (

    select distinct
        agency_name
    from {{ ref('raw_311_complaints') }}
    where agency_name is not null

)
select
    row_number() over (order by agency_name) as agency_dim_id,
    agency_name
from agencies