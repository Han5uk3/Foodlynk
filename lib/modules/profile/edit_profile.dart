import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key, required this.isEdit, this.phoneNumber});
  final bool isEdit;
  final String? phoneNumber;
  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  String? selectedTitle;
  String? selectedGender;
  String? selectedCountry;
  String? selectedState;
  String? selectedCity;
  String? selectedNationality;
  DateTime? selectedDate;
  String formattedDate = '';
  bool _isLoading = false;
  bool _isDataLoaded = false;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _zipCodeController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final List<String> titles = ['Mr.', 'Mrs.', 'Ms.', 'Dr.', 'Prof.'];
  final List<String> genders = ['Male', 'Female', 'Other'];
  final List<String> countries = ['UAE', 'USA', 'UK', 'Canada', 'India'];
  final List<String> states = ['Dubai', 'Abu Dhabi', 'Sharjah', 'Ajman'];
  final List<String> cities = ['Dubai', 'Abu Dhabi', 'Sharjah', 'Ajman'];
  final List<String> nationalities = [
    'Emirati',
    'American',
    'British',
    'Indian',
    'Canadian',
  ];

  @override
  void initState() {
    super.initState();

    if (widget.isEdit) {
      _fetchUserProfile();
    }
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
      final snapshot = await Services.getUserProfile().first;

      if (snapshot.docs.isNotEmpty) {
        final userDoc = snapshot.docs.first;
        final userData = userDoc.data();
        final user = userData is UserModel ? userData : UserModel();
        _populateFields(user);
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
      selectedCountry = user.country?.isNotEmpty == true ? user.country : null;
      selectedState = user.state?.isNotEmpty == true ? user.state : null;
      selectedCity = user.city?.isNotEmpty == true ? user.city : null;
      selectedNationality =
          user.nationality?.isNotEmpty == true ? user.nationality : null;
      selectedDate = (user.dob as Timestamp).toDate();
      if (selectedDate != null) {
        formattedDate = DateFormat('dd-MM-yyyy').format(selectedDate!);
      }
      _nameController.text = user.firstName ?? '';
      _lastNameController.text = user.lastName ?? '';
      _addressController.text = user.address ?? '';
      _zipCodeController.text = user.zipCode ?? '';
      _emailController.text = user.email ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: saverAppBar(
        widget.isEdit ? "My Profile" : "Create Profile",
        context,
        isneedtopop: true,
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
              message: "Profile Updated",
              isTrue: true,
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
    );
  }

  Widget _buildProfileForm() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Stack(
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.person_outline,
                      size: 60,
                      color: Colors.grey[400],
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.grey[300]!),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.camera_alt, size: 24),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            Label(text: 'First Name'),

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
                    hintText: 'Enter First Name',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Label(text: 'Last Name'),
            const SizedBox(height: 8),
            SaverTextField(
              controller: _lastNameController,
              hintText: 'Enter Last Name',
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Label(text: 'Gender'),
                      const SizedBox(height: 8),
                      SaverDropdown(
                        hint: "Male",
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
                      const Text(
                        'D.O.B',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        readOnly: true,
                        decoration: InputDecoration(
                          hintText:
                              formattedDate.isEmpty
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

            Label(text: 'Address'),
            const SizedBox(height: 8),
            SaverTextField(
              hintText: 'Enter Address',
              controller: _addressController,
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Label(text: 'Country'),
                      const SizedBox(height: 8),
                      SaverDropdown(
                        hint: "Choose",
                        items: countries,
                        selectedItem: selectedCountry ?? "",
                        onChanged: (value) {
                          setState(() {
                            selectedCountry = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Label(text: 'State'),
                      const SizedBox(height: 8),
                      SaverDropdown(
                        hint: "Choose",
                        items: states,
                        selectedItem: selectedState ?? "",
                        onChanged: (value) {
                          setState(() {
                            selectedState = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Label(text: 'City'),
                      const SizedBox(height: 8),
                      SaverDropdown(
                        hint: "Choose",
                        items: cities,
                        selectedItem: selectedCity ?? "",
                        onChanged: (value) {
                          setState(() {
                            selectedCity = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Label(text: 'Pin Code'),
                      const SizedBox(height: 8),
                      SaverTextField(
                        hintText: 'Enter Pincode',
                        controller: _zipCodeController,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            Label(text: 'Nationality'),
            const SizedBox(height: 8),
            SaverDropdown(
              items: nationalities,
              hint: "Choose",
              selectedItem: selectedNationality ?? "",
              onChanged: (value) {
                setState(() {
                  selectedNationality = value;
                });
              },
            ),

            const SizedBox(height: 16),

            Label(text: 'Email ID'),
            const SizedBox(height: 8),
            SaverTextField(
              hintText: 'Enter Email ID',
              controller: _emailController,
            ),
            const SizedBox(height: 24),
            SaverButton(
              text: widget.isEdit ? "Save Changes" : 'Create Profile',
              isLoading: _isLoading,
              onPressed:
                  widget.isEdit
                      ? () {
                        context.read<ProfileBloc>().add(
                          EditProfileEvent(
                            userModel: UserModel(
                              uid: HiveHelper.getUID(),
                              gender: selectedGender,
                              title: selectedTitle ?? "",
                              firstName: _nameController.text,
                              lastName: _lastNameController.text,
                              phoneNumber: widget.phoneNumber ?? "",
                              address: _addressController.text,
                              country: selectedCountry ?? "",
                              state: selectedState ?? "",
                              city: selectedCity ?? "",
                              zipCode: _zipCodeController.text,
                              nationality: selectedNationality ?? "",
                              email: _emailController.text,
                              dob: Timestamp.fromDate(selectedDate!),
                            ),
                          ),
                        );
                      }
                      : () {
                        if (selectedDate == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please select a date of birth'),
                            ),
                          );
                          return;
                        }

                        context.read<ProfileBloc>().add(
                          CreateProfileEvent(
                            title: selectedTitle ?? "",
                            firstName: _nameController.text,
                            phoneNumber: widget.phoneNumber ?? "",
                            lastName: _lastNameController.text,
                            gender: selectedGender ?? "",
                            dob: Timestamp.fromDate(selectedDate!),
                            address: _addressController.text,
                            country: selectedCountry ?? "",
                            state: selectedState ?? "",
                            city: selectedCity ?? "",
                            zipCode: _zipCodeController.text,
                            nationality: selectedNationality ?? "",
                            email: _emailController.text,
                          ),
                        );
                      },
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
