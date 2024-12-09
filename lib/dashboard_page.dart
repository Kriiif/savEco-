import 'package:flutter/material.dart';
import 'package:intl/intl.dart';  // Import for currency formatting
import 'sum_page.dart';

class DashboardPage extends StatefulWidget {
  final List<Map<String, dynamic>> fixedUsage;
  final List<Map<String, dynamic>> additionalUsage;

  DashboardPage({Key? key, required this.fixedUsage, required this.additionalUsage}) : super(key: key);

  @override
  DashboardPageState createState() => DashboardPageState();
}

class DashboardPageState extends State<DashboardPage> {
  String formatCurrency(double value) {
    final format = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 2);
    return format.format(value);
  }

  void onSave(List<Map<String, dynamic>> fixed, List<Map<String, dynamic>> additional) {
    setState(() {
      widget.fixedUsage.addAll(fixed);
      widget.additionalUsage.addAll(additional);
    });
  }

  @override
  Widget build(BuildContext context) {
    // Calculate the total wattage and total cost, ensuring we handle null or non-integer 'usage' correctly
    int totalWatt = widget.fixedUsage.fold(0, (sum, item) {
      int usage = (item['usage'] is int) ? item['usage'] : 0; // Ensure it's an integer
      return sum + usage;
    });

    double totalCost = widget.fixedUsage.fold(0.0, (sum, item) {
      double cost = (item['cost'] is double) ? item['cost'] : 0.0; // Ensure it's a double
      return sum + cost;
    });

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            // Watt usage and total cost
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Text('Pemakaian Hari Ini'),
                    Text('$totalWatt Watt', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ],
                ),
                Column(
                  children: [
                    Text('Total Biaya'),
                    Text(formatCurrency(totalCost), style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
            // List of fixed and additional usage
            SizedBox(height: 20),
            //yang baru
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
                CategoryCard(label: "Pemakaian Tetap", count: "${widget.fixedUsage.length}"),
                CategoryCard(label: "Pemakaian Tambahan", count: "${widget.additionalUsage.length}"),
              ],
            ),
            SizedBox(height: 10,),
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
          ],
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