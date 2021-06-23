import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/Home.dart';
import 'package:flutter_app/SignUpScreens/OTP.dart';
import 'package:flutter_app/Utils/Constants.dart';
import 'package:get_storage/get_storage.dart';

class PhoneNumber extends StatefulWidget {
  @override
  _PhoneNumberState createState() => _PhoneNumberState();
}

class _PhoneNumberState extends State<PhoneNumber> {
  var phoneController = TextEditingController();

  String phoneText = 'Enter phone number in this format\n[+] [your country code] [your phone number]';

  bool loading = false;

  bool dullColor = true;

  String id;

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
      child:Stack(
        children: [
          Scaffold(
            body:SingleChildScrollView(
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
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 30,),
                          Text('What\'s your Phone number?',style: TextStyle(color: Colors.white,fontSize: 30),),
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
                          Text(phoneText,style: TextStyle(color: Colors.white,fontSize: 12),),
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
                                    color: dullColor?Colors.grey[700]:Colors.white,
                                    borderRadius: BorderRadius.circular(25)
                                ),
                                child: Center(child: loading?
                                CircularProgressIndicator(backgroundColor: Colors.green[800],color: Colors.green[300],):
                                Text('Next',style: TextStyle(color: Colors.black),)),
                              ),
                            ),
                          ),
                          // SizedBox(height: 50,),
                          // Text('A code will be sent to your phone number.',style: TextStyle(color: Colors.white,fontSize: 12),)
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          loading?Scaffold(
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

  Future<void> function() async {
    final box = GetStorage();
    await box.write(Constant.phoneNumber, phoneController.text.trim());
    FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneController.text.trim(),
      verificationCompleted: (PhoneAuthCredential credential) async {

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
        }).then((value)  {Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
            Home()), (route) => false);
            print('user signed up');
        });
      },
        verificationFailed: (FirebaseAuthException e) {
      setState(() {
        loading = false;
        phoneText = 'The provided phone number is not valid.';
      });
      print(e.message);
    },
      codeSent: (String verificationId, int resendToken) async {
        id = verificationId;
        token = resendToken;
        print('code sent');

      },
      timeout: const Duration(seconds: 3),
      codeAutoRetrievalTimeout: (String verificationId) {
        setState(() {
          loading = false;
        });
        print('time out');
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => OTP(id , token)));
        // Auto-resolution timed out...
      },
    );
  }

  void checkPhoneNumberAvailability() {
      FirebaseFirestore.instance.collection(Constant.users).where(Constant.phoneNumber , isEqualTo: phoneController.text.trim().toString()).get().
    then((value) {
      print(value.docs);
      if(value.docs != null){
        if(value.docs.isNotEmpty){
          print('Phone number already registered.Please provide another phone number');
          setState(() {
            loading = false;
            phoneText = 'Phone number already registered.Please provide another phone number';
          });
        }else{
          print('Phone number available for registration');
          function();
        }
      }else{
        print('Phone number available for registration');
        function();
      }
      });
  }
}
