import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:firebase_storage/firebase_storage.dart';
import 'package:first_task/adminPages/ProductListPage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';


class AddCategoryPage extends StatefulWidget {
  @override
  _AddCategoryPageState createState() => _AddCategoryPageState();
}

class _AddCategoryPageState extends State<AddCategoryPage> {
  TextEditingController nameCtrl = TextEditingController();
  TextEditingController descCtrl = TextEditingController();
  TextEditingController discountCtrl = TextEditingController();

  File? selectedImage;
  bool loading = false;

  Future pickImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() => selectedImage = File(image.path));
    }
  }

  Future uploadCategory() async {
    if (nameCtrl.text.isEmpty || selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please fill all required fields")),
      );
      return;
    }

    setState(() => loading = true);

    try {
      final fileName = "${DateTime.now().microsecondsSinceEpoch}.jpg";
      // final Reference ref =
      //     FirebaseStorage.instance.ref().child("categories/$fileName");

      // await ref.putFile(selectedImage!);
      // final imageUrl = await ref.getDownloadURL();

      
      final docRef =
          await FirebaseFirestore.instance.collection("categories").add({
        "name": nameCtrl.text.trim(),
        "description": descCtrl.text.trim(),
        "discount": discountCtrl.text.isEmpty
            ? 0
            : int.tryParse(discountCtrl.text) ?? 0,
        // "image": imageUrl,
        "createdAt": FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Category Added Successfully")));

      nameCtrl.clear();
      descCtrl.clear();
      discountCtrl.clear();
      setState(() => selectedImage = null);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ProductListPage(),
        ),
      );
    } catch (e) {
      print("ERROR: $e");
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error: $e")));
    }

    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text("Add Category"),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            buildField("Category Name", nameCtrl),
            buildField("Description", descCtrl),
            buildField("Discount (%)", discountCtrl, number: true),

            SizedBox(height: 15),
            GestureDetector(
              onTap: pickImage,
              child: Container(
                height: 170,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: selectedImage == null
                    ? Center(
                        child: Text(
                          "Upload Image",
                          style: TextStyle(color: Colors.blue),
                        ),
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(selectedImage!, fit: BoxFit.cover),
                      ),
              ),
            ),

            SizedBox(height: 30),
            ElevatedButton(
              onPressed: loading ? null : uploadCategory,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 80),
              ),
              child: loading
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text("Save Category", style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildField(String label, TextEditingController ctrl,
      {bool number = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: ctrl,
        keyboardType: number ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}
