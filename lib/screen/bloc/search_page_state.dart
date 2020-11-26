
import 'package:equatable/equatable.dart';
import 'package:test_sejutacita/model/response/search_user_response.dart';

abstract class SearchPageState extends Equatable {
  const SearchPageState();
}

class InitPage extends SearchPageState{
  @override
  List<Object> get props => [];

}

class ReqLoading extends SearchPageState {
  @override
  List<Object> get props => [];
}

class ReqSearchSuccess extends SearchPageState {
  final SearchUserResponse response;
  const ReqSearchSuccess(this.response);

  @override
  List<Object> get props => [response];
}

class ReqSearchError extends SearchPageState {
  final String error;

  const ReqSearchError({this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'ReqSearchError { error: $error }';
}