{{ config(materialized='table') }}

with actions as (

    select distinct
        action
    from {{ ref('raw_dohmh') }} 
    where action is not null

)

select
    row_number() over (order by action) as action_dim_id,
    action,

    --we categorized the violations
    case
        when lower(action) like '%no violations%' then 'No Violations'
        when lower(action) like '%violations%' then 'Violations Cited'
        when lower(action) like '%closed%' and lower(action) not like '%re-opened%' then 'Closed'
        when lower(action) like '%re-closed%' then 'Re-Closed'
        when lower(action) like '%re-opened%' then 'Re-Opened'
        else 'Other'
    end as action_category

from actions
