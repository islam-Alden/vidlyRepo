
from app_db.database import get_db_connection


def create_videos_table():

    create_table_query = """
    CREATE TABLE IF NOT EXISTS videos (
        video_id VARCHAR(20) PRIMARY KEY,
        title TEXT NOT NULL,
        channel TEXT,
        thumbnail TEXT,
        publish_date DATE,
        duration TEXT,
        video_link TEXT
    );
    """

    conn = get_db_connection()
    cursor = conn.cursor()
    
    try:
        cursor.execute(create_table_query)
        conn.commit()
        print("Table created successfully")
    except Exception as e:
        conn.rollback()
        print("Error creating table", e)
    finally:
        cursor.close()
        conn.close()



