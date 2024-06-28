with customers as (
    select
        customer_id,
        first_name,
        last_name,
        email
    from {{ source('ecommerce', 'customers') }}
)

select * from customers
