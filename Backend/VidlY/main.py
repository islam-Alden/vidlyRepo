from fastapi import FastAPI
from app_api.V1.endpoints.get_comments import router as comments_router
from fastapi.middleware.cors import CORSMiddleware
app = FastAPI()

app.include_router(comments_router)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # List of allowed origins or '*' for all origins
    allow_credentials=True,
    allow_methods=["*"],  # Allows all methods (GET, POST, etc.)
    allow_headers=["*"],  # Allows all headers
)