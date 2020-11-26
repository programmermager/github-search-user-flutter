import 'package:equatable/equatable.dart';

abstract class SearchPageEvent extends Equatable {
  const SearchPageEvent();

  @override
  List<Object> get props => [];
}

class ReqSearchUser extends SearchPageEvent {
  final String q;
  final int page;
  const ReqSearchUser({this.q, this.page});

  @override
  List<Object> get props => [q, page];
}
