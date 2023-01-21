import 'package:clinic_appointment_chatbot/providers/chatbot_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class MessagesList extends StatelessWidget {
  const MessagesList({super.key});

  @override
  Widget build(BuildContext context) {
    List messages =
        Provider.of<ChatbotProvider>(context).messages.reversed.toList();
    double w = MediaQuery.of(context).size.width;

    return messages.isEmpty
        ? Center(
            child: Text("Send 'Hi' to start chatting with the chatbot.",
                textAlign: TextAlign.center,
                style: GoogleFonts.lato(
                    fontSize: 18,
                    fontStyle: FontStyle.italic,
                    color: Colors.grey.shade500)),
          )
        : ListView.separated(
            reverse: true,
            itemBuilder: (context, index) {
              bool isUser = messages[index]['isUserMessage'];

              return Container(
                margin: EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment:
                      isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
                  children: [
                    Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 14, horizontal: 14),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(
                                20,
                              ),
                              topRight: Radius.circular(20),
                              bottomRight: Radius.circular(isUser ? 0 : 20),
                              topLeft: Radius.circular(isUser ? 20 : 0),
                            ),
                            color: isUser ? Colors.blue : Color(0xffe5e5e5)),
                        constraints: BoxConstraints(maxWidth: w * 2 / 3),
                        child: Text(messages[index]['message'].text.text[0],
                            style: GoogleFonts.poppins(
                                color: isUser ? Colors.white : Colors.black87,
                                fontSize: 14))),
                  ],
                ),
              );
            },
            separatorBuilder: (_, i) =>
                Padding(padding: EdgeInsets.only(top: 10)),
            itemCount: messages.length);
  }
}
