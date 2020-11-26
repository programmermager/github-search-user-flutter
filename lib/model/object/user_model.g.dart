// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) {
  return UserModel()
    ..login = json['login'] as String
    ..id = json['id'] as int
    ..score = (json['score'] as num)?.toDouble()
    ..avatar_url = json['avatar_url'] as String
    ..url = json['url'] as String;
}

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'login': instance.login,
      'id': instance.id,
      'score': instance.score,
      'avatar_url': instance.avatar_url,
      'url': instance.url,
    };
