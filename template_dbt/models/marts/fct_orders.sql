with stg_orders as (
    select * from {{ ref('stg_orders') }}
),

stg_customers as (
    select * from {{ ref('stg_customers') }}
)

select
    orders.order_id,
    orders.order_date,
    customers.first_name,
    customers.last_name,
    orders.status
from stg_orders as orders
join stg_customers as customers
    on orders.customer_id = customers.customer_id
