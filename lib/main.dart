import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'data.dart';
import 'fuzzy_search.dart';

void main() => runApp(FuzzySearchApp());

class FuzzySearchApp extends StatefulWidget {
  @override
  _FuzzySearchAppState createState() => _FuzzySearchAppState();
}

class _FuzzySearchAppState extends State<FuzzySearchApp> {
  String query = '';
  List<FuzzySearchResult> results = [];

  void search(String query) {
    if (query.isEmpty) {
      setState(() {
        results = [];
      });
      return;
    }
    setState(() {
      results = fuzzySearch(query, items, 3);
    });
  }

  @override
  Widget build(BuildContext context) {
    final double chartHeight = MediaQuery.of(context).size.height * 0.35;
    final double listHeight =
        MediaQuery.of(context).size.height * 0.4; // ارتفاع محدود برای لیست

    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.teal,
        scaffoldBackgroundColor: Colors.grey[100],
        cardTheme: CardTheme(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        appBarTheme: AppBarTheme(
          elevation: 2,
          backgroundColor: Colors.teal,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      home: Directionality(
        textDirection: TextDirection.rtl,
        child: SafeArea(
          child: Scaffold(
            appBar: AppBar(
              title: Text('اپلیکیشن جستجوی فازی'),
              centerTitle: true,
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(
                        MediaQuery.of(context).size.width * 0.04),
                    child: TextField(
                      textAlign: TextAlign.right,
                      decoration: InputDecoration(
                        hintText: 'جستجو کنید...',
                        hintStyle: TextStyle(color: Colors.grey[600]),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        suffixIcon: Icon(Icons.search, color: Colors.teal),
                        contentPadding: EdgeInsets.symmetric(
                          vertical: MediaQuery.of(context).size.height * 0.02,
                          horizontal: MediaQuery.of(context).size.width * 0.05,
                        ),
                      ),
                      onChanged: (value) {
                        query = value;
                        search(query);
                      },
                    ),
                  ),
                  if (results.isNotEmpty)
                    Container(
                      height: chartHeight,
                      padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width * 0.04,
                        vertical: MediaQuery.of(context).size.height * 0.01,
                      ),
                      child: BarChart(
                        BarChartData(
                          alignment: BarChartAlignment.spaceAround,
                          barGroups: results.asMap().entries.map((entry) {
                            int idx = entry.key;
                            FuzzySearchResult res = entry.value;
                            return BarChartGroupData(
                              x: idx,
                              barRods: [
                                BarChartRodData(
                                  toY: res.membership,
                                  color: res.membership > 0.5
                                      ? Colors.teal
                                      : Colors.grey.withOpacity(0.5),
                                  width: 16,
                                  borderRadius: BorderRadius.circular(4),
                                  backDrawRodData: BackgroundBarChartRodData(
                                    show: true,
                                    toY: 1.0,
                                    color: Colors.grey.withOpacity(0.1),
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                          gridData: FlGridData(
                            show: true,
                            drawVerticalLine: true,
                            horizontalInterval: 0.2,
                            verticalInterval: 1,
                            getDrawingHorizontalLine: (value) {
                              return FlLine(
                                color: Colors.grey.withOpacity(0.2),
                                strokeWidth: 1,
                              );
                            },
                            getDrawingVerticalLine: (value) {
                              return FlLine(
                                color: Colors.grey.withOpacity(0.2),
                                strokeWidth: 1,
                              );
                            },
                          ),
                          titlesData: FlTitlesData(
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 40,
                                interval: 1,
                                getTitlesWidget: (value, meta) {
                                  int idx = value.toInt();
                                  if (idx >= 0 && idx < results.length) {
                                    return Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Text(
                                        results[idx].value,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.black87,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    );
                                  }
                                  return Text('');
                                },
                              ),
                            ),
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 40,
                                interval: 0.2,
                                getTitlesWidget: (value, meta) {
                                  return Text(
                                    value.toStringAsFixed(1),
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.black87,
                                    ),
                                    textAlign: TextAlign.right,
                                  );
                                },
                              ),
                            ),
                            topTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            rightTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                          ),
                          borderData: FlBorderData(
                            show: true,
                            border: Border.all(
                              color: Colors.grey.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          barTouchData: BarTouchData(
                            enabled: true,
                            touchTooltipData: BarTouchTooltipData(
                              // tooltipBgColor: Colors.teal.withOpacity(0.8),
                              tooltipRoundedRadius: 8,
                              getTooltipItem:
                                  (group, groupIndex, rod, rodIndex) {
                                if (groupIndex >= 0 &&
                                    groupIndex < results.length) {
                                  double maxMembership = results.isNotEmpty
                                      ? results
                                          .map((e) => e.membership)
                                          .reduce((a, b) => a > b ? a : b)
                                      : 0.0;
                                  String comparison = rod.toY == maxMembership
                                      ? ' (بیشترین)'
                                      : ' (${((rod.toY / maxMembership) * 100).toStringAsFixed(0)}% از بیشترین)';
                                  return BarTooltipItem(
                                    '${results[groupIndex].value}\nدرجه عضویت: ${rod.toY.toStringAsFixed(2)}$comparison',
                                    TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  );
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  Container(
                    height: listHeight,
                    child: ListView.builder(
                      padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width * 0.04,
                        vertical: MediaQuery.of(context).size.height * 0.01,
                      ),
                      itemCount: results.length,
                      itemBuilder: (context, index) => Card(
                        child: ListTile(
                          contentPadding: EdgeInsets.symmetric(
                            horizontal:
                                MediaQuery.of(context).size.width * 0.04,
                            vertical: MediaQuery.of(context).size.height * 0.01,
                          ),
                          title: Text(
                            results[index].value,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.right,
                          ),
                          subtitle: Text(
                            'درجه عضویت: ${results[index].membership.toStringAsFixed(2)}',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                            textAlign: TextAlign.right,
                          ),
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'انتخاب: ${results[index].value}',
                                  textAlign: TextAlign.right,
                                ),
                                duration: Duration(milliseconds: 500),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(
                        MediaQuery.of(context).size.width * 0.04),
                    child: Text(
                      'ساخته شده توسط سید حسین موسوی منش\nدرس مبانی هوش محاسباتی\nاستاد: مریم شمس',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
