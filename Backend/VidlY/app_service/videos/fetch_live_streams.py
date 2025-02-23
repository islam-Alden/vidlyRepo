import isodate
import requests
from datetime import datetime, timedelta


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

import requests
from datetime import datetime, timedelta


SEARCH_URL = "https://www.googleapis.com/youtube/v3/search"
VIDEOS_URL = "https://www.googleapis.com/youtube/v3/videos"


TIME_RANGES = {
    "today": 1,
    "3_days": 3,
    "1_week": 7
}


def search_live_streams(query, eventType, time_range, api_key):
    if eventType not in ["live", "upcoming"]:
        raise ValueError("Invalid eventType. Choose from 'live' or 'upcoming'.")

    # Validate and set days ahead based on time_range
    if time_range in TIME_RANGES:
        days_ahead = TIME_RANGES[time_range]
    else:
        raise ValueError("Invalid time_range. Choose from 'today', '3_days', or '1_week'.")

    params = {
        "part": "snippet",
        "type": "video",
        "eventType": eventType,  
        "q": query,
        # "videoCategoryId": category_id,
        "maxResults": 50,
        "key": api_key
    }

    try:
        response = requests.get(SEARCH_URL, params=params)
        response.raise_for_status()
        data = response.json()

        if "error" in data:
            return {"error": data["error"]["message"]}

        if "items" not in data or not data["items"]:
            return {"message": "No live streams found."}

        video_ids = [item["id"]["videoId"] for item in data["items"]]

        # Fetch and filter upcoming streams
        if eventType == "upcoming":
            return filter_upcoming_streams(video_ids, days_ahead)
        else:
            return format_video_data(data["items"])

    except requests.exceptions.RequestException as e:
        return {"error": f"Request error: {e}"}
    except KeyError as e:
        return {"error": f"Missing key {e} in response data"}
    except Exception as e:
        return {"error": f"Unexpected error: {e}"}


def fetch_video_details(video_ids):
    """Fetches video details including scheduled start time."""
    params = {
        "part": "snippet,liveStreamingDetails",
        "id": ",".join(video_ids),
        "key": API_KEY
    }

    try:
        response = requests.get(VIDEOS_URL, params=params)
        response.raise_for_status()
        data = response.json()
        result = []
        for item in data.get("items", []):
            result.append(
            {
                "title": item["snippet"]["title"],
                "channel": item["snippet"]["channelTitle"],
                "thumbnail": item["snippet"]["thumbnails"]["high"]["url"],
                "video_id": item["id"],
                "scheduled_start":item["liveStreamingDetails"]["scheduledStartTime"],
                "live_link": f"https://www.youtube.com/watch?v={item['id']}"
            }
            

            )

        return result
    except requests.exceptions.RequestException:
        return []


def filter_upcoming_streams(video_ids, days_ahead):
    """Filters upcoming streams based on scheduled start time."""
    videos = fetch_video_details(video_ids)

    now = datetime.utcnow()
    max_future_time = now + timedelta(days=days_ahead)

    filtered_streams = [
        video for video in videos 
        if video["scheduled_start"] and now <= datetime.strptime(video["scheduled_start"], "%Y-%m-%dT%H:%M:%SZ") <= max_future_time
    ]

    return filtered_streams if filtered_streams else {"message": "No upcoming live streams within the selected range."}


def format_video_data(items):
    """Formats live/completed video data."""
    return [
        {
            "title": item["snippet"]["title"],
            "channel": item["snippet"]["channelTitle"],
            "thumbnail": item["snippet"]["thumbnails"]["high"]["url"],
            "video_id": item["id"]["videoId"],
            "live_link": f"https://www.youtube.com/watch?v={item['id']['videoId']}"
        }
        for item in items
    ]




# Test the function
# results = search_live_streams(SEARCH_QUERY,eventType="upcoming", category_id=category,)
# print(results)
# # for video in results:
# #     print(f'{video} ======== \n')

# ucoming = search_live_streams("tech", eventType="upcoming", time_range="today")

# print(ucoming)