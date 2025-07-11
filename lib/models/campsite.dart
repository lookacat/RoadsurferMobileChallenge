class Campsite {
  final String id;
  final String createdAt;
  final String label;
  final String photo;
  final GeoLocation geoLocation;
  final bool isCloseToWater;
  final bool isCampFireAllowed;
  final List<String> hostLanguages;
  final double pricePerNight;
  final List<String> suitableFor;

  Campsite({
    required this.id,
    required this.createdAt,
    required this.label,
    required this.photo,
    required this.geoLocation,
    required this.isCloseToWater,
    required this.isCampFireAllowed,
    required this.hostLanguages,
    required this.pricePerNight,
    required this.suitableFor,
  });

  factory Campsite.fromJson(Map<String, dynamic> json) {
    return Campsite(
      id: json['id'] ?? '',
      createdAt: json['createdAt'] ?? '',
      label: json['label'] ?? '',
      photo: json['photo'] ?? '',
      geoLocation: GeoLocation.fromJson(json['geoLocation'] ?? {}),
      isCloseToWater: json['isCloseToWater'] ?? false,
      isCampFireAllowed: json['isCampFireAllowed'] ?? false,
      hostLanguages: List<String>.from(json['hostLanguages'] ?? []),
      pricePerNight: (json['pricePerNight'] ?? 0.0).toDouble(),
      suitableFor: List<String>.from(json['suitableFor'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'createdAt': createdAt,
      'label': label,
      'photo': photo,
      'geoLocation': geoLocation.toJson(),
      'isCloseToWater': isCloseToWater,
      'isCampFireAllowed': isCampFireAllowed,
      'hostLanguages': hostLanguages,
      'pricePerNight': pricePerNight,
      'suitableFor': suitableFor,
    };
  }
}

class GeoLocation {
  final double lat;
  final double long;

  GeoLocation({
    required this.lat,
    required this.long,
  });

  factory GeoLocation.fromJson(Map<String, dynamic> json) {
    return GeoLocation(
      lat: (json['lat'] ?? 0.0).toDouble(),
      long: (json['long'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'lat': lat,
      'long': long,
    };
  }
} 