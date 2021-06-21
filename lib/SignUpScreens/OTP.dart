import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Utils/Constants.dart';
import 'package:get_storage/get_storage.dart';
import '../Home.dart';

class OTP extends StatefulWidget {
  String verificationId;
  int resendToken;

  OTP(this.verificationId, this.resendToken);

  @override
  _OTPState createState() => _OTPState();
}

class _OTPState extends State<OTP> {
  TextEditingController otpController = TextEditingController();

  String otpText = '';

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
                                            child: IconButton(
                                              icon: Icon(
                                                Icons.arrow_back,
                                                color: Colors.white,
                                              ),
                                              onPressed: () {},
                                              splashRadius: 25,
                                              padding: EdgeInsets.zero,
                                              alignment: Alignment.centerLeft,
                                            ),
                                          )),
                                      Expanded(
                                          flex: 8,
                                          child: Container(
                                            child: Center(
                                                child: Text(
                                              'Create Account',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20),
                                            )),
                                          )),
                                      Expanded(flex: 1, child: Container()),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 30,
                                  ),
                                  Text(
                                    'Enter Code',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 30),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  TextField(
                                    controller: otpController,
                                    cursorColor: Colors.black,
                                    style: TextStyle(fontSize: 20),
                                    decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Colors.white,
                                        border: InputBorder.none),
                                  ),
                                  SizedBox(
                                    height: 7,
                                  ),
                                  Text(
                                    otpText,
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 12),
                                  ),
                                  SizedBox(
                                    height: 100,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 70),
                                    child: InkWell(
                                      onTap: () {
                                        onSubmitPressed();
                                      },
                                      borderRadius: BorderRadius.circular(25),
                                      child: Container(
                                        height: 50,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(25)),
                                        child: Center(
                                            child: Text(
                                          'Create Account',
                                          style: TextStyle(color: Colors.black),
                                        )),
                                      ),
                                    ),
                                  )
                                ]))))));
  }

  Future<void> onSubmitPressed() async {
    // setState(() {
    //   loading = true;
    // });
    final box = GetStorage();
    String smsCode = otpController.text.trim();

    try{
      PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: widget.verificationId, smsCode: smsCode);

      UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

      AuthCredential authCredential = EmailAuthProvider.credential(email:box.read(Constant.email) , password:box.read(Constant.password));

      await userCredential.user.linkWithCredential(authCredential);

      User user = FirebaseAuth.instance.currentUser;


      FirebaseFirestore.instance.doc(Constant.users+'/'+user.uid).set({
        Constant.email:box.read(Constant.email),
        Constant.password:box.read(Constant.password),
        Constant.name:box.read(Constant.name),
        Constant.phoneNumber:box.read(Constant.phoneNumber),
        Constant.searchKey:box.read(Constant.searchKey)
      }).then((value)  {

        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
            Home()), (route) => false);
        print('signed up');
      });

    }

    catch(e){
      print(e);
      setState(() {
        otpText = 'The OTP you entered is not correct';
      });
    }


  }

}
