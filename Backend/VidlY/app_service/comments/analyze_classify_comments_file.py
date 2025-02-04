
# Analyze and classify the sentiment of a comment
# Sentiments are categorized as Positive, Neutral, or Negative

from vaderSentiment.vaderSentiment import SentimentIntensityAnalyzer

def analyze_classify_comment(comment):
    """
    Analyzes the sentiment of a given comment and classifies it into categories:
    - Positive: compound score >= 0.05
    - Neutral: -0.05 < compound score < 0.05
    - Negative: compound score <= -0.05

    Parameters:
        comment (str): The comment to analyze.

    Returns:
        str: The sentiment category ('Positive', 'Neutral', 'Negative') or 'Invalid Comment' if the input is invalid.
    """

    # Check for empty or non-text comments
    if not comment or not isinstance(comment, str):
        return "Invalid Comment"  # Return an error message for empty or invalid comments

    # Create a Sentiment Intensity Analyzer object
    analyzer = SentimentIntensityAnalyzer()

    # Compute the sentiment scores for the comment
    sentiment_score = analyzer.polarity_scores(comment)
    compound_score = sentiment_score['compound']

    # Classify the sentiment based on the compound score
    if compound_score >= 0.05:
        return "Positive"
    elif compound_score <= -0.05:
        return "Negative"
    else:
        return "Neutral"
