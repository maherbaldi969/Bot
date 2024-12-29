import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
String _apiKey="AIzaSyCjNVMYY2hZt6uN20B-DEsIRdrEj-dHbpA";

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ChatScreen(),
    );
  }
}
class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late final  GenerativeModel _model;
  late final ChatSession _chat;
  final ScrollController _scrollController =ScrollController();
  final TextEditingController _textController = TextEditingController();
  final List<ChatMessage> _messages =[];
  @override
  void initState(){
    super.initState();
    _model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: "AIzaSyCjNVMYY2hZt6uN20B-DEsIRdrEj-dHbpA");
    _chat = _model.startChat();

  }
  void _scrollDown() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 750), // Durée de l'animation
        curve: Curves.easeInOut, // Courbe de l'animation
      );
    });
  }
  Future<void> _sendChatMessage(String message) async {
    if (message.isEmpty) return; // Ne pas envoyer si le message est vide

    setState(() {
      _messages.add(ChatMessage(text: message, isUser: true));
    });

    try {
      final response = await _chat.sendMessage(Content.text(message));
      final text = response.text;

      if (text != null) {
        setState(() {
          _messages.add(ChatMessage(text: text, isUser: false));
        });
      } else {
        setState(() {
          _messages.add(ChatMessage(text: "No response received", isUser: false));
        });
      }
      _scrollDown(); // S'assurer de scroller après l'ajout du message
    } catch (e) {
      setState(() {
        _messages.add(ChatMessage(text: "Error occurred: $e", isUser: false));
      });
    } finally {
      _textController.clear(); // Vider le champ de texte après l'envoi
    }
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('ChatBot'),
        centerTitle: true,
        backgroundColor: Colors.green[900],
        elevation: 5.0,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return ListTile(
                  title: Align(
                    alignment: message.isUser
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: message.isUser
                            ? Colors.blue[200]
                            : Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        message.text,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Divider(height: 1),
          Padding(
            padding:  EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    onSubmitted: _sendChatMessage,
                    controller: _textController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.red[850],
                      hintText: "Type your message...",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => _sendChatMessage(_textController.text),
                  icon: Icon(Icons.send, color: Colors.blueAccent),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
class ChatMessage{
  final String text;
  final bool isUser;    // Indique si c'est l'utilisateur ou pas
  ChatMessage({required this.text, required this.isUser});
}
class ChatBubble extends StatelessWidget {
  final ChatMessage message;

  const ChatBubble({super.key,required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8,horizontal: 10),
      alignment: message.isUser ? Alignment.centerRight: Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width / 1.25,
        ),
        padding: EdgeInsets.symmetric(vertical: 10,horizontal: 14),
        decoration: BoxDecoration(
            color: message.isUser ? Colors.blue[200]: Colors.green[200],
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
              bottomLeft: message.isUser ? Radius.circular(12) :Radius.zero,
              bottomRight: message.isUser ? Radius.zero:Radius.circular(12),
            )
        ),
        child: Text(
          message.text,
          style: TextStyle(
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}

