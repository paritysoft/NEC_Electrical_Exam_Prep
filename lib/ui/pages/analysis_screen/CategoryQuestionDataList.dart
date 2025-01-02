import 'package:electrician/ui/widgets/common_widget.dart';
import 'package:electrician/util/util.dart';
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
    return Center(
        child: FutureBuilder<void>(
      future: _dataFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // Loading
        } else if (snapshot.hasError) {
          return Text("Error: ${snapshot.error}"); // Error handling
        } else {
          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _categoryQuestionData?.length ?? 0,
            itemBuilder: (context, index) {
              final data = _categoryQuestionData![index];
              return Card(
                child: ListTile(
                  title: smallLabel(context, aesDecrypt(data.category, myKey),
                      textSize: 16),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      smallLabel(
                          context, 'Correct Answer: ${data.correctCount}'),
                      smallLabel(
                          context, 'Incorrect Answer: ${data.incorrectCount}'),
                      smallLabel(
                          context, 'Unanswered: ${data.unansweredCount}'),
                    ],
                  ),
                ),
              );
            },
          );
        }
      },
    ));
  }
}
