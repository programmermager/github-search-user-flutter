import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
 String login;
 int id;
 double score;
 String avatar_url;

  UserModel();

 factory UserModel.fromJson(Map<String, dynamic> json) =>
     _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}