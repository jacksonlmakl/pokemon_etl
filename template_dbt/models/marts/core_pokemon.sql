-- models/marts/core_pokemon.sql

-- Define core model for processed Pokemon data
with stg_pokemon as (
    select * from {{ ref('stg_pokemon') }}
)

select
    id,
    name,
    base_experience,
    height,
    weight
from stg_pokemon