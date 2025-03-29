import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  bool _isBeforeImageUploading = false;
  bool _isAfterImageUploading = false;

  void _setAfterImage(File image) {
    setState(() {
      _isAfterImageUploading = true;
    });
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _afterImageFile = image;
        _isAfterImageUploading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: saverAppBar("Clean Plate Challenge", context, isneedtopop: true),
      body: BlocListener<ChallengeBloc, ChallengeState>(
        listener: (context, state) {
          if (state is BeforeUploadImageLoadingState) {
            setState(() => _isBeforeImageUploading = true);
          } else if (state is BeforeUploadImageSuccessState) {
            setState(() {
              _beforeImageFile = state.image;
              _isBeforeImageUploading = false;
            });
            SaverSnackBar.show(
              context: context,
              message: "Before image uploaded successfully!",
              isTrue: true,
            );
          } else if (state is BeforeUploadImageErrorState) {
            setState(() => _isBeforeImageUploading = false);
            SaverSnackBar.show(
              context: context,
              message: "Failed to upload image. Please try again.",
              isTrue: false,
            );
          } else if (state is ChallengeInitial) {
            // Handle the case when image is removed
            setState(() {
              _beforeImageFile = null;
              _isBeforeImageUploading = false;
            });
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
                  _isBeforeImageUploading,
                ),
                _buildImageSection(
                  "Upload after image",
                  _afterImageFile,
                  false,
                  _isAfterImageUploading,
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
          color:
              (_beforeImageFile != null &&
                      _afterImageFile != null &&
                      !_isBeforeImageUploading &&
                      !_isAfterImageUploading)
                  ? AppColor.primaryColor
                  : AppColor.lightGrey200,
          onPressed: () {},
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

  Widget _buildImageSection(
    String title,
    File? imageFile,
    bool isBefore,
    bool isUploading,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            children: [
              Text(
                title,
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              ),
              if (isUploading) ...[
                const SizedBox(width: 10),
                SizedBox(
                  width: 15,
                  height: 15,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColor.primaryColor,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  "Uploading...",
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColor.primaryColor,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ],
          ),
        ),
        Row(
          children: [
            if (imageFile != null) _buildImagePreview(imageFile, isBefore),
            if (isUploading && imageFile == null)
              _buildLoadingImagePlaceholder(),
            Visibility(
              visible: imageFile == null && !isUploading,
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

  Widget _buildLoadingImagePlaceholder() {
    return Container(
      height: 100,
      width: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey.shade200,
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: AppColor.primaryColor,
              strokeWidth: 3,
            ),
            const SizedBox(height: 8),
            Text(
              "Processing",
              style: TextStyle(fontSize: 12, color: AppColor.primaryColor),
            ),
          ],
        ),
      ),
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
                if (isBefore) {
                  // Dispatch the remove event to the bloc
                  context.read<ChallengeBloc>().add(RemoveBeforeImageEvent());
                  setState(() {
                    _beforeImageFile = null;
                  });
                } else {
                  setState(() {
                    _afterImageFile = null;
                  });
                }
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

  void _showLoadingDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 16),
              CircularProgressIndicator(color: AppColor.primaryColor),
              const SizedBox(height: 16),
              Text(message),
            ],
          ),
        );
      },
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
                        onPressed: () {
                          Navigator.pop(context);
                          setState(() {
                            _beforeImageFile = null;
                            _afterImageFile = null;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
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
