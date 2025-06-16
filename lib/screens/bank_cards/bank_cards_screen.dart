import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insurance_map/core/app_navigator.dart';
import 'package:insurance_map/core/widget/show_snackbar.dart';
import 'package:insurance_map/core/widget/wait_alert_dialog.dart';
import 'package:insurance_map/data/local/models/card_info.dart';
import 'package:insurance_map/data/remote/model/bank.dart';
import 'package:insurance_map/data/remote/model/card_payment_info.dart';
import 'package:insurance_map/screens/bank_cards/bloc/bank_cards_bloc.dart';
import 'package:insurance_map/utils/extensions_method.dart';
import 'package:app_links/app_links.dart';
import 'package:url_launcher/url_launcher.dart';

class BankCardsScreen extends StatefulWidget {
  const BankCardsScreen({super.key});

  @override
  State<BankCardsScreen> createState() => _BankCardsScreenState();
}

class _BankCardsScreenState extends State<BankCardsScreen> {
  final TextEditingController controller1 = TextEditingController(),
      controller2 = TextEditingController(),
      controller3 = TextEditingController(),
      controller4 = TextEditingController();
  final FocusNode focusNode1 = FocusNode(),
      focusNode2 = FocusNode(),
      focusNode3 = FocusNode(),
      focusNode4 = FocusNode();
  final CardInfo info = CardInfo();
  final Map<String, Bank> savedCards = {};

  BuildContext? _alertContext;

  AppLinks? _appLinks;
  StreamSubscription<Uri>? _linkSub;

  @override
  void initState() {
    super.initState();

    BlocProvider.of<BankCardsBloc>(context).add(BankCardsGetData());

    _appLinks = AppLinks();
    _linkSub = _appLinks!.uriLinkStream.listen((Uri? uri) {
      if (uri != null) {
        // AppNavigator.pop();
        BlocProvider.of<BankCardsBloc>(context).add(BankCardsSubmit());
      }
    });
  }

  @override
  void dispose() {
    _linkSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return BlocListener<BankCardsBloc, BankCardsState>(
      listener: (context, state) {
        if (state is BankCardsLoading) {
          showWaitDialog(context, (p0) => _alertContext = p0);
        } else if (_alertContext != null) {
          Navigator.of(_alertContext!).pop();
          _alertContext = null;
        }

        if (state is BankCardsError) showSnackBar(context, state.message);

        if (state is BankCardsUpdateCard) {
          setState(() {
            if (state.bank == null) {
              info.reset();
            } else {
              info.updateWithBank(state.bank!);
            }
          });
        }

        if (state is BankCardSaved) {
          showSnackBar(context, 'کارت بانکی شما ذخیره شد. در صورت تمایل می توانید کارت دیگری ثبت کنید');
          savedCards.addAll(
            {'${controller1.text} ${controller2.text} ${controller3.text} ${controller4.text}': state.bank}
          );
          controller1.clear();
          controller2.clear();
          controller3.clear();
          controller4.clear();

          setState(() {
            info.reset();
          });
        }

        if (state is BankCardsDone) {
          AppNavigator.pop();
        }

        if (state is BankCardsOpenGateway) _showAlertDialog(state.info);

        if (state is BankCardsShowNumbers) {
          var numbers = state.numbers.map((n, b) {
            return MapEntry(n.formatCardNumber(), b);
          });

          setState(() {
            savedCards.addAll(numbers);
          });
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [BoxShadow(color: Colors.grey, blurRadius: 1.5)],
                    color: Colors.white),
                height: 200,
                width: double.infinity,
                clipBehavior: Clip.antiAlias,
                child: CustomPaint(
                  painter: _CardPainter(info.color),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 16),
                        child: SizedBox(
                          height: 72,
                          child: Row(
                            textDirection: TextDirection.ltr,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              if (info.logo.isNotEmpty)
                                Image.network(
                                  info.logo,
                                  width: 40,
                                ),
                              const SizedBox(width: 16),
                              Text(
                                info.name,
                                style: const TextStyle(fontSize: 18),
                              )
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'شماره کارت ۱۶ رقمی خود را وارد کنید',
                        style: TextStyle(
                            color: Colors.blue[400],
                            fontWeight: FontWeight.w900,
                            fontSize: 19),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        textDirection: TextDirection.ltr,
                        children: [
                          SizedBox(
                              width: min(80, (screenSize.width - 88) / 4),
                              height: 40,
                              child: TextField(
                                controller: controller1,
                                focusNode: focusNode1,
                                decoration: InputDecoration(
                                    enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            style: BorderStyle.solid,
                                            color: Colors.grey[400]!)),
                                    border: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            style: BorderStyle.solid,
                                            color: Colors.grey[400]!)),
                                    counterText: ''),
                                maxLength: 4,
                                maxLines: 1,
                                textAlign: TextAlign.center,
                                keyboardType: TextInputType.number,
                                onChanged: (value) {
                                  if (value.length == 4) focusNode2.requestFocus();
                                },
                              )),
                          SizedBox(
                              width: min(80, (screenSize.width - 88) / 4),
                              height: 40,
                              child: TextField(
                                controller: controller2,
                                focusNode: focusNode2,
                                decoration: InputDecoration(
                                    enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            style: BorderStyle.solid,
                                            color: Colors.grey[400]!)),
                                    border: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            style: BorderStyle.solid,
                                            color: Colors.grey[400]!)),
                                    counterText: ''),
                                maxLength: 4,
                                maxLines: 1,
                                textAlign: TextAlign.center,
                                keyboardType: TextInputType.number,
                                onChanged: (value) {
                                  if (value.length == 2) {
                                    BlocProvider.of<BankCardsBloc>(context).add(
                                        BankCardCheckNumber(
                                            cardNumber: _getCardNumber()));
                                  }
                                  if (value.length == 4) focusNode3.requestFocus();
                                },
                              )),
                          SizedBox(
                              width: min(80, (screenSize.width - 88) / 4),
                              height: 40,
                              child: TextField(
                                controller: controller3,
                                focusNode: focusNode3,
                                decoration: InputDecoration(
                                    enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            style: BorderStyle.solid,
                                            color: Colors.grey[400]!)),
                                    border: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            style: BorderStyle.solid,
                                            color: Colors.grey[400]!)),
                                    counterText: ''),
                                maxLength: 4,
                                maxLines: 1,
                                textAlign: TextAlign.center,
                                keyboardType: TextInputType.number,
                                onChanged: (value) {
                                  if (value.length == 4) focusNode4.requestFocus();
                                },
                              )),
                          SizedBox(
                              width: min(80, (screenSize.width - 88) / 4),
                              height: 40,
                              child: TextField(
                                controller: controller4,
                                focusNode: focusNode4,
                                decoration: InputDecoration(
                                    enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            style: BorderStyle.solid,
                                            color: Colors.grey[400]!)),
                                    border: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            style: BorderStyle.solid,
                                            color: Colors.grey[400]!)),
                                    counterText: ''),
                                maxLength: 4,
                                maxLines: 1,
                                textAlign: TextAlign.center,
                                keyboardType: TextInputType.number,
                                onChanged: (value) {
                                  if (value.length == 4) {
                                    FocusManager.instance.primaryFocus?.unfocus();
                                  }
                                },
                              )),
                        ],
                      )
                    ],
                  ),
                )),
            const SizedBox(height: 16),
            const Align(
              alignment: Alignment.centerRight,
                child: Text('کارت های ذخیره شده')),
            Expanded(child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Column(
                children: [
                  for (var n in savedCards.keys) 
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
                          Image.network(savedCards[n]!.logo, height: 24,),
                          const SizedBox(width: 16,),
                          Text(n, textDirection: TextDirection.ltr, style: const TextStyle(fontSize: 18))
                        ],
                      ),
                    )
                ],
              ),
            )),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 48)),
                      onPressed: () {
                        BlocProvider.of<BankCardsBloc>(context).add(BankCardSaveCard(cardNumber: _getCardNumber()));
                      },
                      child: Text(
                        'ذخیره کارت',
                        style: TextStyle(color: Colors.grey[700]),
                      )),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 48)),
                      onPressed: () {
                        BlocProvider.of<BankCardsBloc>(context).add(BankCardsSubmit());
                      },
                      child: Text(
                        'تائید نهایی‌',
                        style: TextStyle(color: Colors.grey[700]),
                      )),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  _showAlertDialog(CardPaymentInfo info) {
    showDialog(
      context: context,
      builder: (context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            title: const Text(''),
            content: Text(info.getMessage()),
            actions: [
              TextButton(onPressed: (){
                Navigator.of(context).pop();
                launchUrl(Uri.parse(info.link), mode: LaunchMode.externalApplication);
              }, child: const Text('تائید')),
              TextButton(onPressed: (){
                Navigator.of(context).pop();
                AppNavigator.pop();
              }, child: const Text('فعلا نه'))
            ],
          ),
        );
      },
    );
  }

  String _getCardNumber([bool forShow = false]) {
    String seperator = forShow ? ' ' : '',
        v1 = controller1.text,
        v2 = controller2.text,
        v3 = controller3.text,
        v4 = controller4.text;
      
    return '${v1.isNotEmpty ? v1 : '-'}$seperator${v2.isNotEmpty ? v2 : '-'}$seperator${v3.isNotEmpty ? v3 : '-'}$seperator${v4.isNotEmpty ? v4 : '-'}';
  }
}

class _CardPainter extends CustomPainter {
  final Color _color;
  _CardPainter(this._color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = _color;

    canvas.drawCircle(const Offset(50, 50), 90, paint);
    canvas.drawCircle(Offset(size.width - 50, 50), 20, paint);
    canvas.drawRRect(
        RRect.fromLTRBR(size.width - 200, size.height - 40, size.width - 30,
            size.height - 20, const Radius.circular(8)),
        paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
