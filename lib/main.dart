import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'blocs/blocs.dart';
import 'repositories/weather_repository.dart';
import 'screens/home/home_screen.dart';
import 'screens/search/search_screen.dart';
import 'screens/settings/settings_screen.dart';
import 'services/weather_api_services.dart';
import 'package:http/http.dart' as http;

void main() async {
  await dotenv.load(fileName: '.env');
  runApp(
    RepositoryProvider(
      create: (context) => WeatherRepository(
        weatherApiServices: WeatherApiServices(
          httpClient: http.Client(),
        ),
      ),
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => WeatherBloc(
              weatherRepository: context.read<WeatherRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) => TempSettingsBloc(),
          ),
          BlocProvider(
            create: (context) => ThemeBloc(),
          )
        ],
        child: const WeatherApp(),
      ),
    ),
  );
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<WeatherBloc, WeatherState>(
      listener: (context, state) {
        context.read<ThemeBloc>().setTheme(state.weather.temp);
      },
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: state.appTheme == AppTheme.light
                ? ThemeData.light().copyWith(
                    visualDensity: VisualDensity.adaptivePlatformDensity,
                  )
                : ThemeData.dark().copyWith(
                    visualDensity: VisualDensity.adaptivePlatformDensity,
                  ),
            initialRoute: HomeScreen.id,
            routes: {
              HomeScreen.id: (context) => const HomeScreen(),
              SearchScreen.id: (context) => const SearchScreen(),
              SettingsScreen.id: (context) => const SettingsScreen(),
            },
          );
        },
      ),
    );
  }
}
