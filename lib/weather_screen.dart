import 'dart:convert';
import 'dart:ui';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:weather_x/AdditionalFeatures.dart';
import 'package:flutter/material.dart';
import 'package:weather_x/ForecastCard.dart';
import 'package:weather_x/key.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  String city = 'India&Tamilnadu';
  late Future<Map<String, dynamic>> weather;
  Future<Map<String, dynamic>> GetCurrentWeather() async {
    try {
      final res = await http.get(
        Uri.parse(
          'https://api.openweathermap.org/data/2.5/forecast?q=$city&APPID=$key',
        ),
      );
      final data = jsonDecode(res.body);
      if (data['cod'] != '200') {
        throw 'An unexpected error happened';
      }
      return data;
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    weather = GetCurrentWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () {
                  setState(() {
                    weather = GetCurrentWeather();
                  });
                },
                icon: Icon(Icons.refresh))
          ],
          centerTitle: true,
          title: Text(
            'Weather App',
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
          ),
        ),
        body: FutureBuilder(
            future: weather,
            builder: (context, asyncSnapshot) {
              if (asyncSnapshot.connectionState == ConnectionState.waiting) {
                return Center(
                    child: const CircularProgressIndicator.adaptive());
              }
              if (asyncSnapshot.hasError) {
                return Text(asyncSnapshot.error.toString());
              }
              final data = asyncSnapshot.data!;
              final repeatWeather = data['list'][0];
              final currentTemp = repeatWeather['main']['temp'];
              final currentSky = repeatWeather['weather'][0]['main'];
              final humidity = repeatWeather['main']['humidity'];
              final pressure = repeatWeather['main']['pressure'];
              final windSpeed = repeatWeather['wind']['speed'];

              return Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Location : $city',
                      style:
                          TextStyle(fontWeight: FontWeight.w800, fontSize: 20),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          color: Colors.white10,
                          elevation: 10,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  children: [
                                    Text(
                                      '$currentTemp K',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 32,
                                      ),
                                    ),
                                    Icon(
                                      currentSky == 'Clouds' ||
                                              currentSky == "rain"
                                          ? Icons.cloud
                                          : Icons.sunny,
                                      size: 70,
                                    ),
                                    Text(
                                      "$currentSky",
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.white70,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          )),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      textAlign: TextAlign.start,
                      'Weather Forecast',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 7,
                    ),
                    SizedBox(
                      height: 140,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 40,
                        itemBuilder: (context, index) {
                          final Forecast = data['list'][index];
                          final time = DateTime.parse(Forecast['dt_txt']);
                          return ForecastCard(
                            time: DateFormat.Hm().format(time),
                            value: Forecast['main']['temp'].toString(),
                            icon: Forecast['weather'][0]['main'] == 'Clouds' ||
                                    Forecast['weather'][0]['main'] == 'rain'
                                ? CupertinoIcons.cloud
                                : Icons.sunny,
                          );
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Text(
                      "Additional Information",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        AdditionalFeatures(
                          icon: Icons.water_drop,
                          label: 'Humid',
                          value: '$humidity',
                        ),
                        AdditionalFeatures(
                          icon: Icons.compress,
                          label: 'pressure',
                          value: '$pressure',
                        ),
                        AdditionalFeatures(
                          icon: Icons.air,
                          label: 'Wind speed',
                          value: '$windSpeed',
                        ),
                      ],
                    )
                  ],
                ),
              );
            }));
  }
}
