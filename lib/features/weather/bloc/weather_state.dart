part of 'weather_bloc.dart';

@immutable
abstract class WeatherState {}

abstract class WeatherActionState extends WeatherState {}

class WeatherInitial extends WeatherState {}

class WeatherFetchingLoadingState extends WeatherState {}

class WeatherFetchingErrorState extends WeatherState {}

class WeatherSuccessFetch extends WeatherState {
  final WeatherDataUiModel? weather;
  WeatherSuccessFetch({required this.weather});
}