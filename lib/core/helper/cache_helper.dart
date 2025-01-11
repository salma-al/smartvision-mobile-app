// ignore_for_file: unnecessary_null_comparison

import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert' as convert;

class CacheHelper {
  static late SharedPreferences sharedPreferences;
  static init() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  static setData(key, value) async {
    await init();
    switch (value.runtimeType) { 
      case const (bool):
        return sharedPreferences.setBool(key, value);
      case const (String):
        return await sharedPreferences.setString(key, value);
      case const (int):
        return await sharedPreferences.setInt(key, value);
      case const (List<String>):
        return await sharedPreferences.setStringList(key, value);
      default:
        String dataString = convert.jsonEncode(value);
        return await sharedPreferences.setString(key.toString(), dataString);
    }
  }

  static getData(key, Type type) async {
    await init();
    try {
      switch (type) {
        case const (bool):
          return sharedPreferences.getBool(key);
        case const (String):
          return sharedPreferences.getString(key);
        case const (int):
          return sharedPreferences.getInt(key);
        case const (List<String>):
          return sharedPreferences.getStringList(key);
        case const (Map):
          String? data = sharedPreferences.getString(key.toString());
          if (data != null) {
            return await convert.jsonDecode(data);
          } else {
            return null;
          }
      }

      // ignore: empty_catches
    } catch (e) {}
  }

  static removeData(key) async {
    await init();
    try {
      sharedPreferences.remove(key);
      // ignore: empty_catches
    } catch (e) {}
  }

  static removeAllData() async {
    try {
      sharedPreferences.clear();
      // ignore: empty_catches
    } catch (e) {}
  }
}
