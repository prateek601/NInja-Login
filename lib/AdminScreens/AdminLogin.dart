import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/AdminScreens/AdminView.dart';
import 'package:flutter_app/Utils/Constants.dart';

class AdminLogin extends StatefulWidget {
  @override
  _AdminLoginState createState() => _AdminLoginState();
}

class _AdminLoginState extends State<AdminLogin> {
  var emailController = TextEditingController();

  String emailText = '';

  var hide = true;

  var passwordController = TextEditingController();

  String passwordText = '';

  String buttonText = 'Log In';


  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailController.dispose();
    passwordController.dispose();

  }


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
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
                              onPressed: (){
                                Navigator.of(context).pop();
                              },
                              splashRadius: 25,
                              padding: EdgeInsets.zero,
                              alignment: Alignment.centerLeft,
                            ),
                          )),
                      Expanded(
                          flex: 8,
                          child: Container(
                            child: Center(child: Text('Log In as Admin',style: TextStyle(color: Colors.white,fontSize: 20),)),
                          )),
                      Expanded(
                          flex: 1,
                          child: Container()),

                    ],
                  ),
                  SizedBox(height: 30,),
                  Text('Email',style: TextStyle(color: Colors.white,fontSize: 30),),
                  SizedBox(height: 10,),
                  TextField(
                    controller: emailController,
                    cursorColor: Colors.black,
                    style: TextStyle(fontSize: 20),
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: InputBorder.none,
                        suffixIcon:Icon(Icons.email,color: Constant.primaryColor,)
                    ),
                    onChanged: (val) {
                    },
                  ),
                  SizedBox(height: 7,),
                  Text(emailText,style: TextStyle(color: Colors.white,fontSize: 12),),
                  SizedBox(height: 30,),
                  Text('Password',style: TextStyle(color: Colors.white,fontSize: 30),),
                  SizedBox(height: 10,),
                  TextField(
                    obscureText: hide,
                    controller: passwordController,
                    cursorColor: Colors.black,
                    style: TextStyle(fontSize: 20),
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: InputBorder.none,
                        suffixIcon: InkWell(onTap:(){
                          setState(() {
                            hide = !hide;
                          });
                        },child: Icon(hide?Icons.remove_red_eye:CupertinoIcons.eye_slash_fill,color: Constant.primaryColor,))
                    ),
                    onChanged: (val) {
                    },
                  ),
                  SizedBox(height: 7,),
                  Text(passwordText,style: TextStyle(color: Colors.white,fontSize: 12),),
                  SizedBox(height: 100,),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 100),
                    child: InkWell(
                      onTap: () {
                        bool emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(emailController.text.trim());
                        if(emailValid){

                          verify();
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
      ),
    );
  }

  void verify() {
    FirebaseFirestore.instance.collection('admin').where(Constant.email , isEqualTo: emailController.text.trim()).get().then((value)  {
      if(value!=null){
        if(value.docs.isNotEmpty){
          print('email registered as admin email');
          logIn();
        }else{
          print('email not registered as admin email');
          setState(() {
            emailText = 'something went wrong';
            passwordText = '';
            buttonText = 'Log In';
          });
        }
      }else{
        print('email not registered as admin email');
        setState(() {
          emailText = 'something went wrong';
          passwordText = '';
        });
        emailText = 'something went wrong';
        passwordText = '';
      }
    });
  }

  logIn () async {
    try{
      await FirebaseAuth.instance.signInWithEmailAndPassword
        (email: emailController.text.trim(), password: passwordController.text.trim());
      print('signed in using email and password');
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>AdminView()), (route) => false);
    }
    catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
        setState(() {
          emailText = 'No user found for that email.';
          passwordText ='';
        });
      }
      else{
        if (e.code == 'wrong-password') {
          print('Wrong password provided for that user.');
          setState(() {
            emailText = '';
            passwordText = 'Wrong password';
          });
        }else{
          if(e.message == 'Given String is empty or null'){
            print('password field is kept empty');
            setState(() {
              emailText = '';
              passwordText = 'Please enter password';
            });
          }else{
            if(e.code == 'invalid-email'){
              print('please enter a valid email');
              setState(() {
                emailText = 'Please enter a valid email';
                passwordText = '';
              });
            }else{
              print(e.code);
              print(e.message);
            }
          }
        }

      }
    }
  }

}


