import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/utils/colors.dart';
import '../../../core/widgets/custom_drop_down_field.dart';
import '../../../core/widgets/loading_widget.dart';
import '../../../core/widgets/primary_button.dart';
import '../components/email_component.dart';
import '../view_model/cubit/emails_cubit.dart';
import 'email_details_screen.dart';
import 'email_compose_screen.dart';

class EmailInboxScreen extends StatelessWidget {
  const EmailInboxScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EmailCubit()..getEmails(context),
      child: BlocBuilder<EmailCubit, EmailState>(
        builder: (context, state) {
          var cubit = EmailCubit.get(context);
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              title: Text('Email', style: TextStyle(color: AppColors.mainColor)),
              leading: IconButton(
                icon: Icon(Icons.arrow_back_ios, color: AppColors.mainColor),
                onPressed: () => Navigator.pop(context),
              ),
              backgroundColor: Colors.white,
              actions: [
                IconButton(
                  icon: Icon(Icons.filter_list, color: AppColors.mainColor),
                  onPressed: () => cubit.toggleFilter(),
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
                              'Date Range',
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
                            Text(
                              'Email Type',
                              style: TextStyle(
                                fontSize: 16,
                                color: AppColors.darkColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            CustomDropdownFormField(
                              hintText: 'Email Type',
                              value: cubit.selectedEmailType,
                              items: const [
                                DropdownMenuItem(value: 'All', child: Text('All')),
                                DropdownMenuItem(value: 'Inbox', child: Text('Inbox')),
                                DropdownMenuItem(value: 'Sent', child: Text('Sent')),
                                DropdownMenuItem(value: 'Drafts', child: Text('Drafts')),
                              ],
                              onChanged: (value) => cubit.changeEmailType(value),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: Row(
                                    children: [
                                      Checkbox(
                                        value: cubit.showUnreadOnly,
                                        onChanged: (value) => cubit.toggleUnreadFilter(),
                                        activeColor: AppColors.mainColor,
                                      ),
                                      Text(
                                        'Unread Only',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: AppColors.darkColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Row(
                                    children: [
                                      Checkbox(
                                        value: cubit.showStarredOnly,
                                        onChanged: (value) => cubit.toggleStarredFilter(),
                                        activeColor: AppColors.mainColor,
                                      ),
                                      Text(
                                        'Starred Only',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: AppColors.darkColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Center(
                              child: PrimaryButton(
                                text: 'Apply Filters',
                                onTap: () => cubit.applyFilters(context),
                                color: AppColors.mainColor.withValues(alpha: 0.8),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Emails List
                    Expanded(
                      child: cubit.filteredEmails.isEmpty && !cubit.loading
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.email,
                                  size: 64,
                                  color: AppColors.mainColor.withValues(alpha: 0.5),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'No emails found',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: AppColors.darkColor,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : RefreshIndicator(
                            onRefresh: () async => cubit.getEmails(context),
                            child: ListView.builder(
                              padding: const EdgeInsets.only(top: 16, bottom: 16),
                              itemCount: cubit.filteredEmails.length,
                              itemBuilder: (context, index) {
                                final email = cubit.filteredEmails[index];
                                return EmailComponent(
                                  email: email,
                                  onTap: () {
                                    cubit.selectEmail(email);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => EmailDetailsScreen(email: email),
                                      ),
                                    );
                                  },
                                  onStarTap: () => cubit.toggleStarred(context, email),
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
            floatingActionButton: FloatingActionButton(
              backgroundColor: AppColors.mainColor,
              child: const Icon(Icons.edit, color: Colors.white),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const EmailComposeScreen(),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}