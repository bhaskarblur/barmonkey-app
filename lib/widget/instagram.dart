// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
// import 'package:http/http.dart' as http;

// class InstagramConstant {
//   static InstagramConstant? _instance;
//   static InstagramConstant get instance {
//     _instance ??= InstagramConstant._init();
//     return _instance!;
//   }

//   InstagramConstant._init();

//   static const String clientID = '1244244249616322';
//   static const String appSecret = '4eb78194c5d9f3e7b467a718c86aa957';
//   static const String redirectUri = 'https://www.google.com';
//   static const String scope = 'user_profile';
//   static const String responseType = 'code';
//   final String url =
//       'https://api.instagram.com/oauth/authorize?client_id=$clientID&redirect_uri=$redirectUri&scope=user_profile,user_media&response_type=$responseType';
// }

// class InstagramModel {
//   List<String> userFields = ['id', 'username'];

//   String? authorizationCode;
//   String? accessToken;
//   String? userID;
//   String? username;

//   void getAuthorizationCode(String url) {
//     authorizationCode = url
//         .replaceAll('${InstagramConstant.redirectUri}?code=', '')
//         .replaceAll('#_', '');
//   }

//   Future<bool> getTokenAndUserID() async {
//     var url = Uri.parse('https://api.instagram.com/oauth/access_token');
//     final response = await http.post(url, body: {
//       'client_id': InstagramConstant.clientID,
//       'redirect_uri': InstagramConstant.redirectUri,
//       'client_secret': InstagramConstant.appSecret,
//       'code': authorizationCode,
//       'grant_type': 'authorization_code'
//     });
//     accessToken = json.decode(response.body)['access_token'];
//     print(accessToken);
//     userID = json.decode(response.body)['user_id'].toString();
//     return (accessToken != null && userID != null) ? true : false;
//   }

//   Future<bool> getUserProfile() async {
//     final fields = userFields.join(',');
//     final responseNode = await http.get(Uri.parse(
//         'https://graph.instagram.com/$userID?fields=$fields&access_token=$accessToken'));
//     var instaProfile = {
//       'id': json.decode(responseNode.body)['id'].toString(),
//       'username': json.decode(responseNode.body)['username'],
//     };
//     username = json.decode(responseNode.body)['username'];
//     print('username: $username');
//     return instaProfile != null ? true : false;
//   }
// }

// class InstagramView extends StatelessWidget {
//   const InstagramView({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Builder(builder: (context) {
//       final webview = FlutterWebviewPlugin();
//       final InstagramModel instagram = InstagramModel();

//       buildRedirectToHome(webview, instagram, context);

//       return WebviewScaffold(
//         url: InstagramConstant.instance.url,
//         resizeToAvoidBottomInset: true,
//         // appBar: AppBar(),
//       );
//     });
//   }

//   Future<void> buildRedirectToHome(FlutterWebviewPlugin webview,
//       InstagramModel instagram, BuildContext context) async {
//     webview.onUrlChanged.listen((String url) async {
//       if (url.contains(InstagramConstant.redirectUri)) {
//         instagram.getAuthorizationCode(url);
//         await instagram.getTokenAndUserID().then((isDone) {
//           if (isDone) {
//             instagram.getUserProfile().then((isDone) async {
//               await webview.close();

//               print('${instagram.username} logged in!');

//               await Navigator.of(context).push(
//                 MaterialPageRoute(
//                   builder: (context) => HomeView(
//                     token: instagram.authorizationCode.toString(),
//                     name: instagram.username.toString(),
//                   ),
//                 ),
//               );
//             });
//           }
//         });
//       }
//     });
//   }
// }

// class HomeView extends StatelessWidget {
//   const HomeView({Key? key, required this.token, required this.name})
//       : super(key: key);
//   final String token;
//   final String name;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Welcome $name')),
//       body: Center(child: Text('Token: $token')),
//     );
//   }
// }
