import requests

def fetch_comments(video_id, api_key):
    """
    Fetch comments from the YouTube API for a given video ID.
    Returns a list of comments.
    """
    base_url = "https://www.googleapis.com/youtube/v3/commentThreads"
    comments = [] # list to store the fetched comments for future use
    next_page_token = None # initially there is no next page

    while True:
        params = {
            "part": "snippet",            # Specifies the part of the video data to retrieve
            "videoId": video_id,         # YouTube video ID to fetch comments for
            "key": api_key,              # API key from your Google Developer account
            "maxResults": 100,           # Maximum number of comments per request
            "pageToken": next_page_token # Token for fetching the next page of comments (pagination)
        }

        # Fetch comments from YouTube API
        try:
            response = requests.get(base_url, params=params)
            response.raise_for_status()  # Raise an error for HTTP-related issues

        # Handle request errors (e.g., connection issues or API errors)
        except requests.exceptions.RequestException as e:
            print(f"Error fetching comments: {e}")
            break

        # Extract comments from the API response
        data = response.json()
        for item in data.get("items", []):
            comment = item["snippet"]["topLevelComment"]["snippet"]["textDisplay"]
            comments.append(comment)

        # Check if more comments are available (pagination) and update the token
        next_page_token = data.get("nextPageToken")
        if not next_page_token:
            break

    return comments