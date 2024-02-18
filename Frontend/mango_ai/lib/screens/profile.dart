import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/gmail/v1.dart';
import 'package:mango_ai/main3.dart';
import 'package:googleapis_auth/googleapis_auth.dart' as auth show AuthClient;

class ProfileSection extends StatefulWidget {
  const ProfileSection({super.key});

  @override
  State<ProfileSection> createState() => _ProfileSectionState();
}

class _ProfileSectionState extends State<ProfileSection> {
  GoogleSignInAccount? _currentUser;
  final GoogleSignIn googleSignIn = GoogleSignIn.standard();

  @override
  void initState() {
    super.initState();
    googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
      setState(() {
        _currentUser = account;
      });
    });
    googleSignIn.signInSilently();
  }

  Future<void> readRecentUnreads(int hours) async {
    // var googleSignIn = await GoogleSignIn();
    final authClient =
        await googleSignIn.authenticatedClient() as auth.AuthClient;
    final gmailApi = GmailApi(authClient);

    var response = await gmailApi.users.messages.list('me',
        // q: 'is:unread in:inbox after:${DateTime.now().subtract(Duration(hours: hours)).toIso8601String()}',
        maxResults: 20);

    print('Recent unread emails:');

    for (var message in response.messages ?? []) {
      var metadata = await gmailApi.users.messages.get('me', message.id);

      var subjectHeader = metadata.payload?.headers
          ?.where((header) => header.name == 'Subject')
          .first;

      print(' - ${subjectHeader?.value}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              readRecentUnreads(10);
            },
            child: Text("Show Mails"),
            style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Color.fromARGB(255, 255, 164, 102),
                fixedSize: Size(200, 50)),
          ),
          ElevatedButton(
              onPressed: () async {
                await GoogleSignIn().signOut();
                FirebaseAuth.instance.signOut();
              },
              style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Color.fromARGB(255, 255, 164, 102),
                  fixedSize: Size(200, 50)),
              child: Text("LogOut")),
        ],
      ),
    );
  }
}
