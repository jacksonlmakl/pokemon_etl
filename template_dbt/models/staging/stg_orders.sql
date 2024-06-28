with orders as (
    select
        order_id,
        customer_id,
        order_date,
        status
    from {{ source('ecommerce', 'orders') }}
)

select * from orders
