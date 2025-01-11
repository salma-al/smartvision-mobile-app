import 'package:flutter/material.dart';
// import 'package:shorebird_code_push/shorebird_code_push.dart';
// import 'package:smart_vision/core/widgets/toast_widget.dart';
import '../../../core/helper/data_helper.dart';
import '../../../core/utils/colors.dart';
import '../../../core/utils/media_query_values.dart';
// import '../../../core/widgets/primary_button.dart';
import '../../announcement/view/announceent_main_screen.dart';
import '../../home/view/home_screen.dart';
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(instance.name ?? '', style: TextStyle(color: AppColors.mainColor, fontSize: 20)),
                      const SizedBox(height: 2),
                      Text(instance.userId ?? ''),
                    ],
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
                          title: Text('announcement', style: TextStyle(fontSize: 16, color: AppColors.darkColor)),
                          trailing: Icon(Icons.keyboard_arrow_right, color: AppColors.mainColor),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // const SizedBox(height: 30),
              // PrimaryButton(
              //   text: 'Check for updates', 
              //   onTap: () {},
              // ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        elevation: 8,
        currentIndex: 2,
        selectedItemColor: AppColors.mainColor.withOpacity(0.8),
        unselectedItemColor: AppColors.darkColor.withOpacity(0.8),
        items: <BottomNavigationBarItem> [
          BottomNavigationBarItem(
            icon: InkWell(
              child: const Icon(Icons.home_filled), 
              onTap: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomeScreen())),
            ), 
            label: 'Home', 
            backgroundColor: AppColors.mainColor,
          ),
          BottomNavigationBarItem(
            icon: InkWell(
              onTap: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const NotificationScreen())),
              child: const Icon(Icons.notifications),
            ), 
            label: 'Notifications', 
            backgroundColor: AppColors.mainColor,
          ),
          BottomNavigationBarItem(
            icon: InkWell(
              onTap: () {},
              child: const Icon(Icons.person),
            ), 
            label: 'Profile', 
            backgroundColor: AppColors.mainColor,
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