with source as (
    select * from {{ source('raw', 'routes') }}
),

renamed as (
    select
        route_id,
        origin_port,
        origin_country,
        dest_port,
        dest_country,
        distance_nm,
        region
    from source
)

select * from renamed
