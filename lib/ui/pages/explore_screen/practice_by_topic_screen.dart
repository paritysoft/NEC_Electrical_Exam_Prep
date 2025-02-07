import 'package:electrician/ui/pages/data/upadansonghro.dart';
import 'package:electrician/ui/widgets/common_widget.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../util/AppColors.dart';
import '../data/QuestionCache.dart';
import '../data/model/ElectricianQuestion.dart';
import '../quiz_page.dart';
import '../subscription/InAppPurchasePage2.dart';

class PracticeByTopic extends StatefulWidget {
  final bool isSubscribed;

  PracticeByTopic({Key? key, required this.isSubscribed});

  @override
  _PracticeByTopicState createState() => _PracticeByTopicState();
}

class _PracticeByTopicState extends State<PracticeByTopic> {
  List<String> _categories = []; // List to store categories
  bool _isLoading = true; // Loading state
  // Loading state
  bool isSubscribed = false;

  @override
  void initState() {
    super.initState();
    isSubscribed = widget.isSubscribed;
    _checkSubscriptionStatus();
    _fetchUniqueCategories(); // Fetch categories when the screen loads
  }

  Future<void> _checkSubscriptionStatus() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isSubscribed = prefs.getBool('isSubscribed') ?? false; // Default to false
      print("isSubscribed  $isSubscribed");
      //  purchasedPlan = prefs.getString('purchasedPlan') ?? ''; // Default to empty string
    });
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
      appBar: appBarCustom(context, 'Topics List'),
      body: _isLoading
          ? const Center(
          child:
          CircularProgressIndicator()) // Show loading indicator while data is being fetched
          : Container(
        color: background,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView.builder(
            itemCount: _categories.length,
            itemBuilder: (context, index) {
              return Card(
                elevation: 2, // Adds shadow to the card
                margin: EdgeInsets.symmetric(vertical: 8.0),
                shape: RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(12.0), // Rounded corners
                ),
                child: ListTile(
                  title: smallLabel(context, _categories[index]),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    // Handle on tap
                    if (!isSubscribed) {
                      Navigator.of(context)
                          .push(
                        new MaterialPageRoute(
                            builder: (_) => new InAppPurchasePage2()),
                      )
                          .then((val) =>
                      val ? _checkSubscriptionStatus() : null);
                    } else {
                      List<ElectricianQuestion>? questions =
                      QuestionCache().getQuestions();
                      if (questions != null) {
                        List<ElectricianQuestion>? filterQuestions =
                        QuestionCache().filterQuestionsByCategory(
                            questions, _categories[index]);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => QuizPage(
                                  questions: filterQuestions,
                                  category: _categories[index],
                                )));
                      }
                    }
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
