
from pydantic import BaseModel, field_validator


class FetchPlaylistVideosRequest(BaseModel):
    playlist_id: str  

    @field_validator('playlist_id')
    def validate_playlist_id(cls, v):
        if not v.strip():
            raise ValueError("Playlist ID cannot be empty")
        
        if len(v) < 6:  # Minimum length check for YouTube playlist IDs
            raise ValueError("Invalid playlist ID format")
        
        return v