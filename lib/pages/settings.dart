import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mob_dev/app_localization.dart';
import 'package:mob_dev/main.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../router.dart';


enum ThemeStyle {
  material,
  cupertino,
}

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

ThemeStyle currentTheme = ThemeStyle.material;

class _SettingsPageState extends State<SettingsPage> {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String username = ''; // State variable for username

  @override
  void initState() {
    super.initState();
    _loadUsername(); // Fetch username when the page is loaded
  }

  Future<void> _loadUsername() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentReference userDocRef = _firestore.collection('users').doc(user.uid);
      DocumentSnapshot userDoc = await userDocRef.get();
      if (userDoc.exists) {
        setState(() {
          // Assuming 'username' is the field name where username is stored
          username = userDoc.get('username') as String;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).translate('settings')),
        centerTitle: true,
      ),
      body: ListView(
        children: <Widget>[

          if (username.isNotEmpty) // Display username if it's not empty
            ListTile(
              title: Text("Username"),
              trailing: Text(username),
            ),

          ListTile(
            title: Text(AppLocalizations.of(context).translate('changeLanguage')),
            trailing: DropdownButton<String>(
              value: Localizations.localeOf(context).languageCode,
              items: <String>['en', 'id'].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  Locale newLocale = Locale(newValue, '');
                  MyApp.of(context)?.setLocale(newLocale);
                }
              },
            ),
          ),
          ListTile(
            title: Text(AppLocalizations.of(context).translate('changeTheme')),
            trailing: currentTheme == ThemeStyle.material
                ? Text(AppLocalizations.of(context).translate('material'))
                : Text(AppLocalizations.of(context).translate('cupertino')),
            onTap: () {
              MyApp.of(context)?.toggleTheme();
              setState(() {
              });
            },
          ),

          StreamBuilder<User?>(
            stream: _auth.authStateChanges(),
            builder: (BuildContext context, snapshot) {
              if (snapshot.hasData) {
                // If the user is signed in, display the logout button
                return TextButton(
                  onPressed: () async {
                    await _googleSignIn.signOut(); // Sign out from GoogleSignIn
                    await _auth.signOut(); // Then sign out from Firebase
                    appRouter.go('/leaderboards'); // Navigate to the leaderboards page
                    ShellWidget.of(context)?.setIndex(3);
                  },
                  child: Text('Logout'),
                );
              } else {
                // If the user is not signed in, do not display the logout button
                return SizedBox.shrink();
              }
            },
          ),
        ],
      ),
    );
  }
}