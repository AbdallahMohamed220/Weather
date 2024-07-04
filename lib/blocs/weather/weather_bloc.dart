import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:weather/models/custom_error.dart';
import 'package:weather/models/weather.dart';
import 'package:weather/repositories/weather_repository.dart';

part 'weather_event.dart';
part 'weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final WeatherRepository weatherRepository;
  WeatherBloc({required this.weatherRepository})
      : super(WeatherState.initial()) {
    on<FetchWeatherEvent>(_fetchWeatherEvent);
  }

  Future<void> _fetchWeatherEvent(
    FetchWeatherEvent event,
    Emitter<WeatherState> emit,
  ) async {
    emit(state.copyWith(status: WeatherStatus.loading));
    try {
      final Weather weather = await weatherRepository.fetchWeather(event.city);
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
