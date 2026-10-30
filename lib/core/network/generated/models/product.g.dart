// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Product _$ProductFromJson(Map<String, dynamic> json) => Product(
  id: (json['id'] as num?)?.toInt(),
  title: json['title'] as String?,
  description: json['description'] as String?,
  category: json['category'] as String?,
  price: json['price'] as num?,
  discountPercentage: json['discountPercentage'] as num?,
  rating: json['rating'] as num?,
  stock: (json['stock'] as num?)?.toInt(),
  tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList(),
  brand: json['brand'] as String?,
  sku: json['sku'] as String?,
  weight: (json['weight'] as num?)?.toInt(),
  dimensions: json['dimensions'] == null
      ? null
      : Dimensions.fromJson(json['dimensions'] as Map<String, dynamic>),
  warrantyInformation: json['warrantyInformation'] as String?,
  shippingInformation: json['shippingInformation'] as String?,
  availabilityStatus: json['availabilityStatus'] as String?,
  reviews: (json['reviews'] as List<dynamic>?)
      ?.map((e) => Reviews.fromJson(e as Map<String, dynamic>))
      .toList(),
  returnPolicy: json['returnPolicy'] as String?,
  minimumOrderQuantity: (json['minimumOrderQuantity'] as num?)?.toInt(),
  meta: json['meta'] == null
      ? null
      : Meta.fromJson(json['meta'] as Map<String, dynamic>),
  images: (json['images'] as List<dynamic>?)?.map((e) => e as String).toList(),
  thumbnail: json['thumbnail'] as String?,
);

Map<String, dynamic> _$ProductToJson(Product instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'description': instance.description,
  'category': instance.category,
  'price': instance.price,
  'discountPercentage': instance.discountPercentage,
  'rating': instance.rating,
  'stock': instance.stock,
  'tags': instance.tags,
  'brand': instance.brand,
  'sku': instance.sku,
  'weight': instance.weight,
  'dimensions': instance.dimensions,
  'warrantyInformation': instance.warrantyInformation,
  'shippingInformation': instance.shippingInformation,
  'availabilityStatus': instance.availabilityStatus,
  'reviews': instance.reviews,
  'returnPolicy': instance.returnPolicy,
  'minimumOrderQuantity': instance.minimumOrderQuantity,
  'meta': instance.meta,
  'images': instance.images,
  'thumbnail': instance.thumbnail,
};
