import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'features/auth/data/store/auth_store.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/auth/presentation/pages/register_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AuthStore(),
      child: MaterialApp(
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
        home: const AuthWrapper(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool showRegister = false;

  @override
  Widget build(BuildContext context) {
    final authStore = Provider.of<AuthStore>(context);

    if (authStore.isAuthenticated) {
      // Основной экран квеста после аутентификации
      return const Placeholder();
    }

    return showRegister
        ? RegisterPage(onLoginPressed: () => setState(() => showRegister = false))
        : LoginPage(onRegisterPressed: () => setState(() => showRegister = true));
  }
}