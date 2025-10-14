import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/utils/colors.dart';
import '../../../core/widgets/custom_drop_down_field.dart';
import '../../../core/widgets/loading_widget.dart';
import '../../../core/widgets/primary_button.dart';
import '../components/request_component.dart';
import '../view_model/cubit/requests_cubit.dart';

class RequestsScreen extends StatelessWidget {
  const RequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RequestsCubit()..getRequests(context),
      child: BlocBuilder<RequestsCubit, RequestsState>(
        builder: (context, state) {
          var cubit = RequestsCubit.get(context);
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              title: Text('Requests', style: TextStyle(color: AppColors.mainColor)),
              leading: IconButton(
                icon: Icon(Icons.arrow_back_ios, color: AppColors.mainColor),
                onPressed: () => Navigator.pop(context),
              ),
              backgroundColor: Colors.white,
              actions: [
                IconButton(
                  icon: Icon(Icons.filter_list, color: AppColors.mainColor),
                  onPressed: () => context.read<RequestsCubit>().toggleFilter(),
                ),
                Image.asset('assets/images/home_logo.png', width: 40, height: 40),
                const SizedBox(width: 15),
              ],
            ),
            body: Stack(
              children: [
                Column(
                  children: [
                    // Collapsible Filter Section
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      height: cubit.isFilterExpanded ? null : 0,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withValues(alpha: 0.2),
                              spreadRadius: 1,
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Date',
                              style: TextStyle(
                                fontSize: 16,
                                color: AppColors.darkColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Expanded(
                                  child: PrimaryButton(
                                    text: cubit.fromDate != null ? cubit.fromDate! : 'From Date',
                                    onTap: () => cubit.selectDate(context, true),
                                    color: Colors.grey.withValues(alpha: 0.2),
                                    textColor: Colors.grey,
                                  ),
                                ),
                                const SizedBox(width: 20),
                                Expanded(
                                  child: PrimaryButton(
                                    text: cubit.toDate != null ? cubit.toDate! : 'To Date',
                                    onTap: () => cubit.selectDate(context, false),
                                    color: Colors.grey.withValues(alpha: 0.2),
                                    textColor: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            CustomDropdownFormField(
                              hintText: 'Request Type',
                              value: cubit.selectedRequestType,
                              items: const [
                                DropdownMenuItem(value: 'All', child: Text('All')),
                                DropdownMenuItem(value: 'Leave Request', child: Text('Leave Request')),
                                DropdownMenuItem(value: 'Shift Request', child: Text('Shift Request')),
                                DropdownMenuItem(value: 'Overtime Request', child: Text('Overtime Request')),
                              ],
                              onChanged: (value) => cubit.changeRequestType(value),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Checkbox(
                                  value: cubit.actionCheckBox,
                                  onChanged: (value) => cubit.toggleNeedAction(value ?? false),
                                  activeColor: AppColors.mainColor,
                                ),
                                Text(
                                  'Need Action',
                                  style: TextStyle(fontSize: 16, color: AppColors.darkColor),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Center(
                              child: PrimaryButton(
                                text: 'Apply filters',
                                onTap: () {
                                  cubit.getRequests(context);
                                  cubit.toggleFilter();
                                },
                                color: AppColors.mainColor.withValues(alpha: 0.8),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Requests List
                    Expanded(
                      child: cubit.filteredRequests.isEmpty && !cubit.loading
                        ? const Center(child: Text('No requests found'))
                        : RefreshIndicator(
                            onRefresh: () => cubit.getRequests(context),
                            child: ListView.builder(
                              padding: const EdgeInsets.only(top: 16, bottom: 16),
                              itemCount: cubit.filteredRequests.length,
                              itemBuilder: (context, index) {
                                final request = cubit.filteredRequests[index];
                                return RequestComponent(
                                  request: request,
                                  onApprove: (id) => cubit.updateRequest(context, request, 'Approved'),
                                  onReject: (id) => cubit.updateRequest(context, request, 'Rejected'),
                                );
                              },
                            ),
                          ),
                    ),
                  ],
                ),
                if (cubit.loading) const LoadingWidget(),
              ],
            ),
          );
        },
      ),
    );
  }
}