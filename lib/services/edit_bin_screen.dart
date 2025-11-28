import 'package:flutter/material.dart';
import '../services/bin_service.dart';

class EditBinScreen extends StatefulWidget {
  final String binId;
  final String existingName;
  final String existingStatus;

  const EditBinScreen({
    super.key,
    required this.binId,
    required this.existingName,
    required this.existingStatus,
  });

  @override
  State<EditBinScreen> createState() => _EditBinScreenState();
}

class _EditBinScreenState extends State<EditBinScreen> {
  final BinService binService = BinService();
  late TextEditingController nameController;
  late TextEditingController statusController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.existingName);
    statusController = TextEditingController(text: widget.existingStatus);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Bin")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "Bin Name"),
            ),
            TextField(
              controller: statusController,
              decoration: const InputDecoration(labelText: "Status (full, empty, half)"),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () async {
                await binService.updateBin(
                  widget.binId,
                  nameController.text,
                  statusController.text,
                );

                Navigator.pop(context);
              },
              child: const Text("Save Changes"),
            ),
          ],
        ),
      ),
    );
  }
}
