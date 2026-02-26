import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'routes/app_routes.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Nikita Messenger',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Inter',
      ),
      darkTheme: ThemeData.dark().copyWith(
        primarySwatch: Colors.blue,
        brightness: Brightness.dark,
        fontFamily: 'Inter',
      ),
      themeMode: ThemeMode.system,
      routerConfig: AppRouter.router,
    );
  }
}