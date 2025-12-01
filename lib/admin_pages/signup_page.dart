import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:first_task/commonPages/customTextFeild.dart';
import 'package:first_task/commonPages/customButton.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _repeatPasswordController = TextEditingController();

  Future<void> _signup() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
          );

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
            'name': _nameController.text.trim(),
            'email': _emailController.text.trim(),
            'phone': _phoneController.text.trim(),
            'isAdmin':false,
            'createdAt': FieldValue.serverTimestamp(),
          });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Account created! Please login.')));

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Signup failed: $e')));
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(24),
            child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                child: Form(
                  key: _formKey,
                  child: AbsorbPointer(
                    absorbing: isLoading,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Create Account',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2575FC),
                          ),
                        ),
                        SizedBox(height: 30),

                        CustomTextField(
                          controller: _nameController,
                          hint: "Name",
                          prefixIcon: Icons.person_2_outlined,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter your name';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 15),

                        CustomTextField(
                          controller: _emailController,
                          hint: "Email",
                          prefixIcon: Icons.email_outlined,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter your email';
                            }
                            if (!RegExp(
                              r'^[a-zA-Z0-9._%+-]+@(gmail\.com|yahoo\.com)$',
                            ).hasMatch(value)) {
                              return 'Please enter a valid email';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 15),

                        CustomTextField(
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          hint: "Phone NO.",
                          prefixIcon: Icons.phone_outlined,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter your phone number';
                            }
                            if (!RegExp(r'^07[7-9]\d{7}$').hasMatch(value)) {
                              return 'Enter a valid phone number';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 15),

                        CustomTextField(
                          controller: _passwordController,
                          obscureText: true,
                          hint: "Password",
                          prefixIcon: Icons.password_outlined,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter password';
                            }
                            if (value.trim().length < 6) {
                              return 'Password must be at least 6 characters';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 15),

                        CustomTextField(
                          controller: _repeatPasswordController,
                          obscureText: true,
                          hint: "Repeat Password",
                          prefixIcon: Icons.password_outlined,
                          validator: (value) {
                            if (value != _passwordController.text) {
                              return "Passwords don't match";
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 25),

                        SizedBox(
                          width: double.infinity,
                          child: isLoading
                              ? Center(child: CircularProgressIndicator())
                              : CustomButton(
                                  onPressed: _signup,
                                  text: 'Signup',
                                ),
                        ),
                        SizedBox(height: 15),

                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LoginPage(),
                              ),
                            );
                          },
                          child: Text(
                            'Already have an account? Login',
                            style: TextStyle(
                              color: Colors.blueAccent,
                              fontSize: 16,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
  }
}
