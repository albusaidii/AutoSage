import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AdminUserManagementScreen extends StatefulWidget {
  const AdminUserManagementScreen({super.key});

  @override
  State<AdminUserManagementScreen> createState() =>
      _AdminUserManagementScreenState();
}

class _AdminUserManagementScreenState extends State<AdminUserManagementScreen> {
  List users = [];
  bool isLoading = true;

  final String baseUrl = "http://10.0.2.2:3000/api";

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  // ===============================
  // FETCH USERS
  // ===============================
  Future<void> fetchUsers() async {
    setState(() => isLoading = true);

    final res = await http.get(Uri.parse("$baseUrl/admin/users"));

    if (!mounted) return;

    if (res.statusCode == 200) {
      setState(() {
        users = jsonDecode(res.body);
        isLoading = false;
      });
    } else {
      setState(() => isLoading = false);
    }
  }

  // ===============================
  // APPROVE DELETION
  // ===============================
  Future<void> approveDeletion(int userId) async {
    await http.post(
      Uri.parse("$baseUrl/admin/users/$userId/approve-deletion"),
    );

    fetchUsers(); // refresh table
  }

  // ===============================
  // REJECT DELETION
  // ===============================
  Future<void> rejectDeletion(int userId) async {
    await http.post(
      Uri.parse("$baseUrl/admin/users/$userId/reject-deletion"),
    );

    fetchUsers(); // refresh table
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("User Management")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : users.isEmpty
          ? const Center(child: Text("No users found"))
          : ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: users.length,
        separatorBuilder: (_, __) => const Divider(),
        itemBuilder: (context, index) {
          final user = users[index];

          final int userId = (user["user_id"] is int)
              ? user["user_id"]
              : int.tryParse(user["user_id"].toString()) ?? 0;

          final String name = (user["name"] ?? "").toString();
          final String email = (user["email"] ?? "").toString();
          final String? phone =
          user["phone"]?.toString();

          final bool deletionRequested = user["deletion_requested"] == 1;

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ================= ID BADGE (NEW) =================
              Container(
                width: 42,
                height: 42,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  userId.toString(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // ================= USER INFO =================
              Expanded(
                flex: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),

                    // ID line (NEW) - you can remove this if you only want the badge


                    Text(email),
                    if (phone != null && phone.trim().isNotEmpty)
                      Text("📞 $phone"),

                    const SizedBox(height: 6),
                    Text(
                      deletionRequested ? "Deletion Requested" : "Active",
                      style: TextStyle(
                        color: deletionRequested ? Colors.orange : Colors.green,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

              // ================= ACTIONS =================
              if (deletionRequested)
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.check, color: Colors.green),
                      tooltip: "Approve deletion",
                      onPressed: () => approveDeletion(userId),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.red),
                      tooltip: "Reject deletion",
                      onPressed: () => rejectDeletion(userId),
                    ),
                  ],
                ),
            ],
          );
        },
      ),
    );
  }
}
