import '../../widgets/responsive_layout.dart';
import 'dart:io';
import 'package:electrician/ui/pages/settings_screen/exam_date_screen.dart';
import 'package:electrician/ui/pages/settings_screen/privacy_policy_screen.dart';
import 'package:electrician/ui/widgets/common_widget.dart';
import 'package:flutter/material.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../util/app_constants.dart';
import '../../../util/util.dart';

class SettingsScreen extends StatefulWidget {
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool notificationsOn = false;
  bool darkMode = false;

  @override
  void initState() {
    super.initState();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    padding: EdgeInsets.all(MediaQuery.sizeOf(context).width >= 700 ? 32 : 16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeading(
          'Settings',
          subtitle: 'Plan your study schedule and find support.',
        ),
        Card(
          margin: EdgeInsets.zero,
          child: ListTile(
            leading: const Icon(Icons.calendar_today_outlined),
            title: const Text('Exam Date'),
            subtitle: Text(getExamDate()),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => CalendarPage()),
            ),
          ),
        ),
        const SizedBox(height: 32),
        const SectionHeading('Help & support'),
        AdaptiveGrid(
          minItemWidth: 280,
          children: [
            _setting('Share App', Icons.share_outlined, () async {
              final url = Platform.isAndroid
                  ? androidUrl
                  : Platform.isIOS
                  ? iosUrl
                  : webUrl;
              final box = context.findRenderObject() as RenderBox?;
              await SharePlus.instance.share(
                ShareParams(
                  text: 'Check out $app_title: $url',
                  sharePositionOrigin: box == null
                      ? null
                      : box.localToGlobal(Offset.zero) & box.size,
                ),
              );
            }),
            _setting(
              'Terms & Conditions',
              Icons.description_outlined,
              () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      PrivacyPolicyScreen(title: 'Terms & Conditions'),
                ),
              ),
            ),
            _setting('Report issue', Icons.help_outline, _sendEmail),
            _setting('Rate Us', Icons.star_outline, () => appReview(context)),
            _setting(
              'Privacy Policy',
              Icons.security_outlined,
              () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PrivacyPolicyScreen(title: 'Privacy Policy'),
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
  Widget _setting(String title, IconData icon, VoidCallback onTap) => Card(
    margin: EdgeInsets.zero,
    child: ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    ),
  );
}

Future<void> appReview(BuildContext context) async {
  final InAppReview _inAppReview = InAppReview.instance;

  if (await _inAppReview.isAvailable()) {
    _inAppReview.requestReview(); // Triggers the native rating dialog
  } else {
    if (Platform.isAndroid) {
      _inAppReview.openStoreListing(
        appStoreId: 'com.example.yourapp',
      ); // Replace with your Android package name
    } else if (Platform.isIOS) {
      _inAppReview.openStoreListing(
        appStoreId: iosUrl,
      ); // Replace with your App Store ID
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('In-App Review not available on this platform.'),
        ),
      );
    }
  }
}

final String email = 'tariqul1993@gmail.com'; // Your support email
final String subject = 'App Issue Report for ${app_title}';

void _sendEmail() async {
  final Uri emailUri = Uri(
    scheme: 'mailto',
    path: email,
    query: 'subject=$subject&body=Describe your issue here...',
  );

  if (await canLaunchUrl(emailUri)) {
    await launchUrl(emailUri);
  } else {
    print('Could not launch email client');
  }
}
