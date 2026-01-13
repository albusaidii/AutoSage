import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fl_chart/fl_chart.dart';

class AdminReportsScreen extends StatefulWidget {
  const AdminReportsScreen({super.key});

  @override
  State<AdminReportsScreen> createState() => _AdminReportsScreenState();
}

class _AdminReportsScreenState extends State<AdminReportsScreen> {
  Map<String, dynamic>? report;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchReports();
  }

  Future<void> fetchReports() async {
    final res =
    await http.get(Uri.parse("http://10.0.2.2:3000/api/admin/reports"));

    if (res.statusCode == 200) {
      setState(() {
        report = jsonDecode(res.body);
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("System Reports")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // ======================
            // TOP KPI — TOTAL USERS
            // ======================
            _totalUsersCard(),
            const SizedBox(height: 24),

            _dashboardCard(
              title: "Diagnosis Severity",
              subtitle: "Severity distribution of reported issues",
              child: _severityPie(),
            ),

            _dashboardCard(
              title: "Feedback Status",
              subtitle: "Reviewed vs pending feedback",
              child: _feedbackPie(),
            ),

            _dashboardCard(
              title: "Garage Availability",
              subtitle: "Operational status of garages",
              child: _garagePie(),
            ),
          ],
        ),
      ),
    );
  }

  // =====================================================
  // TOTAL USERS KPI CARD
  // =====================================================
  Widget _totalUsersCard() {
    final int totalUsers =
        int.tryParse(report!['users'].toString()) ?? 0;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 26, horizontal: 20),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.indigo.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.people_outline,
                size: 30,
                color: Colors.indigo,
              ),
            ),
            const SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Total Users",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  totalUsers.toString(),
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // =====================================================
  // DASHBOARD CARD
  // =====================================================
  Widget _dashboardCard({
    required String title,
    required String subtitle,
    required Widget child,
  }) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.only(bottom: 22),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(subtitle,
                style: TextStyle(color: Colors.grey[600], fontSize: 13)),
            const SizedBox(height: 20),
            child,
          ],
        ),
      ),
    );
  }

  // =====================================================
  // DIAGNOSIS SEVERITY PIE
  // =====================================================
  Widget _severityPie() {
    final List severity = report!['severity'];

    final Map<String, double> data = {
      for (var s in severity)
        s['severity']:
        double.tryParse(s['count'].toString()) ?? 0
    };

    return _pieWithLegend(
      sections: [
        _pieSection(data['Low'] ?? 0, Colors.green),
        _pieSection(data['Medium'] ?? 0, Colors.orange),
        _pieSection(data['High'] ?? 0, Colors.red),
      ],
      legends: [
        _legend("Low", data['Low'] ?? 0, Colors.green),
        _legend("Medium", data['Medium'] ?? 0, Colors.orange),
        _legend("High", data['High'] ?? 0, Colors.red),
      ],
    );
  }

  // =====================================================
  // FEEDBACK PIE
  // =====================================================
  Widget _feedbackPie() {
    final feedback = report!['feedback'];

    final double reviewed =
        double.tryParse(feedback['reviewed'].toString()) ?? 0;
    final double pending =
        double.tryParse(feedback['pending'].toString()) ?? 0;

    return _pieWithLegend(
      sections: [
        _pieSection(reviewed, Colors.green),
        _pieSection(pending, Colors.red),
      ],
      legends: [
        _legend("Reviewed", reviewed, Colors.green),
        _legend("Pending", pending, Colors.red),
      ],
    );
  }

  // =====================================================
  // GARAGE STATUS PIE
  // =====================================================
  Widget _garagePie() {
    final garages = report!['garages'];

    final double active =
        double.tryParse(garages['active'].toString()) ?? 0;
    final double disabled =
        double.tryParse(garages['disabled'].toString()) ?? 0;

    return _pieWithLegend(
      sections: [
        _pieSection(active, Colors.blue),
        _pieSection(disabled, Colors.grey),
      ],
      legends: [
        _legend("Active", active, Colors.blue),
        _legend("Disabled", disabled, Colors.grey),
      ],
    );
  }

  // =====================================================
  // SHARED PIE + LEGEND
  // =====================================================
  Widget _pieWithLegend({
    required List<PieChartSectionData> sections,
    required List<Widget> legends,
  }) {
    return Column(
      children: [
        SizedBox(
          height: 200,
          child: PieChart(
            PieChartData(
              sections: sections,
              centerSpaceRadius: 42,
              sectionsSpace: 4,
            ),
          ),
        ),
        const SizedBox(height: 12),
        ...legends,
      ],
    );
  }

  PieChartSectionData _pieSection(double value, Color color) {
    return PieChartSectionData(
      value: value == 0 ? 0.01 : value,
      color: color,
      radius: 60,
      title: '',
    );
  }

  Widget _legend(String label, double value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration:
            BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 8),
          Text("$label: ${value.toInt()}"),
        ],
      ),
    );
  }
}
