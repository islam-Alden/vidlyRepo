# Vidly

## Introduction

**Vidly** is a full-stack application that leverages the YouTube API v3 to create a feature-rich video experience. It enables users to search for videos, live streams, and playlists, analyze video comments for sentiment, and manage their favorite videos using a PostgreSQL database.

I built this app to transform my knowledge into a practical tool that benefits others.

## Overview

**Vidly** uses the YouTube API v3 to:

- **Fetch Videos:**
  -  Retrieve videos based on search queries with an option to filter by category for more accurate results.
- **Live Streams:**
  - Fetch live streams based on search queries.
  - Fetch upcoming live streams for specific time frames (today, 3 days, 7 days).
- **Playlists:**
  - Retrieve playlists based on search queries.
  - Fetch videos from a selected playlist using its ID.
- **Comments Analysis:**
  - Fetch comments for a video.
  - Analyze and classify them into positive, negative, and neutral sentiments.
- **Favorites Management:**
  - Allow users to store and delete favorite videos in a PostgreSQL database.

## Tech-Stack

**Backend:**
- FastAPI
- PostgreSQL
- YouTube API v3

**Frontend:**
- Flutter with GetX for state management

**Version Information:**
- Python: 3.12.3
- Flutter: 3.24.0
- Dart: 3.5.0
- PostgreSQL (psql): 16.6

## Installation Guide

### 1. Clone the Repository

Clone the app using the following command:
```bash
git clone https://github.com/islam-Alden/vidlyRepo.git
```
### 2. Backend Setup

Install libraries using one of the following methods:

Install from the file
  ```bash
  pip install -r requirements.txt
```
Install directly:
```bash
pip install fastapi[all] vaderSentiment psycopg2-binary httpx
```
### 3. Frontend (Flutter) Setup

Install the necessary Flutter packages by running the following commands:
```bash
flutter pub add http@1.2.2
flutter pub add get@4.6.6
flutter pub add youtube_player_iframe@2.2.2
flutter pub add d_chart@2.6.7
flutter pub add intl@0.20.1
```

## Usage
**Backend:**

From inside the `Backend/VidlY` directory(folder), start the server by running the following command:
```bash
uvicorn main:app --reload
```

Once the server is started,paste the URL below into your browser to start interacting with the app endpoints:
```bash
http://127.0.0.1:8000/docs#/.
```
 
**Frontend:**

From inside the `Frontend/vidly` directory(folder), start the web server on chrome browser by running the following commend:
```bash
flutter run -d chrome
```
## Notes

- You need to obtain your API key from google console
- You need to setup your PostgreSQL database properly, then connect it to the app
- The main focus was on the backend; the frontend was implemented primarily to visually demonstrate the app's capabilities.
- Due to the nature of the app, a login system has not been implemented.
- Additional features can be explored using the YouTube API v3, such as:
  - Search by region
  - Search for channels
  - Search for specific languages (requires additional engineering and workarounds)
  - Fetch more detailed information about videos
