import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_persian_calendar/flutter_persian_calendar.dart';
import 'package:insurance_map/core/widget/show_snackbar.dart';
import 'package:insurance_map/core/widget/wait_alert_dialog.dart';
import 'package:insurance_map/data/remote/model/insurance_company.dart';
import 'package:insurance_map/data/remote/model/vehicle.dart';
import 'package:insurance_map/screens/insurance_request/bloc/insurance_request_bloc.dart';
import 'package:insurance_map/utils/extensions_method.dart';
import 'package:shamsi_date/shamsi_date.dart';

class InsuranceRequestScreen extends StatefulWidget {
  const InsuranceRequestScreen({super.key});

  @override
  State<InsuranceRequestScreen> createState() => _InsuranceRequestScreenState();
}

class _InsuranceRequestScreenState extends State<InsuranceRequestScreen> {
  BuildContext? alertContext;
  String selectedVehicleId = '', selectedCompany = '', selectedType = '';
  final _descriptionController = TextEditingController(), _dateController = TextEditingController();

  @override
  void initState() {
    super.initState();

    BlocProvider.of<InsuranceRequestBloc>(context).add(InsuranceRequestGetData());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<InsuranceRequestBloc, InsuranceRequestState>(
      buildWhen: (previous, current) => current is InsuranceRequestShowData,
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
        if (state is! InsuranceRequestShowData) return const SizedBox();

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
                      alignment: Alignment.center,
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
              DropdownButton(
                value: selectedCompany,
                isExpanded: true,
                items: [
                  const DropdownMenuItem(
                    value: '',
                    child: Text('انتخاب شرکت بیمه'),
                  ),
                  for (InsuranceCompany c in state.companies)
                    DropdownMenuItem(
                      value: c.id,
                      child: Text(c.name),
                    )
                ],
                onChanged: (value) {
                  setState(() {
                    selectedCompany = value!;
                  });
                },
              ),
              const SizedBox(height: 16),
              DropdownButton(
                value: selectedType,
                isExpanded: true,
                items: const [
                  DropdownMenuItem(
                    value: '',
                    child: Text('انتخاب نوع بیمه'),
                  ),
                  DropdownMenuItem(
                    value: 'body',
                    child: Text('بیمه بدنه'),
                  ),
                  DropdownMenuItem(
                    value: 'third_party',
                    child: Text('بیمه شخص ثالث'),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    selectedType = value!;
                  });
                },
              ),
              const SizedBox(height: 16),
              Directionality(
                textDirection: TextDirection.rtl,
                child: TextField(
                  controller: _dateController,
                  decoration: const InputDecoration(
                    labelText: 'تاریخ انقضای بیمه',
                  ),
                  onTap: () => _showDatePicker(),
                ),
              ),
              const SizedBox(height: 16),
              Directionality(
                textDirection: TextDirection.rtl,
                child: TextField(
                  controller: _descriptionController,
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
                    BlocProvider.of<InsuranceRequestBloc>(context).add(InsuranceRequestSend(id: selectedVehicleId, description: _descriptionController.text, companyId: selectedCompany, insuranceType: selectedType, date: _dateController.text));
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

  Future<void> _showDatePicker() async {
    showDialog(context: context, builder: (context) {
      return Dialog(child: shamsiDateCalendarWidget(context));
    });
  }

  PersianCalendar shamsiDateCalendarWidget(BuildContext context) {
    Jalali? picked;

    return PersianCalendar(
        height: 376,
        onDateChanged: (newDate) {
          picked = newDate;
        },
        confirmButton: ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
            if (picked == null) return;

            _dateController.text =
            '${picked?.year}/${picked?.month.toString().padLeft(2, '0')}/${picked?.day.toString().padLeft(2, '0')}';
          },
          child: const Text('تائید'),
        ),
        startingDate: Jalali(1300),
        endingDate: Jalali.max,
        backgroundColor: Colors.white,
        initialDate: Jalali.now()
    );
  }
}
