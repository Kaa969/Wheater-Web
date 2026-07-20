class WeatherModel {
  final String city;
  final double temperature;
  final String condition;
  final String icon;
  final int humidity;
  final double wind;
  final double feelsLike;
  final int pressure;

  WeatherModel({
    required this.city,
    required this.temperature,
    required this.condition,
    required this.icon,
    required this.humidity,
    required this.wind,
    required this.feelsLike,
    required this.pressure,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      city: json["location"]["name"],
      temperature: (json["current"]["temp_c"] as num).toDouble(),
      condition: json["current"]["condition"]["text"],
      icon: "https:${json["current"]["condition"]["icon"]}",
      humidity: json["current"]["humidity"],
      wind: (json["current"]["wind_kph"] as num).toDouble(),
      feelsLike: (json["current"]["feelslike_c"] as num).toDouble(),
      pressure: json["current"]["pressure_mb"],
    );
  }
}