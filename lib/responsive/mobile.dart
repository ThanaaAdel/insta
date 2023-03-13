// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

 

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:insta/provider/user_provider.dart';
import 'package:insta/screens/add_post.dart';
import 'package:insta/screens/home.dart';
import 'package:insta/screens/profile.dart';
import 'package:insta/screens/search.dart';
import 'package:insta/shared/colors.dart';
import 'package:provider/provider.dart';

class MobileScerren extends StatefulWidget {
  const MobileScerren({Key? key}) : super(key: key);

  @override
  State<MobileScerren> createState() => _MobileScerrenState();
}

class _MobileScerrenState extends State<MobileScerren> {
  final PageController _pageController = PageController();

  int currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
// To get data from DB using provider
  getDataFromDB() async {
    UserProvider userProvider = Provider.of(context, listen: false);
    await userProvider.refreshUser();
  }


  @override
  void initState() {
    super.initState();
    getDataFromDB();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CupertinoTabBar(
          backgroundColor: mobileBackgroundColor,
          onTap: (index) {
            // navigate to the tabed page
            _pageController.jumpToPage(index);
            setState(() {
              currentPage = index;
            });

            // print(   "---------------    $index "  );
          },
          items: [
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.home,
                  color: currentPage == 0 ? primaryColor : secondaryColor,
                ),
                label: ""),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.search,
                  color: currentPage == 1 ? primaryColor : secondaryColor,
                ),
                label: ""),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.add_circle,
                  color: currentPage == 2 ? primaryColor : secondaryColor,
                ),
                label: ""),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.favorite,
                  color: currentPage == 3 ? primaryColor : secondaryColor,
                ),
                label: ""),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.person,
                  color: currentPage == 4 ? primaryColor : secondaryColor,
                ),
                label: ""),
          ]),
      body: PageView(
        onPageChanged: (index) {
          print("------- $index");
        },
        physics: NeverScrollableScrollPhysics(),
        controller: _pageController,
        children: [
          Home(),
          Search(),
          AddPost(),
          Center(child: Text("Love u ♥")),
          Profile(uid: FirebaseAuth.instance.currentUser!.uid,),
        ],
      ),
    );
  }
}
