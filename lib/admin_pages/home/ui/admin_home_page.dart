//import 'package:first_task/adminPages/ProductListPage.dart';
import 'package:first_task/adminPages/ProductListPage.dart';
import 'package:first_task/adminPages/addToCat.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


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
                  borderRadius: BorderRadius.circular(10)),
              child: ListTile(
                leading: const Icon(
                  Icons.category,
                  color: Colors.blue,
                  size: 30,
                ),
                title: const Text(
                  "Manage Categories",
                  style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                subtitle:
                    const Text("Add categories"),
                trailing: ElevatedButton.icon(
                  icon: const Icon(Icons.add),
                  label: const Text("Add Category"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AddCategoryPage()),
                    );
                  },
                ),
              ),
            ),
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: ListTile(
                leading: const Icon(
                  Icons.category,
                  color: Colors.blue,
                  size: 30,
                ),
                title: const Text(
                  "Add Products",
                  style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                trailing: ElevatedButton.icon(
                  icon: const Icon(Icons.add),
                  label: const Text("Add Product"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProductListPage()),
                    );
                  },
                ),
              ),
            ),

            const SizedBox(height: 25),

            const Text(
              "Admins List",
              style: TextStyle(
                  fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 15),

            ...admins.map(
              (admin) => Card(
                child: ListTile(
                  title: Text(admin['name']!),
                  subtitle: Text(
                      "${admin['email']} • Password: ${admin['password']}"),
                  leading: const Icon(Icons.person, color: Colors.blue),
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
                              content:
                                  Text("Admin deleted successfully")),
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content:
                                  Text("Failed to delete admin: $e")),
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
              TextField(
                controller: nameController,
                decoration:
                    const InputDecoration(labelText: "Admin Name"),
              ),
              TextField(
                controller: emailController,
                decoration:
                    const InputDecoration(labelText: "Admin Email"),
              ),
              TextField(
                controller: passwordController,
                decoration:
                    const InputDecoration(labelText: "Admin Password"),
                obscureText: true,
              ),
              TextField(
                controller: phoneController,
                decoration: const InputDecoration(
                    labelText: "Admin Phone No."),
              )
            ],
          ),
          actions: [
            TextButton(
              child: const Text("Cancel"),
              onPressed: () => Navigator.pop(context),
            ),
            ElevatedButton(
              child: const Text("Add"),
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
                  UserCredential userCredential =
                      await FirebaseAuth.instance
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
                    const SnackBar(
                        content: Text("Admin Added successfully")),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text("Failed to add Admin: $e")),
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
    final phoneRegex =
        RegExp(r"^\+9627[7-9][0-9]{7}$|^07[7-9][0-9]{7}$");
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
