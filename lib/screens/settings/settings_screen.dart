import 'package:flutter/material.dart';
import 'package:pluseplay/screens/settings/settingSub/aboutUs.dart';
import 'package:pluseplay/screens/settings/settingSub/contactus.dart';
import 'package:pluseplay/screens/settings/settingSub/privacyPolicy.dart';
import 'package:pluseplay/screens/settings/settingSub/termsCondit.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 13, 3, 56),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        title: const Text(
          'Settings',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.black87, Color.fromARGB(255, 12, 5, 144)],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.info, color: Colors.lightBlueAccent),
              title: TextButton(
                onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>const AboutUsPage()));
                },
                style: TextButton.styleFrom(alignment: Alignment.centerLeft), 
                child: const Text('About Us', style: TextStyle(color: Colors.white)),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.lock, color: Colors.purpleAccent),
              title: TextButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>const PrivacyPolicyPage()));
                },
                style: TextButton.styleFrom(alignment: Alignment.centerLeft), 
                child: const Text('Privacy Policy', style: TextStyle(color: Colors.white)),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.gavel, color: Colors.greenAccent),
              title: TextButton(
                onPressed: () {
                 Navigator.push(context, MaterialPageRoute(builder: (context)=>const TermsAndConditionsPage()));
                },
                style: TextButton.styleFrom(alignment: Alignment.centerLeft), 
                child: const Text('Terms & Conditions', style: TextStyle(color: Colors.white)),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.contact_mail, color: Colors.cyanAccent),
              title: TextButton(
                onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>const ContactUsPage()));
                },
                style: TextButton.styleFrom(alignment: Alignment.centerLeft), 
                child: const Text('Contact Us', style: TextStyle(color: Colors.white)),
              ),
            ),
            const Spacer(),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  'Version 1.0.0',
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
