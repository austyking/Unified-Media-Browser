import 'package:media_browser/models/omdb/omdb_models.dart';

class OmdbCache {
  final _cache = <String, OmdbSearchResultItem>{};

  OmdbSearchResultItem get(String term) => _cache[term];

  void set(String term, OmdbSearchResultItem result) => _cache[term] = result;

  bool contains(String term) => _cache.containsKey(term);

  void remove(String term) => _cache.remove(term);
}
