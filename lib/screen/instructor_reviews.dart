import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crop_doc/firebase/instructor_collection.dart';
import 'package:crop_doc/firebase/records_collection.dart';
import 'package:crop_doc/firebase/review_collection.dart';
import 'package:crop_doc/models/instructor_modal.dart';
import 'package:crop_doc/models/record_model.dart';
import 'package:crop_doc/screen/instructor_page.dart';
import 'package:crop_doc/screen/record_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../models/review_modal.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import '../widgets/app_elevated_button.dart';
import '../widgets/app_text_field.dart';
import 'loading_screen.dart';

class InstructorReviews extends StatefulWidget {
  final String instructorId;  const InstructorReviews({Key? key, required this.instructorId}) : super(key: key);

  @override
  State<InstructorReviews> createState() => _InstructorReviewsState();
}

class _InstructorReviewsState extends State<InstructorReviews> {

  final _pageCtrl = PageController(viewportFraction: 0.9);

  @override
  Widget build(BuildContext context) {
    double screenSize = MediaQuery.of(context).size.height;
    double height = screenSize - kToolbarHeight - 90.0;

    return Scaffold(
      backgroundColor: const Color(0xffffffff),
      appBar: AppBar(
        title: Text("Instructor Reviews",),
        backgroundColor: AppTheme.colors.green,
      ),
      body: StreamBuilder<List<ReviewModel>>(
        stream: ReviewCollection.readSelectedInstReviews(widget.instructorId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return LoadingScreen();
          }
          if (snapshot.hasError) {
            return Center(
              child: Text("some error occured",
                  style: TextStyle(
                    color: Colors.white,
                  )),
            );
          }
          if (snapshot.hasData) {
            final recordData = snapshot.data;

            return Stack(
              children: [
                ListView.builder(
                    controller: _pageCtrl,
                    itemCount: recordData?.length,
                    itemBuilder: (context, index) {
                      final insData = recordData![index];
                      if(recordData.isNotEmpty){
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Stack(
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.fromLTRB(40.0, 5.0, 20.0, 5.0),
                                height: 170.0,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: AppTheme.colors.gray02,
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                child: Padding(
                                  padding:
                                  EdgeInsets.fromLTRB(100.0, 20.0, 20.0, 20.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Container(
                                            // width: 120.0,
                                            child: Flexible(
                                              child: Text(
                                                "${insData.userName}",
                                                style: TextStyle(
                                                  fontSize: 18.0,
                                                  color: AppTheme.colors.black,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 2,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 50.0),
                                      Flexible(
                                        child: Text(
                                          "${insData.review }",
                                          style: TextStyle(
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 10.0),
                                    ],
                                  ),
                                ),
                              ),
                              Positioned(
                                left: 0,
                                top: 15.0,
                                bottom: 15.0,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20.0),
                                  child: Image.asset('assets/images/profile02.png', fit: BoxFit.cover,),
                                ),
                              ),
                            ],
                          ),
                        );
                      } else{
                        return Center(
                          child: Text(
                              "Empty!"
                          ),
                        );
                      }

                    }),
              ],
            );
          }
          return LoadingScreen();
        },
      ),
    );
  }
}
