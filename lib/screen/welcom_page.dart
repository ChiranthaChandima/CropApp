import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crop_doc/screen/login.dart';
import 'package:crop_doc/screen/sign_up.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../theme/app_theme.dart';
import '../validation/form_validation.dart';
import '../widgets/app_elevated_button.dart';
import '../widgets/app_text_field.dart';
import 'forgot_password_screen.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool check = false;

  void validate() {
    setState(() {
      check = true;
    });
    if (formKey.currentState!.validate()) {
      signIn(email.text.trim(), password.text.trim());
    } else {
      EasyLoading.showInfo("Login Failed!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: const Color(0xffffffff),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Center(
              child: Form(
                autovalidateMode: check
                    ? AutovalidateMode.onUserInteraction
                    : AutovalidateMode.disabled,
                key: formKey,
                child: Column(
                  children: [
                    Image.asset('assets/images/crop_doc_logo.png', width: 200),
                    //email textfield
                    Container(
                      margin: EdgeInsets.only(top: 100),
                      child: Text("Welcome",
                          style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 34,
                              color: Color(0xff252525))),
                    ),

                    //Sign In button
                    AppElevatedButton(
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                                return const Login();
                              }));
                        },
                        title: "Sign In",
                        top: 20,
                        left: 36.0,
                        right: 36.0,
                        primary: AppTheme.colors.green,
                        onPrimary: AppTheme.colors.white,
                        bottom: 30.0),

                    //Sign In button
                    AppElevatedButton(
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return const SignUp();
                          }));
                        },
                        title: "Sign Up",
                        left: 36.0,
                        right: 36.0,
                        borderColor: AppTheme.colors.green,
                        primary: AppTheme.colors.white,
                        onPrimary: AppTheme.colors.green,
                        bottom: 30.0),

                    const SizedBox(height: 30.0),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  appleLogin() {}

  googleLogin() {}

  @override
  void initState() {
    super.initState();
  }

  Future signIn(String email, String password) async {
    EasyLoading.show(status: "Loading...");
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        EasyLoading.showError("User Not Found!");
      } else if (e.code == 'wrong-password') {
        EasyLoading.showError("Wrong Password!");
      }
    }
    EasyLoading.dismiss();
  }
}
