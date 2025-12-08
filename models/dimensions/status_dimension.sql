{{ config(materialized='table') }}

with statuses as (

    select distinct
        status,
        resolution_description
    from {{ ref('raw_311_complaints') }}
    where status is not null

)

select
    row_number() over (order by status) as status_dim_id,
    status,
    resolution_description
from statuses
order by status
