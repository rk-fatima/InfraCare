import 'package:flutter/material.dart';
import 'issue_report.dart';

class ReportProvider extends ChangeNotifier {
  final List<IssueReport> _reports = [
    IssueReport(
      category: "Water Leak", 
      description: "Broken Pipe - Sector 4", 
      imagePath: "", 
      timestamp: DateTime.now(), 
      status: "Resolving", 
      icon: Icons.water_drop, 
      location: "Sector 4, Main Square"
    ),
  ];

  List<IssueReport> get reports => List.unmodifiable(_reports);
  int get totalReports => _reports.length;
  int get activeReports => _reports.where((r) => r.status != "Resolved").length;
  int get pendingReports => _reports.where((r) => r.status == "Submitted").length;
  int get resolvingReports => _reports.where((r) => r.status == "Under Review" || r.status == "Resolving").length;
  int get resolvedReports => _reports.where((r) => r.status == "Resolved").length;

  void addReport(IssueReport report) {
    _reports.insert(0, report);
    notifyListeners();
  }

  void updateReportStatus(int index, String newStatus) {
    // Note: This assumes the 'status' field in IssueReport is mutable.
    _reports[index].status = newStatus;
    notifyListeners();
  }
}