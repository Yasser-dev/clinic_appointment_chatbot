import 'package:flutter/material.dart';
import 'package:dialog_flowtter/dialog_flowtter.dart';

class ChatbotProvider with ChangeNotifier {
  late DialogFlowtter _dialogFlowtter;
  List<Map<String, dynamic>> _messages = [];
  bool _isLoading = false;

  DialogFlowtter get dialogFlowtter => _dialogFlowtter;
  List<Map<String, dynamic>> get messages => _messages;
  bool get isLoading => _isLoading;

  set dialogFlowtter(DialogFlowtter dialogFlowtter) {
    _dialogFlowtter = dialogFlowtter;
    notifyListeners();
  }

  set messages(List<Map<String, dynamic>> messages) {
    _messages = messages;
    notifyListeners();
  }

  set isLoading(bool isLoading) {
    _isLoading = isLoading;
    notifyListeners();
  }

  sendMessage(String text) async {
    if (text.isNotEmpty) {
      addMessage(Message(text: DialogText(text: [text])), true);
      isLoading = true;

      try {
        final response = await dialogFlowtter.detectIntent(
          queryInput: QueryInput(text: TextInput(text: text)),
        );
        if (response.message == null) return;
        addMessage(response.message!);
      } catch (e) {
        addMessage(
          Message(
              text: DialogText(text: const [
            "There is an issue connecting to our client, please check that your connection is stable.",
          ])),
          false,
          true,
        );
      } finally {
        isLoading = false;
      }
    }
  }

  clearMessages() {
    messages = [];
  }

  addMessage(Message message,
      [bool isUserMessage = false, bool error = false]) {
    messages.add(
      {'message': message, 'isUserMessage': isUserMessage, 'error': error},
    );
  }
}
