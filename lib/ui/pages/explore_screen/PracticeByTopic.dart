import 'package:commonquiz/ui/pages/data/upadansonghro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PracticeByTopic extends StatefulWidget {
  @override
  _PracticeByTopicState createState() => _PracticeByTopicState();
}

class _PracticeByTopicState extends State<PracticeByTopic> {
  List<String> _categories = []; // List to store categories
  bool _isLoading = true; // Loading state

  @override
  void initState() {
    super.initState();
    _fetchUniqueCategories(); // Fetch categories when the screen loads
  }

  Future<void> _fetchUniqueCategories() async {
    UpadanSonghro dbHelper = UpadanSonghro();
    List<String> categories = await dbHelper.getUniqueCategories();

    setState(() {
      _categories = categories; // Update categories list
      _isLoading = false; // Stop the loading indicator
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Topics List'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator()) // Show loading indicator while data is being fetched
          : ListView.builder(
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_categories[index]),
          );
        },
      ),
    );
  }
}