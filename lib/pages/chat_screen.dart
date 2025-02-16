import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project1/model/chat_message.dart';
import 'package:project1/services/gemini_service.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textController = TextEditingController();
  final List<ChatMessage> _messages = [];
  final GeminiService _geminiService = GeminiService();
  final String _systemInstruction = "You must answer in a conversational way. You must only answer questions that are related to asking for help in social connections, if the question is not related, say sorry this is outside what i can answer, instead";

  @override
  void initState() {
    super.initState();

  }

  void _sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    _textController.clear();

    setState(() {
      _messages.add(ChatMessage(
          messageId: const Uuid().v4(),
          content: text,
          isUser: true,
          timestamp: DateTime.now()));
      _messages.add(ChatMessage(
          messageId: const Uuid().v4(),
          content: "",
          isUser: false,
          timestamp: DateTime.now(),
          isPending: true));
    });

    String response = await _geminiService.sendMessage(
        _messages.map((e) => e.content).toList(), _systemInstruction);

    setState(() {
      _messages.removeWhere((element) => element.isPending);
      _messages.add(ChatMessage(
          messageId: const Uuid().v4(),
          content: response,
          isUser: false,
          timestamp: DateTime.now()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Assistant'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return _buildMessage(message);
              },
            ),
          ),
          _buildInput(),
        ],
      ),
    );
  }

  Widget _buildMessage(ChatMessage message) {
    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: message.isUser ? Colors.blue[100] : Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (message.isPending)
              Center(child: CircularProgressIndicator())
            else
              MarkdownBody(
                data: message.content,
              ),
            SizedBox(height: 4),
            Text(
              DateFormat('HH:mm').format(message.timestamp),
              style: TextStyle(fontSize: 10, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInput() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _textController,
              decoration: InputDecoration(
                hintText: 'Enter your message',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: () => _sendMessage(_textController.text),
          ),
        ],
      ),
    );
  }
}