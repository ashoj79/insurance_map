import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insurance_map/core/widget/show_snackbar.dart';
import 'package:insurance_map/core/widget/wait_alert_dialog.dart';
import 'package:insurance_map/data/remote/model/vehicle.dart';
import 'package:insurance_map/screens/insurance_request/bloc/insurance_request_bloc.dart';
import 'package:insurance_map/utils/extensions_method.dart';

class InsuranceRequestScreen extends StatefulWidget {
  const InsuranceRequestScreen({super.key});

  @override
  State<InsuranceRequestScreen> createState() => _InsuranceRequestScreenState();
}

class _InsuranceRequestScreenState extends State<InsuranceRequestScreen> {
  BuildContext? alertContext;
  String selectedVehicleId = '';
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();

    BlocProvider.of<InsuranceRequestBloc>(context).add(InsuranceRequestGetVehicles());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<InsuranceRequestBloc, InsuranceRequestState>(
      buildWhen: (previous, current) => current is InsuranceRequestShowVehicles,
      listener: (context, state) {
        if (state is InsuranceRequestLoading) {
          showWaitDialog(context, (p0) => alertContext = p0);
        } else if (alertContext != null) {
          Navigator.of(alertContext!).pop();
          alertContext = null;
        }

        if (state is InsuranceRequestError) showSnackBar(context, state.message);
      },
      builder: (context, state) {
        if (state is! InsuranceRequestShowVehicles) return const SizedBox();

        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              DropdownButton(
                value: selectedVehicleId,
                isExpanded: true,
                items: [
                  const DropdownMenuItem(
                    value: '',
                    child: Text('انتخاب وسیله نقلیه'),
                  ),
                  for (Vehicle v in state.vehicles)
                    DropdownMenuItem(
                      value: v.id,
                      child: v.license.toLicenseWidget(),
                    )
                ],
                onChanged: (value) {
                  setState(() {
                    selectedVehicleId = value!;
                  });
                },
              ),
              const SizedBox(height: 16),
              Directionality(
                textDirection: TextDirection.rtl,
                child: TextField(
                  controller: _controller,
                  decoration: const InputDecoration(
                    labelText: 'توضیحات',
                  ),
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                ),
              ),
              const Expanded(child: SizedBox()),
              OutlinedButton(
                  style: OutlinedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 48)),
                  onPressed: () {
                    BlocProvider.of<InsuranceRequestBloc>(context).add(InsuranceRequestSend(id: selectedVehicleId, description: _controller.text));
                  },
                  child: Text(
                    'ثبت درخواست',
                    style: TextStyle(color: Colors.grey[700]),
                  ))
            ],
          ),
        );
      },
    );
  }
}
