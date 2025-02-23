



import requests

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


API_KEY = load_api_key()

# The query you want to search for
query = "Gaming"

# Base URL for YouTube Data API v3
search_base_url = "https://www.googleapis.com/youtube/v3/search"
channel_base_url = "https://www.googleapis.com/youtube/v3/channels"

# Parameters for the search request
search_params = {
    "part": "snippet",          # Required, specifies the parts of the resource to fetch
    "q": query,                 # The search query (your topic)
    "type": "channel",          # Search for channels
    "key": API_KEY,             # Your API key
    "maxResults": 10            # Limit the number of results
}

# Send GET request to search for channels
search_response = requests.get(search_base_url, params=search_params)

# Check if the response is successful
if search_response.status_code == 200:
    search_data = search_response.json()
    
    for item in search_data["items"]:
        channel_id = item["snippet"]["channelId"]
        
        # Fetch detailed channel info using the channelId
        channel_params = {
            "part": "snippet",  # Required, specifies the parts to fetch
            "id": channel_id,   # Channel ID obtained from search
            "key": API_KEY      # Your API key
        }
        
        # Send GET request to fetch channel details
        channel_response = requests.get(channel_base_url, params=channel_params)
        
        if channel_response.status_code == 200:
            channel_data = channel_response.json()
            channel_info = channel_data["items"][0]["snippet"]
            
            # Prepare the data to be returned
            channel_data = {
                "channel_name": channel_info["title"],
                "channel_id": channel_id,
                "description": channel_info["description"],
                "thumbnail": channel_info["thumbnails"]["high"]["url"]
            }
            channel_url = f"https://www.youtube.com/channel/{channel_id}"
            print(f"///////////// Channel URL: {channel_url}")
            print(channel_data)
        else:
            print(f"Error fetching channel details: {channel_response.status_code}")
else:
    print(f"Error searching for channels: {search_response.status_code}")
