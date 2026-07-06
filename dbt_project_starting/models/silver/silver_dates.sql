-- silver_dates.sql
-- Transformation: cast date, derive standard calendar attributes

with source as (

    select * from {{ ref('bronze_date') }}

),

cleaned as (

    select
        cast(date_id as int)                as date_id,
        cast(date as date)                  as date,
        extract(day from cast(date as date))    as day,
        extract(month from cast(date as date))  as month,
        extract(quarter from cast(date as date)) as quarter,
        extract(year from cast(date as date))    as year,
        to_char(cast(date as date), 'Day')  as day_name,
        to_char(cast(date as date), 'Month') as month_name

    from source
    where date_id is not null

)

select * from cleaned
