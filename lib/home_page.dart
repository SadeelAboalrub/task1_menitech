import 'package:first_task/brands_page.dart';
import 'package:first_task/cart_page.dart';
import 'package:first_task/categories_page.dart';
import 'package:first_task/profile_page.dart';
import 'package:flutter/material.dart';

class CategoryModel {
  final String name;
  final String image; 

  CategoryModel({required this.name, required this.image});
}

class ProductModel {
  final String title;
  final String image; 
  final double price;
  final double oldPrice;

  ProductModel({
    required this.title,
    required this.image,
    required this.price,
    required this.oldPrice,
  });
}

class HomePage extends StatelessWidget {
  HomePage({super.key});


  final List<CategoryModel> categories = [
    CategoryModel(name: "Rings", image: ""), 
    CategoryModel(name: "Necklace", image: ""),
    CategoryModel(name: "Earrings", image: ""),
    CategoryModel(name: "Bracelets", image: ""),
    CategoryModel(name: "Gold", image: ""),
    CategoryModel(name: "Diamond", image: ""),
    CategoryModel(name: "Rings", image: ""), 
    CategoryModel(name: "Necklace", image: ""),
    CategoryModel(name: "Earrings", image: ""),
    CategoryModel(name: "Bracelets", image: ""),
    CategoryModel(name: "Gold", image: ""),
    CategoryModel(name: "Diamond", image: ""),
    CategoryModel(name: "Bracelets", image: ""),
    CategoryModel(name: "Gold", image: ""),
    CategoryModel(name: "Diamond", image: ""),
  ];


  final List<ProductModel> products = [
    ProductModel(
      title: "",
      image: "", 
      price: 0,
      oldPrice: 00,
    ),
    ProductModel(
      title: "",
      image: "", 
      price: 0,
      oldPrice: 00,
    ),
    ProductModel(
      title: "",
      image: "", 
      price: 0,
      oldPrice: 00,
    ),
    ProductModel(
      title: "",
      image: "", 
      price: 0,
      oldPrice: 00,
    ),
    ProductModel(
      title: "",
      image: "", 
      price: 0,
      oldPrice: 00,
    ),
    ProductModel(
      title: "",
      image: "", 
      price: 0,
      oldPrice: 00,
    ),
    ProductModel(
      title: "",
      image: "", 
      price: 0,
      oldPrice: 00,
    ),
    ProductModel(
      title: "",
      image: "", 
      price: 0,
      oldPrice: 00,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      bottomNavigationBar: BottomNavigationBar(
  type: BottomNavigationBarType.fixed,
  selectedItemColor: Colors.blue,
  unselectedItemColor: Colors.grey,
  onTap: (index) {
    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => HomePage()),
        );
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => CategoriesPage()),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => BrandsPage()),
        );
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => CartPage()),
        );
        break;
      case 4:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => ProfilePage()),
        );
        break;
    }
  },
  items: const [
    BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: "Home"),
    BottomNavigationBarItem(icon: Icon(Icons.category_outlined), label: "Categories"),
    BottomNavigationBarItem(icon: Icon(Icons.local_offer_outlined), label: "Brands"),
    BottomNavigationBarItem(icon: Icon(Icons.shopping_bag_outlined), label: "Cart"),
    BottomNavigationBarItem(icon: Icon(Icons.person_outlined), label: "Profile"),
  ],
),


      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Row(
                  children: [
                    const Icon(Icons.menu, size: 28),
                    const Spacer(),
                    const Text(
                      "Gemora Jewellery",
                      style: TextStyle(
                        fontSize: 22,
                        color: Color(0xFF0D1B2A),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    const Icon(Icons.notifications_outlined, size: 28),
                    const SizedBox(width: 12),
                    const Icon(Icons.favorite_border, size: 28),
                  ],
                ),
              ),
              
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                height: 45,
                color: Colors.blue.shade800,
                child: const TextField(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Search by Product, Brand & More..",
                    hintStyle: TextStyle(color: Colors.white70),
                    suffixIcon: Icon(Icons.search, color: Colors.white),
                  ),
                  style: TextStyle(color: Colors.white),
                ),
              ),

              Container(
                height: 180,
                margin: const EdgeInsets.only(top: 10),
                decoration: BoxDecoration(
                  color: Colors.blueGrey.shade300, 
                ),
                child: const Center(
                  child: Text(
                    "UP TO 20% OFF\nDIAMOND PRICES",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 26,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              SizedBox(
                height: 110,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  itemBuilder: (context, i) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 32,
                            backgroundColor: Colors.grey.shade300,
                          ),
                          const SizedBox(height: 5),
                          Text(categories[i].name),
                        ],
                      ),
                    );
                  },
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(12),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 6,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                  ),
                  itemBuilder: (context, i) {
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    );
                  },
                ),
              ),

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Recently Viewed",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: products.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: .65,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemBuilder: (context, i) {
                    return Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 3,
                          )
                        ],
                      ),
                      child: Column(
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            products[i].title,
                            maxLines: 2,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text("\$${products[i].price}",
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                          Text(
                            "\$${products[i].oldPrice}",
                            style: const TextStyle(
                              decoration: TextDecoration.lineThrough,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
