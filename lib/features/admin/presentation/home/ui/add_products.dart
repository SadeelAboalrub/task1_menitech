import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:first_task/core/res/app_colors.dart';
import 'package:first_task/core/widgets/customButton.dart';
import 'package:first_task/core/widgets/customTextFeild.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProductListPage extends StatefulWidget {
  const ProductListPage({super.key});

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  String? selectedCategory;
  File? pickedImage;

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        pickedImage = File(image.path);
      });
    }
  }

  Future<String> uploadImage(File imageFile) async {
    String fileName = 'product_${DateTime.now().millisecondsSinceEpoch}.jpg';
    final ref = FirebaseStorage.instance.ref().child('products/$fileName');

    await ref.putFile(imageFile);
    return await ref.getDownloadURL();
  }

  Future<void> addProduct() async {
    if (selectedCategory == null ||
        nameController.text.isEmpty ||
        priceController.text.isEmpty ||
        descriptionController.text.isEmpty ||
        pickedImage == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Fill all fields')));
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) =>
          const Center(child: CircularProgressIndicator(color: Colors.blue)),
    );

    try {
      //String imageUrl = await uploadImage(pickedImage!);

      await FirebaseFirestore.instance
          .collection('categories')
          .doc(selectedCategory)
          .collection('products')
          .add({
            'name': nameController.text,
            'price': double.parse(priceController.text),
            'description': descriptionController.text,
            // 'image': imageUrl,
            'createdAt': Timestamp.now(),
          });

      Navigator.pop(context);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Added Successfully')));

      nameController.clear();
      priceController.clear();
      descriptionController.clear();
      setState(() => pickedImage = null);
    } catch (e) {
      Navigator.pop(context);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
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

        backgroundColor: AppColors.mainColor,
        elevation: 0,
        title: const Text(
          'Add Products',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const SizedBox(height: 10),

            Text(
              "Category",
              style: TextStyle(
                color: AppColors.mainColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('categories')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.data!.docs.isEmpty) {
                  return const Text(
                    "Add a Ctegory",
                    style: TextStyle(color: Colors.red),
                  );
                }

                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: DropdownButton<String>(
                    value: selectedCategory,
                    hint: const Text("Choose Category"),
                    isExpanded: true,
                    underline: const SizedBox(),
                    items: snapshot.data!.docs.map((doc) {
                      return DropdownMenuItem<String>(
                        value: doc.id,
                        child: Text(doc['name']),
                      );
                    }).toList(),
                    onChanged: (val) {
                      setState(() => selectedCategory = val);
                    },
                  ),
                );
              },
            ),

            const SizedBox(height: 25),

            CustomTextField(controller: nameController, hint: "Product Name"),

            const SizedBox(height: 15),

            CustomTextField(
              controller: priceController,
              keyboardType: TextInputType.number,
              hint: "Price",
            ),

            const SizedBox(height: 15),

            CustomTextField(
              controller: descriptionController,
              hint: "Description",
            ),

            const SizedBox(height: 20),

            Text(
              "Choose Picture",
              style: TextStyle(
                fontSize: 16,
                color: AppColors.mainColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),

            GestureDetector(
              onTap: pickImage,
              child: Container(
                height: 150,
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.mainColor, width: 1.5),
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.blue.shade50,
                ),
                child: pickedImage == null
                    ? const Center(child: Text("Choose Picture"))
                    : Image.file(pickedImage!, fit: BoxFit.cover),
              ),
            ),

            const SizedBox(height: 30),

            CustomButton(text: "Submit", onPressed: addProduct),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
