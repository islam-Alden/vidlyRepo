""" this file will continue all YouTube helper functions """

import re

from fastapi import HTTPException


def extract_video_id(url):
    """ extract the Youtube video ID for a given URL """

    # Pattern to match YouTube URLs (including playlists)
    pattern = r'(?:youtube\.com(?:/[^/]+)?(?:\?v=|\/)([^"&?\/\s]+)|youtu\.be\/([^"&?\/\s]+))'
    match = re.search(pattern, url)
    if match:
        return match.group(1) or match.group(2)
    
    # if unmatched 
    raise HTTPException(status_code=400, detail="Invalid YouTube URL")

