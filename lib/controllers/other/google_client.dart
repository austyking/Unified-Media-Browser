/// Build URL to redirect to a google search
String _host = 'www.google.com';
String _path = 'search';

String buildGoogleSearchUrl(String term) {
  var url = Uri.https(_host, _path, {'q': term});
  return url.toString();
}
