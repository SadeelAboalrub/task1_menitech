import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_task/common/widgets/customButton.dart';
import 'package:first_task/common/widgets/customTextFeild.dart';
import 'package:first_task/features/client/presentation/home/ui/home_page.dart';
import 'package:first_task/features/auth/presentation/signup_page.dart';
import 'package:flutter/material.dart';
import '../../admin/presentation/home/ui/admin_home_page.dart';


class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isLoading = false;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => isLoading = true);

    try {
      UserCredential credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
          );
      final uid = credential.user!.uid;

      DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .get();

      if(!userDoc.exists) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("User data not found in Firestore"))
        );
        return;
      }

      bool isAdmin = userDoc['isAdmin'] ?? false;

      if(isAdmin) {
        Navigator.pushReplacement(
          context, 
          MaterialPageRoute(builder: (context) => AdminHomePage()),
        );
      }else{
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage(isAdmin: false)), 
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Login Failed : $e')));
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: AbsorbPointer(
                absorbing: isLoading,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Gemora Jewellery',
                      style: TextStyle(
                        fontSize: 24,
                        fontFamily: 'GoogleFont',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 40),

                    CustomTextField(
                      hint: "Email",
                      controller: _emailController,
                      prefixIcon: Icons.email_outlined,

                      validator: (value) {
                        if (value == null || value.isEmpty)
                          return 'Please Enter Your Email';
                        if (!RegExp(
                          r'^[a-zA-Z0-9._%+-]+@(gmail\.com|yahoo\.com)$',
                        ).hasMatch(value)) {
                          return 'Enter a valid Email';
                        }
                        return null;
                      },
                    ),

                    SizedBox(height: 20),

                    CustomTextField(
                      hint: "Password",
                      controller: _passwordController,
                      prefixIcon: Icons.password_outlined,
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty)
                          return 'Please enter your Password';
                        if (value.length < 6) return 'Wrong Password';
                        return null;
                      },
                    ),

                    SizedBox(height: 25),

                    SizedBox(
                      width: double.infinity,
                      child: isLoading
                          ? Center(child: CircularProgressIndicator())
                          : CustomButton(text: "Login", onPressed: _login),
                    ),

                    SizedBox(height: 15),

                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SignupPage()),
                        );
                      },
                      child: Text(
                        'Don\'t have an account? Signup',
                        style: TextStyle(
                          color: Colors.blueAccent,
                          fontSize: 16,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),

                    SizedBox(height: 15),

                    GestureDetector(
                      onTap: () {},
                      child: Text(
                        'Forgot Password ?',
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
    );
  }
}
