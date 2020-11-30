import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:media_browser/models/omdb/omdb_models.dart';
import 'package:media_browser/models/utelly/utelly_search_result_item.dart';

abstract class OverviewState extends Equatable {
  final UtellySearchResultItem utellyItem;

  const OverviewState({@required this.utellyItem});

  @override
  List<Object> get props => [utellyItem];
}

class OverviewStateInitial extends OverviewState {
  const OverviewStateInitial({@required utellyItem})
      : super(utellyItem: utellyItem);
}

class OverviewStateLoading extends OverviewState {
  const OverviewStateLoading({@required utellyItem})
      : super(utellyItem: utellyItem);
}

class OverviewStateSuccess extends OverviewState {
  final OmdbSearchResultItem item;

  const OverviewStateSuccess({this.item, @required utellyItem})
      : super(utellyItem: utellyItem);

  @override
  List<Object> get props => [item];

  @override
  String toString() => 'OverviewStateSuccess { item title: ${item.title} }';
}

class OverviewStateError extends OverviewState {
  final String error;

  const OverviewStateError(this.error);

  @override
  List<Object> get props => [error];
}
