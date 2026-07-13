import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:majestic_rooms/core/base/common_controller.dart';
import 'package:majestic_rooms/core/theme/custom_colors.dart';
import 'package:majestic_rooms/core/utils/constants.dart';
import 'package:majestic_rooms/core/utils/helper.dart';
import 'package:majestic_rooms/root/modules/home/home_controller.dart';
import 'package:majestic_rooms/root/modules/tabs/profile/profile_avatar_flight_controller.dart';
import 'package:majestic_rooms/root/modules/settings/settings_screen.dart';
import 'package:majestic_rooms/root/modules/settings/user_settings_screen.dart';
import 'package:majestic_rooms/root/modules/settings/about/about_screen.dart';
import 'package:majestic_rooms/root/widgets/user_avatar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/cupertino.dart';

// Promoted to file scope so both ProfileScreen and _Tile can reference it.
const TextStyle _mutedStyle = TextStyle(fontSize: 14, color: CustomColors.textMuted);

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with SingleTickerProviderStateMixin {
  // ── Control Panel ───────────────────────────────────────────────────────────

  static const double _avatarSize    = 120.0; // used 8× across fallback/network/error/loader
  static const double _dividerIndent = 56.0;  // used 4× across both groups

  static const Icon _fallbackAvatarIcon = Icon(Icons.person, size: 60, color: Colors.grey); // 2×

  // Applied to both group containers.
  static const ShapeBorder _groupShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(16.0)),
    side: BorderSide(color: CustomColors.borderColor),
  );

  // Avatar entrance animation config.
  static const Duration _avatarAnimDuration = Duration(milliseconds: 450);
  static const double   _avatarAnimStartScale = 0.35;

  // ── State ──────────────────────────────────────────────────────────────────

  late final AnimationController _avatarAnim;
  late final Animation<double>  _avatarScale;
  late final Animation<double>  _avatarOpacity;
  late final Worker             _tabListener;
  final GlobalKey               _avatarKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    flight.screenAvatarKey = _avatarKey;
    _avatarAnim = AnimationController(vsync: this, duration: _avatarAnimDuration);
    _avatarScale = Tween<double>(begin: _avatarAnimStartScale, end: 1.0).animate(
      CurvedAnimation(parent: _avatarAnim, curve: Curves.easeOutBack),
    );
    _avatarOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _avatarAnim, curve: const Interval(0.0, 0.6)),
    );

    final homeController = Get.find<HomeController>();
    if (homeController.currentIndex.value == 3) _avatarAnim.forward();
    _tabListener = ever(homeController.currentIndex, (index) {
      if (index != 3) return;
      if (flight.isFlying.value) {
        _avatarAnim.value = 1.0; // skip the entrance pop — the flight itself is the entrance
      } else {
        _avatarAnim.forward(from: 0.0);
      }
    });
  }

  ProfileAvatarFlightController get flight {
    if (!Get.isRegistered<ProfileAvatarFlightController>()) {
      Get.put(ProfileAvatarFlightController(), permanent: true);
    }
    return Get.find<ProfileAvatarFlightController>();
  }

  @override
  void dispose() {
    _tabListener.dispose();
    _avatarAnim.dispose();
    super.dispose();
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final CommonController commonController = Get.find<CommonController>();
    final HomeController homeController    = Get.find<HomeController>();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // USER IDENTIFICATION
          Obx(() {
            final User? user        = commonController.currentUser.value;
            final String? avatarUrl = user?.userMetadata?['avatar_url'] as String?;
            final String? fullName  = user?.userMetadata?['full_name'] as String?;
            final String? email     = user?.email;
            final bool isFlying = flight.isFlying.value;

            return Column(
              children: [
                // AVATAR
                Opacity(
                  opacity: isFlying ? 0 : 1,
                  child: GestureDetector(
                    onTap: () => Navigator.push(context, CupertinoPageRoute(builder: (_) => const UserSettingsScreen())),
                    child: UserAvatar(key: _avatarKey, imageUrl: avatarUrl, size: _avatarSize, heroTag: 'profile_avatar'),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  fullName ?? "User",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: CustomColors.textMain,
                  ),
                ),
                const SizedBox(height: 4),
                Text(email ?? "user@email.com", style: _mutedStyle),
              ],
            );
          }),
          const SizedBox(height: 32),

          // ACCOUNT SETTINGS
          Material(
            color: CustomColors.surfaceWhite,
            shape: _groupShape,
            clipBehavior: Clip.antiAlias,
            child: _Tile(
              icon: Icons.person_outline,
              title: 'User Settings'.tr,
              onTap: () => Navigator.push(context, CupertinoPageRoute(builder: (_) => const UserSettingsScreen())),
            ),
          ),
          const SizedBox(height: 24),

          // BOOKINGS & TRAVEL
          Material(
            color: CustomColors.surfaceWhite,
            shape: _groupShape,
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                _Tile(
                  icon: Icons.bookmark_border,
                  title: 'My Bookings'.tr,
                  onTap: () => homeController.navigateTo(2),
                ),
                const Divider(height: 1, indent: _dividerIndent, color: CustomColors.borderColor),
                _Tile(
                  icon: Icons.favorite_border,
                  title: 'Saved Hotels'.tr,
                  onTap: () => homeController.navigateTo(1),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // HELP & SUPPORT
          Material(
            color: CustomColors.surfaceWhite,
            shape: _groupShape,
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                _Tile(
                  icon: Icons.email_outlined,
                  title: 'Contact Support'.tr,
                  subtitle: Constants.email,
                  onTap: () => Utils.launchEmail(Constants.email),
                ),
                const Divider(height: 1, indent: _dividerIndent, color: CustomColors.borderColor),
                _Tile(
                  icon: Icons.phone_outlined,
                  title: 'Helpline'.tr,
                  subtitle: '\u200E${Constants.phone}',
                  onTap: () => Utils.launchPhone(Constants.phone),
                ),
                const Divider(height: 1, indent: _dividerIndent, color: CustomColors.borderColor),
                _Tile(
                  icon: Icons.info_outline,
                  title: 'About'.tr,
                  onTap: () => Navigator.push(context, CupertinoPageRoute(builder: (_) => const AboutScreen())),
                ),
                const Divider(height: 1, indent: _dividerIndent, color: CustomColors.borderColor),
                _Tile(
                  icon: Icons.settings_outlined,
                  title: 'Settings'.tr,
                  onTap: () => Navigator.push(context, CupertinoPageRoute(builder: (_) => const SettingsScreen())),
                ),
                const Divider(height: 1, indent: _dividerIndent, color: CustomColors.borderColor),
                _Tile(
                  icon: Icons.logout,
                  title: 'Log Out'.tr,
                  iconColor: CustomColors.brandRed,
                  titleColor: CustomColors.brandRed,
                  trailing: const SizedBox.shrink(),
                  onTap: Utils.logoutDialog,
                ),
              ],

            ),
          ),
          const SizedBox(height: 32),
          const Center(
            child: Text(
              '${Constants.appName} - ${Constants.appVersion}',
              style: TextStyle(
                fontSize: 12,
                color: CustomColors.textMuted,
              ),
            ),
          ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }
}

// ── _Tile ──────────────────────────────────────────────────────────────────────

/// Private tile widget shared across both profile groups.
/// Defaults to amber leading icon and a chevron trailing.
class _Tile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget trailing;
  final Color iconColor;
  final Color? titleColor;
  final VoidCallback? onTap;

  const _Tile({
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing = const Icon(Icons.chevron_right, color: CustomColors.textMuted),
    this.iconColor = CustomColors.textMain,
    this.titleColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: iconColor),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: titleColor ?? CustomColors.textMain,
        ),
      ),
      subtitle: subtitle != null ? Text(subtitle!, style: _mutedStyle) : null,
      trailing: trailing,
      onTap: onTap,
    );
  }
}
