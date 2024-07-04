part of 'theme_bloc.dart';

enum AppTheme { light, dark }

class ThemeState extends Equatable {
  final AppTheme appTheme;

  ThemeState({required this.appTheme});

  factory ThemeState.initial() {
    return ThemeState(appTheme: AppTheme.light);
  }

  ThemeState copyWith({
    AppTheme? appTheme,
  }) {
    return ThemeState(
      appTheme: appTheme ?? this.appTheme,
    );
  }

  @override
  String toString() => 'AppThemeState(appTheme: $appTheme)';

  @override
  List<Object> get props => [appTheme];
}
