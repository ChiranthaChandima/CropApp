import 'dart:io';
import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:path/path.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crop_doc/screen/loading_screen.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../widgets/app_elevated_button.dart';

class CausePage extends StatefulWidget {
  final String? treatment;
  final File? file;

  const CausePage({Key? key, required this.treatment, this.file})
      : super(key: key);

  @override
  State<CausePage> createState() => _CausePageState();
}

class _CausePageState extends State<CausePage> {
  final FirebaseStorage storage = FirebaseStorage.instance;
  final CollectionReference _records =
  FirebaseFirestore.instance.collection('record');

  @override
  Widget build(BuildContext context) {
    Map<dynamic, dynamic> treatmentData = {};

    final Stream<QuerySnapshot> _treatmentStream = FirebaseFirestore.instance
        .collection('treatment')
        .where("dname", isEqualTo: widget.treatment)
        .snapshots();

    return Scaffold(
      appBar: AppBar(
        title: Text("Treatment"),
        backgroundColor: AppTheme.colors.green,
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: _treatmentStream,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Treatment Not Found!');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return LoadingScreen();
            }
            if (snapshot.hasData) {
              snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data =
                document.data()! as Map<String, dynamic>;
                treatmentData = data;
              }).toList();
            }
            print("Map<String, dynamic> treatmentData : ${treatmentData}");
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Center(
                    child: Text(
                      "${widget.treatment}",
                      style: TextStyle(
                        fontSize: 30,
                        color: AppTheme.colors.green, // Dark blue
                        fontFamily: 'Raleway ', // Use a different font
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      "Reason : ${treatmentData['cause']}",
                      style: TextStyle(
                        fontSize: 20,
                        color: AppTheme.colors.black, // Dark blue
                        fontFamily: 'Raleway ', // Use a different font
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      "${treatmentData['tname']}",
                      style: TextStyle(
                        fontSize: 20,
                        color: AppTheme.colors.black, // Dark blue
                        fontFamily: 'Raleway ', // Use a different font
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Text(
                        "${treatmentData['tsteps']}",
                        style: TextStyle(
                          fontSize: 16,
                          color: AppTheme.colors.black, // Dark blue
                          fontFamily: 'Raleway ', // Use a different font
                        ),
                      ),
                    ),
                  ),
                  AppElevatedButton(
                      onPressed: () async {
                      EasyLoading.show (status: "Loading...");
                      String url = await uploadFile(widget.file!.path);
                      final user = FirebaseAuth.instance.currentUser!;

                      await _records
                          .add ({
                      "url": url,
                        "userId":user.uid,
                      "disease": widget.treatment,
                        "cause":treatmentData['cause'],
                        "steps":treatmentData['tsteps'],
                        "timeStamp": DateTime.timestamp()

                      })
                          .then((value) => EasyLoading.showSuccess(
                      "Record Saved!").then((value) =>
                      {
                                          Navigator.pop(context),
                                          Navigator.pop(context),

                                        })

                      )
                          .catchError((error) =>
                      EasyLoading.showError(
                      "Record Saving Failed!")
                      );
                  },
                      title: "Save",
                      primary: AppTheme.colors.green,
                      bottom: 10,
                      top: 20,
                      onPrimary: AppTheme.colors.white),
                  AppElevatedButton(
                      onPressed: () =>
                      {
                        Navigator.of(context).pop(),
                        Navigator.of(context).pop()
                      },
                      title: "Cancel",
                      primary: AppTheme.colors.white,
                      onPrimary: AppTheme.colors.black),
                ],
              ),
            );
          }),
    );
  }

  Future<String> uploadFile(String filePath,) async {
    File file = File(filePath);
    final User currentUser = FirebaseAuth.instance.currentUser!;
    DocumentSnapshot doc = await FirebaseFirestore.instance.collection('user').doc(currentUser.uid).get();
    try {
      // var rng = Random();
      //
      // await storage.ref('${DateTime.timestamp().toString()}').putFile(file);
      //
      //
      // String downloadURL =
      // await storage.ref('${DateTime.timestamp().toString()}').getDownloadURL();
      // print("downloadURL : $downloadURL");


      final storageRef = FirebaseStorage.instance.ref();

// Create a reference to "mountains.jpg"
      final mountainsRef = storageRef.child('images/${DateTime.timestamp().toString()}');
      await mountainsRef.putFile(file, SettableMetadata(contentType: 'image/png'));
      String downloadURL = await mountainsRef.getDownloadURL();

      return downloadURL;

      return downloadURL;
    } on FirebaseException catch (e) {
      print(e);
    }
    return "";
  }
}
