from typing import List
from fastapi import FastAPI, HTTPException
from fastapi import APIRouter
import requests

from app_config.youtube_token_manger import load_api_key
from app_models.comments_models import FetchCommentsRequest
from app_service.comments.count_classified_comments import count_comments_classification
from app_service.comments.fetch_commets import fetch_comments


from fastapi import APIRouter, HTTPException

from app_service.fetch_video_title import fetch_video_title
from app_utils.youtube_utils import extract_video_id


router = APIRouter(prefix="/comments")


@router.post("/fetch")
def fetch_and_analyze_comments(request: FetchCommentsRequest):
    """
    This endpoint fetches comments for a given YouTube video URL, analyzes them for sentiment,
    classifies them into positive, neutral, or negative categories, and returns the results.

    Arguments:
        request (FetchCommentsRequest): The request object containing the YouTube URL for the video.

    Returns:
        dict: A dictionary containing the video ID, number of fetched comments, classification counts, 
              and the comments themselves.
    """
    # Load the API key from a secure location (e.g., environment variables or a config file)
    api_key = load_api_key()
    
    try:
        # Convert the URL to a string and extract the video ID from the provided URL
        url = str(request.url)
        video_id = extract_video_id(url)

        # Fetch the comments from YouTube using the video ID and API key
        comments = fetch_comments(video_id, api_key)
        video_title = fetch_video_title(video_id, api_key)
        # Analyze and classify the fetched comments (e.g., positive, negative, neutral)
        classification_counts = count_comments_classification(comments)

        # Return the results including the video ID, the number of fetched comments,
        # the classification counts (positive, negative, neutral), and the actual comments
        return {
            "video_id": video_id,  # Video ID extracted from the URL
            "comments_fetched": len(comments),  # Total number of comments fetched
            "classification_counts": classification_counts,  # Count of each sentiment category
            "video_title": video_title 
            # "comments": comments,  # List of the actual fetched comments
        }
    
    except HTTPException as e:
        # If there is an HTTP error (e.g., invalid URL or API call), re-raise the exception
        raise e  
    
    except Exception as e:
        # If any other exception occurs (e.g., parsing error, processing error), return a 500 error
        raise HTTPException(status_code=500, detail=f"Error processing request: {str(e)}")
