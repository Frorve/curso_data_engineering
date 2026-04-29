{{ config(
    materialized='incremental',
    incremental_strategy='delete+insert',
    unique_key='_row'
) }}

WITH src_budget AS (
    SELECT * FROM {{ source('GOOGLE_SHEETS', 'BUDGET') }}
)

SELECT
    _row,
    product_id,
    quantity,
    month,
    _fivetran_synced AS date_load
FROM src_budget

{% if is_incremental() %}
    WHERE _fivetran_synced > (SELECT MAX(date_load) FROM {{ this }})
{% endif %}