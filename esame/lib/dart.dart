class Exercise {
  Exercise({
    required this.name,
    required this.score,
    required this.submittedAt,
  });

  final String name;
  final int score;
  final DateTime submittedAt;

  bool get isPassed {
    return score >= 60;
  }
}

List<Exercise> passedOnly(List<Exercise> exercises) {
  return exercises.where((exercise) => exercise.isPassed).toList();
}

double averageScore(List<Exercise> exercises) {
  if (exercises.isEmpty) {
    return 0.0;
  }
  final totalScore = exercises.fold<int>(
      0, (previousValue, exercise) => previousValue + exercise.score);
  return totalScore / exercises.length;
}


String? bestStudent(List<Exercise> exercises) {
  if (exercises.isEmpty) {
    return null;
  }

  final bestExercise = exercises.reduce(
    (a, b) => a.score > b.score ? a : b,
  );
  
  return bestExercise.name;
}