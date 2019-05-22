import 'dart:js';
import 'package:firebase_dart_ui/firebase_dart_ui.dart';
import 'package:firebase/firebase.dart' as firebase;
import 'package:firebase/src/interop/firebase_interop.dart';

import 'package:flutter_web/material.dart';

import 'package:resource_collect/home_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  UIConfig _uiConfig;

  Future<Null> logout() async {
    await firebase.auth().signOut();
    providerAccessToken = "";
  }

  // todo: We need to create a nicer wrapper for the sign in callbacks.
  PromiseJsImpl<void> signInFailure(AuthUIError authUiError) {
    // nothing to do;
    return new PromiseJsImpl<void>(() => print("SignIn Failure"));
  }

  // Example SignInSuccess callback handler
  bool signInSuccess(firebase.UserCredential authResult, String redirectUrl) {
    print(
        "sign in  success. ProviderID =  ${authResult.credential.providerId}");
    print("Info= ${authResult.additionalUserInfo}");

    // returning false gets rid of the double page load (no need to redirect to /)
    return false;
  }

  /// Your Application must provide the UI configuration for the
  /// AuthUi widget. This is where you configure the providers and options.
  UIConfig getUIConfig() {
    if (_uiConfig == null) {
      var googleOptions = new CustomSignInOptions(
          provider: firebase.GoogleAuthProvider.PROVIDER_ID,
          scopes: ['email', 'https://www.googleapis.com/auth/plus.login'],
          customParameters:
              new GoogleCustomParameters(prompt: 'select_account'));

      var gitHub = new CustomSignInOptions(
          provider: firebase.GithubAuthProvider.PROVIDER_ID,
          // sample below of asking for additional scopes.
          // See https://developer.github.com/apps/building-oauth-apps/scopes-for-oauth-apps/
          scopes: [/*'repo', 'gist' */]);

      var callbacks = new Callbacks(
          uiShown: () => print("UI shown callback"),
          signInSuccessWithAuthResult: allowInterop(signInSuccess),
          signInFailure: signInFailure);

      _uiConfig = new UIConfig(
          signInSuccessUrl: '/',
          signInOptions: [
            googleOptions,
            firebase.EmailAuthProvider.PROVIDER_ID,
            gitHub
          ],
          signInFlow: "redirect",
          //signInFlow: "popup",
          credentialHelper: ACCOUNT_CHOOSER,
          tosUrl: '/tos.html',
          callbacks: callbacks);
    }
    return _uiConfig;
  }

  bool isAuthenticated() => firebase.auth().currentUser != null;
  String get userEmail => firebase.auth().currentUser?.email;
  String get displayName => firebase.auth().currentUser?.displayName;
  String get photoURL => firebase.auth().currentUser?.photoURL;
  Map<String, dynamic> get userJson => firebase.auth().currentUser?.toJson();

  // If the provider gave us an access token, we put it here.
  String providerAccessToken = "";

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    getUIConfig();
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

// class MyHomePage extends StatelessWidget {
//   MyHomePage({Key key}) : super(key: key);

//   final String title = 'Flutter Demo Home Page';

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(title),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Text(
//               'Hello, World!',
//             ),
//           ],
//         ),
//       ), // This trailing comma makes auto-formatting nicer for build methods.
//     );
//   }
// }
