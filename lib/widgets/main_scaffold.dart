import 'package:flutter/material.dart';
import 'package:shuffle_native/pages/home.dart';
import 'package:shuffle_native/pages/rental/my_rentals.dart';
import 'package:shuffle_native/pages/rental/upload_item.dart';
import 'package:shuffle_native/pages/notification.dart';
import 'package:shuffle_native/pages/profile/profile.dart';
// import 'package:shuffle_native/services/web_socket_service.dart';

class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const Homepage(),
    MyRentalsPage(),
    const UploadItemPage(), // Not shown directly
    const NotificationPage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_selectedIndex != 0) {
          setState(() {
            _selectedIndex = 0;
          });
          return false;
        }
        return true;
      },
      child: Scaffold(
        body: IndexedStack(
          index: _selectedIndex,
          children: _pages,
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) {
            if (index == 2) {
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (_, __, ___) => const UploadItemPage(),
                  transitionsBuilder: (_, animation, __, child) {
                    return FadeTransition(
                      opacity: animation,
                      child: SlideTransition(
                        position: Tween(
                          begin: const Offset(0, 0.5),
                          end: Offset.zero,
                        ).animate(animation),
                        child: child,
                      ),
                    );
                  },
                ),
              );
              return;
            }

            setState(() {
              _selectedIndex = index;
              if (index == 3) {
                // WebSocketService.notificationCount.value = 0;
              }
            });
          },
          type: BottomNavigationBarType.fixed,
          selectedItemColor: const Color(0xFF087272),
          unselectedItemColor: Colors.grey,
          items: [
            const BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.inventory_2),
              label: 'Rentals',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.add_box),
              label: 'Upload',
            ),
            BottomNavigationBarItem(
              icon: Stack(
                children: [
                  const Icon(Icons.notifications),
                  // if (count > 0)
                  //   Positioned(
                  //     right: 0,
                  //     child: CircleAvatar(
                  //       radius: 8,
                  //       backgroundColor: Colors.red,
                  //       child: Text(
                  //         '$count',
                  //         style: const TextStyle(
                  //           color: Colors.white,
                  //           fontSize: 10,
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                ],
              ),
              label: 'Notifications',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
