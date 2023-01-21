import 'package:clinic_appointment_chatbot/screens/chatbot_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset("assets/home_asset.png"),
            // Instruction text
            const SizedBox(
              height: 24,
            ),

            Text(
              "Welcome to the Clinic Booking App!",
              textAlign: TextAlign.center,
              style: GoogleFonts.lato(
                fontSize: 20.0,
              ),
            ),
            const SizedBox(
              height: 6,
            ),
            Text(
              "Click the button below to chat with our booking assistant.",
              textAlign: TextAlign.center,
              style: GoogleFonts.lato(
                fontSize: 18.0,
                color: Colors.grey,
              ),
            ),
            const SizedBox(
              height: 44,
            ),
            // Chat button
            Row(
              children: [
                Expanded(
                    child: ElevatedButton.icon(
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all<EdgeInsets>(
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ChatbotScreen(),
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.support_agent,
                    size: 24.0,
                  ),
                  label: Text(
                    'Chat',
                    style: GoogleFonts.poppins(fontSize: 22),
                  ), // <-- Text
                )),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
