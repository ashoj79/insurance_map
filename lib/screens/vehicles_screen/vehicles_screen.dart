import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insurance_map/core/app_navigator.dart';
import 'package:insurance_map/core/routes.dart';
import 'package:insurance_map/core/widget/show_snackbar.dart';
import 'package:insurance_map/core/widget/wait_alert_dialog.dart';
import 'package:insurance_map/data/remote/model/vehicle_info.dart';
import 'package:insurance_map/screens/vehicles_screen/bloc/vehicles_bloc.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:uuid/uuid.dart';

class VehiclesScreen extends StatefulWidget {
  const VehiclesScreen({super.key});

  @override
  State<VehiclesScreen> createState() => _VehiclesScreenState();
}

class _VehiclesScreenState extends State<VehiclesScreen> {
  List<VehiclesInfoController> controllers = [];

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

          if (state is VehiclesNewCar) {
            setState(() {
              controllers.add(VehiclesInfoController(
                  id: const Uuid().v4(), carTypes: state.types));
            });
          }

          if (state is VehiclesUpdateBrands) {
            int index = controllers
                .indexWhere((element) => element.id == state.instanceId);
            setState(() {
              controllers[index].carBrandId = 0;
              controllers[index].carModelId = 0;
              controllers[index].carModels.clear();
              controllers[index].carBrands = state.brands;
            });
          }

          if (state is VehiclesUpdateModels) {
            int index = controllers
                .indexWhere((element) => element.id == state.instanceId);
            setState(() {
              controllers[index].carModelId = 0;
              controllers[index].carModels = state.models;
            });
          }

          if (state is VehiclesSaved) {
            int index = controllers
                .indexWhere((element) => element.id == state.instanceId);
            setState(() {
              controllers[index].isSaved = true;
              controllers[index].isExpanded = false;
            });
          }

          if (state is VehiclesShowAlert) _showAlertDialog();
        },
        child: SingleChildScrollView(
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: ExpansionPanelList(
              children: [
                for (int i = 0; i < controllers.length; i++)
                  ExpansionPanel(
                    headerBuilder: (context, isExpanded) {
                      return ListTile(
                        title: Row(
                          children: [
                            Text(
                                'پلاک ${controllers[i].type == 1 ? 'خودرو' : 'موتورسیکلت'} ${controllers[i].isSaved ? ':${controllers[i].getLicense(true)}' : ''}'),
                            if (controllers[i].isSaved)
                              const Text(
                                ' ذخیره شد',
                                style: TextStyle(
                                    color: Colors.greenAccent, fontSize: 12),
                              )
                          ],
                        ),
                        onTap: () {
                          if (controllers[i].isSaved) return;

                          if (!controllers[i].isExpanded) {
                            for (var element in controllers) {
                              element.isExpanded = false;
                            }
                          }

                          setState(() {
                            controllers[i].isExpanded =
                                !controllers[i].isExpanded;
                          });
                        },
                      );
                    },
                    body: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Column(
                        children: [
                          Row(
                            textDirection: TextDirection.rtl,
                            children: [
                              const Text('نوع وسیله نقلیه: '),
                              Radio<int>(
                                value: 1,
                                groupValue: controllers[i].type,
                                onChanged: (value) {
                                  controllers[i].clearLicense();
                                  setState(() {
                                    controllers[i].type = 1;
                                  });
                                },
                              ),
                              GestureDetector(
                                onTap: () {
                                  controllers[i].clearLicense();
                                  setState(() {
                                    controllers[i].type = 1;
                                  });
                                },
                                child: const Text('ماشین'),
                              ),
                              const Expanded(child: SizedBox()),
                              Radio<int>(
                                value: 2,
                                groupValue: controllers[i].type,
                                onChanged: (value) {
                                  controllers[i].clearLicense();
                                  setState(() {
                                    controllers[i].type = 2;
                                  });
                                },
                              ),
                              GestureDetector(
                                onTap: () {
                                  controllers[i].clearLicense();
                                  setState(() {
                                    controllers[i].type = 2;
                                  });
                                },
                                child: const Text('موتورسیکلت'),
                              ),
                              const Expanded(child: SizedBox()),
                            ],
                          ),
                          const SizedBox(height: 16),
                          if (controllers[i].type == 1)
                            _CarPlaque(controller: controllers[i]),
                          if (controllers[i].type == 2)
                            _MotorcyclePlaque(controller: controllers[i]),
                          const SizedBox(height: 16),
                          if (controllers[i].type == 1)
                            DropdownButton(
                              isExpanded: true,
                              value: controllers[i].carTypeId,
                              items: [
                                const DropdownMenuItem(
                                  value: 0,
                                  child: Text('نوع ماشین'),
                                ),
                                for (VehicleInfo type
                                    in controllers[i].carTypes)
                                  DropdownMenuItem(
                                      value: type.id, child: Text(type.title))
                              ],
                              onChanged: (value) {
                                setState(() {
                                  controllers[i].carTypeId = value!;
                                });
                                BlocProvider.of<VehiclesBloc>(context).add(
                                    VehiclesGetBrands(
                                        instanceId: controllers[i].id,
                                        typeId: controllers[i].carTypeId));
                              },
                            ),
                          const SizedBox(height: 16),
                          if (controllers[i].type == 1)
                            DropdownButton(
                              isExpanded: true,
                              value: controllers[i].carBrandId,
                              items: [
                                const DropdownMenuItem(
                                  value: 0,
                                  child: Text('برند ماشین'),
                                ),
                                for (VehicleInfo brand
                                    in controllers[i].carBrands)
                                  DropdownMenuItem(
                                      value: brand.id, child: Text(brand.title))
                              ],
                              onChanged: (value) {
                                setState(() {
                                  controllers[i].carBrandId = value!;
                                });
                                BlocProvider.of<VehiclesBloc>(context).add(
                                    VehiclesGetModels(
                                        instanceId: controllers[i].id,
                                        typeId: controllers[i].carTypeId,
                                        brandId: controllers[i].carBrandId));
                              },
                            ),
                          const SizedBox(height: 16),
                          if (controllers[i].type == 1)
                            DropdownButton(
                              isExpanded: true,
                              value: controllers[i].carModelId,
                              items: [
                                const DropdownMenuItem(
                                  value: 0,
                                  child: Text('مدل ماشین'),
                                ),
                                for (VehicleInfo model
                                    in controllers[i].carModels)
                                  DropdownMenuItem(
                                      value: model.id, child: Text(model.title))
                              ],
                              onChanged: (value) {
                                setState(() {
                                  controllers[i].carModelId = value!;
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
                                groupValue: controllers[i].thirdPartyInsurance,
                                onChanged: (value) {
                                  setState(() {
                                    controllers[i].thirdPartyInsurance = false;
                                  });
                                },
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    controllers[i].thirdPartyInsurance = false;
                                  });
                                },
                                child: const Text('خیر'),
                              ),
                              const Expanded(child: SizedBox()),
                              Radio<bool>(
                                value: true,
                                groupValue: controllers[i].thirdPartyInsurance,
                                onChanged: (value) {
                                  setState(() {
                                    controllers[i].thirdPartyInsurance = true;
                                  });
                                },
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    controllers[i].thirdPartyInsurance = true;
                                  });
                                },
                                child: const Text('بله'),
                              ),
                              const Expanded(child: SizedBox()),
                            ],
                          ),
                          const SizedBox(height: 16),
                          if (controllers[i].thirdPartyInsurance)
                            Directionality(
                              textDirection: TextDirection.rtl,
                              child: TextField(
                                controller:
                                    controllers[i].thirdPartyInsuranceDate,
                                decoration: const InputDecoration(
                                    labelText: 'تاریخ اتمام بیمه شخص ثالث',
                                    counterText: ''),
                                maxLines: 1,
                                canRequestFocus: false,
                                onTap: () => _showDatePicker(i, true),
                              ),
                            ),
                          const SizedBox(height: 16),
                          Row(
                            textDirection: TextDirection.rtl,
                            children: [
                              const Text('بیمه بدنه دارد؟ '),
                              Radio<bool>(
                                value: false,
                                groupValue: controllers[i].carBodyInsurance,
                                onChanged: (value) {
                                  setState(() {
                                    controllers[i].carBodyInsurance = false;
                                  });
                                },
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    controllers[i].carBodyInsurance = false;
                                  });
                                },
                                child: const Text('خیر'),
                              ),
                              const Expanded(child: SizedBox()),
                              Radio<bool>(
                                value: true,
                                groupValue: controllers[i].carBodyInsurance,
                                onChanged: (value) {
                                  setState(() {
                                    controllers[i].carBodyInsurance = true;
                                  });
                                },
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    controllers[i].carBodyInsurance = true;
                                  });
                                },
                                child: const Text('بله'),
                              ),
                              const Expanded(child: SizedBox()),
                            ],
                          ),
                          const SizedBox(height: 16),
                          if (controllers[i].carBodyInsurance)
                            Directionality(
                              textDirection: TextDirection.rtl,
                              child: TextField(
                                controller: controllers[i].carBodyInsuranceDate,
                                decoration: const InputDecoration(
                                    labelText: 'تاریخ اتمام بیمه بدنه',
                                    counterText: ''),
                                maxLines: 1,
                                canRequestFocus: false,
                                onTap: () => _showDatePicker(i, false),
                              ),
                            ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                              onPressed: () {
                                BlocProvider.of<VehiclesBloc>(context).add(
                                    VehiclesSave(controller: controllers[i]));
                              },
                              child: const Text('ثبت')),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                    isExpanded: controllers[i].isExpanded,
                  )
              ],
            ),
          ),
        ));
  }

  Future<void> _showDatePicker(int index, bool isThirdParty) async {
    Jalali? picked = await showPersianDatePicker(
      context: context,
      initialDate: Jalali.now(),
      firstDate: Jalali(1300),
      lastDate: Jalali.now(),
    );
    if (picked == null) return;

    String date =
        '${picked.year}/${picked.month.toString().padLeft(2, '0')}/${picked.day.toString().padLeft(2, '0')}';

    if (isThirdParty) {
      controllers[index].thirdPartyInsuranceDate.text = date;
    } else {
      controllers[index].carBodyInsuranceDate.text = date;
    }
  }

  void _showAlertDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            title: const Text('هشدار'),
            content: const Text('تمام وسایل نقلیه خود را ذخیره نکرده اید. آیا از عبور از این مرحله مطمئن هستید؟'),
            actions: <Widget>[
              TextButton(
                child: const Text('خیر'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text('بله'),
                onPressed: () {
                  Navigator.of(context).pop();
                  AppNavigator.push(Routes.bankCardsRoute, popTo: Routes.vehiclesRoute);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class VehiclesInfoController {
  int type = 1, carTypeId = 0, carModelId = 0, carBrandId = 0;
  bool carBodyInsurance = false,
      thirdPartyInsurance = false,
      isSaved = false,
      isExpanded = false;
  String id = '', licenseSelectedChar = 'الف';
  List<VehicleInfo> carTypes = [], carModels = [], carBrands = [];
  final TextEditingController licenseController1 =
          TextEditingController(text: ''),
      licenseController2 = TextEditingController(text: ''),
      licenseController3 = TextEditingController(text: ''),
      thirdPartyInsuranceDate = TextEditingController(text: ''),
      carBodyInsuranceDate = TextEditingController(text: '');

  VehiclesInfoController({required this.id, required this.carTypes});

  String getLicense([bool forShow = false]) {
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

class _MotorcyclePlaque extends StatelessWidget {
  const _MotorcyclePlaque({required this.controller});

  final VehiclesInfoController controller;

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

  final VehiclesInfoController controller;

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
