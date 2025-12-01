import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CategoriesView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Categories")),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("categories")
            .orderBy("createdAt", descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(child: CircularProgressIndicator());

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty)
            return Center(child: Text("No categories added yet"));

          final docs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, i) {
              final data = docs[i].data();

              return Card(
                margin: EdgeInsets.all(12),
                child: ListTile(
                  //leading: Image.network(data["image"], width: 60, height: 60, fit: BoxFit.cover),
                  title: Text(data["name"]),
                  subtitle: Text(data["description"] ?? ""),
                  trailing: data["discount"] > 0
                      ? Text("${data['discount']}% OFF",
                          style: TextStyle(color: Colors.red))
                      : null,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
