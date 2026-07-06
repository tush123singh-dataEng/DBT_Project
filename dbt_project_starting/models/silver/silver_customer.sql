-- silver_customers.sql
-- Transformation: dedupe, trim/standardize text fields, cast types, drop nulls on key

with source as (

    select * from {{ ref('bronze_customer') }}

),

cleaned as (

    select
        cast(customer_id as int)               as customer_id,
        trim(customer_name)                    as customer_name,
        lower(trim(email))                     as email,
        trim(phone)                             as phone,
        trim(address)                           as address,
        initcap(trim(city))                     as city,
        initcap(trim(state))                    as state,
        initcap(trim(country))                  as country,
        current_timestamp                       as _loaded_at

    from source
    where customer_id is not null

),

deduped as (

    select *,
        row_number() over (
            partition by customer_id
            order by _loaded_at desc
        ) as rn

    from cleaned

)

select
    customer_id,
    customer_name,
    email,
    phone,
    address,
    city,
    state,
    country
from deduped
where rn = 1
