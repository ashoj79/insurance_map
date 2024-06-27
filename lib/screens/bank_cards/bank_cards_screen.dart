import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insurance_map/core/widget/show_snackbar.dart';
import 'package:insurance_map/core/widget/wait_alert_dialog.dart';
import 'package:insurance_map/data/local/models/card_info.dart';
import 'package:insurance_map/screens/bank_cards/bloc/bank_cards_bloc.dart';

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

  BuildContext? _alertContext;

  @override
  void initState() {
    super.initState();

    BlocProvider.of<BankCardsBloc>(context).add(BankCardsGetBanks());
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return BlocListener<BankCardsBloc, BankCardsState>(
      listener: (context, state) {
        if (state is BackButtonDispatcher) {
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
          showSnackBar(context, 'کارت بانکی شما ذخیره شد');
          controller1.clear();
          controller2.clear();
          controller3.clear();
          controller4.clear();

          setState(() {
            info.reset();
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
                            fontSize: 22),
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
            const Expanded(child: SizedBox()),
            OutlinedButton(
                style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 48)),
                onPressed: () {
                  BlocProvider.of<BankCardsBloc>(context).add(BankCardSaveCard(cardNumber: _getCardNumber()));
                },
                child: Text(
                  'ذخیره',
                  style: TextStyle(color: Colors.grey[700]),
                ))
          ],
        ),
      ),
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
