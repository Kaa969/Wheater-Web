import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:async';

import '../widgets/info_card.dart';
import '../model/weather_model.dart';
import '../services/weather_service.dart';
import '../services/location_service.dart';
import '../services/storage_service.dart';

final LocationService locationService = LocationService();

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final WeatherService weatherService = WeatherService();
  final StorageService storageService = StorageService();

  late Future<WeatherModel> weatherFuture;

  final TextEditingController cityController =
      TextEditingController(text: "Bandung");

  DateTime _currentTime = DateTime.now();
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    weatherFuture = weatherService.getWeather("Bandung");

    loadCurrentLocation();
    loadLastCity();

    _startClock();
  }

  void _startClock() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        _currentTime = DateTime.now();
      });
    });
  }

  void _stopClock() {
    _timer?.cancel();
  }

  Future<void> loadCurrentLocation() async {
    try {
      String city = await locationService.getCurrentCity();

      cityController.text = city;

      setState(() {
        weatherFuture = weatherService.getWeather(city);
      });
    } catch (e) {
      setState(() {
        weatherFuture = weatherService.getWeather("Bandung");
      });
    }
  }

  Future<void> loadLastCity() async {
    final city = await storageService.getLastCity();

    if (city != null) {
      cityController.text = city;

      setState(() {
        weatherFuture = weatherService.getWeather(city);
      });
    }
  }

  void searchWeather() async {
    if (cityController.text.trim().isEmpty) return;

    await storageService.saveCity(cityController.text.trim());

    setState(() {
      weatherFuture =
          weatherService.getWeather(cityController.text.trim());
    });
  }

  @override
  void dispose() {
    _stopClock();
    cityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Weather App",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xff4FACFE),
        elevation: 0,
      ),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xff4FACFE),
              Color(0xff00F2FE),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: FutureBuilder<WeatherModel>(
            future: weatherFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState ==
                  ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                );
              }

              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    snapshot.error.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                );
              }

              if (!snapshot.hasData) {
                return const Center(
                  child: Text(
                    "Data tidak ditemukan",
                    style: TextStyle(color: Colors.white),
                  ),
                );
              }

              final weather = snapshot.data!;

              return SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [

                    TextField(
                      controller: cityController,
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                      decoration: InputDecoration(
                        hintText: "Cari Kota...",
                        hintStyle: const TextStyle(
                          color: Colors.white70,
                        ),
                        prefixIcon: const Icon(
                          Icons.search,
                          color: Colors.white,
                        ),
                        suffixIcon: IconButton(
                          icon: const Icon(
                            Icons.search,
                            color: Colors.white,
                          ),
                          onPressed: searchWeather,
                        ),
                        filled: true,
                        fillColor: Colors.white24,
                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(15),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onSubmitted: (_) => searchWeather(),
                    ),

                    const SizedBox(height: 25),

                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.location_on,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 5),

                        Text(
                          weather.city,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 30),

                    Image.network(
                      weather.icon,
                      width: 120,
                      height: 120,
                    ),

                    const SizedBox(height: 15),

                    Text(
                      "${weather.temperature.toStringAsFixed(0)}°C",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 60,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    Text(
                      weather.condition,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                      ),
                    ),

                    const SizedBox(height: 20),

                    Column(
                      children: [
                        Text(
                          DateFormat('HH:mm:ss')
                              .format(_currentTime),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        Text(
                          DateFormat('EEEE')
                              .format(_currentTime),
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),

                        Text(
                          DateFormat('dd MMMM yyyy')
                              .format(_currentTime),
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 25),
                                        GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 1.2,
                      children: [
                        InfoCard(
                          icon: Icons.water_drop,
                          title: "Humidity",
                          value: "${weather.humidity}%",
                        ),
                        InfoCard(
                          icon: Icons.air,
                          title: "Wind",
                          value:
                              "${weather.wind.toStringAsFixed(1)} km/h",
                        ),
                        InfoCard(
                          icon: Icons.thermostat,
                          title: "Temperature",
                          value:
                              "${weather.temperature.toStringAsFixed(0)}°C",
                        ),
                        InfoCard(
                          icon: Icons.cloud,
                          title: "Condition",
                          value: weather.condition,
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}