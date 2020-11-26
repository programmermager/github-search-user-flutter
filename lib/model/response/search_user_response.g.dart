// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_user_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SearchUserResponse _$SearchUserResponseFromJson(Map<String, dynamic> json) {
  return SearchUserResponse()
    ..items = (json['items'] as List)
        ?.map((e) =>
            e == null ? null : UserModel.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..message = json['message'] as String;
}

Map<String, dynamic> _$SearchUserResponseToJson(SearchUserResponse instance) =>
    <String, dynamic>{
      'items': instance.items,
      'message': instance.message,
    };
