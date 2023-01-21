import 'package:clinic_appointment_chatbot/providers/chatbot_provider.dart';
import 'package:clinic_appointment_chatbot/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ChatbotProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Clinic Appointment Booking',
      theme: ThemeData(
        brightness: WidgetsBinding.instance.window.platformBrightness,
        primarySwatch: Colors.blue,
      ),
      home: const HomeScreen(),
    );
  }
}
