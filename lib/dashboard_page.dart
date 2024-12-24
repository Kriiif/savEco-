import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:saveco_project/controller/database_helper.dart';

class DashboardPage extends StatefulWidget {
  final List<Map<String, dynamic>> fixedUsage;
  final List<Map<String, dynamic>> additionalUsage;
  final String username;
  final int userId;

  DashboardPage({
    Key? key,
    required this.fixedUsage,
    required this.additionalUsage,
    required this.username,
    required this.userId
  }) : super(key: key);

  @override
  DashboardPageState createState() => DashboardPageState();
}

class DashboardPageState extends State<DashboardPage> {
  final DatabaseHelper dbHelper = DatabaseHelper();

  Future<Map<String, dynamic>> getPemakaianHariIni() async {
    final today = DateFormat('dd-MM-yyyy').format(DateTime.now());

    // Get today's usage from database
    final fixedUsage = await dbHelper.getFixedUsage(widget.userId, today);
    final additionalUsage = await dbHelper.getAdditionalUsage(widget.userId, today);

    final allUsage = [...fixedUsage, ...additionalUsage];

    final totalWatt = allUsage.fold<int>(0, (sum, item) {
      final usage = item['usage'] is int ? item['usage'] as int : 0;
      return sum + usage;
    });

    final totalCost = allUsage.fold<double>(0.0, (sum, item) {
      final cost = item['cost'] is num ? item['cost'].toDouble() : 0.0;
      return sum + cost;
    });

    return {
      'totalWatt': totalWatt,
      'totalCost': totalCost,
      'recentlyAdded': allUsage.take(2).toList()
    };
  }

  String formatCurrency(double value) {
    final format = NumberFormat.currency(
        locale: 'id_ID',
        symbol: 'Rp',
        decimalDigits: 0
    );
    return format.format(value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {});
        },
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Color(0xFF4A90E2),
                  borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                      child: Text(
                        'Selamat Pagi, ${widget.username}!, Jangan lupa berhemat',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
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
                          )
                        ]
                      ),
                      child: FutureBuilder<Map<String, dynamic>>(
                        future: getPemakaianHariIni(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          }

                          if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          }

                          final data = snapshot.data!;
                          return Card(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [

                                          Row(
                                            children: [
                                              Icon(Icons.bolt_outlined, color: Colors.yellow, size: 40),
                                              Column(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Pemakaian Hari Ini',
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.bold
                                                    ),
                                                  ),
                                                  SizedBox(height: 4),

                                                  Text(
                                                    '${data['totalWatt']} Watt',
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),

                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Icon(Icons.account_balance_wallet, color: Colors.lightBlue, size:28),
                                          Text(
                                            'Total Biaya',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(height: 4),
                                          Text(
                                            formatCurrency(data['totalCost']),
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'List',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildUsageCard(
                            'Tetap',
                            widget.fixedUsage.length,
                            Icons.lock,
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: _buildUsageCard(
                            'Tambahan',
                            widget.additionalUsage.length,
                            Icons.add_circle,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 24),
                    Text(
                      'Recently Added',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),
                    FutureBuilder<Map<String, dynamic>>(
                      future: getPemakaianHariIni(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Center(child: CircularProgressIndicator());
                        }

                        final recentItems = snapshot.data!['recentlyAdded'] as List;

                        return Column(
                          children: recentItems.map((item) => Card(
                            margin: EdgeInsets.only(bottom: 8),
                            child: ListTile(
                              leading: Icon(
                                item['category'] == 'Tetap'
                                    ? Icons.lock
                                    : Icons.add,
                                color: Color(0xFF4A90E2),
                              ),
                              title: Text(item['name']),
                              subtitle: Text('${item['usage']} Watt'),
                              trailing: Text(
                                formatCurrency(item['cost']),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                            ),
                          )).toList(),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUsageCard(String title, int count, IconData icon) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(icon, size: 32, color: Color(0xFF4A90E2)),
            SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4),
            Text(
              count.toString(),
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF4A90E2),
              ),
            ),
          ],
        ),
      ),
    );
  }
}