import 'package:flutter/material.dart';
import 'package:insurance_map/core/app_navigator.dart';
import 'package:insurance_map/core/routes.dart';
import 'package:insurance_map/data/local/signup_types.dart';

class IntroScreen extends StatelessWidget {
  const IntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                AppNavigator.push(Routes.signupRoute, args: SignupTypes.marketers);
              },
              child: const Text('ثبت نام بازاریابان'),
            ),
            const SizedBox(height: 16,),
            ElevatedButton(
              onPressed: () {
                AppNavigator.push(Routes.signupRoute, args: SignupTypes.businesses);
              },
              child: const Text('ثبت نام کسب و کارها'),
            ),
            const SizedBox(height: 16,),
            ElevatedButton(
              onPressed: () {
                AppNavigator.push(Routes.signupRoute, args: SignupTypes.representatives);
              },
              child: const Text('ثبت نام نمایندگان بیمه'),
            ),
            const SizedBox(height: 16,),
            ElevatedButton(
              onPressed: () {
                AppNavigator.push(Routes.signupRoute, args: SignupTypes.vehicles);
              },
              child: const Text('ثبت نام وسایل نقلیه'),
            )
          ],
        ),
    );
  }
}