-- models/staging/stg_pokemon.sql

-- Define staging model for Pokemon data
with pokemon as (
    select
        id,
        name,
        base_experience,
        height,
        weight
    from RAW.pokemon.pokemon
)

select * from pokemon