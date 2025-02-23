

from app_db.video_data_insertion import insert_video_data
from app_models.favorite_videos_model import FavoriteVideoDeleteRequest, FavoriteVideoAddRequest
from app_db.video_data_retrieving import get_all_favorite_videos
from app_db.video_data_deletion import delete_favorite_video
from fastapi import APIRouter, HTTPException
from typing import List



router = APIRouter(prefix="/videos/favorite")

@router.get("/fetch")
def fetch_videos_endpoint():

    try:
        favorite_videos = get_all_favorite_videos()
        

        return{"favorite_videos": favorite_videos, "total_videos": len(favorite_videos),}


    except HTTPException as e:
        # If there is an HTTP error (e.g., invalid URL or API call), re-raise the exception
        raise e  
    
    except Exception as e:
        # If any other exception occurs (e.g., parsing error, processing error), return a 500 error
        raise HTTPException(status_code=500, detail=f"Error processing request: {str(e)}")



@router.delete("/delete")
def delete_favorite_video_endpoint(request: FavoriteVideoDeleteRequest):
    """
    Endpoint to delete a video by its video_id.
    """
    try:
        deleted_rows = delete_favorite_video(request.video_id)
        
        if deleted_rows == 0:
            # If rowcount is 0, no video matched that ID
            raise HTTPException(status_code=404, detail="Video not found.")
        
        # Return a success message
        return {"message": "Video deleted successfully.", "video_id": request.video_id}
    
    except HTTPException as e:
        # Re-raise the 404 or any custom HTTP error
        raise e
    except Exception as e:
        # For any other unexpected errors, return a 500
        raise HTTPException(status_code=500, detail=str(e))
    

@router.post("/insert")
def insert_videos_endpoint(videos: List[FavoriteVideoAddRequest]):
    """
    Insert multiple videos into the database.
    Expects a JSON array of VideoItem objects.
    """
    try:
        # Convert each Pydantic model to a dict
        video_data_list = [video.dict() for video in videos]

        # Call your existing function
        insert_video_data(video_data_list)

        return {"message": "Data inserted successfully"}

    except Exception as e:
        # If anything goes wrong, raise an HTTPException so the client gets a proper error
        raise HTTPException(status_code=500, detail=str(e))
