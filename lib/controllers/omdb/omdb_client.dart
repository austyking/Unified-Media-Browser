import 'dart:convert';
import 'dart:io';

import 'package:media_browser/globals.dart' as globals;
import 'package:http/http.dart' as http;
import 'package:media_browser/models/omdb/omdb_models.dart';

class OmdbClient {
  final String baseHost;
  final String basePath;
  final http.Client client;
  final String apiKey;

  OmdbClient({
    HttpClient client,
    Map<String, OmdbSearchResultItem> cache,
    this.baseHost = 'www.omdbapi.com',
    this.basePath = '',
    this.apiKey = globals.omdbKey,
  })  : this.client = client ?? http.Client();

Future<OmdbSearchResultItem> search(String imdbId) async {
  var url = _constructUrl(imdbId);
  final response = await client.get(url);
  final results = json.decode(response.body);

  if (response.statusCode == 200) {
    return OmdbSearchResultItem.fromJson(results);
  } else {
    throw SearchResultError.fromJson(results);
  }
}

Uri _constructUrl(String imdbId) {
  return Uri.http(this.baseHost, this.basePath,
      {'i': imdbId, 'plot': 'full', 'apiKey': this.apiKey});
}
}
