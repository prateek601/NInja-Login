import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'Password.dart';
import 'package:flutter_app/Utils/Constants.dart';
import 'package:get_storage/get_storage.dart';

class Email extends StatefulWidget {
  @override
  _EmailState createState() => _EmailState();
}

class _EmailState extends State<Email> {
  var emailController = TextEditingController();

  String emailText = 'You will need to confirm this email';

  String buttonText = 'Next';

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailController.dispose();
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
                Text('What\'s your Email?',style: TextStyle(color: Colors.white,fontSize: 30),),
                SizedBox(height: 10,),
                TextField(
                  controller: emailController,
                  cursorColor: Colors.black,
                  style: TextStyle(fontSize: 20),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: InputBorder.none
                  ),
                  onChanged: (val) {
                    if(val.isEmpty){
                      setState(() {
                        emailText = 'You will need to verify your email';
                      });
                    }
                  },
                ),
                SizedBox(height: 7,),
                Text(emailText,style: TextStyle(color: Colors.white,fontSize: 12),),
                SizedBox(height: 100,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 100),
                  child: InkWell(
                    onTap: () {
                      bool emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(emailController.text.trim());
                      if(emailValid){
                        checkEmailAvailable();
                       //
                        //validateEmail();
                      }
                      else{
                        setState(() {
                          emailText = 'Please enter a valid email';
                        });
                      }
                    },
                    borderRadius: BorderRadius.circular(25),
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25)
                      ),
                      child: Center(child: Text(buttonText,style: TextStyle(color: Colors.black),)),
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

  Future<void> validateEmail() async {
    //await FirebaseAuth.instance.createUserWithEmailAndPassword(email: emailController.text.trim(), password: '12345678');
    User user = FirebaseAuth.instance.currentUser;

    if (user != null && !user.emailVerified) {
      var actionCodeSettings = ActionCodeSettings(
        url: 'https://open.flutterapp6011.com/?email=${user.email}',
        dynamicLinkDomain: "https://flutterapp6011.page.link",
        //androidInstallApp: true,
        androidMinimumVersion: '16',
        androidPackageName: 'com.prateek.flutter_app',
        handleCodeInApp: true,
      );
      try{
        await user.sendEmailVerification(actionCodeSettings);
        print('email sent');
      }
      catch(e){
        print(e);
      }


      //initDynamicLinks();
    }else{
      print(user);
    }
  }

  void checkEmailAvailable() {
    FirebaseFirestore.instance.collection(Constant.users).where(Constant.email,isEqualTo: emailController.text.trim().toString()).get().then((value) async {
      if(value.docs!=null){
        if(value.docs.isNotEmpty){
          setState(() {
            emailText = 'Email already in use';
          });
          print('email already in use');
        }else{
          setState(() {
            emailText = '';
          });
          print('email available');
          final box= GetStorage();
          await box.write(Constant.email,emailController.text.trim().toString());
          Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Password()));
        }
      }else{
        setState(() {
          emailText = '';
        });
        print('email available');
        final box= GetStorage();
        await box.write(Constant.email,emailController.text.trim().toString());
        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Password()));
      }
    });
  }
}
