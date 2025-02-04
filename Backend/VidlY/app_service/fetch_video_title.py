import requests

def fetch_video_title(video_id, api_key):
    """
    Fetch the title of a YouTube video using the YouTube API.
    
    Args:
        video_id (str): The ID of the YouTube video.
        api_key (str): Your YouTube Data API key.
    
    Returns:
        str: The title of the video, or None if an error occurs.
    """
    video_url = "https://www.googleapis.com/youtube/v3/videos"
    
    try:
        # Parameters for the API request
        params = {
            "part": "snippet",  # Request the snippet part to get the title
            "id": video_id,     # Specify the video ID
            "key": api_key      # Provide the API key
        }
        
        # Make the API request
        response = requests.get(video_url, params=params)
        response.raise_for_status()  # Raise an error for bad HTTP status codes
        
        # Parse the response JSON
        data = response.json()
        
        # Extract the video title from the response
        if data.get("items"):
            video_title = data["items"][0]["snippet"]["title"]
            return video_title
        else:
            print(f"No video found with ID: {video_id}")
            return None
    
    except requests.exceptions.RequestException as e:
        # Handle any errors that occur during the request
        print(f"Error fetching video title: {e}")
        return None

# Example usage
video_id = "YOUR_VIDEO_ID"
api_key = "YOUR_API_KEY"
title = fetch_video_title(video_id, api_key)

if title:
    print(f"Video Title: {title}")
else:
    print("Failed to fetch video title.")