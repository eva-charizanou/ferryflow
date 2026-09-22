with source as (
    select * from {{ source('raw', 'payments') }}
)

select
    payment_id,
    booking_id,
    lower(method)          as payment_method,
    lower(payment_status)  as payment_status,
    amount_cents,
    {{ cents_to_euros('amount_cents') }} as amount_eur
    from source