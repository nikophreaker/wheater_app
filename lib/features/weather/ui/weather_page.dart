import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_app/features/weather/bloc/weather_bloc.dart';
import 'package:intl/intl.dart';

class WeatherPage extends StatefulWidget {
  final ScaffoldMessengerState? scaffoldMessengerState;

  const WeatherPage({Key? key, required this.scaffoldMessengerState})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _LocationPageState();
}

class _LocationPageState extends State<WeatherPage> {
  Position? _currentPosition;

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      widget.scaffoldMessengerState?.showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        widget.scaffoldMessengerState?.showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      widget.scaffoldMessengerState?.showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();
    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() => _currentPosition = position);
    }).catchError((e) {
      debugPrint(e);
    });
  }

  final WeatherBloc weatherBloc = WeatherBloc();

  @override
  void initState() {
    _getCurrentPosition();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    weatherBloc.add(WeatherInitialFetchEvent(
        lat: _currentPosition?.latitude ?? 0,
        lon: _currentPosition?.longitude ?? 0));
    return Scaffold(
      body: BlocConsumer<WeatherBloc, WeatherState>(
        bloc: weatherBloc,
        listenWhen: (previous, current) => current is WeatherActionState,
        buildWhen: (previous, current) => current is! WeatherActionState,
        listener: (context, state) {},
        builder: (context, state) {
          switch (state.runtimeType) {
            case WeatherFetchingLoadingState:
              return const Center(child: CircularProgressIndicator());
            case WeatherSuccessFetch:
              final data = state as WeatherSuccessFetch;
              return SafeArea(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 25.0, bottom: 50.0, left: 15.0, right: 15.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                                style: const TextStyle(fontSize: 14),
                                DateFormat('E, d MMM y').format(
                                    DateTime.fromMillisecondsSinceEpoch(
                                        (data.weather?.dt ?? 0) * 1000))),
                            Text(
                                style: const TextStyle(fontSize: 14),
                                DateFormat.Hm().format(
                                    DateTime.fromMillisecondsSinceEpoch(
                                        (data.weather?.dt ?? 0) * 1000))),
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 40),
                                data.weather?.name ?? ""),
                            Padding(
                              padding: const EdgeInsets.only(top: 40.0, bottom: 40.0),
                              child: Container(
                                width: 240,
                                height: 240,
                                decoration: const BoxDecoration(
                                    color: Color(0xffA6A6A6),
                                    shape: BoxShape.circle),
                                child: Center(
                                  child: Column(
                                    children: [
                                      Image.network(
                                          scale: 0.8,
                                          'https://openweathermap.org/img/wn/${data.weather?.weather[0].icon ?? '01n'}@2x.png'),
                                      Text(
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w300,
                                              fontSize: 44),
                                          "${data.weather?.main.temp.toString() ?? "-"}℃"),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Text(
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                                data.weather?.weather[0].description
                                        .toString() ??
                                    "-"),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                const Text(
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14),
                                    "Wind Speed"),
                                Text(
                                    style: const TextStyle(fontSize: 20),
                                    data.weather?.wind.speed.toString() ?? "-"),
                              ],
                            ),
                            Column(
                              children: [
                                const Text(
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14),
                                    "Humidity"),
                                Text(
                                    style: const TextStyle(fontSize: 20),
                                    data.weather?.main.humidity.toString() ??
                                        "-"),
                              ],
                            ),
                            Column(
                              children: [
                                const Text(
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14),
                                    "Visibility"),
                                Text(
                                    style: const TextStyle(fontSize: 20),
                                    data.weather?.visibility.toString() ?? "-"),
                              ],
                            ),
                            Column(
                              children: [
                                const Text(
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14),
                                    "Air Pressure"),
                                Text(
                                    style: const TextStyle(fontSize: 20),
                                    data.weather?.main.pressure.toString() ??
                                        "-"),
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              );
            case WeatherFetchingErrorState:
              return const SizedBox();
            default:
              return Container();
          }
        },
      ),
    );
  }
}
