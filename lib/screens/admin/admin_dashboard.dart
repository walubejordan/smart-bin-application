import 'package:flutter/material.dart';
import 'bin_status_screen.dart';
import 'bin_map_screen.dart';
import 'manage_users_screen.dart';
import 'settings_screen.dart';
import 'admin_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  Stream<int> _getCount(String collection) {
    return FirebaseFirestore.instance
        .collection(collection)
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 15),

              // PROFILE HEADER
              Row(
                children: [
                  const CircleAvatar(
                    radius: 28,
                    backgroundImage: AssetImage('assets/profile.jpg'),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "Kumaabutonde",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "Welcome, Admin",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.notifications_outlined, size: 28),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AdminNotificationsScreen(),
                        ),
                      );
                    },
                  )
                ],
              ),

              const SizedBox(height: 25),

              // FIRESTORE STATS ROW 1
              Row(
                children: [
                  Expanded(
                    child: StreamBuilder<int>(
                      stream: _getCount('users'),
                      builder: (context, snapshot) {
                        return _statCard(
                          "Total Users",
                          snapshot.hasData ? snapshot.data.toString() : "--",
                          Icons.people_alt,
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: StreamBuilder<int>(
                      stream: _getCount('bins'),
                      builder: (context, snapshot) {
                        return _statCard(
                          "Active Bins",
                          snapshot.hasData ? snapshot.data.toString() : "--",
                          Icons.delete_outline,
                        );
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 15),

              // FIRESTORE STATS ROW 2
              Row(
                children: [
                  Expanded(
                    child: StreamBuilder<int>(
                      stream: _getCount('alerts'),
                      builder: (context, snapshot) {
                        return _statCard(
                          "Active Alerts",
                          snapshot.hasData ? snapshot.data.toString() : "--",
                          Icons.warning_amber,
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: StreamBuilder<int>(
                      stream: _getCount('reports'),
                      builder: (context, snapshot) {
                        return _statCard(
                          "Reports",
                          snapshot.hasData ? snapshot.data.toString() : "--",
                          Icons.receipt_long,
                        );
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 25),

              // CHART PLACEHOLDER
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Bin Usage Trends",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: const [
                        Text(
                          "75%",
                          style: TextStyle(
                              fontSize: 28, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(width: 5),
                        Text(
                          "+5.2%",
                          style: TextStyle(color: Colors.green),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Container(
                      height: 140,
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Center(
                        child: Text(
                          "Chart Preview Placeholder",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // RECENT ACTIVITY
              const Text(
                "Recent Activity",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),

              _activityTile(
                title: "Bin #102 is 95% full",
                subtitle: "High Priority",
                time: "2 min ago",
                icon: Icons.warning_amber,
                iconColor: Colors.red,
              ),
              _activityTile(
                title: "Collection route updated",
                subtitle: "System Notification",
                time: "9 min ago",
                icon: Icons.sync,
                iconColor: Colors.blue,
              ),
              _activityTile(
                title: "Battery low on Bin #56",
                subtitle: "Maintenance Needed",
                time: "1 hr ago",
                icon: Icons.battery_5_bar,
                iconColor: Colors.orange,
              ),

              const SizedBox(height: 90),
            ],
          ),
        ),
      ),

      // BOTTOM NAVIGATION
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -3),
            )
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _navItem(Icons.dashboard, "Dashboard", () {}),
            _navItem(Icons.delete_outline, "Bin Status", () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const BinStatusScreen()),
              );
            }),
            _navItem(Icons.map_outlined, "Map", () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const BinMapScreen()),
              );
            }),
            _navItem(Icons.people_outline, "Users", () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ManageUsersScreen()),
              );
            }),
            _navItem(Icons.settings_outlined, "Settings", () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AdminSettingsScreen()),
              );
            }),
          ],
        ),
      ),
    );
  }

  //-----------------------------------------------------
  // COMPONENTS
  //-----------------------------------------------------

  Widget _statCard(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(18),
      height: 110,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.green, size: 28),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text(title, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _activityTile({
    required String title,
    required String subtitle,
    required String time,
    required IconData icon,
    required Color iconColor,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: iconColor.withOpacity(0.15),
            child: Icon(icon, color: iconColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.bold),
                ),
                Text(subtitle, style: const TextStyle(color: Colors.grey)),
              ],
            ),
          ),
          Text(time, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _navItem(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.green),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(color: Colors.green)),
        ],
      ),
    );
  }
}
