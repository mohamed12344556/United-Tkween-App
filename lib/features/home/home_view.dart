import 'package:flutter/material.dart';

import '../../core/core.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Welcome to Home!'),
            ElevatedButton(
              onPressed: () {
                // Add logout functionality here
                NavigationService.navigatorKey.currentState
                    ?.pushNamedAndRemoveUntil(
                      Routes.loginView,
                      (route) => false,
                    );
              },
              child: Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
