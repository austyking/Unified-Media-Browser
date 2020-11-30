import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import 'package:media_browser/models/utelly/utelly_models.dart';
import 'package:media_browser/blocs/blocs.dart';

class DetailBloc extends Bloc<UtellySearchResultItem, DetailState> {
  final UtellySearchResultItem searchResultItem;

  DetailBloc({@required this.searchResultItem});

  @override
  DetailState get initialState => DetailStateInitial(searchResultItem);

  @override
  Stream<DetailState> mapEventToState(UtellySearchResultItem event) async* {
    // given a SearchResultItem which was clicked on, return details
    print('detail_bloc.event: $event');
    yield DetailStateInitial(searchResultItem);
  }
}
