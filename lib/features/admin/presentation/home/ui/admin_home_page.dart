import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:first_task/core/widgets/customButton.dart';
import 'package:first_task/features/admin/presentation/home/ui/add_categories.dart';
import 'package:first_task/features/admin/presentation/home/ui/add_products.dart';
import 'package:first_task/features/admin/presentation/home/ui/manage_admins_page.dart';

class StatisticsCard extends StatelessWidget {
  final String title;
  final int count;
  final Color color;

  const StatisticsCard({
    super.key,
    required this.title,
    required this.count,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.symmetric(horizontal: 6),
        decoration: BoxDecoration(
          color: color.withOpacity(.15),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              count.toString(),
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                color: color,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class AdminHomePage extends StatelessWidget {
  const AdminHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Dashboard"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              
            },
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [

            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("users")
                  .where("isAdmin", isEqualTo: true)
                  .snapshots(),
              builder: (context, adminSnap) {
                return StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("categories")
                      .snapshots(),
                  builder: (context, catSnap) {
                    return StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collectionGroup("products")
                          .snapshots(),
                      builder: (context, productSnap) {
                        if (!adminSnap.hasData ||
                            !catSnap.hasData ||
                            !productSnap.hasData) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 20),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }

                        int adminCount = adminSnap.data!.docs.length;
                        int categoryCount = catSnap.data!.docs.length;
                        int productCount = productSnap.data!.docs.length;

                        return Row(
                          children: [
                            StatisticsCard(
                              title: "Admins",
                              count: adminCount,
                              color: const Color.fromARGB(255, 24, 21, 15),
                            ),
                            StatisticsCard(
                              title: "Categories",
                              count: categoryCount,
                              color: const Color.fromARGB(255, 24, 21, 15),
                            ),
                            StatisticsCard(
                              title: "Products",
                              count: productCount,
                              color: const Color.fromARGB(255, 24, 21, 15),
                            ),
                          ],
                        );
                      },
                    );
                  },
                );
              },
            ),

            const SizedBox(height: 20),

            _buildDashboardCard(
              icon: Icons.category,
              title: "Manage Categories",
              subtitle: "Add, edit & remove categories",
              buttonText: "Open",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => AddCategoryPage()),
                );
              },
            ),

            _buildDashboardCard(
              icon: Icons.shopping_bag,
              title: "Manage Products",
              subtitle: "Add & organize products",
              buttonText: "Open",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => ProductListPage()),
                );
              },
            ),

            _buildDashboardCard(
              icon: Icons.admin_panel_settings,
              title: "Manage Admins",
              subtitle: "View or add administrators",
              buttonText: "Open",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ManageAdminsPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required String buttonText,
    required void Function() onPressed,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, size: 35),
        title: Text(title,
            style: const TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: CustomButton(text: buttonText, onPressed: onPressed),
      ),
    );
  }
}
