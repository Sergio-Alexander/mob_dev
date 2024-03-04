import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../router.dart'; // Make sure to import your router

class LeaderboardsPage extends StatefulWidget{
  @override
  _LeaderboardsPage createState() => _LeaderboardsPage();
}

class _LeaderboardsPage extends State<LeaderboardsPage> {
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Leaderboards'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Leaderboards Page'),
            TextButton(
              onPressed: () {
                appRouter.go('/login'); // Navigate to the login page
              },
              child: Text('Sign In or Sign Up'),
            ),
          ],
        ),
      ),
    );
  }
}