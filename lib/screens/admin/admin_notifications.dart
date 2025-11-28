import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';


class AdminNotificationsScreen extends StatelessWidget {
  const AdminNotificationsScreen({super.key});

  // Change this if your Firestore collection name differs
  final String _collection = "notifications";

  String _formatTimestamp(Timestamp? ts) {
    if (ts == null) return "";
    final dt = ts.toDate();
    return DateFormat.yMMMd().add_jm().format(dt);
  }

  Color _severityColor(String? type) {
    switch (type) {
      case "BIN_FULL":
        return Colors.red;
      case "BIN_NEAR_FULL":
        return Colors.orange;
      default:
        return Colors.blue;
    }
  }

  IconData _severityIcon(String? type) {
    switch (type) {
      case "BIN_FULL":
        return Icons.warning_amber_rounded;
      case "BIN_NEAR_FULL":
        return Icons.report_problem_rounded;
      default:
        return Icons.info_outline;
    }
  }

  Future<void> _markAsRead(String docId) async {
    await FirebaseFirestore.instance.collection(_collection).doc(docId).update({
      'read': true,
      'read_at': FieldValue.serverTimestamp(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          "Notifications",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: Column(
        children: [
          const SizedBox(height: 10),

          /// ------------------------------------
          /// SEARCH BAR (UI only — no logic)
          /// ------------------------------------
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
                  hintText: "Search notifications...",
                  border: InputBorder.none,
                ),
              ),
            ),
          ),

          const SizedBox(height: 12),

          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection(_collection)
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final docs = snapshot.data!.docs;

                if (docs.isEmpty) {
                  return const Center(
                    child: Text(
                      "No notifications yet.",
                      style: TextStyle(color: Colors.grey),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final d = docs[index];
                    final data = d.data() as Map<String, dynamic>;
                    final id = d.id;

                    final binId = data['binId'] ?? "Unknown";
                    final type = data['type'] ?? "INFO";
                    final message = data['message'] ?? "";
                    final read = data['read'] == true;
                    final timestamp = data['timestamp'] as Timestamp?;

                    return Container(
                      margin: const EdgeInsets.only(bottom: 14),
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: read ? Colors.grey[100] : Colors.white,
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
                          /// ------------------------------------
                          /// TITLE ROW
                          /// ------------------------------------
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 20,
                                backgroundColor:
                                    _severityColor(type).withOpacity(0.12),
                                child: Icon(
                                  _severityIcon(type),
                                  color: _severityColor(type),
                                  size: 22,
                                ),
                              ),
                              const SizedBox(width: 12),

                              /// BIN ID + TYPE
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "$binId — ${type.replaceAll('_', ' ')}",
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 3),
                                    Text(
                                      _formatTimestamp(timestamp),
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              /// Menu + Mark Read
                              Row(
                                children: [
                                  if (!read)
                                    IconButton(
                                      icon: const Icon(Icons.check_circle,
                                          color: Colors.green),
                                      tooltip: "Mark as read",
                                      onPressed: () => _markAsRead(id),
                                    ),
                                  PopupMenuButton<String>(
                                    onSelected: (v) async {
                                      if (v == "delete") {
                                        await FirebaseFirestore.instance
                                            .collection(_collection)
                                            .doc(id)
                                            .delete();
                                      } else if (v == "mark_read") {
                                        await _markAsRead(id);
                                      }
                                    },
                                    itemBuilder: (ctx) => const [
                                      PopupMenuItem(
                                          value: "mark_read",
                                          child: Text("Mark as read")),
                                      PopupMenuItem(
                                          value: "delete",
                                          child: Text("Delete")),
                                    ],
                                  ),
                                ],
                              )
                            ],
                          ),

                          const SizedBox(height: 14),

                          /// ------------------------------------
                          /// MESSAGE TEXT
                          /// ------------------------------------
                          Text(
                            message,
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
