import 'package:flutter/material.dart';
import 'Name.dart';
import 'package:get_storage/get_storage.dart';

import '../Utils/Constants.dart';

class Password extends StatefulWidget {
  @override
  _PasswordState createState() => _PasswordState();
}

class _PasswordState extends State<Password> {
  var passwordController = TextEditingController();

  bool buttonActive = false;

  String passwordText = 'Password must be minimum 8 characters long.';

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
                Text('Set Password',style: TextStyle(color: Colors.white,fontSize: 30),),
                SizedBox(height: 10,),
                TextField(
                  controller: passwordController,
                  cursorColor: Colors.black,
                  style: TextStyle(fontSize: 20),
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: InputBorder.none
                  ),
                  onChanged: (val) {
                    if(val.length==8){
                      setState(() {
                        buttonActive = true;
                      });
                    }
                    if(val.length == 7){
                      setState(() {
                        buttonActive = false;
                      });
                    }
                  },
                ),
                SizedBox(height: 7,),
                Text(passwordText,style: TextStyle(color: Colors.white,fontSize: 12),),
                SizedBox(height: 100,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 100),
                  child: InkWell(
                    onTap: () {
                      if(passwordController.text.trim().length<8){
                        print('not correct');
                      }else{
                        print('correct');
                        final box = GetStorage();
                        box.write(Constant.password, passwordController.text.trim());
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) =>Name()));
                      }
                    },
                    borderRadius: BorderRadius.circular(25),
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                          color: buttonActive?Colors.white:Colors.grey[600],
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
}
