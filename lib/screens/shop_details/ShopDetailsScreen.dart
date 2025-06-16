import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insurance_map/core/widget/show_snackbar.dart';
import 'package:insurance_map/core/widget/wait_alert_dialog.dart';
import 'package:insurance_map/screens/shop_details/bloc/shop_details_bloc.dart';

class ShopDetailsScreen extends StatefulWidget {
  const ShopDetailsScreen({super.key});

  @override
  State<ShopDetailsScreen> createState() => _ShopDetailsScreenState();
}

class _ShopDetailsScreenState extends State<ShopDetailsScreen> {
  Map<String, String> data = {};
  String id = '';
  final TextEditingController _amountController = TextEditingController();
  BuildContext? _alertContext;

  @override
  Widget build(BuildContext context) {
    var d = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    data = d['data'];
    id = d['id'];

    return BlocListener<ShopDetailsBloc, ShopDetailsState>(
      listener: (context, state) {
        if (_alertContext != null) {
          Navigator.of(_alertContext!).pop();
          _alertContext = null;
        }

        if (state is ShopDetailsLoading) {
          showWaitDialog(context, (context) => _alertContext = context);
        }

        if (state is ShopDetailsMessage) {
          showSnackBar(context, state.message);
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            for (var item in data.entries)
              Row(
                children: [
                  Text(
                    '${item.key}:',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Text(
                    item.value,
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            const SizedBox(
              height: 16,
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  _showAlertDialog();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
                child: const Text('دریافت تخفیف'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAlertDialog() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        _alertContext = context;
        return AlertDialog(
          title: const Text('دریافت تخفیف',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          content: Directionality(
            textDirection: TextDirection.rtl,
            child: TextField(
              controller: _amountController,
              decoration: const InputDecoration(
                  labelText: 'مبلغ خرید', counterText: ''),
              maxLines: 1,
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                BlocProvider.of<ShopDetailsBloc>(context).add(ShopDetailsCreateRequest(vendorId: id, amount: _amountController.text));
                _amountController.text = '';
              },
              child: const Text('دریافت تخفیف'),
            ),
          ],
        );
      },
    );
  }
}
