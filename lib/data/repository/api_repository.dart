
import 'package:dio/dio.dart';
import 'package:test_sejutacita/model/response/search_user_response.dart';

import '../api_services.dart';

class ApiRepository {
  Dio dio = ApiServices().launch();

  Future<SearchUserResponse> reqSearch(String q, int currentPage) async {
    try {
      final response = await dio.get("https://api.github.com/search/users?q=$q&page=$currentPage&per_page=20");
      return SearchUserResponse.fromJson(response.data);
    } catch (e) {
      return e;
    }
  }
}
