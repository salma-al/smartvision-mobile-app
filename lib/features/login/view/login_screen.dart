import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_vision/core/constants/app_constants.dart';
import 'package:smart_vision/core/widgets/loading_widget.dart';
import 'package:smart_vision/features/login/view_model/cubit/login_cubit.dart';

import '../../../core/widgets/toast_widget.dart';
import '../../home/view/home_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(),
      child: Scaffold(
        backgroundColor: const Color(0xFFE8ECEF),
        body: BlocConsumer<LoginCubit, LoginState>(
          listener: (context, state) {
            if(state is LoginError) {
              ToastWidget().showToast(state.message, context);
            } else if(state is LoginSuccess) {
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const HomeScreen()), (Route<dynamic> route) => false);
            }
          },
          builder: (context, state) {
            var cubit = LoginCubit.get(context);
            return Stack(
              children: [
                Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/SVEC_logo.png',
                          width: 80,
                          height: 80,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(height: 40),
                                  
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Welcome!',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w500,
                                  height: 36 / 24,
                                  color: AppColors.darkText,
                                  fontFamily: 'DM Sans',
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Sign in to access your account',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.lightText,
                                  fontFamily: 'DM Sans',
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 40),
                                  
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Email',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: AppColors.darkText,
                                fontFamily: 'DM Sans',
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: TextField(
                                controller: cubit.emailController,
                                keyboardType: TextInputType.emailAddress,
                                decoration: const InputDecoration(
                                  hintText: 'your.email@company.com',
                                  hintStyle: TextStyle(
                                    color: AppColors.helperText,
                                    fontSize: 14,
                                    fontFamily: 'DM Sans',
                                  ),
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 12,
                                  ),
                                ),
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: AppColors.darkText,
                                  fontFamily: 'DM Sans',
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                                  
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Password',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: AppColors.darkText,
                                fontFamily: 'DM Sans',
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: TextField(
                                controller: cubit.passwordController,
                                obscureText: cubit.obsecurePass,
                                decoration: InputDecoration(
                                  hintText: 'Enter your password',
                                  hintStyle: const TextStyle(
                                    color: AppColors.helperText,
                                    fontSize: 14,
                                    fontFamily: 'DM Sans',
                                  ),
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 12,
                                  ),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      cubit.obsecurePass
                                          ? Icons.visibility_outlined
                                          : Icons.visibility_off_outlined,
                                      color: AppColors.lightText,
                                      size: 20,
                                    ),
                                    onPressed: () => cubit.tooglePassword(),
                                  ),
                                ),
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: AppColors.darkText,
                                  fontFamily: 'DM Sans',
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                                  
                        Row(
                          children: [
                            Transform.translate(
                              offset: const Offset(-8, 0), // shifts checkbox left to align perfectly
                              child: Checkbox(
                                value: cubit.rememberMe,
                                onChanged: (value) => cubit.toggleSave(),
                                activeColor: AppColors.svecColor,
                                side: const BorderSide(color: AppColors.lightText),
                              ),
                            ),
                            const Text(
                              "Remember me",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: AppColors.darkText,
                                fontFamily: 'DM Sans',
                              ),
                            ),
                          ],
                        ),
                              
                        const SizedBox(height: 40),
                                  
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () => cubit.login(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.svecColor,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 0,
                            ),
                            child: const Text(
                              'Sign In',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppColors.white,
                                fontFamily: 'DM Sans',
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                                  
                        const Text(
                          'Need access? Contact your administrator',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: AppColors.helperText,
                            fontFamily: 'DM Sans',
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
                if(state is LoginLoading)
                const LoadingWidget(),
              ],
            );
          },
        ),
      ),
    );
  }
}