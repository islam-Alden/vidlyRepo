
import isodate
from datetime import datetime

# Helper function to format ISO 8601 duration to a readable format
def format_duration(duration_str: str) -> str:
    """Converts ISO 8601 duration to a human-readable format (HH:MM:SS)"""
    return str(isodate.parse_duration(duration_str))

# Helper function to format ISO 8601 date to dd mm yyyy
def format_date(date_str: str) -> str:
    """Converts ISO 8601 date to a formatted string (dd mm yyyy)"""
    publish_date = datetime.fromisoformat(date_str[:-1])  # Remove 'Z' at the end
    return publish_date.strftime("%d %m %Y")  # Desired format: dd mm yyyy
