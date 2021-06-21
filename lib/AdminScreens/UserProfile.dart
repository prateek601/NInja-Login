import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Utils/Constants.dart';

class UserProfile extends StatefulWidget {

  QueryDocumentSnapshot<Map<String, dynamic>> doc;

  UserProfile(this.doc);

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  GeoPoint geoPoint;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    geoPoint = widget.doc[Constant.location];
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 40),
                child: Row(
                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                        flex: 1,
                        child: Container(
                        )),
                    Expanded(
                        flex: 8,
                        child: Container(
                          child: Center(child: Text('Profile',style: TextStyle(color: Colors.white,fontSize: 38),)),
                        )),
                    Expanded(
                        flex: 1,
                        child: Container()),

                  ],
                ),
              ),
              ListTile(
                title:Text('Name',style: TextStyle(color: Colors.white,fontSize: 30),),
                subtitle:Text(widget.doc[Constant.name],style: TextStyle(color: Colors.green,fontSize: 26),),
              ),
              SizedBox(height: 15,),
              ListTile(
                title:Text('Email',style: TextStyle(color: Colors.white,fontSize: 30),),
                subtitle:Text(widget.doc[Constant.email],style: TextStyle(color: Colors.green,fontSize: 26),),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
