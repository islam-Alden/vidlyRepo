
from app_db.video_data_insertion import insert_video_data
from app_models.favorite_videos_model import FavoriteVideoDeleteRequest, FavoriteVideoAddRequest
from app_db.video_data_retrieving import get_all_favorite_videos
from app_db.video_data_deletion import delete_favorite_video
from fastapi import APIRouter, HTTPException
from typing import List

router = APIRouter(prefix="/v1/videos/favorites", tags=["Videos"])


@router.get("/fetch")
def fetch_videos_endpoint():
    """
    Fetch all favorite videos stored in the system.

    Returns:
        dict: A dictionary containing:
            - "favorite_videos" (list): List of all favorite videos.
            - "total_videos" (int): Total number of favorite videos.

    Raises:
        HTTPException: If an HTTP-related error occurs.
        HTTPException (500): If an unexpected error occurs while processing the request.
    """
    try:
        favorite_videos = get_all_favorite_videos()

        return {
            "favorite_videos": favorite_videos,
            "total_videos": len(favorite_videos),
        }

    except HTTPException as e:
        # If there is an HTTP error (e.g., invalid URL or API call), re-raise the exception
        raise e  
    
    except Exception as e:
        # If any other exception occurs (e.g., parsing error, processing error), return a 500 error
        raise HTTPException(status_code=500, detail=f"Error processing request: {str(e)}")


@router.delete("/delete")
def delete_favorite_video_endpoint(request: FavoriteVideoDeleteRequest):

    """
    Delete a favorite video by its unique video ID.

    Args:
        request (FavoriteVideoDeleteRequest): 
            - video_id (str): The unique identifier of the video to be deleted.

    Returns:
        dict: A dictionary containing:
            - "message" (str): Confirmation message upon successful deletion.
            - "video_id" (str): The ID of the deleted video.

    Raises:
        HTTPException (404): If the video with the given ID is not found.
        HTTPException (500): If an unexpected error occurs during deletion.
    """

    try:
        deleted_rows = delete_favorite_video(request.video_id)
        
        if deleted_rows == 0:
            # If no rows were affected, the video was not found
            raise HTTPException(status_code=404, detail="Video not found.")
            
        
        # Return a success message
        return {"message": "Video deleted successfully.", "video_id": request.video_id}
    
    except HTTPException as e:
        # Re-raise known HTTP exceptions
        raise e
    except Exception as e:
        # Handle unexpected errors
        raise HTTPException(status_code=500, detail=str(e))

    

@router.post("/insert")
def insert_videos_endpoint(videos: List[FavoriteVideoAddRequest]):
    """
    Insert multiple favorite videos into the database.

    Args:
        videos (List[FavoriteVideoAddRequest]): 
            - A list of video objects containing details such as video_id, title, and other metadata.

    Returns:
        dict: A dictionary containing:
            - "message" (str): Confirmation message indicating successful insertion.

    Raises:
        HTTPException (500): If an unexpected error occurs during the insertion process.
    """
    try:
        # Convert each Pydantic model to a dictionary
        video_data_list = [video.dict() for video in videos]

        # Call the function to insert videos into the database
        insert_video_data(video_data_list)

        return {"message": "Data inserted successfully"}

    except Exception as e:
        # If anything goes wrong, raise an HTTPException so the client gets a proper error response
        raise HTTPException(status_code=500, detail=str(e))

