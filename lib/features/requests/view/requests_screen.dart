import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/helper/data_helper.dart';
import '../../../core/widgets/base_scaffold.dart';
import '../../../core/widgets/filter_panel.dart';
import '../../../core/widgets/loading_widget.dart';
import '../../../core/widgets/secondary_app_bar.dart';
import '../components/approval_record.dart';
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
          return BaseScaffold(
            currentNavIndex: 0,
            appBar: SecondaryAppBar(
              title: 'Request Approval',
              notificationCount: DataHelper.unreadNotificationCount,
            ),
            body: SafeArea(
              child: Stack(
                children: [
                  RefreshIndicator(
                    onRefresh: () => cubit.getRequests(context),
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.pagePaddingHorizontal,
                        vertical: AppSpacing.pagePaddingVertical,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FilterPanel(
                            pageTitle: 'Request Approval',
                            pageSubtitle: 'View and filter your requests',
                            typeLabel: 'Request Type',
                            typeOptions: const [
                              'All',
                              'Overtime Request',
                              'Leave Application',
                              'Shift Request',
                            ],
                            showNeedActionCheckbox: true,
                            onFilter: (from, to, type, status, needAction) => cubit.getRequests(context, from, to, type, needAction),
                          ),
                          const SizedBox(height: AppSpacing.sectionMargin),
                          if(cubit.requests.isNotEmpty)
                          ...cubit.requests.map((req) {
                            return ApprovalRecord(
                              requestType: req.requestType,
                              status: req.status,
                              employeeName: req.employeeName,
                              date: (req.endDate != null) ? '${req.startDate} to ${req.endDate}' : req.startDate,
                              description: req.reason ?? '',
                              submitted: req.startDate,
                              hasAttachment: req.attachUrl != null,
                              attachmentName: req.attachUrl != null ? req.attachUrl!.split('/').last : '',
                              showActions: req.showActions,
                              onApprove: () => cubit.updateRequest(context, req, 'Approved'),
                              onReject: () => cubit.updateRequest(context, req, 'Rejected'),
                            );
                          }),
                          const SizedBox(height: 16),
                          Text(
                            'Showing ${cubit.requests.length} of ${cubit.requests.length} requests',
                            style: AppTypography.helperTextSmall(),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if(state is RequestsLoading) const LoadingWidget(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}