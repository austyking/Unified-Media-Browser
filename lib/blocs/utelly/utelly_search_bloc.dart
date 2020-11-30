import 'dart:async';

import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:bloc/bloc.dart';

import 'package:media_browser/models/utelly/utelly_models.dart';
import 'package:media_browser/blocs/blocs.dart';
import 'package:media_browser/controllers/controllers.dart';

class UtellySearchBloc extends Bloc<UtellySearchEvent, UtellySearchState> {
  final UtellyRepository utellyRepository;

  UtellySearchBloc({@required this.utellyRepository});

  // Search field triggers an API call if its text is changed. Doing an API call
  // on every single key stroke is expensive. We want to only make a call if the
  // user pauses for a moment. We use debounce() to swallow (not emit) any
  // incoming event which is not followed by a pause.
  @override
  Stream<Transition<UtellySearchEvent, UtellySearchState>> transformEvents(
      Stream<UtellySearchEvent> events,
      // Seems to be the rx/dart way of defining the callback signature. Here,
      // we are defining mapEventToState() (defined below)
      Stream<Transition<UtellySearchEvent, UtellySearchState>> Function(
          UtellySearchEvent event,
          )
      transitionFn,
      ) {
    return events
        .debounceTime(const Duration(milliseconds: 600))
        .switchMap(transitionFn);
  }

  @override
  UtellySearchState get initialState => SearchStateEmpty();

  @override
  Stream<UtellySearchState> mapEventToState(UtellySearchEvent event) async* {
    if (event is TextChanged) {
      final String searchTerm = event.text;
      if (searchTerm.isEmpty) {
        yield SearchStateEmpty();
      } else {
        yield SearchStateLoading();
        try {
          // Sleep some time to ensure user stopped typing
          await Future<void>.delayed(Duration(seconds: 1));
          final results = await utellyRepository.search(searchTerm);
          yield SearchStateSuccess(results.items);
        } catch (error) {
          yield error is SearchResultError
              ? SearchStateError(error.message)
              : SearchStateError('something went wrong');
        }
      }
    }
  }
}
