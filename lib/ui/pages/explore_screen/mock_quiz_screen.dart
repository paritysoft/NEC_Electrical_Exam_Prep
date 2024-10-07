import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../data/QuestionCache.dart';
import '../data/model/ElectricianQuestion.dart';

class MockQuizScreen extends StatelessWidget {
  // Example string array
  final List<String> items = [
    'Item 1',
    'Item 2',
    'Item 3',
    'Item 4',
    'Item 5',
    'Item 6',
    'Item 7',
    'Item 8'
  ];

  @override
  Widget build(BuildContext context) {

    List<ElectricianQuestion>? questions =
    QuestionCache().getQuestions();
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Mock Quiz'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // Number of columns
              crossAxisSpacing: 8.0, // Spacing between columns
              mainAxisSpacing: 8.0, // Spacing between rows
              childAspectRatio: 3 / 2, // Aspect ratio for each grid item
            ),
            itemCount: int.parse(((questions?.length ?? 0) / 20) as String) ,
            itemBuilder: (context, index) {
              return Card(
                elevation: 4, // Shadow effect
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0), // Rounded corners
                ),
                child: Center(
                  child: Text(
                    items[index],
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}