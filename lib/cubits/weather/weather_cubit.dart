import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:weather/models/custom_error.dart';
import 'package:weather/models/weather.dart';
import 'package:weather/repositories/weather_repository.dart';

part 'weather_state.dart';

class WeatherCubit extends Cubit<WeatherState> {
  WeatherCubit({
    required this.weatherRepository,
  }) : super(WeatherState.initial());

  final WeatherRepository weatherRepository;

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
