import 'package:weather/exceptions/weather_exception.dart';
import 'package:weather/models/custom_error.dart';
import 'package:weather/models/direct_geocoding.dart';
import 'package:weather/models/weather.dart';
import 'package:weather/services/weather_api_services.dart';

class WeatherRepository {
  final WeatherApiServices weatherApiServices;

  WeatherRepository({required this.weatherApiServices});

  Future<Weather> fetchWeather(String city) async {
    try {
      final DirectGeocoding directGeocoding =
          await weatherApiServices.getDirectGeocoding(city);

      print(directGeocoding.toJson());

      final Weather tempWeather =
          await weatherApiServices.getWeather(directGeocoding);

      final Weather weather = tempWeather.copyWith(
          name: directGeocoding.name, country: directGeocoding.country);
      print(weather.toJson());

      return weather;
    } on WeatherException catch (e) {
      throw CustomError(errMsg: e.message);
    } catch (e) {
      throw CustomError(errMsg: e.toString());
    }
  }
}
