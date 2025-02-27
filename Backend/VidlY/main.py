from fastapi import FastAPI
from app_api.V1.endpoints.get_comments import router as comments_router
from app_api.V1.endpoints.get_videos import router as normal_videos_router
from app_api.V1.endpoints.get_live_streams import router as live_stream_router
from app_api.V1.endpoints.get_playlistes import router as playlists_router
from app_api.V1.endpoints.favorite_videos_endpoint import router as favorite_videos_router
from app_tests.test_comments_speed import router as comments_test

from fastapi.middleware.cors import CORSMiddleware
app = FastAPI()

app.include_router(comments_router)
app.include_router(comments_test)
app.include_router(normal_videos_router)
app.include_router(live_stream_router)
app.include_router(playlists_router)
app.include_router(favorite_videos_router)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # List of allowed origins or '*' for all origins
    allow_credentials=True,
    allow_methods=["*"],  # Allows all methods (GET, POST, etc.)
    allow_headers=["*"],  # Allows all headers
)