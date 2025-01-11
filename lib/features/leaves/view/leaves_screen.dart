import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/utils/colors.dart';
import '../../../core/utils/media_query_values.dart';
import '../../../core/widgets/custom_drop_down_field.dart';
import '../../../core/widgets/custom_text_form_feild.dart';
import '../../../core/widgets/loading_widget.dart';
import '../../../core/widgets/primary_button.dart';
import '../components/leave_date_component.dart';
import '../components/request_type_component.dart';
import '../view_model/cubit/leaves_cubit.dart';

class RequestScreen extends StatelessWidget {
  const RequestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LeavesCubit()..getAvailableLeaves(context),
      child: BlocBuilder<LeavesCubit, LeavesState>(
        builder: (context, state) {
          var cubit = LeavesCubit.get(context);
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              title: Text('Request Shift/Leave', style: TextStyle(color: AppColors.mainColor)),
              leading: IconButton(
                icon: Icon(Icons.arrow_back_ios, color: AppColors.mainColor),
                onPressed: () => Navigator.pop(context),
              ),
              backgroundColor: Colors.white,
              actions: [
                Image.asset('assets/images/home_logo.png', width: 40, height: 40),
                const SizedBox(width: 15),
              ],
            ),
            body: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: RefreshIndicator(
                    onRefresh: () => cubit.getAvailableLeaves(context),
                    child: ListView(
                      children: [
                        // Available Requests Info
                        if(cubit.currentRequestType == 'Leave')
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.mainColor.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'Available Leave Times: ${cubit.currentLeaveType == null ? 0 : cubit.currentLeaveType!.availableLeaves}', 
                            style: const TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ),
                        if(cubit.currentRequestType == 'Leave')
                        const SizedBox(height: 50),

                        // Request Type Radio Buttons
                        const Text('Request Type', style: TextStyle(fontSize: 18)),
                        const SizedBox(height: 8),
                        Container(
                          width: context.width,
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Wrap(
                            alignment: WrapAlignment.spaceEvenly,
                            runSpacing: 8,
                            children: [
                              RequestTypeComponent(
                                title: 'Shift',
                                textColor: cubit.currentRequestType == 'Shift' ? Colors.white : AppColors.darkColor,
                                background: cubit.currentRequestType == 'Shift' ? AppColors.mainColor : Colors.grey.withOpacity(0.4),
                                onTap: () => cubit.changeRequestType('Shift'),
                              ),
                              RequestTypeComponent(
                                title: 'Leave',
                                textColor: cubit.currentRequestType == 'Leave' ? Colors.white : AppColors.darkColor,
                                background: cubit.currentRequestType == 'Leave' ? AppColors.mainColor : Colors.grey.withOpacity(0.4),
                                onTap: () => cubit.changeRequestType('Leave'),
                              ),
                              RequestTypeComponent(
                                title: 'OverTime',
                                textColor: cubit.currentRequestType == 'OverTime' ? Colors.white : AppColors.darkColor,
                                background: cubit.currentRequestType == 'OverTime' ? AppColors.mainColor : Colors.grey.withOpacity(0.4),
                                onTap: () => cubit.changeRequestType('OverTime'),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                    
                        // Type Dropdown
                        if(cubit.currentRequestType != 'OverTime')
                        ...[
                          Text(cubit.shownRequestType, style: const TextStyle(fontSize: 18)),
                          const SizedBox(height: 8),
                          CustomDropdownFormField(
                            raduis: 35,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 3),
                            hintText: 'Select ${cubit.shownRequestType}',
                            items: cubit.selectedTypeList.map((e) => DropdownMenuItem(value: e, child: Text(e.leaveType))).toList(),
                            value: cubit.currentLeaveType,
                            onChanged: (val) => cubit.changeLeaveShiftType(val!),
                          ),
                          const SizedBox(height: 20),
                        ],
                        
                        // Start and End Date Fields in One Row
                        Row(
                          children: [
                            LeaveDateComponent(
                              title: cubit.currentRequestType != 'OverTime' ? 'Start Date' : 'Date', 
                              hintTitle: 'Enter start date...', 
                              controller: cubit.startDateController, 
                              onTap: () => cubit.pickDate(true, context),
                            ),
                            const SizedBox(width: 16),
                            if(cubit.currentRequestType != 'OverTime')
                            LeaveDateComponent(
                              title: 'End Date', 
                              hintTitle: 'Enter end date...', 
                              controller: cubit.endDateController, 
                              onTap: () => cubit.pickDate(false, context),
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),

                        if(cubit.currentRequestType == 'OverTime')
                        Row(
                          children: [
                            LeaveDateComponent(
                              title: 'Start Time', 
                              hintTitle: 'Enter start time...', 
                              controller: cubit.startTimeController, 
                              onTap: () => cubit.pickTime(true, context),
                            ),
                            const SizedBox(width: 16),
                            LeaveDateComponent(
                              title: 'End Time', 
                              hintTitle: 'Enter end time...', 
                              controller: cubit.endTimeController, 
                              onTap: () => cubit.pickTime(false, context),
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),
                        
                        if(cubit.currentRequestType == 'Leave' || cubit.currentRequestType == 'OverTime' || (cubit.currentLeaveType != null && cubit.currentLeaveType!.leaveType == 'Work From Home'))
                        CustomTextFormField(
                          hintText: 'Reason...', 
                          maxLines: 3,
                          controller: cubit.reasonController,
                          fillColor: Colors.grey.withOpacity(0.2),
                        ),
                        const SizedBox(height: 50),
                    
                        // Submit Button
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: context.width * 0.2),
                          child: PrimaryButton(
                            text: 'Submit', 
                            color: AppColors.mainColor,
                            width: context.width * 0.5,
                            onTap: cubit.currentRequestType == 'OverTime' ? () => cubit.submitRequestOvertime(context) : () => cubit.submitRequest(context),
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
                if (cubit.leavesLoading)
                const LoadingWidget(),
              ],
            ),
          );
        },
      ),
    );
  }
}