{{ config(materialized='table') }}

WITH stg AS (
    SELECT
        o.order_id,
        o.user_id,
        o.address_id,
        o.promo_id,
        o.status,
        o.shipping_service,
        TRY_CAST(REPLACE(o.shipping_cost::STRING, ',', '.') AS NUMBER(18,2)) AS shipping_cost,
        TRY_CAST(REPLACE(o.order_cost::STRING,    ',', '.') AS NUMBER(18,2)) AS order_cost,
        TRY_CAST(REPLACE(o.order_total::STRING,   ',', '.') AS NUMBER(18,2)) AS order_total,
        o.created_at                                                         AS order_date,
        a.country                                                            AS address_country
    FROM {{ ref('dim_orders') }}          o
    INNER JOIN {{ ref('dim_addresses') }} a ON o.address_id = a.address_id
    INNER JOIN {{ ref('dim_users') }}     u ON o.user_id    = u.user_id
)

SELECT * FROM stg