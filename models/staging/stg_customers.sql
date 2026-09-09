with source as (
    select * from {{ source('raw', 'customers') }}
)

select
    customer_id,
    country,
    first_seen_date,
    acquisition_channel
from source