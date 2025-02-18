import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ukk_2025/splash.dart';

String supabeseUrl = 'https://wfrpnwnzpcgtvkhyhnox.supabase.co';
String supabeseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6IndmcnBud256cGNndHZraHlobm94Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mzk0MDg4ODEsImV4cCI6MjA1NDk4NDg4MX0.xzf_Zmzs45M3CJ7YCTr2-CcaTa0dPQ4QtwfPudiqxWQ';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url:'https://wfrpnwnzpcgtvkhyhnox.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6IndmcnBud256cGNndHZraHlobm94Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mzk0MDg4ODEsImV4cCI6MjA1NDk4NDg4MX0.xzf_Zmzs45M3CJ7YCTr2-CcaTa0dPQ4QtwfPudiqxWQ',
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Splash(),
    );
  }
}