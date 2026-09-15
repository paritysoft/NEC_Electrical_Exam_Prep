import 'package:flutter/material.dart';

const app_title = "NEC Electrical Exam Prep 2027";
const sizeBox16 = 16.0;
const padding20 = 20.0;

class AdaptiveFontSize {
  static double getFontSize(BuildContext context, double baseFontSize) {
    // Keep text readable without multiplying it by the desktop window width.
    // Accessibility text scaling is applied by Flutter's Text widgets.
    return baseFontSize;
  }
}

const onboardT1 = "Master the NEC Electrical Exam!";
const onboardD1 =
    "Prepare smarter with expert-crafted NEC questions and personalized study tools. Pass with confidence and ease!";

const onboardT2 = "Prepare with Confidence!";
const onboardD2 =
    "Access high-quality NEC practice questions with in-depth explanations. Track your progress and power through your exam!";

const onboardT3 = "Your NEC Study Companion";
const onboardD3 =
    "Boost your exam readiness with targeted practice questions. Get real-time feedback and insights to stay on track!";

const onboardT4 = "Track Your Progress";
const onboardD4 =
    "Monitor your performance, pinpoint weak areas, and celebrate your achievements as you advance through each stage of the exam!";

const String yearly = "yearly";
const String verifyingScope =
    "https://www.googleapis.com/auth/androidpublisher";
const String weeklyPlan = "com.paritysoft.nec_electrical_exam_prep.weekly";
const String monthlyPlan = "com.paritysoft.nec_electrical_exam_prep.monthly";
const String yearlyPlan = "com.paritysoft.nec_electrical_exam_prep.yearly";
const String inAppPurchases = "com.paritysoft.nec_electrical_exam_prep";

const String androidUrl =
    "https://apps.apple.com/us/app/nec-electrical-exam-prep-2025/id6741515078";
const String iosUrl =
    "https://apps.apple.com/us/app/nec-electrical-exam-prep-2025/id6741515078";
const String webUrl =
    "https://paritysoft.blogspot.com/p/master-your-licensing-exam-with.html";

// Keep the existing NEC lifetime store product when using the shared paywall.
const String unlimitedPlan = inAppPurchases;
const bool hasFreeTrial = false;
const int freeTrialDays = 0;
