import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:insurance_map/data/local/signup_types.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool _showSubmitCodeField = false;
  int _currentState = 1;
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

    if (_currentState == 1) {
      return _PhoneForm(
        showCodeField: _showSubmitCodeField,
        onClicked: () {
          setState(() {
            if (!_showSubmitCodeField) {
              _showSubmitCodeField = true;
            } else {
              _currentState++;
            }
          });
        },
      );
    }

    if (signupType == SignupTypes.marketers) {
      return _MarketerForm(
        states: _states,
        cities: _cities,
        educationLevels: _educationLevels,
      );
    }

    if (signupType == SignupTypes.businesses) {
      return _BusinesForm(states: _states, cities: _cities, businesCategory: _businesCategories);
    }

    if (signupType == SignupTypes.representatives) {
      return _InsuranceForm(states: _states, cities: _cities, insurances: _insurances);
    }

    return Container();
  }
}

class _PhoneForm extends StatelessWidget {
  _PhoneForm({this.showCodeField = false, required this.onClicked});

  final bool showCodeField;
  final Function onClicked;

  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Directionality(
            textDirection: TextDirection.rtl,
            child: TextField(
              controller: _phoneController,
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
                controller: _codeController,
                decoration: const InputDecoration(
                    labelText: 'کد تائید', counterText: ''),
                textDirection: TextDirection.ltr,
                maxLength: 5,
                keyboardType: TextInputType.number,
              ),
            ),
          const Expanded(child: SizedBox()),
          OutlinedButton(
              style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48)),
              onPressed: () {
                onClicked.call();
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
                    decoration:
                        InputDecoration(labelText: 'سوابق کاری', counterText: ''),
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
      {required this.states,
      required this.cities,
      required this.insurances});

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
                    decoration: InputDecoration(
                        labelText: 'کد شعبه', counterText: ''),
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
