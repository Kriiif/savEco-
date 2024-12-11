import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Section
            Container(
              color: Colors.blue,
              padding: EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Icon(Icons.flash_on, color: Colors.yellow, size: 32),
                      Text(
                        "Pemakaian Hari Ini",
                        style: TextStyle(color: Colors.white),
                      ),
                      Text(
                        "999 Watt",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Icon(Icons.attach_money, color: Colors.white, size: 32),
                      Text(
                        "Total Biaya",
                        style: TextStyle(color: Colors.white),
                      ),
                      Text(
                        "Rp230,000.00",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Insight Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InsightCard(),
                  InsightCard(),
                ],
              ),
            ),
            // List Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "List",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Icon(Icons.arrow_forward),
                ],
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CategoryCard(label: "Pemakaian Tetap", count: "10"),
                CategoryCard(label: "Pemakaian Tambahan", count: "10"),
              ],
            ),
            // Recently Added Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Recently Added",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Icon(Icons.arrow_forward),
                ],
              ),
            ),
            RecentlyAddedItem(
              category: "Pemakaian Tetap",
              itemName: "Kulkas 2 Pintu",
              usage: "324.3 watt/tahun",
              cost: "Rp 134.460",
            ),
            RecentlyAddedItem(
              category: "Pemakaian Tambahan",
              itemName: "Lampu",
              usage: "324.3 watt/tahun",
              cost: "Rp 134.460",
            ),
          ],
        ),
      ),
    );
  }
}

class InsightCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.4,
      height: 120,
      decoration: BoxDecoration(
        color: Colors.blue[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(
          "Tarif biaya semakin meningkat",
          style: TextStyle(color: Colors.black, fontSize: 14),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  final String label;
  final String count;

  CategoryCard({required this.label, required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(label, style: TextStyle(fontSize: 16)),
          SizedBox(height: 10),
          Text(count, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class RecentlyAddedItem extends StatelessWidget {
  final String category;
  final String itemName;
  final String usage;
  final String cost;

  RecentlyAddedItem({
    required this.category,
    required this.itemName,
    required this.usage,
    required this.cost,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Icon(
            category == "Pemakaian Tetap" ? Icons.kitchen : Icons.lightbulb,
            size: 40,
          ),
          SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(itemName, style: TextStyle(fontSize: 16)),
              Text(usage, style: TextStyle(color: Colors.grey)),
            ],
          ),
          Spacer(),
          Text(cost, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}