import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/AdminScreens/ListAllUsers.dart';
import 'package:flutter_app/main.dart';

import '../Utils/Constants.dart';

class AdminView extends StatefulWidget {
  @override
  _AdminViewState createState() => _AdminViewState();
}

class _AdminViewState extends State<AdminView> {
  QuerySnapshot<Map<String, dynamic>> collectionData ;

  int collectionSize = 0;

  var loading = true;


  @override
  void initState() {
    super.initState();
    print(collectionData);
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: loading?
          Center(child:CircularProgressIndicator(backgroundColor: Colors.green[800],color: Colors.green[300],)):
      SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                     // crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('Hi,',style: TextStyle(color: Colors.white,fontSize: 42),),
                        Text(' Mr Admin!',style: TextStyle(color: Colors.white,fontSize: 28),),
                      ],
                    ),

                    IconButton(
                      icon: Icon(Icons.logout,color: Colors.white,),
                      onPressed: (){
                        logOut();
                      },
                      splashRadius: 25,
                      padding: EdgeInsets.zero,
                      alignment: Alignment.center,
                    )
                  ],
                ),
              ),
              Card(
                child: Container(
                  height: 200,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    children: [
                      Text('DashBoard',style: TextStyle(color: Colors.grey[900],fontSize: 36),),
                      Padding(
                        padding: const EdgeInsets.only(top: 20,bottom: 20),
                        child: Text('Total users',style: TextStyle(color: Colors.white,fontSize: 32),),
                      ),
                      Text(collectionSize.toString(),style: TextStyle(color: Colors.black,fontSize: 48),)
                    ],
                  ),
                ),
                color: Colors.grey,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 150),
                child: InkWell(
                  onTap: (){
                   Navigator.of(context).push(MaterialPageRoute(builder: (context) => ListAllUsers(collectionData)));
                  },
                  child: Container(
                    height: 50,
                    width: 120,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Center(child: Text('Users',style: TextStyle(color: Colors.black,fontSize: 22),)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void getData() {
    FirebaseFirestore.instance.collection(Constant.users).get().then((value) {
      if(value!=null){
        if(value.docs.isNotEmpty){
          setState(() {
            loading = false;
            collectionData = value;
            collectionSize = value.docs.length;
          });
          print('users found');
        }else{
          setState(() {
            loading = false;
          });
          print('collection is empty.No user found');
        }
      }else{
        setState(() {
          loading = false;
        });
        print('collection is null.No user found');
      }

    });
  }

  Future<void> logOut() async {
    await FirebaseAuth.instance.signOut();
    print('Admin signed out');
    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>App()), (route) => false);
  }
}
