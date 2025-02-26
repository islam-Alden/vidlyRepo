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

## Technology Stack

**Backend:**
- FastAPI
- PostgreSQL
- YouTube API v3

**Frontend:**
- Flutter with GetX for state management
