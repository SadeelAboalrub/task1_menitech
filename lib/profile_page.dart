import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'home_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  File? _pickedImage;
  String userName = "User Name";
  String email = "email@example.com";
  String phone = "+123456789";

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      email = user.email ?? email;

      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (doc.exists) {
        setState(() {
          userName = doc.data()?['username'] ??
              (email.contains('@') ? email.split('@')[0] : "User Name");
          phone = doc.data()?['phone'] ?? phone;
        });
      } else {
        // إذا لم يكن هناك doc في Firestore
        setState(() {
          userName = email.contains('@') ? email.split('@')[0] : "User Name";
        });
      }
    }
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _pickedImage = File(image.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff6eedd),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => HomePage()),
                      );
                    },
                  ),
                  Text(
                    "Profile",
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xff0a2c63),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: pickImage,
                      child: Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          color: Colors.white24,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: _pickedImage == null
                            ? const Icon(
                                Icons.person,
                                size: 40,
                                color: Colors.white,
                              )
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.file(
                                  _pickedImage!,
                                  fit: BoxFit.cover,
                                ),
                              ),
                      ),
                    ),

                    const SizedBox(width: 16),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            userName,
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            email,
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              color: Colors.white70,
                            ),
                          ),
                          Text(
                            phone,
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),

                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.white),
                      onPressed: () {
                        // هنا ممكن تحط صفحة EditProfilePage بدل HomePage
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => HomePage(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: _topButton(Icons.shopping_bag_outlined, "Orders"),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _topButton(
                      Icons.account_balance_wallet_outlined,
                      "Wallet",
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _topButton(Icons.help_outline, "Help Center"),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              _menuTile(
                Icons.shopping_bag_outlined,
                "Orders",
                "Check your order status",
              ),
              _divider(),

              _menuTile(
                Icons.headphones_outlined,
                "Help Center",
                "Help regarding your recent purchase",
              ),
              _divider(),

              _menuTile(
                Icons.favorite_border,
                "Wishlist",
                "Your most loved styles",
              ),
              _divider(),

              _menuTile(Icons.settings, "Settings", "Manage Notifications"),

              const SizedBox(height: 20),
              _divider(),

              _footerItem("FAQS"),
              _footerItem("ABOUT US"),
              _footerItem("TERMS OF USE"),
              _footerItem("PRIVACY POLICY"),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _topButton(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black12),
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 18),
          const SizedBox(width: 5),
          Text(text, style: GoogleFonts.poppins(fontSize: 13)),
        ],
      ),
    );
  }

  Widget _menuTile(IconData icon, String title, String subtitle) {
    return ListTile(
      leading: Icon(icon, size: 28, color: Colors.black87),
      title: Text(
        title,
        style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        subtitle,
        style: GoogleFonts.poppins(fontSize: 12, color: Colors.black54),
      ),
      contentPadding: EdgeInsets.zero,
      trailing: const Icon(Icons.chevron_right),
    );
  }

  Widget _divider() {
    return Container(
      height: 1,
      color: const Color(0xffeedfc7),
      margin: const EdgeInsets.symmetric(vertical: 12),
    );
  }

  Widget _footerItem(String text) {
    return ListTile(
      title: Text(
        text,
        style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500),
      ),
      trailing: const Icon(Icons.chevron_right),
      contentPadding: EdgeInsets.zero,
    );
  }
}
