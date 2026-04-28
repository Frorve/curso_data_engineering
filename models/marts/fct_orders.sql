WITH stg_orders AS (
    SELECT * FROM {{ ref('stg_POSTGRE_PUBLIC__ORDERS') }}
),

stg_order_items AS (
    SELECT * FROM {{ ref('stg_POSTGRE_PUBLIC__ORDER_ITEMS') }}
),

order_items_agg AS (
    SELECT
        order_id,
        COUNT(DISTINCT product_id)  AS n_products,
        SUM(quantity)               AS total_qty
    FROM stg_order_items
    GROUP BY 1
)

SELECT
    o.*,
    oi.n_products,
    oi.total_qty
FROM stg_orders o
LEFT JOIN order_items_agg oi
    ON o.order_id = oi.order_id