import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:first_task/core/widgets/customButton.dart';
import 'package:first_task/core/widgets/customTextFeild.dart';
import 'package:first_task/features/admin/presentation/home/ui/add_products.dart';
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

      await FirebaseFirestore.instance.collection("categories").add({
        "name": nameCtrl.text.trim(),
        "description": descCtrl.text.trim(),
        "discount": discountCtrl.text.isEmpty
            ? 0
            : int.tryParse(discountCtrl.text) ?? 0,
        "createdAt": FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Category Added Successfully")));

      nameCtrl.clear();
      descCtrl.clear();
      discountCtrl.clear();
      setState(() => selectedImage = null);

      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => ProductListPage()),
      );
    } catch (e) {
      print("ERROR: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    }

    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.black,
        elevation: 0,
        title: Text(
          "Add Category",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _label("Category Name"),
            CustomTextField(
              hint: "Type category name...",
              controller: nameCtrl,
            ),

            SizedBox(height: 20),
            _label("Description"),
            CustomTextField(hint: "Write something...", controller: descCtrl),

            SizedBox(height: 20),
            _label("Discount"),
            CustomTextField(
              keyboardType: TextInputType.numberWithOptions(),
              hint: "0",
              controller: discountCtrl,
            ),

            SizedBox(height: 30),
            Text(
              "Category Image",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 10),
            GestureDetector(
              onTap: pickImage,
              child: Container(
                height: 170,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 1.4),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: selectedImage == null
                    ? Center(
                        child: Text(
                          "Upload Image",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(selectedImage!, fit: BoxFit.cover),
                      ),
              ),
            ),

            SizedBox(height: 40),

            CustomButton(text: "Save Category", onPressed: uploadCategory),
          ],
        ),
      ),
    );
  }

  Widget _label(String text) {
    return Text(
      text,
      style: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.w600,
        fontSize: 15,
      ),
    );
  }
}
