// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:sign_in_button/sign_in_button.dart';

// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});

//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   User? _user;
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     _auth.authStateChanges().listen((event) {
//       setState(() {
//         _user = event;
//       });
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Login"),
//       ),
//       body: Center(
//         child: _user != null ? _userinfo() : _googleSignInButton(),
//       ),
//     );
//   }

//   Widget _userinfo() {
//     return SizedBox();
//   }

//   Widget _googleSignInButton() {
//     return SizedBox(
//       height: 50,
//       child: SignInButton(
//         Buttons.google,
//         onPressed: _handleGoogleSignIn,
//         text: "SignInWithGoogle",
//       ),
//     );
//   }

//   void _handleGoogleSignIn() {
//     try {
//       GoogleAuthProvider _googleAuthProvider = GoogleAuthProvider();
//       _auth.signInWithProvider(_googleAuthProvider);
//     } catch (err) {
//       print(err);
//     }
//   }
// }
import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/gmail/v1.dart';
import 'package:googleapis/people/v1.dart';
import 'package:googleapis_auth/googleapis_auth.dart' as auth;

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 164, 102),
      body: Expanded(
        child: Column(
          children: [
            const SizedBox(
              height: 200,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 25, vertical: 30),
              child: Column(
                //crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "🥭 Mango AI",
                      style: TextStyle(
                          fontSize: 40,
                          color: Color.fromARGB(255, 255, 255, 255)),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: SizedBox(
                      width: 240,
                      child: Text(
                        "A new start with your Everyday AI Assistant ",
                        style: TextStyle(
                            fontSize: 20,
                            color: Color.fromRGBO(135, 34, 34, 1)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Expanded(
              child: SizedBox(),
            ),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    //  foregroundColor: ,
                    backgroundColor: const Color.fromARGB(255, 167, 62, 1),
                    elevation: 30,
                    alignment: Alignment.center),
                onPressed: signInWIthGoogle,
                child: const Text(
                  "Continue with Google",
                  style: TextStyle(
                      fontSize: 20, color: Color.fromARGB(255, 251, 251, 251)),
                ),
              ),
            ),
            const SizedBox(
              height: 100,
            )
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  signInWIthGoogle() async {
    GoogleSignInAccount? googleUser = await GoogleSignIn(
      scopes: <String>[
        PeopleServiceApi.contactsReadonlyScope,
        'https://mail.google.com/',
        'https://www.googleapis.com/auth/gmail.modify',
        'https://www.googleapis.com/auth/gmail.readonly',
        // 'https://www.googleapis.com/auth/gmail.metadata',
        GmailApi.gmailComposeScope,
        GmailApi.gmailSendScope,
        GmailApi.gmailReadonlyScope,
      ],
    ).signIn();
    GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
    AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken, idToken: googleAuth?.idToken);
    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);
    print(userCredential.user!);
  }
}

// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:googleapis/calendar/v3.dart' as calendar;
// import 'package:googleapis_auth/auth_io.dart' as auth;

// class LoginScreen extends StatelessWidget {
//   const LoginScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: ElevatedButton(
//           onPressed: () {
//             signInWIthGoogle();
//           },
//           child: const Text("Sign IN with google"),
//         ),
//       ),
//     );
//   }

//   signInWIthGoogle() async {
//     try {
//       // Sign in with Google
//       GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
//       GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
//       AuthCredential credential = GoogleAuthProvider.credential(
//           accessToken: googleAuth?.accessToken, idToken: googleAuth?.idToken);
//       UserCredential userCredential =
//           await FirebaseAuth.instance.signInWithCredential(credential);
//       print(userCredential.user!);

//       // Create the OAuth access credentials from the Firebase user
//       auth.AccessCredentials accessCredentials = auth.AccessCredentials(
//         auth.AccessToken(
//           'Bearer',
//           googleAuth?.accessToken as String,
//           DateTime.now().add(Duration(seconds: 130000 ?? 0)),
//         ),
//         googleAuth?.idToken,
//         ['https://www.googleapis.com/auth/calendar'],
//       );

//       // Create the Google Calendar API client
//       calendar.CalendarApi calendarApi = calendar.CalendarApi(
//           auth.authenticatedClient(auth.Client(), accessCredentials));

//       // Create a sample event to insert
//       calendar.Event event = calendar.Event();
//       event.summary = 'Test event';
//       event.start = calendar.EventDateTime();
//       event.start!.dateTime = DateTime.now();
//       event.end = calendar.EventDateTime();
//       event.end!.dateTime = DateTime.now().add(Duration(hours: 1));

//     // Insert the event to the primary calendar
//     calendarApi.events.insert(event, 'primary').then((value) {
//       print('Event added: ${value.status}');
//     }).catchError((error) {
//       print('Error: $error');
//     });
//   }
// }
