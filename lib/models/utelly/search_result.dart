/// Holds a list of SearchResultItems
import 'package:media_browser/models/utelly/utelly_models.dart';

class SearchResult {
  final List<UtellySearchResultItem> items;

  SearchResult(this.items);

  factory SearchResult.fromJson(dynamic json) {
    var results = List<Map<String, Object>>.from(json['results']);
    var items = results.map((res) => UtellySearchResultItem.fromJson(res));
    return SearchResult(items.toList());
  }

  bool get isPopulated => items.isNotEmpty;

  bool get isEmpty => items.isEmpty;
}
