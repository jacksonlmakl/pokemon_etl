select count(*) from {{ ref('fct_orders') }} where order_id is null
