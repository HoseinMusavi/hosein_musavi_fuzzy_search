import 'package:flutter/material.dart';
import 'data.dart';
import 'fuzzy_search.dart';

void main() => runApp(FuzzySearchApp());

class FuzzySearchApp extends StatefulWidget {
  @override
  _FuzzySearchAppState createState() => _FuzzySearchAppState();
}

class _FuzzySearchAppState extends State<FuzzySearchApp> {
  String query = '';
  List<String> results = [];

  void search(String query) {
    if (query.isEmpty) {
      setState(() {
        results = [];
      });
      return;
    }
    setState(() {
      results = fuzzySearch(query, items, 3); // maxDistance = 3
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Vazir', // اگه فونت فارسی داری
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('اپلیکیشن سرچ ناقص'),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'جستجو...',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.search),
                ),
                onChanged: (value) {
                  query = value;
                  search(query);
                },
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: results.length,
                itemBuilder: (context, index) => Card(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    title: Text(results[index]),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'ساخته شده توسط سید حسین موسوی منش\nبرای درس مبانی هوش محاسباتی\nاستاد: مریم شمس',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
