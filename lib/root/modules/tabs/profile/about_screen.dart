import 'package:flutter/material.dart';
import 'package:majestic_rooms/core/theme/custom_colors.dart';
import 'package:majestic_rooms/core/utils/constants.dart';
import 'package:majestic_rooms/core/utils/helper.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  // ── Control Panel ─────────────────────────────────────────────────────────
  static const _scaffoldBg = Color(0xFFF7F7F9);

  static const _description =
      'We make finding hotels in Saudi Arabia easy. Our platform helps '
      'travelers book great stays, from cozy rooms to luxury hotels, '
      'all across the Kingdom.';

  static const storyTitle = 'Our Story';
  static const storyContent =
      'Started in 2023 by a group of Saudi travel lovers, MajesticRooms '
      'began with a goal to make hotel booking simple. We saw too many '
      'outdated websites and wanted to create one place where people could '
      'find trusted hotels in Saudi Arabia, from Riyadh\'s busy streets to '
      'Jeddah\'s calm beaches. Now, we help thousands of travelers find '
      'their perfect stay.';

  static const missionTitle = 'Our Mission';
  static const missionContent =
      'Our goal is to make hotel booking in Saudi Arabia smooth and reliable. '
      'We want travelers to easily find hotels that match their needs, whether '
      'they\'re visiting Mecca, exploring Al-Ula, or working in Dammam. We '
      'focus on clear information, easy navigation, and supporting local '
      'hotels to share their unique vibe.';

  static const _valuesTitle = 'Our Values';
  static const _values = <(String, String, IconData)>[
    (
      'Trust & Transparency',
      'Honest pricing, clear information, and lasting relationships with guests and hotel partners.',
      Icons.handshake_outlined,
    ),
    (
      'Customer First',
      'Your satisfaction is our priority. Support is available 24/7 for any queries.',
      Icons.support_agent_outlined,
    ),
    (
      'Passion for Travel',
      'We understand the joy of travel and work tirelessly to make every journey memorable.',
      Icons.explore_outlined,
    ),
    (
      'Simplicity',
      'Our platform is intuitive and easy to use, making hotel booking a breeze.',
      Icons.touch_app_outlined,
    ),
    (
      'Security & Privacy',
      'Your data and payment information are protected with industry-leading security measures.',
      Icons.security_outlined,
    ),
    (
      'Local Expertise',
      'Our deep knowledge of Saudi Arabia helps us recommend the best hotels for pilgrims and travelers alike.',
      Icons.location_on_outlined,
    ),
  ];

  static const _licenseLabel = 'Licensed Company';
  static const _licenseNumber = 'Ministry of Tourism — No. 73105591';

  // ── Styles ─────────────────────────────────────────────────────────────────
  static const _tileTitleStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: CustomColors.textMain,
  );

  static const _tileBodyStyle = TextStyle(
    fontSize: 14,
    color: CustomColors.textMuted,
  );

  // ── Handlers ───────────────────────────────────────────────────────────────
  void _onValuesTap(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 16),
        title: const Text(_valuesTitle), 
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              for (final (title, body, icon) in _values) ...[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(icon, color: CustomColors.brandRed, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: CustomColors.textMain,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Padding(
                  padding: const EdgeInsets.only(left: 28.0),
                  child: Text(body),
                ),
                const SizedBox(height: 16),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  // ── Widget helpers ─────────────────────────────────────────────────────────

  /// Thin divider used between every info tile row.
  static Widget tileDivider() => const Divider(
        height: 1,
        indent: 56,
        color: CustomColors.borderColor,
      );

  /// Expansion tile styled consistently for Story / Mission / License rows.
  static Widget infoExpansionTile({
    required IconData icon,
    required String title,
    required Widget child,
  }) =>
      ExpansionTile(
        leading: Icon(icon, color: CustomColors.textMain),
        title: Text(title, style: _tileTitleStyle),
        iconColor: CustomColors.textMuted,
        collapsedIconColor: CustomColors.textMuted,
        textColor: CustomColors.textMain,
        collapsedTextColor: CustomColors.textMain,
        childrenPadding: const EdgeInsets.fromLTRB(24, 0, 16, 16),
        expandedAlignment: Alignment.centerLeft,
        children: [child],
      );

  /// Navigation list tile used for Values / Terms / Privacy / Contact / Call.
  static Widget infoListTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) =>
      ListTile(
        leading: Icon(icon, color: CustomColors.textMain),
        title: Text(title, style: _tileTitleStyle),
        trailing: const Icon(Icons.chevron_right, color: CustomColors.textMuted),
        onTap: onTap,
      );

  // ── Build ──────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _scaffoldBg,
      appBar: AppBar(
        backgroundColor: _scaffoldBg,
        surfaceTintColor: _scaffoldBg,
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
          // LOGO
          Column(
            children: [
              Image.asset(
                'assets/images/logo_black.png',
                width: 180,
                fit: BoxFit.contain,
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

          // DESCRIPTION
          const Text(
            _description,
            style: TextStyle(
              fontSize: 15,
              color: CustomColors.textMuted,
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),

          // INFO TILES
          Material(
            color: CustomColors.surfaceWhite,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(16.0)),
              side: BorderSide(color: CustomColors.borderColor),
            ),
            clipBehavior: Clip.antiAlias,
            child: Theme(
              data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
              child: Column(
                children: [
                  infoExpansionTile(
                    icon: Icons.auto_stories_outlined,
                    title: storyTitle,
                    child: const Text(
                      storyContent, 
                      style: _tileBodyStyle,
                    ),
                  ),
                  tileDivider(),
                  infoExpansionTile(
                    icon: Icons.flag_outlined,
                    title: missionTitle,
                    child: const Text(
                      missionContent,
                      style: _tileBodyStyle,
                    ),
                  ),
                  tileDivider(),
                  infoListTile(
                    icon: Icons.stars_outlined,
                    title: 'Our Values',
                    onTap: () => _onValuesTap(context),
                  ),
                  tileDivider(),
                  infoExpansionTile(
                    icon: Icons.verified_outlined,
                    title: _licenseLabel,
                    child: const Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.verified, color: CustomColors.luxuryGold, size: 18),
                        SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            _licenseNumber,
                            style: TextStyle(
                              fontSize: 13, 
                              color: CustomColors.textMuted,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  tileDivider(),
                  infoListTile(
                    icon: Icons.description_outlined,
                    title: 'Terms of Service',
                    onTap: () => Utils.launchWebUrl(Constants.termsAndConditions),
                  ),
                  tileDivider(),
                  infoListTile(
                    icon: Icons.privacy_tip_outlined,
                    title: 'Privacy Policy',
                    onTap: () => Utils.launchWebUrl(Constants.privacyPolicy),
                  ),
                  tileDivider(),
                  infoListTile(
                    icon: Icons.email_outlined,
                    title: 'Contact Us',
                    onTap: () => Utils.launchEmail(Constants.email),
                  ),
                  tileDivider(),
                  infoListTile(
                    icon: Icons.phone_outlined,
                    title: 'Call Us',
                    onTap: () => Utils.launchPhone(Constants.phone),
                  ),
                ],
              ),
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
          const SizedBox(height: 50),
        ],
      ),
    );
  }
}
