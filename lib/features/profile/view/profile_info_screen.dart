// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_vision/core/utils/colors.dart';
import 'package:smart_vision/core/widgets/loading_widget.dart';
import 'package:smart_vision/features/profile/components/profile_container.dart';
import 'package:smart_vision/features/profile/view_model/cubit/profile_cubit.dart';

import '../../../core/helper/data_helper.dart';

class ProfileInfoScreen extends StatelessWidget {
  const ProfileInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final instance = DataHelper.instance;
    return BlocProvider(
      create: (context) => ProfileCubit()..getProfile(context),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('Personal info', style: TextStyle(color: AppColors.mainColor)),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: AppColors.mainColor),
            onPressed: () => Navigator.pop(context),
          ),
          actions: [
            Image.asset('assets/images/home_logo.png', width: 40, height: 40),
            const SizedBox(width: 15),
          ],
          backgroundColor: Colors.white,
        ),
        body: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            var cubit = ProfileCubit.get(context);
            return Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: RefreshIndicator(
                    onRefresh: () => cubit.getProfile(context),
                    child: ListView(
                      children: [
                        CircleAvatar(
                          radius: 50,
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
                        const SizedBox(height: 16),
                        Text(instance.name ?? '', textAlign: TextAlign.center, style: TextStyle(color: AppColors.mainColor, fontSize: 20)),
                        const SizedBox(height: 2),
                        Text(instance.userId ?? '', textAlign: TextAlign.center),
                        const SizedBox(height: 25),
                        ProfileContainer(
                          margin: const EdgeInsetsDirectional.symmetric(horizontal: 28),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 20),
                                  child: ListTile(title: Text(instance.email ?? '', style: TextStyle(fontSize: 16, color: AppColors.darkColor))),
                                ),
                                const Divider(),
                                Padding(
                                  padding: const EdgeInsets.only(left: 20),
                                  child: ListTile(title: Text(instance.userId ?? '', style: TextStyle(fontSize: 16, color: AppColors.darkColor))),
                                ),
                                const Divider(),
                                Padding(
                                  padding: const EdgeInsets.only(left: 20),
                                  child: ListTile(title: Text('Employment Type: ${cubit.employmentType ?? 'not set'}', style: TextStyle(fontSize: 16, color: AppColors.darkColor))),
                                ),
                                const Divider(),
                                Padding(
                                  padding: const EdgeInsets.only(left: 20),
                                  child: ListTile(title: Text('Default Shift: ${cubit.startShift ?? 'not set'} - ${cubit.endShift ?? 'not set'}', style: TextStyle(fontSize: 16, color: AppColors.darkColor))),
                                ),
                                const Divider(),
                                Padding(
                                  padding: const EdgeInsets.only(left: 20),
                                  child: ListTile(title: Text('Joining Date: ${cubit.joiningDate ?? 'not set'}', style: TextStyle(fontSize: 16, color: AppColors.darkColor))),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        const Padding(
                          padding: EdgeInsetsDirectional.only(start: 15),
                          child: Text('Department Information'),
                        ),
                        const SizedBox(height: 16),
                        ProfileContainer(
                          margin: const EdgeInsetsDirectional.symmetric(horizontal: 28),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 20),
                                  child: ListTile(title: Text('Title: ${cubit.position ?? 'not set'}', style: TextStyle(fontSize: 16, color: AppColors.darkColor))),
                                ),
                                const Divider(),
                                Padding(
                                  padding: const EdgeInsets.only(left: 20),
                                  child: ListTile(title: Text('Department: ${cubit.department ?? 'not set'}', style: TextStyle(fontSize: 16, color: AppColors.darkColor))),
                                ),
                                const Divider(),
                                Padding(
                                  padding: const EdgeInsets.only(left: 20),
                                  child: ListTile(title: Text('Current Salary: ${cubit.currSalary ?? 'not set'}', style: TextStyle(fontSize: 16, color: AppColors.darkColor))),
                                ),
                                const Divider(),
                                Padding(
                                  padding: const EdgeInsets.only(left: 20),
                                  child: ListTile(title: Text('Manager: ${cubit.manager ?? 'not set'}', style: TextStyle(fontSize: 16, color: AppColors.darkColor))),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
                if(cubit.profileLoading)
                const LoadingWidget(),
              ],
            );
          },
        ),
      ),
    );
  }
}