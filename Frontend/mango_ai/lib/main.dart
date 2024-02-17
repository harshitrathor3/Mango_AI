import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mango_ai/firebase_options.dart';
import 'package:mango_ai/screens/authScreen.dart';
import 'package:mango_ai/screens/tabsectionscreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(Myapp());
}

class Myapp extends StatelessWidget {
  const Myapp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: StreamBuilder<User?>(
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }
          if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.data == null) {
              return LoginScreen();
            } else {
              return TabScreen();
            }
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
        stream: FirebaseAuth.instance.authStateChanges(),
      ),
    );
  }
}
