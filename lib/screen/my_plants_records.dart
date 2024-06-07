import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crop_doc/firebase/records_collection.dart';
import 'package:crop_doc/models/record_model.dart';
import 'package:crop_doc/screen/all_instructors_page.dart';
import 'package:crop_doc/screen/record_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import '../widgets/app_elevated_button.dart';
import '../widgets/app_text_field.dart';
import 'loading_screen.dart';

class MyPlantsRecords extends StatefulWidget {
  final DocumentSnapshot<Object?>? currentUser;
  const MyPlantsRecords({Key? key, this.currentUser}) : super(key: key);

  @override
  State<MyPlantsRecords> createState() => _MyPlantsRecordsState();
}

class _MyPlantsRecordsState extends State<MyPlantsRecords> {

  final _pageCtrl = PageController(viewportFraction: 0.9);

  @override
  Widget build(BuildContext context) {
    double screenSize = MediaQuery.of(context).size.height;
    double height = screenSize - kToolbarHeight - 90.0;

    return Scaffold(
      backgroundColor: const Color(0xffffffff),
      appBar: AppBar(
        title: Text("My Plants Records",),
        backgroundColor: AppTheme.colors.green,
      ),
      body: StreamBuilder<List<RecordModel>>(
        stream: RecordCollection.readSelectedUserRecords(widget.currentUser!.id),
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

            print("===========recordData===============${recordData}");

            return Stack(
              children: [
                ListView.builder(
                    controller: _pageCtrl,
                    itemCount: recordData?.length,
                    itemBuilder: (context, index) {
                      // var travel = _list[index];
                      final userRecord = recordData![index];
                      if(recordData.isNotEmpty){
                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: (context) {
                              return RecordPage(record: userRecord);
                            }));
                          },
                          child: Stack(
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.fromLTRB(40.0, 5.0, 20.0, 5.0),
                                height: 170.0,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: AppTheme.colors.grey200,
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
                                                "${userRecord.cause}",
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
                                          "${DateFormat('dd-MM-yyyy   HH:mm').format(userRecord.timeStamp as DateTime)}",
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
                                    imageUrl: "${userRecord.url}",
                                    width: 110.0,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => const LoadingScreen(),
                                    errorWidget: (context, url, error) => Image.asset('assets/images/crop_doc_logo.png', fit: BoxFit.cover,),
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
                if(!widget.currentUser!["isInstructor"])
                  Positioned(
                    bottom: 15.0,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          height: 90,
                          width: 500,
                          child:  AppElevatedButton(
                              onPressed: ()
                              {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          AllInstructorsPage(currentUser: widget.currentUser)));
                              },
                              title: "Contact Agri-Instractor",
                              primary: AppTheme.colors.green,
                              bottom: 10,
                              top: 20,
                              onPrimary: AppTheme.colors.white),

                        ),
                      ),
                    ),
                  )
              ],
            );
          }
          return LoadingScreen();
        },
      ),
    );
  }
}
