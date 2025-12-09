import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:first_task/core/widgets/customButton.dart';
import 'package:first_task/core/widgets/customTextFeild.dart';

class AddAdminPage extends StatefulWidget {
  const AddAdminPage({super.key});

  @override
  State<AddAdminPage> createState() => _AddAdminPageState();
}

class _AddAdminPageState extends State<AddAdminPage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final phoneController = TextEditingController();

  bool loading = false;

  bool _isPhoneValid(String phone) {
    final phoneRegex = RegExp(r"^\+9627[7-9][0-9]{7}$|^07[7-9][0-9]{7}$");
    return phoneRegex.hasMatch(phone);
  }

  Future<void> addAdmin() async {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final phone = phoneController.text.trim();

    if (name.isEmpty || email.isEmpty || password.isEmpty || phone.isEmpty) {
      showError("All fields are required");
      return;
    }

    if (!_isPhoneValid(phone)) {
      showError("Invalid Jordanian phone number");
      return;
    }

    setState(() => loading = true);

    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await FirebaseFirestore.instance.collection("users").add({
        "name": name,
        "email": email,
        "password": password,
        "phone": phone,
        "uid": userCredential.user!.uid,
        "isAdmin": true,
        "createdAt": FieldValue.serverTimestamp(),
      });

      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Admin added successfully!")),
      );
    } catch (e) {
      showError(e.toString());
    }

    setState(() => loading = false);
  }

  void showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add New Admin")),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CustomTextField(controller: nameController, hint: "Admin Name"),
            const SizedBox(height: 20),
            CustomTextField(controller: emailController, hint: "Email"),
            const SizedBox(height: 20),
            CustomTextField(controller: passwordController, hint: "Password"),
            const SizedBox(height: 20),
            CustomTextField(controller: phoneController, hint: "Phone Number"),
            const SizedBox(height: 25),

            loading
                ? const CircularProgressIndicator()
                : CustomButton(
                    text: "Add Admin",
                    onPressed: addAdmin,
                  ),
          ],
        ),
      ),
    );
  }
}
