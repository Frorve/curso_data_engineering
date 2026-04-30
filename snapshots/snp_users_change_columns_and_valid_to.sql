{% snapshot snp_users_change_colums_and_valid_to%}

{{
    config(
        target_schema='snapshots',
        unique_key='DNI',
        strategy='timestamp',
        updated_at='fecha_alta_sistema',
                    snapshot_meta_column_names={
                "dbt_valid_from": "start_date",
                "dbt_valid_to": "end_date",
                "dbt_scd_id": "scd_id",
                "dbt_updated_at": "modified_date",
                "dbt_is_deleted": "is_deleted",
            },
    )
}}

SELECT
    Nombre,
    DNI,
    email,
    fecha_alta_sistema
FROM {{ source('GOOGLE_SHEETS', 'USERS') }}

{% endsnapshot %}