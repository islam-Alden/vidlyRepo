import requests

BASE_URL = "http://127.0.0.1:8000/videos"  # Update with your server URL



def test_playlist_flow():
    # Step 1: Search for playlists
    search_term = input("Enter search term for playlists: ")
    
    try:
        playlists_response = requests.post(
            f"{BASE_URL}/fetch_playlists",
            json={"query": search_term}
        )
        playlists_response.raise_for_status()
        playlists = playlists_response.json().get("playlists", [])
        
        if not playlists:
            print("No playlists found.")
            return
            
    except Exception as e:
        print(f"Playlist fetch error: {str(e)}")
        return

    print("\nFound Playlists:")
    for idx, playlist in enumerate(playlists, 1):
        print(f"{idx}. {playlist['title']} [ID: {playlist['playlist_id']}]")

    try:
        selection = int(input("\nEnter playlist number: "))
        selected_playlist = playlists[selection-1]
    except (ValueError, IndexError):
        print("Invalid selection")
        return

    try:
        videos_response = requests.post(
            f"{BASE_URL}/fetch_playlist_videos",
            json={"playlist_id": selected_playlist["playlist_id"]}        )
        videos_response.raise_for_status()
        videos = videos_response.json().get("videos", [])
        
        if not videos:
            print("No videos found.")
            return
            
    except Exception as e:
        print(f"Video fetch error: {str(e)}")
        print(f"API response: {videos_response.text}")  # Debug info
        return

    print(f"\nVideos in '{selected_playlist['title']}':")
    for idx, video in enumerate(videos, 1):
        print(f"{idx}. {video.get('title', 'No title')}")
        print(f"   URL: {video.get('url', 'No URL')}")
        print(f"   Published: {video.get('published_at', 'Unknown date')}")
        print(f"   Duration: {video.get('duration', 'Unknown duration')}\n")

if __name__ == "__main__":
    test_playlist_flow()