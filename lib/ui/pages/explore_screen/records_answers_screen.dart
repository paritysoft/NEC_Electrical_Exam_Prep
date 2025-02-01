import 'package:electrician/ui/widgets/common_widget.dart';
import 'package:electrician/util/AppColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:html_unescape/html_unescape.dart';

import '../data/QuestionCache.dart';
import '../data/model/ElectricianQuestion.dart';


class RecordsAnswersScreen extends StatelessWidget {
  final List<ElectricianQuestion> questions;

  const RecordsAnswersScreen({Key? key, required this.questions}) : super(key: key);

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: appBarCustom(context, "Check Answers"),
      body: Stack(
        children: <Widget>[
          ClipPath(
            clipper: WaveClipperTwo(),
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor
              ),
              height: 200,
            ),
          ),
          ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: questions.length+1,
            itemBuilder: _buildItem,

          )
        ],
      ),
    );
  }
  Widget _buildItem(BuildContext context, int index) {
    if(index == questions.length) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(primary),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            visualDensity: VisualDensity(vertical: 2),
          ),
          child: title15BoldColor(context, "Go Home", color: Colors.white),
          onPressed: (){
            if (Navigator.canPop(context)) {
              Navigator.of(context, rootNavigator: true).pop(context);
            }
          },
          // style: ElevatedButton.styleFrom(
          //     backgroundColor: background,
          //     padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
          //     textStyle: TextStyle(
          //         fontSize: 16,
          //         fontWeight: FontWeight.bold, color: Colors.white),),
        ),
      );
    }
    ElectricianQuestion question = questions[index];
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(HtmlUnescape().convert(question.question), style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w500,
              fontSize: 16.0
            ),),
            SizedBox(height: 5.0),
            SizedBox(height: 5.0),
            question.correctCount == 1 ? Container(): Text.rich(TextSpan(
                children: [
                  TextSpan(text: "Given Answer: ",style: TextStyle(
                      color: question.correctCount == 1 ? Colors.green : Colors.red,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold
                  ),),
                  TextSpan(text: HtmlUnescape().convert(cleanedString(question.givenAnswer).replaceAll('"', '')) , style: TextStyle(
                      color: question.correctCount == 1 ? Colors.green : Colors.red,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold
                  ),),
                  TextSpan(text: HtmlUnescape().convert(cleanedString(question.explanation).replaceAll('"', '')) , style: TextStyle(
                      color: question.correctCount == 1 ? Colors.green : Colors.red,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold
                  ),)
                ]
            ),style: TextStyle(
                fontSize: 16.0
            ),),
            SizedBox(height: 5.0),
            question.correctCount == 1 ? Container(): Text.rich(TextSpan(
              children: [
                TextSpan(text: "Correct Answer: "),
                TextSpan(text: HtmlUnescape().convert(cleanedString(question.correctAnswer).replaceAll('"', '')) , style: TextStyle(
                  fontWeight: FontWeight.w500
                ))
              ]
            ),style: TextStyle(
              fontSize: 16.0
            ),)
          ],
        ),
      ),
    );
  }
}