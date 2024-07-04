import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:weather/constants/constants.dart';
import 'package:weather/exceptions/weather_exception.dart';
import 'package:weather/models/direct_geocoding.dart';
import 'package:weather/models/weather.dart';
import 'package:weather/services/http_error_handler.dart';

class WeatherApiServices {
  final http.Client httpClient;

  WeatherApiServices({required this.httpClient});

  Future<DirectGeocoding> getDirectGeocoding(String city) async {
    final Uri uri = new Uri(
      scheme: 'http',
      host: kApiHost,
      path: 'geo/1.0/direct',
      queryParameters: {
        'q': city,
        'limit': kLimit,
        'appid': dotenv.env['APPID'],
      },
    );

    try {
      final http.Response response = await http.get(uri);

      if (response.statusCode != 200) {
        throw httpErrorHandler(response);
      }
      final responseBody = json.decode(response.body);

      if (responseBody.isEmpty) {
        throw WeatherException('can not get the location of the $city');
      }

      final directGeoCoding = DirectGeocoding.fromJson(responseBody);

      return directGeoCoding;
    } catch (e) {
      rethrow;
    }
  }

  Future<Weather> getWeather(DirectGeocoding directGeocoding) async {
    final Uri uri = Uri(
      scheme: 'http',
      host: kApiHost,
      path: 'data/2.5/weather',
      queryParameters: {
        'lat': directGeocoding.lat.toString(),
        'lon': directGeocoding.lon.toString(),
        'units': kUnit,
        'appid': dotenv.env['APPID'],
      },
    );

    try {
      final http.Response response = await http.get(uri);

      if (response.statusCode != 200) {
        throw Exception(httpErrorHandler(response));
      }
      final responseBody = json.decode(response.body);

      final weather = Weather.fromJson(responseBody);

      return weather;
    } catch (e) {
      rethrow;
    }
  }
}
