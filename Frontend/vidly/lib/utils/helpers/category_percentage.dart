class CategoryPercentageCalculator {
  static Map<String, int> calculate(int total, int positive, int neutral, int negative) {
    if (total == 0) return {'Positive': 0, 'Neutral': 0, 'Negative': 0};
    return {
      'Positive': ((positive / total) * 100).toInt(),
      'Neutral': ((neutral / total) * 100).toInt(),
      'Negative': ((negative / total) * 100).toInt(),
    };
  }
}
