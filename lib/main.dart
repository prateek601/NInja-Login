import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/AdminScreens/AdminLogin.dart';
import 'AdminScreens/AdminView.dart';
import 'package:flutter_app/Home.dart';
import 'package:flutter_app/LogInScreens/EmailLogIn.dart';
import 'package:flutter_app/SignUpScreens/Sign_upSign_in.dart';
import 'package:flutter_app/Utils/Constants.dart';
import 'package:get_storage/get_storage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await GetStorage.init();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
        scaffoldBackgroundColor: Colors.black
    ),
    home: App(),
  ));
}

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {

  void initDynamicLinks() async {
    FirebaseAuth auth = FirebaseAuth.instance;

    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData dynamicLink) async {
          print('came here in onlink method');
          final Uri deepLink = dynamicLink?.link;
          print(dynamicLink.link.queryParameters);
          print(deepLink);
          print(deepLink.path);
          print(deepLink.queryParameters);

          if (deepLink != null) {
            var actionCode = deepLink.queryParameters['oobCode'];
            print(actionCode);


            try {
              await auth.checkActionCode(actionCode);
              await auth.applyActionCode(actionCode);

              // If successful, reload the user:
              await auth.currentUser.reload();
              if(auth.currentUser.emailVerified){
                print('email verified');
              }
              print('verified');
            } on FirebaseAuthException catch (e) {
              if (e.code == 'invalid-action-code') {
                print('The code is invalid.');
              }
            }
          }else{
            print('deepLink is null');
          }
        },
        onError: (OnLinkErrorException e) async {
          print('onLinkError');
          print(e.message);
        }
    );
    final PendingDynamicLinkData data =
    await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri deepLink = data?.link;

    if (deepLink != null) {
      print('deeplink!!!');
    }else{
      print('no deeplink');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkStatus();
    });
  }
  @override
  Widget build(BuildContext context) {
    return Container();
  }

  void checkStatus() {
    User user = FirebaseAuth.instance.currentUser;
    if(FirebaseAuth.instance.currentUser == null){
      print('AppUser is currently signed out');
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => SignUpSignIn()));
    }else{
      print('AppUser is currently signed in');
      print(user.email);
      FirebaseFirestore.instance.collection('admin').where(Constant.email,isEqualTo: user.email).get().then((value) {
        if(value!= null){
          if(value.docs.isNotEmpty){
            print('it is admin');
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => AdminView()));
          }else{
            print('it is user');
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Home()));
          }
        }else{
          print('it is user');
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Home()));
        }
      });
    }
  }
}


