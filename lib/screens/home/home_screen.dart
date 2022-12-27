import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/constants/constants.dart';
import 'package:weather_app/cubits/temp_settings/temp_settings_cubit.dart';
import 'package:weather_app/cubits/weather/weather_cubit.dart';
import 'package:weather_app/screens/search/search_screen.dart';
import 'package:weather_app/screens/settings/settings_screen.dart';
import 'package:weather_app/utils/error_dialog.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  static const String id = 'home';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? _city;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather'),
        actions: [
          IconButton(
            onPressed: () async {
              _city = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SearchScreen(),
                  ));
              // print('city: $_city');
              if (!mounted) return;
              if (_city != null) {
                context.read<WeatherCubit>().fetchWeather(_city!);
              }
            },
            icon: const Icon(
              Icons.search,
            ),
          ),
          IconButton(
            onPressed: () => Navigator.of(context).pushNamed(
              SettingsScreen.id,
            ),
            icon: const Icon(
              Icons.settings,
            ),
          ),
        ],
      ),
      body: _showWeather(),
    );
  }

  Widget _showWeather() {
    return BlocConsumer<WeatherCubit, WeatherState>(
      listener: (context, state) {
        if (state.weatherStatus == WeatherStatus.error) {
          errorDialog(context, state.error.errMsg);
        }
      },
      builder: (context, state) {
        if (state.weatherStatus == WeatherStatus.initial) {
          return const Center(
            child: Text(
              'Select a City',
              style: TextStyle(fontSize: 20.0),
            ),
          );
        }

        if (state.weatherStatus == WeatherStatus.loading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (state.weatherStatus == WeatherStatus.error &&
            state.weather.name == '') {
          return const Center(
            child: Text(
              'Select a City',
              style: TextStyle(fontSize: 20.0),
            ),
          );
        }

        return ListView(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height / 6,
            ),
            Text(
              state.weather.name,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  TimeOfDay.fromDateTime(state.weather.lastUpdated)
                      .format(context),
                  style: const TextStyle(fontSize: 18.0),
                ),
                const SizedBox(
                  width: 10.0,
                ),
                Text(
                  '(${state.weather.country})',
                  style: const TextStyle(fontSize: 18.0),
                ),
              ],
            ),
            const SizedBox(
              height: 60,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(showTemperature(state.weather.temp),
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    )),
                const SizedBox(
                  width: 20,
                ),
                Column(
                  children: [
                    Text(
                      showTemperature(state.weather.tempMax),
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      showTemperature(state.weather.tempMin),
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ],
                )
              ],
            ),
            const SizedBox(
              height: 40,
            ),
            Row(
              children: [
                const Spacer(),
                showIcon(state.weather.icon),
                Expanded(
                  flex: 3,
                  child: Text(
                    state.weather.description,
                    style: const TextStyle(fontSize: 24),
                    textAlign: TextAlign.center,
                  ),
                ),
                const Spacer()
              ],
            )
          ],
        );
      },
    );
  }

  String showTemperature(double temp) {
    final tempUnit = context.watch<TempSettingsCubit>().state.tempUnit;
    if (tempUnit == TempUnit.farenheit) {
      return '${((temp * 9 / 5) + 32).toStringAsFixed(2)}℉';
    }
    return '${temp.toStringAsFixed(2)}℃';
  }

  Widget showIcon(String icon) {
    return FadeInImage.assetNetwork(
      placeholder: 'assets/loading.gif',
      image: 'https://$kIconHost/img/wn/$icon@4x.png',
      width: 95,
      height: 95,
    );
  }
}
