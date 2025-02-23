import datetime

from app_db.database import get_db_connection

def insert_video_data(video_data):

    insert_query = """
    INSERT INTO videos (video_id, title, channel, thumbnail, publish_date, duration, video_link)
    VALUES (%s, %s, %s, %s, %s, %s, %s)
    ON CONFLICT (video_id) DO NOTHING;
    """

    conn = get_db_connection()
    cursor = conn.cursor()

    try:
        for video in video_data:

            publish_date = datetime.datetime.strptime(video["publish_date"], "%d %m %Y").date()
                        # Prepare the data tuple.
            data_tuple = (
                video["video_id"],
                video["title"],
                video["channel"],
                video["thumbnail"],
                publish_date,
                video["duration"],   # duration stored as text
                video["video_link"]
            )
            cursor.execute(insert_query, data_tuple)
        conn.commit()
        print("Data inserted successfully")

    except Exception as e:
        conn.rollback()
        print("Error creating table", e)
    finally:
        cursor.close()
        conn.close()

