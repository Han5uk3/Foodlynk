import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saver_bbk_main/api/compare_plates.dart';
import 'package:saver_bbk_main/common_widget/button.dart';
import 'package:saver_bbk_main/common_widget/image_picker.dart';
import 'package:saver_bbk_main/common_widget/outline_button.dart';
import 'package:saver_bbk_main/common_widget/saver_appbar.dart';
import 'package:saver_bbk_main/common_widget/snakbar.dart';
import 'package:saver_bbk_main/common_widget/svgicon.dart';
import 'package:saver_bbk_main/modules/zero_waste_challenges/bloc/challenge_bloc.dart';
import 'package:saver_bbk_main/styles/colors.dart';

class CleanPlateChallenge extends StatefulWidget {
  const CleanPlateChallenge({super.key});

  @override
  State<CleanPlateChallenge> createState() => _CleanPlateChallengeState();
}

class _CleanPlateChallengeState extends State<CleanPlateChallenge> {
  File? _beforeImageFile;
  File? _afterImageFile;

  void _setAfterImage(File image) {
    setState(() => _afterImageFile = image);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: saverAppBar("Clean Plate Challenge", context, isneedtopop: true),
      body: BlocListener<ChallengeBloc, ChallengeState>(
        listener: (context, state) {
          if (state is BeforeUploadImageSuccessState) {
            setState(() => _beforeImageFile = state.image);
          }
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildChallengeCard(),
                _buildImageSection(
                  "Upload before image",
                  _beforeImageFile,
                  true,
                ),
                _buildImageSection(
                  "Upload after image",
                  _afterImageFile,
                  false,
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(14),
        child: SaverButton(
          text: "Submit Challenge",
          onPressed: () {},
          // color:
          // (_beforeImageFile != null && _afterImageFile != null)
          //     ? AppColor.primary
          //     : AppColor.lightGrey200,
          // onPressed: (_beforeImageFile != null && _afterImageFile != null)
          //     ? () async {
          //         final bool isPlateEmpty = await comparePlates(
          //           _beforeImageFile!,
          //           _afterImageFile!,
          //         );
          //         isPlateEmpty
          //             ? _showCompletedBottomSheet(context)
          //             : SaverSnackBar.show(
          //                 context: context,
          //                 message:
          //                     "Finish your meal and clean your plate before uploading image",
          //                 isTrue: false,
          //               );
          //       }
          //     : null,
        ),
      ),
    );
  }

  Widget _buildChallengeCard() {
    return Card(
      color: AppColor.white,
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
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
                Positioned(
                  top: 15,
                  right: 12,
                  child: Container(
                    height: 25,
                    padding: const EdgeInsets.symmetric(horizontal: 7),
                    decoration: BoxDecoration(
                      color: AppColor.pointColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        "+10 points",
                        style: TextStyle(fontSize: 12, color: AppColor.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Divider(color: Colors.grey.shade200, thickness: 2),
            Text(
              "Finish your entire meal without leftovers and upload a before & after photo.",
              style: TextStyle(color: Colors.grey.shade600),
            ),
            const SizedBox(height: 12),
            Text(
              "Steps to Complete",
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
            const SizedBox(height: 8),
            bulletText("Take a \"before\" photo of your full plate."),
            bulletText("Enjoy your meal!"),
            bulletText("Take an \"after\" photo of your clean plate."),
            bulletText("Submit for verification!"),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Widget _buildImageSection(String title, File? imageFile, bool isBefore) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Text(
            title,
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
          ),
        ),
        Row(
          children: [
            if (imageFile != null) _buildImagePreview(imageFile, isBefore),
            Visibility(
              visible: imageFile == null,
              child: ImagePickerButton(
                onImageSelected: (File image) {
                  if (isBefore) {
                    context.read<ChallengeBloc>().add(
                      UploadBeforeImageEvent(imageFile: image),
                    );
                  } else {
                    _setAfterImage(image);
                  }
                },
                isFood: isBefore,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildImagePreview(File imageFile, bool isBefore) {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: Stack(
        children: [
          Container(
            height: 100,
            width: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              image: DecorationImage(
                image: FileImage(imageFile),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  if (isBefore) {
                    _beforeImageFile = null;
                  } else {
                    _afterImageFile = null;
                  }
                });
              },
              child: CircleAvatar(
                radius: 12,
                backgroundColor: Colors.white70,
                child: Icon(Icons.close, color: AppColor.black, size: 15),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget bulletText(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            height: 8,
            width: 8,
            decoration: BoxDecoration(
              color: Colors.grey.shade600,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(text, style: TextStyle(color: Colors.grey.shade600)),
          ),
        ],
      ),
    );
  }

  _showCompletedBottomSheet(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: AppColor.white,
      context: context,
      builder:
          (_) => Container(
            padding: const EdgeInsets.all(16),
            height: MediaQuery.of(context).size.height * 0.55,
            child: Column(
              children: [
                Text(
                  "Congratulations!",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Divider(thickness: 2, color: Colors.grey.shade200),
                const SizedBox(height: 18),
                loadsvg("assets/icons/completed.svg"),
                const SizedBox(height: 20),
                Text(
                  "You earned 10 points on completing your challenge!",
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 35),
                Row(
                  children: [
                    Expanded(
                      child: SaverOutlineButton(
                        text: "Take Again",
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    Expanded(
                      child: SaverButton(
                        text: "Back",
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
    );
  }
}
