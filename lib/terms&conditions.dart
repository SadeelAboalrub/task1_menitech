import 'package:flutter/material.dart';

class TermsAndConditionsPage extends StatefulWidget {
  const TermsAndConditionsPage({super.key});

  @override
  State<TermsAndConditionsPage> createState() => _TermsAndConditionsPageState();
}

class _TermsAndConditionsPageState extends State<TermsAndConditionsPage> {
  bool isAccepted = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Terms & Conditions",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 1,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const Text(
              "Lorem ipsum dolor sit amet, consectetur adipiscing elit. "
              "Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. "
              "Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris "
              "nisi ut aliquip ex ea commodo consequat.",
              style: TextStyle(fontSize: 16, height: 1.5),
            ),

            const Spacer(),

            Row(
              children: [
                Checkbox(
                  value: isAccepted,
                  onChanged: (value) {
                    setState(() {
                      isAccepted = value ?? false;
                    });
                  },
                ),
                const Expanded(
                  child: Text(
                    "I agree to the Terms & Conditions.",
                    style: TextStyle(fontSize: 15),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isAccepted ? () {} : null,
                child: const Text("Continue"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
