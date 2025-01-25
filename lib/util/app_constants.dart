import 'package:flutter/material.dart';

const app_title = "ACNP Exam Prep - Nurse MCQs";
const sizeBox16 = 16.0;
const padding20 = 20.0;
class AdaptiveFontSize {
  static double getFontSize(BuildContext context, double baseFontSize) {
    double screenWidth = MediaQuery.of(context).size.width;
    const double baseScreenWidth = 375.0; // Standard screen width
    double scaleFactor = screenWidth / baseScreenWidth;
    return (baseFontSize * scaleFactor)-2;
  }
}

const onboardT1 = "Master the ACNP Exam!";
const onboardD1 = "Practice smarter with high-quality MCQs and personalized study tools. Achieve your goals with confidence and ease!";
const onboardT2 = "Prepare with Confidence!";
const onboardD2 = "Access expert-designed ACNP MCQs and detailed explanations. Track your progress and ace the exam effortlessly!";
const onboardT3 = "Your ACNP Success Companion";
const onboardD3 = "Boost your exam readiness with targeted practice questions. Stay on track with real-time feedback and insights!";
const onboardT4 = "Track Your Progress";
const onboardD4 = "Monitor your performance, identify areas for improvement, and celebrate your achievements as you advance through each stage of the quiz.";


 const String yearly = "yearly";
 const String verifyingScope = "https://www.googleapis.com/auth/androidpublisher";
 const String weeklyPlan = "com.paritysoft.acnp_exam_prep_mcqs.weekly";
 const String monthlyPlan = "com.paritysoft.acnp_exam_prep_mcqs.monthly";
 const String yearlyPlan = "com.paritysoft.acnp_exam_prep_mcqs.yearly";
 const String inAppPurchases = "com.paritysoft.acnp_exam_prep_mcqs";

