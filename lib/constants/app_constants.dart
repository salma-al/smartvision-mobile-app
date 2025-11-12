import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Company-specific accent colors
enum CompanyTheme {
  groupCompany(Color(0xFFCB1933)),
  companyA(Color(0xFF2563EB)),
  companyB(Color(0xFF059669)),
  companyC(Color(0xFF7C3AED));

  const CompanyTheme(this.accentColor);
  final Color accentColor;
}

class AppColors {
  static const Color backgroundColor = Color(0xFFF6F6F6);
  static const Color darkBackgroundColor = Color(0xFFEFEDED);
  static const Color darkText = Color(0xFF39383C);
  static const Color lightText = Color(0xFF76747B);
  static const Color white = Color(0xFFFFFFFF);
  static const Color checkInTextColor = Color(0xFFF2EFF5);
  static const Color notificationBadgeColor = Color(0xFFFB2C36);
  static const Color helperText = Color(0xFF4A5565);
  static const Color dividerLight = Color(0xFFF3F4F6);
  static const Color green = Color(0xFF016630);
  static const Color lightGreen = Color(0xFFDCFCE7);
  static const Color blue = Color(0xFF193CB8);
  static const Color lightBlue = Color(0xFFDBEAFE);
  static const Color purple = Color(0xFF9810FA);
  static const Color lightPurple = Color(0xFFF4EEF9);
  static const Color pink = Color(0xFFE92D9A);
  static const Color orange = Color(0xFFF54900);
  static const Color lightOrange = Color(0xFFFFEDD4);
  static const Color teal = Color(0xFF1787A5);
  static const Color lightTeal = Color(0x291787A5);
  static const Color mint = Color(0xFF33B8BC);
  static const Color redOrange = Color(0xFFFF282C);
  static const Color red = Color(0xFF9F0712);
  static const Color lightRed = Color(0xFFFFE2E2);
  static const Color yellow = Color(0xFF894B00);
  static const Color lightYellow = Color(0xFFFEF9C2);
  static const Color lightGrey = Color(0xFFF9FAFB);
  static const Color greyText = Color(0xFF76747B);
  
  // SVEC Brand Color
  static const Color svecColor = Color(0xFF19868B);
  
  // Notification colors
  static const Color unreadBg = Color(0xFFEFF6FF);
  static const Color unreadDot = Color(0xFF155DFC);
  
  // Global notification count
  static const int globalNotificationCount = 3;
  
  // Global unread emails count
  static const int unreadEmailsCount = 4;
  
  // Meeting colors (dots and record backgrounds)
  static const Color meeting1 = Color(0xFF4ECDC4);
  static const Color meeting2 = Color(0xFFFF6B6B);
  static const Color meeting3 = Color(0xFF96CEB4);
  static const Color meeting4 = Color(0xFFFFEAA7);
  static const Color meeting5 = Color(0xFF45B7D1);
  
  static const List<Color> meetingColors = [
    meeting1,
    meeting2,
    meeting3,
    meeting4,
    meeting5,
  ];

  // Dynamic accent color based on company
  static Color getAccentColor(CompanyTheme company) => company.accentColor;
}

class AppSpacing {
  static const double sectionMargin = 30.0;
  static const double sameSectionMargin = 16.0;
  static const double pagePaddingHorizontal = 16.0;
  static const double pagePaddingVertical = 30.0;
  static const double margin12 = 12.0;
}

class AppTypography {
  static TextStyle h1({Color? color}) => TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w600,
    letterSpacing: 1.0,
    color: color ?? AppColors.darkText,
    fontFamily: GoogleFonts.dmSans().fontFamily,
  );
  
  static TextStyle h2({Color? color}) => TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w500,
    letterSpacing: 0,
    color: color ?? AppColors.darkText,
    fontFamily: GoogleFonts.dmSans().fontFamily,
  );
  
  static TextStyle h3({Color? color}) => TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w500,
    letterSpacing: 1.0,
    color: color ?? AppColors.darkText,
    fontFamily: GoogleFonts.dmSans().fontFamily,
  );
  
  static TextStyle myActivityTitle({Color? color}) => TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
    color: color ?? AppColors.darkText,
    fontFamily: GoogleFonts.dmSans().fontFamily,
  );
  
  static TextStyle h4({Color? color}) => TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    letterSpacing: 1.0,
    color: color ?? AppColors.darkText,
    fontFamily: GoogleFonts.dmSans().fontFamily,
  );

  static TextStyle h4semiBold({Color? color}) => TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 1.0,
    color: color ?? AppColors.darkText,
    fontFamily: GoogleFonts.dmSans().fontFamily,
  );

  static TextStyle p12({Color? color}) => TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
    color: color ?? AppColors.darkText,
    fontFamily: GoogleFonts.dmSans().fontFamily,
  );

  static TextStyle p14({Color? color}) => TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
    color: color ?? AppColors.darkText,
    fontFamily: GoogleFonts.dmSans().fontFamily,
  );

  static TextStyle p16({Color? color}) => TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
    color: color ?? AppColors.darkText,
    fontFamily: GoogleFonts.dmSans().fontFamily,
  );

  // 14px, 400, 20px line-height, darkText
  static TextStyle body16({Color? color}) => TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 20 / 14,
    color: color ?? AppColors.darkText,
    fontFamily: GoogleFonts.dmSans().fontFamily,
  );

  // 14px, 400, 20px line-height, darkText
  static TextStyle body14({Color? color}) => TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 20 / 14,
    color: color ?? AppColors.darkText,
    fontFamily: GoogleFonts.dmSans().fontFamily,
  );

  static TextStyle helperTextLarge({Color? color}) => TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 20 / 14,
    color: color ?? AppColors.helperText,
    fontFamily: GoogleFonts.dmSans().fontFamily,
  );

  static TextStyle helperText({Color? color}) => TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 20 / 14,
    color: color ?? AppColors.helperText,
    fontFamily: GoogleFonts.dmSans().fontFamily,
  );

  static TextStyle helperTextSmall({Color? color}) => TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 20 / 14,
    color: color ?? AppColors.helperText,
    fontFamily: GoogleFonts.dmSans().fontFamily,
  );

  static TextStyle helperTextXSmall({Color? color}) => TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w400,
    height: 20 / 14,
    color: color ?? AppColors.greyText,
    fontFamily: GoogleFonts.dmSans().fontFamily,
  );
  
  static TextStyle checkInStatus({Color? color}) => TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    letterSpacing: 1.0,
    color: color ?? AppColors.checkInTextColor,
    fontFamily: GoogleFonts.dmSans().fontFamily,
  );
  
  static TextStyle checkInTime({Color? color}) => TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w500,
    letterSpacing: 1.0,
    color: color ?? AppColors.white,
    fontFamily: GoogleFonts.dmSans().fontFamily,
  );
}

class AppShadows {
  static List<BoxShadow> get defaultShadow => [
    BoxShadow(
      color: Colors.black.withOpacity(0.04),
      blurRadius: 48,
      offset: const Offset(0, 2),
    ),
  ];
  
  static List<BoxShadow> get checkInShadow => [
    BoxShadow(
      color: Colors.black.withOpacity(0.04),
      blurRadius: 48,
      offset: const Offset(0, 2),
    ),
  ];

  // Popup/modal shadow 0 2px 48px rgba(0,0,0,0.04)
  static List<BoxShadow> get popupShadow => [
    BoxShadow(
      color: Colors.black.withOpacity(0.04),
      blurRadius: 48,
      offset: const Offset(0, 2),
    ),
  ];
}

class AppBorderRadius {
  /// x-Small elements like icons or chips
  static const double radius4 = 4.0;

  /// x-Small elements like icons or chips
  static const double radius6 = 6.0;

  /// Small elements like icons or chips
  static const double radius8 = 8.0;

  /// Default widget corners (cards, containers)
  static const double radius12 = 12.0;

  /// Slightly larger UI elements
  static const double radius14 = 14.0;
}
