// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'CoursesResponse.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CoursesBean _$CoursesBeanFromJson(Map<String, dynamic> json) {
  return CoursesBean(
    id: json['id'],
    title: json['title'],
    images: json['images'] == null ? null : ImagesBean.fromJson(json['images'] as Map<String, dynamic>),
    categories: (json['categories'] as List).map((e) => e as String).toList(),
    price: json['price'] == null ? null : PriceBean.fromJson(json['price'] as Map<String, dynamic>),
    rating: json['rating'] == null ? null : RatingBean.fromJson(json['rating'] as Map<String, dynamic>),
    featured: json['featured'],
    status: json['status'] == null ? null : StatusBean.fromJson(json['status'] as Map<String, dynamic>),
    categories_object: (json['categories_object'] as List).map((e) => e == null ? null : Category.fromJson(e as Map<String, dynamic>)).toList(),
  );
}

Map<String, dynamic> _$CoursesBeanToJson(CoursesBean instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'images': instance.images,
      'categories': instance.categories,
      'price': instance.price,
      'rating': instance.rating,
      'featured': instance.featured,
      'status': instance.status,
      'categories_object': instance.categories_object,
    };

PriceBean _$PriceBeanFromJson(Map<String, dynamic> json) {
  return PriceBean(
    free: json['free'],
    price: json['price'],
    old_price: json['old_price'],
  );
}

Map<String, dynamic> _$PriceBeanToJson(PriceBean instance) => <String, dynamic>{
      'free': instance.free,
      'price': instance.price,
      'old_price': instance.old_price,
    };

StatusBean _$StatusBeanFromJson(Map<String, dynamic> json) {
  return StatusBean(
    status: json['status'],
    label: json['label'],
  );
}

Map<String, dynamic> _$StatusBeanToJson(StatusBean instance) => <String, dynamic>{
      'status': instance.status,
      'label': instance.label,
    };

RatingBean _$RatingBeanFromJson(Map<String, dynamic> json) {
  return RatingBean(
    average: json['average'],
    total: json['total'],
    percent: json['percent'],
  );
}

Map<String, dynamic> _$RatingBeanToJson(RatingBean instance) => <String, dynamic>{
      'average': instance.average,
      'total': instance.total,
      'percent': instance.percent,
    };

ImagesBean _$ImagesBeanFromJson(Map<String, dynamic> json) {
  return ImagesBean(
    full: json['full'],
    small: json['small'],
  );
}

Map<String, dynamic> _$ImagesBeanToJson(ImagesBean instance) => <String, dynamic>{
      'full': instance.full,
      'small': instance.small,
    };
