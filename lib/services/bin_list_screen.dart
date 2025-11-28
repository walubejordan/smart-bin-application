import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/bin_service.dart';
import 'edit_bin_screen.dart';

class BinListScreen extends StatelessWidget {
  BinListScreen({super.key});

  final BinService binService = BinService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("All Bins")),
      body: StreamBuilder<QuerySnapshot>(
        stream: binService.getBinsStream(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          var bins = snapshot.data!.docs;

          return ListView.builder(
            itemCount: bins.length,
            itemBuilder: (context, index) {
              var bin = bins[index];
              var id = bin.id;
              var name = bin["name"];
              var status = bin["status"];

              return ListTile(
                title: Text(name),
                subtitle: Text("Status: $status"),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // EDIT BUTTON
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.green),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => EditBinScreen(
                              binId: id,
                              existingName: name,
                              existingStatus: status,
                            ),
                          ),
                        );
                      },
                    ),

                    // DELETE BUTTON
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () async {
                        await binService.deleteBin(id);
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
