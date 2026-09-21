with searches as (
    select * from {{ ref('stg_searches') }}
),

bookings as (
    select * from {{ ref('fct_bookings') }}
),

routes as (
    select * from {{ ref('dim_route') }}
),

-- Ενώνουμε κάθε search με το booking του (αν έγινε), κρατώντας grain = 1 γραμμή/search
search_to_booking as (
    select
        s.search_id,
        s.route_id,
        s.search_date,
        b.booking_id,
        b.is_confirmed,
        b.revenue_eur
    from searches s
    left join bookings b on s.search_id = b.search_id
)

select
    r.region,
    date_trunc(stb.search_date, month)              as search_month,

    -- funnel metrics
    count(*)                                        as searches,
    count(stb.booking_id)                           as bookings,
    countif(stb.is_confirmed)                       as confirmed_bookings,

    -- conversion rates (σε %)
    round(count(stb.booking_id)  / count(*) * 100, 2) as search_to_booking_pct,
    round(countif(stb.is_confirmed) / count(*) * 100, 2) as search_to_confirmed_pct,

    -- revenue
    round(sum(stb.revenue_eur), 2)                  as revenue_eur,
    round(safe_divide(sum(stb.revenue_eur), countif(stb.is_confirmed)), 2) as avg_order_value_eur

from search_to_booking stb
join routes r on stb.route_id = r.route_id
group by r.region, search_month
order by r.region, search_month