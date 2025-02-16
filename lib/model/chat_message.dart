import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class ChatMessage {
  final String messageId;
  final String content;
  final bool isUser;
  final DateTime timestamp;
  final bool isPending;

  ChatMessage({
    required this.messageId,
    required this.content,
    required this.isUser,
    required this.timestamp,
    this.isPending = false,
  });
}