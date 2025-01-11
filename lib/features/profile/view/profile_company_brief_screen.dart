// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:smart_vision/core/utils/colors.dart';
import 'package:smart_vision/core/utils/media_query_values.dart';
import 'package:smart_vision/core/widgets/loading_widget.dart';
import 'package:smart_vision/core/widgets/primary_button.dart';
import 'package:smart_vision/features/profile/components/profile_container.dart';
import 'package:smart_vision/features/profile/view_model/cubit/profile_cubit.dart';

import '../../../core/helper/data_helper.dart';
import '../../login/view/login_screen.dart';

class CompanyProfileScreen extends StatelessWidget {
  const CompanyProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final instance = DataHelper.instance;
    return BlocProvider(
      create: (context) => ProfileCubit()..getCompanyProfile(context),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('Company Profile', style: TextStyle(color: AppColors.mainColor)),
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
                    onRefresh: () => cubit.getCompanyProfile(context),
                    child: ListView(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.grey.shade200,
                          child: Image.asset('assets/images/home_logo.png', width: 70, height: 70),
                        ),
                        const SizedBox(height: 16),
                        Text('SVG', textAlign: TextAlign.center, style: TextStyle(color: AppColors.mainColor, fontSize: 24)),
                        const SizedBox(height: 25),
                        ProfileContainer(
                          margin: const EdgeInsetsDirectional.symmetric(horizontal: 15),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 20),
                                child: ListTile(title: Text(cubit.company ?? '', style: TextStyle(fontSize: 16, color: AppColors.darkColor))),
                              ),
                              const Divider(),
                              Padding(
                                padding: const EdgeInsets.only(left: 20),
                                child: ListTile(
                                  title: Text(
                                    'The company\'s branch in ${cubit.branch ?? ''}', 
                                    style: TextStyle(fontSize: 16, color: AppColors.darkColor), 
                                    maxLines: 2, 
                                    overflow: TextOverflow.ellipsis,
                                  )),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 30),
                        const Padding(
                          padding: EdgeInsetsDirectional.only(start: 15),
                          child: Text('Company Information'),
                        ),
                        const SizedBox(height: 16),
                        ProfileContainer(
                          margin: const EdgeInsetsDirectional.symmetric(horizontal: 15),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: ListTile(title: Text(cubit.description ?? 'not set', style: TextStyle(fontSize: 16, color: AppColors.darkColor))),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: context.width * 0.2),
                          child: PrimaryButton(
                            text: 'Logout',
                            color: HexColor('#D9534F'),
                            onTap: () async {
                              await instance.reset();
                              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const LoginScreen()), (Route<dynamic> route) => false);
                            }
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