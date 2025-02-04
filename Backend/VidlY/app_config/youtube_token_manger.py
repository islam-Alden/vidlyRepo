# load the API key form the system

import json
import os

TOKEN_FILE_PATH = "/home/helen/VsPRJS/Fullstack/Mobile/vidly/config/youtube_token.json"

def load_api_key():
    """Load the API key from the configuration file."""
    try:
        if not os.path.exists(TOKEN_FILE_PATH):
            raise FileNotFoundError(f"Token file not found: {TOKEN_FILE_PATH}")

        with open(TOKEN_FILE_PATH, 'r') as config_file:
            data = json.load(config_file)
            if 'API_KEY' not in data:
                raise KeyError("'API_KEY' not found in the token file")
            return data['API_KEY']
    except FileNotFoundError as fnf_error:
        print(f"File Error: {fnf_error}")
    except KeyError as key_error:
        print(f"Key Error: {key_error}")
    except json.JSONDecodeError as json_error:
        print(f"JSON Error: {json_error}")
    except Exception as e:
        print(f"An unexpected error occurred: {e}")
    return None


# # Example usage
# api_key = load_api_key()
# if api_key:
#     print(f"API Key: {api_key}")
# else:
#     print("Failed to load API Key.")