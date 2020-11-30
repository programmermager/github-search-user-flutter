import 'package:json_annotation/json_annotation.dart';
import 'package:github_user_search/model/object/user_model.dart';

part 'search_user_response.g.dart';

@JsonSerializable()
class SearchUserResponse {
  List<UserModel> items;
  String message;

  SearchUserResponse();

  factory SearchUserResponse.fromJson(Map<String, dynamic> json) =>
      _$SearchUserResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SearchUserResponseToJson(this);
}
