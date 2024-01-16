import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:weather_app/features/weather/models/weather_data_ui_model.dart';
import 'package:weather_app/features/weather/repos/weather_repo.dart';

part 'weather_event.dart';

part 'weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  WeatherBloc() : super(WeatherInitial()) {
    on<WeatherInitialFetchEvent>(weatherInitialFetchEvent);
  }

  FutureOr<void> weatherInitialFetchEvent(
      WeatherInitialFetchEvent event, Emitter<WeatherState> emit) async {
    emit(WeatherFetchingLoadingState());
    WeatherDataUiModel? weather = await WeatherRepo.fetchWeather(event.lat,event.lon);
    emit(WeatherSuccessFetch(weather: weather));
  }
}
