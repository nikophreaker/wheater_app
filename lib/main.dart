import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:weather_app/features/weather/ui/weather_page.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Color(0xff4A4A4A),
  ));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final rootScaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Location Demo',
      debugShowCheckedModeBanner: false,
      scaffoldMessengerKey: rootScaffoldMessengerKey,
      theme: ThemeData(
          fontFamily: 'Montserrat',
          textTheme: const TextTheme(
            bodyLarge: TextStyle(),
            bodyMedium: TextStyle(),
            bodySmall: TextStyle(),
          ).apply(
            bodyColor: Colors.white,
            displayColor: Colors.orange,
          ),
          colorScheme: const ColorScheme(
              background: Color(0xff4A4A4A),
              brightness: Brightness.light,
              primary: Colors.orange,
              onPrimary: Colors.orange,
              secondary: Colors.orange,
              onSecondary: Colors.orange,
              error: Colors.orange,
              onError: Colors.orange,
              onBackground: Colors.orange,
              surface: Color(0xff4A4A4A),
              onSurface: Colors.orange)),
      home: WeatherPage(
          scaffoldMessengerState: rootScaffoldMessengerKey.currentState),
    );
  }
}
