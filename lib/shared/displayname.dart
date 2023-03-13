// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DisplayName extends StatefulWidget {
  const DisplayName({
    Key? key,
  }) : super(key: key);

  @override
  State<DisplayName> createState() => _DisplayNameState();
}

class _DisplayNameState extends State<DisplayName> {
  final credential = FirebaseAuth.instance.currentUser;
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  @override
  Widget build(BuildContext context) {
    CollectionReference users =
    FirebaseFirestore.instance.collection('users');

    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(credential!.uid).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return Text("Document does not exist");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
          snapshot.data!.data() as Map<String, dynamic>;

          // ${data['title']}
          return  Text(
            "${data['username']}",
            style: TextStyle(
              fontSize: 33,
            ),
          );

        }

        return Text("loading");
      },
    );
  }
}