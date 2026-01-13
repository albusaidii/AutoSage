import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  List<Map<String, String>> messages = [];
  bool isLoading = false;

  // ✅ Helper: detect numeric-only input
  bool _isNumericOnly(String text) {
    return RegExp(r'^\s*\d+\s*$').hasMatch(text);
  }

  Future<void> sendMessage() async {
    final trimmed = _controller.text.trim();
    if (trimmed.isEmpty) return;

    // BLOCK numeric-only messages
    if (_isNumericOnly(trimmed)) {
      setState(() {
        messages.add({
          "sender": "bot",
          "text": "Please describe the issue using words, not only numbers.",
        });
      });
      _controller.clear();
      _scrollToBottom();
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt("userId");

    if (userId == null) {
      throw Exception("User not logged in");
    }


    final userMessage = trimmed;
    _controller.clear();

    setState(() {
      messages.add({"sender": "user", "text": userMessage});
      isLoading = true;
    });
    _scrollToBottom();

    try {
      final response = await http.post(
        Uri.parse("http://10.0.2.2:3000/api/diagnose"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "user_id": userId, // placeholder
          "message": userMessage,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data["diagnosis"] != null &&
            data["diagnosis"]["description"] != null) {
          setState(() {
            messages.add({
              "sender": "bot",
              "text": data["diagnosis"]["description"],
            });
          });
        } else {
          setState(() {
            messages.add({
              "sender": "bot",
              "text": "Sorry, I received an unusual response from the server.",
            });
          });
        }
      } else {
        final errorData = jsonDecode(response.body);
        setState(() {
          messages.add({
            "sender": "bot",
            "text": errorData["error"] ?? "An unknown server error occurred.",
          });
        });
      }
    } catch (_) {
      setState(() {
        messages.add({
          "sender": "bot",
          "text":
          "Could not connect to the server. Please check your network connection.",
        });
      });
    } finally {
      setState(() => isLoading = false);
      _scrollToBottom();
    }

  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("AutoSage Chatbot"),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[index];
                final isUser = msg["sender"] == "user";
                final isDark = Theme.of(context).brightness == Brightness.dark;

                return Align(
                  alignment:
                  isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.all(8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isUser
                          ? Theme.of(context)
                          .primaryColor
                          .withOpacity(0.9)
                          : (isDark
                          ? const Color(0xFF373737)
                          : Colors.grey[300]),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      msg["text"]!,
                      style: TextStyle(
                        color: isUser
                            ? Colors.white
                            : (isDark ? Colors.white : Colors.black),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          if (isLoading)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 16,
                    width: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  SizedBox(width: 12),
                  Text("Diagnosing issue..."),
                ],
              ),
            ),

          _buildChatInput(),
        ],
      ),
    );
  }

  Widget _buildChatInput() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      color: isDark ? const Color(0xFF1F1F1F) : Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              onSubmitted: (_) => sendMessage(),
              style: const TextStyle(color: Colors.black),
              decoration: InputDecoration(
                hintText: "Describe your car's issue...",
                hintStyle: TextStyle(color: Colors.grey[600]),
                filled: true,
                fillColor: isDark ? Colors.grey[800] : Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
                contentPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.send_rounded),
            color: Theme.of(context).primaryColor,
            onPressed: sendMessage,
          ),
        ],
      ),
    );
  }
}
