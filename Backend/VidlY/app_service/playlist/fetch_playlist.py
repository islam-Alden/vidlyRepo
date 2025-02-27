import requests



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


def fetch_videos_from_playlist(playlist_id, api_key):
    """Fetches videos from a selected playlist."""
    params = {
        "part": "snippet",
        "playlistId": playlist_id,
        "maxResults": 50,
        "key": api_key
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
