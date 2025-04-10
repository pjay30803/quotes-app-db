import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../helpers/database_helper.dart';
import '../../models/quote_model.dart';

class QuoteDetailScreen extends StatelessWidget {
  final QuoteModel quote;

  const QuoteDetailScreen({super.key, required this.quote});

  @override
  Widget build(BuildContext context) {
    final isFavorite = quote.isFavorite == 1;

    return Scaffold(
      appBar: AppBar(
        title: Text("Quote Details"),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Center(
              child: Text(
                '"${quote.quote}"',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  fontStyle: FontStyle.italic,
                  height: 1.5,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                "- ${quote.author}",
                style: TextStyle(
                  fontSize: 18,
                  fontStyle: FontStyle.italic,
                  color: Colors.grey,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Chip(
              label: Text(
                quote.category,
                style: TextStyle(color: Colors.black),
              ),

              backgroundColor: Colors.deepPurple.shade100,
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade400,
                  ),
                  onPressed: () async {
                    await DbHelper.dbHelper.deleteQuote(quote.id!);
                    Get.back(result: true); // Notify previous screen
                    Get.snackbar(
                      "Deleted",
                      "Quote has been deleted.",
                      backgroundColor: Colors.red,
                      colorText: Colors.white,
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  },
                  icon: const Icon(Icons.delete),
                  label: const Text("Delete"),
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isFavorite ? Colors.orange : Colors.green,
                  ),
                  onPressed: () async {
                    int newValue = isFavorite ? 0 : 1;
                    await DbHelper.dbHelper.toggleFavorite(quote.id!, newValue);
                    Get.back(result: true); // Notify previous screen
                    Get.snackbar(
                      "SUCCESS",
                      isFavorite
                          ? "Removed from Favorites"
                          : "Added to Favorites",
                      colorText: Colors.white,
                      backgroundColor: Colors.green,
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  },
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                  ),
                  label: Text(isFavorite ? "Unfavorite" : "Favorite"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
