
import 'dart:math';
import 'dart:typed_data';
import 'package:insta/firebase_services/firestore.dart';
import 'package:insta/provider/user_provider.dart';
import 'package:path/path.dart' show basename;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:insta/shared/colors.dart';
import 'package:provider/provider.dart';

class AddPost extends StatefulWidget {
  const AddPost({Key? key}) : super(key: key);

  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  final desController = TextEditingController();

  Uint8List? imgPath;
  String? imgName;
  bool isLoading = false;

  showmodel() {
    return showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(22),
          height: 170,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () async {
                  await uploadImage2Screen(ImageSource.camera);
                },
                child: Row(
                  children: const [
                    Icon(
                      Icons.camera,
                      size: 30,
                    ),
                    SizedBox(
                      width: 11,
                    ),
                    Text(
                      "From Camera",
                      style: TextStyle(fontSize: 20),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 22,
              ),
              GestureDetector(
                onTap: () {
                  uploadImage2Screen(ImageSource.gallery);
                },
                child: Row(
                  children: const [
                    Icon(
                      Icons.photo_outlined,
                      size: 30,
                    ),
                    SizedBox(
                      width: 11,
                    ),
                    Text(
                      "From Gallery",
                      style: TextStyle(fontSize: 20),
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
  uploadImage2Screen(ImageSource source) async {
    Navigator.pop(context);
    final XFile? pickedImg = await ImagePicker().pickImage(source: source);
    try {
      if (pickedImg != null) {
        imgPath = await pickedImg.readAsBytes();
        setState(() {
          imgName = basename(pickedImg.path);
          int random = Random().nextInt(9999999);
          imgName = "$random$imgName";
          print(imgName);
        });
      } else {
        print("NO img selected");
      }
    } catch (e) {
      print("Error => $e");
    }
  }
  @override
  Widget build(BuildContext context) {
    final allDataFromDB = Provider.of<UserProvider>(context).getUser;

    return imgPath == null ?
       Scaffold(
      backgroundColor: mobileBackgroundColor,
     body: Center(
       child: IconButton(
              onPressed: () {
                showmodel();
              },
              icon: const Icon(
                Icons.upload,
                size: 55,
              )),
     ),
    ): Scaffold(
      backgroundColor: mobileBackgroundColor,
      appBar: AppBar(
        actions: [
          TextButton(
              onPressed: () async{
                setState(() {
                  isLoading = true;
                });
                await FirestoreMethods().uploadPost(
                    imgName: imgName,
                    imgPath: imgPath,
                    description: desController.text,
                    profileImg: allDataFromDB!.profileImg,
                    username: allDataFromDB.username,
                    context: context);
                setState(() {
                  isLoading = false;
                  imgName =null;
                });
              },
              child: const Text(
                "Post",
                style: TextStyle(
                    color: Colors.blueAccent,
                    fontSize: 19,
                    fontWeight: FontWeight.bold),
              )),
        ],
        backgroundColor: mobileBackgroundColor,
        leading: IconButton(
            onPressed: () {
              setState(() {
                imgPath = null;
              });
            }, icon: const Icon(Icons.arrow_back)),
      ),
      body: Column(
        children: [
       isLoading ?const LinearProgressIndicator():
      const Divider(
            thickness: 1,
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 33,
                backgroundImage: NetworkImage(
                    allDataFromDB!.profileImg),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.3,
                child: TextField(
                  controller: desController,
                  maxLines: 8,
                  decoration: const InputDecoration(
                      hintText: "write a caption...",
                      border: InputBorder.none),
                ),
              ),
              Container(
                width: 66,
                height: 74,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: MemoryImage(imgPath!), fit: BoxFit.cover,

                    )),
              )
            ],
          ),
        ],
      ),

    );
  }
}
