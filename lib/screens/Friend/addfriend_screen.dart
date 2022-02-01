import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobile_final/model/user_model.dart';

class addFriends extends StatefulWidget {
  const addFriends({Key? key}) : super(key: key);

  @override
  _addFriendsState createState() => _addFriendsState();
}

class _addFriendsState extends State<addFriends> {
  String? nameF; //ตัวแปรที่เก็บ Text
  List<UserModel> modelFriends = []; //list ข้อมูลของเพื่อน
  int times = 0; //จำนวนคน
  UserModel? userModel; //ตัวเราเอง

  String? uidMe; //uid ของเรา
  final formKey = GlobalKey<FormState>();
  String? uid; //uid เราแต่คนละฟีเจอร์

  //หาข้อมูลเรา
  Future findUid() async {
    await FirebaseAuth.instance.authStateChanges().listen((event) async{
      uidMe = event!.uid;
      print('## uid = $uidMe');
      await FirebaseFirestore.instance
        .collection('users')
        .doc(uidMe)
        .get()
        .then((value) {
          setState(() {
            userModel =UserModel.fromMap(value.data()!);
          });
        });
      print('${userModel == null ? '## null': '## ${userModel!.imageUrl}'}');
    });
  }

  //หาข้อมูลของเพื่อน
  Future findFriends() async {
    await FirebaseAuth.instance.authStateChanges().listen((event) async {
      uid = event!.uid;
      print('## uid = $uid');
      await FirebaseFirestore.instance
          .collection('users')
          .where('username', isEqualTo: nameF)
          .get()
          .then((value) {
        int i = 0;
        for (var item in value.docs) {
          UserModel model = UserModel.fromMap(item.data());
          setState(() {
            modelFriends.add(model);
            times = i;
            i++;
          });
        }
      });
      for (int j = 0; j <= times; j++) {
        print(modelFriends[j].uid);

      }
    });
  }

  //widget ข้อมูลที่แสดง
  Widget listFriendss() {
    return Container(
      child: Column(
        children: modelFriends.map((e) {
          return Container(
              child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                CircleAvatar(
                  minRadius: 0,
                  maxRadius: 70,
                  backgroundColor: Colors.blue.shade100,
                  child: CircleAvatar(
                    radius: 90,
                    backgroundColor: Colors.transparent,
                    child: ClipOval(
                      child: Image.network(
                        "${e.imageUrl}",
                        width: 130,
                        height: 130,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
                Text(e.username.toString()),
                GestureDetector(
                  onTap: () async {
                    await FirebaseFirestore.instance
                        .collection('users')
                        .doc(e.uid.toString())
                        .collection('addfriends')
                        .doc(uid)
                        .set({
                          'uid': uidMe,
                          'username': userModel!.username,
                          'imageUrl': userModel!.imageUrl,
                        }).then((value) {
                          setState(() {
                            modelFriends = [];
                          });
                      print("success");
                    });
                  },
                  child: Container(
                    height: 50.0,
                    width: 150,
                    padding: EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      color: Colors.green.shade700,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Text(
                        "เพิ่มเพื่อน",
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
            ),
          ));
        }).toList(),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    findUid();
  }

  Widget build(BuildContext context) {

    return Scaffold(
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.only(top: 70, left: 30, right: 30),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(children: [
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
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Text(
                    "เพิ่มเพื่อน",
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w700,
                    ),
                  )
                ],
              ),
              SizedBox(height: 30),
              Container(
                color: Colors.white,
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        onSaved: (String? name) {
                          nameF = name!;
                        },
                        style: TextStyle(
                          color: Colors.black,
                        ),
                        decoration:
                            InputDecoration(hintText: "ค้นหาด้วยรายชื่อ"),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.search_rounded),
                      onPressed: () {
                        formKey.currentState?.save();
                        findFriends();
                      },
                    ),
                  ],
                ),
              ),
              listFriendss()
            ]),
          ),
        ),
      ),
    );
  }
}
