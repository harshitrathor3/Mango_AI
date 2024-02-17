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

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
            onPressed: () {
              signInWIthGoogle();
            },
            child: const Text("Sign IN with google")),
      ),
    );
  }

  signInWIthGoogle() async {
    GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
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
