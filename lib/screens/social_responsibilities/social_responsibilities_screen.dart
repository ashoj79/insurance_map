import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insurance_map/core/widget/show_snackbar.dart';
import 'package:insurance_map/core/widget/wait_alert_dialog.dart';
import 'package:insurance_map/data/remote/model/province_city.dart';
import 'package:insurance_map/data/remote/model/social_responsibility.dart';
import 'package:insurance_map/screens/social_responsibilities/bloc/s_r_bloc.dart';

class SocialResponsibilitiesScreen extends StatefulWidget {
  const SocialResponsibilitiesScreen({super.key});

  @override
  State<SocialResponsibilitiesScreen> createState() => _SocialResponsibilitiesScreenState();
}

class _SocialResponsibilitiesScreenState extends State<SocialResponsibilitiesScreen> {
  int _selectedProvince = 0, _selectedCity = 0;
  BuildContext? _alertContext;
  final List<ProvinceAndCity> _provinces = [], _cities = [];
  final List<SocialResponsibility> _responsibilities = [];

  @override
  void initState() {
    super.initState();

    BlocProvider.of<SRBloc>(context).add(SRGetInitData());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SRBloc, SRState>(
      listener: (context, state) {
        if (state is SRLoading) {
          showWaitDialog(context, (p0) => _alertContext = p0);
        } else if (_alertContext != null) {
          Navigator.of(_alertContext!).pop();
          _alertContext = null;
        }

        if (state is SRError) showSnackBar(context, state.message);
      },
      builder: (context, state) {
        if (state is SRShowProvinces){
          _provinces.clear();
          _provinces.addAll(state.data);
        }

        if (state is SRShowCities){
          _cities.clear();
          _cities.addAll(state.data);
        }

        if (state is SRShowResponsibilities){
          _responsibilities.clear();
          _responsibilities.addAll(state.data);
        }

        return Padding(
          padding: const EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: DropdownButton(
                      value: _selectedProvince,
                      items: [
                        const DropdownMenuItem(
                          value: 0,
                          child: Text('انتخاب استان'),
                        ),
                        for (var p in _provinces)
                          DropdownMenuItem(value: p.id, child: Text(p.name))
                      ],
                      onChanged: (value) {
                        if (value! > 0) {
                          BlocProvider.of<SRBloc>(context).add(SRGetProvinceData(value));
                        }
                        setState(() {
                          _selectedProvince = value;
                          _selectedCity = 0;
                          _cities.clear();
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: DropdownButton(
                      value: _selectedCity,
                      items: [
                        const DropdownMenuItem(
                          value: 0,
                          child: Text('انتخاب شهر'),
                        ),
                        for (var c in _cities)
                          DropdownMenuItem(value: c.id, child: Text(c.name))
                      ],
                      onChanged: (value) {
                        if (value! > 0) {
                          BlocProvider.of<SRBloc>(context).add(SRGetCityData(value));
                        }
                        setState(() {
                          _selectedCity = value;
                        });
                      },
                    ),
                  ),
                ],
              ),

              SizedBox(height: 16),

              Expanded(
                child: ListView.builder(
                  itemCount: _responsibilities.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12)
                      ),
                      child: Text('${_responsibilities[index].title} (${_responsibilities[index].province.name})', style: const TextStyle(color: Colors.black)),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
