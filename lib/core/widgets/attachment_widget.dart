// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:smart_vision/core/helper/data_helper.dart';
import 'package:smart_vision/core/widgets/toast_widget.dart';
import '../constants/app_constants.dart';

class AttachmentWidget extends StatelessWidget {
  final String url;

  const AttachmentWidget({super.key, required this.url});

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
                  url.split('/').last,
                  style: AppTypography.p14(),
                ),
                const SizedBox(height: 2),
                Text(
                  url.split('.').last,
                  style: AppTypography.helperTextSmall(),
                ),
              ],
            ),
          ),
          
          // Download Button
          IconButton(
            icon: SvgPicture.asset(
              'assets/images/download.svg',
              width: 24,
              height: 24,
              colorFilter: const ColorFilter.mode(
                AppColors.unreadDot,
                BlendMode.srcIn,
              ),
            ),
            onPressed: () => openFileUrl(context, url),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }

  Future<void> openFileUrl(BuildContext context, String url) async {
    try {
      final uri = Uri.parse(url);
      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Cookie' : 'sid=${DataHelper.instance.token}'
      };
      final response = await http.get(uri, headers: headers);

      if (response.statusCode == 200) {
        final dir = await getTemporaryDirectory();
        final filePath = '${dir.path}/${url.split('/').last}';
        final file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);

        await OpenFilex.open(file.path);
      } else {
        ToastWidget().showToast('Failed to download file', context);
      }
    } catch (e) {
      ToastWidget().showToast('Can\'t open this file', context);
    }
  }
}