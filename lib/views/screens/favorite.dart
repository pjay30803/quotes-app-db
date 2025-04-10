import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../helpers/database_helper.dart';
import '../../models/quote_model.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  late Future<List<QuoteModel>> _favQuotesFuture;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  void _loadFavorites() {
    _favQuotesFuture = DbHelper.dbHelper.fetchFavorites();
  }

  void _removeFromFavorites(int quoteId) async {
    await DbHelper.dbHelper.toggleFavorite(quoteId, 0);
    Get.snackbar(
      "Removed",
      "Removed from Favorites",
      backgroundColor: Colors.red,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
    );
    setState(() {
      _loadFavorites();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Favorite Quotes"),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: FutureBuilder<List<QuoteModel>>(
        future: _favQuotesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Something went wrong"));
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            List<QuoteModel> favQuotes = snapshot.data!;
            return ListView.builder(
              itemCount: favQuotes.length,
              itemBuilder: (context, index) {
                QuoteModel quote = favQuotes[index];
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  elevation: 4,
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    title: Text(
                      '"${quote.quote}"',
                      style: const TextStyle(
                        fontSize: 18,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    subtitle: Padding(
                      padding: EdgeInsets.only(top: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "- ${quote.author}",
                            style: const TextStyle(fontSize: 14),
                          ),
                          const SizedBox(height: 4),
                          Chip(
                            label: Text(
                              quote.category,
                              style: TextStyle(color: Colors.black),
                            ),
                            backgroundColor: Colors.deepPurple.shade100,
                          ),
                        ],
                      ),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.favorite, color: Colors.red),
                      onPressed: () => _removeFromFavorites(quote.id!),
                    ),
                  ),
                );
              },
            );
          } else {
            return Center(child: Text("No favorites found"));
          }
        },
      ),
    );
  }
}
