// import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:googleapis/gmail/v1.dart';
// import 'package:googleapis/people/v1.dart';
// import 'package:googleapis_auth/googleapis_auth.dart' as auth show AuthClient;
// import 'main3.dart';

// Future<Message> sendMessage(String email, String subject, String body) async {
//   // var _googleSignIn = await GoogleSignIn();
//   final auth.AuthClient client =
//       await googleSignIn.authenticatedClient() as auth.AuthClient;
//   final gmailApi = GmailApi(client);
//   var message = new Message();
//   message.raw =
//       "From: me <${email}>\nTo: ${email}\nSubject: ${subject}\n\n${body}";
//   // Encode the message.raw property in Base64
//   String encodedMessage = base64.encode(message.raw?.codeUnits ?? []);
//   message.raw = encodedMessage;

//   final response = await gmailApi.users.messages.send(message, 'me');
//   print('Email Sent');
//   return response;
// }

// Future<void> readRecentUnreads(int hours) async {
//   // var googleSignIn = await GoogleSignIn();
//   final authClient =
//       await googleSignIn.authenticatedClient() as auth.AuthClient;
//   final gmailApi = GmailApi(authClient);

//   var response = await gmailApi.users.messages.list('me',
//       // q: 'is:unread in:inbox after:${DateTime.now().subtract(Duration(hours: hours)).toIso8601String()}',
//       maxResults: 20);

//   print('Recent unread emails:');

//   for (var message in response.messages ?? []) {
//     var metadata = await gmailApi.users.messages.get('me', message.id);

//     var subjectHeader = metadata.payload?.headers
//         ?.where((header) => header.name == 'Subject')
//         .first;

//     print(' - ${subjectHeader?.value}');
//   }
// }
