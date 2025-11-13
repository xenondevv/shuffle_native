// import 'package:flutter/material.dart';
// import 'package:shuffle_native/utils/constants.dart';
// import 'package:web_socket_channel/web_socket_channel.dart';
// import 'dart:convert';

// class WebSocketService {
//   final WebSocketChannel channel;
//   static final ValueNotifier<int> notificationCount = ValueNotifier<int>(0); // ValueNotifier for notification count

//   WebSocketService(String userId)
//       : channel = WebSocketChannel.connect(
//           Uri.parse('ws://$HOSTNAME/ws/notifications/$userId/'),
//         ) {
//     print('WebSocketService: Connecting to WebSocket for user $userId');
//     // _listenToNotifications();
//   }

//   // // Listen to WebSocket messages and update notification count
//   // void _listenToNotifications() {
//   //   channel.stream.listen((message) {
//   //     print('WebSocketService: Received message - $message');
//   //     notificationCount.value++; // Increment notification count
//   //   });
//   // }

//   // Listen to WebSocket messages
//   Stream<Map<String, dynamic>> get notifications => channel.stream.map((message) {
//         return json.decode(message);
//       });

//   // Close the WebSocket connection
//   void dispose() {
//     print('WebSocketService: Closing WebSocket connection');
//     channel.sink.close();
//   }
// }
