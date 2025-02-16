import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiService {
  late final GenerativeModel _model;
  late final ChatSession _chat;

  GeminiService() {
    _model = GenerativeModel(
        model: 'gemini-2.0-flash', apiKey: 'AIzaSyBs-hB-DcZ-iIcGHwcApovoZGnrDhaHXwI'); // Replace with your actual API key
    _chat = _model.startChat();
  }

  Future<String> sendMessage(
      List<String> messages, String systemInstruction) async {
    try {
      final List<Part> parts = [
        TextPart(systemInstruction),
        for (var message in messages) TextPart(message),
      ];
      final content = Content('user', parts);
      final response = await _chat.sendMessage(content);
      return response.text ?? "No response";
    } catch (e) {
      print('Error sending message: $e');
      return "Error sending message";
    }
  }
}