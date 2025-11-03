import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/utils/colors.dart';
import '../../../core/widgets/loading_widget.dart';
import '../components/check_buttons.dart';
import '../components/check_times_card.dart';
import '../components/sign_in_out_component.dart';
import '../view_model/cubit/sign_in_out_cubit.dart';

class SignInOutScreen extends StatelessWidget {
  const SignInOutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignInOutCubit()..getLastChecks(context),
      child: BlocBuilder<SignInOutCubit, SignInOutState>(
        builder: (context, state) {
          var cubit = SignInOutCubit.get(context);
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              title: Text('Check in / out', style: TextStyle(color: AppColors.mainColor)),
              leading: IconButton(
                icon: Icon(Icons.arrow_back_ios, color: AppColors.mainColor),
                onPressed: () => Navigator.pop(context),
              ),
              backgroundColor: Colors.white,
              elevation: 0,
              actions: [
                Image.asset('assets/images/home_logo.png', width: 40, height: 40),
                const SizedBox(width: 15),
              ],
            ),
            body: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 24, right: 24),
                  child: RefreshIndicator(
                    onRefresh: () => cubit.getLastChecks(context),
                    child: ListView(
                      children: [
                        const SizedBox(height: 50),
                        // Information Section
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white70,
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.shade300,
                                spreadRadius: 0,
                                blurRadius: 6,
                                offset: const Offset(2, 3),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              SignInOutComponent(title: 'Date', value: cubit.getFormattedDate()),
                              SignInOutComponent(title: 'Time', value: '${cubit.startHour} - ${cubit.endHour}'),
                              SignInOutComponent(title: 'Location', value: cubit.companyAddress),
                              const SizedBox(height: 16),
                              ElevatedButton.icon(
                                onPressed: () => cubit.launchMap(context),
                                icon: const Icon(Icons.location_on, color: Colors.white),
                                label: const Text(
                                  'Get Directions',
                                  style: TextStyle(color: Colors.white),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.mainColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Image Capture Section
                        if(cubit.availableCheck)
                        GestureDetector(
                          onTap: () => cubit.pickImage(context),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            decoration: BoxDecoration(
                              color: cubit.isCheckedIn ? AppColors.mainColor : AppColors.redColor,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.shade300,
                                  spreadRadius: 0,
                                  blurRadius: 6,
                                  offset: const Offset(2, 3),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.add_a_photo_rounded, color: Colors.white),
                                const SizedBox(width: 8),
                                Text(
                                  'Take ${cubit.isCheckedIn ? 'checkin' : 'checkout'} photo',
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Check-In and Check-Out Buttons
                        if(cubit.availableCheck && cubit.isCheckedIn && !cubit.requiredImg)
                        CheckButtons(onTap: () => cubit.checkFunction(context, true), title: 'Check In')
                        else if(cubit.availableCheck && !cubit.isCheckedIn && !cubit.requiredImg)
                        CheckButtons(onTap: () => cubit.checkFunction(context, false), title: 'Check Out'),
                        const SizedBox(height: 30),
                        // Display Check-In and Check-Out Times with Hours Worked
                        cubit.checkRecords.isEmpty ?
                        const CheckTimesCard(inTime: '---', outTime: '---', hours: '00 : 00 : 00') :
                        Column(
                          children: cubit.checkRecords.map((e) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: CheckTimesCard(
                              inTime: e.checkInTime,
                              outTime: e.checkOutTime,
                              hours: (e.checkInTime != '---' && e.checkOutTime == '---') 
                                  ? cubit.formatDuration()
                                  : (e.checkInTime == '---' && e.checkOutTime == '---') 
                                      ? '00 : 00 : 00' 
                                      : cubit.calculateHours(e.checkInTime, e.checkOutTime),
                            ),
                          )).toList(),
                        ),
                      ],
                    ),
                  ),
                ),
                if (cubit.checkLoading)
                LoadingWidget(progress: cubit.uploadProgress),
              ],
            ),
          );
        },
      ),
    );
  }
}