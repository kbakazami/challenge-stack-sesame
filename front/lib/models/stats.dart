class StatsData {
  final double averageScore;
  final int nbrPassage;
  final double averageTime;

  StatsData({
    required this.averageScore,
    required this.nbrPassage,
    required this.averageTime,
  });

  StatsData.fromJson(Map<String, dynamic> json)
      : averageScore = json['averageScore'],
        nbrPassage = json['nbrPassage'],
        averageTime = json['averageTime'];
}