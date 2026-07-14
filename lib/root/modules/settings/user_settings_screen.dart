import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:majestic_rooms/core/base/common_controller.dart';
import 'package:majestic_rooms/core/theme/theme_context_extension.dart';
import 'package:majestic_rooms/root/modules/settings/user_controller.dart';
import 'package:majestic_rooms/root/widgets/user_avatar.dart';
import 'package:majestic_rooms/root/modules/settings/update_password_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserSettingsScreen extends StatefulWidget {
  const UserSettingsScreen({super.key});

  @override
  State<UserSettingsScreen> createState() => _UserSettingsScreenState();
}

class _UserSettingsScreenState extends State<UserSettingsScreen> {
  final UserController _userController = Get.put(UserController());
  final CommonController _commonController = Get.find<CommonController>();

  void _showEditDialog(
    String title,
    String initialValue,
    Function(String) onSave, {
    bool isPassword = false,
  }) {
    final TextEditingController textController = TextEditingController(
      text: isPassword ? '' : initialValue,
    );
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: context.surfaceColor,
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            'Update @title'.trParams({'title': title.tr}),
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          content: TextField(
            controller: textController,
            obscureText: isPassword,
            decoration: InputDecoration(
              hintText: 'Enter new @title'.trParams({'title': title.tr}),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: context.primaryColor),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel'.tr,
                style: TextStyle(color: context.textMutedColor),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                onSave(textController.text);
              },
              child: Text(
                'Save'.tr,
                style: TextStyle(
                  color: context.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F9),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F7F9),
        surfaceTintColor: const Color(0xFFF7F7F9),
        centerTitle: true,
        title: Text(
          'User Settings'.tr,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        leadingWidth: 70,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.maybePop(context),
        ),
      ),
      body: Obx(() {
        final User? user = _commonController.currentUser.value;
        final String? avatarUrl = user?.userMetadata?['avatar_url'] as String?;
        final String fullName =
            user?.userMetadata?['full_name'] as String? ?? '';
        final String email = user?.email ?? '';
        // In real app, we'd fetch public_data here. Since currentUser is auth.User, we don't have public_data sync.
        // We will just show "Update phone" placeholder.

        return Stack(
          children: [
            ListView(
              padding: const EdgeInsets.all(24.0),
              children: [
                Center(
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      UserAvatar(
                        heroTag: 'profile_avatar',
                        imageUrl: avatarUrl,
                        size: 100,
                      ),
                      GestureDetector(
                        onTap: () => _userController.updateProfilePhoto(),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: context.primaryColor,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: context.surfaceColor,
                              width: 3,
                            ),
                          ),
                          child: const Icon(
                            Icons.camera_alt_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                Text(
                  'Personal Information'.tr,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: context.textMainColor,
                  ),
                ),
                const SizedBox(height: 16),
                Material(
                  color: context.surfaceColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(16.0)),
                    side: BorderSide(color: context.borderColor),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    children: [
                      _SettingsTile(
                        icon: Icons.person_outline,
                        title: 'Full Name'.tr,
                        value: fullName.isEmpty ? 'Set name'.tr : fullName,
                        onTap: () => _showEditDialog(
                          'Name',
                          fullName,
                          (val) => _userController.updateName(val),
                        ),
                      ),
                      Divider(
                        height: 1,
                        indent: 56,
                        color: context.borderColor,
                      ),
                      _SettingsTile(
                        icon: Icons.email_outlined,
                        title: 'Email'.tr,
                        value: email.isEmpty ? 'Set email'.tr : email,
                        onTap: () => _showEditDialog(
                          'Email',
                          email,
                          (val) => _userController.updateEmail(val),
                        ),
                      ),
                      Divider(
                        height: 1,
                        indent: 56,
                        color: context.borderColor,
                      ),
                      _SettingsTile(
                        icon: Icons.phone_outlined,
                        title: 'Phone Number'.tr,
                        value: 'Update phone'.tr,
                        onTap: () => _showEditDialog(
                          'Phone',
                          '',
                          (val) => _userController.updatePhone(val),
                        ),
                      ),
                      Divider(
                        height: 1,
                        indent: 56,
                        color: context.borderColor,
                      ),
                      _SettingsTile(
                        icon: Icons.lock_outline,
                        title: 'Password'.tr,
                        value: '••••••••',
                        onTap: () => Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (_) => const UpdatePasswordScreen(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                Material(
                  color: context.surfaceColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(16.0)),
                    side: BorderSide(color: context.borderColor),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: ListTile(
                    leading: Icon(
                      Icons.delete_outline,
                      color: context.primaryColor,
                    ),
                    title: Text(
                      'Delete Account'.tr,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: context.primaryColor,
                      ),
                    ),
                    onTap: _userController.deleteAccount,
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
            if (_userController.isLoading.value)
              Container(
                color: Colors.black.withValues(alpha: 0.3),
                child: Center(
                  child: CircularProgressIndicator(color: context.primaryColor),
                ),
              ),
          ],
        );
      }),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final VoidCallback onTap;

  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: context.textMainColor),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: context.textMainColor,
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: TextStyle(fontSize: 14, color: context.textMutedColor),
          ),
          const SizedBox(width: 8),
          Icon(Icons.chevron_right, color: context.textMutedColor),
        ],
      ),
      onTap: onTap,
    );
  }
}
