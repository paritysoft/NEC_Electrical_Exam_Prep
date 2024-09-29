import 'package:commonquiz/ui/widgets/common_widget.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool notificationsOn = false;
  bool darkMode = false;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        // Premium banner section
        Container(
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
        SizedBox(height: 24),

        // Exam Date section
        ListTile(
          leading: Icon(Icons.calendar_today_outlined),
          title: smallLabel(context, 'Exam Date'),
          trailing:
          smallLabel(context, 'October 17, 2024', color: Colors.orange),
          onTap: () {
            // Action on tap
          },
        ),

        // Dark Mode switch
        ListTile(
          leading: Icon(Icons.brightness_6),
          title: smallLabel(context, 'Dark Mode'),
          trailing: Switch(
            value: darkMode,
            onChanged: (value) {
              setState(() {
                darkMode = value;
              });
            },
          ),
        ),

        // Notification section header
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: smallLabel(context,
            'NOTIFICATION',
           color: Colors.grey,
          ),
        ),

        // Turn on Notifications switch
        ListTile(
          leading: Icon(Icons.notifications_none),
          title: smallLabel(context, 'Turn On Notification'),
          trailing: Switch(
            value: notificationsOn,
            onChanged: (value) {
              setState(() {
                notificationsOn = value;
              });
            },
          ),
        ),

        // Reset Progress
        ListTile(
          leading: Icon(Icons.refresh),
          title: smallLabel(context,'Reset All'),
          onTap: () {
            // Action on tap
          },
        ),

        // Help & Support section header
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: smallLabel(context,
            'HELP & SUPPORT',
             color: Colors.grey,
          ),
        ),

        // Share App
        ListTile(
          leading: Icon(Icons.share),
          title: smallLabel(context, 'Share App'),
          onTap: () {
            // Action on tap
          },
        ),
        // Rate Us
        ListTile(
          leading: Icon(Icons.star_rate_rounded),
          title: smallLabel(context,'Rate Us'),
          onTap: () {
            // Action on tap
          },
        ),
        // Terms of Use
        ListTile(
          leading: Icon(Icons.description),
          title: smallLabel(context,'Terms of use'),
          onTap: () {
            // Action on tap
          },
        ),
        // Terms of Use
        ListTile(
          leading: Icon(Icons.description_outlined),
          title: smallLabel(context,'Report issue'),
          onTap: () {
            // Action on tap
          },
        ),

        // Privacy Policy
        ListTile(
          leading: Icon(Icons.security_outlined),
          title: smallLabel(context,'Privacy Policy'),
          onTap: () {
            // Action on tap
          },
        ),
      ],
    );
  }
}
