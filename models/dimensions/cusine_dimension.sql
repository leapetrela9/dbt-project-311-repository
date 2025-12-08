{{ config(materialized='table') }}

with cuisines as (

    select distinct
        cuisine_description
    from {{ ref('raw_dohmh') }}
    where cuisine_description is not null

)

select
    row_number() over (order by cuisine_description) as cuisine_dim_id,
    cuisine_description
from cuisines
order by cuisine_description
