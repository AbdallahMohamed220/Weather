import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:weather/cubits/temp_settings/temp_settings_cubit.dart';
import 'package:weather/cubits/theme/theme_cubit.dart';
import 'package:weather/cubits/weather/weather_cubit.dart';
import 'package:weather/pages/home.dart';
import 'package:weather/repositories/weather_repository.dart';
import 'package:weather/services/weather_api_services.dart';

void main() async {
  await dotenv.load(fileName: '.env');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => WeatherRepository(
        weatherApiServices: WeatherApiServices(
          httpClient: http.Client(),
        ),
      ),
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (BuildContext context) => WeatherCubit(
              weatherRepository: context.read<WeatherRepository>(),
            ),
          ),
          BlocProvider(
            create: (BuildContext context) => TempSettingsCubit(),
          ),
          BlocProvider(
            create: (BuildContext context) => ThemeCubit(),
          ),
        ],
        child: BlocListener<WeatherCubit, WeatherState>(
          listener: (context, state) {
            context.read<ThemeCubit>().setTheme(state.weather.temp);
          },
          child: BlocBuilder<ThemeCubit, ThemeState>(
            builder: (context, state) {
              return MaterialApp(
                title: 'Weather',
                debugShowCheckedModeBanner: false,
                theme: state.appTheme == AppTheme.light
                    ? ThemeData.light()
                    : ThemeData.dark(),
                home: HomeScreen(),
              );
            },
          ),
        ),
      ),
    );
  }
}
