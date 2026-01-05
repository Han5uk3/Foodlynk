import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saver_bbk_main/common_widget/button.dart';
import 'package:saver_bbk_main/common_widget/outline_button.dart';
import 'package:saver_bbk_main/common_widget/saver_appbar.dart';
import 'package:saver_bbk_main/common_widget/snakbar.dart';
import 'package:saver_bbk_main/common_widget/svgicon.dart';
import 'package:saver_bbk_main/helpers/hive_helper.dart';
import 'package:saver_bbk_main/modules/community/bloc/community_bloc.dart';
import 'package:saver_bbk_main/modules/login/login.dart';
import 'package:saver_bbk_main/modules/profile/bloc/profile_bloc.dart';
import 'package:saver_bbk_main/modules/profile/edit_profile.dart';
import 'package:saver_bbk_main/modules/profile/terms_and_conditions_page.dart';
import 'package:saver_bbk_main/styles/colors.dart';
import 'package:saver_bbk_main/l10n/app_localizations.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isLoading = false;
  bool isGuestUser = false;
  @override
  void initState() {
    isGuestUser = HiveHelper.getIsGuest();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: saverAppBar(AppLocalizations.of(context)!.profile, context),
      body: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is LogoutStateSuccess) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => LoginPage()),
                (route) => false,
              );
            });
          }
          if (state is DeleteProfileSuccessState) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => LoginPage()),
                (route) => false,
              );
            });
          }
        },
        builder: (context, state) {
          if (state is LogoutStateLoading) {
            _isLoading = state.isLoading;
          }
          if (state is DeleteProfileLoadingState) {
            _isLoading = state.isLoading;
          }
          return Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              children: [
                _buildProfileTile(
                  label: AppLocalizations.of(context)!.myProfile,
                  path: "assets/icons/Icon.svg",
                  color: AppColor.lightblue,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => EditProfilePage(
                          isEdit: true,
                          email: "",
                          isFromEmailLogin: false,
                        ),
                      ),
                    );
                  },
                ),
                _buildProfileTile(
                  label: AppLocalizations.of(context)!.termsAndConditions,
                  path: "assets/icons/terms.svg",
                  color: Colors.green.shade50,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TermsAndConditionsPage(),
                    ),
                  ),
                ),
                isGuestUser
                    ? SizedBox()
                    : _buildProfileTile(
                        label: AppLocalizations.of(context)!.deleteProfile,
                        path: "assets/icons/deleteaccount.svg",
                        color: Colors.red.shade50,
                        onTap: () {
                          _showDeleteBottomSheet(context, true);
                        },
                      ),
                _buildProfileTile(
                  label: isGuestUser
                      ? AppLocalizations.of(context)!.logIn
                      : AppLocalizations.of(context)!.logout,
                  path: "assets/icons/logout.svg",
                  color: AppColor.lightPink,
                  onTap: () {
                    _showDeleteBottomSheet(context, false);
                  },
                ),
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Version: v1.0.8",
                      style: TextStyle(
                        color: AppColor.lightGrey200,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  _buildProfileTile({
    VoidCallback? onTap,
    required String path,
    required Color color,
    required String label,
  }) {
    return Column(
      children: [
        ListTile(
          minTileHeight: 85,
          onTap: () async {
            if (label == AppLocalizations.of(context)!.logIn) {
              await HiveHelper.putisGuest(false);
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
                (_) => false,
              );
            } else if (label ==
                AppLocalizations.of(context)!.termsAndConditions) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TermsAndConditionsPage(),
                ),
              );
            } else if (isGuestUser) {
              SaverSnackBar.show(
                context: context,
                message: "Create an account first",
                isTrue: false,
              );
            } else {
              onTap?.call();
            }
          },
          leading: Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: SizedBox(height: 20, width: 20, child: loadsvg(path)),
            ),
          ),
          title: Text(label, style: TextStyle(fontSize: 16)),
          trailing: Icon(Icons.chevron_right, size: 35),
        ),
        Divider(height: 1, thickness: 0.5, color: Colors.grey.shade500),
      ],
    );
  }

  _showDeleteBottomSheet(BuildContext context, bool toggler) {
    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      builder: (context) {
        return Column(
          spacing: 15,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                toggler
                    ? AppLocalizations.of(context)!.deleteProfile
                    : AppLocalizations.of(context)!.logout,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Divider(height: 1, thickness: 0.5, color: Colors.grey.shade500),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                height: toggler ? 40 : 40,
                child: Text(
                  toggler
                      ? AppLocalizations.of(
                          context,
                        )!
                          .areYouSureYouWantToDeleteYourProfile
                      : AppLocalizations.of(context)!.areYouSureYouWantToLogout,
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
                      text: AppLocalizations.of(context)!.cancel,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      borderColor: AppColor.red,
                      textColor: AppColor.red,
                    ),
                  ),
                  Expanded(
                    child: SaverButton(
                      text: toggler
                          ? AppLocalizations.of(context)!.deleteProfile
                          : AppLocalizations.of(context)!.logout,
                      onPressed: _isLoading
                          ? () {} // Disable button during loading
                          : () {
                              setState(() {
                                _isLoading = true;
                              });
                              if (toggler) {
                                context.read<ProfileBloc>().add(
                                      DeleteProfileEvent(),
                                    );
                              } else {
                                context.read<ProfileBloc>().add(
                                      LogoutEvent(
                                        communityBloc:
                                            context.read<CommunityBloc>(),
                                      ),
                                    );
                              }
                            },
                      color: AppColor.red,
                      textColor: AppColor.white,
                      isLoading: _isLoading,
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
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      backgroundColor: AppColor.white,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.34,
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      barrierColor: Colors.black26,
      isDismissible: false,
      enableDrag: false,
      useRootNavigator: true,
    );
  }
}
