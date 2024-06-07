import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crop_doc/models/instructor_modal.dart';
import 'package:crop_doc/models/record_model.dart';
import 'package:crop_doc/screen/instructor_reviews.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';

import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import '../validation/form_validation.dart';
import '../widgets/app_elevated_button.dart';
import '../widgets/app_text_field.dart';
import 'loading_screen.dart';

class ProfilePage extends StatefulWidget {
  final DocumentSnapshot<Object?>? currentUser;

  const ProfilePage({Key? key, required this.currentUser}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  TextEditingController review = TextEditingController();
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
            expandedHeight: expandedHeight,
            roundedContainerHeight: roundedContainerHeight));
  }

  //---------------------content details------------------------
  Widget _buildDetail(valueCheck) {
    return Container(
      child: Column(
        children: [
          _buildUserInfo(),
          if(widget.currentUser!["isInstructor"])
            AppElevatedButton(
                onPressed: ()
                {
                  print("widget.currentUser!.id : ${widget.currentUser!.id}");
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return InstructorReviews(instructorId: widget.currentUser!.id);
                  }));
                },
                title: "See All Reviews",
                primary: AppTheme.colors.green,
                bottom: 10,
                top: 20,
                left: 20,
                right: 20,
                borderRadius: 10,
                onPrimary: AppTheme.colors.white),
          AppElevatedButton(
              onPressed: ()
              {
                FirebaseAuth.instance.signOut();
                Navigator.of(context).pop();
              },
              title: "Log out",
              primary: AppTheme.colors.white,
              bottom: 10,
              top: 5,
              left: 20,
              right: 20,
              borderRadius: 10,
              borderColor: AppTheme.colors.green,
              onPrimary: AppTheme.colors.green),

        ],
      ),
    );
  }

  // -------------- contend header -----------------
  Widget _buildUserInfo() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [

          SizedBox(
            height: 10,
          ),
          Text(
            "${widget.currentUser!['username']}",
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors().black),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "${widget.currentUser!['district'] } - ${widget.currentUser!['division'] }",
            style: TextStyle(fontSize: 16, color: AppColors().green),
          ),
          SizedBox(
            height: 15,
          ),
          Text(
            "${widget.currentUser!['mobileNo'] }",
            style: TextStyle(fontSize: 16, color: AppColors().black),
          ),
          SizedBox(
            height: 15,
          ),
          Text(
            "${widget.currentUser!['email'] }",
            style: TextStyle(fontSize: 16, color: AppColors().black),
          ),
        ],
      ),
    );
  }
}

//--------------------Header Image------------------
class RecordSliverDelegate extends SliverPersistentHeaderDelegate {
  final double expandedHeight;
  final double roundedContainerHeight;

  RecordSliverDelegate({
    required this.expandedHeight,
    required this.roundedContainerHeight});

  @override
  Widget build(BuildContext context, double shrinkOffset,
      bool overlapsContent) {
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Align(
            alignment: Alignment.center,
            child: SizedBox(
              width: 200,
              height: 200,
              child: Image.asset(
                'assets/images/profile.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
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
