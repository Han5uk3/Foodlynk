import 'package:flutter/material.dart';
import 'package:saver_bbk_main/common_widget/button.dart';
import 'package:saver_bbk_main/common_widget/outline_button.dart';
import 'package:saver_bbk_main/common_widget/saver_appbar.dart';
import 'package:saver_bbk_main/styles/colors.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: saverAppBar('Profile', context),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            _buildProfileTile(
              label: "My Profile",
              icon: Icons.person_2_outlined,
              color: AppColor.lightblue,
              iconColor: AppColor.blue,
            ),

            _buildProfileTile(
              label: "Password",
              icon: Icons.key_outlined,
              color: AppColor.lightPurple,
              iconColor: AppColor.purple,
            ),

            _buildProfileTile(
              label: "Terms & Conditions",
              icon: Icons.insert_drive_file_outlined,
              color: Colors.green.shade50,
              iconColor: Colors.green.shade600,
            ),

            _buildProfileTile(
              label: "Delete Profile",
              icon: Icons.person_2_outlined,
              color: Colors.red.shade50,
              iconColor: Colors.red.shade600,
              onTap: () {
                _showDeleteBottomSheet(context, true);
              },
            ),

            _buildProfileTile(
              label: "Logout",
              icon: Icons.person_2_outlined,
              color: AppColor.lightPink,
              iconColor: AppColor.pink,
              onTap: () {
                _showDeleteBottomSheet(context, false);
              },
            ),
          ],
        ),
      ),
    );
  }

  _buildProfileTile({
    VoidCallback? onTap,
    required Color iconColor,
    required Color color,
    required IconData icon,
    required String label,
  }) {
    return Column(
      children: [
        ListTile(
          minTileHeight: 85,
          onTap: onTap,
          leading: Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: iconColor),
          ),
          title: Text(label, style: TextStyle(fontSize: 16)),
          trailing: Icon(Icons.chevron_right, size: 35),
        ),

        Divider(height: 0.5, thickness: 0.5, color: Colors.grey.shade500),
      ],
    );
  }

  _showDeleteBottomSheet(BuildContext context, bool toggler) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          spacing: 15,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                toggler ? "Delete Profile" : "Logout",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Divider(height: 0.5, thickness: 0.5, color: Colors.grey.shade500),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                height: toggler ? 40 : 40,
                child: Text(
                  toggler
                      ? "Are you sure you want to delete your profile with Saver?"
                      : "Are you sure you want to logout?",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
            SizedBox(height: 5),
            Divider(height: 0.5, thickness: 0.5, color: Colors.grey.shade500),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 3),
              child: Row(
                spacing: 10,
                children: [
                  Expanded(
                    child: SaverOutlineButton(
                      text: "Cancel",
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      borderColor: AppColor.red,
                      textColor: AppColor.red,
                    ),
                  ),
                  Expanded(
                    child: SaverButton(
                      text: toggler ? "Delete Profile" : "Logout",
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      color: AppColor.red,
                      textColor: AppColor.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      backgroundColor: AppColor.white,
      // isScrollControlled: true,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.25,
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      barrierColor: Colors.black26,
      barrierLabel: '',
      isDismissible: false,
      useRootNavigator: true,
    );
  }
}
