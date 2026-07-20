class ForecastModel {
  final String date;
  final double temp;
  final String condition;
  final String icon;

  ForecastModel({
    required this.date,
    required this.temp,
    required this.condition,
    required this.icon,
  });

  factory ForecastModel.fromJson(Map<String, dynamic> json) {
    return ForecastModel(
      date: json["date"],
      temp: json["day"]["avgtemp_c"].toDouble(),
      condition: json["day"]["condition"]["text"],
      icon: "https:${json["day"]["condition"]["icon"]}",
    );
  }
}