import 'package:flutter/material.dart';
import 'package:smart_vision/core/utils/media_query_values.dart';

import '../../../core/helper/data_helper.dart';
import '../../../core/utils/colors.dart';
import '../model/salary_details_model.dart';

class ProfileSalaryDetailsScreen extends StatelessWidget {
  final SalaryDetailsModel salaryDetailsModel;
  const ProfileSalaryDetailsScreen({super.key, required this.salaryDetailsModel});

  @override
  Widget build(BuildContext context) {
    final instance = DataHelper.instance;
    return Scaffold(
      appBar: AppBar(
        title: Text('My Salaries', style: TextStyle(color: AppColors.mainColor)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: AppColors.mainColor),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Image.asset('assets/images/home_logo.png', width: 40, height: 40),
          const SizedBox(width: 15),
        ],
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 30, right: 30, top: 30),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 35,
                    backgroundColor: Colors.grey.shade300,
                    child: const Icon(Icons.person, size: 50, color: Colors.white),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(instance.name ?? '', style: TextStyle(color: AppColors.mainColor, fontSize: 20)),
                      const SizedBox(height: 2),
                      Text(instance.userId ?? ''),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Bank Name', style: TextStyle(color: AppColors.darkColor, fontSize: 16)),
                  Text(salaryDetailsModel.bankName, style: TextStyle(color: AppColors.darkColor, fontSize: 16)),
                ],
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Bank Account number', style: TextStyle(color: AppColors.darkColor, fontSize: 16)),
                  Text(salaryDetailsModel.bankAccountNo, style: TextStyle(color: AppColors.darkColor, fontSize: 16)),
                ],
              ),
              const SizedBox(height: 20),
              Divider(color: AppColors.mainColor),
              const SizedBox(height: 20),
              Text('Deduction', style: TextStyle(color: AppColors.mainColor, fontSize: 20)),
              const SizedBox(height: 15),
              ...salaryDetailsModel.deductionList.map((e) => Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: context.width * 0.5,
                        child: Text(
                          e.name, 
                          style: TextStyle(color: AppColors.darkColor, fontSize: 14), 
                          maxLines: 2, 
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(e.amount, style: TextStyle(color: AppColors.darkColor, fontSize: 14)),
                    ],
                  ),
                  const SizedBox(height: 15),
                ],
              )),
              const SizedBox(height: 5),
              Divider(color: AppColors.mainColor),
              const SizedBox(height: 20),
              Text('Earnings', style: TextStyle(color: AppColors.mainColor, fontSize: 20)),
              const SizedBox(height: 15),
              ...salaryDetailsModel.earningList.map((e) => Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: context.width * 0.5,
                        child: Text(
                          e.name, 
                          style: TextStyle(color: AppColors.darkColor, fontSize: 14), 
                          maxLines: 2, 
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(e.amount, style: TextStyle(color: AppColors.darkColor, fontSize: 14)),
                    ],
                  ),
                  const SizedBox(height: 15),
                ],
              )),
              const SizedBox(height: 5),
              Divider(color: AppColors.mainColor),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Gross Amount', style: TextStyle(color: AppColors.darkColor, fontSize: 16)),
                  Text(salaryDetailsModel.grossAmount, style: TextStyle(color: AppColors.darkColor, fontSize: 16)),
                ],
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Net Amount', style: TextStyle(color: AppColors.darkColor, fontSize: 16)),
                  Text(salaryDetailsModel.netAmount, style: TextStyle(color: AppColors.darkColor, fontSize: 16)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}