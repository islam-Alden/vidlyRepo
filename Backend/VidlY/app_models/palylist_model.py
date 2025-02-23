from pydantic import BaseModel, field_validator
from typing import List, Optional
import re

class FetchPlaylistRequest(BaseModel):
    query: str

    # Validator to check the query string
    @field_validator('query')
    def validate_query(cls, v):
        # Check if query is not empty and doesn't contain malicious characters
        if not v.strip():
            raise ValueError("Query cannot be empty")
        
        # Optional: Ensure the query only contains alphanumeric and space characters
        if not re.match(r'^[a-zA-Z0-9\s]*$', v):
            raise ValueError("Query can only contain alphanumeric characters and spaces.")
        
        return v
