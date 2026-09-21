with routes as (
    select * from {{ ref('stg_routes') }}
)

select
    route_id,
    origin_port,
    origin_country,
    dest_port,
    dest_country,
    concat(origin_port, ' → ', dest_port) as route_name,
    distance_nm,
    region
from routes