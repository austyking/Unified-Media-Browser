import 'package:equatable/equatable.dart';

abstract class DetailOverviewEvent extends Equatable {
  const DetailOverviewEvent();
}

class OverviewQuery extends DetailOverviewEvent {
  final String imdbId;

  const OverviewQuery(this.imdbId);

  @override
  List<Object> get props => [imdbId];

  @override
  String toString() => 'OverviewQuery { imdb_id: $imdbId }';
}
