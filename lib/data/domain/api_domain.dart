

import 'package:github_user_search/data/repository/api_repository.dart';
import 'package:github_user_search/model/response/search_user_response.dart';

class ApiDomain {
  final ApiRepository repository;

  ApiDomain(this.repository);

  Future<SearchUserResponse> reqSearch(String q, int page) {
    return repository.reqSearch(q, page);
  }
}
