import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:github_user_search/data/domain/api_domain.dart';
import 'package:github_user_search/model/response/search_user_response.dart';
import 'package:github_user_search/screen/bloc/search_page_state.dart';

import 'search_page_event.dart';

class SearchPageBloc extends Bloc<SearchPageEvent, SearchPageState> {
  final ApiDomain domain;

  SearchPageBloc({@required this.domain}) : assert(domain != null);

  @override
  SearchPageState get initialState => InitPage();

  @override
  Stream<SearchPageState> mapEventToState(SearchPageEvent event) async* {
    if (event is ReqSearchUser) {
      yield ReqLoading();
      try {
        SearchUserResponse resp = await domain.reqSearch(event.q, event.page);
        if (resp.message == null) {
          yield ReqSearchSuccess(resp);
        } else {
          yield ReqSearchError(error: resp.message);
        }
      } catch (e) {
        yield ReqSearchError(error: e.toString());
      }
    }
  }
}
