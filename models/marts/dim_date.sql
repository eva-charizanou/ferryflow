with date_spine as (
    select day
    from unnest(generate_date_array('2025-01-01', '2026-12-31')) as day
)

select
    day                                as date_day,
    extract(year    from day)          as year,
    extract(month   from day)          as month,
    format_date('%B', day)             as month_name,
    extract(quarter from day)          as quarter,
    extract(dayofweek from day)        as day_of_week,     -- 1=Κυρ ... 7=Σαβ
    format_date('%A', day)             as day_name,
    extract(dayofweek from day) in (1, 7) as is_weekend,
    case
        when extract(month from day) in (6, 7, 8)  then 'Summer'
        when extract(month from day) in (3, 4, 5)  then 'Spring'
        when extract(month from day) in (9, 10, 11) then 'Autumn'
        else 'Winter'
    end                                as season
from date_spine