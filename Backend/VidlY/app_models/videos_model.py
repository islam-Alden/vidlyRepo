from pydantic import BaseModel, field_validator
from typing import List, Optional
import re

class FetchVideosRequest(BaseModel):
    query: str
    category_ids: Optional[List[int]] = None  


    # Validator to check the query string
    @field_validator('query')
    def validate_query(cls, v):
        # Check if query is not empty and doesn't contain malicious characters
        if not v.strip():
            raise ValueError("Query cannot be empty")
        
        # Optional: Ensure the query only contains alphanumeric and space characters
        if not re.match(r'^[a-zA-Z0-9 ]*$', v):
            raise ValueError("Query can only contain alphanumeric characters and spaces.")
        
        return v

    # Validator to check category_ids are valid
    @field_validator('category_ids')
    def validate_category_ids(cls, v):
        if not all(isinstance(id, int) and id > 0 and id  for id in v):
            raise ValueError("Each category ID should be a positive integer")
        return v

