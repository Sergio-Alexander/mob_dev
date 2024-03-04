// login_page.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../router.dart';

// class LoginPage extends StatefulWidget {
//   @override
//   _LoginPageState createState() => _LoginPageState();
// }
//
// class _LoginPageState extends State<LoginPage> {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final GoogleSignIn _googleSignIn = GoogleSignIn();
//
//   bool rememberMe = false;
//
//   Future<UserCredential> signInWithGoogle({required bool rememberMe}) async {
//     final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
//     final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;
//     final credential = GoogleAuthProvider.credential(
//       accessToken: googleAuth.accessToken,
//       idToken: googleAuth.idToken,
//     );
//
//     if (rememberMe) {
//       // Persist the user's session
//       await _auth.setPersistence(Persistence.LOCAL);
//     } else {
//       // Don't persist the user's session
//       await _auth.setPersistence(Persistence.NONE);
//     }
//
//     return await _auth.signInWithCredential(credential);
//   }
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             TextButton(
//               child: Text('Sign in with Google'),
//               onPressed: () async {
//                 await signInWithGoogle(rememberMe: rememberMe);
//                 // Navigate to the leaderboard page after sign in
//                 Navigator.pushReplacementNamed(context, '/emotion');
//               },
//             ),
//
//             CheckboxListTile(
//               title: Text('Remember Me'),
//               value: rememberMe,
//               onChanged: (bool? value) {
//                 setState(() {
//                   rememberMe = value!;
//                 });
//               },
//             ),
//
//           ],
//         ),
//       ),
//     );
//   }
// }


class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  bool rememberMe = false;

  Future<UserCredential> signInWithGoogle({required bool rememberMe}) async {
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // if (rememberMe) {
    //   await _auth.setPersistence(Persistence.LOCAL);
    // } else {
    //   await _auth.setPersistence(Persistence.NONE);
    // }
    //
    // UserCredential userCredential = await _auth.signInWithCredential(credential);

    // Navigate to the main page after sign in
    // Navigator.pushReplacementNamed(context, '/emotion');

    appRouter.go('/emotion');

    return await _auth.signInWithCredential(credential);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[

              Image.asset(
                'images/machio.jpg',
                height: 150, // You can adjust the size as needed.
              ),
              SizedBox(height: 20),

              Text(
                'The Health Recorder',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 50),
              TextButton(
                style: TextButton.styleFrom(
                  padding: EdgeInsets.all(15),
                  backgroundColor: Colors.blue,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.login),
                    SizedBox(width: 10),
                    Text('Sign in with Google'),
                  ],
                ),
                onPressed: () async {
                  await signInWithGoogle(rememberMe: rememberMe);
                  Navigator.pushReplacementNamed(context, '/');
                },
              ),
              SizedBox(height: 20),
              CheckboxListTile(
                title: Text('Remember Me'),
                value: rememberMe,
                onChanged: (bool? value) {
                  setState(() {
                    rememberMe = value!;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}