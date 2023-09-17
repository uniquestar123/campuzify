
import 'package:json_annotation/json_annotation.dart';

import 'InstructorsResponse.dart';

part 'account.g.dart';

@JsonSerializable()
class Account {
  num? id;
  String? login;
  dynamic avatar;
  String? avatar_url;
  String? email;
  String? url;
  List<dynamic>? roles;
  MetaBean? meta;
  RatingBean? rating;
  String? profile_url;

  Account({
    this.id,
    this.login,
    this.avatar,
    this.avatar_url,
    this.email,
    this.url,
    this.roles,
    this.meta,
    this.rating,
    this.profile_url,
  });

  factory Account.fromJson(Map<String, dynamic> json) => _$AccountFromJson(json);


  Map<String, dynamic> toJson() => _$AccountToJson(this);
}

@JsonSerializable()
class RatingBean {
  num? total;
  num? average;
  num? marks_num;
  String? total_marks;
  num? percent;

  RatingBean(
      {required this.total,
      required this.average,
      required this.marks_num,
      required this.total_marks,
      required this.percent});

  factory RatingBean.fromJson(Map<String, dynamic> json) => _$RatingBeanFromJson(json);

  Map<String, dynamic> toJson() => _$RatingBeanToJson(this);
}
