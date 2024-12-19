import 'package:flutter/material.dart';

class Insight extends StatelessWidget {
  final String title;
  final String description;

  const Insight({
    super.key,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5.0,
      margin: const EdgeInsets.all(10.0),
      child: ListTile(
        leading: const Icon(Icons.insights),
        title: Text(title),
        subtitle: Text(description),
      ),
    );
  }
}

final List<Map<String, String>> insights = [
  {
    'title': '5 Tips Jitu agar Kulkas di Rumah Hemat Listrik',
    'description': 'Kulkas bekerja tanpa henti untuk menjaga makanan tetap segar dan aman dikonsumsi. Begini caranya agar kulkas di rumah hemat listrik',
  },
  {
    'title': '7 Tips Ampuh Pangkas Tagihan Listrik di Rumah',
    'description': 'Berikut adalah 7 tips untuk memangkas tagihan listrik bulanan di rumahmu',
  },
];

class InsightSection extends StatelessWidget {
  const InsightSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: Colors.blue,
          width: double.infinity,
          height: 100.0,
          padding: const EdgeInsets.all(30.0),
          child: TextField(
            decoration: InputDecoration(
              labelText: 'Search',
              hintText: 'Type to search',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
            onChanged: (value) {
              print('Search input: $value');
            },
          ),
        ),
        const SizedBox(height: 20.0),
        Container(
          margin: const EdgeInsets.only(left: 10.0),
          child: const Text(
            'Rekomendasi berdasarkan pemakaian',
            style: TextStyle(fontSize: 15.0),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: insights.length,
            itemBuilder: (context, index) {
              return Insight(
                title: insights[index]['title']!,
                description: insights[index]['description']!,
              );
            },
          ),
        ),
      ],
    );
  }
}
