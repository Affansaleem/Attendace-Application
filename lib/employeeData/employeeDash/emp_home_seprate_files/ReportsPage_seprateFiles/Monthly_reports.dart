import 'package:flutter/material.dart';

import '../../../../api_intigration_files/models/MonthlyReports_model.dart';
import '../../../../api_intigration_files/repository/MonthlyReports_repository.dart';

class MonthlyReportsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Monthly Reports'),
      ),
      body: FutureBuilder(
        // Replace with your API call using the MonthlyReportsRepository
        future: fetchMonthlyReportsData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // While data is being fetched, show a loading indicator
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            // If there's an error, display an error message
            return Center(child: Text('Error: ${snapshot.error.toString()}'));
          } else {
            // If data has been successfully fetched, display it
            final monthlyReports = snapshot.data as List<Map<String, dynamic>>;
            return MonthlyReportsListView(monthlyReports: monthlyReports);
          }
        },
      ),
    );
  }

  // Replace this function with your actual API call using the MonthlyReportsRepository
  Future<List<MonthlyReportsModel>> fetchMonthlyReportsData() async {
    final repository = MonthlyReportsRepository();

    try {
      final reportsData = await repository.getMonthlyReports(
        corporateId: 'your_corporate_id',
        employeeId: 3,
        month: 8,
      );

      return reportsData;
    } catch (e) {
      throw e; // You can handle errors as needed
    }
  }
}

// monthly_reports_list_view.dart


class MonthlyReportsListView extends StatelessWidget {
  final List<Map<String, dynamic>> monthlyReports;

  MonthlyReportsListView({required this.monthlyReports});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: monthlyReports.length,
      itemBuilder: (context, index) {
        final report = monthlyReports[index];
        return Card(
          margin: EdgeInsets.all(8.0),
          child: ListTile(
            title: Text("Shift Start Time: ${report['shiftstarttime']}"),
            subtitle: Text("Shift End Time: ${report['shiftendtime']}"),
            // Add other fields you want to display
          ),
        );
      },
    );
  }
}
