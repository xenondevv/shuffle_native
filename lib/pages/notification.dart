import 'package:flutter/material.dart';
import 'package:shuffle_native/pages/rental/payment.dart';
import 'package:shuffle_native/services/auth_service.dart';
// import 'package:shuffle_native/services/web_socket_service.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  // late WebSocketService _webSocketService;
  // late Stream<Map<String, dynamic>> _notificationsStream;
  bool _isLoading = false;
  final List<Map<String, dynamic>> _notifications = []; // Added list to store notifications

  @override
  void initState() {
    super.initState();
    // _initializeWebSocket();
  }

  // Future<void> _initializeWebSocket() async {
  //   final userId = (await AuthService().getUserId()).toString();
  //   _webSocketService = WebSocketService(userId);
  //   _notificationsStream = _webSocketService.notifications;

  //   _notificationsStream.listen((notification) {
  //     setState(() {
  //       _notifications.add(notification); // Push new notifications into the list
  //     });
  //   });

  //   setState(() {
  //     _isLoading = false;
  //   });
  // }

  @override
  void dispose() {
    // _webSocketService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text('Notifications')),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text('Notifications')),
      body: _notifications.isEmpty
          ? Center(child: Text('No notifications yet.'))
          : ListView.builder(
              itemCount: _notifications.length,
              itemBuilder: (context, index) {
                final notification = _notifications[index];
                final title = notification['title'];
                final body = notification['body'];
                final redirectTo = notification['redirectTo'];

                return ListTile(
                  title: Text(title),
                  subtitle: Text(body),
                  onTap: () {
                    if (redirectTo == "requestpage") {
                      Navigator.pushNamed(context, '/$redirectTo');
                    } else if (redirectTo == "paymentpage") {
                      Navigator.push(context, 
                        MaterialPageRoute(
                          builder: (context) => CheckoutPage(
                            bookingId: notification['booking_id'],
                          ),
                        ),
                      );
                    }
                  },
                );
              },
            ),
    );
  }
}
