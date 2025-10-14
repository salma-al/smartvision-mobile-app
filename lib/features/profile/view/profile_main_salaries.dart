import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_vision/core/utils/media_query_values.dart';
import 'package:smart_vision/core/widgets/loading_widget.dart';

import '../../../core/utils/colors.dart';
import '../../../core/widgets/custom_drop_down_field.dart';
import '../view_model/cubit/profile_cubit.dart';

class ProfileMainSalary extends StatelessWidget {
  const ProfileMainSalary({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Salaries', style: TextStyle(color: AppColors.mainColor)),
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
      body: BlocProvider(
        create: (context) => ProfileCubit()..getSalriesProfile(context),
        child: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            var cubit = ProfileCubit.get(context);
            return Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16, top: 50),
                  child: SizedBox(
                    width: context.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        SizedBox(
                          width: context.width * 0.3,
                          child: CustomDropdownFormField(
                            raduis: 35,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                            hintText: 'Years',
                            items: cubit.availableYears.map((e) => DropdownMenuItem(
                              alignment: AlignmentDirectional.center,
                              value: e,
                              child: Text(e.toString(), textAlign: TextAlign.center),),
                            ).toList(),
                            value: cubit.selectedYear,
                            onChanged: (val) => cubit.changeSalaryYear(val!, context),
                          ),
                        ),
                        const SizedBox(height: 50),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  Text('Year', style: TextStyle(color: AppColors.mainColor, fontSize: 18)),
                                  const SizedBox(height: 6),
                                  Divider(color: AppColors.mainColor),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  Text('Month', style: TextStyle(color: AppColors.mainColor, fontSize: 18)),
                                  const SizedBox(height: 6),
                                  Divider(color: AppColors.mainColor),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  Text('Actions', style: TextStyle(color: AppColors.mainColor, fontSize: 18)),
                                  const SizedBox(height: 6),
                                  Divider(color: AppColors.mainColor),
                                ],
                              ),
                            ),
                          ],
                        ),
                        ...cubit.salaryList.map((e) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 24),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    children: [
                                      Text(cubit.selectedYear.toString(), style: TextStyle(color: AppColors.darkColor, fontSize: 18)),
                                      const SizedBox(height: 6),
                                      Divider(color: AppColors.mainColor),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    children: [
                                      Text(e.month, style: TextStyle(color: AppColors.darkColor, fontSize: 18)),
                                      const SizedBox(height: 6),
                                      Divider(color: AppColors.mainColor),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    children: [
                                      InkWell(
                                        onTap: () => cubit.getSalryDetails(context, e.id),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: AppColors.mainColor.withValues(alpha: 0.8),
                                            borderRadius: BorderRadius.circular(16),
                                          ),
                                          child: const Text('Details', style: TextStyle(color: Colors.white, fontSize: 14))),
                                      ),
                                      const SizedBox(height: 4),
                                      Divider(color: AppColors.mainColor),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        })
                      ],
                    ),
                  ),
                ),
                if(cubit.profileLoading)
                const LoadingWidget(),
              ],
            );
          },
        )
      ),
    );
  }
}