# from pydantic import BaseModel, field_validator

# class FetchPlaylistVideosRequest(BaseModel):
#     selected_playlist: int 

#     # Validator to check the selected_playlist positive int
#     @field_validator('selected_playlist')
#     def validate_query(cls, v):

#         # Check if query is not empty and doesn't contain malicious characters
#         if v < 0:
#             raise ValueError("Invalid value. Only non-negative integers (0 or greater) are allowed.")
        
#         return v


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