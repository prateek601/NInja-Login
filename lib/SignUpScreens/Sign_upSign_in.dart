import 'package:flutter/material.dart';
import 'package:flutter_app/LogInScreens/EmailLogIn.dart';
import 'package:flutter_app/LogInScreens/PhoneLogIn.dart';
import 'package:flutter_app/SignUpScreens/Email.dart';
import 'package:flutter_app/SignUpScreens/PhoneNumber.dart';

class SignUpSignIn extends StatefulWidget {
  @override
  _SignUpSignInState createState() => _SignUpSignInState();
}

class _SignUpSignInState extends State<SignUpSignIn> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.center,
            // mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  child: FlutterLogo(
                    size: 120,
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => Email()));
                        },
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                              color: Color(0xFF4682b4),
                              borderRadius: BorderRadius.circular(25)
                          ),
                          child: Center(child: Text('Sign Up',style: TextStyle(color: Colors.black),)),

                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context)=>PhoneLogIn()));
                        },
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                              border: Border.all(style: BorderStyle.solid,color: Colors.white,width: 0.5),
                              borderRadius: BorderRadius.circular(25)
                          ),
                          child: Center(child: Text('Log In with phone number',style: TextStyle(color: Colors.white),)),

                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 50),
                      child: InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => EmailLogIn()));
                          },
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(10,10,10,10),
                            child: Text('Log In',style: TextStyle(color: Colors.white),),
                          )),
                    )
                  ],
                ),
              )

            ],
          ),
        ),
      ),
    );
  }
}
