// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:weather_app/models/custom_error.dart';
import 'package:weather_app/models/weather.dart';
import 'package:weather_app/repositories/weather_repository.dart';

part 'weather_state.dart';

class WeatherCubit extends Cubit<WeatherState> {
  final WeatherRepository weatherRepository;
  WeatherCubit({required this.weatherRepository})
      : super(WeatherState.initial());

  Future<void> fetchWeather(String city) async {
    emit(state.copyWith(weatherStatus: WeatherStatus.loading));
    try {
      final Weather weather = await weatherRepository.fetchWeather(city);
      emit(state.copyWith(
        weatherStatus: WeatherStatus.loaded,
        weather: weather,
      ));
      print('state: $state');
    } on CustomError catch (e) {
      emit(state.copyWith(weatherStatus: WeatherStatus.error, error: e));
      print('state: $state');
    }
  }
}
