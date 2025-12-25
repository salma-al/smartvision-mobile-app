import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../core/constants/app_constants.dart';
import '../../check_in_out/view/sign_in_out_screen.dart';

class SignInOutCard extends StatelessWidget {
  final bool isCheckedIn;
  final String checkInTime;
  final VoidCallback onPopOut;

  const SignInOutCard({
    super.key, 
    required this.isCheckedIn, 
    required this.checkInTime, 
    required this.onPopOut,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => PopScope(
          onPopInvokedWithResult: (didPop, result) async {
            if(didPop) onPopOut();
          },
          child: const SignInOutScreen(),
        )));
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppBorderRadius.radius12),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: isCheckedIn ? const Color(0xFF197744) : const Color(0xFF9C1922),
            borderRadius: BorderRadius.circular(AppBorderRadius.radius12),
            boxShadow: AppShadows.checkInShadow,
          ),
          child: Stack(
            children: [
              Positioned(
                top: -4,
                right: 0,
                child: SvgPicture.asset(
                  'assets/images/cta_bg.svg',
                  fit: BoxFit.none,
                ),
              ),
              // Content with padding
              Padding(
                padding: const EdgeInsets.all(15),
                child: Row(
                  children: [
                    Container(
                      width: 63,
                      height: 63,
                      decoration: BoxDecoration(
                        color: AppColors.white.withValues(alpha: 0.38),
                        borderRadius: BorderRadius.circular(AppBorderRadius.radius14),
                      ),
                      child: Center(
                        child: SvgPicture.asset(
                          'assets/images/check_in.svg',
                          width: 40,
                          height: 40,
                          colorFilter: const ColorFilter.mode(
                            AppColors.white,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isCheckedIn ? 'Checked in' : 'Check in',
                            style: isCheckedIn ? AppTypography.checkInStatus() : AppTypography.checkInTime(),
                          ),
                          if (isCheckedIn)
                            Text(
                              checkInTime,
                              style: AppTypography.checkInTime(),
                            ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.arrow_forward_ios,
                      color: AppColors.white,
                      size: 16,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}