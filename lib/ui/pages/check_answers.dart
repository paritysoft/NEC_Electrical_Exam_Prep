import 'package:electrician/ui/widgets/common_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:html_unescape/html_unescape.dart';

import '../../models/question.dart';
import 'data/QuestionCache.dart';
import 'data/model/ElectricianQuestion.dart';

class CheckAnswersPage extends StatelessWidget {
  final List<ElectricianQuestion> questions;
  final Map<int,dynamic> answers;

  const CheckAnswersPage({Key? key, required this.questions, required this.answers}) : super(key: key);

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
      return ElevatedButton(
        child: Text("Done"),
        onPressed: (){
          Navigator.of(context).popUntil(ModalRoute.withName(Navigator.defaultRouteName));
        },
      );
    }
    ElectricianQuestion question = questions[index];
    bool correct = cleanedString(question.correctAnswer).replaceAll('"', '') == answers[index];
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
            Text(HtmlUnescape().convert("${answers[index]}"), style: TextStyle(
              color: correct ? Colors.green : Colors.red,
              fontSize: 18.0,
              fontWeight: FontWeight.bold
            ),),
            SizedBox(height: 5.0),
            correct ? Container(): Text.rich(TextSpan(
              children: [
                TextSpan(text: "Answer: "),
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