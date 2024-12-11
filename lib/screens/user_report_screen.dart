import 'package:flutter/material.dart';
import '../services/sqlite_service.dart';

class UserReportScreen extends StatelessWidget {
  final int userId;
  final SQLiteService sqliteService = SQLiteService();

  UserReportScreen({required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("User Reports")),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: sqliteService.getUserReports(userId),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const CircularProgressIndicator();

          final reports = snapshot.data!;
          return ListView.builder(
            itemCount: reports.length,
            itemBuilder: (context, index) {
              var report = reports[index];
              return ListTile(
                title: Text(report['reportName']),
                subtitle: Text("Date: ${report['date']}"),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () async {
                    await sqliteService.deleteReport(report['id']);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Report deleted")),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Implement document upload logic
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
