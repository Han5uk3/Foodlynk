import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerButton extends StatelessWidget {
  final Function(File) onImageSelected;
  final ImagePicker _picker = ImagePicker();

  ImagePickerButton({super.key, required this.onImageSelected});

  Future<void> _pickImage(BuildContext context) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery, // Try ImageSource.camera if needed
        maxWidth: 800, // Reduce size if necessary
        maxHeight: 800,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        onImageSelected(File(pickedFile.path));
      } else {
        print("No image selected");
      }
    } catch (e) {
      print("Error picking image: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await _pickImage(context);
      },
      child: DottedBorder(
        borderType: BorderType.RRect,
        radius: Radius.circular(12),
        dashPattern: [6, 3],
        strokeWidth: 2,
        color: Colors.grey.shade400,
        child: SizedBox(
          height: 80,
          width: 80,
          child: Center(
            child: Icon(
              size: 40,
              Icons.add_photo_alternate_outlined,
              color: Colors.grey.shade400,
            ),
          ),
        ),
      ),
    );
  }
}
