import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recase/recase.dart';
import 'package:weather/blocs/blocs.dart';
import 'package:weather/constants/constants.dart';
import 'package:weather/pages/search.dart';
import 'package:weather/pages/settings.dart';
import 'package:weather/widgets/erro_dialog.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  String? _city;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Weather',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              _city = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SearchScreen(),
                ),
              );

              if (_city != null) {
                context
                    .read<WeatherBloc>()
                    .add(FetchWeatherEvent(city: _city!));
              }
            },
            icon: Icon(
              Icons.search,
            ),
          ),
          IconButton(
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SettingsScreen(),
                ),
              );
            },
            icon: Icon(
              Icons.settings,
            ),
          )
        ],
      ),
      body: ShowWeather(),
    );
  }
}

String showTemperature(double temperature, BuildContext context) {
  String formatTemperate =
      context.watch<TempSettingsBloc>().state.tempUnit == TempUnit.celsius
          ? temperature.toStringAsFixed(2) + '℃'
          : ((temperature * 9 / 5) + 32).toStringAsFixed(2) + '℉';

  return formatTemperate;
}

class ShowWeather extends StatelessWidget {
  const ShowWeather({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WeatherBloc, WeatherState>(
      listener: (context, state) {
        if (state.status == WeatherStatus.error) {
          errorDialog(context, state.error.errMsg.toString());
        }
      },
      builder: (context, state) {
        if (state.status == WeatherStatus.initial) {
          return Center(
            child: Text(
              'Selected city',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          );
        }

        if (state.status == WeatherStatus.loading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state.status == WeatherStatus.error && state.weather.name == '') {
          return Center(
            child: Text(
              'Selected city',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          );
        }
        return ListView(
          children: [
            SizedBox(
              height: MediaQuery.sizeOf(context).height / 6,
            ),
            Text(
              state.weather.name,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  TimeOfDay.fromDateTime(state.weather.lastUpdated)
                      .format(context),
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                SizedBox(width: 10),
                Text(
                  '(${state.weather.country})',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  showTemperature(state.weather.temp, context),
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 20),
                Column(
                  children: [
                    Text(
                      showTemperature(state.weather.tempMin, context),
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      showTemperature(state.weather.tempMax, context),
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ShowIcon(icon: state.weather.icon),
                FormatText(description: state.weather.description),
              ],
            )
          ],
        );
      },
    );
  }
}

class ShowIcon extends StatelessWidget {
  const ShowIcon({super.key, required this.icon});
  final String icon;

  @override
  Widget build(BuildContext context) {
    return FadeInImage.assetNetwork(
      placeholder: 'assets/images/loading.gif',
      image: 'http://$kIconHost/img/wn/$icon@4x.png',
      height: 96,
      width: 96,
    );
  }
}

class FormatText extends StatelessWidget {
  const FormatText({super.key, required this.description});
  final String description;

  @override
  Widget build(BuildContext context) {
    final formatText = description.titleCase;
    return Text(
      formatText,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
