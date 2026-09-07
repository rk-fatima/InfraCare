import 'package:flutter/material.dart';

class IssueReport {
  final String category;
  final String description;
  final String imagePath;
  final DateTime timestamp;
  String status;
  final IconData icon;
  final String location;

  IssueReport({
    required this.category,
    required this.description,
    required this.imagePath,
    required this.timestamp,
    required this.location,
    this.status = "Submitted",
    this.icon = Icons.report_problem,
  });
}