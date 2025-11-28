import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool notificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F8E9),

      appBar: AppBar(
        title: const Text("Settings"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: const Color(0xFFF1F8E9),
        foregroundColor: Colors.black87,
      ),

      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // -------------------------
          // 🔔 NOTIFICATION SWITCH
          // -------------------------
          _settingsCard(
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.green.withOpacity(0.15),
                  child: const Icon(Icons.notifications_active, color: Colors.green),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Text(
                    "Enable Notifications",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                Switch(
                  value: notificationsEnabled,
                  activeColor: Colors.green,
                  onChanged: (value) {
                    setState(() {
                      notificationsEnabled = value;
                    });
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // -------------------------
          // 🌍 LANGUAGE OPTION
          // -------------------------
          _settingsCard(
            child: ListTile(
              leading: CircleAvatar(
                radius: 20,
                backgroundColor: Colors.blue.withOpacity(0.15),
                child: const Icon(Icons.language, color: Colors.blue),
              ),
              title: const Text("Language"),
              subtitle: const Text("English"),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {},
            ),
          ),

          const SizedBox(height: 16),

          // -------------------------
          // ℹ️ ABOUT APP
          // -------------------------
          _settingsCard(
            child: ListTile(
              leading: CircleAvatar(
                radius: 20,
                backgroundColor: Colors.orange.withOpacity(0.15),
                child: const Icon(Icons.info_outline, color: Colors.orange),
              ),
              title: const Text("About SmartBin"),
              subtitle: const Text("Version 1.0.0"),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {},
            ),
          ),
        ],
      ),
    );
  }

  // --------------------------------------------------
  // 🌟 Reusable Card Widget
  // --------------------------------------------------
  Widget _settingsCard({required Widget child}) {
    return Container(
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
      child: child,
    );
  }
}
