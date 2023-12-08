import 'dart:convert';

class Review{
  final int? id;
  final int? id_user, id_news;
  final String? review;

  Review({this.id, this.id_user, this.id_news, this.review});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'id_user': id_user,
      'id_news': id_news,
      'review': review,
    };
  }

  Review.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        id_user = map['id_user'],
        id_news = map['id_news'],
        review = map['review'];

  factory Review.fromRawJson(String str) => Review.fromJson(json.decode(str));

  factory Review.fromJson(Map<String, dynamic> json) => Review(
    id: json['id'],
    id_user: json['id_user'],
    id_news: json['id_news'],
    review: json['review'],
  );

  String toRawJson() => json.encode(toMap());

  Map<String, dynamic> toJson() => {
        "id": id,
        "id_user": id_user,
        "id_news": id_news,
        "review": review,
      };
}