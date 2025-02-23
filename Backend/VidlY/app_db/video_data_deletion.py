from app_db.database import get_db_connection


def delete_favorite_video(video_id):
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

# # Example usage:
# if __name__ == '__main__':
#     # Replace with the ID of the video you want to delete
#     delete_video("5W1ifBIY0nw")
