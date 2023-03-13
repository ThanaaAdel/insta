import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:insta/provider/user_provider.dart';
import 'package:insta/responsive/mobile.dart';
import 'package:insta/responsive/responsive.dart';
import 'package:insta/responsive/web.dart';
import 'package:insta/screens/sign_in.dart';
import 'package:insta/shared/snakbar.dart';
import 'package:provider/provider.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyCsoNWQGp0gK0w-oJ_HclrpHzIxw4laBh4",
            authDomain: "insta-c15b7.firebaseapp.com",
            projectId: "insta-c15b7",
            storageBucket: "insta-c15b7.appspot.com",
            messagingSenderId: "724883202315",
            appId: "1:724883202315:web:de71817fa98286a15a420e"
        ));
  } else {
    await Firebase.initializeApp();
  }
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) {return UserProvider();},
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark(),
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ));
            } else if (snapshot.hasError) {
              return showSnackBar(context, "Something went wrong");
            } else if (snapshot.hasData) {
              return const Resposive(
                myMobileScreen: MobileScerren(),
                myWebScreen: WebScerren(),
              );
            } else {
              return const Login();
            }
          },
        ),

      ),
    );
  }
}
