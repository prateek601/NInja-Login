import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Home.dart';

class OtpLogin extends StatefulWidget {
  String verificationId;
  int resendToken;

  OtpLogin(this.verificationId, this.resendToken);

  @override
  _OtpLoginState createState() => _OtpLoginState();
}

class _OtpLoginState extends State<OtpLogin> {
  var otpController = TextEditingController();

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
                                              'Log In',
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
                                'Enter OTP',
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
                                    horizontal: 100),
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
                                          'Log In',
                                          style: TextStyle(color: Colors.black),
                                        )),
                                  ),
                                ),
                              ),
                              SizedBox(height: 20),
                              InkWell(
                                onTap: () {
                                  //resendOtp();
                                },
                                child: Container(
                                  height: 40,
                                  width: 100,
                                  child: Center(child: Text('Resend OTP',style: TextStyle(color: Colors.white),)),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(color: Colors.white,style: BorderStyle.solid,width: 0.5)
                                  ),
                                ),
                              )
                            ]))))));
  }

  Future<void> onSubmitPressed() async {
    // setState(() {
    //   loading = true;
    // });
    String smsCode = otpController.text.trim();

    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: widget.verificationId, smsCode: smsCode);

      await FirebaseAuth.instance.signInWithCredential(credential);

      print('logged in using phone number and otp');
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context )=>Home()), (route) => false);
    }
    catch(e){
      print(e);
      setState(() {
        otpText = 'The OTP you entered is not correct';
      });
    }
  }


}
