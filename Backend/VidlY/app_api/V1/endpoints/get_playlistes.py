
# from fastapi import FastAPI, HTTPException
# from fastapi import APIRouter



# from app_models.palylist_videos_model import FetchPlaylistVideosRequest
# from app_models.palylist_model import FetchPlaylistRequest

# from app_service.playlist.fetch_playlist import fetch_playlists, fetch_videos_from_playlist

# from app_config.youtube_token_manger import load_api_key

# from fastapi import APIRouter, HTTPException

# router = APIRouter(prefix="/videos")


# api_key = load_api_key()

# @router.post("/fetch_playlists")
# def fetch_playlists_endpoint(request: FetchPlaylistRequest):

#     try:
#         playlists = fetch_playlists(request.query, api_key)
        
#         if not playlists:
#             raise HTTPException(status_code=404, detail="No playlists found")
#         return {"Playlist": playlists}


#     except HTTPException as e:
#         # If there is an HTTP error (e.g., invalid URL or API call), re-raise the exception
#         raise e  
    
#     except Exception as e:
#         # If any other exception occurs (e.g., parsing error, processing error), return a 500 error
#         raise HTTPException(status_code=500, detail=f"Error processing request: {str(e)}")



# @router.post("/fetch_playlist_videos")
# def fetch_playlist_videos(request: FetchPlaylistVideosRequest):
#     try:

#         if not request.selected_playlist:
#             raise HTTPException(status_code=400, detail="Playlist not selected.")


#         playlists = fetch_playlists(FetchPlaylistRequest.query, api_key)

#         if request.selected_playlist not in playlists:
#             raise HTTPException(status_code=400, detail="Invalid playlist selection")
            

#         playlist_videos = fetch_videos_from_playlist(playlists[request.selected_playlist]["playlist_id"])
        
#         return {"Playlist found":playlists[request.selected_playlist] , "Playlist videos": playlist_videos}
        
#     except HTTPException as e:
#         raise e
#     except Exception as e:
#         raise HTTPException(status_code=500, detail=f"Error processing request: {str(e)}")


from fastapi import FastAPI, HTTPException
from fastapi import APIRouter
# from app_models.playlist_videos_model import FetchPlaylistVideosRequest  # Corrected typo in 'playlist'
# from app_models.playlist_model import FetchPlaylistRequest
from app_models.palylist_model import FetchPlaylistRequest
from app_models.palylist_videos_model import FetchPlaylistVideosRequest
from app_service.playlist.fetch_playlist import fetch_playlists, fetch_videos_from_playlist
from app_config.youtube_token_manger import load_api_key


router = APIRouter(prefix="/videos")
api_key = load_api_key()

@router.post("/fetch_playlists")
def fetch_playlists_endpoint(request: FetchPlaylistRequest):
    try:
        playlists = fetch_playlists(request.query, api_key)
        if not playlists:
            raise HTTPException(status_code=404, detail="No playlists found")
        return {"playlists": playlists}  
    except HTTPException as e:
        raise e
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error processing request: {str(e)}")



@router.post("/fetch_playlist_videos")
def fetch_playlist_videos(request: FetchPlaylistVideosRequest):
    try:
        
        playlist_videos = fetch_videos_from_playlist(request.playlist_id)
        return {"playlist_videos": playlist_videos}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))