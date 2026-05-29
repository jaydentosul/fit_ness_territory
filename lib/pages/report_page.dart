import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  final TextEditingController territoryController = TextEditingController();
  final TextEditingController reasonController = TextEditingController();

  String issueType = "Territory Issue";
  bool isLoading = false;

  // saves issue report to firebase
  Future<void> submitReport() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) return;

    if (reasonController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please describe the issue")),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    await FirebaseFirestore.instance.collection('reports').add({
      'issueType': issueType,
      'territoryName': territoryController.text.trim(),
      'description': reasonController.text.trim(),
      'reportedBy': user.uid,
      'userEmail': user.email,
      'date': Timestamp.now(),
      'status': 'pending',
    });

    setState(() {
      isLoading = false;
    });

    territoryController.clear();
    reasonController.clear();

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Report submitted')),
    );
  }

  @override
  void dispose() {
    territoryController.dispose();
    reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Report Issues'),
      ),

      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Icon(
            Icons.report_problem_outlined,
            size: 70,
            color: Colors.orange,
          ),

          const SizedBox(height: 10),

          const Center(
            child: Text(
              "Report an Issue",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(height: 8),

          const Center(
            child: Text(
              "Report problems with territories or with the app itself.",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black54,
              ),
            ),
          ),

          const SizedBox(height: 25),

          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                children: [
                  // choose issue type
                  DropdownButtonFormField<String>(
                    value: issueType,
                    decoration: const InputDecoration(
                      labelText: 'Issue Type',
                      prefixIcon: Icon(Icons.category_outlined),
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: "Territory Issue",
                        child: Text("Territory Issue"),
                      ),
                      DropdownMenuItem(
                        value: "App Issue",
                        child: Text("App Issue"),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        issueType = value!;
                      });
                    },
                  ),

                  const SizedBox(height: 18),

                  TextField(
                    controller: territoryController,
                    decoration: const InputDecoration(
                      labelText: 'Territory Name (Optional)',
                      hintText: 'Only needed for territory issues',
                      prefixIcon: Icon(Icons.map_outlined),
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 18),

                  TextField(
                    controller: reasonController,
                    maxLines: 5,
                    decoration: const InputDecoration(
                      labelText: 'Issue Description',
                      hintText: 'Describe the issue here',
                      prefixIcon: Icon(Icons.edit_note),
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 22),

                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: isLoading ? null : submitReport,
                      icon: const Icon(Icons.send),
                      label: isLoading
                          ? const Text("Submitting...")
                          : const Text("Submit Report"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}