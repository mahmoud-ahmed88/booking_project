import 'package:flutter/material.dart';
import 'core/thema.dart';
import 'core/config/routes/routes.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url:"https://kasnveeddkvvmyknzkpz.supabase.co" ,
    anonKey:"sb_publishable_JzKJah8OArz6BUe2f8RIFg_c4rKQs30" ,
  );

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
