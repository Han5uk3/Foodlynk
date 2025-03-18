import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:saver_bbk_main/common_widget/button.dart';
import 'package:saver_bbk_main/common_widget/dropdown.dart';
import 'package:saver_bbk_main/common_widget/label.dart';
import 'package:saver_bbk_main/common_widget/saver_appbar.dart';
import 'package:saver_bbk_main/common_widget/text_field.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key, required this.isEdit});
  final bool isEdit;
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
  final TextEditingController _dobController = TextEditingController();

  final List<String> titles = ['Mr.', 'Mrs.', 'Ms.', 'Dr.', 'Prof.'];
  final List<String> genders = ['Male', 'Female', 'Other'];
  final List<String> countries = ['UAE', 'USA', 'UK', 'Canada', 'India'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: saverAppBar(
        widget.isEdit ? "My Profile" : "Create Profile",
        context,
        isneedtopop: true,
      ),
      body: SingleChildScrollView(
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
                      controller: TextEditingController(),
                      hintText: 'Enter First Name',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Label(text: 'Last Name'),
              const SizedBox(height: 8),
              SaverTextField(
                controller: TextEditingController(),
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
                          controller: _dobController,
                          readOnly: true,
                          decoration: InputDecoration(
                            hintText: 'DD/MM/YYYY',
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
                              initialDate: DateTime.now(),
                              firstDate: DateTime(1900),
                              lastDate: DateTime.now(),
                            );
                            if (picked != null) {
                              setState(() {
                                selectedDate = picked;
                                _dobController.text = DateFormat(
                                  'dd/MM/yyyy',
                                ).format(picked);
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
                controller: TextEditingController(),
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
                          items: ['Dubai', 'Abu Dhabi', 'Sharjah', 'Ajman'],
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
                          items: ['Dubai', 'Abu Dhabi', 'Sharjah', 'Ajman'],
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
                          controller: TextEditingController(),
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
                items: ['Emirati', 'American', 'British', 'Indian', 'Canadian'],
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
                controller: TextEditingController(),
              ),
              const SizedBox(height: 24),

              SaverButton(
                text: widget.isEdit ? "Save Changes" : 'Create Profile',
                onPressed: () {},
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}
