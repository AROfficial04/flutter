import 'dart:convert';

import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:http/http.dart' as http;
import 'package:speech_to_text/speech_to_text.dart';

class ChatBot extends StatefulWidget {
  const ChatBot({Key? key}) : super(key: key);

  @override
  State<ChatBot> createState() => _ChatBotState();
}

class _ChatBotState extends State<ChatBot> {


  SpeechToText speechToText = SpeechToText();
  var text = "";
  var isListening = false;
  ChatUser myself = ChatUser(id: '1', firstName: 'Bhavesh');
  ChatUser bot = ChatUser(id: '2', firstName: 'Ultron');
  List<ChatMessage> allMessages = [];
  List<ChatUser> typing = [];

  final mUrl =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=AIzaSyAKFujneoX4Z_Nq0PNAmaaKU4TYmMhGpjk';
  final header = {'Content-Type': 'application/json'};

  getData(ChatMessage m) async {
    typing.add(bot);
    allMessages.insert(0, m);
    setState(() {});
    var data = {
      "contents": [
        {
          "parts": [
            {"text": m.text}
          ]
        }
      ]
    };
    await http
        .post(Uri.parse(mUrl), headers: header, body: jsonEncode(data))
        .then((value) {
      if (value.statusCode == 200) {
        var result = jsonDecode(value.body);
        print(result['candidates'][0]['content']['parts'][0]['text']);

        ChatMessage m1 = ChatMessage(
          text: result['candidates'][0]['content']['parts'][0]['text'],
          user: bot,
          createdAt: DateTime.now(),
        );
        allMessages.insert(0, m1);

        speak(result['candidates'][0]['content']['parts'][0]['text']);
        setState(() {});
      } else {
        print('Error Occurred');
      }
    }).catchError((e) {});
    typing.remove(bot);
    setState(() {});
  }

  FlutterTts flutterTts = FlutterTts();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/bg10.jpg'), fit: BoxFit.cover)
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            'AIASSBOT',
            style: TextStyle(fontSize: 25,
                color: Colors.white,

                letterSpacing: 3),
          ),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Expanded(
                child: DashChat(
                  inputOptions: InputOptions(
                    cursorStyle: CursorStyle(color: Colors.black),
                  ),
                  messageOptions: MessageOptions(
                      containerColor: Colors.white70,
                      currentUserTextColor: Colors.black,
                      currentUserContainerColor: Colors.grey[200],timeFontSize: 40,
                     avatarBuilder: avatAr
                  ),
                  typingUsers: typing,

                  currentUser: myself,
                  onSend: (ChatMessage m) {
                    getData(m);
                  },
                  messages: allMessages,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,

                children: [
                  FloatingActionButton(
                    onPressed: _toggleListening,
                    child: Icon(isListening ? Icons.mic : Icons.mic_none),
                    backgroundColor: Colors.grey[300], elevation: 10,
                  ),
                  FloatingActionButton(
                    onPressed: () {
                      flutterTts.stop();
                    },
                    child: Icon(Icons.stop),
                    backgroundColor: Colors.grey[300], elevation: 10,
                  ),
                ],
              ),

            ],
          ),
        ),
      ),
    );
  }
  Widget avatAr(ChatUser user, Function? function,Function? onAvatarPress){
    return SizedBox(
      height: 50,
      child: CircleAvatar(
          radius: 30,backgroundImage: AssetImage('assets/images/avatar.jpeg'),
          ),
    );
  }

  void _toggleListening() async {
    if (!isListening) {
      bool available = await speechToText.initialize(
        onError: (error) => print('Error: $error'),
      );

      if (available) {
        setState(() {
          isListening = true;
        });
        speechToText.listen(
          onResult: (result) {
            setState(() {
              text = result.recognizedWords;
            });
          },
        );
      } else {
        print('Speech recognition not available');
      }
    } else {
      setState(() {
        isListening = false;
      });
      speechToText.stop();
      // allMessages.add(
      //   ChatMessage(
      //     text: text,
      //     user: myself,
      //     createdAt: DateTime.now(),
      //
      //   ),
      //
      // );

      getData(
        ChatMessage(
          text: text.isEmpty ? 'dont reply wait' : text,
          user: myself,
          createdAt: DateTime.now(),
        ),
      );
    }
  }

  Future<void> speak(String text) async {
    await flutterTts.setLanguage("en-IN");
    await flutterTts.setPitch(1);
    await flutterTts.setSpeechRate(0.5);
    String cleanedText = _removeSigns(text);
    await flutterTts.speak(cleanedText);
  }

  String _removeSigns(String text) {
    // Define signs to be removed
    String signs = r'[!@#$%^&*(),.?":{}|<>]';

    // Remove signs from text
    return text.replaceAll(RegExp(signs), '');
  }
}

