import 'package:flutter/material.dart';

class FilterPage extends StatefulWidget {
  @override
  _FilterPageState createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  final List<String> tabs = [
    "Gender",
    "Category",
    "Price",
    "Brands",
    "Occasion",
    "Discount",
    "Color",
    "Size & Fit",
  ];

  int selectedTab = 4;

  Map<String, bool> brandChecks = {
    "Tanishq": false,
    "Reliance Jewels": true,
    "Caratlane": false,
    "BlueStone": false,
    "Kalyan Jewellers": false,
    "18 Edition (13)": false,
    "2Go(7)": false,
    "69TH Avenue (12)": false,
    "7 For All Mankind (5)": false,
    "9 Impression (3)": false,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Row(
          children: [
            Container(
              width: 110,
              color: Colors.white,
              child: ListView.builder(
                itemCount: tabs.length,
                itemBuilder: (context, index) {
                  bool isSelected = index == selectedTab;
                  return GestureDetector(
                    onTap: () => setState(() => selectedTab = index),
                    child: Row(
                      children: [
                        SizedBox(width: 16),
                        Text(
                          tabs[index],
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.w300,
                            color: isSelected ? Colors.black : Colors.grey,
                          ),
                        ),
                        if (tabs[index] == "Price")
                          Padding(
                            padding: EdgeInsets.only(left: 5),
                            child: Text(
                              ".",
                              style: TextStyle(color: Colors.red, fontSize: 24),
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),

            Expanded(
              child: Container(
                color: Colors.white,
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.arrow_back, size: 24),
                        SizedBox(width: 12),
                        Text(
                          "Filters (78838 Products)",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),

                    TextField(
                      decoration: InputDecoration(
                        hintText: "Search For Brand",
                        prefixIcon: Icon(Icons.search),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),

                    Text(
                      "Popular Brands",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 8),

                    Expanded(
                      child: ListView(
                        children: brandChecks.keys.map((brand) {
                          return CheckboxListTile(
                            value: brandChecks[brand],
                            onChanged: (value) {
                              setState(() => brandChecks[brand] = value!);
                            },
                            title: Text(brand, style: TextStyle(fontSize: 15)),
                            controlAffinity: ListTileControlAffinity.leading,
                            activeColor: Colors.black,
                          );
                        }).toList(),
                      ),
                    ),

                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 50,
                            margin: EdgeInsets.only(top:10),
                            child: OutlinedButton(
                              onPressed: (){
                                setState(() {
                                  brandChecks.updateAll((key, value) => false);
                                });
                              },
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(color : Colors.black),
                              ),
                              child: Text(
                                "Reset",
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          )
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Container(
                            height: 50,
                            margin: EdgeInsets.only(top : 10),
                            child: ElevatedButton(
                              onPressed: (){},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                              ),
                              child: Text(
                                "APPLY FILTER",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          )
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
