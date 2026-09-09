with source as (
    select * from {{ source('raw', 'payments') }}
)

select
    payment_id,
    booking_id,
    lower(method)          as payment_method,
    lower(payment_status)  as payment_status,
    amount_cents,
    round(amount_cents / 100.0, 2) as amount_eur
from source