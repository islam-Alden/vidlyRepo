

from app_db.database import get_db_connection


def get_all_favorite_videos():
    query = """
    SELECT 
        video_id, 
        title, 
        channel, 
        thumbnail, 
        publish_date, 
        duration, 
        video_link
    FROM videos;
    """

    conn = get_db_connection()
    cursor = conn.cursor()

    try:
        cursor.execute(query)
        rows = cursor.fetchall()

        fetched_videos = []
        for row in rows:
            video = {
                "video_id": row[0],
                "title": row[1],
                "channel": row[2],
                "thumbnail": row[3],
                # Convert the date to string if needed
                "publish_date": str(row[4]) if row[4] else None,
                # Convert the duration (if interval/text) to string if needed
                "duration": str(row[5]) if row[5] else None,
                "video_link": row[6]
            }
            fetched_videos.append(video)

        return fetched_videos
    
    except Exception as e:
        print("Error retrieving data:", e)
        return []  # Return an empty list on error
    finally:
        cursor.close()
        conn.close()



# if __name__ == '__main__':
#     # Example usage
#     all_videos = get_all_videos()
#     for vid in all_videos:
#         print(vid)