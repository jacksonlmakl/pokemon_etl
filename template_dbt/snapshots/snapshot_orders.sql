{% snapshot snapshot_orders %}

{{
    config(
      target_schema='snapshots',
      unique_key='order_id',
      strategy='timestamp',
      updated_at='updated_at'
    )
}}

select * from {{ ref('stg_orders') }}

{% endsnapshot %}
