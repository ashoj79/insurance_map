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
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all()
                  ),
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    children: [
                      Row(
                        textDirection: TextDirection.rtl,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('کارت های بانکی', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                          InkWell(
                            onTap: () {
                              AppNavigator.push(Routes.bankCardsRoute);
                            },
                            child: const Icon(
                              Icons.add,
                              color: Colors.black,
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 8),
                      Expanded(
                        child: SingleChildScrollView(
                          child: state is! CAVShowData ? const SizedBox() : Column(
                            children: [
                              for (String n in state.cards.keys)
                                Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8)
                                  ),
                                  padding: const EdgeInsets.all(8),
                                  margin: const EdgeInsets.only(bottom: 16),
                                  child: Row(
                                    textDirection: TextDirection.ltr,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.network(state.cards[n]!.logo, height: 24,),
                                      const SizedBox(width: 16,),
                                      Text(n, textDirection: TextDirection.ltr, style: const TextStyle(fontSize: 18))
                                    ],
                                  ),
                                )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 8,),

              Expanded(child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all()
                ),
                padding: const EdgeInsets.all(8),
                child: Column(
                  children: [
                    Row(
                      textDirection: TextDirection.rtl,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('وسایل نقلیه', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                        InkWell(
                          onTap: () {
                            AppNavigator.push(Routes.vehiclesRoute);
                          },
                          child: const Icon(
                            Icons.add,
                            color: Colors.black,
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 8,),
                    Expanded(
                      child: SingleChildScrollView(
                        child: state is! CAVShowData ? const SizedBox() : Column(
                          children: [
                            for (String val in state.vehicles)
                              Padding(
                                padding: EdgeInsets.only(bottom: 8),
                                child: _isCarLicense(val) ? _CarLicense(license: val) : _MotorLicense(license: val),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ))
            ],
          ),
        );
      },
    );
  }

  _isCarLicense(String license) => int.tryParse(license) == null;
}

class _CarLicense extends StatelessWidget {
  final String license;
  const _CarLicense({required this.license});

  @override
  Widget build(BuildContext context) {
    List<String> parts = _getLicenseParts(license);

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
          Expanded(child: Text(parts[0], style: TextStyle(fontSize: 18),)),
          Expanded(child: Text(parts[1], style: TextStyle(fontSize: 18),)),
          Expanded(child: Text(parts[2], style: TextStyle(fontSize: 18),)),
          Expanded(child: SizedBox()),
          Container(width: 2, height: double.infinity, color: Colors.black),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Text(
                  'ایران',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w700),
                ),
                Text(parts[3])
              ],
            ),
          )
        ],
      ),
    );
  }

  List<String> _getLicenseParts(String license) {
    String part1 = '', part2 = '', part3 = '', part4 = '';
    part1 = license[0] + license[1];
    part2 = license.length == 10 ? license[2] + license[3] + license[4] : license[2];
    String l = license.replaceAll(part1 + part2, '');
    part3 = l[0] + l[1] + l[2];
    part4 = l[3] + l[4];
    return [part1.toPersian(), part2.toPersian(), part3.toPersian(), part4.toPersian()];
  }
}

class _MotorLicense extends StatelessWidget {
  final String license;
  const _MotorLicense({required this.license});

  @override
  Widget build(BuildContext context) {
    List<String> parts = _getLicenseParts(license);

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
              Expanded(child: Text(parts[0], style: TextStyle(fontSize: 18), textAlign: TextAlign.center,))
            ],
          ),
          SizedBox(height: 16),
          Text(parts[1], style: TextStyle(fontSize: 18),),
          SizedBox(height: 16),
        ],
      ),
    );
  }

  List<String> _getLicenseParts(String license) {
    String part1 = '', part2 = '';
    part1 = license[0] + license[1] + license[2];
    part2 = license.replaceAll(part1, '');
    return [part1.toPersian(), part2.toPersian()];
  }
}
