class Coordinates {
  double lat;
  double lng;

  Coordinates({required this.lat, required this.lng});

  factory Coordinates.fromJson(Map<String, dynamic> json) =>
      Coordinates(lat: json["lat"], lng: json["lng"]);

  Map<String, dynamic> toJson() => {
        "lat": lat,
        "lng": lng,
      };
}
