import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:weather/constants/constants.dart';

part 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(ThemeState.initial());

  void setTheme(double temp) {
    if (temp > kWarmOrNot) {
      emit(state.copyWith(appTheme: AppTheme.light));
    } else {
      emit(state.copyWith(appTheme: AppTheme.dark));
    }
  }
}
