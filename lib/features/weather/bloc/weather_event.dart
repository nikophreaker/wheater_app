part of 'weather_bloc.dart';

@immutable
abstract class WeatherEvent {}

class WeatherInitialFetchEvent extends WeatherEvent {
  final double lat;
  final double lon;
  WeatherInitialFetchEvent({required this.lat, required this.lon});
}
