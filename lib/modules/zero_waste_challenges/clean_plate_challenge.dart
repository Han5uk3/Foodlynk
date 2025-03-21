import 'dart:io';

import 'package:flutter/material.dart';
import 'package:saver_bbk_main/api/compare_plates.dart';
import 'package:saver_bbk_main/common_widget/button.dart';
import 'package:saver_bbk_main/common_widget/image_picker.dart';
import 'package:saver_bbk_main/common_widget/outline_button.dart';
import 'package:saver_bbk_main/common_widget/saver_appbar.dart';
import 'package:saver_bbk_main/common_widget/snakbar.dart';
import 'package:saver_bbk_main/common_widget/svgicon.dart';
import 'package:saver_bbk_main/styles/colors.dart';

class CleanPlateChallenge extends StatefulWidget {
  const CleanPlateChallenge({super.key});

  @override
  State<CleanPlateChallenge> createState() => _CleanPlateChallengeState();
}

class _CleanPlateChallengeState extends State<CleanPlateChallenge> {
  File? _beforeImageFile;
  File? _afterImageFile;

  void _setBeforeImage(File image) {
    setState(() {
      _beforeImageFile = image;
    });
  }

  void _setAfterImage(File image) {
    setState(() {
      _afterImageFile = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: saverAppBar("Clean Plate Challenge", context, isneedtopop: true),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(14),
        child:
            (_beforeImageFile != null && _afterImageFile != null)
                ? SaverButton(
                  text: "Submit Challenge",
                  onPressed: () async {
                    final bool isPlateEmpty = await comparePlates(
                      _beforeImageFile!,
                      _afterImageFile!,
                    );
                    isPlateEmpty
                        ? _showCompletedBottomSheet(context)
                        : SaverSnackBar.show(
                          context: context,
                          message: "failed",
                          isTrue: false,
                        );
                  },
                )
                : SaverButton(
                  text: "Submit Challenge",
                  color: AppColor.lightGrey200,
                  onPressed: () {
                    showSnackBar(context, "Please select both images");
                  },
                ), // Empty space when condition is false
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IntrinsicHeight(
                  child: Card(
                    color: AppColor.white,
                    elevation: 3,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            Center(
                              child: SizedBox(
                                height: 150,
                                width: 150,
                                child: loadsvg("assets/icons/cleanplate.svg"),
                              ),
                            ),

                            Align(
                              alignment: Alignment.topRight,
                              child: IntrinsicWidth(
                                child: Container(
                                  margin: EdgeInsets.only(right: 12, top: 15),
                                  height: 25,

                                  padding: EdgeInsets.symmetric(horizontal: 7),
                                  decoration: BoxDecoration(
                                    color: AppColor.pointColor,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Center(
                                    child: Text(
                                      "+10 points",
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: AppColor.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Divider(
                          color: Colors.grey.shade200,
                          thickness: 2,
                          endIndent: 12,
                          indent: 12,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Text(
                            "Finish your entire meal without leftovers and upload a before & after photo.",
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.only(
                            left: 12,
                            right: 12,
                            bottom: 12,
                          ),
                          child: Text(
                            "Steps to Complete",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        bulletText(
                          "Take a \"before\" photo of your full plate. ",
                        ),
                        bulletText("Enjoy your meal!"),
                        bulletText(
                          "Take an \"after\" photo of your clean plate .",
                        ),
                        bulletText("Submit for verification!"),
                        SizedBox(height: 9.5),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 3,
                    vertical: 12,
                  ),
                  child: Text(
                    "Upload before image",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 12, bottom: 12),
                  child: Row(
                    children: [
                      if (_beforeImageFile != null)
                        Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: IntrinsicWidth(
                            child: IntrinsicHeight(
                              child: Stack(
                                children: [
                                  SizedBox(
                                    height: 100,
                                    width: 100,
                                    child: Center(
                                      child: Container(
                                        height: 90,
                                        width: 90,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          image: DecorationImage(
                                            image: FileImage(_beforeImageFile!),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    child: SizedBox(
                                      width: 100,
                                      child: Align(
                                        alignment: Alignment.topRight,
                                        child: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              _beforeImageFile = null;
                                            });
                                          },
                                          child: CircleAvatar(
                                            radius: 10,
                                            backgroundColor: Colors.white70,
                                            child: Center(
                                              child: Icon(
                                                Icons.close,
                                                color: AppColor.black,
                                                size: 15,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      _beforeImageFile == null
                          ? ImagePickerButton(onImageSelected: _setBeforeImage)
                          : SizedBox(),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 3,
                    vertical: 12,
                  ),
                  child: Text(
                    "Upload after image",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 12, bottom: 12),
                  child: Row(
                    children: [
                      if (_afterImageFile != null)
                        Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: IntrinsicWidth(
                            child: IntrinsicHeight(
                              child: Stack(
                                children: [
                                  SizedBox(
                                    height: 100,
                                    width: 100,
                                    child: Center(
                                      child: Container(
                                        height: 90,
                                        width: 90,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          image: DecorationImage(
                                            image: FileImage(_afterImageFile!),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    child: SizedBox(
                                      width: 100,
                                      child: Align(
                                        alignment: Alignment.topRight,
                                        child: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              _afterImageFile = null;
                                            });
                                          },
                                          child: CircleAvatar(
                                            radius: 10,
                                            backgroundColor: Colors.white70,
                                            child: Center(
                                              child: Icon(
                                                Icons.close,
                                                color: AppColor.black,
                                                size: 15,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      _afterImageFile == null
                          ? ImagePickerButton(onImageSelected: _setAfterImage)
                          : SizedBox(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget bulletText(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2.5),
      child: Row(
        spacing: 5,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 3,
            backgroundColor: Colors.grey.shade600,
          ), // Bullet point
          Expanded(
            child: Text(text, style: TextStyle(color: Colors.grey.shade600)),
          ),
        ],
      ),
    );
  }

  _showCompletedBottomSheet(context) {
    showModalBottomSheet(
      backgroundColor: AppColor.white,
      isDismissible: false,
      enableDrag: false,
      barrierColor: Colors.black26,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.55,
      ),
      context: context,
      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
          ),
          padding: const EdgeInsets.only(
            left: 16,
            right: 16,
            top: 20,
            bottom: 16,
          ),
          child: Column(
            children: [
              Text(
                "Congratulations",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: AppColor.black,
                ),
              ),
              SizedBox(height: 12),
              Divider(thickness: 2, color: Colors.grey.shade200),
              SizedBox(height: 18),
              loadsvg("assets/icons/completed.svg"),
              SizedBox(height: 20),
              Text(
                "You earned 10 Points on completing your Clean Plate Challenge!",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 35),
              Row(
                spacing: 12,
                children: [
                  Expanded(
                    child: SaverOutlineButton(
                      text: "Take Again",
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  Expanded(
                    child: SaverButton(
                      text: "Back To Challenges",

                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  showSnackBar(context, String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
