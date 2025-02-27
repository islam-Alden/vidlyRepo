import json
import psycopg2


db_path = "/home/helen/VsPRJS/Fullstack/Mobile/vidly/config/db_config.json"

def get_db_connection():
    # Load the configuration from the JSON file
    with open(db_path, 'r') as file:
        config = json.load(file)

    # Connect to PostgreSQL using the loaded configuration
    conn = psycopg2.connect(
        dbname=config["dbname"],
        user=config["user"],
        password=config["password"],
        host=config["host"],
        port=config["port"]
    )
    return conn


# # Example usage
# if __name__ == "__main__":
#     conn = get_db_connection()
#     cur = conn.cursor()

#     # Execute a query
#     cur.execute("SELECT version()")

#     # Fetch the result
#     db_version = cur.fetchone()
#     print(f"Database version: {db_version}")

#     # Close the cursor and connection
#     cur.close()
#     conn.close()
