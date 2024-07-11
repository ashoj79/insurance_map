import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insurance_map/core/app_navigator.dart';
import 'package:insurance_map/core/routes.dart';
import 'package:insurance_map/core/widget/show_snackbar.dart';
import 'package:insurance_map/core/widget/wait_alert_dialog.dart';
import 'package:insurance_map/data/remote/model/insurance_company.dart';
import 'package:insurance_map/screens/companies/bloc/companies_bloc.dart';

class CompaniesScreen extends StatelessWidget {
  const CompaniesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    BuildContext? _alertContext;

    return BlocConsumer<CompaniesBloc, CompaniesState>(
      listener: (context, state) {
        if (state is CompaniesError) {
          showWaitDialog(context, (p0) => _alertContext=p0);
        } else if (_alertContext != null) {
          Navigator.of(_alertContext!).pop();
          _alertContext = null;
        }

        if (state is CompaniesError) showSnackBar(context, state.message);
      },
      builder: (context, state) {
        List<InsuranceCompany> companies = state is CompaniesShow ? state.companies : [];

        return Container(
          decoration: const BoxDecoration(
            color: Color(0xFFF3F7FA)
          ),
          child: ListView.builder(
            itemCount: companies.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  AppNavigator.push(Routes.mapRoute, args: {'type': 'insurance', 'id': companies[index].id});
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12)
                  ),
                  child: Row(
                    textDirection: TextDirection.rtl,
                    children: [
                      if (companies[index].logo.isNotEmpty) Image.network(companies[index].logo, width: 32, height: 32,),
                      const SizedBox(width: 16,),
                      Text(companies[index].name, style: const TextStyle(color: Colors.black),)
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
