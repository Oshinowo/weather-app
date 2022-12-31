import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:weather_app/models/custom_error.dart';
import 'package:weather_app/models/weather.dart';
import 'package:weather_app/repositories/weather_repository.dart';

part 'weather_event.dart';
part 'weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final WeatherRepository weatherRepository;

  WeatherBloc({required this.weatherRepository})
      : super(WeatherState.initial()) {
    on<FetchWeatherEvent>(_fetchWeather);
  }

  Future<void> _fetchWeather(
      FetchWeatherEvent event, Emitter<WeatherState> emit) async {
    emit(state.copyWith(weatherStatus: WeatherStatus.loading));

    try {
      final weather = await weatherRepository.fetchWeather(event.cityName);
      emit(state.copyWith(
          weatherStatus: WeatherStatus.loaded, weather: weather)); 
    } on CustomError catch (e) {
      emit(state.copyWith(weatherStatus: WeatherStatus.error, error: e));
    }
  }
}
