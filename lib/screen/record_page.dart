import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crop_doc/models/record_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';

import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import '../widgets/app_elevated_button.dart';
import 'loading_screen.dart';

class RecordPage extends StatefulWidget {
  final RecordModel record;

  const RecordPage({Key? key, required this.record}) : super(key: key);

  @override
  State<RecordPage> createState() => _RecordPageState();
}

class _RecordPageState extends State<RecordPage> {
  final double expandedHeight = 300;
  final double roundedContainerHeight = 50;
  bool valueCheck = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors().white,
        body: Stack(
          children: [
            CustomScrollView(
              slivers: [
                _buildSilverHead(),
                SliverToBoxAdapter(
                  child: _buildDetail(valueCheck),
                )
              ],
            ),
            Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery
                      .of(context)
                      .padding
                      .top, right: 15, left: 15),
              child: SizedBox(
                height: kToolbarHeight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Icon(Icons.arrow_back, color: Colors.black)),
                    // Icon(Icons.menu, color: Colors.white),
                  ],
                ),
              ),
            )
          ],
        ));
  }

  Widget _buildSilverHead() {
    return SliverPersistentHeader(
        delegate: RecordSliverDelegate(
            record: widget.record,
            expandedHeight: expandedHeight,
            roundedContainerHeight: roundedContainerHeight));
  }

  //---------------------content details------------------------
  Widget _buildDetail(valueCheck) {
    return Container(
      child: Column(
        children: [
          _buildUserInfo(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
            child: Text(
              "${widget.record.cause}",
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: AppColors().black, fontSize: 16, height: 1.5),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
            child: Text(
              "${widget.record.steps}",
              style: TextStyle(
                  color: AppColors().black, fontSize: 16, height: 1.5),
            ),
          ),
          AppElevatedButton(
              onPressed: ()
              {
                FirebaseFirestore.instance
                    .collection("record")
                    .doc(widget.record.id).delete();
                Navigator.of(context).pop();
                EasyLoading.showSuccess(
                    "Record Deleted!");
                  },
              title: "Delete Record",
              primary: Colors.red,
              bottom: 10,
              top: 20,
              left: 20,
              right: 20,
              borderRadius: 10,
              onPrimary: AppTheme.colors.white),

        ],
      ),
    );
  }

  // -------------- contend header -----------------
  Widget _buildUserInfo() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: Row(
        children: [
          Flexible(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "${widget.record.disease}",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors().black),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "${DateFormat('dd-MM-yyyy   HH:mm').format(
                        widget.record.timeStamp as DateTime)}",
                    style: TextStyle(fontSize: 16, color: AppColors().green),
                  ),
                ],
              ),
            ),
          ),
          // Icon(
          //   Icons.bookmark,
          //   color: Colors.grey,
          // )
        ],
      ),
    );
  }
}

//--------------------Header Image------------------
class RecordSliverDelegate extends SliverPersistentHeaderDelegate {
  final RecordModel record;
  final double expandedHeight;
  final double roundedContainerHeight;

  RecordSliverDelegate({required this.record,
    required this.expandedHeight,
    required this.roundedContainerHeight});

  @override
  Widget build(BuildContext context, double shrinkOffset,
      bool overlapsContent) {
    return Stack(
      children: [
        CachedNetworkImage(
            imageUrl: "${record.url}",
            width: MediaQuery
                .of(context)
                .size
                .width,
            height: expandedHeight,
            fit: BoxFit.cover,
            placeholder: (context, url) => LoadingScreen(),
            errorWidget: (context, url, error) =>
                Image.asset('assets/images/crop_doc_logo.png', fit: BoxFit.cover,)
        ),
        Positioned(
          top: expandedHeight - roundedContainerHeight - shrinkOffset,
          left: 0,
          child: Container(
            width: MediaQuery
                .of(context)
                .size
                .width,
            height: roundedContainerHeight,
            decoration: BoxDecoration(
                color: AppColors().white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30))),
          ),
        ),
      ],
    );
  }

  @override
  double get maxExtent => expandedHeight;

  @override
  double get minExtent => 0;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
