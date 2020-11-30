import 'dart:async';

import 'package:media_browser/controllers/controllers.dart';
import 'package:media_browser/models/utelly/utelly_models.dart';

class UtellyRepository {
  final UtellyCache cache;
  final UtellyClient client;

  UtellyRepository(this.cache, this.client);

  Future<SearchResult> search(String term) async {
    if (cache.contains(term)) {
      return cache.get(term);
    } else {
      final result = await client.search(term);
      cache.set(term, result);
      return result;
    }
  }
}
