
from app_models.videos_model import FetchVideosRequest
from app_service.videos.fetch_normal_video import fetch_videos
from app_config.youtube_token_manger import load_api_key
from fastapi import APIRouter, HTTPException


router = APIRouter(prefix="/v1/videos/normal", tags=["Videos"])

api_key = load_api_key()

@router.post("/fetch")
def fetch_videos_endpoint(request: FetchVideosRequest):
    """
    Fetch videos based on the given search query and category filters.

    Args:
        request (FetchVideosRequest): 
            - query (str): Search query to find videos.
            - category_ids (list[str], optional): List of category IDs to filter videos.

    Returns:
        dict: A dictionary containing:
            - "videos" (list): List of videos matching the query and category filters.
            - "total_videos" (int): Total number of videos retrieved.

    Raises:
        HTTPException: If an HTTP-related error occurs (e.g., invalid API response).
        HTTPException (500): If an unexpected error occurs during processing.
    """
    try:
        videos = fetch_videos(request.query, request.category_ids, api_key)

        return {
            "videos": videos,
            "total_videos": len(videos),
        }

    except HTTPException as e:
        # If there is an HTTP error (e.g., invalid URL or API call), re-raise the exception
        raise e  
    
    except Exception as e:
        # If any other exception occurs (e.g., parsing error, processing error), return a 500 error
        raise HTTPException(status_code=500, detail=f"Error processing request: {str(e)}")

