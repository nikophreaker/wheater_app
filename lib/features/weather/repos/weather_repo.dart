import 'dart:convert';
import 'dart:developer';

import '../models/weather_data_ui_model.dart';
import 'package:http/http.dart' as http;

class WeatherRepo {
  static Future<WeatherDataUiModel?> fetchWeather(double lat, double lon) async {
    var client = http.Client();
    try {
      var response = await client.get(Uri.parse(
          'https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=246870ca0491e4f355fa3c139dd60029&lang=ID&units=metric'));
      var result = jsonDecode(response.body);
      WeatherDataUiModel weather = WeatherDataUiModel.fromJson(result);
      return weather;
    } catch (e) {
      log(e.toString());
      return null;
    }
  }
}
