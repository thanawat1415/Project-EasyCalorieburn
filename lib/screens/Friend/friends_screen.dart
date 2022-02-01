import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mobile_final/Auth/login_screen.dart';
import 'package:mobile_final/model/user_model.dart';
import 'package:mobile_final/screens/Friend/acfriend.dart';
import 'package:mobile_final/screens/Friend/addfriend_screen.dart';

class FriendScreen extends StatefulWidget {
  const FriendScreen({Key? key}) : super(key: key);

  @override
  _FriendScreenState createState() => _FriendScreenState();
}

class _FriendScreenState extends State<FriendScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? user = FirebaseAuth.instance.currentUser;

  final storage = new FlutterSecureStorage();
  List<UserModel> modelFriends = [];
  UserModel? userModel;
  String? uidMe;
  String? uid;
  int times = 0;

  Future findUid() async {
    await FirebaseAuth.instance.authStateChanges().listen((event) async {
      uidMe = event!.uid;
      print('## uid = $uidMe');
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uidMe)
          .get()
          .then((value) {
        setState(() {
          userModel = UserModel.fromMap(value.data()!);
        });
      });
      print('${userModel == null ? '## null' : '## ${userModel!.imageUrl}'}');
    });
  }

  Future findFriends() async {
    await FirebaseAuth.instance.authStateChanges().listen((event) async {
      uid = event!.uid;
      print('## uid = $uid');
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('friends')
          .where('username', isNotEqualTo: 'a')
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
      // for (int j = 0; j <= times; j++) {
      //   print(modelFriends[j].uid);

      // }
    });
  }

  Widget listFriendss() {
    return Container(
      height: 450,
      width: 300,
      
      child: SingleChildScrollView(
        child: Column(
          children: modelFriends.map((e) {
            return Container(
                child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.blueGrey),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                        topRight: Radius.circular(50),
                        bottomLeft: Radius.circular(10),
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
                    child: Row(
                      children: [
                        CircleAvatar(
                          minRadius: 0,
                          maxRadius: 40,
                          backgroundColor: Colors.blue.shade100,
                          child: CircleAvatar(
                            radius: 90,
                            backgroundColor: Colors.transparent,
                            child: ClipOval(
                              child: Image.network(
                                "${e.imageUrl}",
                                width: 70,
                                height: 70,
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 50),
                        Text(
                          e.username.toString(),
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ));
          }).toList(),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    findFriends();
    findUid();
    listFriendss();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        padding: const EdgeInsets.only(top: 70, left: 30, right: 30),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  "รายชื่อเพื่อน",
                  style: TextStyle(
                      fontSize: 25,
                      color: Colors.black,
                      fontWeight: FontWeight.w700),
                ),
                Expanded(child: Container()),
                IconButton(
                  icon: const Icon(
                    Icons.logout,
                    size: 20,
                    color: Colors.black,
                  ),
                  onPressed: () async => {
                    // logout(context)
                    await FirebaseAuth.instance.signOut(),
                    await storage.delete(key: "uid"),
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Login(),
                        ),
                        (route) => false)
                  },
                ),
              ],
            ),
            SizedBox(height: 20),
            listFriendss(),
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const addFriends()),
                    );
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
                SizedBox(width: 30),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const accectFriend()),
                    );
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
                        "คำขอเป็นเพื่อน",
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
    );
  }
}

Future<void> logout(BuildContext context) async {
  await FirebaseAuth.instance.signOut();
  Navigator.of(context)
      .pushReplacement(MaterialPageRoute(builder: (context) => Login()));
}
