import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';

class DashboardTab extends StatefulWidget {
  const DashboardTab({super.key});

  @override
  _DashboardTabState createState() => _DashboardTabState();
}

class _DashboardTabState extends State<DashboardTab> {
  // Fetch counts from Firestore
  Future<Map<String, int>> getCounts() async {
    try {
      var songsCollection = FirebaseFirestore.instance.collection('songs');
      var artistsCollection = FirebaseFirestore.instance.collection('artists');
      var devotionalsCollection =
          FirebaseFirestore.instance.collection('devotionals');

      var songsCount = (await songsCollection.get()).size;
      var artistsCount = (await artistsCollection.get()).size;
      var devotionalsCount = (await devotionalsCollection.get()).size;

      return {
        'SONGS': songsCount,
        'ARTISTS': artistsCount,
        'DEVOTIONALS': devotionalsCount,
      };
    } catch (e) {
      print("Error fetching data: $e");
      return {
        'SONGS': 0,
        'ARTISTS': 0,
        'DEVOTIONALS': 0,
      };
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTitle('ADMIN DASHBOARD'),
            const SizedBox(height: 20),
            FutureBuilder<Map<String, int>>(
              future: getCounts(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (snapshot.hasData && snapshot.data != null) {
                  var counts = snapshot.data!;
                  return Column(
                    children: [
                      _buildStatCard('SONGS', counts['SONGS']!.toString()),
                      _buildStatCard('ARTISTS', counts['ARTISTS']!.toString()),
                      _buildStatCard(
                          'DEVOTIONALS', counts['DEVOTIONALS']!.toString()),
                      const SizedBox(height: 20),
                      const Text(
                        'Stats Bar Chart',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        height: 300, // Chart height
                        child: BarChart(
                          BarChartData(
                            gridData: FlGridData(show: false),
                            titlesData: FlTitlesData(
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  reservedSize: 30,
                                  getTitlesWidget:
                                      (double value, TitleMeta meta) {
                                    switch (value.toInt()) {
                                      case 0:
                                        return const Text(
                                          'Songs',
                                          style: TextStyle(fontSize: 12),
                                        );
                                      case 1:
                                        return const Text(
                                          'Artists',
                                          style: TextStyle(fontSize: 12),
                                        );
                                      case 2:
                                        return const Text(
                                          'Devotionals',
                                          style: TextStyle(fontSize: 12),
                                        );
                                      default:
                                        return const Text('');
                                    }
                                  },
                                ),
                              ),
                              leftTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: true),
                              ),
                            ),
                            barTouchData: BarTouchData(
                              touchTooltipData: BarTouchTooltipData(
                                tooltipMargin: 8,
                                tooltipPadding: const EdgeInsets.all(8),
                                getTooltipItem:
                                    (group, groupIndex, rod, rodIndex) {
                                  String label;
                                  switch (group.x.toInt()) {
                                    case 0:
                                      label = 'Songs';
                                      break;
                                    case 1:
                                      label = 'Artists';
                                      break;
                                    case 2:
                                      label = 'Devotionals';
                                      break;
                                    default:
                                      label = '';
                                  }
                                  return BarTooltipItem(
                                    '$label\n${rod.toY.toInt()}',
                                    const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                  );
                                },
                              ),
                            ),
                            borderData: FlBorderData(show: true),
                            barGroups: [
                              BarChartGroupData(
                                x: 0,
                                barRods: [
                                  BarChartRodData(
                                    toY: counts['SONGS']!.toDouble(),
                                    color: const Color(
                                        0xFFB4BA1C), // Updated color
                                    width: 20,
                                  ),
                                ],
                              ),
                              BarChartGroupData(
                                x: 1,
                                barRods: [
                                  BarChartRodData(
                                    toY: counts['ARTISTS']!.toDouble(),
                                    color: const Color(
                                        0xFFB4BA1C), // Updated color
                                    width: 20,
                                  ),
                                ],
                              ),
                              BarChartGroupData(
                                x: 2,
                                barRods: [
                                  BarChartRodData(
                                    toY: counts['DEVOTIONALS']!.toDouble(),
                                    color: const Color(
                                        0xFFB4BA1C), // Updated color
                                    width: 20,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                } else {
                  return const Text('No data available');
                }
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // Helper method to build the dashboard title
  Widget _buildTitle(String title) {
    return Container(
      width: 362,
      height: 47,
      decoration: BoxDecoration(
        color: const Color(0xFFB4BA1C),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Center(
        child: Text(
          title.toUpperCase(),
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  // Helper method to build the stat cards
  Widget _buildStatCard(String title, String count) {
    return Card(
      color: const Color(0xFFB4BA1C).withOpacity(0.5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: SizedBox(
        width: 350,
        height: 150,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: Center(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFB4BA1C),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Text(
                  count,
                  style: const TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
