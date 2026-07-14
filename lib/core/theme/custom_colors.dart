import 'package:flutter/material.dart';

class CustomColors {
  CustomColors._();

  // ── Legacy (kept for backward compatibility) ──────────────────────────────
  static const Color brandRed = Color(0xFF7A2021);
  static const Color brandGreen = Color(0xFF1697A3);
  static const Color brandBlack = Color(0xFF111827);
  static const Color brandWhite = Color(0xFFFFFFFF);
  static const Color brandGrey = Color(0xFFE5E7EB);
  static const Color textDark = Color(0xFF111827);
  static const Color linkColor = Color(0xFF1F2937);
  static const Color borderColor = Color(0xFFE5E7EB);
  static const Color hintColor = Color(0xFF9E9E9E);
  static const Color successColor = Colors.lightGreenAccent;

  // ── Brand tones ───────────────────────────────────────────────────────────
  static const Color primaryDark = Color(
    0xFF111111,
  ); // main backgrounds / headers
  static const Color luxuryGold = Color(
    0xFFD4AF37,
  ); // accents, active states, stars
  static const Color premiumAmber = Color(
    0xFFC5A059,
  ); // border outlines, secondary buttons

  // ── Surface & canvas ──────────────────────────────────────────────────────
  static const Color bgLight = Color(0xFFF9F9FA); // scaffold background
  static const Color bgLightAlt = Color(0xEEE4EAEA); // scaffold background
  static const Color surfaceWhite = Color(0xFFFFFFFF); // cards / containers
  static const Color cardSubtleBg = Color(
    0xFFF1F1F3,
  ); // secondary cards / dividers

  // ── Typography ────────────────────────────────────────────────────────────
  static const Color textMain = Color(0xFF1A1A1A); // headings
  static const Color textMuted = Color(0xFF666666); // descriptions / subtitles
  static const Color textLight = Color(0xFFFFFFFF); // text on dark surfaces

  // ── Utility ───────────────────────────────────────────────────────────────
  static const Color whatsappGreen = Color(0xFF25D366); // WhatsApp float button
}
