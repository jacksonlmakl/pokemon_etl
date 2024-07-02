
  
    

        create or replace transient table RAW.POKEMON.core_pokemon
         as
        (-- models/marts/core_pokemon.sql

-- Define core model for processed Pokemon data
with stg_pokemon as (
    select * from RAW.POKEMON.stg_pokemon
)

select
    id,
    name,
    base_experience,
    height,
    weight
from stg_pokemon
        );
      
  