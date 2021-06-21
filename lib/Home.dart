import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Utils/Constants.dart';
import 'package:flutter_app/main.dart';
import 'package:geolocator/geolocator.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  @override
  void initState() {
    super.initState();
    getGeoLocation();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      // crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('Hello!',style: TextStyle(color: Colors.white,fontSize: 28),),
                        //Text(' Mr Admin!',style: TextStyle(color: Colors.white,fontSize: 28),),
                      ],
                    ),

                    IconButton(
                      icon: Icon(Icons.logout,color: Colors.white,),
                      onPressed: () async {
                        await FirebaseAuth.instance.signOut();
                        print('User signed out');
                        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>App()), (route) => false);
                      },
                      splashRadius: 25,
                      padding: EdgeInsets.zero,
                      alignment: Alignment.center,
                    ),
                  ],
                ),
              ),
              SizedBox(
                  height: Constant.returnHeight(context) * .3,
                  width: Constant.returnWidth(context),
                  child: Image(image: AssetImage('assets/party.gif'))),
              Padding(
                padding: const EdgeInsets.only(top: 170),
                child: InkWell(
                  onTap: () async {
                    alert();
                  },
                  child: Container(
                    height: 40,
                    width: 150,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25)
                    ),
                    child: Center(child: Text('Delete Account',style: TextStyle(color: Colors.black),)),
                  ),
                ),
              )
            ],
          ),
        ),
      )
    );
  }

    getGeoLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    Position position = await Geolocator.getCurrentPosition();
    print(position);
    updateLocation(position);
  }

  void updateLocation(Position position) {
    User user = FirebaseAuth.instance.currentUser;
    FirebaseFirestore.instance.doc(Constant.users+'/'+user.uid).set({Constant.location : GeoPoint(position.latitude,position.longitude)},SetOptions(merge: true)).then((value) {
      print('location successfully updated');
    });
  }


  alert() {
    return showDialog(
      context: context,
      builder: (context){
        return AlertDialog(
         // backgroundColor: Colors.grey[800],
          title: Text('Alert'),
          content: Text('Do you really want to delete your account?'),
          actions: [
            InkWell(
              onTap: (){
                Navigator.of(context).pop();
              },
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Text('No'),
              ),
            ),
            InkWell(
              onTap: () async {
                User user = FirebaseAuth.instance.currentUser;
                await FirebaseFirestore.instance.doc(Constant.users+'/'+user.uid).delete();
                await FirebaseAuth.instance.currentUser.delete();
                print('account deleted');
                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>App()), (route) => false);
              },
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Text('Yes'),
              ),
            ),

          ],
        );
      }
    );
  }
}
