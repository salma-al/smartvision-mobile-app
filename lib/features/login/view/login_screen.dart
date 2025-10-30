import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_vision/core/utils/colors.dart';
import 'package:smart_vision/core/utils/media_query_values.dart';
import 'package:smart_vision/core/widgets/custom_text_form_feild.dart';
import 'package:smart_vision/core/widgets/loading_widget.dart';
import 'package:smart_vision/core/widgets/primary_button.dart';
import 'package:smart_vision/features/login/view_model/cubit/login_cubit.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit()..getEmailAndPass(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: BlocBuilder<LoginCubit, LoginState>(
          builder: (context, state) {
            var cubit = LoginCubit.get(context);
            return Stack(
              children: [
                Container(
                  height: context.height,
                  padding: const EdgeInsets.only(left: 16, right: 16, top: 50),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset('assets/images/main_logo.png', height: context.height * 0.17, width: context.width * 0.5, fit: BoxFit.contain),
                        const SizedBox(height: 80),
                        Text(
                          'Login to your account',
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w500,
                            color: AppColors.mainColor,
                          ),
                        ),
                        const SizedBox(height: 40),
                        // Email TextField
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(35),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withValues(alpha: 0.5),
                                spreadRadius: 2,
                                blurRadius: 4,
                                offset: const Offset(3, 4),
                              ),
                            ]
                          ),
                          child: CustomTextFormField(
                            hintText: 'Email', 
                            controller: cubit.emailController,
                            keyboardType: TextInputType.emailAddress,
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Password TextField
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(35),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withValues(alpha: 0.5),
                                spreadRadius: 2,
                                blurRadius: 4,
                                offset: const Offset(3, 4),
                              ),
                            ]
                          ),
                          child: CustomTextFormField(
                            hintText: 'Password', 
                            controller: cubit.passwordController,
                            isObscureText: cubit.showPass,
                            keyboardType: TextInputType.visiblePassword,
                            suffixIcon: IconButton(
                              onPressed: () => cubit.tooglePassword(), 
                              icon: Icon(cubit.showPass ? Icons.visibility : Icons.visibility_off, color: AppColors.mainColor),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        // checkbox save email and password
                        Row(
                          children: [
                            Checkbox(
                              value: cubit.saveEmailAndPassword, 
                              onChanged: (val) => cubit.toggleSave(),
                              checkColor: Colors.white,
                              activeColor: AppColors.mainColor,
                              side: BorderSide(color: AppColors.mainColor),
                            ),
                            Text('Save email and password', style: TextStyle(color: AppColors.mainColor)),
                          ],
                        ),
                        const SizedBox(height: 16),
                        // Login Button
                        PrimaryButton(
                          text: 'Sign in', 
                          onTap: () => cubit.login(context), 
                          color: AppColors.mainColor,
                          width: context.width * 0.6,
                        ),
                      ],
                    ),
                  ),
                ),
                if(cubit.loginLoading)
                const LoadingWidget(),
              ],
            );
          },
        ),
      ),
    );
  }
}