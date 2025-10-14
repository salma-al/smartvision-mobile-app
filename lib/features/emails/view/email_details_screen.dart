import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../core/utils/colors.dart';
import '../../../core/widgets/loading_widget.dart';
import '../components/attachment_component.dart';
import '../model/email_model.dart';
import '../view_model/cubit/emails_cubit.dart';
import 'email_compose_screen.dart';

class EmailDetailsScreen extends StatelessWidget {
  final EmailModel email;

  const EmailDetailsScreen({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EmailCubit()..selectedEmail = email,
      child: BlocBuilder<EmailCubit, EmailState>(
        builder: (context, state) {
          var cubit = EmailCubit.get(context);
          final currentEmail = cubit.selectedEmail ?? email;
          
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
                  icon: Icon(
                    currentEmail.isStarred ? Icons.star : Icons.star_border,
                    color: currentEmail.isStarred ? Colors.amber : AppColors.mainColor,
                  ),
                  onPressed: () => cubit.toggleStarred(context, currentEmail),
                ),
                Image.asset('assets/images/home_logo.png', width: 40, height: 40),
                const SizedBox(width: 15),
              ],
            ),
            body: Stack(
              children: [
                SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Subject
                      Text(
                        currentEmail.subject,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.mainColor,
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      // Sender info and date
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: AppColors.mainColor.withValues(alpha: 0.2),
                            child: Text(
                              currentEmail.senderName.isNotEmpty
                                  ? currentEmail.senderName[0].toUpperCase()
                                  : '?',
                              style: TextStyle(
                                color: AppColors.mainColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  currentEmail.senderName,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.darkColor,
                                  ),
                                ),
                                Text(
                                  currentEmail.senderEmail,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppColors.darkColor.withValues(alpha: 0.7),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            DateFormat('MMM d, yyyy h:mm a').format(currentEmail.date),
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.darkColor.withValues(alpha: 0.7),
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Recipients
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'To: ${currentEmail.recipientEmails.join(', ')}',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.darkColor,
                              ),
                            ),
                            if (currentEmail.ccEmails != null && currentEmail.ccEmails!.isNotEmpty) ...[  
                              const SizedBox(height: 4),
                              Text(
                                'CC: ${currentEmail.ccEmails!.join(', ')}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.darkColor,
                                ),
                              ),
                            ],
                            if (currentEmail.bccEmails != null && currentEmail.bccEmails!.isNotEmpty) ...[  
                              const SizedBox(height: 4),
                              Text(
                                'BCC: ${currentEmail.bccEmails!.join(', ')}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.darkColor,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Email body
                      Text(
                        currentEmail.body,
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.darkColor,
                          height: 1.5,
                        ),
                      ),
                      
                      // Signature if present
                      if (currentEmail.signature != null) ...[  
                        const SizedBox(height: 24),
                        const Divider(),
                        const SizedBox(height: 8),
                        currentEmail.isSignatureImage
                            ? Image.network(
                                currentEmail.signature!,
                                height: 60,
                                errorBuilder: (context, error, stackTrace) => Text(
                                  'Signature image',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontStyle: FontStyle.italic,
                                    color: AppColors.darkColor.withValues(alpha: 0.7),
                                  ),
                                ),
                              )
                            : Text(
                                currentEmail.signature!,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontStyle: FontStyle.italic,
                                  color: AppColors.darkColor.withValues(alpha: 0.7),
                                ),
                              ),
                      ],
                      
                      // Attachments
                      if (currentEmail.attachments != null && currentEmail.attachments!.isNotEmpty) ...[  
                        const SizedBox(height: 24),
                        Text(
                          'Attachments (${currentEmail.attachments!.length})',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.mainColor,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ...currentEmail.attachments!.map((attachment) => AttachmentComponent(
                          attachment: attachment,
                          onDownload: () => cubit.downloadAttachment(context, attachment),
                          // onView: () => cubit.openAttachmentOnline(context, attachment),
                          onView: () {},
                        )),
                      ],
                    ],
                  ),
                ),
                if (cubit.loading) const LoadingWidget(),
              ],
            ),
            bottomNavigationBar: BottomAppBar(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildActionButton(
                      icon: Icons.reply,
                      label: 'Reply',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EmailComposeScreen(
                              replyTo: currentEmail,
                              isReplyAll: false,
                            ),
                          ),
                        );
                      },
                    ),
                    _buildActionButton(
                      icon: Icons.reply_all,
                      label: 'Reply All',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EmailComposeScreen(
                              replyTo: currentEmail,
                              isReplyAll: true,
                            ),
                          ),
                        );
                      },
                    ),
                    _buildActionButton(
                      icon: Icons.forward,
                      label: 'Forward',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EmailComposeScreen(
                              forwardFrom: currentEmail,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: AppColors.mainColor),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: AppColors.mainColor,
            ),
          ),
        ],
      ),
    );
  }
}