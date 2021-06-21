
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/AdminScreens/UserProfile.dart';
import 'package:flutter_app/Utils/Constants.dart';

class UserSearch extends StatefulWidget {
  @override
  _UserSearchState createState() => _UserSearchState();
}

class _UserSearchState extends State<UserSearch> {
  var nameController = TextEditingController();

  String text = '';

  QuerySnapshot<Map<String, dynamic>> collection;



  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    nameController.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nameController.addListener(() {
      if(nameController.text.trim().isEmpty){
        setState(() {
          text = '';
        });
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(left: 10,right: 10,top:10),
            child: Column(
              children: [
                TextField(
                  controller: nameController,
                  cursorColor: Colors.black,
                  style: TextStyle(fontSize: 20),
                  decoration: InputDecoration(
                    hintText: 'search using name',
                      prefixIcon: Icon(Icons.search),
                      filled: true,
                      fillColor: Colors.white,
                      border: InputBorder.none
                  ),
                  onChanged: (val) {
                    if(val.trim().isNotEmpty){
                      get();
                    }else{
                      setState(() {
                        text = '';
                        collection = null;
                      });
                    }

                  },
                ),
                SizedBox(height: 40,),
                collection == null?Text(text,style: TextStyle(color: Colors.white,fontSize: 18),):
                Expanded(
                  child: ListView.builder(
                      itemCount: collection.docs.length,
                      itemBuilder: (context,index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: ListTile(
                            onTap: (){
                              Navigator.of(context).push(MaterialPageRoute(builder: (context)=>UserProfile(collection.docs[index])));
                            },
                            tileColor: Colors.grey[850],
                            title: Text(collection.docs[index][Constant.name],style: TextStyle(color: Colors.white),),
                          ),
                        );
                      }),
                )


              ],
            ),
          ),
        ),
      ),
    );
  }

  void get() {
    String name = nameController.text.toLowerCase().trim();
    FirebaseFirestore.instance.collection(Constant.users).where(Constant.searchKey,arrayContains:name).get().then((value) {
      print('getted');
      if(value!=null){
        if(value.docs.isNotEmpty){
          setState(() {
            collection = value;
            text = '';
          });
        }else{
          setState(() {
            text = 'No user found';
            collection = null;
          });
        }
      }else{
        setState(() {
          text  = 'No user found';
          collection = null;
        });
      }
    });
  }
}
