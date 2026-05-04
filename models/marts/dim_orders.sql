{{ config(materialized='table') }}

WITH orders AS (
    SELECT * FROM {{ ref('stg_POSTGRE_PUBLIC__ORDERS') }}
),

order_items AS (
    SELECT
        order_id,
        COUNT(DISTINCT product_id) AS n_products,
        SUM(quantity)              AS total_qty
    FROM {{ ref('stg_POSTGRE_PUBLIC__ORDER_ITEMS') }}
    GROUP BY 1
)

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
    o.tracking_id,
    o.created_at,
    o.estimated_delivery_at,
    o.delivered_at,
    oi.n_products,
    oi.total_qty,
    o._fivetran_synced
FROM orders o
LEFT JOIN order_items oi ON o.order_id = oi.order_id
WHERE o._fivetran_deleted IS NULL OR o._fivetran_deleted = 'false'