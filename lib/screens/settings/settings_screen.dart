import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/cubits/temp_settings/temp_settings_cubit.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});
  static const String id = 'settings screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings Screen'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 10,
        ),
        child: ListTile(
          title: const Text('Temperature Unit'),
          subtitle: const Text('Celsius/Farenheit (Default: Celcius)'),
          trailing: Switch.adaptive(
            value: context.watch<TempSettingsCubit>().state.tempUnit ==
                TempUnit.celcius,
            onChanged: (_) {
              context.read<TempSettingsCubit>().toggleTempSettings();
            },
          ),
        ),
      ),
    );
  }
}
