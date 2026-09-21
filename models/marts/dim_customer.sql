with customers as (
    select * from {{ ref('stg_customers') }}
)

select
    customer_id,
    country,
    first_seen_date,
    acquisition_channel
from customers