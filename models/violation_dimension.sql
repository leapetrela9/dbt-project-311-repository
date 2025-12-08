{{ config(materialized='table') }}

with violations as (

    select distinct
        violation_code,
        violation_description
    from {{ ref('raw_dohmh') }}
    where violation_code        is not null
      and violation_description is not null

)

select
    row_number() over (order by violation_code, violation_description) as violation_dim_id,
    violation_code,
    violation_description
from violations
order by
    violation_code,
    violation_description
