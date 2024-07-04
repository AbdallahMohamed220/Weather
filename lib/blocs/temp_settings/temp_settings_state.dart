part of 'temp_settings_bloc.dart';

enum TempUnit {
  celsius,
  fahrenheit,
}

class TempSettingsState extends Equatable {
  final TempUnit tempUnit;

  TempSettingsState({required this.tempUnit});

  factory TempSettingsState.initial() {
    return TempSettingsState(tempUnit: TempUnit.celsius);
  }

  @override
  List<Object?> get props => [tempUnit];

  TempSettingsState copyWith({
    TempUnit? tempUnit,
  }) {
    return TempSettingsState(
      tempUnit: tempUnit ?? this.tempUnit,
    );
  }
}
