// ignore_for_file: prefer_const_constructors

import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_final/model/user_model.dart';

class editUserScreen extends StatefulWidget {
  const editUserScreen({Key? key}) : super(key: key);

  @override
  _editUserScreenState createState() => _editUserScreenState();
}

class _editUserScreenState extends State<editUserScreen> {
  UserModel? userModel;
  final formKey = GlobalKey<FormState>();
  
  String? imageProfile;
  File? image;

  Future uploadPic() async{
    Random random = Random();
    int i = random.nextInt(100000);

    FirebaseStorage firebaseStorage = FirebaseStorage.instance;
    Reference reference = firebaseStorage.ref().child('user/user$i.jpg');
    UploadTask uploadTask = reference.putFile(image!);
    imageProfile = await uploadTask.then((res) => res.ref.getDownloadURL());
    print('${imageProfile}');
  }

  Future pickImage(ImageSource source) async{
    try{
      final image = await ImagePicker().pickImage(source: source);
      if(image == null)return;

      final imageTemporary = File(image.path);
      setState(()=> this.image = imageTemporary);
    }on PlatformException catch(e){
      print("Failed");
    }
  }

  Future getImage(ImageSource source) async{
    try{
      final image = await ImagePicker().pickImage(source: source);
      if(image == null)return;

      final imageTemporary = File(image.path);
      setState(()=> this.image = imageTemporary);
    }on PlatformException catch(e){
      print("Failed");
    }
  }

  Future findProfile() async {
    await FirebaseAuth.instance.authStateChanges().listen((event) async {
      String uid = event!.uid;
      print('## uid = $uid');
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get()
          .then((value) {
        setState(() {
          userModel = UserModel.fromMap(value.data()!);
        });
      });
      print('${userModel == null ? '## null' : '## ${userModel!.imageUrl}'}');
    });
  }

  @override
  void initState() {
    findProfile();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: userModel == null
          ? Center(child: CircularProgressIndicator())
          : Container(
              padding: const EdgeInsets.only(top: 70, left: 30, right: 30),
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(
                              Icons.arrow_back_ios,
                              size: 20,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Row(
                        children: [
                          Text(
                            "แก้ไขข้อมูลส่วนตัว",
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w700,
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      Stack(
                        children: [
                          Container(
                            width: 130,
                            height: 130,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    width: 4,
                                    color: Theme.of(context)
                                        .scaffoldBackgroundColor),
                                boxShadow: [
                                  BoxShadow(
                                    spreadRadius: 2,
                                    blurRadius: 10,
                                    color: Colors.black.withOpacity(0.1),
                                    offset: Offset(0, 10),
                                  )
                                ],
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(
                                        "${userModel!.imageUrl}"))),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    width: 4,
                                    color: Theme.of(context)
                                        .scaffoldBackgroundColor,
                                  ),
                                  color: Colors.lightBlue),
                              child: IconButton(
                                icon: const Icon(Icons.logout,
                                size: 20,
                                color: Colors.black,
                                ),
                                onPressed: (){
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text(
                                          "Chose Options",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            color: Colors.blue,
                                          ),
                                        ),
                                        content: SingleChildScrollView(
                                          child: ListBody(
                                            children: [
                                              InkWell(
                                                onTap: () => pickImage(
                                                    ImageSource.camera),
                                                splashColor: Colors.blueAccent,
                                                child: Row(
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Icon(
                                                        Icons.camera,
                                                        color:
                                                            Colors.blueAccent,
                                                      ),
                                                    ),
                                                    Text(
                                                      "Camera",
                                                      style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Colors.blue[900],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              InkWell(
                                                onTap: () => pickImage(
                                                    ImageSource.gallery),
                                                splashColor: Colors.blueAccent,
                                                child: Row(
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Icon(
                                                        Icons.image,
                                                        color:
                                                            Colors.blueAccent,
                                                      ),
                                                    ),
                                                    Text(
                                                      "Gallery",
                                                      style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Colors.blue[900],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  uploadPic();
                                                },
                                                child: Container(
                                                  height: 40.0,
                                                  width: 100,
                                                  padding: EdgeInsets.all(10.0),
                                                  decoration: BoxDecoration(
                                                    color: Colors.green
                                                        .withOpacity(0.9),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      "ยืนยัน",
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    });
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 30),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                            topRight: Radius.circular(70),
                            bottomLeft: Radius.circular(20),
                          ),
                          gradient: LinearGradient(
                            colors: [
                              Colors.lightBlue.shade50.withOpacity(0.9),
                              Colors.lightBlue.shade100.withOpacity(0.9),
                            ],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),
                        ),
                        child: Column(
                          children: [
                            SizedBox(height: 30),
                            Row(
                              children: [
                                SizedBox(width: 10),
                                Text(
                                  "ชื่อผู้ใช้",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(width: 35),
                                Container(
                                  alignment: Alignment.center,
                                  width: 180,
                                  height: 40,
                                  child: TextFormField(
                                    validator: (value) {
                                      RegExp regex = new RegExp(r'^.{2,}$');
                                      if (value!.isEmpty) {
                                        return ("กรุณากรอกชื่อผู้ใช้");
                                      }
                                      if (!regex.hasMatch(value)) {
                                        return ("กรุณากรอกชื่อผู้ใช้มากกว่า 2 ตัวอักษร");
                                      }
                                      return null;
                                    },
                                    onSaved: (String? name) {
                                      userModel!.username = name!;
                                    },
                                    initialValue: userModel!.username,
                                    decoration: InputDecoration(
                                        contentPadding:
                                            EdgeInsets.fromLTRB(10, 0, 0, 0),
                                        fillColor: Colors.white,
                                        filled: true,
                                        hintText: '${userModel!.username}',
                                        hintStyle: TextStyle(fontSize: 18),
                                        border: OutlineInputBorder()),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 30),
                            Row(
                              children: [
                                SizedBox(width: 10),
                                Text(
                                  "อายุ",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(width: 60),
                                Container(
                                  alignment: Alignment.center,
                                  width: 100,
                                  height: 40,
                                  child: TextFormField(
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return userModel!.age;
                                      } else if (int.tryParse(value)! > 100) {
                                        return 'อายุไม่ถูกต้อง';
                                      } else {
                                        return null;
                                      }
                                    },
                                    onSaved: (String? age) {
                                      userModel!.age = age!;
                                    },
                                    initialValue: userModel!.age,
                                    decoration: InputDecoration(
                                        contentPadding:
                                            EdgeInsets.fromLTRB(10, 0, 0, 0),
                                        fillColor: Colors.white,
                                        filled: true,
                                        hintText: '${userModel!.age}',
                                        hintStyle: TextStyle(fontSize: 18),
                                        border: OutlineInputBorder()),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 30),
                            Row(
                              children: [
                                SizedBox(width: 10),
                                Text(
                                  "ส่วนสูง",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(width: 40),
                                Container(
                                  alignment: Alignment.center,
                                  width: 100,
                                  height: 40,
                                  child: TextFormField(
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return userModel!.height;
                                      } else if (int.tryParse(value)! > 250) {
                                        return 'ส่วนสูงไม่ถูกต้อง';
                                      } else {
                                        return null;
                                      }
                                    },
                                    onSaved: (String? height) {
                                      userModel!.height = height!;
                                    },
                                    initialValue: userModel!.height,
                                    decoration: InputDecoration(
                                        contentPadding:
                                            EdgeInsets.fromLTRB(10, 0, 0, 0),
                                        fillColor: Colors.white,
                                        filled: true,
                                        hintText: '${userModel!.height}',
                                        hintStyle: TextStyle(fontSize: 18),
                                        border: OutlineInputBorder()),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 30),
                            Row(
                              children: [
                                SizedBox(width: 10),
                                Text(
                                  "น้ำหนัก",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(width: 37),
                                Container(
                                  alignment: Alignment.center,
                                  width: 100,
                                  height: 40,
                                  child: TextFormField(
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return userModel!.weight;
                                      } else if (int.tryParse(value)! > 150) {
                                        return 'น้ำหนักไม่ถูกต้อง';
                                      } else {
                                        return null;
                                      }
                                    },
                                    onSaved: (String? weight) {
                                      userModel!.weight = weight!;
                                    },
                                    
                                    initialValue: userModel!.weight,
                                    decoration: InputDecoration(
                                      isCollapsed: false,
                                        contentPadding:
                                            EdgeInsets.fromLTRB(10, 0, 0, 0),
                                        fillColor: Colors.white,
                                        filled: true,
                                        hintText: '${userModel!.weight}',
                                        hintStyle: TextStyle(fontSize: 18),
                                        border: OutlineInputBorder()),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                          ],
                        ),
                      ),
                      SizedBox(height: 30),
                      Row(
                        children: [
                          SizedBox(width: 150),
                          GestureDetector(
                            onTap: () async {
                              if (formKey.currentState!.validate()) {
                                formKey.currentState?.save();
                                try {
                                  await FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(userModel!.uid)
                                      .update({
                                    'age': userModel!.age,
                                    'email': userModel!.email,
                                    'height': userModel!.height,
                                    'weight': userModel!.weight,
                                    'imageUrl': imageProfile,
                                    'uid': userModel!.uid,
                                    'username': userModel!.username,
                                  });
                                  Navigator.pop(context);
                                } catch (e) {}
                              }
                            },
                            child: Container(
                              height: 50.0,
                              width: 180,
                              padding: EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                color: Colors.green.shade700,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Center(
                                child: Text(
                                  "ยืนยันการแก้ไข",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
