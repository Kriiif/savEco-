import 'package:flutter/material.dart';
import 'package:intl/intl.dart';  // Import for currency formatting
import 'sum_page.dart';

class DashboardPage extends StatefulWidget {
  final List<Map<String, dynamic>> fixedUsage;
  final List<Map<String, dynamic>> additionalUsage;
  final String username;

  DashboardPage({Key? key, required this.fixedUsage, required this.additionalUsage, required this.username}) : super(key: key);

  @override
  DashboardPageState createState() => DashboardPageState();
}

class DashboardPageState extends State<DashboardPage> {
  Future<Map<String, dynamic>> getPemakaianHariIni() async {
  // Get today's date
  final today = DateFormat('dd-MM-yyyy').format(DateTime.now());

  // Filter usage for today
  final todayUsage = [
    ...widget.fixedUsage.where((item) => item['date'] == today),
    ...widget.additionalUsage.where((item) => item['date'] == today),
  ];

  // Calculate total watt and cost for today
  final totalWatt = todayUsage.fold<int>(0, (sum, item) {
    final usage = item['usage'] is int ? item['usage'] as int : 0;
    return sum + usage;
  });

  final totalCost = todayUsage.fold<double>(0.0, (sum, item) {
    final cost = item['cost'] is num ? item['cost'].toDouble() : 0.0;
    return sum + cost;
  });

  return {'totalWatt': totalWatt, 'totalCost': totalCost};
}

  String formatCurrency(double value) {
    final format = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0);
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
    List<Map<String, dynamic>> allUsage = [
      ...widget.fixedUsage,
      ...widget.additionalUsage,
    ];

    allUsage.sort((a, b) => (b['timestamp'] as DateTime).compareTo(a['timestamp'] as DateTime));

    List<Map<String, dynamic>> recentlyAdded = allUsage.take(2).toList();

    // Calculate the total wattage and total cost, ensuring we handle null or non-integer 'usage' correctly
    int totalWatt = widget.fixedUsage.fold(0, (sum, item) {
      final usage = item['usage'] is int ? item['usage'] as int : 0;
      return sum + usage;
    }) + widget.additionalUsage.fold(0, (sum, item) {
      final usage = item['usage'] is int ? item['usage'] as int : 0;
      return sum + usage;
    });

    double totalCost = widget.fixedUsage.fold(0.0, (sum, item) {
      final cost = item['cost'] is double ? item['cost'] as double : 0.0;
      return sum + cost;
    }) + widget.additionalUsage.fold(0.0, (sum, item) {
      final cost = item['cost'] is double ? item['cost'] as double : 0.0;
      return sum + cost;
    });

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Padding(
        padding: const EdgeInsets.all(0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Watt usage and total cost
            Container(
              decoration: BoxDecoration(
                color: Color(0xFF4A90E2), // Background biru
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Selamat Pagi Text
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                    child: Text(
                      'Selamat Pagi, ${widget.username}! Jangan lupa berhemat',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  // Card with usage and total cost
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                    padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Pemakaian Hari Ini
                        Row(
                          children: [
                            Icon(Icons.bolt, color: Colors.yellow, size: 28),
                            SizedBox(width: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Pemakaian Hari Ini',
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.black54,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 4),
                                FutureBuilder(
                                  future: getPemakaianHariIni(),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState == ConnectionState.waiting) {
                                      return Text(
                                        'Loading...',
                                        style: TextStyle(
                                            fontSize: 16, fontWeight: FontWeight.bold),
                                      );
                                    } else if (snapshot.hasError) {
                                      return Text(
                                        'Error',
                                        style: TextStyle(
                                            fontSize: 16, fontWeight: FontWeight.bold),
                                      );
                                    } else {
                                      final data = snapshot.data as Map<String, dynamic>;
                                      return Text(
                                        '${data['totalWatt']} Watt',
                                        style: TextStyle(
                                            fontSize: 16, fontWeight: FontWeight.bold),
                                      );
                                    }
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                        // Total Biaya
                        Row(
                          children: [
                            Icon(Icons.account_balance_wallet,
                                color: Colors.lightBlue, size: 28),
                            SizedBox(width: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Total Biaya',
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.black54,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 4),
                                FutureBuilder(
                                  future: getPemakaianHariIni(),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState == ConnectionState.waiting) {
                                      return Text(
                                        'Loading...',
                                        style: TextStyle(
                                            fontSize: 16, fontWeight: FontWeight.bold),
                                      );
                                    } else if (snapshot.hasError) {
                                      return Text(
                                        'Error',
                                        style: TextStyle(
                                            fontSize: 16, fontWeight: FontWeight.bold),
                                      );
                                    } else {
                                      final data = snapshot.data as Map<String, dynamic>;
                                      return Text(
                                        formatCurrency(data['totalCost']),
                                        style: TextStyle(
                                            fontSize: 16, fontWeight: FontWeight.bold),
                                      );
                                    }
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                        // Row(
                        //   children: [
                        //     Icon(Icons.bolt, color: Colors.yellow, size: 28),
                        //     SizedBox(width: 8),
                        //     Column(
                        //       crossAxisAlignment: CrossAxisAlignment.start,
                        //       children: [
                        //         Text(
                        //           'Pemakaian Hari Ini',
                        //           style: TextStyle(
                        //               fontSize: 12,
                        //               color: Colors.black54,
                        //               fontWeight: FontWeight.bold),
                        //         ),
                        //         SizedBox(height: 4),
                        //         Text(
                        //           '$totalWatt Watt',
                        //           style: TextStyle(
                        //               fontSize: 16, fontWeight: FontWeight.bold),
                        //         ),
                        //       ],
                        //     ),
                        //   ],
                        // ),
                        // // Total Biaya
                        // Row(
                        //   children: [
                        //     Icon(Icons.account_balance_wallet,
                        //         color: Colors.lightBlue, size: 28),
                        //     SizedBox(width: 8),
                        //     Column(
                        //       crossAxisAlignment: CrossAxisAlignment.start,
                        //       children: [
                        //         Text(
                        //           'Total Biaya',
                        //           style: TextStyle(
                        //               fontSize: 12,
                        //               color: Colors.black54,
                        //               fontWeight: FontWeight.bold),
                        //         ),
                        //         SizedBox(height: 4),
                        //         Text(
                        //           formatCurrency(totalCost),
                        //           style: TextStyle(
                        //               fontSize: 16, fontWeight: FontWeight.bold),
                        //         ),
                        //       ],
                        //     ),
                        //   ],
                        // ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Insight",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Icon(Icons.arrow_forward),
                ],
              ),
            ),
            // List of fixed and additional usage
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InsightCard(photo: "assets/images/tiang.jpg", text: "Pemakaian listik boros"),
                InsightCard(photo: "assets/images/tiang2.jpg", text: "KwH naik akhir tahun",),
              ],
            ),
            SizedBox(height: 10),
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
            SizedBox(height: 0,),
            // Recently Added Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Recently Added",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            ...recentlyAdded.map((item) => RecentlyAddedCard(item: item)).toList(),
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

class InsightCard extends StatelessWidget {
  final String photo;
  final String text;

  InsightCard({required this.photo, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          marketcard('${photo}', '${text}'),
        ],
      ),
    );
  }

  Container marketcard(String photopath, String text) {
    Container contents = Container(
      height: 110,
      width: 178.5,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Stack( // Menggunakan Stack untuk menumpuk widget
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
            child: Image.asset(
              photopath,
              height: 110,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Positioned( // Menempatkan teks di posisi tertentu di atas gambar
            bottom: 8, // Menentukan jarak dari bawah
            left: 8,   // Menentukan jarak dari kiri
            child: Text(
              text, // Teks yang ingin ditampilkan
              style: const TextStyle(
                color: Colors.white, // Warna teks
                fontSize: 14,
                fontWeight: FontWeight.bold,
                shadows: [
                  Shadow(
                    color: Colors.black54,
                    blurRadius: 4,
                    offset: Offset(1, 1),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
    return contents;
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

class RecentlyAddedCard extends StatelessWidget {
  final Map<String, dynamic> item;

  const RecentlyAddedCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16.0),
      child: ListTile(
        leading: Icon(
          item['category'] == 'Tetap' ? Icons.lock : Icons.add_circle,
          size: 40,
          color: Colors.blue,
        ),
        title: Text(item['name'] ?? ''),
        subtitle: Text('${item['usage']} watt/hari'),
        trailing: Text(
          NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0).format(item['cost'] ?? 0),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}