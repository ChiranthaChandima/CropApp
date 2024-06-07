import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crop_doc/screen/instructor_sign_up.dart';
import 'package:crop_doc/screen/my_plants_records.dart';
import 'package:crop_doc/screen/profile_page.dart';
import 'package:crop_doc/screen/uploaded_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/app_elevated_button_icon.dart';
import 'package:image_picker/image_picker.dart';

class HomePage extends StatefulWidget {
  final DocumentSnapshot<Object?>? currentUser;

  const HomePage({Key? key, this.currentUser}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  File? uploadImage;

  @override
  Widget build(BuildContext context) {
    final providerUser = Provider.of<UserProvider>(context);
    double width = MediaQuery.of(context).size.width;

    final user = FirebaseAuth.instance.currentUser!;
    print("user---->   $user");
    return Scaffold(
      backgroundColor: const Color(0xffffffff),
      appBar: AppBar(
        toolbarHeight: 90.0,
        leadingWidth: 100,
        leading: Container(
          // color: AppTheme.colors.white,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
            child: Image.asset(
              'assets/images/crop_doc_logo.png',
              width: 500,
              height: 500,
            ),
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(widget.currentUser!["username"],
                  style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 16,
                      color: AppTheme.colors.green)),
            ],
          ),
          SizedBox(width: 10.0),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: SizedBox(
              // width: 500,
              // height: 500,
              child: FittedBox(
                child: FloatingActionButton(
                  backgroundColor: AppTheme.colors.white,
                  foregroundColor: AppTheme.colors.white,
                  onPressed: () {
                    // ScaffoldMessenger.of(context).showSnackBar(
                    //   const SnackBar(content: Text('User Profile!')),
                    // );
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                          return ProfilePage(currentUser: widget.currentUser);
                        }));
                  },
                  child: CircleAvatar(
                    radius: 100,
                    backgroundImage: AssetImage('assets/images/profile.png'),
                    backgroundColor: AppTheme.colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 25.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  children: [
                    SizedBox(height: 20.0),
                    Column(
                      // crossAxisAlignment: CrossAxisAlignment.center,
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            AppElevatedButtonIcon(
                              onPressed: () {
                                pickImage(ImageSource.camera).then((value) => {
                                      if (value != null)
                                        {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    UploadedImage(
                                                        uploadImage:
                                                            uploadImage)),
                                          )
                                        }
                                    });
                              },
                              title: "${"Camera"}",
                              fontSize: 18.0,
                              icon:
                                  const FaIcon(FontAwesomeIcons.camera, size: 20),
                              primary: AppTheme.colors.green,
                              onPrimary: AppTheme.colors.white,
                              width: (width - 30) / 2 - 15,
                              borderRadius: 10,
                            ),
                            AppElevatedButtonIcon(
                              onPressed: () {
                                pickImage(ImageSource.gallery).then((value) => {
                                      if (value != null)
                                        {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    UploadedImage(
                                                        uploadImage:
                                                            uploadImage)),
                                          )
                                        }
                                    });
                              },
                              title: "${"Gallery"}",
                              fontSize: 18.0,
                              icon: const FaIcon(FontAwesomeIcons.photoFilm,
                                  size: 20),
                              primary: AppTheme.colors.green,
                              onPrimary: AppTheme.colors.white,
                              width: (width - 30) / 2 - 15,
                              borderRadius: 10,
                            ),
                          ],
                        ),
                        SizedBox(height: 30.0),
                        AppElevatedButtonIcon(
                          onPressed: () {
                            providerUser.currentUser = widget.currentUser;
                            print("User : ${widget.currentUser}");
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => MyPlantsRecords(currentUser: widget.currentUser)),
                            );
                          },
                          title: "My Plants Records",
                          fontSize: 18,
                          icon: const FaIcon(FontAwesomeIcons.recordVinyl,
                              size: 20),
                          primary: AppTheme.colors.green03,
                          onPrimary: AppTheme.colors.white,
                          borderRadius: 10,
                        ),
                        SizedBox(height: 30.0),

                        if(!widget.currentUser!["isInstructor"])
                          AppElevatedButtonIcon(
                            onPressed: () {
                              providerUser.currentUser = widget.currentUser;
                              print("User : ${widget.currentUser}");
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => InstructorSignUp(currentUser: widget.currentUser)),
                              );
                            },
                            title: "Login As a Agri-Instructor",
                            fontSize: 18,
                            icon: const FaIcon(FontAwesomeIcons.userGroup,
                                size: 20),
                            primary: AppTheme.colors.green,
                            onPrimary: AppTheme.colors.white,
                            borderRadius: 10,
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;

      final imageTemporary = File(image.path);
      setState(() {
        uploadImage = imageTemporary;
      });

      return imageTemporary;
    } on PlatformException catch (e) {
      print("Failed ro pick image => $e");
    }
  }
}
