import '../../widgets/responsive_layout.dart';
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
      if (mounted) setState(() {}); // Trigger a UI update to reflect the data
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
            return AdaptiveGrid(
              minItemWidth: 280,
              children: [
                for (final data
                    in _categoryQuestionData ?? <CategoryQuestionData>[])
                  Card(
                    margin: EdgeInsets.zero,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            aesDecrypt(data.category, myKey),
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 17,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Correct: ${data.correctCount}',
                            style: const TextStyle(color: Color(0xFF237A4D)),
                          ),
                          Text('Incorrect: ${data.incorrectCount}'),
                          Text(
                            'Unanswered: ${data.unansweredCount}',
                            style: const TextStyle(color: appMuted),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            );
          }
        },
      ),
    );
  }
}
