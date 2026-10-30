// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reviews.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Reviews _$ReviewsFromJson(Map<String, dynamic> json) => Reviews(
  rating: (json['rating'] as num?)?.toInt(),
  comment: json['comment'] as String?,
  date: json['date'] as String?,
  reviewerName: json['reviewerName'] as String?,
  reviewerEmail: json['reviewerEmail'] as String?,
);

Map<String, dynamic> _$ReviewsToJson(Reviews instance) => <String, dynamic>{
  'rating': instance.rating,
  'comment': instance.comment,
  'date': instance.date,
  'reviewerName': instance.reviewerName,
  'reviewerEmail': instance.reviewerEmail,
};
