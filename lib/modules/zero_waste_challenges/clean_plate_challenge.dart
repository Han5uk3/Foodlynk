import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saver_bbk_main/common_widget/button.dart';
import 'package:saver_bbk_main/common_widget/image_picker.dart';
import 'package:saver_bbk_main/common_widget/saver_appbar.dart';
import 'package:saver_bbk_main/common_widget/snakbar.dart';
import 'package:saver_bbk_main/common_widget/svgicon.dart';
import 'package:saver_bbk_main/modules/zero_waste_challenges/bloc/challenge_bloc.dart';
import 'package:saver_bbk_main/styles/colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CleanPlateChallenge extends StatefulWidget {
  const CleanPlateChallenge({super.key});

  @override
  State<CleanPlateChallenge> createState() => _CleanPlateChallengeState();
}

class _CleanPlateChallengeState extends State<CleanPlateChallenge> {
  File? _beforeImageFile;
  File? _afterImageFile;
  bool _isSubmitting = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: saverAppBar(
        AppLocalizations.of(context)!.cleanPlateChallenge,
        context,
        isneedtopop: true,
      ),
      body: BlocConsumer<ChallengeBloc, ChallengeState>(
        listener: (context, state) {
          if (state is BeforeUploadImageSuccessState) {
            setState(() {
              _beforeImageFile = state.image;
            });
            SaverSnackBar.show(
              context: context,
              message:
                  AppLocalizations.of(context)!.beforeImageUploadedSuccessfully,
              isTrue: true,
            );
          } else if (state is BeforeUploadImageErrorState) {
            SaverSnackBar.show(
              context: context,
              message: state.errorMessage,
              isTrue: false,
            );
          } else if (state is AfterUploadImageSuccessState) {
            setState(() {
              _beforeImageFile = state.beforeImage;
              _afterImageFile = state.afterImage;
            });
            SaverSnackBar.show(
              context: context,
              message:
                  AppLocalizations.of(context)!.afterImageUploadedSuccessfully,
              isTrue: true,
            );
          } else if (state is AfterUploadImageErrorState) {
            SaverSnackBar.show(
              context: context,
              message: state.errorMessage,
              isTrue: false,
            );
          } else if (state is ChallengeSubmissionSuccessState) {
            setState(() {
              _isSubmitting = false;
            });
            _showCompletedBottomSheet(context, state.points);
          } else if (state is ChallengeSubmissionErrorState) {
            setState(() {
              _isSubmitting = false;
            });
            SaverSnackBar.show(
              context: context,
              message: state.errorMessage,
              isTrue: false,
            );
          } else if (state is ChallengeInitial) {
            setState(() {
              _beforeImageFile = null;
            });
          } else if (state is ChallengeSubmissionLoadingState) {
            setState(() {
              _isSubmitting = true;
            });
          }
        },
        builder: (context, state) {
          bool isBeforeLoading = state is BeforeUploadImageLoadingState;
          bool isAfterLoading = state is AfterUploadImageLoadingState;
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildChallengeCard(),
                  _buildImageSection(
                    AppLocalizations.of(context)!.uploadBeforeImage,
                    _beforeImageFile,
                    true,
                    isBeforeLoading,
                  ),
                  _buildImageSection(
                    AppLocalizations.of(context)!.uploadAfterImage,
                    _afterImageFile,
                    false,
                    isAfterLoading,
                  ),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(14),
        child: SaverButton(
          text:
              _isSubmitting
                  ? AppLocalizations.of(context)!.submitting
                  : AppLocalizations.of(context)!.submitChallenge,
          color:
              (_beforeImageFile != null &&
                      _afterImageFile != null &&
                      !_isSubmitting)
                  ? AppColor.primaryColor
                  : AppColor.lightGrey200,
          onPressed:
              (_beforeImageFile != null &&
                      _afterImageFile != null &&
                      !_isSubmitting)
                  ? () {
                    context.read<ChallengeBloc>().add(
                      SubmitChallengeEvent(
                        beforeImageFile: _beforeImageFile!,
                        afterImageFile: _afterImageFile!,
                      ),
                    );
                  }
                  : () {},
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
                        AppLocalizations.of(context)!.tenpoints,
                        style: TextStyle(fontSize: 12, color: AppColor.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Divider(color: Colors.grey.shade200, thickness: 2),
            Text(
              AppLocalizations.of(context)!.finishYourEntireMeal,
              style: TextStyle(color: Colors.grey.shade600),
            ),
            const SizedBox(height: 12),
            Text(
              AppLocalizations.of(context)!.stepsToComplete,
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
            const SizedBox(height: 8),
            bulletText(
              AppLocalizations.of(context)!.takeABeforePhotoOfYourFullPlate,
            ),
            bulletText(AppLocalizations.of(context)!.enjoyYourMeal),
            bulletText(
              AppLocalizations.of(context)!.takeAnAfterPhotoOfYourCleanPlate,
            ),
            bulletText(AppLocalizations.of(context)!.submitForVerification),
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
    bool isLoading,
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
              if (isLoading) ...[
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
                  AppLocalizations.of(context)!.uploading,
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
            if (isLoading && imageFile == null) _buildLoadingImagePlaceholder(),
            Visibility(
              visible: imageFile == null && !isLoading,
              child: ImagePickerButton(
                onImageSelected: (File image) {
                  if (isBefore) {
                    context.read<ChallengeBloc>().add(
                      UploadBeforeImageEvent(context,imageFile: image),
                    );
                  } else if (_beforeImageFile != null) {
                    context.read<ChallengeBloc>().add(
                      UploadAfterImageEvent(
                        context,
                        imageFile: image,
                        beforeImageFile: _beforeImageFile!,
                      ),
                    );
                  } else {
                    SaverSnackBar.show(
                      context: context,
                      message:
                          AppLocalizations.of(
                            context,
                          )!.pleaseUploadTheBeforeImageFirst,
                      isTrue: false,
                    );
                  }
                },
                isFood: true,
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
              AppLocalizations.of(context)!.processing,
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
                  context.read<ChallengeBloc>().add(RemoveBeforeImageEvent());
                  setState(() {
                    _afterImageFile = null;
                  });
                } else {
                  context.read<ChallengeBloc>().add(RemoveAfterImageEvent());
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

  _showCompletedBottomSheet(BuildContext context, int points) {
    showModalBottomSheet(
      backgroundColor: AppColor.white,
      isDismissible: false,
      enableDrag: false,
      useSafeArea: true,
      context: context,
      builder:
          (_) => Container(
            padding: const EdgeInsets.all(16),
            height: MediaQuery.of(context).size.height * 0.70,
            child: Column(
              children: [
                Text(
                  AppLocalizations.of(context)!.congratulations,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Divider(thickness: 2, color: Colors.grey.shade200),
                const SizedBox(height: 18),
                loadsvg("assets/icons/completed.svg"),
                const SizedBox(height: 20),
                Text(
                  AppLocalizations.of(context)!.youEarnedTenPointsOn,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 35),
                Row(
                  children: [
                    const SizedBox(width: 10),
                    Expanded(
                      child: SaverButton(
                        text: AppLocalizations.of(context)!.back,
                        onPressed: () {
                          Navigator.pop(context);
                          context.read<ChallengeBloc>().add(
                            RemoveBeforeImageEvent(),
                          );
                          setState(() {
                            _beforeImageFile = null;
                            _afterImageFile = null;
                          });
                        },
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
