/// Client for OMDB

/// Regex - comma sandwiched by 0 or more whitespace
RegExp commaRe = RegExp(r'(\s*,\s*)+');

/// Helper to convert a string of comma-separated items into a list
List<String> stringToList(String raw) {
  return raw.split(commaRe);
}

/// Helper to format the year returned by overview Utelly
String _formatYear(String year) {
  String sep = '–';
  String current = 'current';
  List<String> yearParts = year.split(sep);
  print(yearParts);
  if (yearParts.length == 1) {
    yearParts.add(current);
  } else if (yearParts.length == 2 && yearParts[1].length != 4) {
    yearParts[1] = current;
  }
  return yearParts.join(' $sep ');
}

class OmdbSearchResultItem {
  final String title;
  final String year;
  final String rated;
  final String released;
  final String runtime ;
  final String genre;
  final String director;
  final List<String> writer ;
  final List<String> actors ;
  final String plot;
  final String language;
  final String country ;
  final String awards ;
  final String poster ;
  final String metascore;
  final double imdbRating;
  final int imdbVotes;
  final String imdbID ;
  final String type;
  final String totalSeasons;

  OmdbSearchResultItem(this.title, this.year, this.rated, this.released,
      this.runtime, this.genre, this.director, this.writer, this.actors,
      this.plot, this.language, this.country, this.awards, this.poster,
      this.metascore, this.imdbRating, this.imdbVotes,
      this.imdbID, this.type, this.totalSeasons);

  factory OmdbSearchResultItem.fromJson(Map<String, Object> json) {
    return OmdbSearchResultItem(
        json['Title'] as String,
        json['Year'] != null ? _formatYear(json['Year']) : null,
        json['Rated'] as String,
        json['Released'] as String,
        json['Runtime'] as String,
        json['Genre'] as String,
        json['Director'] as String,
        json['Writer'] != null ? stringToList(json['Writer']) : null,
        json['Actors'] != null ? stringToList(json['Actors']) : null,
        json['Plot'] as String,
        json['Language'] as String,
        json['Country'] as String,
        json['Awards'] as String,
        json['Poster'] as String,
        json['Metascore'] as String,
        double.parse(json['imdbRating']),
        _readInt(json['imdbVotes']),
        json['imdbID'] as String,
        json['Type'] as String,
        json['totalSeasons'] as String,
    );
  }

  /// Read a comma-separated integer; e.g. 123,465
  static int _readInt(String raw) {
    var stripped = raw.replaceAll(',', '');
    return int.parse(stripped);
  }
}
