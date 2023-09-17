import 'package:json_annotation/json_annotation.dart';
import 'package:masterstudy_app/data/models/category.dart';

part 'CoursesResponse.g.dart';

class CoursesResponse {
  num? page;
  List<CoursesBean?> courses;
  num? total_pages;

  CoursesResponse({required this.page, required this.courses, required this.total_pages});

  factory CoursesResponse.fromJson(Map<String, dynamic> json) {
    return CoursesResponse(
      page: json['page'] as num,
      courses: (json['courses'] as List).map((e) => e == null ? null : CoursesBean.fromJson(e as Map<String, dynamic>)).toList(),
      total_pages: json['total_pages'] as num,
    );
  }

  Map<String, dynamic> toJson(CoursesResponse instance) => <String, dynamic>{
        'page': instance.page,
        'courses': instance.courses,
        'total_pages': instance.total_pages,
      };
}

@JsonSerializable()
class CoursesBean {
  dynamic id;
  String? title;
  ImagesBean? images;
  List<String?> categories;
  PriceBean? price;
  RatingBean? rating;
  String? featured;
  StatusBean? status;
  List<Category?> categories_object;

  CoursesBean({
    required this.id,
    required this.title,
    required this.images,
    required this.categories,
    required this.price,
    required this.rating,
    required this.featured,
    required this.status,
    required this.categories_object,
  });

  factory CoursesBean.fromJson(Map<String, dynamic> json) => _$CoursesBeanFromJson(json);

  Map<String, dynamic> toJson() => _$CoursesBeanToJson(this);
}

@JsonSerializable()
class PriceBean {
  final dynamic free;
  final dynamic price;
  final dynamic old_price;

  PriceBean({
    this.free,
    this.price,
    this.old_price,
  });

  factory PriceBean.fromJson(Map<String, dynamic> json) => _$PriceBeanFromJson(json);

  Map<String, dynamic> toJson() => _$PriceBeanToJson(this);
}

@JsonSerializable()
class StatusBean {
  String? status;
  String? label;

  StatusBean({required this.status, required this.label});

  factory StatusBean.fromJson(Map<String, dynamic> json) => _$StatusBeanFromJson(json);

  Map<String, dynamic> toJson() => _$StatusBeanToJson(this);
}

@JsonSerializable()
class RatingBean {
  num? average;
  num? total;
  num? percent;

  RatingBean({required this.average, required this.total, required this.percent});

  factory RatingBean.fromJson(Map<String, dynamic> json) => _$RatingBeanFromJson(json);

  Map<String, dynamic> toJson() => _$RatingBeanToJson(this);
}

@JsonSerializable()
class ImagesBean {
  String? full;
  String? small;

  ImagesBean({required this.full, required this.small});

  factory ImagesBean.fromJson(Map<String, dynamic> json) => _$ImagesBeanFromJson(json);

  Map<String, dynamic> toJson() => _$ImagesBeanToJson(this);
}
