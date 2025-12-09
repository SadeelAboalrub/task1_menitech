import 'package:flutter/material.dart';

class TopProductsPage extends StatelessWidget{
  const TopProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF4EDE3),

      appBar: AppBar(
        backgroundColor: Color(0xFFF4EDE3),
        elevation: 0,
        leading: IconButton(
          onPressed: () {}, 
          icon: Icon(Icons.arrow_back , color: Colors.black),
        ),
        title: Text(
          "Top Products",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: (){}, 
            icon: Icon(Icons.search, color: Colors.black),
          ),
          IconButton(
            onPressed: (){}, 
            icon: Icon(Icons.search, color: Colors.black),
          ),
          IconButton(
            onPressed: (){}, 
            icon: Icon(Icons.search, color: Colors.black),
          ),
        ],
      ),

      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Align(
              alignment: AlignmentGeometry.centerLeft,
              child: Text(
                "194673 Products",
                style: TextStyle(color: Colors.black, fontSize: 14),
              ),
            ),
          ),
          SizedBox(height: 10),

          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.all(12), 
              itemCount: 10,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.62,
              ),
              itemBuilder: (context, index){
                return productCard();
              },
            )
          )
        ],
      ),

      bottomNavigationBar: Container(
        color: Colors.black,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  context: context, 
                  isScrollControlled: true,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  builder: (context) => FractionallySizedBox(
                    heightFactor: 0.45,
                    child: Column(
                      children: [
                        SizedBox(height: 15),
                        Text("Sort By", style: TextStyle(fontSize: 18)),
                        Divider(),
                        ListTile(title: Text("Price : Low to High")),
                        ListTile(title: Text("Price : Low to High")),
                        ListTile(title: Text("Price : Low to High")),
                        ListTile(title: Text("Price : Low to High")),
                      ],
                    ),
                  )
                );
              },
              child: Row(
                children: [
                  Icon(Icons.sort, color: Colors.white70),
                  SizedBox(width: 6),
                  Text("SORT BY", style: TextStyle(color: Colors.white60)),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, "/filters");
              },
              child: Row(
                children: [
                  Stack(
                    children: [
                      Icon(Icons.filter_list, color: Colors.white60),
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          width: 7,
                          height: 7,
                          decoration: BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 6),
                  Text("FILTERS", style: TextStyle(color: Colors.white60)),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
  Widget productCard(){
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade200),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 130,
            width: double.infinity,
            color: Colors.grey.shade200,
            child: Icon(Icons.image, size: 50, color: Colors.grey),
          ),

          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("14KT Yellow Gold", maxLines: 1),
                Text("#12345"),
                SizedBox(height: 4),
                Text("Women | Earrings",
                style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
                SizedBox(height: 8),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(Icons.favorite_border, size: 20, color: Colors.red),
                    Text("5K", style: TextStyle(color: Colors.red)),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}