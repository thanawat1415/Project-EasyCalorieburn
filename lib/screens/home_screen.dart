 // ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:mobile_final/Auth/login_screen.dart';
import 'package:mobile_final/Games/exam_screen.dart';
import 'package:mobile_final/model/user_model.dart';



 class HomeScreen extends StatefulWidget {
   const HomeScreen({ Key? key }) : super(key: key);
 
   @override
   _HomeScreenState createState() => _HomeScreenState();
 }
 
 class _HomeScreenState extends State<HomeScreen> {
    
   User? user = FirebaseAuth.instance.currentUser;
   UserModel loggedInUser = UserModel();
   @override

  final storage = new FlutterSecureStorage();
  
  final upDateWeightController = TextEditingController();

  String? valueText;

  @override
  void initState() {
    // TODO: implement initState
    super.initState(
    );
    FirebaseFirestore.instance
    .collection("users")
    .doc(user!.uid)
    .get()
    .then((value){
      this.loggedInUser = UserModel.fromMap(value.data());
      setState(() {}
      );
    });
  }
   @override
   Widget build(BuildContext context) {
     return Scaffold(
       backgroundColor: Color(0xFFF1F5FE),
       body: Container(
         padding: const EdgeInsets.only(top: 70,left: 30,right: 30),
         child: SingleChildScrollView(
           child: Column(
             
             children: [
             Row(
                 children: [
                   Text("Easy Calorie Burn",
                   style: TextStyle(
                     fontSize: 25,
                     color: Colors.black,
                     fontWeight: FontWeight.w700
                   ),
                  ),
                  Expanded(child: Container(
         
                  )),
                  IconButton(
                    icon: const Icon(Icons.logout,
                    size: 20,
                    color: Colors.black,
                    ),
                    onPressed: () async=>{
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
             Row(
               children: [
                 Text("Welcome to Easy Calorie Burn",
                   style: TextStyle(
                     fontSize: 15,
                     color: Colors.grey,
                     fontWeight: FontWeight.w700
                   ),
                  ),
               ],
             ),
             SizedBox(height: 20,),
             Container(
               width: MediaQuery.of(context).size.width,
               height: 170,
               decoration: BoxDecoration(
                 
                 gradient: LinearGradient(
                    colors: [
                      Color(0xFF1565C0),
                      Color(0xFF81DAFA),
                    ],
                    begin: Alignment.bottomLeft,
                    end: Alignment.bottomRight
                 ),
                 borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                  topRight: Radius.circular(60),
                 ),
                 boxShadow: [
                   BoxShadow(
                     offset: Offset(5,10),
                     blurRadius:20,
                     color: Colors.blue.shade300.withOpacity(0.2),
                   )
                 ]
               ),
             child: Container(
               padding: const EdgeInsets.only(left: 20,top: 15),
               child: Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   Text("น้ำหนักปัจจุบัน",
                   style: TextStyle(
                     color: Colors.white,
                     fontSize: 16,
                     fontWeight:FontWeight.bold,
                   ),
                   ),
                   SizedBox(height: 5),
                   Text("${loggedInUser.weight} กิโลกรัม",
                   style: TextStyle(
                     color: Colors.white,
                     fontSize: 25,
                     fontWeight: FontWeight.w400
                   ),
                   ),
                   SizedBox(height: 15),
                   Text("เผาผลาญจากการออกกำลังกาย",
                   style: TextStyle(
                     color: Colors.white,
                     fontSize: 16,
                     fontWeight:FontWeight.bold,
                   ),
                   ),
                   SizedBox(height: 5),
                   Row(
                     crossAxisAlignment: CrossAxisAlignment.end,
                     children: [
                     Row(
                     children: [
                       Icon(Icons.accessibility_new,
                       size: 30,
                       color: Colors.white,
                       ),
                       Text("0.00 Kcal",
                        style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w400
                        ),
                      ),
                      SizedBox(width: 60),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(horizontal: 8,vertical: 3),
                          minimumSize: Size(10, 25),
                          primary: Colors.blueAccent,
                          shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                          elevation: 2,
                          shadowColor: Colors.blue[400],
                        ),
                        icon: Icon(Icons.edit,
                        size: 20),
                        label: Text("แก้ไขน้ำหนัก"),
                        onPressed: (){
                          showDialog(
                          context: context, 
                          builder: (BuildContext context){
                            return AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25)
                              ),
                              title: Text("บันทึกน้ำหนัก",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                              content: TextField(
                                onChanged: (value) {
                                setState(() {
                                valueText = value;
                                });
                              },
                                  controller: upDateWeightController,
                                  decoration: InputDecoration(hintText: "กรอกน้ำหนักในวันนี้ของคุณ (กิโลกรัม)",
                                  ),
                                  keyboardType: TextInputType.number,
                            ),
                              actions: [
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.blueAccent[200],
                                    shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25)),
                                  ),
                                  onPressed: (){}, child: Text("บันทึกน้ำหนัก"))
                              ],
                            );
                          }
                          );
                        }),
                    ],
                   ),
                   ],
                  ),
                 ],
               ),
             ),
             ),
             SizedBox(height: 5),
              Container(
                height: 180,
                width: MediaQuery.of(context).size.width,
                child: Stack(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.only(top:30),
                      height: 120,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        image: DecorationImage(
                          image: AssetImage(
                            "assets/images/wall2.jpg"
                            ),
                          fit: BoxFit.fill
                        ),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 40,
                            offset: Offset(8,10),
                            color: Colors.lightBlueAccent.withOpacity(0.3),
                          ),
                          BoxShadow(
                            blurRadius: 10,
                            offset: Offset(-1,-5),
                            color: Colors.lightBlueAccent.withOpacity(0.3),
                          )
                        ]
                      ),
                    ),
                    Container(
                     height: 200,
                     width: MediaQuery.of(context).size.width,
                     margin: const EdgeInsets.only(right: 150,bottom: 20),
                     decoration: BoxDecoration(
                       borderRadius: BorderRadius.circular(20),
                       image: DecorationImage(
                         image:AssetImage(
                           "assets/images/run.png"
                        ),
                        fit:BoxFit.fill,
                       )
                     ),
                    ),
                    Container(
                      width: double.maxFinite,
                      height: 100,
                      // color: Colors.black.withOpacity(0.3),
                      margin: const EdgeInsets.only(left: 120,top: 50),
                      child: Column(
                        // crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("กราฟแสดงการออกกำลังกาย",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          ),
                          SizedBox(height: 10),
                          ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(horizontal: 20,vertical: 3),
                          minimumSize: Size(20, 30),
                          primary: Colors.blue[900],
                          shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                          elevation: 2,
                          shadowColor: Colors.blue[900],
                        ),
                        icon: Icon(Icons.arrow_forward,
                        size: 20),
                        label: Text("แสดงกราฟ",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                        ),
                        onPressed: (){}),
                        ],
                      ), 
                    ),
                  ],
                ),
              ),
                    SizedBox(height: 5),
                    Row(children: [
                      GestureDetector(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=> const gameEx()),);
                        },
                        child: Container(
                          width: 140,
                          height: 140,
                          padding: EdgeInsets.only(bottom: 5),
                          decoration: BoxDecoration(
                            color: Colors.indigo[100],
                            borderRadius: BorderRadius.circular(20),
                            image: DecorationImage(
                            image:AssetImage(
                              "assets/images/game2.png"
                        ),
                       ),
                       boxShadow: [
                         BoxShadow(
                           blurRadius: 3,
                           offset: Offset(5,5),
                           color: Colors.blueAccent.withOpacity(0.1),
                         ),
                         BoxShadow(
                           blurRadius: 3,
                           offset: Offset(-5,-5),
                           color: Colors.blueAccent.withOpacity(0.1),
                         ),
                       ],
                     ),
                          child: Center(
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: Text("เกมออกกำลังกาย",
                              style: TextStyle(
                                fontWeight:FontWeight.bold
                              ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 50),
                      GestureDetector(
                        onTap: (){
                          print("Open Ranking");
                        },
                        child: Container(
                          width: 140,
                          height: 140,
                          padding: EdgeInsets.only(bottom: 5),
                          decoration: BoxDecoration(
                            color: Colors.lime[200],
                            borderRadius: BorderRadius.circular(20),
                            image: DecorationImage(
                            image:AssetImage(
                              "assets/images/ranking.png"
                        ),
                       ),
                       boxShadow: [
                         BoxShadow(
                           blurRadius: 3,
                           offset: Offset(5,5),
                           color: Colors.blueAccent.withOpacity(0.1),
                         ),
                         BoxShadow(
                           blurRadius: 3,
                           offset: Offset(-5,-5),
                           color: Colors.blueAccent.withOpacity(0.1),
                         ),
                       ],
                     ),
                          child: Center(
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: Text("อันดับการแข่งขัน",
                              style: TextStyle(
                                fontWeight:FontWeight.bold
                              ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                    ),
              //       Expanded(child:ListView.builder(
              //         itemCount: 4,
              //         itemBuilder: (_,i){
              //           return Row(
              //             children: [
              //               Container(
              //                 width: 150,
              //                 height: 150,
              //                 decoration:BoxDecoration(
              //                   color: Colors.white,
              //                   borderRadius: BorderRadius.circular(15),
              //                   image: DecorationImage(
              //                     image: AssetImage(
              //                       "assets/images/game.png"
              //                     ),
              //                   ),
              //                   boxShadow: [
              //                     BoxShadow(
              //                       blurRadius: 3,
              //                       offset: Offset(5,5),
              //                       color: Colors.blueAccent.withOpacity(0.1)
              //                     ),
              //                     BoxShadow(
              //                       blurRadius: 3,
              //                       offset: Offset(-5,-5),
              //                       color: Colors.blueAccent.withOpacity(0.1)
              //                     ),
              //                   ],
              //                 ),
              //               ),
              //             ],
              //           );
              //         },
              //   ),
              // ),
             ],
           ),
         ),
       ),
     );
   }
    Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => Login()));
  }
}