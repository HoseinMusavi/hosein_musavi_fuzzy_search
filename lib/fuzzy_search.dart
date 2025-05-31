import 'dart:math';

int levenshteinDistance(String s1, String s2) {
  int m = s1.length;
  int n = s2.length;
  List<List<int>> dp = List.generate(m + 1, (_) => List<int>.filled(n + 1, 0));

  for (int i = 0; i <= m; i++) {
    dp[i][0] = i;
  }
  for (int j = 0; j <= n; j++) {
    dp[0][j] = j;
  }

  for (int i = 1; i <= m; i++) {
    for (int j = 1; j <= n; j++) {
      if (s1[i - 1] == s2[j - 1]) {
        dp[i][j] = dp[i - 1][j - 1];
      } else {
        dp[i][j] = 1 + min(dp[i - 1][j], min(dp[i][j - 1], dp[i - 1][j - 1]));
      }
    }
  }
  return dp[m][n];
}

double fuzzyMembership(int distance, int maxDistance) {
  if (distance == 0) return 1.0;
  if (distance > maxDistance) return 0.0;
  return 1 - (distance / maxDistance);
}

class FuzzySearchResult {
  final String value;
  final double membership;
  FuzzySearchResult(this.value, this.membership);
}

List<FuzzySearchResult> fuzzySearch(
    String query, List<String> items, int maxDistance) {
  List<FuzzySearchResult> results = [];
  for (String item in items) {
    int distance = levenshteinDistance(query, item);
    double membership = fuzzyMembership(distance, maxDistance);
    if (membership > 0.5) {
      results.add(FuzzySearchResult(item, membership));
    }
  }
  return results;
}
