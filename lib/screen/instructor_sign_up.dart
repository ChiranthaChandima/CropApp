import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../firebase/location_collection.dart';
import '../models/location_model.dart';
import '../theme/app_theme.dart';
import '../validation/form_validation.dart';
import '../widgets/app_dropdown.dart';
import '../widgets/app_elevated_button.dart';
import '../widgets/app_text_field.dart';

class InstructorSignUp extends StatefulWidget {
  final DocumentSnapshot<Object?>? currentUser;
  const InstructorSignUp({Key? key, this.currentUser}) : super(key: key);

  @override
  State<InstructorSignUp> createState() => _InstructorSignUpState();
}

class _InstructorSignUpState extends State<InstructorSignUp> {
  final CollectionReference _instructor =
  FirebaseFirestore.instance.collection('instructor');
  final CollectionReference _user =
  FirebaseFirestore.instance.collection('user');
  final districtState = GlobalKey<FormFieldState>();
  final divisionState = GlobalKey<FormFieldState>();
  String dropdownvalue = "";

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController mobileNumber = TextEditingController();
  TextEditingController location = TextEditingController();
  TextEditingController nic = TextEditingController();
  TextEditingController workingId = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool check = false;

  void validate() {
    setState(() {
      check = true;
    });
    if (formKey.currentState!.validate()) {
      signUp(name.text.trim(), email.text.trim(), nic.text.trim(), workingId.text.trim(), mobileNumber.text.trim(), districtState.currentState?.value);

    } else {
      EasyLoading.showInfo("Sing Up Failed!");
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
              child: StreamBuilder(
                  stream: LocationCollection.readAllLocations(),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<LocationModel>> snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    List<LocationModel>? locations = snapshot.data;
                    List<String> districtArray = [];
                    List<String> divisionArray = [];

                    for (LocationModel location in locations!) {
                      String? district = location.district;
                      String? division = location.division;
                      if (division != null &&
                          district != null &&
                          !districtArray.contains("$district - $division")) {
                        districtArray.add("$district - $division");
                      }
                    }
                    dropdownvalue = districtArray[0];
                    return Form(
                      autovalidateMode: check
                          ? AutovalidateMode.onUserInteraction
                          : AutovalidateMode.disabled,
                      key: formKey,
                      child: Column(
                        children: [
                          Image.asset('assets/images/flower_pot.png',
                              width: 200),
                          //email textfield

                          //name textfield
                          AppTextField(
                              hitText: "Full Name",
                              fieldValue: name,
                              top: 30.0,
                              bottom: 30.0,
                              left: 36.0,
                              right: 36.0,
                              validator: FormValidation.requiredValidator),

                          AppTextField(
                              keyboardType: TextInputType.emailAddress,
                              hitText: "Email",
                              fieldValue: email,
                              bottom: 30.0,
                              left: 36.0,
                              right: 36.0,
                              validator: FormValidation.emailValidator),

                          //nic textfield
                          AppTextField(
                              hitText: "NIC",
                              fieldValue: nic,
                              bottom: 30.0,
                              left: 36.0,
                              right: 36.0,
                              validator: FormValidation.requiredValidator),

                          //work id textfield
                          AppTextField(
                              hitText: "Working ID",
                              fieldValue: workingId,
                              bottom: 30.0,
                              left: 36.0,
                              right: 36.0,
                              validator: FormValidation.requiredValidator),

                          AppDropdown(
                            dropdownState: districtState,
                            dropdownvalue: dropdownvalue,
                            items: districtArray,
                            bottom: 30.0,
                            left: 36.0,
                            right: 36.0,
                            labelText: "District - Division",
                          ),

                          //mobile textfield
                          AppTextField(
                              hitText: "Professional Mobile",
                              fieldValue: mobileNumber,
                              keyboardType: TextInputType.phone,
                              bottom: 30.0,
                              left: 36.0,
                              right: 36.0,
                              validator: FormValidation.requiredValidator),




                          //login button
                          AppElevatedButton(
                              onPressed: () => validate(),
                              title: "Submit",
                              left: 36.0,
                              right: 36.0,
                              primary: AppTheme.colors.green,
                              onPrimary: AppTheme.colors.white,
                              bottom: 30.0),
                        ],
                      ),
                    );
                  }),
            ),
          ),
        ),
      ),
    );
  }


  @override
  void initState() {
    super.initState();
  }

  Future signUp(String name, String email, String nic, String workingId, String mobileNumber, String districtDivision) async {
    print("districtDivision : ${widget.currentUser?.id}");
    List<String> location = districtDivision.split(" - ");
    EasyLoading.show(status: "Loading...");
    try {

      await _user
          .doc(widget.currentUser?.id)
          .update({
        "isInstructor": true,
      });

      await _instructor
          .doc(widget.currentUser?.id)
          .set({
        "fullName": name,
        "email": email,
        "mobileNo": mobileNumber,
        "district": location[0],
        "division": location[1],
        "nic": nic,
        "adminApproval": false,
        "workingId": workingId,

      })
          .then((value) => EasyLoading.showSuccess(
          "Registration Successfully!").then((value) => Navigator.pop(context))

      )
          .catchError((error) =>
          EasyLoading.showError(
              "Registration Failed!")
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        EasyLoading.showError("Registration Failed!");
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        EasyLoading.showError("Email Already Registered!");
        print(
            'The account already exists for that email.');
      }
    }
    EasyLoading.dismiss();
  }
}
