
# Analyze and classify the sentiment of a comment
# Sentiments are categorized as Positive, Neutral, or Negative

from vaderSentiment.vaderSentiment import SentimentIntensityAnalyzer

# Create a global analyzer instance once
analyzer = SentimentIntensityAnalyzer()

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

    if not comment or not isinstance(comment, str):
        return "Invalid Comment"

    
    sentiment_score = analyzer.polarity_scores(comment)
    compound_score = sentiment_score['compound']

    if compound_score >= 0.05:
        return "Positive"
    elif compound_score <= -0.05:
        return "Negative"
    else:
        return "Neutral"
