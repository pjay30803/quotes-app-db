import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/json_controller.dart';
import '../../helpers/database_helper.dart';
import '../../models/quote_model.dart';
import 'detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<List<QuoteModel>>? allQuotes;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    await loadQuotesFromJson(); // Make sure this populates DB only if needed
    setState(() {
      allQuotes = DbHelper.dbHelper.fetchAllQuotes();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("All Quotes"),
        centerTitle: true,
        elevation: 2,
        actions: [
          IconButton(
            onPressed: () => Get.toNamed('/fav'),
            icon: Icon(Icons.favorite_border),
          ),
          IconButton(
            onPressed: () {
              (Get.isDarkMode)
                  ? Get.changeTheme(ThemeData.light())
                  : Get.changeTheme(ThemeData.dark());
            },
            icon: Icon(Get.isDarkMode ? Icons.dark_mode : Icons.light_mode),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: FutureBuilder<List<QuoteModel>>(
          future: allQuotes,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Something went wrong"));
            } else if (snapshot.hasData) {
              final quotes = snapshot.data!;
              return ListView.builder(
                itemCount: quotes.length,
                itemBuilder: (context, index) {
                  final quote = quotes[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 4,
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 16,
                      ),
                      onTap: () async {
                        final result = await Get.to(
                          () => QuoteDetailScreen(quote: quote),
                        );
                        if (result == true) {
                          setState(() {
                            allQuotes = DbHelper.dbHelper.fetchAllQuotes();
                          });
                        }
                      },
                      title: Text(
                        quote.quote,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      subtitle: Padding(
                        padding: EdgeInsets.only(top: 4.0),
                        child: Text(
                          "- ${quote.author}",
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                      trailing: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.deepPurple.shade100,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          quote.category,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            } else {
              return const Center(child: Text("No quotes found"));
            }
          },
        ),
      ),
    );
  }
}
