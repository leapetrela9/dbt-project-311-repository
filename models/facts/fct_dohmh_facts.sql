{{
    config(
        materialized = 'table'
    )
}}

with restaurant_dimension as (
    select *
    from {{ ref('restaurant_dimension') }}
),

violation_dimension as (
    select *
    from {{ ref('violation_dimension') }}
),

cuisine_dimension as (
    select *
    from {{ ref('cuisine_dimension') }}
),

action_dimension as (
    select *
    from {{ ref('action_dimension') }}
),

location_dimension as (
    select *
    from {{ ref('location_dimension') }}
),

date_dimension as (
    select *
    from {{ ref('date_dimension') }}
),

all_inspections as (
    select
        camis,
        dba,
        boro              as borough,
        building,
        street,
        zipcode,
        community_board,
        council_district,
        census_tract,
        latitude,
        longitude,

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
        inspection_type
    from {{ ref('raw_dohmh') }}
)

select
    rd.restaurant_dim_id,
    ld.location_dim_id,
    vd.violation_dim_id,
    cd.cuisine_dim_id,
    ad.action_dim_id,
    dd_inspection.date_dim_id as inspection_date_dim_id,

    1            as inspection_count,
    ai.score     as inspection_score,
    ai.grade     as inspection_grade,
    ai.critical_flag,
    ai.inspection_type

from all_inspections ai

join restaurant_dimension rd
  using (camis)

join location_dimension ld
  using (
      borough,
      zipcode,
      community_board,
      latitude,
      longitude
  )

join violation_dimension vd
  using (violation_code, violation_description)

join cuisine_dimension cd
  using (cuisine_description)

join action_dimension ad
  using (action)

join date_dimension dd_inspection
  on extract(date from ai.inspection_date) = dd_inspection.full_date
