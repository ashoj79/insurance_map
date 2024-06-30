import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:insurance_map/core/app_navigator.dart';
import 'package:insurance_map/core/routes.dart';
import 'package:insurance_map/core/widget/show_snackbar.dart';
import 'package:insurance_map/core/widget/wait_alert_dialog.dart';
import 'package:insurance_map/data/local/signup_types.dart';
import 'package:insurance_map/data/remote/model/insurance_company.dart';
import 'package:insurance_map/data/remote/model/province_city.dart';
import 'package:insurance_map/data/remote/model/shop_category.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';

import 'bloc/signup_bloc.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  int _currentState = 1;

  BuildContext? _alertContext;

  @override
  Widget build(BuildContext context) {
    SignupTypes signupType =
        ModalRoute.of(context)!.settings.arguments as SignupTypes;

    return BlocConsumer<SignupBloc, SignupState>(
      buildWhen: (previous, current) =>
          current is! SignupError &&
          current is! SignupLoading &&
          current is! SignupUpdateCities &&
          current is! SignupGoToVehicles &&
          current is! SignupGoToBankCards &&
          current is! SignupDoLogin,
      listener: (context, state) {
        if (state is SignupLoading) {
          showWaitDialog(context, (p0) => _alertContext = p0);
        } else if (_alertContext != null) {
          Navigator.of(_alertContext!).pop();
          _alertContext = null;
        }

        if (state is SignupError) showSnackBar(context, state.message);

        if (state is SignupDoLogin) AppNavigator.pop();

        if (state is SignupGoToVehicles) AppNavigator.push(Routes.vehiclesRoute, popTo: Routes.signupRoute);

        if (state is SignupGoToBankCards) AppNavigator.push(Routes.bankCardsRoute, popTo: Routes.signupRoute);
      },
      builder: (context, state) {
        if (state is SignupGetOtp) _currentState = 2;
        if (state is SignupDoSignup) _currentState = 3;
        if (state is SignupDoSignupStepTwo) _currentState = 4;

        if (_currentState < 3) {
          return _PhoneForm(
            showCodeField: _currentState == 2,
            phone: state is SignupGetOtp ? state.phone : '',
            type: signupType,
          );
        }

        if (_currentState == 3) {
          return _StepOneForm(
            type: signupType,
          );
        }

        if (signupType == SignupTypes.businesses) {
          return _BusinesForm(
              provinces: (state as SignupDoSignupStepTwo).provinces,
              categories: state.categories,
          );
        }

        if (signupType == SignupTypes.representatives) {
          return _InsuranceForm(
            provinces: (state as SignupDoSignupStepTwo).provinces,
            companies: state.companies,
          );
        }

        return Container();
      },
    );
  }
}

class _PhoneForm extends StatelessWidget {
  _PhoneForm({this.showCodeField = false, this.phone = '', required this.type});

  final bool showCodeField;
  final String phone;
  final SignupTypes type;

  final phoneController = TextEditingController(),
      codeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    if (phone.isNotEmpty) phoneController.text = phone;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Directionality(
            textDirection: TextDirection.rtl,
            child: TextField(
              controller: phoneController,
              decoration: const InputDecoration(
                  labelText: 'شماره موبایل',
                  hintText: '9131234567',
                  hintTextDirection: TextDirection.ltr,
                  suffixText: ' 98+',
                  counterText: ''),
              textDirection: TextDirection.ltr,
              maxLength: 10,
              keyboardType: TextInputType.phone,
              enabled: !showCodeField,
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          if (showCodeField)
            Directionality(
              textDirection: TextDirection.rtl,
              child: TextField(
                controller: codeController,
                decoration: const InputDecoration(
                    labelText: 'کد تائید', counterText: ''),
                textDirection: TextDirection.ltr,
                maxLength: 6,
                keyboardType: TextInputType.number,
              ),
            ),
          const Expanded(child: SizedBox()),
          OutlinedButton(
              style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48)),
              onPressed: () {
                if (!showCodeField) {
                  BlocProvider.of<SignupBloc>(context)
                      .add(SignupSendOtp(phoneController.text));
                } else {
                  BlocProvider.of<SignupBloc>(context).add(SignupValidateOtp(
                      phone: phoneController.text, otp: codeController.text, type: type));
                }
              },
              child: Text(
                !showCodeField ? 'ارسال کد تائید' : 'ادامه',
                style: TextStyle(color: Colors.grey[700]),
              ))
        ],
      ),
    );
  }
}

class _StepOneForm extends StatefulWidget {
  const _StepOneForm({required this.type});

  final SignupTypes type;

  @override
  State<_StepOneForm> createState() => __StepOneFormState();
}

class __StepOneFormState extends State<_StepOneForm> {
  final _firstnameController = TextEditingController(),
      _lastnameController = TextEditingController(),
      _fatherNameController = TextEditingController(),
      _nationalcodeController = TextEditingController(),
      _birthCertificateIdController = TextEditingController(),
      _birthDateController = TextEditingController(),
      _placeOfBirthController = TextEditingController(),
      _jobTitleController = TextEditingController(),
      _inviterController = TextEditingController();

  final _firstnameFocusNode = FocusNode(),
      _lastnameFocusNode = FocusNode(),
      _fatherNameFocusNode = FocusNode(),
      _nationalcodeFocusNode = FocusNode(),
      _birthCertificateIdFocusNode = FocusNode(),
      _birthDateFocusNode = FocusNode(),
      _placeOfBirthFocusNode = FocusNode(),
      _jobTitleFocusNode = FocusNode(),
      _inviterFocusNode = FocusNode();

  String _selectedSex = '';
  final Map<String, String> _sexOptions = {
    'man': 'مرد',
    'woman': 'زن',
    'unknown': 'ترجیح می‌دهم نگویم'
  };

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Directionality(
                    textDirection: TextDirection.rtl,
                    child: TextField(
                      focusNode: _firstnameFocusNode,
                      controller: _firstnameController,
                      decoration: const InputDecoration(
                          labelText: 'نام', counterText: ''),
                      maxLines: 1,
                      onSubmitted: (value) => _lastnameFocusNode.requestFocus(),
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Directionality(
                    textDirection: TextDirection.rtl,
                    child: TextField(
                      focusNode: _lastnameFocusNode,
                      controller: _lastnameController,
                      decoration: const InputDecoration(
                          labelText: 'نام خانوادگی', counterText: ''),
                      maxLines: 1,
                      onSubmitted: (value) =>
                          _fatherNameFocusNode.requestFocus(),
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Directionality(
                    textDirection: TextDirection.rtl,
                    child: TextField(
                      focusNode: _fatherNameFocusNode,
                      controller: _fatherNameController,
                      decoration: const InputDecoration(
                          labelText: 'نام پدر', counterText: ''),
                      maxLines: 1,
                      onSubmitted: (value) =>
                          _nationalcodeFocusNode.requestFocus(),
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Directionality(
                    textDirection: TextDirection.rtl,
                    child: TextField(
                      focusNode: _nationalcodeFocusNode,
                      controller: _nationalcodeController,
                      decoration: const InputDecoration(
                          labelText: 'کد ملی', counterText: ''),
                      maxLines: 1,
                      maxLength: 10,
                      keyboardType: TextInputType.number,
                      onSubmitted: (value) =>
                          _birthCertificateIdFocusNode.requestFocus(),
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Directionality(
                    textDirection: TextDirection.rtl,
                    child: TextField(
                      focusNode: _birthCertificateIdFocusNode,
                      controller: _birthCertificateIdController,
                      decoration: const InputDecoration(
                          labelText: 'شناسه شناسنامه', counterText: ''),
                      maxLines: 1,
                      maxLength: 10,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  DropdownButton(
                    isExpanded: true,
                    value: _selectedSex,
                    items: [
                      const DropdownMenuItem(
                        value: '',
                        child: Text('جنسیت'),
                      ),
                      for (String s in _sexOptions.keys)
                        DropdownMenuItem(
                          value: s,
                          child: Text(_sexOptions[s]!),
                        )
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedSex = value!;
                      });
                    },
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Directionality(
                    textDirection: TextDirection.rtl,
                    child: TextField(
                      focusNode: _birthDateFocusNode,
                      controller: _birthDateController,
                      decoration: const InputDecoration(
                          labelText: 'تاریخ تولد‌', counterText: ''),
                      maxLines: 1,
                      canRequestFocus: false,
                      onTap: () => _showDatePicker(),
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Directionality(
                    textDirection: TextDirection.rtl,
                    child: TextField(
                      focusNode: _placeOfBirthFocusNode,
                      controller: _placeOfBirthController,
                      decoration: const InputDecoration(
                          labelText: 'محل تولد', counterText: ''),
                      maxLines: 1,
                      onSubmitted: (value) => _jobTitleFocusNode.requestFocus(),
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Directionality(
                    textDirection: TextDirection.rtl,
                    child: TextField(
                      focusNode: _jobTitleFocusNode,
                      controller: _jobTitleController,
                      decoration: const InputDecoration(
                          labelText: 'شغل', counterText: ''),
                      maxLines: 1,
                      onSubmitted: (value) => _inviterFocusNode.requestFocus(),
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Directionality(
                    textDirection: TextDirection.rtl,
                    child: TextField(
                      focusNode: _inviterFocusNode,
                      controller: _inviterController,
                      decoration: const InputDecoration(
                          labelText: 'کد معرف', counterText: ''),
                      maxLines: 1,
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                ],
              ),
            ),
          ),
          OutlinedButton(
              style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48)),
              onPressed: () {
                BlocProvider.of<SignupBloc>(context).add(SignupSubmitStepOne(
                    fname: _firstnameController.text,
                    lname: _lastnameController.text,
                    fatherName: _fatherNameController.text,
                    nc: _nationalcodeController.text,
                    certId: _birthCertificateIdController.text,
                    sex: _selectedSex,
                    birthDate: _birthDateController.text,
                    place: _placeOfBirthController.text,
                    job: _jobTitleController.text,
                    inviterCode: _inviterController.text,
                    type: widget.type,
                ));
              },
              child: Text(
                'تائید',
                style: TextStyle(color: Colors.grey[700]),
              ))
        ],
      ),
    );
  }

  Future<void> _showDatePicker() async {
    Jalali? picked = await showPersianDatePicker(
      context: context,
      initialDate: Jalali.now(),
      firstDate: Jalali(1300),
      lastDate: Jalali.now(),
    );
    if (picked == null) return;

    _birthDateController.text =
        '${picked.year}/${picked.month.toString().padLeft(2, '0')}/${picked.day.toString().padLeft(2, '0')}';
  }
}

class _InsuranceForm extends StatefulWidget {
  const _InsuranceForm({required this.provinces, required this.companies});

  final List<ProvinceAndCity> provinces;
  final List<InsuranceCompany> companies;

  @override
  State<_InsuranceForm> createState() => _InsuranceFormState();
}

class _InsuranceFormState extends State<_InsuranceForm> {
  int selectedProvince = 0, selectedCity = 0;
  String selectedInsurance = '';

  final _officeNameController = TextEditingController(),
      _officeCodeController = TextEditingController(),
      _addressController = TextEditingController(),
      _postalCodeController = TextEditingController();

  final _officeCodeFocusNode = FocusNode();

  final MapController _mapController = MapController();
  final Location _locationService = Location();
  LocationData? _currentLocation;

  final List<Marker> _markers = [];
  double lat = 0, lng = 0;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Expanded(
              child: SingleChildScrollView(
            child: Column(
              children: [
                DropdownButton(
                  isExpanded: true,
                  value: selectedInsurance,
                  items: [
                    const DropdownMenuItem(
                      value: '',
                      child: Text('شرکت بیمه'),
                    ),
                    for (InsuranceCompany item in widget.companies)
                      DropdownMenuItem(value: item.id, child: Text(item.name))
                  ],
                  onChanged: (value) {
                    setState(() {
                      selectedInsurance = value!;
                    });
                  },
                ),
                const SizedBox(
                  height: 16,
                ),
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: TextField(
                    controller: _officeNameController,
                    decoration: const InputDecoration(
                        labelText: 'نام شعبه', counterText: ''),
                    maxLines: 1,
                    onSubmitted: (value) => _officeCodeFocusNode.requestFocus(),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: TextField(
                    controller: _officeCodeController,
                    decoration: const InputDecoration(
                        labelText: 'کد شعبه', counterText: ''),
                    maxLines: 1,
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                DropdownButton(
                  isExpanded: true,
                  value: selectedProvince,
                  items: [
                    const DropdownMenuItem(
                      value: 0,
                      child: Text('انتخاب استان'),
                    ),
                    for (ProvinceAndCity item in widget.provinces)
                      DropdownMenuItem(value: item.id, child: Text(item.name))
                  ],
                  onChanged: (value) {
                    BlocProvider.of<SignupBloc>(context)
                        .add(SignupGetCities(value!));
                    setState(() {
                      selectedProvince = value;
                      selectedCity = 0;
                    });
                  },
                ),
                const SizedBox(
                  height: 16,
                ),
                BlocBuilder<SignupBloc, SignupState>(
                  buildWhen: (previous, current) =>
                      current is SignupUpdateCities,
                  builder: (context, state) {
                    List<ProvinceAndCity> cities =
                        state is SignupUpdateCities ? state.cities : [];
                    return DropdownButton(
                      isExpanded: true,
                      value: selectedCity,
                      items: [
                        const DropdownMenuItem(
                          value: 0,
                          child: Text('انتخاب شهر'),
                        ),
                        for (var city in cities)
                          DropdownMenuItem(
                            value: city.id,
                            child: Text(city.name),
                          )
                      ],
                      onChanged: (value) {
                        setState(() {
                          selectedCity = value!;
                        });
                      },
                    );
                  },
                ),
                const SizedBox(
                  height: 16,
                ),
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: TextField(
                    controller: _addressController,
                    decoration: const InputDecoration(
                        labelText: 'آدرس دفتر', counterText: ''),
                    maxLines: 1,
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: TextField(
                    controller: _postalCodeController,
                    decoration: const InputDecoration(
                        labelText: 'کد پستی دفتر', counterText: ''),
                    maxLines: 1,
                    maxLength: 10,
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                const Text(
                  'مکان دفتر',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(
                  height: 16,
                ),
                SizedBox(
                  height: 200,
                  child: Stack(
                    children: [
                      FlutterMap(
                        mapController: _mapController,
                        options: MapOptions(
                          initialCenter: const LatLng(35.6892, 51.3890),
                          initialZoom: 9,
                          onTap: (tapPosition, point) {
                            lat = point.latitude;
                            lng = point.longitude;
                            _addMarker();
                          },
                        ),
                        children: [
                          TileLayer(
                            urlTemplate:
                                "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                            subdomains: ['a', 'b', 'c'],
                          ),
                          MarkerLayer(markers: _markers),
                        ],
                      ),
                      Positioned(
                        bottom: 8,
                        right: 8,
                        child: GestureDetector(
                          onTap: () {
                            _moveToUserLocation();
                          },
                          child: Container(
                            width: 32,
                            height: 32,
                            decoration: ShapeDecoration(shape: CircleBorder(), color: Colors.white,),
                            alignment: Alignment.center,
                            child: Icon(Icons.location_searching, color: theme.primaryColor,),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
              ],
            ),
          )),
          OutlinedButton(
              style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48)),
              onPressed: () {
                BlocProvider.of<SignupBloc>(context).add(
                    SignupSaveInsuranceOffice(
                        provinceId: selectedProvince,
                        cityId: selectedCity,
                        insuranceCompanyId: selectedInsurance,
                        officeName: _officeNameController.text,
                        officeCode: _officeCodeController.text,
                        address: _addressController.text,
                        postalCode: _postalCodeController.text,
                        lat: lat,
                        lng: lng));
              },
              child: Text(
                'تائید',
                style: TextStyle(color: Colors.grey[700]),
              ))
        ],
      ),
    );
  }

  _addMarker() {
    _markers.clear();
    _markers.add(
      Marker(
        point: LatLng(lat, lng),
        child: const Icon(
          Icons.location_on,
          color: Colors.red,
          size: 40,
        ),
      ),
    );
    setState(() {});
  }

  Future<void> _moveToUserLocation() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await _locationService.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _locationService.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await _locationService.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _locationService.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _currentLocation = await _locationService.getLocation();

    _locationService.onLocationChanged.listen((LocationData result) {
      _mapController.move(
        LatLng(_currentLocation!.latitude!, _currentLocation!.longitude!),
        14,
      );
      lat = result.latitude!;
      lng = result.longitude!;
      _addMarker();
    });
  }
}

class _BusinesForm extends StatefulWidget {
  const _BusinesForm({required this.provinces, required this.categories});

  final List<ProvinceAndCity> provinces;
  final List<ShopCategory> categories;

  @override
  State<_BusinesForm> createState() => _BusinesFormState();
}

class _BusinesFormState extends State<_BusinesForm> {
  int selectedProvince = 0, selectedCity = 0;
  String selectedCategory = '';

  final _shopNameController = TextEditingController(),
      _addressController = TextEditingController(),
      _postalCodeController = TextEditingController();

  final _addressFocusNode = FocusNode(),
    _postalCodeFocusNode = FocusNode();

  final MapController _mapController = MapController();
  final Location _locationService = Location();
  LocationData? _currentLocation;

  final List<Marker> _markers = [];
  double lat = 0, lng = 0;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Expanded(
              child: SingleChildScrollView(
            child: Column(
              children: [
                DropdownButton(
                  isExpanded: true,
                  value: selectedCategory,
                  items: [
                    const DropdownMenuItem(
                      value: '',
                      child: Text('دسته بندی'),
                    ),
                    for (ShopCategory item in widget.categories)
                      DropdownMenuItem(value: item.id, child: Text(item.title))
                  ],
                  onChanged: (value) {
                    setState(() {
                      selectedCategory = value!;
                    });
                  },
                ),
                const SizedBox(
                  height: 16,
                ),
                DropdownButton(
                  isExpanded: true,
                  value: selectedProvince,
                  items: [
                    const DropdownMenuItem(
                      value: 0,
                      child: Text('انتخاب استان'),
                    ),
                    for (ProvinceAndCity item in widget.provinces)
                      DropdownMenuItem(value: item.id, child: Text(item.name))
                  ],
                  onChanged: (value) {
                    BlocProvider.of<SignupBloc>(context)
                        .add(SignupGetCities(value!));
                    setState(() {
                      selectedProvince = value;
                      selectedCity = 0;
                    });
                  },
                ),
                const SizedBox(
                  height: 16,
                ),
                BlocBuilder<SignupBloc, SignupState>(
                  buildWhen: (previous, current) =>
                      current is SignupUpdateCities,
                  builder: (context, state) {
                    List<ProvinceAndCity> cities =
                        state is SignupUpdateCities ? state.cities : [];
                    return DropdownButton(
                      isExpanded: true,
                      value: selectedCity,
                      items: [
                        const DropdownMenuItem(
                          value: 0,
                          child: Text('انتخاب شهر'),
                        ),
                        for (var city in cities)
                          DropdownMenuItem(
                            value: city.id,
                            child: Text(city.name),
                          )
                      ],
                      onChanged: (value) {
                        setState(() {
                          selectedCity = value!;
                        });
                      },
                    );
                  },
                ),
                const SizedBox(
                  height: 16,
                ),
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: TextField(
                    controller: _shopNameController,
                    decoration: const InputDecoration(
                        labelText: 'نام کسب و کار', counterText: ''),
                    maxLines: 1,
                    onSubmitted: (value) => _addressFocusNode.requestFocus(),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: TextField(
                    controller: _addressController,
                    focusNode: _addressFocusNode,
                    decoration: const InputDecoration(
                        labelText: 'آدرس دفتر', counterText: ''),
                    maxLines: 1,
                    onSubmitted: (value) => _postalCodeFocusNode.requestFocus(),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: TextField(
                    controller: _postalCodeController,
                    focusNode: _postalCodeFocusNode,
                    decoration: const InputDecoration(
                        labelText: 'کد پستی دفتر', counterText: ''),
                    maxLines: 1,
                    maxLength: 10,
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                const Text(
                  'مکان کسب و کار',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(
                  height: 16,
                ),
                SizedBox(
                  height: 200,
                  child: Stack(
                    children: [
                      FlutterMap(
                        mapController: _mapController,
                        options: MapOptions(
                          initialCenter: const LatLng(35.6892, 51.3890),
                          initialZoom: 9,
                          onTap: (tapPosition, point) {
                            lat = point.latitude;
                            lng = point.longitude;
                            _addMarker();
                          },
                        ),
                        children: [
                          TileLayer(
                            urlTemplate:
                                "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                            subdomains: ['a', 'b', 'c'],
                          ),
                          MarkerLayer(markers: _markers),
                        ],
                      ),
                      Positioned(
                        bottom: 8,
                        right: 8,
                        child: GestureDetector(
                          onTap: () {
                            _moveToUserLocation();
                          },
                          child: Container(
                            width: 32,
                            height: 32,
                            decoration: ShapeDecoration(shape: CircleBorder(), color: Colors.white,),
                            alignment: Alignment.center,
                            child: Icon(Icons.location_searching, color: theme.primaryColor,),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
              ],
            ),
          )),
          OutlinedButton(
              style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48)),
              onPressed: () {
                BlocProvider.of<SignupBloc>(context).add(
                    SignupSaveVendor(
                        provinceId: selectedProvince,
                        cityId: selectedCity,
                        categoryId: selectedCategory,
                        shopName: _shopNameController.text,
                        address: _addressController.text,
                        postalCode: _postalCodeController.text,
                        lat: lat,
                        lng: lng));
              },
              child: Text(
                'تائید',
                style: TextStyle(color: Colors.grey[700]),
              ))
        ],
      ),
    );
  }

  _addMarker() {
    _markers.clear();
    _markers.add(
      Marker(
        point: LatLng(lat, lng),
        child: const Icon(
          Icons.location_on,
          color: Colors.red,
          size: 40,
        ),
      ),
    );
    setState(() {});
  }

  Future<void> _moveToUserLocation() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await _locationService.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _locationService.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await _locationService.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _locationService.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _currentLocation = await _locationService.getLocation();

    _locationService.onLocationChanged.listen((LocationData result) {
      _mapController.move(
        LatLng(_currentLocation!.latitude!, _currentLocation!.longitude!),
        14,
      );
      lat = result.latitude!;
      lng = result.longitude!;
      _addMarker();
    });
  }
}
