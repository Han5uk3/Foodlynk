import 'package:flutter/material.dart';
import 'package:saver_bbk_main/common_widget/saver_appbar.dart';

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
              color: Colors.blue.shade50,
              iconColor: Colors.blue.shade900,
            ),

            _buildProfileTile(
              label: "Password",
              icon: Icons.key_outlined,
              color: Colors.purple.shade50,
              iconColor: Colors.purple.shade600,
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
                _showDeleteBottomSheet(context);
              },
            ),

            _buildProfileTile(
              label: "Logout",
              icon: Icons.person_2_outlined,
              color: const Color.fromARGB(91, 255, 157, 190),
              iconColor: Colors.pink.shade600,
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
              borderRadius: BorderRadius.circular(15),
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

  _showDeleteBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            spacing: 15,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10),
              Text(
                "Delete Profile",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Divider(height: 0.5, thickness: 0.5, color: Colors.grey.shade500),
            ],
          ),
        );
      },
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      backgroundColor: Colors.white,
      isScrollControlled: true,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.35,
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      barrierColor: Colors.black26,
      barrierLabel: '',
      enableDrag: false,
      isDismissible: true,
      useRootNavigator: true,
      useSafeArea: true,
    );
  }
}
