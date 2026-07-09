import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:majestic_rooms/core/theme/custom_colors.dart';
import 'package:majestic_rooms/core/utils/constants.dart';
import 'package:majestic_rooms/core/utils/helper.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F9),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F7F9),
        surfaceTintColor: const Color(0xFFF7F7F9),
        centerTitle: true,
        title: const Text(
          'About',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        leadingWidth: 70,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.maybePop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24.0),
        children: [
          // APP LOGO / INFO
          Column(
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: CustomColors.surfaceWhite,
                  shape: BoxShape.circle,
                  border: Border.all(color: CustomColors.borderColor),
                ),
                child: const Icon(
                  Icons.hotel_rounded,
                  size: 50,
                  color: CustomColors.brandRed,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                Constants.appName,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: CustomColors.textMain,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Version ${Constants.appVersion}',
                style: TextStyle(
                  fontSize: 14,
                  color: CustomColors.textMuted,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),

          // APP DESCRIPTION
          const Text(
            'Majestic Rooms is your premium destination for finding and booking the perfect stay. We combine luxury, comfort, and seamless experiences to make your travels unforgettable. Designed with modern aesthetics and a focus on user experience.',
            style: TextStyle(
              fontSize: 15,
              color: CustomColors.textMuted,
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),

          // LINKS SECTION
          Material(
            color: CustomColors.surfaceWhite,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(16.0)),
              side: BorderSide(color: CustomColors.borderColor),
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.description_outlined, color: CustomColors.textMain),
                  title: const Text(
                    'Terms of Service',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: CustomColors.textMain),
                  ),
                  trailing: const Icon(Icons.chevron_right, color: CustomColors.textMuted),
                  onTap: () {
                    // Placeholder for future TOS link
                  },
                ),
                const Divider(height: 1, indent: 56, color: CustomColors.borderColor),
                ListTile(
                  leading: const Icon(Icons.privacy_tip_outlined, color: CustomColors.textMain),
                  title: const Text(
                    'Privacy Policy',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: CustomColors.textMain),
                  ),
                  trailing: const Icon(Icons.chevron_right, color: CustomColors.textMuted),
                  onTap: () {
                    // Placeholder for future Privacy Policy link
                  },
                ),
                const Divider(height: 1, indent: 56, color: CustomColors.borderColor),
                ListTile(
                  leading: const Icon(Icons.email_outlined, color: CustomColors.textMain),
                  title: const Text(
                    'Contact Us',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: CustomColors.textMain),
                  ),
                  trailing: const Icon(Icons.chevron_right, color: CustomColors.textMuted),
                  onTap: () => Utils.launchEmail(Constants.email),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // COPYRIGHT
          const Center(
            child: Text(
              '© 2026 Majestic Rooms. All rights reserved.',
              style: TextStyle(
                fontSize: 12,
                color: CustomColors.textMuted,
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
