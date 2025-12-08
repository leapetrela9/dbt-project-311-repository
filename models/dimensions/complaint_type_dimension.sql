{{ config(materialized='table') }}

with complaint_types as (

    select distinct
        complaint_type,
        descriptor
    from {{ ref('raw_311_complaints') }}
    where complaint_type is not null
      and descriptor    is not null

)

select
    row_number() over (order by complaint_type, descriptor) as complaint_type_dim_id,
    complaint_type,
    descriptor
from complaint_types
order by complaint_type, descriptor