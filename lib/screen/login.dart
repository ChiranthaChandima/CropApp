import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
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

class Login extends StatefulWidget {
  static const String routeName = '/login';

  static Route route() {
    return MaterialPageRoute(
      settings: RouteSettings(name: routeName),
      builder: (_) => Login(),
    );
  }

  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}


class _LoginState extends State<Login> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool check = false;
  Timer? _timer;

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
                    Image.asset('assets/images/flower_pot.png', width: 200),
                    //email textfield
                    Container(
                      margin: EdgeInsets.only(top: 75),
                      child: Text("Sign In Now",
                          style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 34,
                              color: Color(0xff252525))),
                    ),
                    AppTextField(
                        keyboardType: TextInputType.emailAddress,
                        hitText: "Email",
                        fieldValue: email,
                        top: 30.0,
                        bottom: 30.0,
                        left: 36.0,
                        right: 36.0,
                        validator: FormValidation.emailValidator),

                    //password textfield
                    AppTextField(
                        hitText: "Password",
                        fieldValue: password,
                        bottom: 30.0,
                        left: 36.0,
                        right: 36.0,
                        obscureText: true,
                        validator: FormValidation.passwordValidator),

                    //login button
                    AppElevatedButton(
                        onPressed: () => validate(),
                        title: "Sign In",
                        left: 36.0,
                        right: 36.0,
                        primary: AppTheme.colors.green,
                        onPrimary: AppTheme.colors.white,
                        bottom: 30.0),

                    //forget password
                    GestureDetector(
                      onTap: (){
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                              return const ForgotPasswordScreen();
                            }));
                      },
                      child: Text("Forgot your password?",
                          style: TextStyle(
                              fontFamily: 'Roboto-Medium',
                              fontSize: 16,
                              color: AppTheme.colors.grey)),
                    ),

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
      final User currentUser = FirebaseAuth.instance.currentUser!;
      final DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('user')
          .doc(currentUser.uid)
          .get();
      Navigator.pop(context);
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
