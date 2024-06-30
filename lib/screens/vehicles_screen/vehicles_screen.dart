import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insurance_map/core/widget/show_snackbar.dart';
import 'package:insurance_map/core/widget/wait_alert_dialog.dart';
import 'package:insurance_map/data/remote/model/vehicle_info.dart';
import 'package:insurance_map/screens/vehicles_screen/bloc/vehicles_bloc.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';

class VehiclesScreen extends StatefulWidget {
  const VehiclesScreen({super.key});

  @override
  State<VehiclesScreen> createState() => _VehiclesScreenState();
}

class _VehiclesScreenState extends State<VehiclesScreen> {
  int type = 1, carTypeId = 0, carModelId = 0, carBrandId = 0;
  bool carBodyInsurance = false, thirdPartyInsurance = false;
  List<VehicleInfo> carTypes = [], carModels = [], carBrands = [];
  final TextEditingController thirdPartyInsuranceDate =
          TextEditingController(text: ''),
      carBodyInsuranceDate = TextEditingController(text: '');
  final PlaqueController _plaqueController = PlaqueController();

  BuildContext? _alertContext;

  @override
  void initState() {
    super.initState();

    BlocProvider.of<VehiclesBloc>(context).add(VehiclesGetTypes());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<VehiclesBloc, VehiclesState>(
        listener: (context, state) {
          if (state is VehiclesLoading) {
            showWaitDialog(context, (p0) => _alertContext = p0);
          } else if (_alertContext != null) {
            Navigator.of(_alertContext!).pop();
            _alertContext = null;
          }

          if (state is VehiclesError) showSnackBar(context, state.message);

          if (state is VehiclesUpdateTypes) {
            setState(() {
              carTypes.clear();
              carTypes.addAll(state.types);
            });
          }

          if (state is VehiclesUpdateBrands) {
            setState(() {
              carBrandId = 0;
              carModelId = 0;
              carModels.clear();
              carBrands = state.brands;
            });
          }

          if (state is VehiclesUpdateModels) {
            setState(() {
              carModelId = 0;
              carModels = state.models;
            });
          }

          if (state is VehiclesSaved) {
            showSnackBar(context, 'وسیله نقلیه شما ذخیره شد');

            _plaqueController.clearLicense();
            setState(() {
              type = 1;
              carTypeId = 0;
              carModelId = 0;
              carBrandId = 0;
              carBodyInsurance = false;
              thirdPartyInsurance = false;
              carModels = [];
              carBrands = [];
              thirdPartyInsuranceDate.clear();
              carBodyInsuranceDate.clear();
            });
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        textDirection: TextDirection.rtl,
                        children: [
                          const Text('نوع وسیله نقلیه: ', textDirection: TextDirection.rtl),
                          Radio<int>(
                            value: 1,
                            groupValue: type,
                            onChanged: (value) {
                              _plaqueController.clearLicense();
                              setState(() {
                                type = 1;
                              });
                            },
                          ),
                          GestureDetector(
                            onTap: () {
                              _plaqueController.clearLicense();
                              setState(() {
                                type = 1;
                              });
                            },
                            child: const Text('ماشین'),
                          ),
                          const Expanded(child: SizedBox()),
                          Radio<int>(
                            value: 2,
                            groupValue: type,
                            onChanged: (value) {
                              _plaqueController.clearLicense();
                              setState(() {
                                type = 2;
                              });
                            },
                          ),
                          GestureDetector(
                            onTap: () {
                              _plaqueController.clearLicense();
                              setState(() {
                                type = 2;
                              });
                            },
                            child: const Text('موتورسیکلت'),
                          ),
                          const Expanded(child: SizedBox()),
                        ],
                      ),
                      const SizedBox(height: 16),
                      if (type == 1) _CarPlaque(controller: _plaqueController),
                      if (type == 2)
                        _MotorcyclePlaque(controller: _plaqueController),
                      const SizedBox(height: 16),
                      if (type == 1)
                        DropdownButton(
                          isExpanded: true,
                          value: carTypeId,
                          items: [
                            const DropdownMenuItem(
                              value: 0,
                              child: Text('نوع ماشین'),
                            ),
                            for (VehicleInfo type in carTypes)
                              DropdownMenuItem(
                                  value: type.id, child: Text(type.title))
                          ],
                          onChanged: (value) {
                            setState(() {
                              carTypeId = value!;
                            });
                            BlocProvider.of<VehiclesBloc>(context)
                                .add(VehiclesGetBrands(typeId: carTypeId));
                          },
                        ),
                      const SizedBox(height: 16),
                      if (type == 1)
                        DropdownButton(
                          isExpanded: true,
                          value: carBrandId,
                          items: [
                            const DropdownMenuItem(
                              value: 0,
                              child: Text('برند ماشین'),
                            ),
                            for (VehicleInfo brand in carBrands)
                              DropdownMenuItem(
                                  value: brand.id, child: Text(brand.title))
                          ],
                          onChanged: (value) {
                            setState(() {
                              carBrandId = value!;
                            });
                            BlocProvider.of<VehiclesBloc>(context).add(
                                VehiclesGetModels(
                                    typeId: carTypeId, brandId: carBrandId));
                          },
                        ),
                      const SizedBox(height: 16),
                      if (type == 1)
                        DropdownButton(
                          isExpanded: true,
                          value: carModelId,
                          items: [
                            const DropdownMenuItem(
                              value: 0,
                              child: Text('مدل ماشین'),
                            ),
                            for (VehicleInfo model in carModels)
                              DropdownMenuItem(
                                  value: model.id, child: Text(model.title))
                          ],
                          onChanged: (value) {
                            setState(() {
                              carModelId = value!;
                            });
                          },
                        ),
                      const SizedBox(height: 16),
                      Row(
                        textDirection: TextDirection.rtl,
                        children: [
                          const Text('بیمه شخص ثالث دارد؟ '),
                          Radio<bool>(
                            value: false,
                            groupValue: thirdPartyInsurance,
                            onChanged: (value) {
                              setState(() {
                                thirdPartyInsurance = false;
                              });
                            },
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                thirdPartyInsurance = false;
                              });
                            },
                            child: const Text('خیر'),
                          ),
                          const Expanded(child: SizedBox()),
                          Radio<bool>(
                            value: true,
                            groupValue: thirdPartyInsurance,
                            onChanged: (value) {
                              setState(() {
                                thirdPartyInsurance = true;
                              });
                            },
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                thirdPartyInsurance = true;
                              });
                            },
                            child: const Text('بله'),
                          ),
                          const Expanded(child: SizedBox()),
                        ],
                      ),
                      const SizedBox(height: 16),
                      if (thirdPartyInsurance)
                        Directionality(
                          textDirection: TextDirection.rtl,
                          child: TextField(
                            controller: thirdPartyInsuranceDate,
                            decoration: const InputDecoration(
                                labelText: 'تاریخ اتمام بیمه شخص ثالث',
                                counterText: ''),
                            maxLines: 1,
                            canRequestFocus: false,
                            onTap: () => _showDatePicker(true),
                          ),
                        ),
                      const SizedBox(height: 16),
                      Row(
                        textDirection: TextDirection.rtl,
                        children: [
                          const Text('بیمه بدنه دارد؟ '),
                          Radio<bool>(
                            value: false,
                            groupValue: carBodyInsurance,
                            onChanged: (value) {
                              setState(() {
                                carBodyInsurance = false;
                              });
                            },
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                carBodyInsurance = false;
                              });
                            },
                            child: const Text('خیر'),
                          ),
                          const Expanded(child: SizedBox()),
                          Radio<bool>(
                            value: true,
                            groupValue: carBodyInsurance,
                            onChanged: (value) {
                              setState(() {
                                carBodyInsurance = true;
                              });
                            },
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                carBodyInsurance = true;
                              });
                            },
                            child: const Text('بله'),
                          ),
                          const Expanded(child: SizedBox()),
                        ],
                      ),
                      const SizedBox(height: 16),
                      if (carBodyInsurance)
                        Directionality(
                          textDirection: TextDirection.rtl,
                          child: TextField(
                            controller: carBodyInsuranceDate,
                            decoration: const InputDecoration(
                                labelText: 'تاریخ اتمام بیمه بدنه',
                                counterText: ''),
                            maxLines: 1,
                            canRequestFocus: false,
                            onTap: () => _showDatePicker(false),
                          ),
                        ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
              OutlinedButton(
                  style: OutlinedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 48)),
                  onPressed: () {
                    FocusManager.instance.primaryFocus?.unfocus();

                    BlocProvider.of<VehiclesBloc>(context).add(VehiclesSave(
                        type: type,
                        carTypeId: carTypeId,
                        carBrandId: carBrandId,
                        carModelId: carModelId,
                        license: _plaqueController.getLicense(type),
                        thirdPartyInsurance: thirdPartyInsurance,
                        carBodyInsurance: carBodyInsurance,
                        carBodyInsuranceDate: carBodyInsuranceDate.text,
                        thirdPartyInsuranceDate: thirdPartyInsuranceDate.text));
                  },
                  child: Text(
                    'ذخیره',
                    style: TextStyle(color: Colors.grey[700]),
                  )),
            ],
          ),
        ));
  }

  Future<void> _showDatePicker(bool isThirdParty) async {
    Jalali? picked = await showPersianDatePicker(
      context: context,
      initialDate: Jalali.now(),
      firstDate: Jalali(1300),
      lastDate: Jalali.MAX
    );
    if (picked == null) return;

    String date =
        '${picked.year}/${picked.month.toString().padLeft(2, '0')}/${picked.day.toString().padLeft(2, '0')}';

    if (isThirdParty) {
      thirdPartyInsuranceDate.text = date;
    } else {
      carBodyInsuranceDate.text = date;
    }
  }
}

class _MotorcyclePlaque extends StatelessWidget {
  const _MotorcyclePlaque({required this.controller});

  final PlaqueController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 2),
          borderRadius: BorderRadius.circular(4)),
      constraints: const BoxConstraints(maxWidth: 150),
      child: Column(
        children: [
          Row(
            textDirection: TextDirection.ltr,
            children: [
              Container(
                color: Colors.blue[900],
                padding: const EdgeInsets.all(4),
                child: Column(
                  children: [
                    Image.asset(
                      'assets/img/iran_flag.png',
                      width: 24,
                      height: 20,
                      fit: BoxFit.fill,
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    const Text(
                      'I.R.',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w900),
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    const Text(
                      'IRAN',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w900),
                    ),
                  ],
                ),
              ),
              Expanded(
                  child: TextField(
                controller: controller.licenseController1,
                decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: '۱۲۳',
                    hintStyle:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
                    counterText: ''),
                textAlign: TextAlign.center,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
                maxLength: 3,
                maxLines: 1,
                keyboardType: TextInputType.number,
              ))
            ],
          ),
          TextField(
            controller: controller.licenseController2,
            decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: '۱۲۳۴۵',
                hintStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
                counterText: ''),
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
            maxLength: 5,
            maxLines: 1,
            keyboardType: TextInputType.number,
          )
        ],
      ),
    );
  }
}

class _CarPlaque extends StatefulWidget {
  const _CarPlaque({required this.controller});

  final PlaqueController controller;

  @override
  State<_CarPlaque> createState() => _CarPlaqueState();
}

class _CarPlaqueState extends State<_CarPlaque> {
  final List<String> persianAlphabet = const [
    'الف',
    'ب',
    'پ',
    'ت',
    'ث',
    'ج',
    'چ',
    'ح',
    'خ',
    'د',
    'ذ',
    'ر',
    'ز',
    'ژ',
    'س',
    'ش',
    'ص',
    'ض',
    'ط',
    'ظ',
    'ع',
    'غ',
    'ف',
    'ق',
    'ک',
    'گ',
    'ل',
    'م',
    'ن',
    'و',
    'ه',
    'ی'
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxHeight: 88),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 2),
          borderRadius: BorderRadius.circular(4)),
      child: Row(
        textDirection: TextDirection.ltr,
        children: [
          Container(
            color: Colors.blue[900],
            padding: const EdgeInsets.all(4),
            child: Column(
              children: [
                Image.asset(
                  'assets/img/iran_flag.png',
                  width: 24,
                  height: 20,
                  fit: BoxFit.fill,
                ),
                const SizedBox(
                  height: 6,
                ),
                const Text(
                  'I.R.',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w900),
                ),
                const SizedBox(
                  height: 2,
                ),
                const Text(
                  'IRAN',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w900),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 64,
            child: TextField(
              controller: widget.controller.licenseController1,
              decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: '۱۲',
                  hintStyle:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
                  counterText: ''),
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
              maxLength: 2,
              maxLines: 1,
              keyboardType: TextInputType.number,
            ),
          ),
          DropdownButton(
            value: widget.controller.licenseSelectedChar,
            items: List.generate(
                persianAlphabet.length,
                (index) => DropdownMenuItem(
                      value: persianAlphabet[index],
                      child: Text(
                        persianAlphabet[index],
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    )),
            onChanged: (value) {
              setState(() {
                widget.controller.licenseSelectedChar =
                    value ?? widget.controller.licenseSelectedChar;
              });
            },
          ),
          SizedBox(
            width: 96,
            child: TextField(
              controller: widget.controller.licenseController2,
              decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: '۱۲۳',
                  hintStyle:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
                  counterText: ''),
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
              maxLength: 3,
              maxLines: 1,
              keyboardType: TextInputType.number,
            ),
          ),
          Container(width: 2, height: double.infinity, color: Colors.black),
          Expanded(
            child: Column(
              children: [
                const Text(
                  'ایران',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w700),
                ),
                SizedBox(
                  width: 64,
                  child: TextField(
                    controller: widget.controller.licenseController3,
                    decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: '۱۲',
                        hintStyle: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w900),
                        counterText: ''),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w900),
                    maxLength: 2,
                    maxLines: 1,
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class PlaqueController {
  TextEditingController licenseController1 = TextEditingController(),
      licenseController2 = TextEditingController(),
      licenseController3 = TextEditingController();
  String licenseSelectedChar = 'الف';

  String getLicense(int type, [bool forShow = false]) {
    String seperator = forShow ? ' ' : '';
    if (type == 1) {
      if (forShow) {
        return licenseController3.text +
            seperator +
            licenseController2.text +
            seperator +
            licenseSelectedChar +
            seperator +
            licenseController1.text;
      }
      return licenseController1.text +
          seperator +
          licenseSelectedChar +
          seperator +
          licenseController2.text +
          seperator +
          licenseController3.text;
    }

    return licenseController1.text + seperator + licenseController2.text;
  }

  clearLicense() {
    licenseController1.text = '';
    licenseController2.text = '';
    licenseController3.text = '';
    licenseSelectedChar = 'الف';
  }
}
