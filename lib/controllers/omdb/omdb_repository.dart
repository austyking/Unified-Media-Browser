import 'dart:async';

import 'package:media_browser/controllers/controllers.dart';
import 'package:media_browser/models/omdb/omdb_models.dart';

class OmdbRepository {
  final OmdbCache cache;
  final OmdbClient client;

  OmdbRepository(this.cache, this.client);

  Future<OmdbSearchResultItem> search(String term) async {
    if (cache.contains(term)) {
      return cache.get(term);
    } else {
      final result = await client.search(term);
      cache.set(term, result);
      return result;
    }
  }
}
