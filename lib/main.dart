import 'package:digital_wind/features/auth/presentation/pages/login_page.dart';
import 'package:digital_wind/features/game/presentation/pages/game_page.dart';
import 'package:digital_wind/features/menu/presentation/pages/quick_menu_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'features/auth/data/store/auth_store.dart';
import 'features/endings/data/api/endings_api.dart';
import 'features/endings/data/store/endings_store.dart';
import 'features/menu/presentation/pages/main_menu_page.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthStore()),
        ChangeNotifierProvider(create: (_) => EndingsStore(endingApi: EndingsApi(client: http.Client())))
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Neo History Quest',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.white, fontFamily: 'Courier'),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          border: InputBorder.none,
          hintStyle: TextStyle(color: Colors.grey),
        ),
      ),
      home: const LoginPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}