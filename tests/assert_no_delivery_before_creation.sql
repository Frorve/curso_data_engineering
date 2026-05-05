SELECT
    order_id,
    created_at,
    delivered_at
FROM {{ ref('dim_orders') }}
WHERE delivered_at IS NOT NULL
  AND delivered_at < created_at