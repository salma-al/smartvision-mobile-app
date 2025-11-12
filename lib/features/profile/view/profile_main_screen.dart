import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:smart_vision/core/helper/cache_helper.dart';

import '../../../core/helper/data_helper.dart';
import '../../../core/utils/colors.dart';
import '../../../core/utils/media_query_values.dart';
import '../../../core/widgets/primary_button.dart';
import '../../announcement/view/announceent_main_screen.dart';
import '../../home/view/home_screen.dart';
import '../../login/view/login_screen.dart';
import '../../notification/view/notifications_screen.dart';
import '../components/profile_container.dart';
import 'profile_company_brief_screen.dart';
import 'profile_info_screen.dart';
import 'profile_main_salaries.dart';

class ProfileMainScreen extends StatelessWidget {
  const ProfileMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final instance = DataHelper.instance;
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile', style: TextStyle(color: AppColors.mainColor)),
        actions: [
          Image.asset('assets/images/home_logo.png', width: 40, height: 40),
          const SizedBox(width: 15),
        ],
        backgroundColor: Colors.white,
      ),
      body: Container(
        color: Colors.white,
        height: context.height,
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 45),
              Row(
                children: [
                  CircleAvatar(
                    radius: 35,
                    backgroundColor: Colors.grey,
                    child: instance.img == null ? 
                      const Icon(Icons.person, size: 50, color: Colors.white) :
                      ClipRRect(
                        borderRadius: BorderRadius.circular(35),
                        child: FadeInImage(
                          placeholder: NetworkImage('https://eu.ui-avatars.com/api/?name=${instance.name}&size=250'), 
                          image: NetworkImage(instance.img ?? ''), fit: BoxFit.cover,
                          imageErrorBuilder: (context, error, stackTrace) => const Icon(Icons.person, size: 50, color: Colors.white),
                        ),
                      ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(instance.name ?? '', maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(color: AppColors.mainColor, fontSize: 20)),
                        const SizedBox(height: 2),
                        Text(instance.userId ?? ''),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 60),
              const Text('Account'),
              const SizedBox(height: 20),
              ProfileContainer(
                margin: const EdgeInsetsDirectional.only(bottom: 20, end: 15, start: 15),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20, top: 10, bottom: 10),
                      child: InkWell(
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfileInfoScreen())),
                        child: ListTile(
                          leading: Icon(Icons.person, color: AppColors.mainColor),
                          title: Text('Personal Info', style: TextStyle(fontSize: 16, color: AppColors.darkColor)),
                          trailing: Icon(Icons.keyboard_arrow_right, color: AppColors.mainColor),
                        ),
                      ),
                    ),
                    const Divider(),
                    Padding(
                      padding: const EdgeInsets.only(left: 20, top: 10, bottom: 10),
                      child: InkWell(
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const CompanyProfileScreen())),
                        child: ListTile(
                          leading: Icon(Icons.article, color: AppColors.mainColor),
                          title: Text('Company brief', style: TextStyle(fontSize: 16, color: AppColors.darkColor)),
                          trailing: Icon(Icons.keyboard_arrow_right, color: AppColors.mainColor),
                        ),
                      ),
                    ),
                    const Divider(),
                    Padding(
                      padding: const EdgeInsets.only(left: 20, top: 10, bottom: 10),
                      child: InkWell(
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfileMainSalary())),
                        child: ListTile(
                          leading: Icon(Icons.payment, color: AppColors.mainColor),
                          title: Text('My salaries', style: TextStyle(fontSize: 16, color: AppColors.darkColor)),
                          trailing: Icon(Icons.keyboard_arrow_right, color: AppColors.mainColor),
                        ),
                      ),
                    ),
                    const Divider(),
                    Padding(
                      padding: const EdgeInsets.only(left: 20, top: 10, bottom: 10),
                      child: InkWell(
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AnnouncementMainScreen())),
                        child: ListTile(
                          leading: Icon(Icons.announcement, color: AppColors.mainColor),
                          title: Text('Announcement', style: TextStyle(fontSize: 16, color: AppColors.darkColor)),
                          trailing: Icon(Icons.keyboard_arrow_right, color: AppColors.mainColor),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: context.width * 0.2),
                child: PrimaryButton(
                  text: 'Logout',
                  color: HexColor('#D9534F'),
                  onTap: () async {
                    String email = await CacheHelper.getData('email', String) ?? '';
                    String password = await CacheHelper.getData('password', String) ?? '';
                    await instance.reset();
                    if(email.isNotEmpty) await CacheHelper.setData('email', email);
                    if(password.isNotEmpty) await CacheHelper.setData('password', password);
                    // ignore: use_build_context_synchronously
                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const LoginScreen()), (Route<dynamic> route) => false);
                  }
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        elevation: 8,
        currentIndex: 2,
        selectedItemColor: AppColors.mainColor.withValues(alpha: 0.8),
        unselectedItemColor: AppColors.darkColor.withValues(alpha: 0.8),
        onTap: (index) {
          if (index == 1) {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const NotificationScreen()));
          } else if (index == 0) {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomeScreen(saveToken: false)));
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_filled),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  // Future<void> checkForUpdates(context) async {
  //   final updater = ShorebirdUpdater();
  //   // Check whether a new update is available.
  //   final status = await updater.checkForUpdate();

  //   if (status == UpdateStatus.outdated) {
  //     try {
  //       // Perform the update
  //       await updater.update();
  //     } on UpdateException catch (error) {
  //       ToastWidget().showToast('Can\'t update for now, please try again later', context);
  //     }
  //   }else {
  //     ToastWidget().showToast('You are up to date', context);
  //   }
  // }
}