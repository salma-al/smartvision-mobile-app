import 'package:flutter/material.dart';

class FilePickerComponent extends StatelessWidget {
  final VoidCallback? onTap;
  final String? fileName;
  final String hint;
  final bool isLoading;
  final double? progress; // 0.0 - 1.0 or null

  const FilePickerComponent({
    super.key,
    this.onTap,
    this.fileName,
    this.hint = 'Tap to attach a file (pdf, docx, image)',
    this.isLoading = false,
    this.progress,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasFile = (fileName ?? '').isNotEmpty;

    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Card with dotted border
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  theme.colorScheme.surface,
                  theme.colorScheme.surface.withValues(alpha: 0.98),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(14),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x11000000),
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: CustomPaint(
              painter: _DashRectPainter(
                strokeWidth: 1.5,
                gap: 6,
                color: theme.colorScheme.primary.withValues(alpha: 0.9),
                radius: 12,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
                child: Row(
                  children: [
                    // Icon circle
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [
                            theme.colorScheme.primary,
                            theme.colorScheme.primaryContainer,
                          ],
                        ),
                      ),
                      child: Icon(
                        hasFile ? Icons.insert_drive_file_rounded : Icons.attach_file_rounded,
                        color: Colors.white,
                        size: 26,
                      ),
                    ),

                    const SizedBox(width: 14),

                    // Texts
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            hasFile ? fileName! : 'Attach file',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            hasFile ? 'Tap to change' : hint,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.7),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Trailing: either filename size / arrow or progress
                    if (!isLoading)
                      Row(
                        children: [
                          Icon(
                            Icons.keyboard_arrow_right_rounded,
                            color: theme.iconTheme.color?.withValues(alpha: 0.6),
                          ),
                        ],
                      )
                    else
                      // small circular progress with percent
                      _SmallProgressIndicator(progress: progress),
                  ],
                ),
              ),
            ),
          ),

          // Optional overlay when loading: slightly dark overlay (unobtrusive)
          if (isLoading)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Small circular progress indicator with percent text inside.
/// If progress == null, show an indeterminate CircularProgressIndicator.
class _SmallProgressIndicator extends StatelessWidget {
  final double? progress;
  const _SmallProgressIndicator({this.progress});

  @override
  Widget build(BuildContext context) {
    const  size = 48.0;
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              value: progress,
              strokeWidth: 3.0,
            ),
          ),
          if (progress != null)
            Text(
              '${(progress! * 100).clamp(0, 100).toInt()}%',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold),
            )
          else
            const SizedBox.shrink(),
        ],
      ),
    );
  }
}

/// Painter that draws a dashed rounded rectangle.
class _DashRectPainter extends CustomPainter {
  final double strokeWidth;
  final double gap;
  final Color color;
  final double radius;

  _DashRectPainter({
    this.strokeWidth = 1.5,
    this.gap = 6,
    this.color = Colors.black,
    this.radius = 12,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0 + strokeWidth / 2, 0 + strokeWidth / 2, size.width - strokeWidth, size.height - strokeWidth);
    final rrect = RRect.fromRectAndRadius(rect, Radius.circular(radius));
    final path = Path()..addRRect(rrect);

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    // create dashed path
    final dashPath = _createDashedPath(path, dashWidth: gap / 2, gapWidth: gap);
    canvas.drawPath(dashPath, paint);
  }

  Path _createDashedPath(Path source, {required double dashWidth, required double gapWidth}) {
    final dest = Path();
    for (final metric in source.computeMetrics()) {
      double distance = 0.0;
      while (distance < metric.length) {
        final next = distance + dashWidth;
        dest.addPath(metric.extractPath(distance, next.clamp(0.0, metric.length)), Offset.zero);
        distance = next + gapWidth;
      }
    }
    return dest;
  }

  @override
  bool shouldRepaint(covariant _DashRectPainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.gap != gap || oldDelegate.radius != radius;
  }
}
