import 'package:flutter/material.dart';
import 'core/thema.dart';
import 'core/routes.dart';

void main() {
  runApp(const DocLineApp());
}

class DocLineApp extends StatelessWidget {
  const DocLineApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: appTheme,
      initialRoute: AppRoutes.login,
      routes: AppRoutes.routes,
    );
  }
}
