import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/AdminScreens/UserProfile.dart';
import 'package:flutter_app/AdminScreens/UserSearch.dart';
import 'package:flutter_app/Utils/Constants.dart';

class ListAllUsers extends StatefulWidget {

  QuerySnapshot<Map<String, dynamic>> collectionData;


  ListAllUsers(this.collectionData);

  @override
  _ListAllUsersState createState() => _ListAllUsersState();
}

class _ListAllUsersState extends State<ListAllUsers> {
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
                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                        flex: 1,
                        child: Container()),
                    Expanded(
                        flex: 8,
                        child: Container(
                          child: Center(child: Text('Users',style: TextStyle(color: Colors.white,fontSize: 38),)),
                        )),
                    Expanded(
                        flex: 1,
                        child: Container(
                          child:
                          IconButton(
                            icon: Icon(Icons.search,color: Colors.white,),
                            onPressed: (){
                              Navigator.of(context).push(MaterialPageRoute(builder: (context)=>UserSearch()));
                            },
                            splashRadius: 25,
                            padding: EdgeInsets.zero,
                            alignment: Alignment.centerLeft,
                          ),
                        )),
                  ],
                ),
              ),
              widget.collectionData == null?
                  Padding(
                    padding: const EdgeInsets.only(top: 60),
                    child: Text('No user found!',style: TextStyle(color: Colors.white,fontSize: 40),),
                  )
                  :Expanded(
                    child: ListView.builder(
                    itemCount: widget.collectionData.docs.length,
                    itemBuilder: (context,index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: ListTile(
                          onTap: (){
                            Navigator.of(context).push(MaterialPageRoute(builder: (context)=>UserProfile(widget.collectionData.docs[index])));
                          },
                          tileColor: Colors.grey[850],
                          title: Text(widget.collectionData.docs[index][Constant.name],style: TextStyle(color: Colors.white),),
                        ),
                      );
                    }),
                  )

            ],
          ),
        ),
      ),
    );
  }
}
