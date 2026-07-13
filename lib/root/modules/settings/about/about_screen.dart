import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:majestic_rooms/core/theme/custom_colors.dart';
import 'package:majestic_rooms/core/utils/constants.dart';
import 'package:majestic_rooms/core/utils/helper.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  // ── Control Panel ─────────────────────────────────────────────────────────
  static const _scaffoldBg = Color(0xFFF7F7F9);

  static String get description => 'about_description'.tr;

  static String get storyTitle => 'our_story_title'.tr;
  static String get storyContent => 'our_story_content'.tr;

  static String get missionTitle => 'our_mission_title'.tr;
  static String get missionContent => 'our_mission_content'.tr;

  static String get valuesTitle => 'our_values_title'.tr;
  static List<(String, String, IconData)> get values => [
    (
      'value_trust_title'.tr,
      'value_trust_content'.tr,
      Icons.handshake_outlined,
    ),
    (
      'value_customer_title'.tr,
      'value_customer_content'.tr,
      Icons.support_agent_outlined,
    ),
    (
      'value_passion_title'.tr,
      'value_passion_content'.tr,
      Icons.explore_outlined,
    ),
    (
      'value_simplicity_title'.tr,
      'value_simplicity_content'.tr,
      Icons.touch_app_outlined,
    ),
    (
      'value_security_title'.tr,
      'value_security_content'.tr,
      Icons.security_outlined,
    ),
    (
      'value_expertise_title'.tr,
      'value_expertise_content'.tr,
      Icons.location_on_outlined,
    ),
  ];

  static String get _licenseLabel => 'licensed_company'.tr;
  static String get _licenseNumber => 'license_number'.tr;

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
        title: Text(valuesTitle),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              for (final (title, body, icon) in values) ...[
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
            child: Text('Close'.tr),
          ),
        ],
      ),
    );
  }

  // ── Widget helpers ─────────────────────────────────────────────────────────

  /// Thin divider used between every info tile row.
  static Widget tileDivider() =>
      const Divider(height: 1, indent: 56, color: CustomColors.borderColor);

  /// Expansion tile styled consistently for Story / Mission / License rows.
  static Widget infoExpansionTile({
    required IconData icon,
    required String title,
    required Widget child,
  }) => ExpansionTile(
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
  }) => ListTile(
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
        title: Text(
          'About'.tr,
          style: const TextStyle(fontWeight: FontWeight.bold),
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
              // Text(
              //   'Version: @version'.trParams({'version': Constants.appVersion}),
              //   style: const TextStyle(
              //     fontSize: 14,
              //     color: CustomColors.textMuted,
              //     fontWeight: FontWeight.w500,
              //   ),
              // ),
            ],
          ),
          const SizedBox(height: 32),

          // DESCRIPTION
          Text(
            description,
            style: const TextStyle(
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
              data: Theme.of(
                context,
              ).copyWith(dividerColor: Colors.transparent),
              child: Column(
                children: [
                  infoExpansionTile(
                    icon: Icons.auto_stories_outlined,
                    title: storyTitle,
                    child: Text(storyContent, style: _tileBodyStyle),
                  ),
                  tileDivider(),
                  infoExpansionTile(
                    icon: Icons.flag_outlined,
                    title: missionTitle,
                    child: Text(missionContent, style: _tileBodyStyle),
                  ),
                  tileDivider(),
                  infoListTile(
                    icon: Icons.stars_outlined,
                    title: 'our_values_title'.tr,
                    onTap: () => _onValuesTap(context),
                  ),
                  tileDivider(),
                  infoExpansionTile(
                    icon: Icons.verified_outlined,
                    title: _licenseLabel,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.verified,
                          color: CustomColors.luxuryGold,
                          size: 18,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            _licenseNumber,
                            style: const TextStyle(
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
                    title: 'terms_of_service'.tr,
                    onTap: () =>
                        Utils.launchWebUrl(Constants.termsAndConditions),
                  ),
                  tileDivider(),
                  infoListTile(
                    icon: Icons.privacy_tip_outlined,
                    title: 'privacy_policy'.tr,
                    onTap: () => Utils.launchWebUrl(Constants.privacyPolicy),
                  ),
                  tileDivider(),
                  infoListTile(
                    icon: Icons.email_outlined,
                    title: 'contact_us'.tr,
                    onTap: () => Utils.launchEmail(Constants.email),
                  ),
                  tileDivider(),
                  infoListTile(
                    icon: Icons.phone_outlined,
                    title: 'call_us'.tr,
                    onTap: () => Utils.launchPhone(Constants.phone),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),

          // COPYRIGHT
          Center(
            child: Text(
              'copyright_text'.tr,
              style: const TextStyle(
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
