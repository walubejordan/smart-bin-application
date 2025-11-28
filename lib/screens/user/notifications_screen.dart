import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F8E9),

      appBar: AppBar(
        title: const Text("Notifications"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: const Color(0xFFF1F8E9),
        foregroundColor: Colors.black87,
      ),

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [

          // ------------------------
          // 🔴 BIN FULL ALERT CARD
          // ------------------------
          _notificationItem(
            icon: Icons.delete_forever,
            iconColor: Colors.red,
            title: "Bin A - Full Alert 🚨",
            message: "Bin A reached 100% capacity. Empty required!",
            time: "5 min ago",
          ),

          // ------------------------
          // 🟡 HIGH LEVEL WARNING
          // ------------------------
          _notificationItem(
            icon: Icons.warning_amber_rounded,
            iconColor: Colors.orange,
            title: "Bin B - 80% Full",
            message: "Bin B is nearing capacity.",
            time: "1 hour ago",
          ),

          // ------------------------
          // 🟢 ENVIRONMENTAL TIP
          // ------------------------
          _notificationItem(
            icon: Icons.eco,
            iconColor: Colors.green,
            title: "Recycling Tip",
            message: "Did you know you can recycle soft plastics at local markets?",
            time: "2 days ago",
          ),

          // ------------------------
          // 🔵 SYSTEM UPDATE
          // ------------------------
          _notificationItem(
            icon: Icons.system_update_alt,
            iconColor: Colors.blue,
            title: "App Update Available",
            message: "A new SmartBin version is now available.",
            time: "Mar 25",
          ),

          // ------------------------
          // 🟢 ISSUE RESOLVED
          // ------------------------
          _notificationItem(
            icon: Icons.check_circle,
            iconColor: Colors.green,
            title: "Issue Resolved",
            message: "The issue reported for Bin #SWB-456 has been resolved.",
            time: "Mar 22",
          ),
        ],
      ),
    );
  }

  // -----------------------------------------------------
  // ✨ CUSTOM BEAUTIFUL NOTIFICATION CARD
  // -----------------------------------------------------
  Widget _notificationItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String message,
    required String time,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ICON
          CircleAvatar(
            radius: 22,
            backgroundColor: iconColor.withOpacity(0.15),
            child: Icon(icon, color: iconColor, size: 26),
          ),

          const SizedBox(width: 12),

          // TEXTS
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    )),
                const SizedBox(height: 4),
                Text(
                  message,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  time,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
