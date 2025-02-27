import re
from pydantic import BaseModel,field_validator


# CREATE
class FavoriteVideoAddRequest(BaseModel):
    video_id: str
    title: str
    channel: str
    thumbnail: str
    publish_date: str  
    duration: str
    video_link: str


# DELETE
class FavoriteVideoDeleteRequest(BaseModel):
    video_id: str

    @field_validator("video_id")
    def validate_video_id(cls, value):
        # 1) Check length
        if len(value) != 11:
            raise ValueError("Video ID must be exactly 11 characters.")

        # 2) Check against a regex pattern
        pattern = r'^[A-Za-z0-9_-]+$'
        if not re.match(pattern, value):
            raise ValueError("Video ID contains invalid characters.")

        return value