import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crop_doc/firebase/instructor_collection.dart';
import 'package:crop_doc/firebase/records_collection.dart';
import 'package:crop_doc/models/instructor_modal.dart';
import 'package:crop_doc/models/record_model.dart';
import 'package:crop_doc/screen/instructor_page.dart';
import 'package:crop_doc/screen/record_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import '../widgets/app_elevated_button.dart';
import '../widgets/app_text_field.dart';
import 'loading_screen.dart';

class AllInstructorsPage extends StatefulWidget {
  final DocumentSnapshot<Object?>? currentUser;
  const AllInstructorsPage({Key? key, this.currentUser}) : super(key: key);

  @override
  State<AllInstructorsPage> createState() => _AllInstructorsPageState();
}

class _AllInstructorsPageState extends State<AllInstructorsPage> {

  final _pageCtrl = PageController(viewportFraction: 0.9);

  @override
  Widget build(BuildContext context) {
    double screenSize = MediaQuery.of(context).size.height;
    double height = screenSize - kToolbarHeight - 90.0;

    return Scaffold(
      backgroundColor: const Color(0xffffffff),
      appBar: AppBar(
        title: Text("Agri Instructors",),
        backgroundColor: AppTheme.colors.green,
      ),
      body: StreamBuilder<List<InstructorModel>>(
        stream: InstructorCollection.readApprovedInstructors(widget.currentUser!["district"]),
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
                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: (context) {
                              return InstructorPage(instructor: insData, currentUser: widget.currentUser);
                            }));
                          },
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
                                                "${insData.fullName}",
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
                                          "${insData.district } - ${insData.division }",
                                          style: TextStyle(
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 10.0),
                                    ],
                                  ),
                                ),
                              ),
                              Positioned(
                                left: 20.0,
                                top: 15.0,
                                bottom: 15.0,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20.0),
                                  child: CachedNetworkImage(
                                    imageUrl: "https://i.pinimg.com/474x/49/ce/d2/49ced2e29b6d4945a13be722bac54642.jpg",
                                    width: 110.0,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => const LoadingScreen(),
                                    errorWidget: (context, url, error) => Image.asset('assets/images/user_icon.png', fit: BoxFit.cover,),
                                  ),
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
