import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Home.dart';
import 'package:flutter_app/LogInScreens/OtpLogin.dart';
import 'package:flutter_app/Utils/Constants.dart';
import 'package:get_storage/get_storage.dart';

class PhoneLogIn extends StatefulWidget {
  @override
  _PhoneLogInState createState() => _PhoneLogInState();
}

class _PhoneLogInState extends State<PhoneLogIn> {
  var phoneController = TextEditingController();

  String phoneText = 'Enter phone number in this format\n[+] [your country code] [your phone number]';

  bool codeSent = false;

  var otpController = TextEditingController();

  bool loading = false;

  bool dullColor = true;

  int token;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    phoneController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: 
            Stack(
              children: [
                Scaffold(
                  body: SingleChildScrollView(
                    child: SafeArea(
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
                            Text('Phone number',style: TextStyle(color: Colors.white,fontSize: 30),),
                            SizedBox(height: 10,),
                            TextField(
                              keyboardType: TextInputType.phone,
                              controller: phoneController,
                              cursorColor: Colors.black,
                              style: TextStyle(fontSize: 20),
                              decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: InputBorder.none
                              ),
                                onChanged: (value){
                                  bool isValid = RegExp(r'^\+[1-9]\d{1,14}$').hasMatch(value);
                                  // ^\\+[1-9]\\d{1,14}$
                                  if(isValid){
                                    setState(() {
                                      dullColor = false;
                                      phoneText = 'Enter phone number in this format\n[+] [your Country code] [your phone number]';
                                    });
                                  }else{
                                    setState(() {
                                      dullColor = true;
                                      phoneText = 'Enter phone number in this format\n[+] [your Country code] [your phone number]';

                                    });
                                  }
                                }
                            ),
                            SizedBox(height: 7,),
                            Container(
                              height: 35,
                             // color: Colors.blue,
                                child: Text(phoneText,style: TextStyle(color: Colors.white,fontSize: 12),)),
                            SizedBox(height: 100,),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 100),
                              child: InkWell(
                                onTap: (){
                                  if(dullColor) {
                                    setState(() {
                                      phoneText =
                                      'The provided phone number is not valid';
                                    });
                                  }else{
                                    setState(() {
                                      loading = true;
                                    });
                                    checkPhoneNumberAvailability();
                                  }
                                },
                                borderRadius: BorderRadius.circular(25),
                                child: Container(
                                  height: 50,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(25)
                                  ),
                                  child: Center(child: loading?
                                  CircularProgressIndicator(backgroundColor: Colors.green[800],color: Colors.green[300],):
                                  Text('Send OTP',style: TextStyle(color: Colors.black),)),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                loading?
                Scaffold(
                  backgroundColor: Colors.transparent,
                  body: Center(
                    //child: CircularProgressIndicator(backgroundColor: Colors.green[800],color: Colors.green[300],),
                  ),
                )
                    :
                    Container()
              ],
            )

    );
  }

  void function() {
    FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneController.text.trim(),
      verificationCompleted: (PhoneAuthCredential credential) async {
        await FirebaseAuth.instance.signInWithCredential(credential);
          print('logged in using phone no , otp auto detected');
          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context )=>Home()), (route) => false);
        print('otp auto detected');

      },
      verificationFailed: (FirebaseAuthException e) {
          print(e);
          setState(() {
            loading =false;
            phoneText = 'Something went wrong.Try again later.';
          });
        },
      codeSent: (String verificationId, int resendToken) async {
        token = resendToken;
        print('otp sent');

      },
      timeout: Duration(seconds: 3),
      codeAutoRetrievalTimeout: (String verificationId) {
        print('timeout');
        setState(() {
          loading = false;
        });
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => OtpLogin(verificationId , token)));
      },
    );
  }

  void checkPhoneNumberAvailability() {
    FirebaseFirestore.instance.collection(Constant.users).where(Constant.phoneNumber , isEqualTo: phoneController.text.trim()).get().
    then((value) {
      if(value.docs != null){
        if(value.docs.isNotEmpty){
          print('Phone number registered.');
          function();
        }else{
          print('Either phone number is not registered or phone number is invalid');
          setState(() {
            loading = false;
            phoneText = 'Either phone number is not registered or phone number is invalid';
          });
        }
      }else{
        print('Either phone number is not registered or phone number is invalid');
        setState(() {
          loading = false;
          phoneText = 'Either phone number is not registered or phone number is invalid';
        });
      }
    });
  }

}