with source as (
    select * from {{ source('raw', 'operators') }}
)

select
    operator_id,
    operator_name,
    country as operator_country,
    founded_year
from source