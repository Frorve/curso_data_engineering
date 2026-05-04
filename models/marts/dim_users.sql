{{ config(materialized='table') }}

WITH src AS (
    SELECT * FROM {{ ref('stg_POSTGRE_PUBLIC__USER') }}
)

SELECT
    user_id,
    first_name,
    last_name,
    email,
    phone_number,
    address_id,
    CAST(total_orders AS NUMBER) AS total_orders,
    created_at,
    updated_at,
    _fivetran_synced
FROM src
WHERE _fivetran_deleted IS NULL OR _fivetran_deleted = 'false'