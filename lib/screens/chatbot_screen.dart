import 'package:clinic_appointment_chatbot/providers/chatbot_provider.dart';
import 'package:clinic_appointment_chatbot/screens/messages.dart';
import 'package:dialog_flowtter/dialog_flowtter.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  _ChatbotScreenState createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<ChatbotProvider>(context, listen: false);
    DialogFlowtter.fromFile()
        .then((instance) => provider.dialogFlowtter = instance);
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ChatbotProvider>(context);
    void submitMessage() {
      if (_controller.text == "clear") {
        _controller.clear();
        provider.clearMessages();
        return;
      }
      if (provider.isLoading) return;
      provider.sendMessage(_controller.text);
      _controller.clear();
    }

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Clinic Chatbot'),
        ),
        body: Column(
          children: [
            Expanded(
              child: MessagesList(),
            ),
            Material(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                color: Theme.of(context).scaffoldBackgroundColor,
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                            hintText: "Write your message here..",
                            hintStyle: GoogleFonts.poppins(
                                fontSize: 15, color: Colors.grey)),
                        controller: _controller,
                        onEditingComplete: submitMessage,
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                        ),
                      ),
                    ),
                    SizedBox(
                        width: 50,
                        child: Center(
                          child: provider.isLoading
                              ? LoadingAnimationWidget.prograssiveDots(
                                  color: Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? Colors.white
                                      : Colors.black54,
                                  size: 22)
                              : IconButton(
                                  color: Colors.blue,
                                  disabledColor: Colors.black26,
                                  onPressed: submitMessage,
                                  icon: Icon(
                                    Icons.send,
                                    // color: Colors.black87,
                                  ),
                                ),
                        ))
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
