import 'package:electrician/util/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import '../../../util/AppColors.dart';
import '../../widgets/common_widget.dart';
import '../data/QuestionCache.dart';
import '../home_updated.dart';
import 'custom_onboarding_page_view_model.dart';


class OnboardingScreen extends StatefulWidget {
  static const String id = "onboarding screen";
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  List<Widget> getPages() {
    return [
      const CustomOnboardingPageViewModel(
        imageUrl: 'assets/images/onbImage1.jpg',
        modelTitle: onboardT1,
        modelDescription: onboardD1,
      ),
      const CustomOnboardingPageViewModel(
        imageUrl: 'assets/images/onbImage2.jpg',
        modelTitle: onboardT2,
        modelDescription: onboardD2,
      ),
      const CustomOnboardingPageViewModel(
        imageUrl: 'assets/images/onbImage3.jpg',
        modelTitle: onboardT3,
        modelDescription: onboardD3,
      ),
      const CustomOnboardingPageViewModel(
        imageUrl: 'assets/images/onbImage4.jpg',
        modelTitle: onboardT4,
        modelDescription: onboardD4,
      ),
    ];
  }

  @override
  void initState() {
    super.initState();
//   UpadanSonghro upadanSonghro = new UpadanSonghro();
   // upadanSonghro.getAndInsertQuestions();
   //upadanSonghro.insertDataFromJson();

  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: IntroductionScreen(
          rawPages: getPages(),
          onDone: () {
          //  SharedPreferenceHelper.setSplashVisit(true);
            loadQuestions();

            Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => QuizHomePage(),
            ));

          } ,
          done:  Container(
            padding: const EdgeInsets.fromLTRB(4, 4, 4, 4),
            decoration: BoxDecoration(
              color: Colors.amber[600],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              //Center Row contents horizontally,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                    child: smallLabel(context, 'Get Started', textSize: 14, color: Colors.grey[800]
                    )),
              ],
            ),
          ),
          showSkipButton: true,
          skip:  smallLabel(
              context, 'Skip',
              color: Colors.grey
          ),
          next:  Container(
            padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
            decoration: BoxDecoration(
              color: Colors.amber[600],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              //Center Row contents horizontally,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                    child: smallLabel(context, 'Next', color: Colors.grey[800]
                        , textSize: 14)),
              ],
            ),
          ),
          globalBackgroundColor: Colors.white,
          dotsDecorator: DotsDecorator(
            activeColor: primary,
          ),
        ),
      ),
    );
  }
}
