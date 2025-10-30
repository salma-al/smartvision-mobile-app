import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_constants.dart';

class ThemeProvider extends ChangeNotifier {
  CompanyTheme _currentCompany = CompanyTheme.groupCompany;
  
  CompanyTheme get currentCompany => _currentCompany;
  Color get accentColor => AppColors.getAccentColor(_currentCompany);
  
  void setCompany(CompanyTheme company) {
    _currentCompany = company;
    notifyListeners();
  }
}
