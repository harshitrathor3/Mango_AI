import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/gmail/v1.dart';
import 'package:googleapis/people/v1.dart';
import 'package:googleapis_auth/googleapis_auth.dart' as auth show AuthClient;
import 'package:mango_ai/screens/tabsectionscreen.dart';
import 'usermail.dart';

final GoogleSignIn _googleSignIn = GoogleSignIn(
  // Optional clientId
  // clientId: '[YOUR_OAUTH_2_CLIENT_ID]',
  // clientId:
  // '165299692088-ri8jkeohrl01rokuvqnk97kac78uknd0.apps.googleusercontent.com',
  // serverClientId:
  //     '165299692088-ri8jkeohrl01rokuvqnk97kac78uknd0.apps.googleusercontent.com',
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
);

void main() {
  runApp(
    const MaterialApp(
      title: 'Google Sign In + googleapis',
      home: SignInDemo(),
    ),
  );
}

class SignInDemo extends StatefulWidget {
  const SignInDemo({super.key});

  @override
  State createState() => SignInDemoState();
}

class SignInDemoState extends State<SignInDemo> {
  GoogleSignInAccount? _currentUser;
  String _contactText = '';

  @override
  void initState() {
    super.initState();
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
      setState(() {
        _currentUser = account;
      });
      if (_currentUser != null) {
        _handleGetContact();
      }
    });
    _googleSignIn.signInSilently();
  }

  Future<void> _handleGetContact() async {
    setState(() {
      _contactText = 'Loading contact info...';
    });

    final auth.AuthClient? client = await _googleSignIn.authenticatedClient();

    assert(client != null, 'Authenticated client missing!');
    final PeopleServiceApi peopleApi = PeopleServiceApi(client!);
    final ListConnectionsResponse response =
        await peopleApi.people.connections.list(
      'people/me',
      personFields: 'names',
    );

    final String? firstNamedContactName =
        _pickFirstNamedContact(response.connections);

    setState(() {
      if (firstNamedContactName != null) {
        _contactText = 'I see you know $firstNamedContactName!';
      } else {
        _contactText = 'No contacts to display.';
      }
    });
  }

  String? _pickFirstNamedContact(List<Person>? connections) {
    return connections
        ?.firstWhere(
          (Person person) => person.names != null,
        )
        .names
        ?.firstWhere(
          (Name name) => name.displayName != null,
        )
        .displayName;
  }

  Future<void> _handleSignIn() async {
    try {
      await _googleSignIn.signIn();
      // sendMessage("harshitrathorelink@gmail.com", "Hello Harshit Bhaiya",
      // "Hello this messege was sent with flutter");
      // readRecentUnreads(24);
    } catch (error) {
      print(error); // ignore: avoid_print
    }
  }

  Future<void> _handleSignOut() => _googleSignIn.disconnect();

  Widget _buildBody() {
    final GoogleSignInAccount? user = _currentUser;
    if (user != null) {
      return TabScreen();
      // Column(
      //   mainAxisAlignment: MainAxisAlignment.spaceAround,
      //   children: <Widget>[
      //     ListTile(
      //       leading: GoogleUserCircleAvatar(
      //         identity: user,
      //       ),
      //       title: Text(user.displayName ?? ''),
      //       subtitle: Text(user.email),
      //     ),
      //     const Text('Signed in successfully.'),
      //     Text(_contactText),
      //     ElevatedButton(
      //       onPressed: _handleSignOut,
      //       child: const Text('SIGN OUT'),
      //     ),
      //     ElevatedButton(
      //       onPressed: _handleGetContact,
      //       child: const Text('REFRESH'),
      //     ),
      //     ElevatedButton(
      //         onPressed: () {
      //           readRecentUnreads(24);
      //         },
      //         child: const Text("Read Mails and Print"))
      //   ],
      // );
    } else {
      return Scaffold(
        backgroundColor: Color.fromARGB(255, 255, 164, 102),
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
                            color: const Color.fromARGB(255, 255, 255, 255)),
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
                      backgroundColor: Color.fromARGB(255, 167, 62, 1),
                      elevation: 30,
                      alignment: Alignment.center),
                  onPressed: _handleSignIn,
                  child: Text(
                    "Continue with Google",
                    style: TextStyle(
                        fontSize: 20,
                        color: Color.fromARGB(255, 251, 251, 251)),
                  ),
                ),
              ),
              SizedBox(
                height: 100,
              )
            ],
          ),
        ), // This trailing comma makes auto-formatting nicer for build methods.
      );
    }
  }

  // Future<Message> sendMessage(String email, String subject, String body) async {
  //   final auth.AuthClient client =
  //       await _googleSignIn.authenticatedClient() as auth.AuthClient;
  //   final gmailApi = GmailApi(client);
  //   var message = new Message();
  //   message.raw =
  //       "From: me <${email}>\nTo: ${email}\nSubject: ${subject}\n\n${body}";
  //   final response = await gmailApi.users.messages.send(message, 'me');
  //   print('Email Sent');
  //   return response;
  // }

  @override
  Widget build(BuildContext context) {
    return _buildBody();
  }
}
