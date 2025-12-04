class Review {
  String title;
  String? comment;
  int rating;

  Review({
    required this.title,
    this.comment,
    required this.rating,
  }) : assert(rating >= 1 && rating <= 5, 'Rating must be between 1 and 5');

  Review copyWith({
    String? title,
    String? comment,
    int? rating,
  }) {
    return Review(
      title: title ?? this.title,
      comment: comment ?? this.comment,
      rating: rating ?? this.rating,
    );
  }
}