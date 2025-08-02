import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:saver_bbk_main/common_widget/button.dart';
import 'package:saver_bbk_main/common_widget/dropdown.dart';
import 'package:saver_bbk_main/common_widget/label.dart';
import 'package:saver_bbk_main/common_widget/loader.dart';
import 'package:saver_bbk_main/common_widget/saver_appbar.dart';
import 'package:saver_bbk_main/common_widget/snakbar.dart';
import 'package:saver_bbk_main/common_widget/text_field.dart';
import 'package:saver_bbk_main/helpers/hive_helper.dart';
import 'package:saver_bbk_main/models/users_model.dart';
import 'package:saver_bbk_main/modules/home/home.dart';
import 'package:saver_bbk_main/modules/profile/bloc/profile_bloc.dart';
import 'package:saver_bbk_main/services/app_services.dart';
import 'package:path/path.dart' as path;
import 'package:saver_bbk_main/services/storage_services.dart';
import 'package:saver_bbk_main/l10n/app_localizations.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({
    super.key,
    required this.isEdit,
    this.phoneNumber,
    this.email,
    this.password,
    required this.isFromEmailLogin,
  });
  final bool isEdit;
  final String? phoneNumber;
  final String? email;
  final String? password;
  final bool isFromEmailLogin;
  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  String? selectedTitle;
  String? selectedGender;
  DateTime? selectedDate;
  String formattedDate = '';
  bool _isLoading = false;
  bool _isDataLoaded = false;
  File? _imageFile;
  String? _profileImageUrl;
  bool _isUploadingImage = false;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _zipCodeController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final List<String> titles = ['Mr.', 'Mrs.', 'Ms.', 'Dr.', 'Prof.'];
  final List<String> genders = ['Male', 'Female', 'Other'];
  final currentLocale = HiveHelper().getUserlanguage();
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    if (widget.isEdit) {
      _fetchUserProfile();
    }
    if (widget.email != "") {
      _emailController.text = widget.email ?? "";
    }

    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _lastNameController.dispose();
    _addressController.dispose();
    _zipCodeController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _fetchUserProfile() async {
    try {
      final uid = Services.uid ?? "";
      if (uid == null) {
        debugPrint('No user is logged in.');
        return;
      }

      log(uid);

      final docSnapshot =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();

      if (docSnapshot.exists) {
        final data = docSnapshot.data();
        if (data != null) {
          final user = UserModel.fromJson(data);
          _populateFields(user);
        } else {
          debugPrint('User data is null');
        }
      } else {
        debugPrint('No user document found');
      }
    } catch (e) {
      debugPrint('Error fetching user profile: $e');
    }
  }

  void _populateFields(UserModel user) {
    if (_isDataLoaded) return;
    setState(() {
      _isDataLoaded = true;
      selectedTitle = user.title?.isNotEmpty == true ? user.title : null;
      selectedGender = user.gender?.isNotEmpty == true ? user.gender : null;
      selectedDate = (user.dob as Timestamp).toDate();
      if (selectedDate != null) {
        formattedDate = DateFormat('dd-MM-yyyy').format(selectedDate!);
      }
      _nameController.text = user.firstName ?? '';
      _lastNameController.text = user.lastName ?? '';
      _addressController.text = user.address ?? '';
      _zipCodeController.text = user.zipCode ?? '';
      _emailController.text = user.email ?? '';
      _profileImageUrl = user.profileImage;
    });
  }

  Future<void> _selectImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 80,
      );

      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
        });
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error picking image: $e');
      }
      SaverSnackBar.show(
        context: context,
        message: "Failed to select image",
        isTrue: false,
      );
    }
  }

  Future<String?> _uploadProfileImage() async {
    if (_imageFile == null) return _profileImageUrl;

    setState(() {
      _isUploadingImage = true;
    });

    try {
      final String fileName =
          '${HiveHelper.getUID()}_${DateTime.now().millisecondsSinceEpoch}${path.extension(_imageFile!.path)}';

      final String uploadedUrl = await StorageService.uploadFile(
        mainPath: 'profile_images',
        filePath: _imageFile!.path,
        fileName: fileName,
      );

      if (uploadedUrl.isNotEmpty) {
        return uploadedUrl;
      } else {
        throw Exception('Failed to upload image');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error uploading profile image: $e');
      }
      SaverSnackBar.show(
        context: context,
        message: "Failed to upload profile image",
        isTrue: false,
      );
      return _profileImageUrl;
    } finally {
      setState(() {
        _isUploadingImage = false;
      });
    }
  }

  void _showImagePickerModal() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Gallery'),
                onTap: () {
                  Navigator.of(context).pop();
                  _selectImage(ImageSource.gallery);
                },
              ),
              if (_profileImageUrl != null || _imageFile != null)
                ListTile(
                  leading: const Icon(Icons.delete, color: Colors.red),
                  title: const Text(
                    'Remove Photo',
                    style: TextStyle(color: Colors.red),
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    setState(() {
                      _imageFile = null;
                      _profileImageUrl = null;
                    });
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProfileImage() {
    if (_imageFile != null) {
      return CircleAvatar(radius: 60, backgroundImage: FileImage(_imageFile!));
    } else if (_profileImageUrl != null && _profileImageUrl!.isNotEmpty) {
      return CircleAvatar(
        radius: 60,
        backgroundImage: NetworkImage(_profileImageUrl!),
        onBackgroundImageError: (exception, stackTrace) {
          if (kDebugMode) {
            print('Error loading image: $exception');
          }
        },
      );
    } else {
      return Container(
        width: 120,
        height: 120,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          shape: BoxShape.circle,
        ),
        child: Icon(Icons.person_outline, size: 60, color: Colors.grey[400]),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: saverAppBar(
        widget.isEdit
            ? AppLocalizations.of(context)!.myProfile
            : AppLocalizations.of(context)!.createProfile,
        context,
        isneedtopop: widget.isEdit,
      ),
      body: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is CreateProfileSuccessState) {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => MainScreen(currentIndex: 0),
              ),
              (route) => false,
            );
          }

          if (state is EditProfileSuccessState) {
            Navigator.of(context).pop();
            SaverSnackBar.show(
              context: context,
              message: AppLocalizations.of(context)!.profileUpdated,
              isTrue: true,
            );
          }

          if (state is CreateProfileErrorState) {
            setState(() {
              _isLoading = false;
            });
            SaverSnackBar.show(
              context: context,
              message: state.errorMessage,
              isTrue: false,
            );
          }

          if (state is CreateProfileLoadingState) {
            setState(() {
              _isLoading = state.isLoading;
            });
          } else if (state is EditProfileLoadingState) {
            setState(() {
              _isLoading = state.isLoading;
            });
          }
        },
        builder: (context, state) {
          if (widget.isEdit && !_isDataLoaded) {
            return SaverLoader();
          }

          return _buildProfileForm();
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SaverButton(
          text: widget.isEdit
              ? AppLocalizations.of(context)!.saveChanges
              : AppLocalizations.of(context)!.createProfile,
          isLoading: _isLoading || _isUploadingImage,
          onPressed: _isUploadingImage
              ? () {}
              : () async {
                  final String? imageUrl = await _uploadProfileImage();

                  final userModel = UserModel(
                    uid: HiveHelper.getUID(),
                    gender: selectedGender,
                    title: selectedTitle ?? "",
                    firstName: _nameController.text,
                    lastName: _lastNameController.text,
                    phoneNumber: widget.phoneNumber ?? "",
                    address: _addressController.text,
                    zipCode: _zipCodeController.text,
                    email: _emailController.text,
                    dob: Timestamp.fromDate(selectedDate ?? DateTime.now()),
                    profileImage: imageUrl,
                    createdAt: DateTime.now(),
                  );

                  if (widget.isEdit) {
                    context.read<ProfileBloc>().add(
                          EditProfileEvent(
                            userModel: userModel,
                            preserveLocale: true,
                            locale: HiveHelper().getUserlanguage(),
                          ),
                        );

                    context.read<ProfileBloc>().add(
                          ChangeLocale(
                            languageCode: HiveHelper().getUserlanguage(),
                          ),
                        );
                  } else {
                    context.read<ProfileBloc>().add(
                          CreateProfileEvent(
                            userModel: userModel,
                            password: widget.password ?? "",
                            isEmailLogin: widget.isFromEmailLogin,
                          ),
                        );
                  }
                },
        ),
      ),
    );
  }

  Widget _buildProfileForm() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Stack(
                  children: [
                    _buildProfileImage(),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: _showImagePickerModal,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            border: Border.all(color: Colors.white, width: 2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.camera_alt,
                            size: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Label(text: AppLocalizations.of(context)!.firstName),
              const SizedBox(height: 8),
              Row(
                children: [
                  SizedBox(
                    width: 100,
                    child: SaverDropdown(
                      hint: "Mr.",
                      items: titles,
                      onChanged: (value) {
                        setState(() {
                          selectedTitle = value;
                        });
                      },
                      selectedItem: selectedTitle ?? "",
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: SaverTextField(
                      controller: _nameController,
                      hintText: AppLocalizations.of(context)!.enterFirstName,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Label(text: AppLocalizations.of(context)!.lastName),
              const SizedBox(height: 8),
              SaverTextField(
                controller: _lastNameController,
                hintText: AppLocalizations.of(context)!.enterLastName,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Label(text: AppLocalizations.of(context)!.gender),
                        const SizedBox(height: 8),
                        SaverDropdown(
                          hint: AppLocalizations.of(context)!.male,
                          items: genders,
                          onChanged: (value) {
                            setState(() {
                              selectedGender = value;
                            });
                          },
                          selectedItem: selectedGender ?? "",
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.dob,
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          readOnly: true,
                          decoration: InputDecoration(
                            hintText: formattedDate.isEmpty
                                ? 'DD/MM/YYYY'
                                : formattedDate,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 16,
                            ),
                            suffixIcon: const Icon(Icons.calendar_today),
                          ),
                          onTap: () async {
                            final DateTime? picked = await showDatePicker(
                              context: context,
                              initialDate: selectedDate ?? DateTime.now(),
                              firstDate: DateTime(1900),
                              lastDate: DateTime.now(),
                            );

                            if (picked != null) {
                              setState(() {
                                selectedDate = picked;
                                formattedDate =
                                    '${picked.day.toString().padLeft(2, '0')}/'
                                    '${picked.month.toString().padLeft(2, '0')}/'
                                    '${picked.year}';
                              });
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Label(text: AppLocalizations.of(context)!.address),
              const SizedBox(height: 8),
              SaverTextField(
                hintText: AppLocalizations.of(context)!.enterAddress,
                controller: _addressController,
              ),
              const SizedBox(height: 16),
              Label(text: AppLocalizations.of(context)!.emailId),
              const SizedBox(height: 8),
              IgnorePointer(
                ignoring: (widget.email != ""),
                child: SaverTextField(
                  hintText: AppLocalizations.of(context)!.enterEmailId,
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                      RegExp(r"[a-zA-Z0-9._%+-@]"),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
