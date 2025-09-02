import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'bus_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://ddjecxltxnxfqfahlmol.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRkamVjeGx0eG54ZnFmYWhsbW9sIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTY3MTQyOTEsImV4cCI6MjA3MjI5MDI5MX0.oiWOauTNQANpThHm5bU7i2p93qulfGJOdyHO-Yf5V0Q',
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'City Bus App',
      home: BusScreen(),
    );
  }
}
