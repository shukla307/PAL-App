import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class CbcGraphScreen extends StatelessWidget {
  // Sample CBC Data
  final List<Map<String, dynamic>> cbcData = [
    {"date": "2024-11-01", "Hemoglobin": 13.0, "Platelets": 250},
    {"date": "2024-11-08", "Hemoglobin": 13.8, "Platelets": 245},
    {"date": "2024-11-15", "Hemoglobin": 4.2, "Platelets": 255},
    {"date": "2024-11-22", "Hemoglobin": 7.1, "Platelets": 248},
    {"date": "2024-11-29", "Hemoglobin": 9.9, "Platelets": 252},
  ];

  // Extracting data points for Hemoglobin and Platelets
  List<FlSpot> getHemoglobinSpots() {
    return List.generate(
      cbcData.length,
          (index) => FlSpot(index.toDouble(), cbcData[index]['Hemoglobin']),
    );
  }

  //print(List.generate)

  List<FlSpot> getPlateletsSpots() {
    return List.generate(
      cbcData.length,
          (index) => FlSpot(index.toDouble(), cbcData[index]['Platelets'] / 100), // Normalized for graph
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Graph",
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              "Hemoglobin (g/dL)",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 50),  // table
            SizedBox(
              height: 300,
              child: LineChart(
                LineChartData(
                  gridData: const FlGridData(show: false),  //determines showing or hiding all grids,
                  borderData: FlBorderData(show: true),
                  titlesData: FlTitlesData(
                    leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: true)),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, _) {
                          if (value.toInt() < cbcData.length) {
                            return Text(
                              cbcData[value.toInt()]['date'].split('-').last,
                              style: const TextStyle(fontSize: 12),
                            );
                          }
                          return const Text('');
                        },
                      ),
                    ),
                  ),
                  lineBarsData: [
                    LineChartBarData(
                      spots: getHemoglobinSpots(),
                      isCurved: true,
                      barWidth: 4,
                      color: Colors.green,
                      dotData: const FlDotData(show: true),
                    ),
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

















// import 'package:flutter/material.dart';
// import '../services/sqlite_service.dart';
// import 'user_report_screen.dart';
//
// class AdminDashboardScreen extends StatelessWidget {
//   final SQLiteService sqliteService = SQLiteService();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Admin Dashboard")),
//       body: FutureBuilder<List<Map<String, dynamic>>>(
//         future: sqliteService.getAllUsersWithReports(),
//         builder: (context, snapshot) {
//           if (!snapshot.hasData) return const CircularProgressIndicator();
//
//           final users = snapshot.data!;
//           return ListView.builder(
//             itemCount: users.length,
//             itemBuilder: (context, index) {
//               var user = users[index];
//               return ListTile(
//                 title: Text(user['name']),
//                 subtitle: Text(user['phone']),
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => UserReportScreen(userId: user['id']),
//                     ),
//                   );
//                 },
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }
