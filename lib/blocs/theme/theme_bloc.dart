import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:weather/blocs/blocs.dart';
import 'package:weather/blocs/weather/weather_bloc.dart';
import 'package:weather/constants/constants.dart';

part 'theme_event.dart';
part 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  late final StreamSubscription streamSubscription;
  final WeatherBloc weatherBloc;
  ThemeBloc({required this.weatherBloc}) : super(ThemeState.initial()) {
    streamSubscription = weatherBloc.stream.listen((WeatherState weatherState) {
      if (weatherState.weather.temp > kWarmOrNot) {
        add(SetThemeEvent(appTheme: AppTheme.light));
      } else {
        add(SetThemeEvent(appTheme: AppTheme.dark));
      }
    });
    on<SetThemeEvent>((event, emit) {
      emit(state.copyWith(appTheme: event.appTheme));
    });
  }

  @override
  Future<void> close() {
    streamSubscription.cancel();
    return super.close();
  }
}
