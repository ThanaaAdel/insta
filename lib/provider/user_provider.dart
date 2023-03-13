





import 'package:flutter/material.dart';
import 'package:insta/firebase_services/auth.dart';
import 'package:insta/models/users.dart';


class UserProvider with ChangeNotifier {
  UserDate? _userData;
  UserDate? get getUser => _userData;

  refreshUser() async {
    UserDate userData = await AuthMethods().getUserDetails();
    _userData = userData;
    notifyListeners();
  }
}