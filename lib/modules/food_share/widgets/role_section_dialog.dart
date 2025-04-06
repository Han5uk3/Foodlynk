import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:saver_bbk_main/common_widget/button.dart';
import 'package:saver_bbk_main/styles/colors.dart';

class RoleSelectionDialog extends StatefulWidget {
  final Function(bool isDonor) onRoleSelected;

  const RoleSelectionDialog({super.key, required this.onRoleSelected});

  @override
  State<RoleSelectionDialog> createState() => _RoleSelectionDialogState();
}

class _RoleSelectionDialogState extends State<RoleSelectionDialog>
    with SingleTickerProviderStateMixin {
  bool _isDonor = true;
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: FadeTransition(
        opacity: _animation,
        child: Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFC9F5FF), Color(0xFF9EE9FA)],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "How would you like to proceed?",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: AppColor.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 25),
                Row(
                  children: [
                    Expanded(
                      child: _buildRoleCard(
                        icon: Icons.volunteer_activism,
                        title: "Donor",
                        description: "Share food with others",
                        isSelected: _isDonor,
                        onTap: () => setState(() => _isDonor = true),
                      ),
                    ),
                    SizedBox(width: 15),
                    Expanded(
                      child: _buildRoleCard(
                        icon: Icons.people_alt_outlined,
                        title: "Beneficiary",
                        description: "Receive available food",
                        isSelected: !_isDonor,
                        onTap: () => setState(() => _isDonor = false),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 25),
                SaverButton(
                  text: "Continue",
                  onPressed: () {
                    final selectedRole = _isDonor;
                    _animationController.reverse().then((_) {
                      Navigator.of(context).pop();
                      Future.microtask(() {
                        widget.onRoleSelected(selectedRole);
                      });
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRoleCard({
    required IconData icon,
    required String title,
    required String description,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: isSelected ? AppColor.white : AppColor.white.withOpacity(0.6),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColor.primaryColor : Colors.transparent,
            width: 2,
          ),
          boxShadow:
              isSelected
                  ? [
                    BoxShadow(
                      color: AppColor.primaryColor.withOpacity(0.3),
                      blurRadius: 8,
                      offset: Offset(0, 3),
                    ),
                  ]
                  : [],
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 40,
              color: isSelected ? AppColor.primaryColor : AppColor.lightGrey200,
            ),
            SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color:
                    isSelected ? AppColor.primaryColor : AppColor.lightGrey200,
              ),
            ),
            SizedBox(height: 5),
            Text(
              description,
              style: TextStyle(fontSize: 12, color: AppColor.lightGrey200),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
