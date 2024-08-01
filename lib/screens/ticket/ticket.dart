import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insurance_map/core/widget/show_snackbar.dart';
import 'package:insurance_map/core/widget/wait_alert_dialog.dart';
import 'package:insurance_map/screens/ticket/bloc/ticket_bloc.dart';

class TicketScreen extends StatefulWidget {
  const TicketScreen({super.key});

  @override
  State<TicketScreen> createState() => _TicketScreenState();
}

class _TicketScreenState extends State<TicketScreen> {
  final _titleController = TextEditingController(),
      _messageController = TextEditingController();

  String _selectedPriority = 'low';
  BuildContext? _alertContext;

  @override
  Widget build(BuildContext context) {
    return BlocListener<TicketBloc, TicketState>(
      listener: (context, state) {
        if (state is TicketLoading) {
          showWaitDialog(context, (p0) => _alertContext = p0);
        } else if (_alertContext != null) {
          Navigator.of(_alertContext!).pop();
          _alertContext = null;
        }

        if (state is TicketError) showSnackBar(context, state.msg);

        if (state is TicketSuccess) {
          _titleController.clear();
          _messageController.clear();
          _showAlertDialog();
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(child: SingleChildScrollView(
              child: Column(
                children: [
                  Directionality(
                    textDirection: TextDirection.rtl,
                    child: TextField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                        labelText: 'عنوان',),
                    ),
                  ),
                  SizedBox(height: 16),
                  Text('اولویت تیکت', style: TextStyle(fontWeight: FontWeight.w600)),
                  DropdownButton(
                    isExpanded: true,
                    value: _selectedPriority,
                    items: const [
                      DropdownMenuItem(
                        value: 'low',
                        child: Text('کم'),
                      ),
                      DropdownMenuItem(
                        value: 'medium',
                        child: Text('متوسط'),
                      ),
                      DropdownMenuItem(
                        value: 'high',
                        child: Text('زیاد'),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedPriority = value!;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  Directionality(
                    textDirection: TextDirection.rtl,
                    child: TextField(
                      controller: _messageController,
                      decoration: const InputDecoration(
                        labelText: 'متن پیام‌',

                      ),
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                      minLines: 6,
                      textAlignVertical: TextAlignVertical.top,
                    ),
                  ),
                ],
              ),
            )),
            OutlinedButton(
                style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 48)),
                onPressed: () {
                  BlocProvider.of<TicketBloc>(context).add(
                      TicketSend(title: _titleController.text, message: _messageController.text, priority: _selectedPriority));
                },
                child: Text(
                  'ثبت تیکت',
                  style: TextStyle(color: Colors.grey[700]),
                ))
          ],
        ),
      ),
    );
  }

  _showAlertDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            title: const Text(''),
            content: const Text(
                'درخواست شما ثبت شد. به زودی همکاران ما بررسی می کنند و نتیجه از طریق پیامک برای شما ارسال می شود'
            ),
            actions: [
              TextButton(onPressed: (){
                Navigator.of(context).pop();
              }, child: const Text('متوجه شدم')),
            ],
          ),
        );
      },
    );
  }
}
