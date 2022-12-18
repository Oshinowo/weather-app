import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:weather_app/screens/home/home_screen.dart';
import 'package:weather_app/screens/search/search_screen.dart';
import 'package:weather_app/screens/settings/settings_screen.dart';

void main() async {
  await dotenv.load(fileName: '.env');
  runApp(
    const WeatherApp(),
  );
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(visualDensity: VisualDensity.adaptivePlatformDensity),
      initialRoute: HomeScreen.id,
      routes: {
        HomeScreen.id: (context) => const HomeScreen(),
        SearchScreen.id: (context) => const SearchScreen(),
        SettingsScreen.id: (context) => const SettingsScreen(),
      },
    );
  }
}
