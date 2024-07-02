import snowflake.connector
import requests
print('Connection to Snowflake')
import yaml
import os

config_file = f'{os.getcwd()}/secrets.yaml'
with open(config_file, 'r') as file:
    secrets= yaml.safe_load(file)

# Snowflake connection details
SNOWFLAKE_ACCOUNT = 'ip94038.us-east4.gcp'
SNOWFLAKE_USER = 'jacksongeorgetown'
SNOWFLAKE_PASSWORD = secrets['snowflake_pwd']

# Connect to Snowflake
conn = snowflake.connector.connect(
    user=SNOWFLAKE_USER,
    password=SNOWFLAKE_PASSWORD,
    account=SNOWFLAKE_ACCOUNT,
)

# Create or replace the table
create_table_query = """
CREATE OR REPLACE TABLE RAW.POKEMON.POKEMON (
    id INTEGER,
    name STRING,
    base_experience INTEGER,
    height INTEGER,
    weight INTEGER
)
"""

cur = conn.cursor()
cur.execute(create_table_query)
print("Pulling Data From API")
# Pull data from the Pokémon API
api_url = "https://pokeapi.co/api/v2/pokemon?limit=10"
response = requests.get(api_url)
pokemon_list = response.json()['results']

print("Inserting Data To Snowflake")
# Insert data into the Snowflake table
for pokemon in pokemon_list:
    pokemon_data = requests.get(pokemon['url']).json()
    insert_query = f"""
    INSERT INTO RAW.POKEMON.POKEMON  (id, name, base_experience, height, weight)
    VALUES ({pokemon_data['id']}, '{pokemon_data['name']}', {pokemon_data['base_experience']},
            {pokemon_data['height']}, {pokemon_data['weight']})
    """
    print(insert_query)
    cur.execute(insert_query)

# Commit and close the connection
conn.commit()
cur.close()
conn.close()

print("Data inserted successfully.")
