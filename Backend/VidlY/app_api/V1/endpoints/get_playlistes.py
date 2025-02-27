

from fastapi import APIRouter, HTTPException
from app_models.palylist_model import FetchPlaylistRequest
from app_models.palylist_videos_model import FetchPlaylistVideosRequest
from app_service.playlist.fetch_playlist import fetch_playlists, fetch_videos_from_playlist
from app_config.youtube_token_manger import load_api_key


router = APIRouter(prefix="/v1/playlists", tags=["Playlists"])
api_key = load_api_key()

@router.post("/fetch_playlists")
def fetch_playlists_endpoint(request: FetchPlaylistRequest):
    """
    Fetch playlists based on the given search query.

    Args:
        request (FetchPlaylistRequest): 
            - query (str): Search query for finding playlists.

    Returns:
        dict: A dictionary containing:
            - "playlists" (list): List of playlists matching the search query.

    Raises:
        HTTPException (404): If no playlists are found.
        HTTPException (500): If an unexpected error occurs.
    """
    try:
        playlists = fetch_playlists(request.query, api_key)
        if not playlists:
            raise HTTPException(status_code=404, detail="No playlists found")
        return {"playlists": playlists}  

    except HTTPException as e:
        raise e  # Re-raise known HTTP exceptions

    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error processing request: {str(e)}")




@router.post("/fetch_playlist_videos")
def fetch_playlist_videos(request: FetchPlaylistVideosRequest):
    """
    Fetch videos from a specific playlist.

    Args:
        request (FetchPlaylistVideosRequest): 
            - playlist_id (str): The unique identifier of the playlist.

    Returns:
        dict: A dictionary containing:
            - "playlist_videos" (list): List of videos in the specified playlist.

    Raises:
        HTTPException (500): If an unexpected error occurs while fetching playlist videos.
    """
    try:
        playlist_videos = fetch_videos_from_playlist(request.playlist_id, api_key)
        return {"playlist_videos": playlist_videos}

    except HTTPException as e:
        raise e  # Re-raise known HTTP exceptions
    
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
