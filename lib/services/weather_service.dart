import 'dart:convert';

import 'package:http/http.dart' as http;

import '../model/weather_model.dart';

class WeatherService {

  final String apiKey = "f2dbe19561194bec9c105931261707";

  Future<WeatherModel> getWeather(String city) async {

    final url =
        "https://api.weatherapi.com/v1/forecast.json?key=$apiKey&q=$city&days=3&aqi=no&alerts=no";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {

      final data = jsonDecode(response.body);

      return WeatherModel.fromJson(data);

    } else {

      throw Exception("Gagal mengambil data cuaca");

    }

  }

}