import requests


from app_utils.formatting_utils import format_date, format_duration

# TOKEN_FILE_PATH = "/home/helen/VsPRJS/Fullstack/Mobile/vidly/config/youtube_token.json"

# def load_api_key():
#     """Load the API key from the configuration file."""
#     try:
#         if not os.path.exists(TOKEN_FILE_PATH):
#             raise FileNotFoundError(f"Token file not found: {TOKEN_FILE_PATH}")

#         with open(TOKEN_FILE_PATH, 'r') as config_file:
#             data = json.load(config_file)
#             if 'API_KEY' not in data:
#                 raise KeyError("'API_KEY' not found in the token file")
#             return data['API_KEY']
#     except FileNotFoundError as fnf_error:
#         print(f"File Error: {fnf_error}")
#     except KeyError as key_error:
#         print(f"Key Error: {key_error}")
#     except json.JSONDecodeError as json_error:
#         print(f"JSON Error: {json_error}")
#     except Exception as e:
#         print(f"An unexpected error occurred: {e}")
#     return None


# API_KEY = load_api_key()
# SEARCH_QUERY = "programming"

MAX_RESULTS = 10  # Total number of videos you want
VIDEOS_PER_PAGE = 10  # Max per request

# category_id = [27,28,10]  

# # Helper function to format ISO 8601 duration to a readable format
# def format_duration(duration_str: str) -> str:
#     """Converts ISO 8601 duration to a human-readable format (HH:MM:SS)"""
#     return str(isodate.parse_duration(duration_str))

# # Helper function to format ISO 8601 date to dd mm yyyy
# def format_date(date_str: str) -> str:
#     """Converts ISO 8601 date to a formatted string (dd mm yyyy)"""
#     publish_date = datetime.fromisoformat(date_str[:-1])  # Remove 'Z' at the end
#     return publish_date.strftime("%d %m %Y")  # Desired format: dd mm yyyy




def fetch_videos(query: str, categoryID: list, api_key):
    """a function to fetch the video from YouTub API V3
    based on the user query and filters 
    """

    search_url = "https://www.googleapis.com/youtube/v3/search"
    video_url = "https://www.googleapis.com/youtube/v3/videos"

    search_params = {
        "part": "snippet",
        "q": query,
        "type": "video",
        "maxResults": min(VIDEOS_PER_PAGE, MAX_RESULTS),
        "videoCategoryId": categoryID,  # Filter by category
        "key": api_key
    }

    videos = []
    next_page_token = None
    try:
        # Fetch video search results
        while len(videos) < MAX_RESULTS:
            if next_page_token:
                search_params["pageToken"] = next_page_token
            
            response = requests.get(search_url, params=search_params)

            if response.status_code != 200:
                print(f"Error: {response.status_code}, {response.json()}")
                break
            response_data = response.json()

            # Extract video IDs
            video_ids = [
                item["id"]["videoId"] for item in response_data.get("items", []) if "videoId" in item["id"]
            ]

            next_page_token = response_data.get("nextPageToken")

            # Fetch video details for duration & publish date
            if video_ids:
                video_params = {
                    "part": "snippet,contentDetails",
                    "id": ",".join(video_ids),
                    "key": api_key
                }
                
                video_response = requests.get(video_url, params=video_params)
                if video_response.status_code != 200:
                    print(f"Error: {video_response.status_code}, {video_response.text}")
                    break
                
                video_response_data = video_response.json()

                # Process video data
                for item in video_response_data.get("items", []):

                    # Use helper functions to format date and duration
                    formatted_duration = format_duration(item["contentDetails"]["duration"])
                    formatted_publish_date = format_date(item["snippet"]["publishedAt"])

                    videos.append({
                        "title": item["snippet"]["title"],
                        "channel": item["snippet"]["channelTitle"],
                        "thumbnail": item["snippet"]["thumbnails"]["high"]["url"],
                        "video_id": item["id"],
                        "publish_date": formatted_publish_date,
                        "duration": formatted_duration,
                        "video_link": f"https://www.youtube.com/watch?v={item['id']}"
                    })

            if not next_page_token:  # No more results
                break
        
        return videos
    except Exception as e:
        print(f"Error: {e}")
        return None

# videos = fetch_videos(SEARCH_QUERY, category_id,API_KEY)
# print(videos)