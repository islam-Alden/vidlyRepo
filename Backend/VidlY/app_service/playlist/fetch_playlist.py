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


SEARCH_URL = "https://www.googleapis.com/youtube/v3/search"
PLAYLIST_ITEMS_URL = "https://www.googleapis.com/youtube/v3/playlistItems"

def fetch_playlists(query, api_key):
    """Fetches playlists based on the search query."""
    params = {
        "part": "snippet",
        "q": query,
        "type": "playlist",
        "maxResults": 50,
        "key": api_key
    }
    try:
        response = requests.get(SEARCH_URL, params=params)
        response.raise_for_status()  # Raises an HTTPError if the response is not 200 OK
        data = response.json()

        return [
            {
                "title": item["snippet"]["title"],
                "playlist_id": item["id"]["playlistId"],
                "channel": item["snippet"]["channelTitle"],
                "thumbnail": item["snippet"]["thumbnails"]["high"]["url"]
            }
            for item in data.get("items", [])
        ]

    except requests.exceptions.RequestException as e:
        print(f"Request error: {e}")
        return []
    except KeyError as e:
        print(f"Key error: Missing key {e} in response data")
        return []


def fetch_videos_from_playlist(playlist_id, max_results=10):
    """Fetches videos from a selected playlist."""
    params = {
        "part": "snippet",
        "playlistId": playlist_id,
        "maxResults": max_results,
        "key": API_KEY
    }
    response = requests.get(PLAYLIST_ITEMS_URL, params=params)
    if response.status_code != 200:
        return []

    data = response.json()
    return [
        {
            "title": item["snippet"]["title"],
            "channel": item["snippet"]["channelTitle"],
            "thumbnail": item["snippet"]["thumbnails"]["high"]["url"],
            "video_id": item["snippet"]["resourceId"]["videoId"],
            "video_link": f"https://www.youtube.com/watch?v={item['snippet']['resourceId']['videoId']}"
        }
        for item in data.get("items", [])
    ]



# # User enters query
# query = "AI"

# # Fetch playlists
# playlists = fetch_playlists(query,API_KEY)
# print("\nAvailable Playlists:")
# for idx, playlist in enumerate(playlists):
#     print(f"{idx + 1}. {playlist['title']} (ID: {playlist['playlist_id']})")
# selected_list = int(input("enter playlist number: "))
# # Simulating user selecting the first playlist
# selected_playlist_id = playlists[47]["playlist_id"]
# # print(f"\nUser selected playlist: {playlists[0]['title']} ")
# # for vid in playlists[0]['title']:
# #     print(vid, "===========")

# vides_list = fetch_videos_from_playlist(selected_playlist_id)
# print(vides_list)