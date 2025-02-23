from pydantic import BaseModel, field_validator
from typing import List, Optional
import re

class FetchLiveStreamsRequest(BaseModel):
    query: str
    upcoming_live_stream_time_range : str = "today"
    event_type: str = "live"


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


    # Validator to check time range is valid
    @field_validator('upcoming_live_stream_time_range')
    def validate_time_range(cls, v):
        if v not in ["today", "3_days", "1_week"]:
            raise ValueError("Invalid time range. Choose from 'today', '3_days;, '1_week'.")

        return v



    # Validator to check the event type string
    @field_validator("event_type", mode="before")
    def validate_event_type(cls, v: str) -> str:
        if not isinstance(v, str) or not v.strip():
            raise ValueError("Event type cannot be empty.")

        # Only allow "live" or "upcoming"
        if v not in ["live", "upcoming"]:
            raise ValueError("Invalid eventType. Choose from 'live' or 'upcoming'.")
        
        return v  # Return the validated value
