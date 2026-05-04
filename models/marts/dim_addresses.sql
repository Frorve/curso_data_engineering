{{ config(materialized='table') }}

WITH src AS (
    SELECT * FROM {{ ref('stg_POSTGRE_PUBLIC__ADDRESSES') }}
)

SELECT
    address_id,
    address,
    zipcode,
    state,
    country,
    _fivetran_synced
FROM src
WHERE _fivetran_deleted IS NULL OR _fivetran_deleted = 'false'