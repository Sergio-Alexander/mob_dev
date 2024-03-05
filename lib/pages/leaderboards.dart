import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../router.dart';
import 'package:url_launcher/url_launcher.dart';

class LeaderboardsPage extends StatefulWidget {
  @override
  _LeaderboardsPage createState() => _LeaderboardsPage();
}

class _LeaderboardsPage extends State<LeaderboardsPage> {
  bool _agreedToTOS = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Leaderboards'),
      ),
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData) {
            // User is signed in, show the leaderboard and the delete button
            return Column(
              children: [
                Expanded(
                  child: FutureBuilder<QuerySnapshot>(
                    future: FirebaseFirestore.instance.collection('users').orderBy('points', descending: true).get(),
                    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      }
                      return ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ListTile(
                            title: Text(snapshot.data!.docs[index]['username']),
                            subtitle: Text('Points: ${snapshot.data!.docs[index]['points']}'),
                          );
                        },
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.red,
                      primary: Colors.white,
                    ),
                    onPressed: _showDeleteConfirmationDialog,
                    child: Text('Delete My Data'),
                  ),
                ),
              ],
            );
          } else {
            // User is not signed in, show a sign-in prompt
            return _buildSignInPrompt();
          }
        },
      ),
    );
  }

  Widget _buildSignInPrompt() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Please Sign In or Sign Up to view the leaderboards.'),
          CheckboxListTile(
            title: Text.rich(
              TextSpan(
                children: [
                  TextSpan(text: 'I agree to the '),
                  TextSpan(
                    text: 'Terms of Service.',
                    style: TextStyle(color: Colors.blue),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () async {
                        const url = 'https://doc-hosting.flycricket.io/health-recorder-terms-of-use/43a0c51c-6ed1-4fa9-855e-36cf0e06aaf1/terms';
                        if (await canLaunch(url)) {
                          await launch(url);
                        } else {
                          throw 'Could not launch $url';
                        }
                      },
                  ),
                ],
              ),
            ),
            value: _agreedToTOS,
            onChanged: (bool? value) {
              setState(() {
                _agreedToTOS = value!;
              });
            },
            controlAffinity: ListTileControlAffinity.leading,
          ),
          TextButton(
            onPressed: _agreedToTOS ? () {
              appRouter.go('/login'); // Navigate to the login page
            } : null,
            child: Text('Sign In / Sign Up'),
          ),
          if (!_agreedToTOS)
            Text('You must agree to the TOS first in order to login or signup'),
        ],
      ),
    );
  }

  void _showDeleteConfirmationDialog() async {
    // Show confirmation dialog
    bool confirmed = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Delete My Data"),
          content: Text("This will delete your account and remove you from the leaderboard. Are you sure?"),
          actions: <Widget>[
            TextButton(
              child: Text("Cancel"),
              onPressed: () => Navigator.of(context).pop(false), // Dismiss and return false
            ),
            TextButton(
              child: Text("Delete"),
              onPressed: () => Navigator.of(context).pop(true), // Dismiss and return true
            ),
          ],
        );
      },
    ) ?? false; // If dialog is dismissed, treat it as "Cancel"

        if (confirmed) {
      _deleteUserData();
        }
  }

  void _deleteUserData() async{
    await FirebaseFunctions.instance.httpsCallable('deleteUserData').call();
    await FirebaseAuth.instance.signOut();
    // Sign out from Google
    final GoogleSignIn googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();

    appRouter.go('/leaderboards'); // Navigate to the leaderboards page
    ShellWidget.of(context)?.setIndex(3);
  }

}