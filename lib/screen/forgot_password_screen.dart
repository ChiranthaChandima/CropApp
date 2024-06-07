import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../theme/app_theme.dart';
import '../validation/form_validation.dart';
import '../widgets/app_elevated_button.dart';
import '../widgets/app_text_field.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  TextEditingController email = TextEditingController();

  @override
  void dispose(){
    email.dispose();
    super.dispose();
  }

  Future<void> validate() async {
    EasyLoading.show(status: "Loading...");
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: email.text.trim());

      showDialog(context: context, builder: (context){
        return AlertDialog(
          backgroundColor: Color(0xffffffff),
          content: Text("Password reset link sent! Check your email",
              style: TextStyle(
                  fontFamily: 'Roboto-Medium',
                  fontSize: 16,
                  color: Color(0xff000000))),
          actions: <Widget>[
            TextButton(
              onPressed: (){
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: const Text('Got it'),
            ),
          ],
        );
      });

    } on FirebaseException catch (e) {
      showDialog(context: context, builder: (context){
        return AlertDialog(
          backgroundColor: Color(0xffffffff),
          content: Text(e.message.toString(),
              style: TextStyle(
                  fontFamily: 'Roboto-Medium',
                  fontSize: 16,
                  color: Color(0xff000000))),
          actions: <Widget>[
            TextButton(
              onPressed: (){
                Navigator.of(context).pop();
                },
              child: const Text('Try again'),
            ),
          ],

        );
      });
    }
    EasyLoading.dismiss();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffffffff),
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: AppTheme.colors.grey,
        ),
        toolbarHeight: 75.0,
        title: const Text("Forgot Password",
            style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 34,
                color: Color(0xff000000))),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
           Padding(
             padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 8.0),
             child: Text(
                "Enter your Email and we will send you a password reset link",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: 'Roboto-Medium',
                    fontSize: 16,
                    color: Color(0xff000000))),
           ),
          AppTextField(
              hitText: "Email",
              fieldValue: email,
              bottom: 30.0,
              left: 36.0,
              right: 36.0,
              validator: FormValidation.emailValidator
          ),

          //login button
          AppElevatedButton(
              onPressed: () => validate(),
              title: "Reset Password",
              left: 36.0,
              right: 36.0,
              primary: AppTheme.colors.green,
              onPrimary: AppTheme.colors.black,
              bottom: 30.0),
        ],
      ),
    );
  }
}
