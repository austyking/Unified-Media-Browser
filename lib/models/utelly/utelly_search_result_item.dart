/// A single search result item
class UtellySearchResultItem {
  final String id;
  final String pictureUrl;
  final String name;
  final List<Location> locations;
  final String provider;
  final int weight;
  final Map<String, ExternalId> externalIds;

  UtellySearchResultItem(this.id, this.pictureUrl, this.name, this.locations, this.provider,
      this.weight, this.externalIds);

  factory UtellySearchResultItem.fromJson(Map<String, Object> json) {
    // convert 1st level of types
    var locations = List<Map<String, Object>>.from(json['locations']);
    var externalIds = Map<String, Object>.from(json['external_ids']);
    // remove null values
    externalIds.removeWhere((k,v) => v == null);

    return UtellySearchResultItem(
      json['id'] as String,
      json['picture'] as String,
      json['name'] as String,
      locations.map((loc) => Location.fromJson(loc)).toList(),
      json['provider'] as String,
      json['weight'] as int,
      externalIds.map((k,v) => MapEntry(k, ExternalId.fromJson(v))),
    );
  }
}

class Location {
  final String iconUrl;
  final String displayName;
  final String name;
  final String id;
  final String url;

  Location(this.iconUrl, this.displayName, this.name, this.id, this.url);

  factory Location.fromJson(Map<String, Object> json) {
    return Location(
        json['icon'] as String,
        json['display_name'] as String,
        json['name'] as String,
        json['id'] as String,
        json['url'] as String
    );
  }
}

class ExternalId {
  final String url;
  final String id;

  ExternalId(this.url, this.id);

  factory ExternalId.fromJson(Map<String, Object> json) {
    return ExternalId(
      json.containsKey('url')? json['url'] as String : null,
      json.containsKey('id')? json['id'] as String: null,
    );
  }
}
