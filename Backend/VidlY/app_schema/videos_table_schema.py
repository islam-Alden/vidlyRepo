
#  **** this file should only have CREATE VIDEOS TABLE FUNCTION ****


# ================= TEMP FOR TESTING DUE TO IMPORTING ERRORS =====
import json
import psycopg2
import datetime




db_path = "/home/helen/VsPRJS/Fullstack/Mobile/vidly/config/db_config.json"

def get_db_connection():
    # Load the configuration from the JSON file
    with open(db_path, 'r') as file:
        config = json.load(file)

    # Connect to PostgreSQL using the loaded configuration
    conn = psycopg2.connect(
        dbname=config["dbname"],
        user=config["user"],
        password=config["password"],
        host=config["host"],
        port=config["port"]
    )
    return conn

# =======================================================


# def drop_table(table_name):
#     # Note: Using string formatting for table names is acceptable when you're in control of the input.
#     drop_query = f"DROP TABLE IF EXISTS {table_name} CASCADE;"

#     conn = get_db_connection()
#     cursor = conn.cursor()

#     try:
#         cursor.execute(drop_query)
#         conn.commit()
#         print(f"Table '{table_name}' dropped successfully.")
#     except Exception as e:
#         conn.rollback()
#         print("Error dropping table:", e)
#     finally:
#         cursor.close()
#         conn.close()

# # Usage
# if __name__ == '__main__':
#     drop_table('videos')




# def create_videos_table():

#     create_table_query = """
#     CREATE TABLE IF NOT EXISTS videos (
#         video_id VARCHAR(20) PRIMARY KEY,
#         title TEXT NOT NULL,
#         channel TEXT,
#         thumbnail TEXT,
#         publish_date DATE,
#         duration TEXT,
#         video_link TEXT
#     );
#     """

#     conn = get_db_connection()
#     cursor = conn.cursor()
    
#     try:
#         cursor.execute(create_table_query)
#         conn.commit()
#         print("Table created successfully")
#     except Exception as e:
#         conn.rollback()
#         print("Error creating table", e)
#     finally:
#         cursor.close()
#         conn.close()



# def show_table_structure(table_name):
#     query = """
#     SELECT column_name, data_type, character_maximum_length, is_nullable
#     FROM information_schema.columns
#     WHERE table_schema = 'public'
#       AND table_name = %s;
#     """
#     conn = get_db_connection()
#     cursor = conn.cursor()
    
#     try:
#         cursor.execute(query, (table_name,))
#         columns = cursor.fetchall()
#         for col in columns:
#             print(f"Column: {col[0]}, Data Type: {col[1]}, Max Length: {col[2]}, Nullable: {col[3]}")
#     except Exception as e:
#         print("Error fetching table structure:", e)
#     finally:
#         cursor.close()
#         conn.close()

# # Usage
# show_table_structure('videos')




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


# Example JSON data (could be loaded from a file or another source)
json_data = {
    "videos": [
        {
            "title": "Tip for Stringers - How to cut the tag of String",
            "channel": "SBM Badminton Academy",
            "thumbnail": "https://i.ytimg.com/vi/l3IWUmdG2Uk/hqdefault.jpg",
            "video_id": "l3IWUmdG2Uk",
            "publish_date": "12 07 2022",
            "duration": "0:00:20",
            "video_link": "https://www.youtube.com/watch?v=l3IWUmdG2Uk"
        },
        {
            "title": "The best string you can put on your Mathews. #mathews",
            "channel": "Mathews Archery",
            "thumbnail": "https://i.ytimg.com/vi/5W1ifBIY0nw/hqdefault.jpg",
            "video_id": "5W1ifBIY0nw",
            "publish_date": "20 09 2023",
            "duration": "0:00:18",
            "video_link": "https://www.youtube.com/watch?v=5W1ifBIY0nw"
        },
        {
            "title": "🔥 Bivol's Reaction is crazy 🔥",
            "channel": "BOXRAW",
            "thumbnail": "https://i.ytimg.com/vi/vghcLU_FctQ/hqdefault.jpg",
            "video_id": "vghcLU_FctQ",
            "publish_date": "18 02 2025",
            "duration": "0:00:25",
            "video_link": "https://www.youtube.com/watch?v=vghcLU_FctQ"
        },
        {
            "title": "Felet TJ 1000 Speed + BG65 Titanium 🔊 #badminton #yonex #bg65titanium #felet #tj1000speed",
            "channel": "Hidayatx",
            "thumbnail": "https://i.ytimg.com/vi/FlZ2vjekASM/hqdefault.jpg",
            "video_id": "FlZ2vjekASM",
            "publish_date": "12 12 2023",
            "duration": "0:00:10",
            "video_link": "https://www.youtube.com/watch?v=FlZ2vjekASM"
        }
    ]
}

def insert_data():
    # Extract the list of videos from the JSON data
    videos_list = json_data["videos"]
    insert_video_data(videos_list)






def get_all_videos():
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


def delete_video(video_id):
    # Define the parameterized DELETE query
    delete_query = """
    DELETE FROM videos
    WHERE video_id = %s;
    """
    
    conn = get_db_connection()
    cursor = conn.cursor()
    
    try:
        # Execute the query, passing the video_id as a parameter
        cursor.execute(delete_query, (video_id,))
        conn.commit()
        
        # Check how many rows were deleted
        rows_deleted = cursor.rowcount
        if rows_deleted > 0:
            print(f"Video with ID '{video_id}' deleted successfully.")
        else:
            print(f"No video found with ID '{video_id}'.")
    except Exception as e:
        conn.rollback()
        print("Error deleting data:", e)
    finally:
        cursor.close()
        conn.close()



# if __name__ == '__main__':
#     # Example usage
#     all_videos = get_all_videos()
#     for vid in all_videos:
#         print(vid)
# delete_video("l3IWUmdG2Uk")




if __name__ == '__main__':
    insert_data()