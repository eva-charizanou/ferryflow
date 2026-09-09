with source as (
    select * from {{ source('raw', 'bookings') }}
),

deduped as (
    select *
    from source
    qualify row_number() over (
        partition by booking_id
        order by booking_ts
    ) = 1
),

renamed as (
    select
        booking_id,
        nullif(search_id, '')          as search_id,
        route_id,
        operator_id,
        customer_id,
        booking_ts,
        travel_date,
        amount_cents,
        round(amount_cents / 100.0, 2) as amount_eur,
        currency,
        lower(status)                  as booking_status
    from deduped
)

select * from renamed