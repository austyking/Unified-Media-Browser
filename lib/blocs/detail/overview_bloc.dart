import 'package:bloc/bloc.dart';
import 'package:media_browser/controllers/controllers.dart';

import 'package:media_browser/models/omdb/omdb_models.dart';
import 'package:media_browser/blocs/blocs.dart';
import 'package:media_browser/models/utelly/utelly_search_result_item.dart';

class OverviewBloc extends Bloc<DetailOverviewEvent, OverviewState> {
  final OmdbRepository omdbRepository;
  final UtellySearchResultItem utellyItem;

  OverviewBloc(this.omdbRepository, this.utellyItem) {
    // trigger query event here, bc we can't do it from initalState()
    this.add(OverviewQuery(utellyItem.externalIds['imdb'].id));
  }

  @override
  OverviewState get initialState {
    return OverviewStateInitial(utellyItem: utellyItem);
  }

  @override
  Stream<OverviewState> mapEventToState(DetailOverviewEvent event) async* {
    print('overview_bloc.event: $event');
    if (event is OverviewQuery) {
      yield OverviewStateLoading(utellyItem: utellyItem);
      try {
        final result = await omdbRepository.search(event.imdbId);
        yield OverviewStateSuccess(item: result, utellyItem: utellyItem);
      } catch (error, stacktrace) {
        print('overview_bloc error:\n$error\n$stacktrace');
        yield error is SearchResultError
            ? OverviewStateError(error.message)
            : OverviewStateError('something went wrong');
      }
    } else {
      yield OverviewStateLoading(utellyItem: utellyItem);
    }
  }
}
