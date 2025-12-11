import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../constants/app_constants.dart';

class AttachmentCard extends StatelessWidget {
  final String fileName;
  final String fileType;
  final VoidCallback? onDownload;

  const AttachmentCard({
    super.key,
    required this.fileName,
    required this.fileType,
    this.onDownload,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.backgroundColor,
        borderRadius: BorderRadius.circular(AppBorderRadius.radius8),
      ),
      child: Row(
        children: [
          // Attachment Icon
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.greyText,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(
              child: Icon(
                Icons.attach_file,
                color: AppColors.white,
                size: 24,
              ),
            ),
          ),
          const SizedBox(width: 12),
          
          // File Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  fileName,
                  style: AppTypography.p14(),
                ),
                const SizedBox(height: 2),
                Text(
                  fileType,
                  style: AppTypography.helperTextSmall(),
                ),
              ],
            ),
          ),
          
          // Download Button
          IconButton(
            icon: SvgPicture.asset(
              'assets/icons/download.svg',
              width: 24,
              height: 24,
              colorFilter: const ColorFilter.mode(
                AppColors.unreadDot,
                BlendMode.srcIn,
              ),
            ),
            onPressed: onDownload ??
                () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Downloading file...')),
                  );
                },
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }
}

