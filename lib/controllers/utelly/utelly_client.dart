/*
Make request to get media data.
 */
import 'dart:convert';
import 'dart:io';

import 'package:media_browser/globals.dart' as globals;
import 'package:http/http.dart' as http;
import 'package:media_browser/models/utelly/utelly_models.dart';

class UtellyClient {
  final String baseHost;
  final String basePath;
  final Map<String, String> baseHeaders;
  final http.Client client;

  UtellyClient({
    HttpClient client,
    Map<String, SearchResult> cache,
    this.baseHost = 'utelly-tv-shows-and-movies-availability-v1.p.rapidapi.com',
    this.basePath = '/lookup',
    this.baseHeaders = const {
      'x-rapidapi-host': 'utelly-tv-shows-and-movies-availability-v1.p.rapidapi.com',
      'x-rapidapi-key': globals.utellyKey
    }
  })  : this.client = client ?? http.Client();

  /// Search Utelly for media using given term
  Future<SearchResult> search(String term) async {
    var url = _constructUrl(term);
    final response = await client.get(url, headers: this.baseHeaders);
    final results = json.decode(response.body);

    if (response.statusCode == 200) {
      return SearchResult.fromJson(results);
    } else {
      throw SearchResultError.fromJson(results);
    }
  }
  /// Helper to construct URL
  Uri _constructUrl(String term) {
    return Uri.https(this.baseHost, this.basePath, {'term': term});
  }
}


// driver
main() async {
  var api = UtellyClient();
  var res = api.search('the office');
  print(await res);
  print('done');
}
