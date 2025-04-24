import 'package:digital_wind/features/endings/presentation/pages/all_endings_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'features/auth/data/store/auth_store.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/auth/presentation/pages/register_page.dart';
import 'features/endings/data/store/endings_store.dart';
import 'features/main_menu/presentation/pages/main_menu_page.dart';
import 'features/quest/presentation/pages/quest_page.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthStore()),
        ChangeNotifierProvider(create: (_) => EndingsStore()),
      ],
      child: const MyApp(),
    ),
  );
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
      return MainMenuPage(
        onPlayPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const QuestPage()),
          );
        },
        // onEndingsPressed: () async {
        //   try {
        //     final endingsStore = Provider.of<EndingsStore>(context, listen: false);
        //     await endingsStore.loadEndings(authStore.token!);
        //
        //     if (mounted) {
        //       Navigator.of(context).push(
        //         MaterialPageRoute(
        //           builder: (_) => AllEndingsPage(
        //             endings: endingsStore.endings,
        //             onExitPressed: () => Navigator.of(context).pop(),
        //           ),
        //         ),
        //       );
        //     }
        //   } catch (e) {
        //     if (mounted) {
        //       ScaffoldMessenger.of(context).showSnackBar(
        //         SnackBar(content: Text('Ошибка загрузки концовок: ${e.toString()}')),
        //       );
        //     }
        //   }
        // },
        onEndingsPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => AllEndingsPage(
                endings: ["концовка слона", 'концовка бурильщика'],
                onExitPressed: () => Navigator.of(context).pop(),
              ),
            ),
          );
        },
        onLogoutPressed: () async {
          await authStore.logout();
          if (mounted) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const AuthWrapper()),
            );
          }
        },
      );
    }

    return showRegister
        ? RegisterPage(onLoginPressed: () => setState(() => showRegister = false))
        : LoginPage(onRegisterPressed: () => setState(() => showRegister = true));
  }
}