import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:insurance_map/core/widget/show_snackbar.dart';
import 'package:insurance_map/data/local/shared_preference_helper.dart';
import 'package:insurance_map/data/local/temp_db.dart';
import 'package:insurance_map/utils/di.dart';
// import 'package:social_share/social_share.dart';
import 'package:url_launcher/url_launcher.dart';

class InviteScreen extends StatelessWidget {
  const InviteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    String code = locator<SharedPreferenceHelper>().getInviteCode();

    return Container(
      color: const Color(0xFFFCFCFC),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Expanded(child: Image.asset('assets/img/invite.png')),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.black, fontSize: 22),
              children: [
                const TextSpan(text: 'دوستاتون رو دعوت کنین و '),
                TextSpan(text: '۲۰,۰۰۰ تومان اعتبار هدیه', style: TextStyle(color: theme.primaryColor)),
                const TextSpan(text: ' بگیرین!')
              ]
            ),
          ),
          const SizedBox(height: 32),
          const Text(
            'کد معرفی شما',
            style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black, fontSize: 22),
          ),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF1F1F1),
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              code,
              style: const TextStyle(fontSize: 24, color: Color(0xff606060), fontWeight: FontWeight.w600),
            ),
          ),
          GestureDetector(
            onTap: () {
              Clipboard.setData(ClipboardData(text: code));
              showSnackBar(context, 'کپی شد');
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              textDirection: TextDirection.rtl,
              children: [
                Icon(
                  Icons.copy,
                  color: theme.primaryColor,
                ),
                const SizedBox(width: 4),
                Text(
                  'کپی کد',
                  style: TextStyle(color: theme.primaryColor, fontSize: 18),
                ),
              ],
            ),
          ),
          const SizedBox(height: 48),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            textDirection: TextDirection.ltr,
            children: [
              GestureDetector(
                onTap: () {
                  // SocialShare.shareTelegram(_getMessage());
                },
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16)
                      ),
                      padding: const EdgeInsets.all(16),
                      margin: const EdgeInsets.only(bottom: 8),
                      child: Icon(
                        Icons.telegram,
                        color: theme.primaryColor,
                      ),
                    ),
                    const Text(
                      'تلگرام',
                      style: TextStyle(color: Color(0xFF1E1F22), fontSize: 16, fontWeight: FontWeight.w600),
                    )
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  // SocialShare.shareSms(_getMessage());
                },
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16)
                      ),
                      padding: const EdgeInsets.all(16),
                      margin: const EdgeInsets.only(bottom: 8),
                      child: Icon(
                        Icons.sms_outlined,
                        color: theme.primaryColor,
                      ),
                    ),
                    const Text(
                      'پیامک',
                      style: TextStyle(color: Color(0xFF1E1F22), fontSize: 16, fontWeight: FontWeight.w600),
                    )
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  shareViaEmail();
                },
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16)
                      ),
                      padding: const EdgeInsets.all(16),
                      margin: const EdgeInsets.only(bottom: 8),
                      child: Icon(
                        Icons.alternate_email,
                        color: theme.primaryColor,
                      ),
                    ),
                    const Text(
                      'ایمیل',
                      style: TextStyle(color: Color(0xFF1E1F22), fontSize: 16, fontWeight: FontWeight.w600),
                    )
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  // SocialShare.shareOptions(_getMessage());
                },
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16)
                      ),
                      padding: const EdgeInsets.all(16),
                      margin: const EdgeInsets.only(bottom: 8),
                      child: Icon(
                        Icons.share,
                        color: theme.primaryColor,
                      ),
                    ),
                    const Text(
                      'اشتراک گذاری',
                      style: TextStyle(color: Color(0xFF1E1F22), fontSize: 16, fontWeight: FontWeight.w600),
                    )
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 64)
        ],
      ),
    );
  }
  
  String _getMessage() {
    String text = TempDB.getMessage('in-app-text-share-app'),
        code = locator<SharedPreferenceHelper>().getInviteCode();
    text = text.replaceAll(':code', code);
    return text;
  }

  void shareViaEmail() async {
    String subject = 'معرفی اپلیکیشن بیمرزان', body = _getMessage();
    final Uri uri = Uri(
      scheme: 'mailto',
      query: 'subject=$subject&body=$body'
    );
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}
