import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather/constants/constants.dart';
import 'package:weather/models/custom_error.dart';
import 'package:weather/models/weather.dart';
import 'package:weather/repositories/weather_repository.dart';

part 'weather_state.dart';

class WeatherCubit extends Cubit<WeatherState> {
  WeatherCubit({
    required this.weatherRepository,
  }) : super(WeatherState.initial());

  final WeatherRepository weatherRepository;

  checkFetchCurrentLocation() {
    emit(state.copyWith(status: WeatherStatus.loading));
    if (currentLocation == null) {
      getCurrentLocation();
    } else {
      fetchWeather(currentLocation!);
    }
  }

  Future<void> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    _getAddressFromLatLng(position);
  }

  Future<void> _getAddressFromLatLng(Position position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      Placemark place = placemarks[0];
      currentLocation = place.locality!;
      fetchWeather(currentLocation!);
    } catch (e) {
      print(e);
    }
  }

  Future<void> fetchWeather(String city) async {
    emit(
      state.copyWith(status: WeatherStatus.loading),
    );
    try {
      final Weather weather = await weatherRepository.fetchWeather(city);
      emit(
        state.copyWith(
          status: WeatherStatus.loaded,
          weather: weather,
        ),
      );
      print(state);
    } on CustomError catch (e) {
      emit(
        state.copyWith(
          status: WeatherStatus.error,
          error: e,
        ),
      );
      print(state);
    }
  }
}
