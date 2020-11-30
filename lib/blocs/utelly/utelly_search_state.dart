import 'package:equatable/equatable.dart';

import 'package:media_browser/models/utelly/utelly_models.dart';

/// Equatable allows pragmatic comparison between two instances of an object
abstract class UtellySearchState extends Equatable {
  const UtellySearchState();

  @override
  List<Object> get props => [];
}

class SearchStateEmpty extends UtellySearchState {}

class SearchStateLoading extends UtellySearchState {}

class SearchStateSuccess extends UtellySearchState {
  final List<UtellySearchResultItem> items;

  const SearchStateSuccess(this.items);

  @override
  List<Object> get props => [items];

  @override
  String toString() => 'SearchStateSuccess { items: ${items.length} }';
}

class SearchStateError extends UtellySearchState {
  final String error;

  const SearchStateError(this.error);

  @override
  List<Object> get props => [error];
}
