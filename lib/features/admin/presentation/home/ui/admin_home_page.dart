//import 'package:first_task/adminPages/ProductListPage.dart';
import 'package:first_task/core/widgets/customButton.dart';
import 'package:first_task/core/widgets/customTextFeild.dart';
import 'package:first_task/features/admin/presentation/add_categories.dart';
import 'package:first_task/features/admin/presentation/add_products.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:first_task/common/res/app_colors.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  State<StatefulWidget> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  List<Map<String, String>> admins = [];

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Dashboard"),
        actions: const [
          Icon(Icons.notifications_outlined),
          SizedBox(width: 10),
          Icon(Icons.settings),
          SizedBox(width: 10),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddAdminDialog(),
        child: const Icon(Icons.add),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                leading: const Icon(
                  Icons.category,
                  color: Color.fromARGB(255, 10, 14, 16),
                  size: 30,
                ),
                title: const Text(
                  "Manage Categories",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                subtitle: const Text("Add categories"),
                trailing: CustomButton(
                  text: "Add Category",
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddCategoryPage(),
                      ),
                    );
                  },
                ),
              ),
            ),
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                leading: const Icon(
                  Icons.category,
                  color: Color.fromARGB(255, 15, 20, 24),
                  size: 30,
                ),
                title: const Text(
                  "Add Products",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                trailing: CustomButton(
                  text: "Add Product",
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductListPage(),
                      ),
                    );
                  },
                ),
              ),
            ),

            const SizedBox(height: 25),

            const Text(
              "Admins List",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 15),

            ...admins.map(
              (admin) => Card(
                child: ListTile(
                  title: Text(admin['name']!),
                  subtitle: Text(
                    "${admin['email']} • Password: ${admin['password']}",
                  ),
                  leading: const Icon(Icons.person, color: Colors.black),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {
                      try {
                        String docId = admin['docId']!;
                        await FirebaseFirestore.instance
                            .collection('users')
                            .doc(docId)
                            .delete();

                        setState(() => admins.remove(admin));

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Admin deleted successfully"),
                          ),
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Failed to delete admin: $e")),
                        );
                      }
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddAdminDialog() {
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final phoneController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add New Admin"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomTextField(controller: nameController, hint: "Admin Name"),
              SizedBox(height: 20),
              CustomTextField(
                controller: emailController,
                hint: "Admin Email",
                obscureText: true,
              ),
              SizedBox(height: 20),
              CustomTextField(controller: passwordController, hint: "Password"),
              SizedBox(height: 20),
              CustomTextField(
                controller: phoneController,
                hint: "Admin Phone No.",
              ),
            ],
          ),
          actions: [
            CustomButton(
              text: "Cancel",
              onPressed: () => Navigator.pop(context),
            ),
            CustomButton(
              text: "Add",
              onPressed: () async {
                final name = nameController.text;
                final email = emailController.text;
                final password = passwordController.text;
                final phone = phoneController.text;

                if (!_isPhoneValid(phone)) {
                  _showErrorDialog("Invalid Phone Number");
                  return;
                }

                try {
                  UserCredential userCredential = await FirebaseAuth.instance
                      .createUserWithEmailAndPassword(
                        email: email.trim(),
                        password: password.trim(),
                      );

                  String uid = userCredential.user!.uid;

                  var docRef = await FirebaseFirestore.instance
                      .collection('users')
                      .add({
                        'name': name.trim(),
                        'email': email.trim(),
                        'password': password.trim(),
                        'phone': phone.trim(),
                        'createdAt': FieldValue.serverTimestamp(),
                        'uid': uid,
                        'isAdmin': true,
                      });

                  setState(() {
                    admins.add({
                      "name": name,
                      "email": email,
                      "password": password,
                      "phone": phone,
                      "isAdmin": "true",
                      "docId": docRef.id,
                    });
                  });

                  Navigator.pop(context);

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Admin Added successfully")),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Failed to add Admin: $e")),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  bool _isPhoneValid(String phone) {
    final phoneRegex = RegExp(r"^\+9627[7-9][0-9]{7}$|^07[7-9][0-9]{7}$");
    return phoneRegex.hasMatch(phone);
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Error"),
          content: Text(message),
          actions: [
            TextButton(
              child: const Text("OK"),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }
}
