import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spinning_wheel/screen/name_input_screen.dart';
import 'package:spinning_wheel/state_provider/names_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NameProvider()),
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
      title: 'Random Spinner',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const NameInputScreen(),
    );
  }
}
