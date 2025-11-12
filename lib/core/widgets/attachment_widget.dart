import 'dart:io';

import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

class AttachmentWidget extends StatelessWidget {
  final String fileUrl;
  const AttachmentWidget({super.key, required this.fileUrl});

  @override
  Widget build(BuildContext context) {
    final fileType = _getFileType(fileUrl);
    return GestureDetector(
      onTap: () => openFileUrl(fileUrl),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade300),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.2),
              blurRadius: 6,
              offset: const Offset(2, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _getFileTypeColor(fileType).withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _getFileTypeIcon(fileType),
                color: _getFileTypeColor(fileType),
                size: 36,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                fileUrl.split('/').last,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 14),
                maxLines: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getFileType(String url) {
    final lower = url.toLowerCase();
    if (lower.endsWith('.pdf')) return 'pdf';
    if (lower.endsWith('.jpg') ||
        lower.endsWith('.jpeg') ||
        lower.endsWith('.png') ||
        lower.endsWith('.gif') ||
        lower.endsWith('.webp')) { return 'image'; }
    if (lower.endsWith('.doc') || lower.endsWith('.docx')) return 'doc';
    if (lower.endsWith('.xls') || lower.endsWith('.xlsx')) return 'excel';
    return 'other';
  }

  IconData _getFileTypeIcon(String type) {
    switch (type) {
      case 'pdf':
        return Icons.picture_as_pdf_rounded;
      case 'image':
        return Icons.image_rounded;
      case 'doc':
        return Icons.description_rounded;
      case 'excel':
        return Icons.table_chart_rounded;
      default:
        return Icons.insert_drive_file_rounded;
    }
  }

  Color _getFileTypeColor(String type) {
    switch (type) {
      case 'pdf':
        return Colors.redAccent;
      case 'image':
        return Colors.blueAccent;
      case 'doc':
        return Colors.indigoAccent;
      case 'excel':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  Future<void> openFileUrl(String url) async {
    try {
      final uri = Uri.parse(url);
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final dir = await getTemporaryDirectory();
        final filePath = '${dir.path}/${url.split('/').last}';
        final file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);

        await OpenFilex.open(file.path);
      } else {
        throw 'Failed to download file';
      }
    } catch (e) {
      debugPrint('Error opening file: $e');
    }
  }
}