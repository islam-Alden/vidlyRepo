from pydantic import BaseModel, HttpUrl

class FetchCommentsRequest(BaseModel):
    url: HttpUrl  # Ensures the URL is valid
