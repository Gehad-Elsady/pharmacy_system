import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pharmacy_system/Screens/Home/home_screen.dart';
import 'package:pharmacy_system/backend/fierbase_functions.dart';
import 'package:pharmacy_system/backend/models/cart_model.dart';

class AnalysisScreen extends StatelessWidget {
  static const String routeName = '/analysis-screen';
  const AnalysisScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Analysis',
          style: TextStyle(
            color: Colors.blue,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.blue,
          onPressed: () {
            Navigator.pushReplacementNamed(context, HomeScreen.routeName);
          },
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Monthly Sales Pie Chart
           kIsWeb? Row(
              children: [
                Expanded(
                  // height: 300,
                  child: StreamBuilder(
                    stream: FirebaseFunctions.cartsHistory(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      final data = snapshot.data!;
                      final now = DateTime.now();
                      final year = now.year;

                      final Map<int, double> monthlyTotals = {
                        for (int i = 1; i <= 12; i++) i: 0.0
                      };

                      for (var element in data) {
                        final date = element.createdAt;
                        if (date != null && date.year == year) {
                          monthlyTotals[date.month] =
                              monthlyTotals[date.month]! + (element.total ?? 0);
                        }
                      }

                      final pieSections = monthlyTotals.entries
                          .where((entry) => entry.value > 0)
                          .map((entry) {
                        final monthName = [
                          'January',
                          'February',
                          'March',
                          'April',
                          'May',
                          'June',
                          'July',
                          'August',
                          'September',
                          'October',
                          'November',
                          'December'
                        ][entry.key - 1];

                        return PieChartSectionData(
                            showTitle: true,
                            value: entry.value,
                            color: _getMonthColor(entry.key),
                            title:
                                '$monthName\n${entry.value.toStringAsFixed(2)}',
                            titleStyle: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ));
                      }).toList();

                      return _buildChartCard(
                        title: "Monthly Sales Breakdown",
                        child: PieChart(
                          PieChartData(
                            sectionsSpace: 10,
                            centerSpaceRadius: 70,
                            sections: pieSections,
                            titleSunbeamLayout: true,
                            borderData: FlBorderData(show: true),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Expanded(
                  // height: 300,
                  child: StreamBuilder(
                    stream: FirebaseFunctions.cartsHistory(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      final data = snapshot.data!;
                      final now = DateTime.now();
                      final month = now.month;
                      final year = now.year;
                      final daysInMonth = DateUtils.getDaysInMonth(year, month);

                      final Map<int, double> dailyTotals = {
                        for (int i = 1; i <= daysInMonth; i++) i: 0.0
                      };

                      for (var element in data) {
                        final date = element.createdAt;
                        if (date != null &&
                            date.year == year &&
                            date.month == month) {
                          dailyTotals[date.day] =
                              dailyTotals[date.day]! + (element.total ?? 0);
                        }
                      }

                      final lineChartData = dailyTotals.entries
                          .where((entry) => entry.value > 0)
                          .map((entry) =>
                              FlSpot(entry.key.toDouble(), entry.value))
                          .toList();

                      return _buildChartCard(
                        title: "Daily Sales Breakdown",
                        child: LineChart(
                          LineChartData(
                            gridData: FlGridData(show: true),
                            titlesData: FlTitlesData(
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  interval: 5,
                                  getTitlesWidget: (value, meta) {
                                    return Text(value.toInt().toString());
                                  },
                                ),
                              ),
                              leftTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  // showTitles: true,
                                  interval: 50,
                                  getTitlesWidget: (value, meta) {
                                    return Text(value.toInt().toString());
                                  },
                                ),
                              ),
                            ),
                            borderData: FlBorderData(show: true),
                            lineBarsData: [
                              LineChartBarData(
                                spots: lineChartData,
                                isCurved: true,
                                color: Colors.blue,
                                dotData: FlDotData(show: false),
                                belowBarData: BarAreaData(show: false),
                              ),
                            ],
                            lineTouchData: LineTouchData(
                              touchTooltipData: LineTouchTooltipData(
                                getTooltipColor: (touchedSpot) {
                                  return Colors.red;
                                },
                                // tooltipBgColor: Colors.black,
                                getTooltipItems: (spots) => spots
                                    .map((spot) => LineTooltipItem(
                                        'Day ${spot.x.toInt()}: ${spot.y.toStringAsFixed(2)}',
                                        const TextStyle(color: Colors.white)))
                                    .toList(),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ):Column(
              children: [
                StreamBuilder(
                  stream: FirebaseFunctions.cartsHistory(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }
                
                    final data = snapshot.data!;
                    final now = DateTime.now();
                    final year = now.year;
                
                    final Map<int, double> monthlyTotals = {
                      for (int i = 1; i <= 12; i++) i: 0.0
                    };
                
                    for (var element in data) {
                      final date = element.createdAt;
                      if (date != null && date.year == year) {
                        monthlyTotals[date.month] =
                            monthlyTotals[date.month]! + (element.total ?? 0);
                      }
                    }
                
                    final pieSections = monthlyTotals.entries
                        .where((entry) => entry.value > 0)
                        .map((entry) {
                      final monthName = [
                        'January',
                        'February',
                        'March',
                        'April',
                        'May',
                        'June',
                        'July',
                        'August',
                        'September',
                        'October',
                        'November',
                        'December'
                      ][entry.key - 1];
                
                      return PieChartSectionData(
                          showTitle: true,
                          value: entry.value,
                          color: _getMonthColor(entry.key),
                          title:
                              '$monthName\n${entry.value.toStringAsFixed(2)}',
                          titleStyle: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ));
                    }).toList();
                
                    return _buildChartCard(
                      title: "Monthly Sales Breakdown",
                      child: PieChart(
                        PieChartData(
                          sectionsSpace: 10,
                          centerSpaceRadius: 70,
                          sections: pieSections,
                          titleSunbeamLayout: true,
                          borderData: FlBorderData(show: true),
                        ),
                      ),
                    );
                  },
                ),
                StreamBuilder(
                  stream: FirebaseFunctions.cartsHistory(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }
                
                    final data = snapshot.data!;
                    final now = DateTime.now();
                    final month = now.month;
                    final year = now.year;
                    final daysInMonth = DateUtils.getDaysInMonth(year, month);
                
                    final Map<int, double> dailyTotals = {
                      for (int i = 1; i <= daysInMonth; i++) i: 0.0
                    };
                
                    for (var element in data) {
                      final date = element.createdAt;
                      if (date != null &&
                          date.year == year &&
                          date.month == month) {
                        dailyTotals[date.day] =
                            dailyTotals[date.day]! + (element.total ?? 0);
                      }
                    }
                
                    final lineChartData = dailyTotals.entries
                        .where((entry) => entry.value > 0)
                        .map((entry) =>
                            FlSpot(entry.key.toDouble(), entry.value))
                        .toList();
                
                    return _buildChartCard(
                      title: "Daily Sales Breakdown",
                      child: LineChart(
                        LineChartData(
                          gridData: FlGridData(show: true),
                          titlesData: FlTitlesData(
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                interval: 5,
                                getTitlesWidget: (value, meta) {
                                  return Text(value.toInt().toString());
                                },
                              ),
                            ),
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                // showTitles: true,
                                interval: 50,
                                getTitlesWidget: (value, meta) {
                                  return Text(value.toInt().toString());
                                },
                              ),
                            ),
                          ),
                          borderData: FlBorderData(show: true),
                          lineBarsData: [
                            LineChartBarData(
                              spots: lineChartData,
                              isCurved: true,
                              color: Colors.blue,
                              dotData: FlDotData(show: false),
                              belowBarData: BarAreaData(show: false),
                            ),
                          ],
                          lineTouchData: LineTouchData(
                            touchTooltipData: LineTouchTooltipData(
                              getTooltipColor: (touchedSpot) {
                                return Colors.red;
                              },
                              // tooltipBgColor: Colors.black,
                              getTooltipItems: (spots) => spots
                                  .map((spot) => LineTooltipItem(
                                      'Day ${spot.x.toInt()}: ${spot.y.toStringAsFixed(2)}',
                                      const TextStyle(color: Colors.white)))
                                  .toList(),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),

            const SizedBox(height: 20),
            
            // Branch Sales Horizontal Bar Chart
            _buildChartCard(
              title: 'Branch Sales Comparison',
              child: SizedBox(
                height: 300,
                child: StreamBuilder<List<CartModel>>(
  stream: FirebaseFunctions.cartsHistory(),
  builder: (context, snapshot) {
    final carts = snapshot.data ?? [];
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: 20000, // Adjust this based on your max expected value
        barTouchData: BarTouchData(
          enabled: true,
          touchTooltipData: BarTouchTooltipData(
            getTooltipColor: (group) => Colors.blueGrey[800]!,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              return BarTooltipItem(
                '${_getBranchName(group.x)}\n\$${rod.toY.toInt()}',
                const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              );
            },
          ),
        ),
        // ... rest of your BarChartData configuration
        barGroups: _generateBranchData(carts),
      ),
    );
  },
)
              ),
            ),

            const SizedBox(height: 20),

            // Weekly Sales Bar Chart
            SizedBox(
              height: 300,
              child: StreamBuilder(
                stream: FirebaseFunctions.cartsHistory(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final data = snapshot.data!;
                  final now = DateTime.now();
                  final weekStart =
                      now.subtract(Duration(days: now.weekday - 1));
                  final weekEnd = weekStart.add(const Duration(days: 6));

                  final Map<int, double> weeklyTotals = {
                    for (int i = 1; i <= 7; i++) i: 0.0
                  };

                  for (var element in data) {
                    final date = element.createdAt;
                    if (date != null &&
                        date.isAfter(
                            weekStart.subtract(const Duration(days: 1))) &&
                        date.isBefore(weekEnd.add(const Duration(days: 1)))) {
                      weeklyTotals[date.weekday] =
                          weeklyTotals[date.weekday]! + (element.total ?? 0);
                    }
                  }

                  final barGroups = weeklyTotals.entries.map((entry) {
                    return BarChartGroupData(
                      x: entry.key,
                      barRods: [
                        BarChartRodData(
                          toY: entry.value,
                          color: Colors.green,
                          width: 18,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ],
                    );
                  }).toList();

                  return _buildChartCard(
                    title: "Weekly Sales Overview",
                    child: BarChart(
                      BarChartData(
                        alignment: BarChartAlignment.spaceAround,
                        maxY: weeklyTotals.values.fold(
                                0,
                                (a, b) => a.toInt() > b.toInt()
                                    ? a.toInt()
                                    : b.toInt()) +
                            10,
                        barTouchData: BarTouchData(
                          enabled: true,
                          touchTooltipData: BarTouchTooltipData(
                            getTooltipColor: (group) {
                              return Colors.green;
                            },
                            // tooltipBgColor: Colors.grey.shade800,
                            getTooltipItem: (group, groupIndex, rod, rodIndex) {
                              final day = [
                                'M',
                                'T',
                                'W',
                                'T',
                                'F',
                                'S',
                                'S'
                              ][group.x - 1];
                              return BarTooltipItem(
                                '$day\n${rod.toY.toStringAsFixed(1)}',
                                const TextStyle(color: Colors.white),
                              );
                            },
                          ),
                        ),
                        titlesData: FlTitlesData(
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, _) {
                                final dayLabels = [
                                  'M',
                                  'T',
                                  'W',
                                  'T',
                                  'F',
                                  'S',
                                  'S'
                                ];
                                return Text(dayLabels[value.toInt() - 1]);
                              },
                            ),
                          ),
                          leftTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false)),
                          topTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false)),
                          rightTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false)),
                        ),
                        gridData: FlGridData(show: false),
                        borderData: FlBorderData(show: false),
                        barGroups: barGroups,
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              height: 300,
              child: FutureBuilder<Map<String, String>>(
                future: FirebaseFunctions
                    .getAllUserNames(), // Fetch all user names first
                builder: (context, userSnapshot) {
                  if (!userSnapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final userNames = userSnapshot.data!;

                  return StreamBuilder(
                    stream: FirebaseFunctions.cartsHistory(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      final data = snapshot.data!;
                      final now = DateTime.now();
                      final weekStart =
                          now.subtract(Duration(days: now.weekday - 1));
                      final weekEnd = weekStart.add(const Duration(days: 6));

                      final Map<String, double> userTotals = {};

                      for (var element in data) {
                        final date = element.createdAt;
                        final userId = element.userId ?? 'Unknown';
                        if (date != null &&
                            date.isAfter(
                                weekStart.subtract(const Duration(days: 1))) &&
                            date.isBefore(
                                weekEnd.add(const Duration(days: 1)))) {
                          userTotals[userId] =
                              (userTotals[userId] ?? 0) + (element.total ?? 0);
                        }
                      }

                      final userList = userTotals.keys.toList();
                      userList.sort();

                      final barGroups = <BarChartGroupData>[];
                      for (int i = 0; i < userList.length; i++) {
                        final userId = userList[i];
                        final total = userTotals[userId]!;
                        barGroups.add(
                          BarChartGroupData(
                            x: i,
                            barRods: [
                              BarChartRodData(
                                toY: total,
                                color: Colors.green,
                                width: 18,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ],
                          ),
                        );
                      }

                      return _buildChartCard(
                        title: "Weekly Sales by User",
                        child: BarChart(
                          BarChartData(
                            alignment: BarChartAlignment.spaceAround,
                            maxY: userTotals.values.fold(
                                    0,
                                    (a, b) => a.toInt() > b.toInt()
                                        ? a.toInt()
                                        : b.toInt()) +
                                10,
                            barTouchData: BarTouchData(
                              enabled: true,
                              touchTooltipData: BarTouchTooltipData(
                                getTooltipColor: (group) => Colors.green,
                                getTooltipItem:
                                    (group, groupIndex, rod, rodIndex) {
                                  final userId = userList[group.x.toInt()];
                                  final name = userNames[userId] ?? userId;
                                  return BarTooltipItem(
                                    '$name\n${rod.toY.toStringAsFixed(1)}',
                                    const TextStyle(color: Colors.white),
                                  );
                                },
                              ),
                            ),
                            titlesData: FlTitlesData(
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  getTitlesWidget: (value, _) {
                                    final index = value.toInt();
                                    if (index >= 0 && index < userList.length) {
                                      final userId = userList[index];
                                      final name = userNames[userId] ?? 'User';
                                      return Transform.rotate(
                                        angle: -0.5,
                                        child: Text(
                                          name
                                              .split(' ')
                                              .first, // Short first name
                                          style: const TextStyle(fontSize: 10),
                                        ),
                                      );
                                    }
                                    return const Text('');
                                  },
                                ),
                              ),
                              leftTitles: AxisTitles(
                                  sideTitles: SideTitles(showTitles: false)),
                              topTitles: AxisTitles(
                                  sideTitles: SideTitles(showTitles: false)),
                              rightTitles: AxisTitles(
                                  sideTitles: SideTitles(showTitles: false)),
                            ),
                            gridData: FlGridData(show: false),
                            borderData: FlBorderData(show: false),
                            barGroups: barGroups,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            // Top Selling Medicines Bar Chart
            SizedBox(
              height: 300, // Increased height to accommodate the chart
              child: StreamBuilder(
                stream: FirebaseFunctions.cartsHistory(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final data = snapshot.data!;
                  
                  // Track medicine sales
                  final Map<String, int> medicineSales = {};
                  
                  // Process all cart items to calculate total units sold per medicine
                  for (var cart in data) {
                    for (var item in cart.items) {
                      final medicineName = item.medicineName;
                      final unitsSold = item.quantity; // This already accounts for strip/unit selection
                      
                      medicineSales.update(
                        medicineName,
                        (existing) => existing + unitsSold,
                        ifAbsent: () => unitsSold,
                      );
                    }
                  }

                  
                  // Sort medicines by units sold (descending) and take top 10
                  final sortedMedicines = medicineSales.entries.toList()
                    ..sort((a, b) => b.value.compareTo(a.value));
                  final topMedicines = sortedMedicines.take(10).toList();
                  
                  if (topMedicines.isEmpty) {
                    return _buildChartCard(
                      title: 'Top Selling Medicines',
                      child: const Center(
                        child: Text('No sales data available'),
                      ),
                    );
                  }
                  
                  // Create bar groups for the chart
                  final barGroups = List.generate(
                    topMedicines.length,
                    (index) => BarChartGroupData(
                      x: index,
                      barRods: [
                        BarChartRodData(
                          toY: topMedicines[index].value.toDouble(),
                          color: Colors.blue,
                          width: 22,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ],
                    ),
                  );
                  
                  return _buildChartCard(
                    title: 'Top Selling Medicines (Last 30 Days)',
                    child: BarChart(
                      BarChartData(
                        alignment: BarChartAlignment.spaceAround,
                        maxY: (topMedicines.first.value * 1.2).toDouble(),
                        barTouchData: BarTouchData(
                          enabled: true,
                          touchTooltipData: BarTouchTooltipData(
                            getTooltipColor: (group) => Colors.blue,
                            getTooltipItem: (group, groupIndex, rod, rodIndex) {
                              final medicineName = topMedicines[group.x.toInt()].key;
                              final unitsSold = rod.toY.toInt();
                              return BarTooltipItem(
                                '$medicineName\n$unitsSold units',
                                const TextStyle(color: Colors.white),
                              );
                            },
                          ),
                        ),
                        titlesData: FlTitlesData(
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, _) {
                                if (value.toInt() >= 0 && value.toInt() < topMedicines.length) {
                                  final name = topMedicines[value.toInt()].key;
                                  // Shorten long medicine names
                                  final displayName = name.length > 15 
                                      ? '${name.substring(0, 12)}...' 
                                      : name;
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Transform.rotate(
                                      angle: -0.5,
                                      child: Text(
                                        displayName,
                                        style: const TextStyle(fontSize: 10),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  );
                                }
                                return const Text('');
                              },
                              reservedSize: 60, // Increased reserved size for better text display
                            ),
                          ),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              interval: _calculateInterval(topMedicines.first.value.toDouble()),
                              getTitlesWidget: (value, _) {
                                return Text(
                                  value.toInt().toString(),
                                  style: const TextStyle(fontSize: 10),
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
                        gridData: FlGridData(
                          show: true,
                          drawVerticalLine: false,
                          getDrawingHorizontalLine: (value) => FlLine(
                            color: Colors.grey[300]!,
                            strokeWidth: 1,
                          ),
                        ),
                        borderData: FlBorderData(show: false),
                        barGroups: barGroups,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  // Helper method to calculate a reasonable interval for the Y-axis
  double _calculateInterval(double maxValue) {
    if (maxValue <= 5) return 1;
    if (maxValue <= 20) return 5;
    if (maxValue <= 50) return 10;
    if (maxValue <= 100) return 20;
    if (maxValue <= 200) return 50;
    if (maxValue <= 500) return 100;
    return 200;
  }

  Widget _buildChartCard({required String title, required Widget child}) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            SizedBox(height: 200, child: child),
          ],
        ),
      ),
    );
  }

  // Helper method to generate a color based on an index (for consistent colors in charts)
  Color _getIndexColor(int index) {
    final colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.red,
      Colors.purple,
      Colors.teal,
      Colors.amber,
      Colors.deepPurple,
      Colors.lightBlue,
      Colors.lightGreen,
      Colors.pink,
      Colors.brown,
    ];
    return colors[index % colors.length];
  }

  // Get color for month
  Color _getMonthColor(int month) {
    return _getIndexColor(month - 1);
  }

  // Helper method to get branch name by index
  String _getBranchName(int branchId) {
    switch (branchId) {
      case 0:
        return 'Asuti';
      case 1:
        return 'Downtown';
      case 2:
        return 'Westside';
      default:
        return 'Branch $branchId';
    }
  }

  // Generate sample branch sales data
  List<BarChartGroupData> _generateBranchData(List<CartModel>? carts) {
  // Calculate total sales for Asuti branch
  double asutiSales = 0;
  if (carts != null) {
    asutiSales = carts.fold(0, (sum, cart) => sum + cart.total);
  }

  // Sample data for other branches (kept static)
  final branchData = [
    {'id': 0, 'sales': asutiSales, 'color': Colors.blue}, // Asuti branch with dynamic data
    {'id': 1, 'sales': 3000, 'color': Colors.green}, // Downtown (static)
    {'id': 2, 'sales': 4500, 'color': Colors.orange}, // Westside (static)
  ];

  return branchData.map((branch) {
    return BarChartGroupData(
      x: branch['id'] as int,
      barRods: [
        BarChartRodData(
          toY: (branch['sales'] as num).toDouble(),
          color: branch['color'] as Color,
          width: 30,
          borderRadius: BorderRadius.circular(4),
          backDrawRodData: BackgroundBarChartRodData(
            show: false,
            toY: 1200, // Max Y value + some padding
          ),
        ),
      ],
    );
  }).toList();
}
}
