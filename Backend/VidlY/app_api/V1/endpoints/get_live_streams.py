

from app_models.live_streams_model import FetchLiveStreamsRequest
from app_service.videos.fetch_live_streams import search_live_streams
from app_config.youtube_token_manger import load_api_key
from fastapi import APIRouter, HTTPException

router = APIRouter(prefix="/v1/videos/live_streams", tags=["Videos"])


api_key = load_api_key()

@router.post("/fetch")
def fetch_live_streams_endpoint(request: FetchLiveStreamsRequest):
    """
    Fetch live streams based on the given search query and filters.

    Args:
        request (FetchLiveStreamsRequest): 
            - query (str): Search query for live streams.
            - event_type (str, optional): Type of event (e.g., "live", "upcoming").
            - upcoming_live_stream_time_range (str, optional): Time range for upcoming streams.
    
    Returns:
        dict: A dictionary containing:
            - "videos" (list): List of live stream videos matching the query.
            - "total_videos" (int): Total number of videos retrieved.

    Raises:
        HTTPException (500): If an error occurs while processing the request.
        HTTPException: If an external API error occurs.
    """
    try:
        live_streams = search_live_streams(
            request.query, request.event_type, request.upcoming_live_stream_time_range, api_key
        )

        return {
            "videos": live_streams,
            "total_videos": len(live_streams),
        }

    except HTTPException as e:
        # If there is an HTTP error (e.g., invalid URL or API call), re-raise the exception
        raise e  

    except Exception as e:
        # If any other exception occurs (e.g., parsing error, processing error), return a 500 error
        raise HTTPException(status_code=500, detail=f"Error processing request: {str(e)}")
