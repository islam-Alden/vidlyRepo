
import asyncio
import concurrent
import concurrent.futures
from fastapi import APIRouter, HTTPException
from app_config.youtube_token_manger import load_api_key
from app_models.comments_models import FetchCommentsRequest
from app_service.comments.count_classified_comments import count_comments_classification
from app_service.comments.fetch_commets import fetch_comments
from app_service.fetch_video_title import fetch_video_title
from app_utils.youtube_utils import extract_video_id


router = APIRouter(prefix="/v1/comments", tags=["Comments"])

api_key = load_api_key()

@router.post("/fetch")
async def fetch_and_analyze_comments(request: FetchCommentsRequest):
    """
    Fetches and analyzes YouTube video comments.

    This endpoint extracts the video ID from the provided YouTube URL, retrieves comments using 
    the YouTube API, analyzes their sentiment, and categorizes them into positive, neutral, 
    or negative classifications.

    Arguments:
        request (FetchCommentsRequest): The request object containing the YouTube video URL.

    Returns:
        dict: A dictionary containing:
            - video_id (str): The extracted video ID.
            - video_title (str): The title of the YouTube video.
            - comments_fetched (int): The number of comments retrieved.
            - classification_counts (dict): A breakdown of sentiment classifications 
              (positive, neutral, negative).
            - comments (list, optional): The list of retrieved comments (commented out for now).

    Raises:
        HTTPException: If an error occurs during processing, such as an invalid URL 
        or API request failure.
    """
 
 
    
    try:
        # Convert the URL to a string and extract the video ID from the provided URL
        url = str(request.url)
        video_id = extract_video_id(url)

        # Fetch the comments from YouTube using the video ID and API key
        comments = await fetch_comments(video_id, api_key)

        video_title = fetch_video_title(video_id, api_key)

 
        loop = asyncio.get_running_loop()
        with concurrent.futures.ProcessPoolExecutor(max_workers=16) as executor:
            classification_counts = await loop.run_in_executor(executor,count_comments_classification, comments ) 

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


