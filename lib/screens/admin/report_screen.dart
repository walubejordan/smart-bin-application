import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          "Reports",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),

      body: Column(
        children: [
          const SizedBox(height: 10),

          /// ----------------------------------------
          /// SEARCH BAR
          /// ----------------------------------------
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
              ),
              child: TextField(
                decoration: InputDecoration(
                  icon: Icon(Icons.search, color: Colors.grey.shade600),
                  hintText: "Search by Report ID, Location...",
                  border: InputBorder.none,
                ),
              ),
            ),
          ),

          const SizedBox(height: 12),

          /// ----------------------------------------
          /// FILTER ROW
          /// ----------------------------------------
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _filterChip(Icons.filter_alt_outlined, "Status: All"),
                const SizedBox(width: 10),
                _filterChip(Icons.person_outline, "Type: User Report"),
                const Spacer(),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.more_vert),
                )
              ],
            ),
          ),

          const SizedBox(height: 10),

          /// ----------------------------------------
          /// REPORT LIST
          /// ----------------------------------------
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _reportCard(
                  title: "Overflowing Bin",
                  type: "User Report",
                  date: "2023-10-27 09:35 AM",
                  location: "City Park, Main Entrance",
                  reportId: "REP-80213",
                  status: "New",
                  statusColor: Colors.orange,
                ),
                _reportCard(
                  title: "Bin Damage Detected",
                  type: "AI Sensor Alert",
                  date: "2023-10-26 08:14 PM",
                  location: "Bin: AI-5821",
                  reportId: "REP-10012",
                  status: "In Progress",
                  statusColor: Colors.blue,
                ),
                _reportCard(
                  title: "Illegal Dumping",
                  type: "User Report",
                  date: "2023-10-25 11:00 AM",
                  location: "West Avenue Trail",
                  reportId: "REP-56221",
                  status: "Resolved",
                  statusColor: Colors.green,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// ======================================================
  /// COMPONENTS
  /// ======================================================

  Widget _filterChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            blurRadius: 6,
            offset: const Offset(0, 3),
            color: Colors.black.withOpacity(0.03),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.green),
          const SizedBox(width: 6),
          Text(label, style: const TextStyle(fontSize: 13)),
        ],
      ),
    );
  }

  Widget _reportCard({
    required String title,
    required String type,
    required String date,
    required String location,
    required String reportId,
    required String status,
    required Color statusColor,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            blurRadius: 10,
            offset: const Offset(0, 3),
            color: Colors.black.withOpacity(0.05),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Title + Status chip
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold)),

              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    color: statusColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 4),
          Text(type, style: TextStyle(color: Colors.grey.shade600)),

          const SizedBox(height: 10),
          Text(location, style: const TextStyle(fontSize: 14)),

          const SizedBox(height: 6),
          Text("ID: $reportId",
              style: const TextStyle(color: Colors.grey, fontSize: 13)),

          const SizedBox(height: 8),
          Text(date, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        ],
      ),
    );
  }
}
