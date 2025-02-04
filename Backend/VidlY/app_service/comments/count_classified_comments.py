from collections import Counter
from app_service.comments.analyze_classify_comments_file import analyze_classify_comment

def count_comments_classification(comments: list):
    """
    Classify and count comments based on sentiment (Positive, Negative, Neutral).
    
    Parameters:
        comments (list): List of comments (strings) to classify and count.
    
    Returns:
        dict: A dictionary containing the counts of each sentiment classification ('Positive', 'Neutral', 'Negative').
    """
    # Initialize a Counter to hold classification counts
    classification_counts = Counter()

    # Iterate through comments
    for comment in comments:
        # Ensure the comment is a valid string (handle edge cases)
        if not isinstance(comment, str) or not comment.strip():
            continue  # Skip empty or invalid comments
        
        # Classify the comment and update the counter
        classification = analyze_classify_comment(comment)
        classification_counts[classification] += 1

    return dict(classification_counts)

