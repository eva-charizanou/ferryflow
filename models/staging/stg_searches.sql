with source as (
    select * from {{ source('raw', 'searches') }}
)

select
    search_id,
    route_id,
    search_ts,
    cast(search_ts as date) as search_date,
    passengers,
    with_vehicle,
    lower(device)           as device,
    nullif(customer_id, '') as customer_id
from source