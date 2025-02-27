

from fastapi import APIRouter, HTTPException
import httpx
import asyncio
import time
import concurrent.futures
from collections import Counter
from app_config.youtube_token_manger import load_api_key
from app_utils.youtube_utils import extract_video_id
from app_service.comments.analyze_classify_comments_file import analyze_classify_comment

router = APIRouter(prefix="/v1/comments", tags=["Comments"])

async def fetch_comments_only(video_id: str, api_key: str):
    """
    Asynchronously fetches all comments for a given YouTube video ID 
    and measures the time taken.

    Args:
        video_id (str): The YouTube video ID.
        api_key (str): Your YouTube API key.

    Returns:
        tuple: (comments, elapsed_time)
            - comments (list): List of fetched comments.
            - elapsed_time (float): Time taken in seconds.
    """
    start_time = time.monotonic()
    base_url = "https://www.googleapis.com/youtube/v3/commentThreads"
    comments = []
    next_page_token = None

    async with httpx.AsyncClient() as client:
        while True:
            params = {
                "part": "snippet",
                "videoId": video_id,
                "key": api_key,
                "maxResults": 100,
                "pageToken": next_page_token,
            }
            try:
                response = await client.get(base_url, params=params)
                response.raise_for_status()
            except httpx.RequestError as e:
                raise HTTPException(status_code=500, detail=f"Error fetching comments: {e}")

            data = response.json()

            # Extract comments from the current page
            for item in data.get("items", []):
                try:
                    comment = item["snippet"]["topLevelComment"]["snippet"]["textDisplay"]
                    comments.append(comment)
                except KeyError:
                    continue

            next_page_token = data.get("nextPageToken")
            if not next_page_token:
                break

    elapsed_time = time.monotonic() - start_time
    return comments, elapsed_time

def classify_comments_batch(comments: list) -> dict:
    """
    Classify a batch of comments and return the classification counts.

    Args:
        comments (list): List of comment strings.

    Returns:
        dict: A dictionary mapping sentiment labels (e.g., 'Positive', 'Neutral', 'Negative')
              to their respective counts.
    """
    counts = Counter()
    for comment in comments:
        if isinstance(comment, str) and comment.strip():
            classification = analyze_classify_comment(comment)
            counts[classification] += 1
    return dict(counts)



@router.get("/test_classification")
async def test_classification_endpoint(video_url: str):
    """
    Endpoint to test and time the fetching and classification stages separately.

    Query Parameters:
        video_url (str): The full YouTube video URL.

    Returns:
        dict: Contains the video ID, number of comments fetched, the elapsed time for fetching,
              the elapsed time for classification, and the classification counts.
    """
    try:
        api_key = load_api_key()
        video_id = extract_video_id(video_url)
        
        # Stage 1: Fetch all comments and time the operation.
        comments, fetch_elapsed = await fetch_comments_only(video_id, api_key)
        
        # Stage 2: Classify all fetched comments and time the operation.
        classify_start = time.monotonic()
        loop = asyncio.get_running_loop()
        with concurrent.futures.ProcessPoolExecutor(max_workers=16) as executor:
            classification_counts = await loop.run_in_executor(executor, classify_comments_batch, comments)
        classify_elapsed = time.monotonic() - classify_start

        return {
            "video_id": video_id,
            "comments_fetched": len(comments),
            "fetch_elapsed_seconds": fetch_elapsed,
            "classification_elapsed_seconds": classify_elapsed,
            "classification_counts": classification_counts,
        }
    
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))







# from fastapi import APIRouter, HTTPException
# import httpx
# import asyncio
# import time
# from app_config.youtube_token_manger import load_api_key
# from app_utils.youtube_utils import extract_video_id

# router = APIRouter(prefix="/v1/comments", tags=["Comments"])

# async def fetch_comments_only(video_id: str, api_key: str):
#     """
#     Asynchronously fetches all comments for a given YouTube video ID 
#     and measures the time taken.

#     Args:
#         video_id (str): The YouTube video ID.
#         api_key (str): Your YouTube API key.

#     Returns:
#         tuple: (comments, elapsed_time)
#             - comments (list): List of fetched comments.
#             - elapsed_time (float): Time taken in seconds.
#     """
#     start_time = time.monotonic()
#     base_url = "https://www.googleapis.com/youtube/v3/commentThreads"
#     comments = []
#     next_page_token = None

#     async with httpx.AsyncClient() as client:
#         while True:
#             params = {
#                 "part": "snippet",
#                 "videoId": video_id,
#                 "key": api_key,
#                 "maxResults": 100,
#                 "pageToken": next_page_token,
#             }
#             try:
#                 response = await client.get(base_url, params=params)
#                 response.raise_for_status()
#             except httpx.RequestError as e:
#                 raise HTTPException(status_code=500, detail=f"Error fetching comments: {e}")

#             data = response.json()

#             # Extract comments from the current page
#             for item in data.get("items", []):
#                 try:
#                     comment = item["snippet"]["topLevelComment"]["snippet"]["textDisplay"]
#                     comments.append(comment)
#                 except KeyError:
#                     continue

#             next_page_token = data.get("nextPageToken")
#             if not next_page_token:
#                 break

#     elapsed_time = time.monotonic() - start_time
#     return comments, elapsed_time

# @router.get("/speed_test")
# async def test_fetch_comments_endpoint(video_url: str):
#     """
#     Endpoint for testing the performance of comment fetching.

#     Query Parameters:
#         video_url (str): The full YouTube video URL.

#     Returns:
#         dict: Contains the video ID, number of comments fetched, and the elapsed time in seconds.
#     """
#     try:
#         api_key = load_api_key()
#         video_id = extract_video_id(video_url)
#         comments, elapsed_time = await fetch_comments_only(video_id, api_key)
#         return {
#             "video_id": video_id,
#             "comments_fetched": len(comments),
#             "elapsed_time_seconds": elapsed_time,
#         }
#     except Exception as e:
#         raise HTTPException(status_code=500, detail=str(e))










# import httpx
# import asyncio
# from collections import Counter
# from fastapi import APIRouter, HTTPException
# from app_config.youtube_token_manger import load_api_key
# from app_models.comments_models import FetchCommentsRequest
# from app_service.comments.analyze_classify_comments_file import analyze_classify_comment
# from app_service.fetch_video_title import fetch_video_title
# from app_utils.youtube_utils import extract_video_id

# router = APIRouter(prefix="/v1/comments", tags=["Comments"])

# async def fetch_comments_pages(video_id: str, api_key: str):
#     """
#     Asynchronously fetch comments pages from the YouTube API for a given video ID.
#     This is implemented as an async generator that yields a list of comments for each page.
    
#     Args:
#         video_id (str): The YouTube video ID.
#         api_key (str): Your API key.
    
#     Yields:
#         list: A list of comment strings for the current page.
#     """
#     base_url = "https://www.googleapis.com/youtube/v3/commentThreads"
#     next_page_token = None

#     async with httpx.AsyncClient() as client:
#         while True:
#             params = {
#                 "part": "snippet",
#                 "videoId": video_id,
#                 "key": api_key,
#                 "maxResults": 100,
#                 "pageToken": next_page_token,
#             }
#             try:
#                 response = await client.get(base_url, params=params)
#                 response.raise_for_status()
#             except httpx.RequestError as e:
#                 print(f"Error fetching comments: {e}")
#                 break

#             data = response.json()
#             page_comments = []
#             for item in data.get("items", []):
#                 try:
#                     comment = item["snippet"]["topLevelComment"]["snippet"]["textDisplay"]
#                     page_comments.append(comment)
#                 except (KeyError, TypeError):
#                     continue

#             yield page_comments

#             next_page_token = data.get("nextPageToken")
#             if not next_page_token:
#                 break

# async def classify_comments_page(comments_page: list) -> Counter:
#     """
#     Asynchronously classify all comments in a given page and return a Counter of classifications.
    
#     Args:
#         comments_page (list): List of comment strings.
    
#     Returns:
#         Counter: A collections.Counter with counts for each classification.
#     """
#     page_counter = Counter()
#     # Offload each classification to a thread (or process pool if needed)
#     tasks = [
#         asyncio.to_thread(analyze_classify_comment, comment)
#         for comment in comments_page if isinstance(comment, str) and comment.strip()
#     ]
#     # Process all classification tasks concurrently
#     classifications = await asyncio.gather(*tasks)
#     for classification in classifications:
#         page_counter[classification] += 1
#     return page_counter

# @router.post("/speed_test")
# async def fetch_and_analyze_comments(request: FetchCommentsRequest):
#     """
#     Asynchronously fetches and analyzes YouTube video comments.
    
#     This endpoint extracts the video ID from the provided YouTube URL, then
#     streams comment pages from the YouTube API and concurrently classifies
#     each page of comments as they arrive. The classification counts are
#     aggregated and returned along with video details.
    
#     Args:
#         request (FetchCommentsRequest): The request object containing the YouTube video URL.
    
#     Returns:
#         dict: A dictionary containing:
#             - video_id (str): The extracted video ID.
#             - video_title (str): The title of the YouTube video.
#             - comments_fetched (int): The total number of comments retrieved.
#             - classification_counts (dict): Aggregated sentiment counts.
#     """
#     api_key = load_api_key()
    
#     try:
#         # Extract video ID from the URL.
#         url = str(request.url)
#         video_id = extract_video_id(url)
        
#         # Fetch the video title concurrently.
#         video_title_task = asyncio.to_thread(fetch_video_title, video_id, api_key)
        
#         total_comments = 0
#         overall_counter = Counter()
        
#         # Stream through pages of comments.
#         async for page_comments in fetch_comments_pages(video_id, api_key):
#             total_comments += len(page_comments)
#             # For each page, concurrently classify its comments.
#             page_counter = await classify_comments_page(page_comments)
#             overall_counter.update(page_counter)
        
#         # Await the video title if not already completed.
#         video_title = await video_title_task
        
#         return {
#             "video_id": video_id,
#             "comments_fetched": total_comments,
#             "classification_counts": dict(overall_counter),
#             "video_title": video_title,
#         }
    
#     except HTTPException as e:
#         raise e
#     except Exception as e:
#         raise HTTPException(status_code=500, detail=f"Error processing request: {str(e)}")
