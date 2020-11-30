import 'package:equatable/equatable.dart';
import 'package:media_browser/models/utelly/utelly_models.dart';

abstract class DetailState extends Equatable {
  final UtellySearchResultItem item;

  const DetailState(this.item);

  @override
  List<Object> get props => [];
}

class DetailStateInitial extends DetailState {
  DetailStateInitial(UtellySearchResultItem item) : super(item);

  @override
  List<Object> get props => [item];
}

class DetailStateLoading extends DetailState {
  DetailStateLoading(UtellySearchResultItem item) : super(item);
}


class DetailStateError extends DetailState {
  final String error;

  const DetailStateError(this.error) : super(null);

  @override
  List<Object> get props => [error];
}
