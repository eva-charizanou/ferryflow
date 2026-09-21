with bookings as (
    select * from {{ ref('stg_bookings') }}
),

payments as (
    select
        booking_id,
        count(*)              as payment_count,
        max(payment_status)   as payment_status,
        max(payment_method)   as payment_method,
        sum(amount_eur)       as paid_amount_eur
    from {{ ref('stg_payments') }}
    group by booking_id
)

select
    b.booking_id,
    b.search_id,
    b.route_id,
    b.operator_id,
    b.customer_id,
    cast(b.booking_ts as date)              as booking_date,   -- join key για dim_date

    -- timestamps
    b.booking_ts,
    b.travel_date,

    -- measures
    b.amount_eur,
    b.amount_cents,
    b.booking_status,
    (b.booking_status = 'confirmed')        as is_confirmed,

    -- recognized revenue: ΜΟΝΟ τα confirmed μετράνε ως έσοδο
    case when b.booking_status = 'confirmed'
         then b.amount_eur else 0 end       as revenue_eur,

    -- payment info
    coalesce(p.payment_count, 0)            as payment_count,
    (coalesce(p.payment_count, 0) > 0)      as has_payment,
    p.payment_status,
    p.payment_method

from bookings b
left join payments p on b.booking_id = p.booking_id