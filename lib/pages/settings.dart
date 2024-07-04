import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather/blocs/blocs.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 10,
        ),
        child: ListTile(
          title: Text('Temperature Unit'),
          subtitle: Text('Celsius/fahrenheit (Default: Celsius)'),
          trailing: BlocBuilder<TempSettingsBloc, TempSettingsState>(
            builder: (context, state) {
              return Switch(
                value: state.tempUnit == TempUnit.celsius,
                onChanged: (value) {
                  print(value);
                  if (value == true) {
                    context.read<TempSettingsBloc>().add(
                        ToggleTempSettingsEvent(tempUnit: TempUnit.celsius));
                  } else {
                    context.read<TempSettingsBloc>().add(
                        ToggleTempSettingsEvent(tempUnit: TempUnit.fahrenheit));
                  }
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
