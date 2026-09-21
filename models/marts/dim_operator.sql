with operators as (
    select * from {{ ref('stg_operators') }}
)

select
    operator_id,
    operator_name,
    operator_country,
    founded_year
from operators