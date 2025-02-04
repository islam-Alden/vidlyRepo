import re

from fastapi import HTTPException


def extract_video_id(url):
    """ extract the Youtube video ID for a given URL """

    try:
        # Pattern to match YouTube URLs (including playlists)
        pattern = r'(?:youtube\.com(?:/[^/]+)?(?:\?v=|\/)([^"&?\/\s]+)|youtu\.be\/([^"&?\/\s]+))'
        match = re.search(pattern, url)
        if match:
            return match.group(1) or match.group(2)
        
    except ValueError as e:
        raise HTTPException(status_code=500, detail=f"Error processing request: {str(e)}")

    



url = "https://www.youtube.com/watch?v=lXrgaLSHucM&t=58s"
test = extract_video_id(url)
print(test)