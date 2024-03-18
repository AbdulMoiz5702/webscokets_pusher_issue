import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:webscokets_pusker_issue/text_widgets.dart';

import 'api_controller.dart';
import 'colors.dart';


class MessagingScreen extends StatefulWidget {
  final String userId;
  final String userName;

  MessagingScreen({required this.userId, required this.userName});

  @override
  _MessagingScreenState createState() => _MessagingScreenState();
}

class _MessagingScreenState extends State<MessagingScreen> {
  late WebSocketChannel webSocketChannel; // Declare WebSocketChannel
  final TextEditingController messageController = TextEditingController();
  late Stream<List<dynamic>> _messageStream;
  late StreamController<List<dynamic>> _streamController;

  List<dynamic> currentMessages = [];

  @override
  void initState() {
    super.initState();
    _streamController = StreamController<List<dynamic>>();
    _messageStream = _streamController.stream;
    initializeWebSocket();
    fetchMessages(widget.userId);
  }

  void initializeWebSocket() async {
    try {
      String app_id = "1769136";
      String key = "5cb9bd0682b65ca9d279";
      String cluster = "ap3";
      String url = "wss://ws-$cluster.pusher.com/app/$app_id?client=$key&cluster=$cluster";

      webSocketChannel = IOWebSocketChannel.connect(Uri.parse(url)); // Establish WebSocket connection
      print('WebSocket connected successfully.');
      webSocketChannel.stream.listen((dynamic data) {
        print('Received message: $data');
        currentMessages.add(jsonDecode(data));
        _streamController.add(List.from(currentMessages));
      });
    } catch (e, s) {
      print('Error connecting to WebSocket: $e');
      print('Error stack trace: $s');
    }
  }



  Future<void> fetchMessages(userID) async {
    final response = await http.get(Uri.parse('${ApiServices.fetchMessageapi}=$userID'));
    if (response.statusCode == 200) {
      Map<String, dynamic> responseData = jsonDecode(response.body);
      List<dynamic> receivedMessages = responseData['data'];
      _streamController.add(receivedMessages);
    } else {
      throw Exception('Failed to load messages');
    }
  }

  Future<void> sendMessage(String userId, String message) async {
    try {
      final response = await http.post(
        Uri.parse(ApiServices.sendMessageapi),
        body: {
          'sender_id': '4',
          'receiver_id': widget.userId,
          'message': message,
          'request_type': 'admin',
        },
      );
      if (response.statusCode == 200) {
        print('message send: ${response.statusCode}');
        print('message reponse : ${response.body}');
      }
    } catch (error) {
      print('Error sending message: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: blackColor,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await fetchMessages(widget.userId);
        },
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<List<dynamic>>(
                stream: _messageStream,
                initialData: [],
                builder: (context, snapshot) {
                  List<dynamic> messages = snapshot.data!;
                  return ListView.builder(
                    reverse: true,
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      bool isSender = messages[index]['sender_name'] != 'Admin';
                      return Align(
                        alignment: isSender ? Alignment.centerLeft : Alignment.centerRight,
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10.0),
                              margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
                              decoration: BoxDecoration(
                                color: isSender ? buttonColors : listTileLeadingColor,
                                borderRadius: isSender
                                    ? const BorderRadius.only(
                                  bottomRight: Radius.circular(15.0),
                                  topRight: Radius.circular(15.0),
                                  topLeft: Radius.circular(15.0),
                                )
                                    : const BorderRadius.only(
                                  bottomLeft: Radius.circular(15),
                                  topRight: Radius.circular(15.0),
                                  topLeft: Radius.circular(15.0),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  smallText(
                                    title: messages[index]['message'].toString() ?? 'No message',
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 5, left: 10, right: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: buttonColors),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        onFieldSubmitted: (value) {
                          if (messageController.text.trim().isEmpty) {
                          } else {
                            sendMessage(widget.userId, messageController.text);
                            messageController.clear();
                          }
                        },
                        cursorColor: goldenColor,
                        style: const TextStyle(color: Colors.white),
                        keyboardType: TextInputType.text,
                        controller: messageController,
                        decoration: const InputDecoration.collapsed(
                          hintText: 'Type your message...',
                          hintStyle: TextStyle(
                            color: listTileEditColor,
                            fontFamily: "Poppins",
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.send, color: listTileEditColor),
                      onPressed: () {
                        if (messageController.text.trim().isEmpty) {
                        } else {
                          sendMessage(widget.userId, messageController.text);
                          messageController.clear();
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    webSocketChannel.sink.close();
    _streamController.close();
    super.dispose();
  }
}







// class MessagingScreen extends StatefulWidget {
//   final String  userId;
//   final String userName ;
//
//   MessagingScreen({required this.userId,required this.userName}) ;
//
//   @override
//   _MessagingScreenState createState() => _MessagingScreenState();
// }
//
// class _MessagingScreenState extends State<MessagingScreen> {
//   List<dynamic> messages = [];
//   late WebSocket webSocket; // Declare WebSocket
//   final TextEditingController messageController = TextEditingController();
//   dynamic? repliedMessage;
//
//
//   @override
//   void initState() {
//     super.initState();
//     initializeWebSocket();
//     fetchMessages(widget.userId);
//   }
//
//   void initializeWebSocket() async {
//     try {
//       webSocket = await WebSocket.connect('wss://ws-ap3.pusher.com/app/1769136'); // Replace with your WebSocket URL
//       webSocket.listen((dynamic data) {
//         setState(() {
//           messages.add(jsonDecode(data)); // Assuming data is a JSON string
//         });
//       });
//     } catch (e) {
//       print('Error connecting to WebSocket: $e');
//     }
//   }
//
//   Future<void> fetchMessages(userID) async {
//     final response = await http.get(Uri.parse('${ApiServices.fetchMessageapi}=$userID'));
//     if (response.statusCode == 200) {
//       Map<String, dynamic> responseData = jsonDecode(response.body);
//       List<dynamic> receivedMessages = responseData['data'];
//       setState(() {
//         messages = receivedMessages; // Update messages list
//       });
//     } else {
//       throw Exception('Failed to load messages');
//     }
//   }
//
//   Future<void> sendMessage(userId, String message) async {
//     try {
//       final response = await http.post(
//         Uri.parse(ApiServices.sendMessageapi),
//         body: {
//           'sender_id':'4',
//           'receiver_id': widget.userId,
//           'message': message,
//           'request_type': 'admin',
//         },
//       );
//       if (response.statusCode == 200) {
//         // Optionally, you can fetch messages again after sending to update the UI
//         fetchMessages(userId);
//       } else {
//         print('Failed to send message. Server returned status code: ${response.statusCode}');
//       }
//     } catch (error) {
//       print('Error sending message: $error');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: blackColor,
//       ),
//       body: RefreshIndicator(
//         onRefresh: () => fetchMessages(widget.userId),
//         child: Column(
//           children: [
//             Expanded(
//               child: ListView.builder(
//                 reverse: true,
//                 itemCount: messages.length,
//                 itemBuilder: (context, index) {
//                   bool isSender = messages[index]['sender_name'] != 'Admin';
//                   return Align(
//                     alignment: isSender ? Alignment.centerLeft : Alignment.centerRight,
//                     child: Column(
//                       children: [
//                         Container(
//                           padding: const EdgeInsets.all(10.0),
//                           margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
//                           decoration: BoxDecoration(
//                             color: isSender ? buttonColors : listTileLeadingColor,
//                             borderRadius: isSender
//                                 ? const BorderRadius.only(
//                               bottomRight: Radius.circular(15.0),
//                               topRight: Radius.circular(15.0),
//                               topLeft: Radius.circular(15.0),
//                             )
//                                 : const BorderRadius.only(
//                               bottomLeft: Radius.circular(15),
//                               topRight: Radius.circular(15.0),
//                               topLeft: Radius.circular(15.0),
//                             ),
//                           ),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               smallText(title: messages[index]['message'].toString() ?? 'No message'),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   );
//                 },
//               ),
//             ),
//             Container(
//               margin: const EdgeInsets.only(bottom: 5, left: 10, right: 10),
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(10),
//                 border: Border.all(color: buttonColors),
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.only(left: 8.0, right: 8),
//                 child: Row(
//                   children: [
//                     Expanded(
//                       child: TextFormField(
//                         onFieldSubmitted: (value) {
//                           if (messageController.text.trim().isEmpty) {
//                             ToastClass.showToast(context, 'Please enter some text');
//                           } else {
//                             sendMessage(widget.userId, messageController.text);
//                             messageController.clear();
//                           }
//                         },
//                         cursorColor: goldenColor,
//                         style: const TextStyle(color: Colors.white),
//                         keyboardType: TextInputType.text,
//                         controller: messageController,
//                         decoration: const InputDecoration.collapsed(
//                           hintText: 'Type your message...',
//                           hintStyle: TextStyle(
//                             color: listTileEditColor,
//                             fontFamily: "Poppins",
//                             fontSize: 14,
//                           ),
//                         ),
//                       ),
//                     ),
//                     IconButton(
//                       icon: const Icon(Icons.send, color: listTileEditColor),
//                       onPressed: () {
//                         if (messageController.text.trim().isEmpty) {
//                           ToastClass.showToast(context, 'Please enter some text');
//                         } else {
//                           sendMessage(widget.userId, messageController.text);
//                           messageController.clear();
//                         }
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   @override
//   void dispose() {
//     // pusher.disconnect();
//     webSocket.close();
//     super.dispose();
//   }
// }