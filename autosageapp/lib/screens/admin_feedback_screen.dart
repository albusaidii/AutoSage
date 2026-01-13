import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AdminFeedbackScreen extends StatefulWidget {
  const AdminFeedbackScreen({super.key});

  @override
  State<AdminFeedbackScreen> createState() => _AdminFeedbackScreenState();
}

class _AdminFeedbackScreenState extends State<AdminFeedbackScreen> {
  List feedbackList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchFeedback();
  }

  // =========================
  // FETCH FEEDBACK
  // =========================
  Future<void> fetchFeedback() async {
    try {
      final res = await http.get(
        Uri.parse("http://10.0.2.2:3000/api/admin/feedback"),
      );

      if (res.statusCode == 200) {
        setState(() {
          feedbackList = jsonDecode(res.body);
          isLoading = false;
        });
      } else {
        throw Exception("Failed to load feedback");
      }
    } catch (_) {
      setState(() => isLoading = false);
    }
  }

  // =========================
  // MARK AS REVIEWED
  // =========================
  Future<void> markAsReviewed(int feedbackId, int index) async {
    await http.put(
      Uri.parse(
        "http://10.0.2.2:3000/api/admin/feedback/$feedbackId/reviewed",
      ),
    );

    setState(() {
      feedbackList[index]["is_reviewed"] = 1;
    });
  }

  // =========================
  // HELPERS
  // =========================
  Color _typeColor(String type) {
    switch (type) {
      case "bug":
        return Colors.red;
      case "suggestion":
        return Colors.purple;
      case "chatbot":
        return Colors.blue;
      default:
        return Colors.green;
    }
  }

  Widget _ratingStars(int rating) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        5,
            (i) => Icon(
          i < rating ? Icons.star : Icons.star_border,
          size: 16,
          color: Colors.amber,
        ),
      ),
    );
  }

  // =========================
  // UI
  // =========================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("User Feedback"),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : feedbackList.isEmpty
          ? const Center(child: Text("No feedback submitted yet"))
          : ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: feedbackList.length,
        separatorBuilder: (_, __) =>
        const SizedBox(height: 12),
        itemBuilder: (context, i) {
          final f = feedbackList[i];
          final color = _typeColor(f["type"]);
          final bool isReviewed = f["is_reviewed"] == 1;

          return Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ================= HEADER =================
                  Row(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        f["name"],
                        style: const TextStyle(
                            fontWeight: FontWeight.bold),
                      ),
                      Row(
                        children: [
                          // REVIEW STATUS
                          Container(
                            padding:
                            const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4),
                            decoration: BoxDecoration(
                              color: isReviewed
                                  ? Colors.green
                                  .withOpacity(0.15)
                                  : Colors.orange
                                  .withOpacity(0.15),
                              borderRadius:
                              BorderRadius.circular(10),
                            ),
                            child: Text(
                              isReviewed
                                  ? "REVIEWED"
                                  : "NEW",
                              style: TextStyle(
                                color: isReviewed
                                    ? Colors.green
                                    : Colors.orange,
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),

                          // TYPE
                          Container(
                            padding:
                            const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4),
                            decoration: BoxDecoration(
                              color:
                              color.withOpacity(0.15),
                              borderRadius:
                              BorderRadius.circular(10),
                            ),
                            child: Text(
                              f["type"].toUpperCase(),
                              style: TextStyle(
                                color: color,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 6),

                  Text(
                    f["email"],
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 13,
                    ),
                  ),

                  const SizedBox(height: 10),

                  _ratingStars(f["rating"]),

                  const SizedBox(height: 10),

                  Text(
                    f["message"],
                    style:
                    const TextStyle(height: 1.4),
                  ),

                  const SizedBox(height: 10),

                  // ================= ACTION =================
                  Row(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        f["created_at"]
                            .toString()
                            .substring(0, 16),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      if (!isReviewed)
                        TextButton.icon(
                          onPressed: () =>
                              markAsReviewed(
                                  f["feedback_id"], i),
                          icon: const Icon(
                              Icons.check_circle_outline),
                          label: const Text(
                              "Mark as Reviewed"),
                          style: TextButton.styleFrom(
                            foregroundColor:
                            Colors.green,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
