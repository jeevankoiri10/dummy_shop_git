// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'reviews.g.dart';

@JsonSerializable()
class Reviews {
  const Reviews({
    this.rating,
    this.comment,
    this.date,
    this.reviewerName,
    this.reviewerEmail,
  });
  
  factory Reviews.fromJson(Map<String, Object?> json) => _$ReviewsFromJson(json);
  
  final int? rating;
  final String? comment;
  final String? date;
  final String? reviewerName;
  final String? reviewerEmail;

  Map<String, Object?> toJson() => _$ReviewsToJson(this);
}
