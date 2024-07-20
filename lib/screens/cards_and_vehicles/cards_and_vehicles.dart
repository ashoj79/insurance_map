import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insurance_map/core/app_navigator.dart';
import 'package:insurance_map/core/routes.dart';
import 'package:insurance_map/core/widget/show_snackbar.dart';
import 'package:insurance_map/core/widget/wait_alert_dialog.dart';
import 'package:insurance_map/screens/cards_and_vehicles/bloc/c_a_v_bloc.dart';
import 'package:insurance_map/utils/extensions_method.dart';

class CardsAndVehiclesScreen extends StatelessWidget {
  const CardsAndVehiclesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    BuildContext? alertContext;

    return BlocConsumer<CAVBloc, CAVState>(
      listener: (context, state) {
        if (state is CAVLoading) {
          showWaitDialog(context, (p0) => alertContext = p0);
        } else if (alertContext != null) {
          Navigator.of(alertContext!).pop();
          alertContext = null;
        }

        if (state is CAVError) showSnackBar(context, state.message);
      },
      builder: (context, state) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
          ),
          child: Column(
            children: [
              Row(
                textDirection: TextDirection.rtl,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('کارت های بانکی', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                  InkWell(
                    onTap: () {
                      AppNavigator.push(Routes.bankCardsRoute);
                    },
                    child: Icon(
                      Icons.add,
                      color: Colors.black,
                    ),
                  )
                ],
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: state is! CAVShowData ? SizedBox() : Column(
                    children: [
                      for (String val in state.cards)
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 4),
                          child: Text(val),
                        )
                    ],
                  ),
                ),
              ),
              Row(
                textDirection: TextDirection.rtl,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('وسایل نقلیه', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                  InkWell(
                    onTap: () {
                      AppNavigator.push(Routes.vehiclesRoute);
                    },
                    child: Icon(
                      Icons.add,
                      color: Colors.black,
                    ),
                  )
                ],
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: state is! CAVShowData ? SizedBox() : Column(
                    children: [
                      for (String val in state.vehicles)
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 4),
                          child: val.toLicenseWidget(),
                        )
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
