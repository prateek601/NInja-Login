import 'package:flutter/material.dart';
import 'PhoneNumber.dart';
import 'package:flutter_app/Utils/Constants.dart';
import 'package:get_storage/get_storage.dart';

class Name extends StatefulWidget {
  @override
  _NameState createState() => _NameState();
}

class _NameState extends State<Name> {
  var nameController = TextEditingController();

  List list = [] ;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    nameController.dispose();
    GetStorage().remove(Constant.name);
    print(GetStorage());
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                        flex: 1,
                        child: Container(
                          child:
                          IconButton(
                            icon: Icon(Icons.arrow_back,color: Colors.white,),
                            onPressed: (){},
                            splashRadius: 25,
                            padding: EdgeInsets.zero,
                            alignment: Alignment.centerLeft,
                          ),
                        )),
                    Expanded(
                        flex: 8,
                        child: Container(
                          child: Center(child: Text('Create Account',style: TextStyle(color: Colors.white,fontSize: 20),)),
                        )),
                    Expanded(
                        flex: 1,
                        child: Container()),

                  ],
                ),
                SizedBox(height: 30,),
                Text('What\'s your Name?',style: TextStyle(color: Colors.white,fontSize: 30),),
                SizedBox(height: 10,),
                TextField(
                  controller: nameController,
                  cursorColor: Colors.black,
                  style: TextStyle(fontSize: 20),
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: InputBorder.none
                  ),
                  onChanged: (val) {
                  },
                ),
                SizedBox(height: 7,),
                Text('',style: TextStyle(color: Colors.white,fontSize: 12),),
                SizedBox(height: 100,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 100),
                  child: InkWell(
                    onTap: () {
                      print('Tapped');
                      print(nameController.text.trim());
                      final box = GetStorage();
                      box.write(Constant.name, nameController.text.trim());
                      searchKey();

                    },
                    borderRadius: BorderRadius.circular(25),
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(25)
                      ),
                      child: Center(child: Text('Next',style: TextStyle(color: Colors.black),)),
                    ),
                  ),
                )


              ],
            ),
          ),
        ),
      ),
    );
  }

  void searchKey() {
    String name = nameController.text.toLowerCase().trim();
    list.clear();
    for(int i = 0 ; i<name.length ; i++){
      list.add(name.substring(0,i+1));
    }
    print(list);
    final box = GetStorage();
    box.write(Constant.searchKey, list);
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => PhoneNumber()));
  }
}
