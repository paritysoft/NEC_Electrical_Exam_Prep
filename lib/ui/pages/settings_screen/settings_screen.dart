import 'dart:io';
import 'package:electrician/subscription/core/sharepref_helper.dart';
import 'package:electrician/ui/pages/settings_screen/exam_date_screen.dart';
import 'package:electrician/ui/pages/settings_screen/privacy_policy_screen.dart';
import 'package:electrician/ui/widgets/common_widget.dart';
import 'package:flutter/material.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

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
    setState(() {
    });
  }
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        InkWell(
          onTap: (){
            if (SharedPreferenceHelper.getSubscription() == false) {
              gotToSubscriptionPage(context);
            }else{
              snackBar(context, "You are already in premium version");
            }
          },
          child: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.amberAccent[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    title15BoldColor(context,
                      'Upgrade to the Premium'),
                    const SizedBox(height: 4),
                    smallLabel(context, 'Get a personal learning plan', textSize: 14),
                  ],
                ),
                const Spacer(),
                Image.asset("assets/images/ic_premium.png",
                    height: 40, width: 40, fit: BoxFit.cover),
              ],
            ),
          ),
        ),
        SizedBox(height: 24),

        // Exam Date section
        Card(
          color: Colors.white,
          child: ListTile(
            leading: Icon(Icons.calendar_today_outlined),
            title: smallLabel(context, 'Exam Date'),
            trailing:
            smallLabel(context, getExamDate(), color: Colors.orange),
            onTap: () {
              // Action on tap
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => CalendarPage()));
            },
          ),
        ),

        // Dark Mode switch
        // Card(
        //   color: Colors.white,
        //   child: ListTile(
        //     leading: Icon(Icons.brightness_6),
        //     title: smallLabel(context, 'Dark Mode'),
        //     trailing: Switch(
        //       value: darkMode,
        //       onChanged: (value) {
        //         setState(() {
        //           darkMode = value;
        //         });
        //       },
        //     ),
        //   ),
        // ),

        // // Notification section header
        // Padding(
        //   padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 5),
        //   child: title15BoldColor(context,
        //     'NOTIFICATION',
        //    color: Colors.grey,
        //   ),
        // ),

        // Turn on Notifications switch
        // Card(
        //   color: Colors.white,
        //   child: ListTile(
        //     leading: Icon(Icons.notifications_none),
        //     title: smallLabel(context, 'Turn On Notification'),
        //     trailing: Switch(
        //       value: notificationsOn,
        //       onChanged: (value) {
        //         setState(() {
        //           notificationsOn = value;
        //         });
        //       },
        //     ),
        //   ),
        // ),

        // Reset Progress
        // Card(
        //   color: Colors.white,
        //   child: ListTile(
        //     leading: Icon(Icons.refresh),
        //     title: smallLabel(context,'Reset All'),
        //     onTap: () {
        //       // Action on tap
        //     },
        //   ),
        // ),

        // Help & Support section header
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 5),
          child: title15BoldColor(context,
            'HELP & SUPPORT',
             color: Colors.grey,
          ),
        ),

        // Share App
        Card(
          color: Colors.white,
          child: ListTile(
            leading: Icon(Icons.share),
            title: smallLabel(context, 'Share App'),
            onTap: () {
              // Action on tap

              if (Platform.isAndroid) {
                Share.share('Check out this app on Android: https://play.google.com/store/apps/details?id=com.mole.limsp');
              } else if (Platform.isIOS) {
                Share.share('Check out this app on iOS: https://apps.apple.com/app/com.mole.lims');
              } else {
                // For other platforms, like web or desktop
                Share.share('Check out this app: https://yourappwebsite.com');
              }

            },
          ),
        ),
        Card(
          color: Colors.white,
          child: ListTile(
            leading: Icon(Icons.description),
            title: smallLabel(context,'Terms & Conditions'),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => PrivacyPolicyScreen(title: "Terms & Conditions")));
            },
          ),
        ),
        // Terms of Use
        Card(
          color: Colors.white,
          child: ListTile(
            leading: Icon(Icons.description_outlined),
            title: smallLabel(context,'Report issue'),
            onTap: () {
              // Action on tap
              _sendEmail();
            },
          ),
        ),
        // Rate Us
        Card(
          color: Colors.white,
          child: ListTile(
            leading: Icon(Icons.star_rate_rounded),
            title: smallLabel(context,'Rate Us'),
            onTap: () {
              // Action on tap
              appReview(context);
            },
          ),
        ),
        // Terms of Use


        // Privacy Policy
        Card(
          color: Colors.white,
          child: ListTile(
            leading: Icon(Icons.security_outlined),
            title: smallLabel(context,'Privacy Policy'),
            onTap: () {
              // Action on tap
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => PrivacyPolicyScreen(title: "Privacy Policy")));
            },
          ),
        ),
      ],
    );
  }
}
Future<void> appReview(BuildContext context) async {
  final InAppReview _inAppReview = InAppReview.instance;


  if (await _inAppReview.isAvailable()) {
    _inAppReview.requestReview(); // Triggers the native rating dialog
  } else {
    // Fallback to manually open the store page
    if (Platform.isAndroid) {
      _inAppReview.openStoreListing(
          appStoreId: 'com.example.yourapp'); // Replace with your Android package name
    } else if (Platform.isIOS) {
      _inAppReview.openStoreListing(
          appStoreId: 'XXXXXXXXX'); // Replace with your App Store ID
    } else {
      // Handle other platforms (e.g., web)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('In-App Review not available on this platform.'),
        ),
      );
    }
  }
}

final String email = 'tariqul1993@gmail.com'; // Your support email
final String subject = 'App Issue Report';

void _sendEmail() async {
  final Uri emailUri = Uri(
    scheme: 'mailto',
    path: email,
    query: 'subject=$subject&body=Describe your issue here...',
  );

  if (await canLaunchUrl(emailUri)) {
    await launchUrl(emailUri);
  } else {
    // Handle the error if the device cannot launch email
    print('Could not launch email client');
  }
}