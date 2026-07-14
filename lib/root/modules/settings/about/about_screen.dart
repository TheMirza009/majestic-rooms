import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:majestic_rooms/core/theme/theme_context_extension.dart';
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

  static TextStyle _tileTitleStyle(BuildContext context) => TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: context.textMainColor,
  );

  static TextStyle _tileBodyStyle(BuildContext context) =>
      TextStyle(fontSize: 14, color: context.textMutedColor);

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
                    Icon(icon, color: context.primaryColor, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: context.textMainColor,
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
  static Widget tileDivider(BuildContext context) =>
      Divider(height: 1, indent: 56, color: context.borderColor);

  /// Expansion tile styled consistently for Story / Mission / License rows.
  static Widget infoExpansionTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required Widget child,
  }) => ExpansionTile(
    leading: Icon(icon, color: context.textMainColor),
    title: Text(title, style: _tileTitleStyle(context)),
    iconColor: context.textMutedColor,
    collapsedIconColor: context.textMutedColor,
    textColor: context.textMainColor,
    collapsedTextColor: context.textMainColor,
    childrenPadding: const EdgeInsets.fromLTRB(24, 0, 16, 16),
    expandedAlignment: Alignment.centerLeft,
    children: [child],
  );

  /// Navigation list tile used for Values / Terms / Privacy / Contact / Call.
  static Widget infoListTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) => ListTile(
    leading: Icon(icon, color: context.textMainColor),
    title: Text(title, style: _tileTitleStyle(context)),
    trailing: Icon(Icons.chevron_right, color: context.textMutedColor),
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
              Text(
                Constants.appName,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: context.textMainColor,
                ),
              ),
              const SizedBox(height: 4),
              // Text(
              //   'Version: @version'.trParams({'version': Constants.appVersion}),
              //   style: TextStyle(
              //     fontSize: 14,
              //     color: context.textMutedColor,
              //     fontWeight: FontWeight.w500,
              //   ),
              // ),
            ],
          ),
          const SizedBox(height: 32),

          // DESCRIPTION
          Text(
            description,
            style: TextStyle(
              fontSize: 15,
              color: context.textMutedColor,
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),

          // INFO TILES
          Material(
            color: context.surfaceColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(16.0)),
              side: BorderSide(color: context.borderColor),
            ),
            clipBehavior: Clip.antiAlias,
            child: Theme(
              data: Theme.of(
                context,
              ).copyWith(dividerColor: Colors.transparent),
              child: Column(
                children: [
                  infoExpansionTile(
                    context,
                    icon: Icons.auto_stories_outlined,
                    title: storyTitle,
                    child: Text(storyContent, style: _tileBodyStyle(context)),
                  ),
                  tileDivider(context),
                  infoExpansionTile(
                    context,
                    icon: Icons.flag_outlined,
                    title: missionTitle,
                    child: Text(missionContent, style: _tileBodyStyle(context)),
                  ),
                  tileDivider(context),
                  infoListTile(
                    context,
                    icon: Icons.stars_outlined,
                    title: 'our_values_title'.tr,
                    onTap: () => _onValuesTap(context),
                  ),
                  tileDivider(context),
                  infoExpansionTile(
                    context,
                    icon: Icons.verified_outlined,
                    title: _licenseLabel,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.verified,
                          color: context.secondaryColor,
                          size: 18,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            _licenseNumber,
                            style: TextStyle(
                              fontSize: 13,
                              color: context.textMutedColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  tileDivider(context),
                  infoListTile(
                    context,
                    icon: Icons.description_outlined,
                    title: 'terms_of_service'.tr,
                    onTap: () =>
                        Utils.launchWebUrl(Constants.termsAndConditions),
                  ),
                  tileDivider(context),
                  infoListTile(
                    context,
                    icon: Icons.privacy_tip_outlined,
                    title: 'privacy_policy'.tr,
                    onTap: () => Utils.launchWebUrl(Constants.privacyPolicy),
                  ),
                  tileDivider(context),
                  infoListTile(
                    context,
                    icon: Icons.email_outlined,
                    title: 'contact_us'.tr,
                    onTap: () => Utils.launchEmail(Constants.email),
                  ),
                  tileDivider(context),
                  infoListTile(
                    context,
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
              style: TextStyle(fontSize: 12, color: context.textMutedColor),
            ),
          ),
          const SizedBox(height: 50),
        ],
      ),
    );
  }
}
