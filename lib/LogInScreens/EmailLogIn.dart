import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/AdminScreens/AdminLogin.dart';
import 'package:flutter_app/Home.dart';
import 'package:flutter_app/Utils/Constants.dart';

class EmailLogIn extends StatefulWidget {
  @override
  _EmailLogInState createState() => _EmailLogInState();
}

class _EmailLogInState extends State<EmailLogIn> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  String emailText = '';

  String buttonText = 'Log In';

  bool hide = true;

  String passwordText = '';

  String email = '';

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
                            child: Center(child: Text('Log In',style: TextStyle(color: Colors.white,fontSize: 20),)),
                          )),
                      Expanded(
                          flex: 1,
                          child: Container()),

                    ],
                  ),
                  SizedBox(height: 30,),
                  Text('Email/Phone Number',style: TextStyle(color: Colors.white,fontSize: 30),),
                  SizedBox(height: 10,),
                  TextField(
                    controller: emailController,
                    cursorColor: Colors.black,
                    style: TextStyle(fontSize: 20),
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: InputBorder.none,
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
                      },child: Icon(hide?Icons.visibility:Icons.visibility_off,color: Constant.primaryColor,))
                    ),
                    onChanged: (val) {
                    },
                  ),
                  SizedBox(height: 7,),
                  Text(passwordText,style: TextStyle(color: Colors.white,fontSize: 12),),
                  SizedBox(height: 70,),
                  Align(
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        InkWell(
                          onTap: () {
                            bool emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(emailController.text.trim());
                            bool phoneValid = RegExp(r'^\+[1-9]\d{1,14}$').hasMatch(emailController.text.trim());

                            if(emailValid){
                              email = emailController.text.trim();
                              logIn();
                              //
                              //validateEmail();
                            }
                            else{
                                  if(phoneValid){
                                  findEmail();

                              // if(!emailValid){
                              // setState(() {
                              //   emailText = 'Please enter a valid email';
                              // });
                              }else{
                                  setState(() {
                                    emailText = 'Enter phone number in this format\n[+] [your Country code] [your phone number]\nor Enter a valid email';
                                    passwordText ='';
                                  });
                                  print('phone number format not correct');

                              }
                            }
                          },
                          borderRadius: BorderRadius.circular(25),
                          child: Container(
                            height: 50,
                            width: 120,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(25)
                            ),
                            child: Center(child: Text(buttonText,style: TextStyle(color: Colors.black),)),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 100,right: 40,left: 40),
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(builder: (context)=>AdminLogin()));
                            },
                            child: Container(
                                height: 30,
                                alignment: Alignment.center,
                                child: Text('Log In as Admin',style: TextStyle(color: Colors.white,fontSize: 18),)),
                          ),
                        )
                      ],
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

  logIn () async {
    try{
        await FirebaseAuth.instance.signInWithEmailAndPassword
        (email: email, password: passwordController.text.trim());
          print('signed in using email and password');
          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>Home()), (route) => false);
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

  void findEmail() {
    FirebaseFirestore.instance.collection(Constant.users).
    where(Constant.phoneNumber ,isEqualTo: emailController.text.trim()).get().then((value) {
      if(value!=null){
        if(value.docs.isNotEmpty){
          print('phone number registered');
          print(value.docs[0][Constant.email]);
          email = value.docs[0][Constant.email];
          logIn();
        }else{
          print('No user found for that phone number.');
          setState(() {
            emailText = 'No user found for that phone number.';
            passwordText = '';
          });
        }
      }else{
        print('No user found for that phone number.');
        setState(() {
          emailText = 'No user found for that phone number.';
          passwordText = '';
        });
      }
    });
  }
}
