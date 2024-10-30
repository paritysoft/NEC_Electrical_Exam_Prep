import 'package:commonquiz/util/util.dart';
import 'package:flutter/material.dart';

import '../data/model/CategoryQuestionData.dart';
import '../data/upadansonghro.dart';

class CategoryQuestionDataList extends StatefulWidget {
  CategoryQuestionDataList();

  @override
  _CategoryQuestionDataListState createState() =>
      _CategoryQuestionDataListState();
}

class _CategoryQuestionDataListState extends State<CategoryQuestionDataList> {
  //Future<List<CategoryQuestionData>>? _categoryQuestionData;
  List<CategoryQuestionData>? _categoryQuestionData;
  Future<void>? _dataFuture;

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() {
    _dataFuture = () async {
      UpadanSonghro dbHelper = UpadanSonghro();
      _categoryQuestionData = await dbHelper.getCategoryQuestionData();
      print("_categoryQuestionData  ${_categoryQuestionData}");
      setState(() {}); // Trigger a UI update to reflect the data
    }();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Category-Wise Question Data")),
        body: Center(
            child: FutureBuilder<void>(
          future: _dataFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator(); // Loading
            } else if (snapshot.hasError) {
              return Text("Error: ${snapshot.error}"); // Error handling
            } else {
              return ListView.builder(
                itemCount: _categoryQuestionData?.length ?? 0,
                itemBuilder: (context, index) {
                  final data = _categoryQuestionData![index];
                  return ListTile(
                    title: Text(aesDecrypt(data.category, myKey)),
                    subtitle: Text(
                        'Correct Answer: ${data.correctCount}, Incorrect Answer: ${data.incorrectCount}, Unanswered: ${data.unansweredCount}'),
                  );
                },
              );
            }
          },
        )));
  }
}
