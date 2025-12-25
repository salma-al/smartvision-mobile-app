import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:smart_vision/core/constants/app_constants.dart';

import 'cache_helper.dart';

class DataHelper {
  DataHelper._privateConstructor();

  static final DataHelper _instance = DataHelper._privateConstructor();

  static DataHelper get instance => _instance;

  String? token, name, userId, email, img, company;
  bool isHr = false, isManager = false;

  //global variables
  CompanyBranding? comp;
  static int unreadNotificationCount = 0;

  set() async{
    await CacheHelper.setData('userId', userId);
    await CacheHelper.setData('name', name);
    await CacheHelper.setData('token', token);
    await CacheHelper.setData('email', email);
    await CacheHelper.setData('company', company);
    setCompanyDetails();
  }
  get() async{
    name = await CacheHelper.getData('name', String);
    token = await CacheHelper.getData('token', String);
    userId = await CacheHelper.getData('userId', String);
    email = await CacheHelper.getData('email', String);
    img = await CacheHelper.getData('img', String);
    company = await CacheHelper.getData('company', String);
    setCompanyDetails();
  }
  setCompanyDetails() {
    Color primaryColor = getColor();
    String logoAsset = getLogoPath();
    comp = CompanyBranding(name: company ?? '', primaryColor: primaryColor, logoAsset: logoAsset);
  }
  Color getColor() {
    switch(company) {
      case 'Smart Vision Engineering Consultant':
        return HexColor('#19868B');
      case 'Smart Vision Group':
        return HexColor('#e64c2a');
      case 'Orbit':
        return HexColor('#FD022B');
      default:
        return const Color(0xFFCB1933);
    }
  }
  String getLogoPath() {
    switch(company) {
      case 'Smart Vision Engineering Consultant':
        return 'assets/images/SVEC_logo.png';
      case 'Smart Vision Group':
        return 'assets/images/SVG_logo.jpg';
      case 'Orbit':
        return 'assets/images/orbit_logo.png';
      default:
        return 'assets/images/SVEC_logo.png';
    }
  }
  reset([bool saveAccount = false]) async{
    if(saveAccount) {
      String email = await CacheHelper.getData('email', String) ?? '';
      String pass = await CacheHelper.getData('password', String) ?? '';
      await CacheHelper.removeAllData();
      await CacheHelper.setData('email', email);
      await CacheHelper.setData('password', pass);
    } else {
      await CacheHelper.removeAllData();
    }
    name = null;
    token = null;
    userId = null;
    email = null;
    img = null;
    company = null;
    comp = null;
  }
}