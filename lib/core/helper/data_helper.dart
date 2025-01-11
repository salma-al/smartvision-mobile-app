import 'cache_helper.dart';

class DataHelper {
  DataHelper._privateConstructor();

  static final DataHelper _instance = DataHelper._privateConstructor();

  static DataHelper get instance => _instance;

  String? token, name, userId, email, img;

  set() async{
    await CacheHelper.setData('userId', userId);
    await CacheHelper.setData('name', name);
    await CacheHelper.setData('token', token);
    await CacheHelper.setData('email', email);
  }
  get() async{
    name = await CacheHelper.getData('name', String);
    token = await CacheHelper.getData('token', String);
    userId = await CacheHelper.getData('userId', String);
    email = await CacheHelper.getData('email', String);
    img = await CacheHelper.getData('img', String);
  }
  reset() async{
    await CacheHelper.removeAllData();
    name = null;
    token = null;
    userId = null;
    email = null;
    img = null;
  }
}