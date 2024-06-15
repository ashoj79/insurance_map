import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insurance_map/core/widget/show_snackbar.dart';
import 'package:insurance_map/core/widget/wait_alert_dialog.dart';
import 'package:insurance_map/data/local/signup_types.dart';
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

  final List<String> _states = ['اصفهان', 'تهران', 'یزد'],
      _educationLevels = [
        'ابتدایی',
        'سیکل',
        'دیپلم',
        'فوق دیپلم',
        'لیسانس',
        'فوق لیسانس',
        'دکتری'
      ],
      _businesCategories = [
        'دسته بندی 1',
        'دسته بندی 2',
        'دسته بندی 3',
        'دسته بندی 4',
      ],
      _insurances = [
        'بیمه 1',
        'بیمه 2',
        'بیمه 3',
        'بیمه 4',
      ];
  final List<List<String>> _cities = [
    ['اصفهان', 'کاشان', 'بهارستان'],
    ['تهران', 'ری', 'کرج'],
    ['یزد', 'شهر ۱', 'شهر ۲'],
  ];

  @override
  Widget build(BuildContext context) {
    SignupTypes signupType =
        ModalRoute.of(context)!.settings.arguments as SignupTypes;

    return BlocConsumer<SignupBloc, SignupState>(
      buildWhen: (previous, current) =>
          current is! SignupError && current is! SignupLoading,
      listener: (context, state) {
        if (state is SignupLoading) {
          showWaitDialog(context, (p0) => _alertContext = p0);
        } else if (_alertContext != null) {
          Navigator.of(_alertContext!).pop();
          _alertContext = null;
        }

        if (state is SignupError) showSnackBar(context, state.message);
      },
      builder: (context, state) {
        if (state is SignupGetOtp) _currentState = 2;
        if (state is SignupDoSignup) _currentState = 3;
        if (state is SignupDoSignupStepTwo) _currentState = 4;

        if (_currentState < 3) {
          return _PhoneForm(
            showCodeField: _currentState == 2,
            phone: state is SignupGetOtp ? state.phone : '',
          );
        }

        if (_currentState == 3) {
          return const _StepOneForm();
        }

        if (signupType == SignupTypes.marketers) {
          return _MarketerForm(
            states: _states,
            cities: _cities,
            educationLevels: _educationLevels,
          );
        }

        if (signupType == SignupTypes.businesses) {
          return _BusinesForm(
              states: _states,
              cities: _cities,
              businesCategory: _businesCategories);
        }

        if (signupType == SignupTypes.representatives) {
          return _InsuranceForm(
              states: _states, cities: _cities, insurances: _insurances);
        }

        return Container();
      },
    );
  }
}

class _PhoneForm extends StatelessWidget {
  _PhoneForm({this.showCodeField = false, this.phone = ''});

  final bool showCodeField;
  final String phone;

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
                      phone: phoneController.text, otp: codeController.text));
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
  const _StepOneForm();

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
      _jobTitleController = TextEditingController();

  final _firstnameFocusNode = FocusNode(),
      _lastnameFocusNode = FocusNode(),
      _fatherNameFocusNode = FocusNode(),
      _nationalcodeFocusNode = FocusNode(),
      _birthCertificateIdFocusNode = FocusNode(),
      _birthDateFocusNode = FocusNode(),
      _placeOfBirthFocusNode = FocusNode(),
      _jobTitleFocusNode = FocusNode();

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
                    job: _jobTitleController.text));
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

    _birthDateController.text = '${picked.year}/${picked.month.toString().padLeft(2, '0')}/${picked.day.toString().padLeft(2, '0')}';
  }
}

class _MarketerForm extends StatefulWidget {
  const _MarketerForm(
      {required this.states,
      required this.cities,
      required this.educationLevels});

  final List<String> states, educationLevels;
  final List<List<String>> cities;

  @override
  State<_MarketerForm> createState() => _MarketerFormState();
}

class _MarketerFormState extends State<_MarketerForm> {
  String selectedState = '', selectedCity = '', selectedEducation = '';

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
                const Directionality(
                  textDirection: TextDirection.rtl,
                  child: TextField(
                    decoration:
                        InputDecoration(labelText: 'نام', counterText: ''),
                    maxLines: 1,
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                const Directionality(
                  textDirection: TextDirection.rtl,
                  child: TextField(
                    decoration: InputDecoration(
                        labelText: 'نام خانوادگی', counterText: ''),
                    maxLines: 1,
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                DropdownButton(
                  isExpanded: true,
                  value: selectedState,
                  items: [
                    const DropdownMenuItem(
                      value: '',
                      child: Text('انتخاب استان'),
                    ),
                    for (String s in widget.states)
                      DropdownMenuItem(
                        value: s,
                        child: Text(s),
                      )
                  ],
                  onChanged: (value) {
                    setState(() {
                      selectedState = value!;
                      selectedCity = '';
                    });
                  },
                ),
                const SizedBox(
                  height: 16,
                ),
                DropdownButton(
                  isExpanded: true,
                  value: selectedCity,
                  items: [
                    const DropdownMenuItem(
                      value: '',
                      child: Text('انتخاب شهر'),
                    ),
                    if (selectedState != '')
                      for (String s in widget
                          .cities[widget.states.indexOf(selectedState)])
                        DropdownMenuItem(
                          value: s,
                          child: Text(s),
                        )
                  ],
                  onChanged: (value) {
                    setState(() {
                      selectedCity = value!;
                    });
                  },
                ),
                const SizedBox(
                  height: 16,
                ),
                const Directionality(
                  textDirection: TextDirection.rtl,
                  child: TextField(
                    decoration:
                        InputDecoration(labelText: 'آدرس', counterText: ''),
                    maxLines: 1,
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                DropdownButton(
                  isExpanded: true,
                  value: selectedEducation,
                  items: [
                    const DropdownMenuItem(
                      value: '',
                      child: Text('سطح تحصیلات'),
                    ),
                    for (String s in widget.educationLevels)
                      DropdownMenuItem(
                        value: s,
                        child: Text(s),
                      )
                  ],
                  onChanged: (value) {
                    setState(() {
                      selectedEducation = value!;
                    });
                  },
                ),
                const SizedBox(
                  height: 16,
                ),
                const Directionality(
                  textDirection: TextDirection.rtl,
                  child: TextField(
                    decoration: InputDecoration(
                        labelText: 'سوابق کاری', counterText: ''),
                    textDirection: TextDirection.ltr,
                    maxLines: 1,
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
              onPressed: () {},
              child: Text(
                'تائید',
                style: TextStyle(color: Colors.grey[700]),
              ))
        ],
      ),
    );
  }
}

class _BusinesForm extends StatefulWidget {
  const _BusinesForm(
      {required this.states,
      required this.cities,
      required this.businesCategory});

  final List<String> states, businesCategory;
  final List<List<String>> cities;

  @override
  State<_BusinesForm> createState() => _BusinesFormState();
}

class _BusinesFormState extends State<_BusinesForm> {
  String selectedState = '', selectedCity = '', selectedCategory = '';

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
                const Directionality(
                  textDirection: TextDirection.rtl,
                  child: TextField(
                    decoration:
                        InputDecoration(labelText: 'نام', counterText: ''),
                    maxLines: 1,
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                const Directionality(
                  textDirection: TextDirection.rtl,
                  child: TextField(
                    decoration: InputDecoration(
                        labelText: 'نام خانوادگی', counterText: ''),
                    maxLines: 1,
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                DropdownButton(
                  isExpanded: true,
                  value: selectedState,
                  items: [
                    const DropdownMenuItem(
                      value: '',
                      child: Text('انتخاب استان'),
                    ),
                    for (String s in widget.states)
                      DropdownMenuItem(
                        value: s,
                        child: Text(s),
                      )
                  ],
                  onChanged: (value) {
                    setState(() {
                      selectedState = value!;
                      selectedCity = '';
                    });
                  },
                ),
                const SizedBox(
                  height: 16,
                ),
                DropdownButton(
                  isExpanded: true,
                  value: selectedCity,
                  items: [
                    const DropdownMenuItem(
                      value: '',
                      child: Text('انتخاب شهر'),
                    ),
                    if (selectedState != '')
                      for (String s in widget
                          .cities[widget.states.indexOf(selectedState)])
                        DropdownMenuItem(
                          value: s,
                          child: Text(s),
                        )
                  ],
                  onChanged: (value) {
                    setState(() {
                      selectedCity = value!;
                    });
                  },
                ),
                const SizedBox(
                  height: 16,
                ),
                const Directionality(
                  textDirection: TextDirection.rtl,
                  child: TextField(
                    decoration:
                        InputDecoration(labelText: 'آدرس', counterText: ''),
                    maxLines: 1,
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                DropdownButton(
                  isExpanded: true,
                  value: selectedCategory,
                  items: [
                    const DropdownMenuItem(
                      value: '',
                      child: Text('دسته بندی کسب و کار'),
                    ),
                    for (String s in widget.businesCategory)
                      DropdownMenuItem(
                        value: s,
                        child: Text(s),
                      )
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
              ],
            ),
          )),
          OutlinedButton(
              style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48)),
              onPressed: () {},
              child: Text(
                'تائید',
                style: TextStyle(color: Colors.grey[700]),
              ))
        ],
      ),
    );
  }
}

class _InsuranceForm extends StatefulWidget {
  const _InsuranceForm(
      {required this.states, required this.cities, required this.insurances});

  final List<String> states, insurances;
  final List<List<String>> cities;

  @override
  State<_InsuranceForm> createState() => _InsuranceFormState();
}

class _InsuranceFormState extends State<_InsuranceForm> {
  String selectedState = '', selectedCity = '', selectedInsurance = '';

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
                const Directionality(
                  textDirection: TextDirection.rtl,
                  child: TextField(
                    decoration:
                        InputDecoration(labelText: 'نام', counterText: ''),
                    maxLines: 1,
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                const Directionality(
                  textDirection: TextDirection.rtl,
                  child: TextField(
                    decoration: InputDecoration(
                        labelText: 'نام خانوادگی', counterText: ''),
                    maxLines: 1,
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                DropdownButton(
                  isExpanded: true,
                  value: selectedInsurance,
                  items: [
                    const DropdownMenuItem(
                      value: '',
                      child: Text('شرکت بیمه'),
                    ),
                    for (String s in widget.insurances)
                      DropdownMenuItem(
                        value: s,
                        child: Text(s),
                      )
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
                const Directionality(
                  textDirection: TextDirection.rtl,
                  child: TextField(
                    decoration:
                        InputDecoration(labelText: 'کد شعبه', counterText: ''),
                    maxLines: 1,
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                DropdownButton(
                  isExpanded: true,
                  value: selectedState,
                  items: [
                    const DropdownMenuItem(
                      value: '',
                      child: Text('انتخاب استان'),
                    ),
                    for (String s in widget.states)
                      DropdownMenuItem(
                        value: s,
                        child: Text(s),
                      )
                  ],
                  onChanged: (value) {
                    setState(() {
                      selectedState = value!;
                      selectedCity = '';
                    });
                  },
                ),
                const SizedBox(
                  height: 16,
                ),
                DropdownButton(
                  isExpanded: true,
                  value: selectedCity,
                  items: [
                    const DropdownMenuItem(
                      value: '',
                      child: Text('انتخاب شهر'),
                    ),
                    if (selectedState != '')
                      for (String s in widget
                          .cities[widget.states.indexOf(selectedState)])
                        DropdownMenuItem(
                          value: s,
                          child: Text(s),
                        )
                  ],
                  onChanged: (value) {
                    setState(() {
                      selectedCity = value!;
                    });
                  },
                ),
                const SizedBox(
                  height: 16,
                ),
                const Directionality(
                  textDirection: TextDirection.rtl,
                  child: TextField(
                    decoration:
                        InputDecoration(labelText: 'آدرس', counterText: ''),
                    maxLines: 1,
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
              onPressed: () {},
              child: Text(
                'تائید',
                style: TextStyle(color: Colors.grey[700]),
              ))
        ],
      ),
    );
  }
}

class _MotorcyclePlaque extends StatelessWidget {
  const _MotorcyclePlaque();

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
              const Expanded(
                  child: TextField(
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: '۱۲۳',
                    hintStyle:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
                    counterText: ''),
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
                maxLength: 3,
                maxLines: 1,
                keyboardType: TextInputType.number,
              ))
            ],
          ),
          const TextField(
            decoration: InputDecoration(
                border: InputBorder.none,
                hintText: '۱۲۳۴۵',
                hintStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
                counterText: ''),
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
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
  const _CarPlaque();

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

  String selectedChar = 'الف';

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
          const SizedBox(
            width: 64,
            child: TextField(
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: '۱۲',
                  hintStyle:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
                  counterText: ''),
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
              maxLength: 2,
              maxLines: 1,
              keyboardType: TextInputType.number,
            ),
          ),
          DropdownButton(
            value: selectedChar,
            items: List.generate(
                persianAlphabet.length,
                (index) => DropdownMenuItem(
                      child: Text(
                        persianAlphabet[index],
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      value: persianAlphabet[index],
                    )),
            onChanged: (value) {
              setState(() {
                selectedChar = value ?? selectedChar;
              });
            },
          ),
          const SizedBox(
            width: 96,
            child: TextField(
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: '۱۲۳',
                  hintStyle:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
                  counterText: ''),
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
              maxLength: 3,
              maxLines: 1,
              keyboardType: TextInputType.number,
            ),
          ),
          Container(width: 2, height: double.infinity, color: Colors.black),
          const Expanded(
            child: Column(
              children: [
                Text(
                  'ایران',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w700),
                ),
                SizedBox(
                  width: 64,
                  child: TextField(
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: '۱۲',
                        hintStyle: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w900),
                        counterText: ''),
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
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
