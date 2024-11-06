import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

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
          'Privacy Policy',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.black87, Color.fromARGB(255, 12, 5, 144)],
            ),
          ),
          padding: const EdgeInsets.all(16.0),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16), 
              Text(
                'Privacy Policy',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'We at PlusPlay respect your privacy and are committed to protecting your personal information. '
                'This Privacy Policy outlines how we collect, use, and safeguard your data while you use the app.',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 16),
              Text(
                '1. Information We Collect:\nWe may collect personal information such as your name, email address, and usage data. '
                'This information helps us provide better service and improve the app.',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 16),
              Text(
                '2. How We Use Your Information:\nThe data we collect is used to personalize your experience, respond to your inquiries, '
                'and improve our app’s performance. We do not sell or share your information with third parties without your consent.',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 16),
              Text(
                '3. Data Security:\nWe take appropriate measures to protect your personal information from unauthorized access, '
                'alteration, or disclosure. However, no method of transmission over the Internet or method of electronic storage is completely secure.',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 16),
              Text(
                '4. Changes to this Policy:\nWe may update this Privacy Policy from time to time. Any changes will be posted in the app, '
                'and it is your responsibility to review the policy periodically.',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 40), 
              Center(
                child: Text(
                  'Version 1.0.0',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),
              ),
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
