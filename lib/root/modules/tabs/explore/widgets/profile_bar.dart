import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:majestic_rooms/core/base/common_controller.dart';
import 'package:majestic_rooms/core/theme/custom_colors.dart';
import 'package:majestic_rooms/root/modules/home/home_controller.dart';
import 'package:majestic_rooms/root/modules/tabs/profile/profile_avatar_flight_controller.dart';
import 'package:majestic_rooms/root/widgets/user_avatar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileBar extends StatelessWidget {
  final VoidCallback? onNotificationsTap;

  const ProfileBar({super.key, this.onNotificationsTap});

  static const double _size = 42;

  ProfileAvatarFlightController get flight {
    if (!Get.isRegistered<ProfileAvatarFlightController>()) {
      Get.put(ProfileAvatarFlightController(), permanent: true);
    }
    return Get.find<ProfileAvatarFlightController>();
  }

  @override
  Widget build(BuildContext context) {
    final CommonController commonController = Get.find<CommonController>();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [

        // PROFILE
        Obx(() {
          final User? user        = commonController.currentUser.value;
          final String? avatarUrl = user?.userMetadata?['avatar_url'] as String?;
          final bool isFlying     = flight.isFlying.value;

          return Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(100),
            child: InkWell(
              borderRadius: BorderRadius.circular(100),
              onTap: () => flight.flyToProfile(context, avatarUrl),
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Row(
                  spacing: 12,
                  children: [
                    Opacity(
                      opacity: isFlying ? 0 : 1,
                      child: UserAvatar(key: flight.barAvatarKey, imageUrl: avatarUrl, size: _size),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Welcome back  ', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: CustomColors.textMuted, height: 1.2)),
                        Text('John Doe', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: CustomColors.brandBlack, fontWeight: FontWeight.w700, height: 1.2)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        }),

        IconButton(
          style: IconButton.styleFrom(
            backgroundColor: CustomColors.surfaceWhite,
            padding: EdgeInsets.zero,
            iconSize: 25,
          ),
          onPressed: onNotificationsTap,
          icon: Icon(
            Icons.notifications_outlined,
            color: CustomColors.textMuted,
            size: 22,
          ),
        )
      ],
    );
  }
}