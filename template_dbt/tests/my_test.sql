select count(*) from {{ ref('core_pokemon') }} where order_id is null
