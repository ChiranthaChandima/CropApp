import 'dart:convert';
import 'dart:io';

import 'package:crop_doc/theme/app_theme.dart';
import 'package:crop_doc/widgets/app_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:loading_animation_widget/loading_animation_widget.dart';

import 'cause_page.dart';

class UploadedImage extends StatefulWidget {
  final File? uploadImage;

  const UploadedImage({Key? key, this.uploadImage}) : super(key: key);

  @override
  State<UploadedImage> createState() => _UploadedImageState();
}

class _UploadedImageState extends State<UploadedImage> {
  String uri =
      "https://7eed-2402-4000-20c3-63c1-19a1-f322-1ae1-7b37.ngrok-free.app/predict";
  dynamic responseList;
  bool? isLoading = false;
  bool? isPredictionFinish = false;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("Disease Prediction"),
        backgroundColor: AppTheme.colors.green,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                // Container(
                //   height: 250.0,
                //   width: width,
                //   margin:
                //       EdgeInsets.only(bottom: 30.0, left: 30.0, right: 30.0),
                //   decoration:
                //       widget.uploadImage == null || widget.uploadImage == true
                //           ? BoxDecoration(color: AppTheme.colors.green)
                //           : BoxDecoration(
                //               image: DecorationImage(
                //                 image: FileImage(widget.uploadImage!),
                //                 fit: BoxFit.cover,
                //               ),
                //             ),
                // ),
                Container(
                  height: 250.0,
                  width: width,
                  margin: EdgeInsets.only(bottom: 30.0, left: 30.0, right: 30.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0), // Add border radius
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                    // Conditionally set background color or image
                    image: widget.uploadImage == null || widget.uploadImage == true
                        ? null
                        : DecorationImage(
                      image: FileImage(widget.uploadImage!),
                      fit: BoxFit.cover,
                    ),
                    color: widget.uploadImage == null || widget.uploadImage == true
                        ? AppTheme.colors.green
                        : null,
                  ),
                ),
                SizedBox(height: 16),
                if (isLoading! == false && isPredictionFinish! == false)
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        isLoading = true;
                      });
                      print("isLoading => ${isLoading}");
                      print("Upload Image => ${widget.uploadImage}");
                      handleUploadImage(widget.uploadImage!);
                      // Navigator.pushNamed(context, UploadScreen.routeName);
                    },
                    style: ElevatedButton.styleFrom(
                      primary: AppTheme.colors.green, // Dark blue
                      padding: const EdgeInsets.all(16),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(25), // Rounded button
                      ),
                    ),
                    child: const Text(
                      'Scan',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontFamily: 'Roboto', // Use a different font
                      ),
                    ),
                  ),
                if (isLoading!)
                  LoadingAnimationWidget.prograssiveDots(
                    color: AppTheme.colors.green,
                    size: 100,
                  ),
                if (isPredictionFinish!)
                  Column(
                    children: [
                      Center(
                          child: Text(
                            "Result",
                            style: TextStyle(
                              fontSize: 25,
                              color: AppTheme.colors.black, // Dark blue
                              fontFamily: 'Raleway ', // Use a different font
                            ),
                          ),
                      ),Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 10.0),
                          child: Text(
                            "${responseList["class"].replaceAll('_', ' ')}",
                            style: TextStyle(
                              fontSize: 30,
                              color: AppTheme.colors.green, // Dark blue
                              fontFamily: 'Raleway ', // Use a different font
                            ),
                          ),
                        ),
                      ),
                      Center(
                        child: Text(
                          "Confidence : ${(responseList["confidence"] * 100).toStringAsFixed(2)}%",
                          style: TextStyle(
                            fontSize: 25,
                            color: AppTheme.colors.green02, // Dark blue
                            fontFamily: 'Raleway ', // Use a different font
                          ),
                        ),
                      ),
                      if (responseList["class"] != "Healthy") // Condition to check if class is not "Healthy"
                        Visibility(
                          visible: responseList["class"] != "Healthy",
                          child: AppElevatedButton(
                            onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        CausePage(treatment: responseList["class"], file:widget.uploadImage))),
                            title: "Treatment",
                            primary: AppTheme.colors.green,
                            bottom: 10,
                            top: 20,
                            onPrimary: AppTheme.colors.white,
                          ),
                        ),
                      AppElevatedButton(
                          onPressed: () => Navigator.of(context).pop(),
                          title: "Cancel",
                          primary: AppTheme.colors.gray02,
                          onPrimary: AppTheme.colors.black)
                    ],
                  ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void handleUploadImage(File uploadImage) async {
    final request = http.MultipartRequest("POST", Uri.parse(uri));

    request.files
        .add(await http.MultipartFile.fromPath('file', uploadImage.path));
    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String responseString =
          await response.stream.bytesToString(); // Store response in a variable
      print(responseString);
      final resJson = jsonDecode(responseString); // Assuming response is JSON
      print("Response => $resJson");
      setState(() {
        responseList = resJson;
        isLoading = false;
        isPredictionFinish = true;
      });
      print("class => ${responseList["class"]}");
      print("confidence => ${responseList["confidence"]}");
    } else {
      print(response.reasonPhrase);
    }
  }
}
