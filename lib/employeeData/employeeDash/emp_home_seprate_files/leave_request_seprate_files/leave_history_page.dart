import 'package:flutter/material.dart';

class LeavesHistoryPage extends StatefulWidget {
  @override
  _LeavesHistoryPageState createState() => _LeavesHistoryPageState();
}

class _LeavesHistoryPageState extends State<LeavesHistoryPage> {
  // Replace this with your API data or leave details list
  List<LeaveDetail> leaveDetails = [
    LeaveDetail('Annual Leave', '2023-10-10', 'Full Day', 'Approved'),
    LeaveDetail('Sick Leave', '2023-10-15', 'Half Day', 'Pending'),
    // Add more leave details as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Leaves History',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFFE26142),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 20),
            const Text(
              'Leave Details:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: leaveDetails.length,
                itemBuilder: (BuildContext context, int index) {
                  final leave = leaveDetails[index];
                  return LeaveCard(
                    leaveName: leave.leaveName,
                    date: leave.date,
                    duration: leave.duration,
                    status: leave.status,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LeaveDetail {
  final String leaveName;
  final String date;
  final String duration;
  final String status;

  LeaveDetail(this.leaveName, this.date, this.duration, this.status);
}

class LeaveCard extends StatelessWidget {
  final String leaveName;
  final String date;
  final String duration;
  final String status;

  LeaveCard({
    required this.leaveName,
    required this.date,
    required this.duration,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: ListTile(
        title: Text(leaveName),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Date: $date'),
            Text('Duration: $duration'),
            Text('Status: $status'),
          ],
        ),
      ),
    );
  }
}
