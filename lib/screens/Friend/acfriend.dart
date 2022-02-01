
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobile_final/model/user_model.dart';

class accectFriend extends StatefulWidget {
  const accectFriend({Key? key}) : super(key: key);

  @override
  _accectFriendState createState() => _accectFriendState();
}

class _accectFriendState extends State<accectFriend> {
  List<UserModel> modelFriends = []; //list ข้อมูลของเพื่อน
  int times = 0;  //จำนวนครั้ง
  String? uid, uidMe;
  UserModel? userModel;


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
          .collection('addfriends')
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
    });
  }

  Widget listFriendss() {
    return Container(
      child: 
      Column(
        children: modelFriends.map((e) {
          return Container(
              child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(uid)
                  .collection('addfriends')
                  .where('username')
                  .snapshots()
                  ,
                  builder: (context,snapshot){
                   if(!snapshot.hasData){
                     return Center(
                       child: Text("no data"),
                     );
                   }
                   final DocumentSnapshotList = snapshot.data!.docs;
                   
                   return Text('${DocumentSnapshotList.length}');
                  }),
                // StreamBuilder(
                //   stream: FirebaseFirestore.instance
                //   .collection('users')
                //   .where('username',isEqualTo: 'adminMoo')
                //   .snapshots(),
                //   builder: (BuildContext context, AsyncSnapshot snapshot){
                //   return Text(snapshot.data.documents.length.toString());
                // }),
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
                    //เก็บข้อมูลเพื่อน
                    await FirebaseFirestore.instance
                        .collection('users')
                        .doc(uidMe)
                        .collection('friends')
                        .doc(e.uid)
                        .set({
                      'uid': e.uid,
                      'username': e.username,
                      'imageUrl': e.imageUrl,
                    }).then((value) async {
                      //เก็บข้อมูลเราให้เพื่อน
                      await FirebaseFirestore.instance
                          .collection('users')
                          .doc(e.uid)
                          .collection('friends')
                          .doc(uidMe)
                          .set({
                        'uid': uidMe,
                        'username': userModel!.username,
                        'imageUrl': userModel!.imageUrl,
                      }).then((val) async {
                        //ลบข้อมูลการแอดเพื่อน
                        await FirebaseFirestore.instance
                            .collection('users')
                            .doc(uidMe)
                            .collection('addfriends')
                            .doc(e.uid)
                            .delete()
                            .then((value)  {
                              setState(() {
                                modelFriends = [];
                              });
                            });
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
  @override
  void initState() {
    super.initState();
    findFriends();
    findUid();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ยืนยันเพื่อน"),
      ),
      body: modelFriends.isEmpty 
      ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [CircularProgressIndicator(
          )],
        ),
      ) 
      :Center(
        child: Container(
          child: listFriendss(),
        ),
      ),
    );
  }
}
