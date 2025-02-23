from fastapi import FastAPI, HTTPException
from fastapi import APIRouter



from app_models.videos_model import FetchVideosRequest
from app_service.videos.fetch_normal_video import fetch_videos
from app_config.youtube_token_manger import load_api_key


from fastapi import APIRouter, HTTPException

router = APIRouter(prefix="/videos")

api_key = load_api_key()

@router.post("/fetch")
def fetch_videos_endpoint(request: FetchVideosRequest):

    # category_id = [27,28,10]  
    try:
        videos = fetch_videos(request.query,request.category_ids, api_key)

        return{"videos": videos, "total_videos": len(videos),}


    except HTTPException as e:
        # If there is an HTTP error (e.g., invalid URL or API call), re-raise the exception
        raise e  
    
    except Exception as e:
        # If any other exception occurs (e.g., parsing error, processing error), return a 500 error
        raise HTTPException(status_code=500, detail=f"Error processing request: {str(e)}")
