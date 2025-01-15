import 'package:encrypt/encrypt.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../subscription/core/sharepref_helper.dart';

String aesDecrypt(String encryptedText, String key) {
  // Check if the input is null or empty
  if (encryptedText == null || encryptedText.isEmpty) {
    return ''; // Return a default value or message
  }

  try {
    final keyBytes =
        Key.fromUtf8(key); // Ensure your key length matches AES requirements
    final iv = IV.fromLength(
        16); // ECB mode doesn't require IV, but you can set a dummy one
    final encrypter =
        Encrypter(AES(keyBytes, mode: AESMode.ecb, padding: 'PKCS7'));

    // Perform decryption
    final decrypted = encrypter.decrypt64(encryptedText, iv: iv);
    return decrypted;
  } catch (e) {
    return ''; // Handle decryption failure
  }
}

// AES Encryption function
String encryptAES(String plainText, String key) {
  // Check if the input plainText is null or empty
  if (plainText == null || plainText.isEmpty) {
    return ''; // Return a default value or error message
  }

  // Check if the key is null, empty, or invalid
  if (key == null || key.isEmpty || key.length != 16) {
    return ''; // Check for a valid key
  }

  try {
    // Convert the key and plain text to bytes
    final keyBytes =
        Key.fromUtf8(key); // Ensure key length matches AES requirements
    final iv = IV.fromLength(
        16); // Initialization Vector with fixed length (ECB doesn't need it)

    // Use AES algorithm with ECB mode and PKCS7 padding
    final encrypter =
        Encrypter(AES(keyBytes, mode: AESMode.ecb, padding: 'PKCS7'));

    // Encrypt the plain text
    final encrypted = encrypter.encrypt(plainText, iv: iv);
    return encrypted.base64; // Return encrypted text as Base64
  } catch (e) {
    return ''; // Handle encryption failure
  }
}

String getExamDate() {
  String currentDate =
      SharedPreferenceHelper.getExamDate()?.split('T').first ?? "01/01/2026";
  return currentDate;
}

String yourDBKey = dotenv.env["YOUR_DB_KEY"]!;
String your_db_pass = dotenv.env["YOUR_DB_PASS_KEY"]!;

List<Map<String, dynamic>> quizzesJsonList = [
  {
    "uuid": "q1",
    "question":
        "Which of the following is the most common cause of community-acquired pneumonia in adults?",
    "explanation":
        "Streptococcus pneumoniae is the most common bacterial pathogen responsible for community-acquired pneumonia in adults.",
    "incorrect_answer": [
      "Klebsiella pneumoniae",
      "Mycoplasma pneumoniae",
      "Legionella pneumophila"
    ],
    "correct_answer": ["Streptococcus pneumoniae"],
    "topic_name": "Pulmonary Medicine",
    "category": "Respiratory Infections",
    "level": 1,
    "status": 1,
    "exam_title": "Acute Care NP Exam Prep 2024"
  },
  {
    "uuid": "q2",
    "question":
        "A 65-year-old male with a history of COPD presents with acute worsening of dyspnea, increased sputum production, and purulence. What is the most appropriate first-line antibiotic therapy?",
    "explanation":
        "Amoxicillin-clavulanate is effective against common bacterial pathogens responsible for COPD exacerbations, including H. influenzae and M. catarrhalis.",
    "incorrect_answer": [
      "Azithromycin",
      "Levofloxacin",
      "Trimethoprim-sulfamethoxazole"
    ],
    "correct_answer": ["Amoxicillin-clavulanate"],
    "topic_name": "Pulmonary Medicine",
    "category": "COPD Management",
    "level": 2,
    "status": 1,
    "exam_title": "Acute Care NP Exam Prep 2024"
  },
  {
    "uuid": "q3",
    "question":
        "What is the primary diagnostic test used to confirm the presence of pulmonary embolism (PE)?",
    "explanation":
        "CT pulmonary angiography is the gold standard imaging modality for diagnosing pulmonary embolism.",
    "incorrect_answer": [
      "Ventilation-perfusion (V/Q) scan",
      "Chest X-ray",
      "D-dimer blood test"
    ],
    "correct_answer": ["CT pulmonary angiography"],
    "topic_name": "Pulmonary Medicine",
    "category": "Pulmonary Embolism",
    "level": 2,
    "status": 1,
    "exam_title": "Acute Care NP Exam Prep 2024"
  },
  {
    "uuid": "q4",
    "question":
        "A 50-year-old female presents with a 3-week history of chronic dry cough and dyspnea. A chest CT reveals bilateral hilar lymphadenopathy. What is the most likely diagnosis?",
    "explanation":
        "Sarcoidosis often presents with bilateral hilar lymphadenopathy and systemic symptoms such as dry cough and dyspnea.",
    "incorrect_answer": ["Tuberculosis", "Lung cancer", "Pulmonary fibrosis"],
    "correct_answer": ["Sarcoidosis"],
    "topic_name": "Pulmonary Medicine",
    "category": "Interstitial Lung Diseases",
    "level": 2,
    "status": 1,
    "exam_title": "Acute Care NP Exam Prep 2024"
  },
  {
    "uuid": "q5",
    "question":
        "What is the preferred initial treatment for acute asthma exacerbation in the emergency department?",
    "explanation":
        "Nebulized short-acting beta-agonists (e.g., albuterol) are the first-line treatment for acute asthma exacerbations.",
    "incorrect_answer": [
      "Inhaled corticosteroids",
      "Leukotriene receptor antagonists",
      "Long-acting beta-agonists"
    ],
    "correct_answer": ["Nebulized short-acting beta-agonists"],
    "topic_name": "Pulmonary Medicine",
    "category": "Asthma Management",
    "level": 1,
    "status": 1,
    "exam_title": "Acute Care NP Exam Prep 2024"
  },
  {
    "uuid": "q6",
    "question":
        "Which of the following is the most common cause of transudative pleural effusion?",
    "explanation":
        "Congestive heart failure is the most common cause of transudative pleural effusion, characterized by low protein content.",
    "incorrect_answer": ["Pneumonia", "Pulmonary embolism", "Malignancy"],
    "correct_answer": ["Congestive heart failure"],
    "topic_name": "Pulmonary Medicine",
    "category": "Pleural Diseases",
    "level": 1,
    "status": 1,
    "exam_title": "Acute Care NP Exam Prep 2024"
  },
  {
    "uuid": "q7",
    "question":
        "A 72-year-old male with a 40-pack-year smoking history presents with hemoptysis and unintentional weight loss. A chest CT reveals a centrally located lung mass. What is the most likely diagnosis?",
    "explanation":
        "Small cell lung cancer often presents as a centrally located mass and is associated with smoking history.",
    "incorrect_answer": [
      "Adenocarcinoma",
      "Large cell carcinoma",
      "Mesothelioma"
    ],
    "correct_answer": ["Small cell lung cancer"],
    "topic_name": "Pulmonary Medicine",
    "category": "Oncology",
    "level": 3,
    "status": 1,
    "exam_title": "Acute Care NP Exam Prep 2024"
  },
  {
    "uuid": "q8",
    "question":
        "Which of the following is a classic finding on chest X-ray for a patient with pneumothorax?",
    "explanation":
        "A pneumothorax is characterized by the presence of a visible pleural line and absence of lung markings beyond it.",
    "incorrect_answer": [
      "Consolidation",
      "Bilateral hilar lymphadenopathy",
      "Ground-glass opacities"
    ],
    "correct_answer": ["Visible pleural line and absent lung markings"],
    "topic_name": "Pulmonary Medicine",
    "category": "Pleural Diseases",
    "level": 1,
    "status": 1,
    "exam_title": "Acute Care NP Exam Prep 2024"
  },
  {
    "uuid": "q9",
    "question":
        "What is the hallmark clinical finding in obstructive sleep apnea?",
    "explanation":
        "Daytime somnolence and loud snoring with witnessed apneas are hallmark findings in obstructive sleep apnea.",
    "incorrect_answer": ["Hemoptysis", "Chronic cough", "Wheezing"],
    "correct_answer": ["Daytime somnolence and loud snoring"],
    "topic_name": "Pulmonary Medicine",
    "category": "Sleep Disorders",
    "level": 1,
    "status": 1,
    "exam_title": "Acute Care NP Exam Prep 2024"
  },
  {
    "uuid": "q10",
    "question":
        "Which of the following is the most common cause of ARDS (Acute Respiratory Distress Syndrome)?",
    "explanation":
        "Sepsis is the leading cause of ARDS, accounting for a significant proportion of cases.",
    "incorrect_answer": ["Aspiration pneumonia", "Trauma", "Near-drowning"],
    "correct_answer": ["Sepsis"],
    "topic_name": "Pulmonary Medicine",
    "category": "Critical Care",
    "level": 2,
    "status": 1,
    "exam_title": "Acute Care NP Exam Prep 2024"
  },
  {
    "uuid": "q101",
    "question":
        "What is the initial imaging study of choice for a patient suspected of having a pneumothorax?",
    "explanation":
        "A chest X-ray is the first-line imaging study to confirm the presence of a pneumothorax.",
    "incorrect_answer": [
      "CT scan of the chest",
      "Ventilation-perfusion (V/Q) scan",
      "Pulmonary angiography"
    ],
    "correct_answer": ["Chest X-ray"],
    "topic_name": "Pulmonary Medicine",
    "category": "Pleural Diseases",
    "level": 1,
    "status": 1,
    "exam_title": "Acute Care NP Exam Prep 2024"
  },
  {
    "uuid": "q102",
    "question":
        "A 55-year-old male with a history of long-term corticosteroid use presents with dyspnea and bilateral infiltrates on a chest X-ray. Which condition should be suspected?",
    "explanation":
        "Prolonged corticosteroid use is associated with an increased risk of pneumocystis pneumonia (PCP), particularly in immunocompromised patients.",
    "incorrect_answer": [
      "Pulmonary embolism",
      "Pulmonary fibrosis",
      "Tuberculosis"
    ],
    "correct_answer": ["Pneumocystis pneumonia (PCP)"],
    "topic_name": "Pulmonary Medicine",
    "category": "Infections",
    "level": 2,
    "status": 1,
    "exam_title": "Acute Care NP Exam Prep 2024"
  },
  {
    "uuid": "q103",
    "question":
        "What is the most common cause of acute hypoxemia in hospitalized patients?",
    "explanation":
        "Atelectasis is the most common cause of acute hypoxemia in hospitalized patients, often caused by hypoventilation or obstruction.",
    "incorrect_answer": [
      "Pulmonary embolism",
      "Pneumonia",
      "Acute respiratory distress syndrome (ARDS)"
    ],
    "correct_answer": ["Atelectasis"],
    "topic_name": "Pulmonary Medicine",
    "category": "Respiratory Pathophysiology",
    "level": 2,
    "status": 1,
    "exam_title": "Acute Care NP Exam Prep 2024"
  },
  {
    "uuid": "q104",
    "question":
        "Which of the following is a hallmark finding in a patient with pulmonary fibrosis?",
    "explanation":
        "Pulmonary fibrosis is associated with restrictive lung disease, characterized by reduced lung volumes and impaired gas exchange.",
    "incorrect_answer": [
      "Wheezing",
      "Obstructive spirometry pattern",
      "Decreased residual volume"
    ],
    "correct_answer": ["Reduced total lung capacity (TLC)"],
    "topic_name": "Pulmonary Medicine",
    "category": "Interstitial Lung Diseases",
    "level": 2,
    "status": 1,
    "exam_title": "Acute Care NP Exam Prep 2024"
  },
  {
    "uuid": "q105",
    "question":
        "What is the preferred treatment for a patient with latent tuberculosis infection (LTBI)?",
    "explanation":
        "Isoniazid for 9 months is the recommended treatment to prevent progression to active tuberculosis.",
    "incorrect_answer": [
      "Rifampin for 4 months",
      "Pyrazinamide for 2 months",
      "Ethambutol for 6 months"
    ],
    "correct_answer": ["Isoniazid for 9 months"],
    "topic_name": "Pulmonary Medicine",
    "category": "Infectious Diseases",
    "level": 1,
    "status": 1,
    "exam_title": "Acute Care NP Exam Prep 2024"
  },
  {
    "uuid": "q106",
    "question":
        "Which diagnostic test is used to confirm obstructive sleep apnea?",
    "explanation":
        "Polysomnography (sleep study) is the gold standard for diagnosing obstructive sleep apnea.",
    "incorrect_answer": [
      "Chest X-ray",
      "Arterial blood gas analysis",
      "Pulmonary function tests"
    ],
    "correct_answer": ["Polysomnography"],
    "topic_name": "Pulmonary Medicine",
    "category": "Sleep Disorders",
    "level": 1,
    "status": 1,
    "exam_title": "Acute Care NP Exam Prep 2024"
  },
  {
    "uuid": "q107",
    "question":
        "Which of the following is the most specific symptom of pulmonary embolism?",
    "explanation":
        "Hemoptysis, while rare, is a specific symptom of pulmonary embolism and is typically associated with pulmonary infarction.",
    "incorrect_answer": ["Dyspnea", "Tachycardia", "Pleuritic chest pain"],
    "correct_answer": ["Hemoptysis"],
    "topic_name": "Pulmonary Medicine",
    "category": "Pulmonary Embolism",
    "level": 2,
    "status": 1,
    "exam_title": "Acute Care NP Exam Prep 2024"
  },
  {
    "uuid": "q108",
    "question": "What is the most common cause of chronic cough in nonsmokers?",
    "explanation":
        "Postnasal drip syndrome is the leading cause of chronic cough in nonsmokers.",
    "incorrect_answer": [
      "Gastroesophageal reflux disease (GERD)",
      "Asthma",
      "Chronic bronchitis"
    ],
    "correct_answer": ["Postnasal drip syndrome"],
    "topic_name": "Pulmonary Medicine",
    "category": "Chronic Cough",
    "level": 1,
    "status": 1,
    "exam_title": "Acute Care NP Exam Prep 2024"
  },
  {
    "uuid": "q109",
    "question":
        "Which organism is most commonly associated with pneumonia in patients with cystic fibrosis?",
    "explanation":
        "Pseudomonas aeruginosa is the most common pathogen in pneumonia associated with cystic fibrosis.",
    "incorrect_answer": [
      "Streptococcus pneumoniae",
      "Mycoplasma pneumoniae",
      "Klebsiella pneumoniae"
    ],
    "correct_answer": ["Pseudomonas aeruginosa"],
    "topic_name": "Pulmonary Medicine",
    "category": "Respiratory Infections",
    "level": 2,
    "status": 1,
    "exam_title": "Acute Care NP Exam Prep 2024"
  },
  {
    "uuid": "q110",
    "question": "What is the primary treatment for tension pneumothorax?",
    "explanation":
        "Immediate needle decompression in the second intercostal space at the midclavicular line is the life-saving treatment for tension pneumothorax.",
    "incorrect_answer": [
      "Supplemental oxygen",
      "Chest tube placement",
      "Observation and serial imaging"
    ],
    "correct_answer": ["Needle decompression"],
    "topic_name": "Pulmonary Medicine",
    "category": "Critical Care",
    "level": 2,
    "status": 1,
    "exam_title": "Acute Care NP Exam Prep 2024"
  },
  {
    "uuid": "q111",
    "question":
        "What is the hallmark physical examination finding in a patient with pleural effusion?",
    "explanation":
        "Dullness to percussion and decreased breath sounds are classic findings associated with pleural effusion.",
    "incorrect_answer": [
      "Hyperresonance to percussion",
      "Bronchial breath sounds",
      "Stridor"
    ],
    "correct_answer": ["Dullness to percussion and decreased breath sounds"],
    "topic_name": "Pulmonary Medicine",
    "category": "Pleural Diseases",
    "level": 1,
    "status": 1,
    "exam_title": "Acute Care NP Exam Prep 2024"
  },
  {
    "uuid": "q112",
    "question":
        "A 40-year-old male presents with hemoptysis, weight loss, and a cavitary lesion in the upper lobe on chest imaging. What is the most likely diagnosis?",
    "explanation":
        "Tuberculosis commonly presents with hemoptysis, weight loss, and cavitary lesions in the upper lobes on imaging.",
    "incorrect_answer": ["Pulmonary embolism", "Lung abscess", "Sarcoidosis"],
    "correct_answer": ["Tuberculosis"],
    "topic_name": "Pulmonary Medicine",
    "category": "Respiratory Infections",
    "level": 2,
    "status": 1,
    "exam_title": "Acute Care NP Exam Prep 2024"
  },
  {
    "uuid": "q113",
    "question":
        "What is the most common pulmonary complication of systemic lupus erythematosus (SLE)?",
    "explanation":
        "Pleuritis is the most common pulmonary complication of SLE and often presents with pleuritic chest pain.",
    "incorrect_answer": [
      "Pulmonary hypertension",
      "Pulmonary embolism",
      "Diffuse alveolar hemorrhage"
    ],
    "correct_answer": ["Pleuritis"],
    "topic_name": "Pulmonary Medicine",
    "category": "Autoimmune Disorders",
    "level": 2,
    "status": 1,
    "exam_title": "Acute Care NP Exam Prep 2024"
  },
  {
    "uuid": "q114",
    "question":
        "A 35-year-old female presents with progressive dyspnea and a nonproductive cough. Chest X-ray reveals a honeycombing pattern. What is the most likely diagnosis?",
    "explanation":
        "Idiopathic pulmonary fibrosis is characterized by a honeycombing pattern on imaging, reflecting end-stage lung disease.",
    "incorrect_answer": [
      "Sarcoidosis",
      "Pulmonary embolism",
      "Chronic obstructive pulmonary disease (COPD)"
    ],
    "correct_answer": ["Idiopathic pulmonary fibrosis"],
    "topic_name": "Pulmonary Medicine",
    "category": "Interstitial Lung Diseases",
    "level": 3,
    "status": 1,
    "exam_title": "Acute Care NP Exam Prep 2024"
  },
  {
    "uuid": "q115",
    "question":
        "What is the most appropriate treatment for exercise-induced asthma?",
    "explanation":
        "Short-acting beta-agonists (SABAs) like albuterol are effective in preventing and treating exercise-induced bronchospasm.",
    "incorrect_answer": [
      "Inhaled corticosteroids",
      "Leukotriene receptor antagonists",
      "Long-acting beta-agonists"
    ],
    "correct_answer": ["Short-acting beta-agonists"],
    "topic_name": "Pulmonary Medicine",
    "category": "Asthma Management",
    "level": 1,
    "status": 1,
    "exam_title": "Acute Care NP Exam Prep 2024"
  },
  {
    "uuid": "q116",
    "question":
        "Which of the following is a contraindication to noninvasive positive pressure ventilation (NIPPV)?",
    "explanation":
        "Altered mental status is a contraindication to NIPPV because it increases the risk of aspiration and inadequate airway protection.",
    "incorrect_answer": [
      "Hypoxemic respiratory failure",
      "Mild hypercapnia",
      "Obstructive sleep apnea"
    ],
    "correct_answer": ["Altered mental status"],
    "topic_name": "Pulmonary Medicine",
    "category": "Ventilator Management",
    "level": 2,
    "status": 1,
    "exam_title": "Acute Care NP Exam Prep 2024"
  },
  {
    "uuid": "q117",
    "question":
        "A 55-year-old patient presents with chronic dyspnea and bilateral fine inspiratory crackles. Which diagnostic test is most useful to confirm interstitial lung disease?",
    "explanation":
        "High-resolution computed tomography (HRCT) is the most sensitive imaging modality for diagnosing interstitial lung disease.",
    "incorrect_answer": [
      "Chest X-ray",
      "Pulmonary function tests",
      "Arterial blood gas analysis"
    ],
    "correct_answer": ["High-resolution computed tomography (HRCT)"],
    "topic_name": "Pulmonary Medicine",
    "category": "Interstitial Lung Diseases",
    "level": 2,
    "status": 1,
    "exam_title": "Acute Care NP Exam Prep 2024"
  },
  {
    "uuid": "q118",
    "question":
        "What is the most common occupational lung disease in the United States?",
    "explanation":
        "Silicosis is the most common occupational lung disease in the U.S., associated with inhalation of crystalline silica dust.",
    "incorrect_answer": [
      "Asbestosis",
      "Coal workers' pneumoconiosis",
      "Berylliosis"
    ],
    "correct_answer": ["Silicosis"],
    "topic_name": "Pulmonary Medicine",
    "category": "Occupational Lung Diseases",
    "level": 2,
    "status": 1,
    "exam_title": "Acute Care NP Exam Prep 2024"
  },
  {
    "uuid": "q119",
    "question":
        "Which of the following conditions is associated with a decrease in DLCO (diffusing capacity for carbon monoxide)?",
    "explanation":
        "Emphysema, due to alveolar destruction, reduces the surface area available for gas exchange, leading to a decreased DLCO.",
    "incorrect_answer": ["Asthma", "Chronic bronchitis", "Pulmonary edema"],
    "correct_answer": ["Emphysema"],
    "topic_name": "Pulmonary Medicine",
    "category": "Pulmonary Function Tests",
    "level": 2,
    "status": 1,
    "exam_title": "Acute Care NP Exam Prep 2024"
  },
  {
    "uuid": "q120",
    "question":
        "What is the gold standard test for diagnosing pulmonary hypertension?",
    "explanation":
        "Right heart catheterization directly measures pulmonary artery pressure and is the gold standard for diagnosing pulmonary hypertension.",
    "incorrect_answer": [
      "Echocardiography",
      "Chest CT scan",
      "Pulmonary function tests"
    ],
    "correct_answer": ["Right heart catheterization"],
    "topic_name": "Pulmonary Medicine",
    "category": "Pulmonary Hypertension",
    "level": 3,
    "status": 1,
    "exam_title": "Acute Care NP Exam Prep 2024"
  },
  {
    "uuid": "q121",
    "question":
        "Which of the following findings on pulmonary function tests is characteristic of restrictive lung disease?",
    "explanation":
        "Restrictive lung diseases are characterized by a decreased total lung capacity (TLC) and preserved or increased FEV1/FVC ratio.",
    "incorrect_answer": [
      "Decreased FEV1/FVC ratio",
      "Increased residual volume (RV)",
      "Increased total lung capacity (TLC)"
    ],
    "correct_answer": [
      "Decreased total lung capacity (TLC) with preserved FEV1/FVC ratio"
    ],
    "topic_name": "Pulmonary Medicine",
    "category": "Pulmonary Function Tests",
    "level": 2,
    "status": 1,
    "exam_title": "Acute Care NP Exam Prep 2024"
  },
  {
    "uuid": "q122",
    "question":
        "A 45-year-old male presents with acute dyspnea after a motor vehicle accident. Chest X-ray reveals multiple rib fractures and subcutaneous emphysema. What is the most likely diagnosis?",
    "explanation":
        "Pneumothorax is commonly associated with rib fractures and subcutaneous emphysema following trauma.",
    "incorrect_answer": ["Hemothorax", "Flail chest", "Diaphragmatic rupture"],
    "correct_answer": ["Pneumothorax"],
    "topic_name": "Pulmonary Medicine",
    "category": "Trauma and Critical Care",
    "level": 2,
    "status": 1,
    "exam_title": "Acute Care NP Exam Prep 2024"
  },
  {
    "uuid": "q123",
    "question":
        "What is the recommended duration of anticoagulation therapy for a patient with a first unprovoked pulmonary embolism?",
    "explanation":
        "For a first unprovoked pulmonary embolism, anticoagulation is recommended for at least 3 months, with consideration for extended therapy based on bleeding risk.",
    "incorrect_answer": ["1 month", "6 weeks", "6 months"],
    "correct_answer": ["At least 3 months"],
    "topic_name": "Pulmonary Medicine",
    "category": "Pulmonary Embolism",
    "level": 2,
    "status": 1,
    "exam_title": "Acute Care NP Exam Prep 2024"
  },
  {
    "uuid": "q124",
    "question":
        "Which of the following is the best initial test to confirm the diagnosis of obstructive sleep apnea?",
    "explanation":
        "Polysomnography is the gold standard diagnostic test for obstructive sleep apnea, measuring apneas and hypopneas during sleep.",
    "incorrect_answer": [
      "Chest X-ray",
      "Arterial blood gas",
      "Echocardiography"
    ],
    "correct_answer": ["Polysomnography"],
    "topic_name": "Pulmonary Medicine",
    "category": "Sleep Disorders",
    "level": 2,
    "status": 1,
    "exam_title": "Acute Care NP Exam Prep 2024"
  },
  {
    "uuid": "q125",
    "question":
        "A 70-year-old patient with a history of COPD is hospitalized for acute respiratory failure. Which of the following arterial blood gas findings is most consistent with this condition?",
    "explanation":
        "In COPD exacerbation with respiratory failure, arterial blood gas typically shows respiratory acidosis with elevated PaCO2 and a compensatory rise in bicarbonate.",
    "incorrect_answer": [
      "Respiratory alkalosis with low PaCO2",
      "Normal PaCO2 and normal pH",
      "Metabolic acidosis with low bicarbonate"
    ],
    "correct_answer": ["Respiratory acidosis with elevated PaCO2"],
    "topic_name": "Pulmonary Medicine",
    "category": "COPD Management",
    "level": 3,
    "status": 1,
    "exam_title": "Acute Care NP Exam Prep 2024"
  },
  {
    "uuid": "q126",
    "question": "What is the most common cause of chronic cough in nonsmokers?",
    "explanation":
        "Postnasal drip syndrome is the leading cause of chronic cough in nonsmokers, often caused by allergic or nonallergic rhinitis.",
    "incorrect_answer": [
      "Gastroesophageal reflux disease (GERD)",
      "Asthma",
      "Chronic bronchitis"
    ],
    "correct_answer": ["Postnasal drip syndrome"],
    "topic_name": "Pulmonary Medicine",
    "category": "Respiratory Symptoms",
    "level": 1,
    "status": 1,
    "exam_title": "Acute Care NP Exam Prep 2024"
  },
  {
    "uuid": "q127",
    "question":
        "Which pathogen is most commonly associated with ventilator-associated pneumonia (VAP)?",
    "explanation":
        "Pseudomonas aeruginosa is a common pathogen associated with ventilator-associated pneumonia, especially in ICU settings.",
    "incorrect_answer": [
      "Staphylococcus epidermidis",
      "Legionella pneumophila",
      "Streptococcus pneumoniae"
    ],
    "correct_answer": ["Pseudomonas aeruginosa"],
    "topic_name": "Pulmonary Medicine",
    "category": "Respiratory Infections",
    "level": 3,
    "status": 1,
    "exam_title": "Acute Care NP Exam Prep 2024"
  },
  {
    "uuid": "q128",
    "question":
        "A 60-year-old male presents with progressive dyspnea and fatigue. Pulmonary artery pressure is elevated on echocardiography. What is the next step to confirm the diagnosis of pulmonary hypertension?",
    "explanation":
        "Right heart catheterization is required to confirm the diagnosis of pulmonary hypertension by directly measuring pulmonary artery pressure.",
    "incorrect_answer": [
      "CT pulmonary angiography",
      "Pulmonary function testing",
      "D-dimer testing"
    ],
    "correct_answer": ["Right heart catheterization"],
    "topic_name": "Pulmonary Medicine",
    "category": "Pulmonary Hypertension",
    "level": 2,
    "status": 1,
    "exam_title": "Acute Care NP Exam Prep 2024"
  },
  {
    "uuid": "q129",
    "question":
        "Which of the following is the most appropriate initial treatment for moderate to severe croup in children?",
    "explanation":
        "Nebulized epinephrine is effective in reducing airway swelling and improving symptoms in moderate to severe croup.",
    "incorrect_answer": [
      "Inhaled corticosteroids",
      "Intravenous antibiotics",
      "Chest physiotherapy"
    ],
    "correct_answer": ["Nebulized epinephrine"],
    "topic_name": "Pulmonary Medicine",
    "category": "Pediatric Respiratory Disorders",
    "level": 2,
    "status": 1,
    "exam_title": "Acute Care NP Exam Prep 2024"
  },
  {
    "uuid": "q130",
    "question":
        "What is the most likely etiology of hypoxemia in a patient with pneumonia?",
    "explanation":
        "Ventilation-perfusion (V/Q) mismatch occurs in pneumonia due to alveolar consolidation, leading to impaired oxygen exchange.",
    "incorrect_answer": ["Shunt", "Hypoventilation", "Diffusion impairment"],
    "correct_answer": ["Ventilation-perfusion (V/Q) mismatch"],
    "topic_name": "Pulmonary Medicine",
    "category": "Respiratory Physiology",
    "level": 2,
    "status": 1,
    "exam_title": "Acute Care NP Exam Prep 2024"
  },
  {
    "uuid": "q131",
    "question":
        "Which condition is characterized by noncaseating granulomas in the lungs and other organs?",
    "explanation":
        "Sarcoidosis is a systemic inflammatory disease characterized by noncaseating granulomas, most commonly affecting the lungs.",
    "incorrect_answer": ["Tuberculosis", "Lung cancer", "Asbestosis"],
    "correct_answer": ["Sarcoidosis"],
    "topic_name": "Pulmonary Medicine",
    "category": "Interstitial Lung Diseases",
    "level": 2,
    "status": 1,
    "exam_title": "Acute Care NP Exam Prep 2024"
  },
  {
    "uuid": "q132",
    "question": "What is the most common cause of bronchiolitis in infants?",
    "explanation":
        "Respiratory syncytial virus (RSV) is the leading cause of bronchiolitis in children under 2 years old.",
    "incorrect_answer": [
      "Parainfluenza virus",
      "Adenovirus",
      "Influenza virus"
    ],
    "correct_answer": ["Respiratory syncytial virus (RSV)"],
    "topic_name": "Pulmonary Medicine",
    "category": "Pediatric Respiratory Disorders",
    "level": 1,
    "status": 1,
    "exam_title": "Acute Care NP Exam Prep 2024"
  },
  {
    "uuid": "q133",
    "question":
        "Which type of lung cancer is most strongly associated with smoking?",
    "explanation":
        "Small cell lung cancer (SCLC) is strongly linked to smoking and is aggressive, often presenting with metastases at diagnosis.",
    "incorrect_answer": [
      "Adenocarcinoma",
      "Large cell carcinoma",
      "Mesothelioma"
    ],
    "correct_answer": ["Small cell lung cancer (SCLC)"],
    "topic_name": "Pulmonary Medicine",
    "category": "Oncology",
    "level": 3,
    "status": 1,
    "exam_title": "Acute Care NP Exam Prep 2024"
  },
  {
    "uuid": "q134",
    "question":
        "What is the most effective intervention to prevent ventilator-associated pneumonia (VAP)?",
    "explanation":
        "Elevation of the head of the bed reduces the risk of aspiration, a key factor in preventing VAP.",
    "incorrect_answer": [
      "Routine chest physiotherapy",
      "Frequent suctioning",
      "Daily chest X-rays"
    ],
    "correct_answer": ["Elevation of the head of the bed"],
    "topic_name": "Pulmonary Medicine",
    "category": "Critical Care",
    "level": 2,
    "status": 1,
    "exam_title": "Acute Care NP Exam Prep 2024"
  },
  {
    "uuid": "q135",
    "question":
        "Which pulmonary function test result is characteristic of obstructive lung disease?",
    "explanation":
        "A decreased FEV1/FVC ratio is the hallmark finding in obstructive lung diseases such as asthma and COPD.",
    "incorrect_answer": [
      "Decreased total lung capacity (TLC)",
      "Increased FEV1/FVC ratio",
      "Decreased residual volume (RV)"
    ],
    "correct_answer": ["Decreased FEV1/FVC ratio"],
    "topic_name": "Pulmonary Medicine",
    "category": "Pulmonary Function Tests",
    "level": 2,
    "status": 1,
    "exam_title": "Acute Care NP Exam Prep 2024"
  },
  {
    "uuid": "q136",
    "question":
        "Which of the following is the best diagnostic test for tuberculosis in a patient with suspected active disease?",
    "explanation":
        "Sputum acid-fast bacilli (AFB) smear and culture remain the gold standard for diagnosing active tuberculosis.",
    "incorrect_answer": [
      "Tuberculin skin test",
      "Interferon-gamma release assay (IGRA)",
      "Chest X-ray"
    ],
    "correct_answer": ["Sputum acid-fast bacilli (AFB) smear and culture"],
    "topic_name": "Pulmonary Medicine",
    "category": "Respiratory Infections",
    "level": 2,
    "status": 1,
    "exam_title": "Acute Care NP Exam Prep 2024"
  },
  {
    "uuid": "q137",
    "question":
        "Which of the following is the primary mechanism of hypoxemia in acute respiratory distress syndrome (ARDS)?",
    "explanation":
        "Shunting occurs in ARDS as blood flows through non-ventilated alveoli, leading to hypoxemia.",
    "incorrect_answer": [
      "Hypoventilation",
      "Ventilation-perfusion (V/Q) mismatch",
      "Diffusion impairment"
    ],
    "correct_answer": ["Shunting"],
    "topic_name": "Pulmonary Medicine",
    "category": "Critical Care",
    "level": 2,
    "status": 1,
    "exam_title": "Acute Care NP Exam Prep 2024"
  },
  {
    "uuid": "q138",
    "question":
        "Which of the following is the preferred treatment for idiopathic pulmonary fibrosis?",
    "explanation":
        "Antifibrotic agents such as nintedanib slow the progression of idiopathic pulmonary fibrosis.",
    "incorrect_answer": [
      "Systemic corticosteroids",
      "Inhaled bronchodilators",
      "Antibiotics"
    ],
    "correct_answer": ["Antifibrotic agents such as nintedanib"],
    "topic_name": "Pulmonary Medicine",
    "category": "Interstitial Lung Diseases",
    "level": 3,
    "status": 1,
    "exam_title": "Acute Care NP Exam Prep 2024"
  },
  {
    "uuid": "q139",
    "question":
        "Which of the following is the most common cause of chronic respiratory acidosis?",
    "explanation":
        "Chronic respiratory acidosis is most commonly caused by chronic obstructive pulmonary disease (COPD), which impairs ventilation.",
    "incorrect_answer": [
      "Pulmonary embolism",
      "Obstructive sleep apnea",
      "Pneumothorax"
    ],
    "correct_answer": ["Chronic obstructive pulmonary disease (COPD)"],
    "topic_name": "Pulmonary Medicine",
    "category": "COPD Management",
    "level": 2,
    "status": 1,
    "exam_title": "Acute Care NP Exam Prep 2024"
  },
  {
    "uuid": "q140",
    "question":
        "What is the best initial treatment for a patient presenting with acute exacerbation of chronic bronchitis?",
    "explanation":
        "Short-acting bronchodilators such as albuterol are the first-line treatment for acute exacerbations of chronic bronchitis.",
    "incorrect_answer": [
      "Inhaled corticosteroids",
      "Oral antibiotics",
      "Oxygen therapy"
    ],
    "correct_answer": ["Short-acting bronchodilators"],
    "topic_name": "Pulmonary Medicine",
    "category": "COPD Management",
    "level": 1,
    "status": 1,
    "exam_title": "Acute Care NP Exam Prep 2024"
  },
  {
    "uuid": "q141",
    "question":
        "Which of the following pathogens is most commonly associated with ventilator-associated pneumonia (VAP)?",
    "explanation":
        "Pseudomonas aeruginosa is a common pathogen responsible for VAP, particularly in patients in the ICU setting.",
    "incorrect_answer": [
      "Streptococcus pneumoniae",
      "Mycoplasma pneumoniae",
      "Legionella pneumophila"
    ],
    "correct_answer": ["Pseudomonas aeruginosa"],
    "topic_name": "Pulmonary Medicine",
    "category": "Respiratory Infections",
    "level": 2,
    "status": 1,
    "exam_title": "Acute Care NP Exam Prep 2024"
  },
  {
    "uuid": "q142",
    "question":
        "What is the primary imaging modality for the evaluation of suspected pulmonary hypertension?",
    "explanation":
        "Echocardiography is the primary non-invasive test to evaluate pulmonary artery pressure and right heart function.",
    "incorrect_answer": [
      "Chest X-ray",
      "CT pulmonary angiography",
      "Ventilation-perfusion (V/Q) scan"
    ],
    "correct_answer": ["Echocardiography"],
    "topic_name": "Pulmonary Medicine",
    "category": "Pulmonary Hypertension",
    "level": 2,
    "status": 1,
    "exam_title": "Acute Care NP Exam Prep 2024"
  },
  {
    "uuid": "q143",
    "question":
        "Which condition is characterized by the permanent dilation of bronchi due to chronic inflammation and infection?",
    "explanation":
        "Bronchiectasis is characterized by the permanent dilation of airways due to recurrent infections and inflammation.",
    "incorrect_answer": [
      "Asthma",
      "Chronic obstructive pulmonary disease (COPD)",
      "Pulmonary fibrosis"
    ],
    "correct_answer": ["Bronchiectasis"],
    "topic_name": "Pulmonary Medicine",
    "category": "Chronic Respiratory Disorders",
    "level": 2,
    "status": 1,
    "exam_title": "Acute Care NP Exam Prep 2024"
  },
  {
    "uuid": "q144",
    "question":
        "Which diagnostic test is most commonly used to confirm obstructive sleep apnea (OSA)?",
    "explanation":
        "Polysomnography, or a sleep study, is the gold standard for diagnosing OSA.",
    "incorrect_answer": [
      "Chest X-ray",
      "Echocardiography",
      "Pulmonary function test"
    ],
    "correct_answer": ["Polysomnography"],
    "topic_name": "Pulmonary Medicine",
    "category": "Sleep Disorders",
    "level": 1,
    "status": 1,
    "exam_title": "Acute Care NP Exam Prep 2024"
  },
  {
    "uuid": "q145",
    "question":
        "What is the most likely cause of sudden onset dyspnea, pleuritic chest pain, and hypoxemia in a hospitalized patient?",
    "explanation":
        "Pulmonary embolism is a common cause of sudden dyspnea, chest pain, and hypoxemia in hospitalized patients, particularly those at risk of thrombosis.",
    "incorrect_answer": [
      "Pneumothorax",
      "Pneumonia",
      "Acute myocardial infarction"
    ],
    "correct_answer": ["Pulmonary embolism"],
    "topic_name": "Pulmonary Medicine",
    "category": "Pulmonary Embolism",
    "level": 2,
    "status": 1,
    "exam_title": "Acute Care NP Exam Prep 2024"
  },
  {
    "uuid": "q146",
    "question":
        "What is the initial management step in a patient presenting with tension pneumothorax?",
    "explanation":
        "Immediate needle decompression is the first step in managing tension pneumothorax to relieve pressure and restore ventilation.",
    "incorrect_answer": [
      "Chest tube placement",
      "Supplemental oxygen",
      "Endotracheal intubation"
    ],
    "correct_answer": ["Needle decompression"],
    "topic_name": "Pulmonary Medicine",
    "category": "Pleural Diseases",
    "level": 2,
    "status": 1,
    "exam_title": "Acute Care NP Exam Prep 2024"
  },
  {
    "uuid": "q147",
    "question":
        "Which of the following is the hallmark symptom of chronic bronchitis?",
    "explanation":
        "Chronic productive cough for at least three months over two consecutive years is the hallmark of chronic bronchitis.",
    "incorrect_answer": ["Hemoptysis", "Wheezing", "Dyspnea"],
    "correct_answer": ["Chronic productive cough"],
    "topic_name": "Pulmonary Medicine",
    "category": "COPD Management",
    "level": 1,
    "status": 1,
    "exam_title": "Acute Care NP Exam Prep 2024"
  },
  {
    "uuid": "q148",
    "question":
        "Which of the following is a potential complication of untreated obstructive sleep apnea (OSA)?",
    "explanation":
        "Untreated OSA can lead to systemic complications such as hypertension, arrhythmias, and heart failure.",
    "incorrect_answer": [
      "Pulmonary embolism",
      "Chronic bronchitis",
      "Pulmonary fibrosis"
    ],
    "correct_answer": ["Hypertension and cardiovascular complications"],
    "topic_name": "Pulmonary Medicine",
    "category": "Sleep Disorders",
    "level": 1,
    "status": 1,
    "exam_title": "Acute Care NP Exam Prep 2024"
  },
  {
    "uuid": "q149",
    "question":
        "What is the most common risk factor for spontaneous pneumothorax in a young, otherwise healthy individual?",
    "explanation":
        "Spontaneous pneumothorax in young adults is most commonly associated with smoking and tall, thin body habitus.",
    "incorrect_answer": ["Asthma", "COPD", "Bronchiectasis"],
    "correct_answer": ["Smoking"],
    "topic_name": "Pulmonary Medicine",
    "category": "Pleural Diseases",
    "level": 1,
    "status": 1,
    "exam_title": "Acute Care NP Exam Prep 2024"
  },
  {
    "uuid": "q150",
    "question":
        "Which of the following treatments is considered first-line for acute bronchospasm in an asthma exacerbation?",
    "explanation":
        "Inhaled short-acting beta-agonists (SABAs) like albuterol are the first-line treatment for acute bronchospasm in asthma.",
    "incorrect_answer": [
      "Inhaled corticosteroids",
      "Leukotriene receptor antagonists",
      "Long-acting beta-agonists"
    ],
    "correct_answer": ["Inhaled short-acting beta-agonists"],
    "topic_name": "Pulmonary Medicine",
    "category": "Asthma Management",
    "level": 1,
    "status": 1,
    "exam_title": "Acute Care NP Exam Prep 2024"
  },
  {
    "uuid": "q151",
    "question":
        "What is the most common pathogen causing nosocomial pneumonia in intubated patients?",
    "explanation":
        "Acinetobacter species are a common cause of hospital-acquired and ventilator-associated pneumonia, especially in intubated patients.",
    "incorrect_answer": [
      "Streptococcus pneumoniae",
      "Legionella pneumophila",
      "Mycoplasma pneumoniae"
    ],
    "correct_answer": ["Acinetobacter species"],
    "topic_name": "Pulmonary Medicine",
    "category": "Respiratory Infections",
    "level": 2,
    "status": 1,
    "exam_title": "Acute Care NP Exam Prep 2024"
  },
  {
    "uuid": "q152",
    "question":
        "What is the primary mechanism of hypoxemia in acute respiratory distress syndrome (ARDS)?",
    "explanation":
        "In ARDS, impaired gas exchange occurs due to alveolar collapse, decreased lung compliance, and shunting.",
    "incorrect_answer": [
      "Hypercapnia",
      "Alveolar hyperventilation",
      "Increased diffusion capacity"
    ],
    "correct_answer": ["Shunting"],
    "topic_name": "Pulmonary Medicine",
    "category": "Critical Care",
    "level": 3,
    "status": 1,
    "exam_title": "Acute Care NP Exam Prep 2024"
  },
  {
    "uuid": "q153",
    "question":
        "Which of the following is the most appropriate treatment for a patient with sarcoidosis and severe pulmonary symptoms?",
    "explanation":
        "Corticosteroids, such as prednisone, are the mainstay of treatment for symptomatic sarcoidosis.",
    "incorrect_answer": [
      "Methotrexate",
      "Azathioprine",
      "Inhaled bronchodilators"
    ],
    "correct_answer": ["Corticosteroids"],
    "topic_name": "Pulmonary Medicine",
    "category": "Interstitial Lung Diseases",
    "level": 2,
    "status": 1,
    "exam_title": "Acute Care NP Exam Prep 2024"
  },
  {
    "uuid": "q154",
    "question":
        "What is the most common complication of a massive pulmonary embolism?",
    "explanation":
        "A massive pulmonary embolism can lead to acute right ventricular failure, which is the primary cause of morbidity and mortality.",
    "incorrect_answer": [
      "Myocardial infarction",
      "Pneumothorax",
      "Hypovolemic shock"
    ],
    "correct_answer": ["Right ventricular failure"],
    "topic_name": "Pulmonary Medicine",
    "category": "Pulmonary Embolism",
    "level": 3,
    "status": 1,
    "exam_title": "Acute Care NP Exam Prep 2024"
  },
  {
    "uuid": "q155",
    "question":
        "What is the first-line treatment for acute COPD exacerbation with severe hypoxemia?",
    "explanation":
        "Non-invasive positive pressure ventilation (NIPPV) is the preferred first-line treatment for acute COPD exacerbations with hypercapnic respiratory failure.",
    "incorrect_answer": [
      "Oral corticosteroids",
      "Intravenous antibiotics",
      "High-flow nasal cannula oxygen"
    ],
    "correct_answer": ["Non-invasive positive pressure ventilation"],
    "topic_name": "Pulmonary Medicine",
    "category": "COPD Management",
    "level": 3,
    "status": 1,
    "exam_title": "Acute Care NP Exam Prep 2024"
  },
  {
    "uuid": "q156",
    "question":
        "What is the most common imaging finding in patients with idiopathic pulmonary fibrosis (IPF)?",
    "explanation":
        "A reticular pattern with subpleural honeycombing is characteristic of IPF on high-resolution CT scans.",
    "incorrect_answer": [
      "Centrilobular nodules",
      "Bilateral pleural effusion",
      "Diffuse ground-glass opacities"
    ],
    "correct_answer": ["Subpleural honeycombing"],
    "topic_name": "Pulmonary Medicine",
    "category": "Interstitial Lung Diseases",
    "level": 2,
    "status": 1,
    "exam_title": "Acute Care NP Exam Prep 2024"
  },
  {
    "uuid": "q157",
    "question":
        "Which intervention is most effective for smoking cessation in patients with COPD?",
    "explanation":
        "Nicotine replacement therapy is one of the most effective tools for smoking cessation in COPD patients.",
    "incorrect_answer": [
      "Long-term oxygen therapy",
      "Pulmonary rehabilitation",
      "Beta-agonist inhalers"
    ],
    "correct_answer": ["Nicotine replacement therapy"],
    "topic_name": "Pulmonary Medicine",
    "category": "Preventive Care",
    "level": 1,
    "status": 1,
    "exam_title": "Acute Care NP Exam Prep 2024"
  },
  {
    "uuid": "q158",
    "question":
        "What is the preferred diagnostic test for identifying pleural effusion etiology?",
    "explanation":
        "Thoracentesis allows for fluid sampling, enabling analysis of protein, LDH, and other markers to determine transudative versus exudative effusion.",
    "incorrect_answer": [
      "Chest X-ray",
      "High-resolution CT scan",
      "Pulmonary angiography"
    ],
    "correct_answer": ["Thoracentesis"],
    "topic_name": "Pulmonary Medicine",
    "category": "Pleural Diseases",
    "level": 2,
    "status": 1,
    "exam_title": "Acute Care NP Exam Prep 2024"
  },
  {
    "uuid": "q159",
    "question":
        "What is the mechanism of action of ipratropium in the treatment of COPD?",
    "explanation":
        "Ipratropium is an anticholinergic bronchodilator that reduces airway resistance by blocking muscarinic receptors in the lungs.",
    "incorrect_answer": [
      "Beta-2 receptor agonism",
      "Reduction of airway inflammation",
      "Suppression of leukotriene production"
    ],
    "correct_answer": ["Blocking muscarinic receptors"],
    "topic_name": "Pulmonary Medicine",
    "category": "Pharmacology",
    "level": 1,
    "status": 1,
    "exam_title": "Acute Care NP Exam Prep 2024"
  },
  {
    "uuid": "q160",
    "question":
        "Which of the following conditions is most likely to present with pulsus paradoxus?",
    "explanation":
        "Pulsus paradoxus is commonly seen in conditions causing increased intrathoracic pressure, such as severe asthma or cardiac tamponade.",
    "incorrect_answer": [
      "Pulmonary fibrosis",
      "COPD",
      "Pulmonary hypertension"
    ],
    "correct_answer": ["Severe asthma"],
    "topic_name": "Pulmonary Medicine",
    "category": "Clinical Signs",
    "level": 2,
    "status": 1,
    "exam_title": "Acute Care NP Exam Prep 2024"
  },
  {
    "uuid": "q161",
    "question":
        "Which of the following is the hallmark spirometry finding in obstructive lung diseases such as asthma or COPD?",
    "explanation":
        "A decreased FEV1/FVC ratio is the hallmark finding in obstructive lung diseases due to airway obstruction.",
    "incorrect_answer": [
      "Increased FEV1",
      "Normal FEV1/FVC ratio",
      "Increased total lung capacity"
    ],
    "correct_answer": ["Decreased FEV1/FVC ratio"],
    "topic_name": "Pulmonary Medicine",
    "category": "Pulmonary Function Testing",
    "level": 1,
    "status": 1,
    "exam_title": "Acute Care NP Exam Prep 2024"
  },
  {
    "uuid": "q162",
    "question":
        "What is the most common cause of chronic cough in non-smoking patients with normal chest X-ray findings?",
    "explanation":
        "Postnasal drip is the leading cause of chronic cough in non-smokers and is often due to allergic rhinitis or sinusitis.",
    "incorrect_answer": ["GERD", "Asthma", "Vocal cord dysfunction"],
    "correct_answer": ["Postnasal drip"],
    "topic_name": "Pulmonary Medicine",
    "category": "Cough Evaluation",
    "level": 1,
    "status": 1,
    "exam_title": "Acute Care NP Exam Prep 2024"
  },
  {
    "uuid": "q163",
    "question":
        "What is the most common presenting symptom of pulmonary hypertension?",
    "explanation":
        "Exertional dyspnea is the most common symptom of pulmonary hypertension and results from increased pulmonary vascular resistance.",
    "incorrect_answer": ["Chest pain", "Hemoptysis", "Peripheral edema"],
    "correct_answer": ["Exertional dyspnea"],
    "topic_name": "Pulmonary Medicine",
    "category": "Pulmonary Hypertension",
    "level": 2,
    "status": 1,
    "exam_title": "Acute Care NP Exam Prep 2024"
  },
  {
    "uuid": "q164",
    "question":
        "Which of the following conditions is associated with an increased risk of spontaneous pneumothorax?",
    "explanation":
        "Marfan syndrome is associated with increased risk of spontaneous pneumothorax due to connective tissue abnormalities.",
    "incorrect_answer": ["Obstructive sleep apnea", "Asthma", "Bronchiectasis"],
    "correct_answer": ["Marfan syndrome"],
    "topic_name": "Pulmonary Medicine",
    "category": "Pleural Diseases",
    "level": 2,
    "status": 1,
    "exam_title": "Acute Care NP Exam Prep 2024"
  },
  {
    "uuid": "q165",
    "question": "What is the most common occupational lung disease worldwide?",
    "explanation":
        "Silicosis is the most common occupational lung disease worldwide, primarily affecting workers exposed to silica dust.",
    "incorrect_answer": [
      "Asbestosis",
      "Coal workers' pneumoconiosis",
      "Hypersensitivity pneumonitis"
    ],
    "correct_answer": ["Silicosis"],
    "topic_name": "Pulmonary Medicine",
    "category": "Occupational Lung Diseases",
    "level": 2,
    "status": 1,
    "exam_title": "Acute Care NP Exam Prep 2024"
  },
  {
    "uuid": "q166",
    "question":
        "What is the initial imaging modality of choice for evaluating a suspected pleural effusion?",
    "explanation":
        "Chest X-ray is the initial imaging test for suspected pleural effusion and may show blunting of the costophrenic angle.",
    "incorrect_answer": [
      "Chest CT",
      "Ultrasound",
      "Ventilation-perfusion (V/Q) scan"
    ],
    "correct_answer": ["Chest X-ray"],
    "topic_name": "Pulmonary Medicine",
    "category": "Pleural Diseases",
    "level": 1,
    "status": 1,
    "exam_title": "Acute Care NP Exam Prep 2024"
  },
  {
    "uuid": "q167",
    "question":
        "Which of the following is the most common type of lung cancer in non-smokers?",
    "explanation":
        "Adenocarcinoma is the most common type of lung cancer in non-smokers and often arises in the peripheral lung fields.",
    "incorrect_answer": [
      "Small cell carcinoma",
      "Squamous cell carcinoma",
      "Large cell carcinoma"
    ],
    "correct_answer": ["Adenocarcinoma"],
    "topic_name": "Pulmonary Medicine",
    "category": "Oncology",
    "level": 2,
    "status": 1,
    "exam_title": "Acute Care NP Exam Prep 2024"
  },
  {
    "uuid": "q168",
    "question": "Which biomarker is elevated in eosinophilic pneumonia?",
    "explanation":
        "Eosinophilic pneumonia is associated with elevated eosinophil counts in the peripheral blood and bronchoalveolar lavage fluid.",
    "incorrect_answer": ["D-dimer", "Troponin", "Procalcitonin"],
    "correct_answer": ["Eosinophils"],
    "topic_name": "Pulmonary Medicine",
    "category": "Pulmonary Inflammation",
    "level": 2,
    "status": 1,
    "exam_title": "Acute Care NP Exam Prep 2024"
  },
  {
    "uuid": "q169",
    "question":
        "What is the best initial treatment for a patient presenting with tension pneumothorax?",
    "explanation":
        "Immediate needle decompression is the first-line treatment for tension pneumothorax to relieve intrathoracic pressure.",
    "incorrect_answer": [
      "Chest tube placement",
      "High-flow oxygen",
      "Observation"
    ],
    "correct_answer": ["Needle decompression"],
    "topic_name": "Pulmonary Medicine",
    "category": "Emergency Management",
    "level": 3,
    "status": 1,
    "exam_title": "Acute Care NP Exam Prep 2024"
  },
  {
    "uuid": "q170",
    "question":
        "What is the preferred diagnostic tool for assessing diaphragmatic paralysis?",
    "explanation":
        "Fluoroscopy with a sniff test is the preferred diagnostic tool for diaphragmatic paralysis, evaluating diaphragmatic movement.",
    "incorrect_answer": ["Chest X-ray", "CT scan", "MRI"],
    "correct_answer": ["Fluoroscopy"],
    "topic_name": "Pulmonary Medicine",
    "category": "Diagnostics",
    "level": 2,
    "status": 1,
    "exam_title": "Acute Care NP Exam Prep 2024"
  },
  {
    "uuid": "q171",
    "question":
        "Which of the following clinical features is most specific for a diagnosis of chronic bronchitis?",
    "explanation":
        "Chronic productive cough lasting at least three months in two consecutive years is the hallmark of chronic bronchitis.",
    "incorrect_answer": ["Wheezing", "Dyspnea on exertion", "Weight loss"],
    "correct_answer": ["Chronic productive cough"],
    "topic_name": "Pulmonary Medicine",
    "category": "COPD Management",
    "level": 1,
    "status": 1,
    "exam_title": "Acute Care NP Exam Prep 2024"
  },
  {
    "uuid": "q172",
    "question":
        "What is the recommended duration of corticosteroid therapy in acute COPD exacerbation?",
    "explanation":
        "A 5- to 7-day course of systemic corticosteroids is recommended to manage inflammation in COPD exacerbations.",
    "incorrect_answer": ["3 days", "10 days", "14 days"],
    "correct_answer": ["5 to 7 days"],
    "topic_name": "Pulmonary Medicine",
    "category": "COPD Management",
    "level": 1,
    "status": 1,
    "exam_title": "Acute Care NP Exam Prep 2024"
  },
  {
    "uuid": "q173",
    "question": "What is the most common symptom in patients with lung cancer?",
    "explanation":
        "Cough is the most common symptom of lung cancer and may be persistent or associated with hemoptysis.",
    "incorrect_answer": ["Chest pain", "Weight loss", "Dyspnea"],
    "correct_answer": ["Cough"],
    "topic_name": "Pulmonary Medicine",
    "category": "Oncology",
    "level": 2,
    "status": 1,
    "exam_title": "Acute Care NP Exam Prep 2024"
  },
  {
    "uuid": "q174",
    "question":
        "Which of the following conditions is associated with the formation of a cavitary lung lesion?",
    "explanation":
        "Tuberculosis is a classic cause of cavitary lung lesions, often in the upper lobes of the lungs.",
    "incorrect_answer": [
      "Pulmonary edema",
      "Pulmonary fibrosis",
      "Sarcoidosis"
    ],
    "correct_answer": ["Tuberculosis"],
    "topic_name": "Pulmonary Medicine",
    "category": "Respiratory Infections",
    "level": 2,
    "status": 1,
    "exam_title": "Acute Care NP Exam Prep 2024"
  },
  {
    "uuid": "q175",
    "question":
        "What is the primary mechanism of hypoxemia in acute respiratory distress syndrome (ARDS)?",
    "explanation":
        "Shunting, caused by alveolar collapse and fluid-filled alveoli, is the primary mechanism of hypoxemia in ARDS.",
    "incorrect_answer": [
      "Decreased inspired oxygen",
      "Hypoventilation",
      "Diffusion limitation"
    ],
    "correct_answer": ["Shunting"],
    "topic_name": "Pulmonary Medicine",
    "category": "Critical Care",
    "level": 3,
    "status": 1,
    "exam_title": "Acute Care NP Exam Prep 2024"
  },
  {
    "uuid": "q176",
    "question":
        "Which of the following is the first-line treatment for high-altitude pulmonary edema (HAPE)?",
    "explanation":
        "Immediate descent to a lower altitude is the most effective treatment for HAPE, improving oxygenation and reducing pulmonary pressure.",
    "incorrect_answer": [
      "Diuretics",
      "High-flow oxygen",
      "Inhaled nitric oxide"
    ],
    "correct_answer": ["Immediate descent to a lower altitude"],
    "topic_name": "Pulmonary Medicine",
    "category": "Environmental Lung Diseases",
    "level": 3,
    "status": 1,
    "exam_title": "Acute Care NP Exam Prep 2024"
  },
  {
    "uuid": "q177",
    "question":
        "What is the definitive diagnostic test for obstructive sleep apnea?",
    "explanation":
        "Polysomnography is the gold standard for diagnosing obstructive sleep apnea by evaluating apneas, hypopneas, and oxygen desaturation.",
    "incorrect_answer": [
      "Overnight pulse oximetry",
      "Home sleep apnea testing",
      "Arterial blood gas"
    ],
    "correct_answer": ["Polysomnography"],
    "topic_name": "Pulmonary Medicine",
    "category": "Sleep Disorders",
    "level": 2,
    "status": 1,
    "exam_title": "Acute Care NP Exam Prep 2024"
  },
  {
    "uuid": "q178",
    "question":
        "Which of the following is the most common complication of bronchoscopy?",
    "explanation":
        "Bleeding is the most common complication of bronchoscopy, especially in patients with underlying coagulopathies or during biopsy procedures.",
    "incorrect_answer": ["Pneumothorax", "Infection", "Aspiration"],
    "correct_answer": ["Bleeding"],
    "topic_name": "Pulmonary Medicine",
    "category": "Diagnostics",
    "level": 2,
    "status": 1,
    "exam_title": "Acute Care NP Exam Prep 2024"
  },
  {
    "uuid": "q179",
    "question":
        "Which imaging modality is most sensitive for detecting interstitial lung disease?",
    "explanation":
        "High-resolution CT is the most sensitive imaging modality for diagnosing interstitial lung disease, revealing detailed lung parenchyma abnormalities.",
    "incorrect_answer": ["Chest X-ray", "MRI", "PET scan"],
    "correct_answer": ["High-resolution CT"],
    "topic_name": "Pulmonary Medicine",
    "category": "Interstitial Lung Diseases",
    "level": 2,
    "status": 1,
    "exam_title": "Acute Care NP Exam Prep 2024"
  },
  {
    "uuid": "q180",
    "question":
        "What is the primary pharmacologic treatment for pulmonary arterial hypertension (PAH)?",
    "explanation":
        "Endothelin receptor antagonists, such as bosentan, are commonly used to reduce pulmonary vascular resistance in PAH.",
    "incorrect_answer": ["Corticosteroids", "Anticoagulants", "Beta-blockers"],
    "correct_answer": ["Endothelin receptor antagonists"],
    "topic_name": "Pulmonary Medicine",
    "category": "Pulmonary Hypertension",
    "level": 3,
    "status": 1,
    "exam_title": "Acute Care NP Exam Prep 2024"
  },
  {
    "uuid": "q181",
    "question":
        "Which lung condition is associated with alpha-1 antitrypsin deficiency?",
    "explanation":
        "Alpha-1 antitrypsin deficiency is associated with early-onset emphysema, particularly in the lower lobes of the lungs.",
    "incorrect_answer": [
      "Asthma",
      "Bronchiectasis",
      "Interstitial lung disease"
    ],
    "correct_answer": ["Emphysema"],
    "topic_name": "Pulmonary Medicine",
    "category": "Genetic Disorders",
    "level": 2,
    "status": 1,
    "exam_title": "Acute Care NP Exam Prep 2024"
  },
  {
    "uuid": "q182",
    "question":
        "What is the most common causative agent of ventilator-associated pneumonia (VAP)?",
    "explanation":
        "Pseudomonas aeruginosa is a common cause of ventilator-associated pneumonia in critically ill patients.",
    "incorrect_answer": [
      "Staphylococcus aureus",
      "Escherichia coli",
      "Klebsiella pneumoniae"
    ],
    "correct_answer": ["Pseudomonas aeruginosa"],
    "topic_name": "Pulmonary Medicine",
    "category": "Respiratory Infections",
    "level": 2,
    "status": 1,
    "exam_title": "Acute Care NP Exam Prep 2024"
  },
  {
    "uuid": "q183",
    "question":
        "Which diagnostic test is most useful in confirming the presence of pleural effusion?",
    "explanation":
        "Ultrasound is highly sensitive for detecting pleural effusions and can guide thoracentesis.",
    "incorrect_answer": [
      "Chest X-ray",
      "CT scan",
      "Pulmonary function testing"
    ],
    "correct_answer": ["Ultrasound"],
    "topic_name": "Pulmonary Medicine",
    "category": "Pleural Diseases",
    "level": 2,
    "status": 1,
    "exam_title": "Acute Care NP Exam Prep 2024"
  },
  {
    "uuid": "q184",
    "question":
        "Which treatment is recommended for idiopathic pulmonary fibrosis (IPF) to slow disease progression?",
    "explanation":
        "Antifibrotic agents such as nintedanib are used to slow the progression of idiopathic pulmonary fibrosis.",
    "incorrect_answer": [
      "Systemic corticosteroids",
      "Immunosuppressants",
      "Long-term antibiotics"
    ],
    "correct_answer": ["Antifibrotic agents"],
    "topic_name": "Pulmonary Medicine",
    "category": "Interstitial Lung Diseases",
    "level": 3,
    "status": 1,
    "exam_title": "Acute Care NP Exam Prep 2024"
  },
  {
    "uuid": "q185",
    "question":
        "Which of the following physical examination findings is commonly associated with tension pneumothorax?",
    "explanation":
        "Tension pneumothorax is often associated with tracheal deviation away from the affected side due to pressure changes.",
    "incorrect_answer": [
      "Hyperresonance on percussion on the affected side",
      "Decreased breath sounds on the affected side",
      "Tachycardia"
    ],
    "correct_answer": ["Tracheal deviation away from the affected side"],
    "topic_name": "Pulmonary Medicine",
    "category": "Pleural Diseases",
    "level": 3,
    "status": 1,
    "exam_title": "Acute Care NP Exam Prep 2024"
  },
  {
    "uuid": "q186",
    "question":
        "What is the typical chest X-ray finding in a patient with primary spontaneous pneumothorax?",
    "explanation":
        "Primary spontaneous pneumothorax is characterized by a visible pleural line with no lung markings beyond it.",
    "incorrect_answer": [
      "Consolidation",
      "Ground-glass opacities",
      "Bilateral hilar lymphadenopathy"
    ],
    "correct_answer": ["Visible pleural line with no lung markings"],
    "topic_name": "Pulmonary Medicine",
    "category": "Pleural Diseases",
    "level": 1,
    "status": 1,
    "exam_title": "Acute Care NP Exam Prep 2024"
  },
  {
    "uuid": "q187",
    "question":
        "Which clinical condition is characterized by the presence of 'honeycomb lung' on imaging?",
    "explanation":
        "'Honeycomb lung' is a classic finding in advanced interstitial lung disease, particularly idiopathic pulmonary fibrosis.",
    "incorrect_answer": [
      "Chronic obstructive pulmonary disease",
      "Acute respiratory distress syndrome",
      "Sarcoidosis"
    ],
    "correct_answer": ["Idiopathic pulmonary fibrosis"],
    "topic_name": "Pulmonary Medicine",
    "category": "Interstitial Lung Diseases",
    "level": 3,
    "status": 1,
    "exam_title": "Acute Care NP Exam Prep 2024"
  },
  {
    "uuid": "q188",
    "question":
        "Which of the following is a key diagnostic criterion for allergic bronchopulmonary aspergillosis (ABPA)?",
    "explanation":
        "Elevated serum IgE levels are a hallmark diagnostic criterion for allergic bronchopulmonary aspergillosis.",
    "incorrect_answer": [
      "Positive D-dimer",
      "Low serum albumin",
      "Hypocapnia on arterial blood gas"
    ],
    "correct_answer": ["Elevated serum IgE levels"],
    "topic_name": "Pulmonary Medicine",
    "category": "Respiratory Infections",
    "level": 3,
    "status": 1,
    "exam_title": "Acute Care NP Exam Prep 2024"
  },
  {
    "uuid": "q189",
    "question":
        "What is the first-line treatment for acute bronchospasm in a patient with asthma?",
    "explanation":
        "Short-acting beta-agonists (e.g., albuterol) are the first-line treatment for acute bronchospasm.",
    "incorrect_answer": [
      "Inhaled corticosteroids",
      "Leukotriene receptor antagonists",
      "Long-acting beta-agonists"
    ],
    "correct_answer": ["Short-acting beta-agonists"],
    "topic_name": "Pulmonary Medicine",
    "category": "Asthma Management",
    "level": 1,
    "status": 1,
    "exam_title": "Acute Care NP Exam Prep 2024"
  },
  {
    "uuid": "q190",
    "question":
        "Which of the following tests is most useful in diagnosing pulmonary hypertension?",
    "explanation":
        "Right heart catheterization is the gold standard for diagnosing pulmonary hypertension by directly measuring pulmonary artery pressures.",
    "incorrect_answer": [
      "Echocardiogram",
      "CT angiography",
      "Pulmonary function testing"
    ],
    "correct_answer": ["Right heart catheterization"],
    "topic_name": "Pulmonary Medicine",
    "category": "Pulmonary Hypertension",
    "level": 3,
    "status": 1,
    "exam_title": "Acute Care NP Exam Prep 2024"
  },
  {
    "uuid": "q191",
    "question":
        "Which of the following is the hallmark feature of chronic bronchitis in COPD?",
    "explanation":
        "Chronic bronchitis is characterized by excessive mucus production and a productive cough for at least three months in two consecutive years.",
    "incorrect_answer": [
      "Wheezing",
      "Airway hyperresponsiveness",
      "Parenchymal destruction"
    ],
    "correct_answer": ["Excessive mucus production"],
    "topic_name": "Pulmonary Medicine",
    "category": "COPD Management",
    "level": 1,
    "status": 1,
    "exam_title": "Acute Care NP Exam Prep 2024"
  },
  {
    "uuid": "q192",
    "question":
        "Which pathogen is most commonly associated with post-viral pneumonia?",
    "explanation":
        "Staphylococcus aureus is a common cause of secondary bacterial pneumonia following a viral infection.",
    "incorrect_answer": [
      "Klebsiella pneumoniae",
      "Mycoplasma pneumoniae",
      "Legionella pneumophila"
    ],
    "correct_answer": ["Staphylococcus aureus"],
    "topic_name": "Pulmonary Medicine",
    "category": "Respiratory Infections",
    "level": 2,
    "status": 1,
    "exam_title": "Acute Care NP Exam Prep 2024"
  },
  {
    "uuid": "q193",
    "question":
        "What is the most appropriate initial diagnostic test for suspected pulmonary embolism in a hemodynamically unstable patient?",
    "explanation":
        "Bedside echocardiography can rapidly detect right ventricular dysfunction, a sign of massive pulmonary embolism, in unstable patients.",
    "incorrect_answer": [
      "CT pulmonary angiography",
      "D-dimer assay",
      "Chest X-ray"
    ],
    "correct_answer": ["Bedside echocardiography"],
    "topic_name": "Pulmonary Medicine",
    "category": "Pulmonary Embolism",
    "level": 3,
    "status": 1,
    "exam_title": "Acute Care NP Exam Prep 2024"
  },
  {
    "uuid": "q194",
    "question":
        "Which condition is characterized by a decreased diffusing capacity for carbon monoxide (DLCO)?",
    "explanation":
        "Emphysema is associated with destruction of alveolar walls, leading to decreased DLCO.",
    "incorrect_answer": [
      "Asthma",
      "Chronic bronchitis",
      "Pulmonary hypertension"
    ],
    "correct_answer": ["Emphysema"],
    "topic_name": "Pulmonary Medicine",
    "category": "Pulmonary Function Testing",
    "level": 2,
    "status": 1,
    "exam_title": "Acute Care NP Exam Prep 2024"
  },
  {
    "uuid": "q195",
    "question":
        "Which condition presents with inspiratory stridor and is caused by upper airway obstruction?",
    "explanation":
        "Inspiratory stridor is a hallmark sign of laryngotracheobronchitis (croup), a common cause of upper airway obstruction.",
    "incorrect_answer": ["Asthma", "Bronchiectasis", "Pulmonary fibrosis"],
    "correct_answer": ["Laryngotracheobronchitis (croup)"],
    "topic_name": "Pulmonary Medicine",
    "category": "Respiratory Disorders",
    "level": 1,
    "status": 1,
    "exam_title": "Acute Care NP Exam Prep 2024"
  },
  {
    "uuid": "q196",
    "question":
        "Which of the following is a common complication of untreated obstructive sleep apnea?",
    "explanation":
        "Untreated obstructive sleep apnea can lead to systemic hypertension due to repetitive hypoxia and sympathetic activation.",
    "incorrect_answer": [
      "Pulmonary embolism",
      "Pneumothorax",
      "Acute respiratory distress syndrome"
    ],
    "correct_answer": ["Systemic hypertension"],
    "topic_name": "Pulmonary Medicine",
    "category": "Sleep Disorders",
    "level": 2,
    "status": 1,
    "exam_title": "Acute Care NP Exam Prep 2024"
  },
  {
    "uuid": "q197",
    "question":
        "Which ventilator setting is adjusted to directly improve oxygenation in ARDS?",
    "explanation":
        "Increasing the positive end-expiratory pressure (PEEP) helps improve oxygenation by preventing alveolar collapse.",
    "incorrect_answer": [
      "Tidal volume",
      "Inspiratory-to-expiratory (I:E) ratio",
      "Respiratory rate"
    ],
    "correct_answer": ["Positive end-expiratory pressure (PEEP)"],
    "topic_name": "Pulmonary Medicine",
    "category": "Ventilator Management",
    "level": 2,
    "status": 1,
    "exam_title": "Acute Care NP Exam Prep 2024"
  },
  {
    "uuid": "q198",
    "question": "What is the most common cause of hemoptysis worldwide?",
    "explanation":
        "Tuberculosis is the most common cause of hemoptysis, particularly in developing countries.",
    "incorrect_answer": [
      "Bronchogenic carcinoma",
      "Pulmonary embolism",
      "Bronchiectasis"
    ],
    "correct_answer": ["Tuberculosis"],
    "topic_name": "Pulmonary Medicine",
    "category": "Respiratory Infections",
    "level": 1,
    "status": 1,
    "exam_title": "Acute Care NP Exam Prep 2024"
  },
  {
    "uuid": "q199",
    "question": "Which of the following is the primary symptom of pleuritis?",
    "explanation":
        "Sharp, localized chest pain that worsens with inspiration or coughing is characteristic of pleuritis.",
    "incorrect_answer": ["Wheezing", "Hemoptysis", "Chronic cough"],
    "correct_answer": ["Sharp chest pain with inspiration"],
    "topic_name": "Pulmonary Medicine",
    "category": "Pleural Diseases",
    "level": 1,
    "status": 1,
    "exam_title": "Acute Care NP Exam Prep 2024"
  },
  {
    "uuid": "q200",
    "question":
        "Which imaging modality is most appropriate for evaluating interstitial lung disease?",
    "explanation":
        "High-resolution CT is the preferred imaging study for evaluating interstitial lung disease as it provides detailed visualization of lung parenchyma.",
    "incorrect_answer": [
      "Chest X-ray",
      "Pulmonary angiography",
      "Ventilation-perfusion (V/Q) scan"
    ],
    "correct_answer": ["High-resolution CT"],
    "topic_name": "Pulmonary Medicine",
    "category": "Interstitial Lung Diseases",
    "level": 2,
    "status": 1,
    "exam_title": "Acute Care NP Exam Prep 2024"
  },
  {
    "uuid": "q201",
    "question":
        "Which of the following pulmonary conditions is associated with digital clubbing?",
    "explanation":
        "Digital clubbing is commonly seen in pulmonary conditions like lung cancer, bronchiectasis, and interstitial lung disease.",
    "incorrect_answer": ["Chronic bronchitis", "Asthma", "Acute bronchitis"],
    "correct_answer": ["Bronchiectasis"],
    "topic_name": "Pulmonary Medicine",
    "category": "Physical Examination Findings",
    "level": 2,
    "status": 1,
    "exam_title": "Acute Care NP Exam Prep 2024"
  },
  {
    "uuid": "q202",
    "question": "What is the most common cause of exudative pleural effusion?",
    "explanation":
        "Pneumonia is the leading cause of exudative pleural effusion, which results from increased capillary permeability.",
    "incorrect_answer": [
      "Congestive heart failure",
      "Cirrhosis",
      "Nephrotic syndrome"
    ],
    "correct_answer": ["Pneumonia"],
    "topic_name": "Pulmonary Medicine",
    "category": "Pleural Diseases",
    "level": 1,
    "status": 1,
    "exam_title": "Acute Care NP Exam Prep 2024"
  },
  {
    "uuid": "q203",
    "question":
        "Which medication is recommended for the prevention of exercise-induced bronchospasm?",
    "explanation":
        "Short-acting beta-agonists like albuterol are the treatment of choice for preventing exercise-induced bronchospasm.",
    "incorrect_answer": [
      "Inhaled corticosteroids",
      "Long-acting beta-agonists",
      "Leukotriene receptor antagonists"
    ],
    "correct_answer": ["Short-acting beta-agonists"],
    "topic_name": "Pulmonary Medicine",
    "category": "Asthma Management",
    "level": 1,
    "status": 1,
    "exam_title": "Acute Care NP Exam Prep 2024"
  },
  {
    "uuid": "q204",
    "question":
        "What is the mechanism of hypoxemia in acute respiratory distress syndrome (ARDS)?",
    "explanation":
        "ARDS is characterized by intrapulmonary shunting due to alveolar collapse and fluid accumulation, leading to refractory hypoxemia.",
    "incorrect_answer": [
      "Hypoventilation",
      "High V/Q mismatch",
      "Diffusion limitation"
    ],
    "correct_answer": ["Intrapulmonary shunting"],
    "topic_name": "Pulmonary Medicine",
    "category": "Critical Care",
    "level": 2,
    "status": 1,
    "exam_title": "Acute Care NP Exam Prep 2024"
  },
  {
    "uuid": "q205",
    "question":
        "Which pulmonary function test finding is consistent with obstructive lung disease?",
    "explanation":
        "A decreased FEV1/FVC ratio is a hallmark feature of obstructive lung diseases such as COPD and asthma.",
    "incorrect_answer": [
      "Increased FEV1",
      "Normal FEV1/FVC ratio",
      "Decreased total lung capacity"
    ],
    "correct_answer": ["Decreased FEV1/FVC ratio"],
    "topic_name": "Pulmonary Medicine",
    "category": "Pulmonary Function Testing",
    "level": 1,
    "status": 1,
    "exam_title": "Acute Care NP Exam Prep 2024"
  },
  {
    "uuid": "q206",
    "question":
        "What is the next step in the management of a patient with a pneumothorax occupying 20% of the hemithorax and stable vital signs?",
    "explanation":
        "Observation with supplemental oxygen is appropriate for small, stable pneumothoraces as it can accelerate reabsorption of air.",
    "incorrect_answer": [
      "Immediate chest tube placement",
      "Needle decompression",
      "Thoracotomy"
    ],
    "correct_answer": ["Observation with supplemental oxygen"],
    "topic_name": "Pulmonary Medicine",
    "category": "Pleural Diseases",
    "level": 2,
    "status": 1,
    "exam_title": "Acute Care NP Exam Prep 2024"
  },
  {
    "uuid": "q207",
    "question":
        "Which of the following is the hallmark imaging finding in idiopathic pulmonary fibrosis?",
    "explanation":
        "Bilateral basal reticulonodular opacities with honeycombing on high-resolution CT are characteristic of idiopathic pulmonary fibrosis.",
    "incorrect_answer": [
      "Bilateral pleural effusions",
      "Ground-glass opacities",
      "Centrilobular nodules"
    ],
    "correct_answer": ["Honeycombing and basal reticulonodular opacities"],
    "topic_name": "Pulmonary Medicine",
    "category": "Interstitial Lung Diseases",
    "level": 2,
    "status": 1,
    "exam_title": "Acute Care NP Exam Prep 2024"
  },
  {
    "uuid": "q208",
    "question":
        "What is the most appropriate treatment for tension pneumothorax in the emergency setting?",
    "explanation":
        "Needle decompression is the immediate life-saving treatment for tension pneumothorax, followed by chest tube placement.",
    "incorrect_answer": ["Supplemental oxygen", "Thoracentesis", "Observation"],
    "correct_answer": ["Needle decompression"],
    "topic_name": "Pulmonary Medicine",
    "category": "Critical Care",
    "level": 1,
    "status": 1,
    "exam_title": "Acute Care NP Exam Prep 2024"
  },
  {
    "uuid": "q209",
    "question":
        "Which of the following is an early sign of hypercapnia in patients with chronic obstructive pulmonary disease?",
    "explanation":
        "Morning headaches are an early sign of hypercapnia due to nocturnal hypoventilation in patients with COPD.",
    "incorrect_answer": [
      "Cyanosis",
      "Peripheral edema",
      "Altered mental status"
    ],
    "correct_answer": ["Morning headaches"],
    "topic_name": "Pulmonary Medicine",
    "category": "COPD Management",
    "level": 2,
    "status": 1,
    "exam_title": "Acute Care NP Exam Prep 2024"
  },
  {
    "uuid": "q210",
    "question":
        "Which inhaled medication class is considered the first-line treatment for stable COPD to improve airflow and reduce symptoms?",
    "explanation":
        "Long-acting beta-agonists (LABAs) improve airflow and are the cornerstone of maintenance therapy for stable COPD.",
    "incorrect_answer": [
      "Short-acting beta-agonists",
      "Inhaled corticosteroids",
      "Oral theophylline"
    ],
    "correct_answer": ["Long-acting beta-agonists"],
    "topic_name": "Pulmonary Medicine",
    "category": "COPD Management",
    "level": 1,
    "status": 1,
    "exam_title": "Acute Care NP Exam Prep 2024"
  },
  {
    "uuid": "q211",
    "question":
        "A 60-year-old patient with COPD presents with an acute exacerbation. Which blood gas finding is most consistent with acute-on-chronic respiratory failure?",
    "explanation":
        "Acute-on-chronic respiratory failure in COPD is characterized by elevated PaCO2 and decreased pH, indicating respiratory acidosis.",
    "incorrect_answer": [
      "pH 7.45, PaCO2 30 mm Hg",
      "pH 7.50, PaCO2 25 mm Hg",
      "pH 7.35, PaCO2 40 mm Hg"
    ],
    "correct_answer": ["pH 7.30, PaCO2 55 mm Hg"],
    "topic_name": "Pulmonary Medicine",
    "category": "COPD Management",
    "level": 2,
    "status": 1,
    "exam_title": "Acute Care NP Exam Prep 2024"
  },
  {
    "uuid": "q212",
    "question":
        "Which diagnostic test is used to confirm obstructive sleep apnea (OSA)?",
    "explanation":
        "Polysomnography is the gold standard for diagnosing obstructive sleep apnea, as it monitors sleep patterns, airflow, and oxygen saturation.",
    "incorrect_answer": [
      "Chest X-ray",
      "Spirometry",
      "Arterial blood gas analysis"
    ],
    "correct_answer": ["Polysomnography"],
    "topic_name": "Pulmonary Medicine",
    "category": "Sleep Disorders",
    "level": 1,
    "status": 1,
    "exam_title": "Acute Care NP Exam Prep 2024"
  },
  {
    "uuid": "q213",
    "question":
        "What is the most likely cause of post-operative hypoxemia in a patient who underwent major abdominal surgery?",
    "explanation":
        "Atelectasis is the most common cause of hypoxemia in post-operative patients due to shallow breathing and impaired cough reflex.",
    "incorrect_answer": [
      "Pulmonary embolism",
      "Pneumothorax",
      "Pleural effusion"
    ],
    "correct_answer": ["Atelectasis"],
    "topic_name": "Pulmonary Medicine",
    "category": "Post-Operative Complications",
    "level": 1,
    "status": 1,
    "exam_title": "Acute Care NP Exam Prep 2024"
  },
  {
    "uuid": "q214",
    "question":
        "A 45-year-old male presents with sudden onset dyspnea and pleuritic chest pain. His D-dimer is elevated. What is the next step in management?",
    "explanation":
        "CT pulmonary angiography is the preferred imaging modality to confirm the diagnosis of pulmonary embolism in patients with elevated D-dimer.",
    "incorrect_answer": [
      "Perform a chest X-ray",
      "Start anticoagulation without further testing",
      "Order a ventilation-perfusion (V/Q) scan"
    ],
    "correct_answer": ["Order CT pulmonary angiography"],
    "topic_name": "Pulmonary Medicine",
    "category": "Pulmonary Embolism",
    "level": 2,
    "status": 1,
    "exam_title": "Acute Care NP Exam Prep 2024"
  },
  {
    "uuid": "q215",
    "question":
        "Which of the following is the primary treatment for a patient diagnosed with primary spontaneous pneumothorax with minimal symptoms?",
    "explanation":
        "Observation with supplemental oxygen is appropriate for small, spontaneous pneumothoraces in stable patients.",
    "incorrect_answer": [
      "Needle decompression",
      "Chest tube placement",
      "Thoracotomy"
    ],
    "correct_answer": ["Observation with supplemental oxygen"],
    "topic_name": "Pulmonary Medicine",
    "category": "Pleural Diseases",
    "level": 1,
    "status": 1,
    "exam_title": "Acute Care NP Exam Prep 2024"
  },
  {
    "uuid": "q216",
    "question":
        "What is the characteristic finding on pulmonary function testing for restrictive lung disease?",
    "explanation":
        "Restrictive lung diseases are characterized by reduced total lung capacity (TLC) and preserved or increased FEV1/FVC ratio.",
    "incorrect_answer": [
      "Decreased FEV1/FVC ratio",
      "Increased residual volume",
      "Increased total lung capacity"
    ],
    "correct_answer": ["Decreased total lung capacity"],
    "topic_name": "Pulmonary Medicine",
    "category": "Pulmonary Function Testing",
    "level": 2,
    "status": 1,
    "exam_title": "Acute Care NP Exam Prep 2024"
  },
  {
    "uuid": "q217",
    "question":
        "Which of the following medications is most effective for the treatment of sarcoidosis with pulmonary involvement?",
    "explanation":
        "Corticosteroids are the first-line treatment for sarcoidosis to reduce inflammation and improve symptoms.",
    "incorrect_answer": ["Methotrexate", "Azathioprine", "Cyclophosphamide"],
    "correct_answer": ["Corticosteroids"],
    "topic_name": "Pulmonary Medicine",
    "category": "Interstitial Lung Diseases",
    "level": 2,
    "status": 1,
    "exam_title": "Acute Care NP Exam Prep 2024"
  },
  {
    "uuid": "q218",
    "question":
        "Which intervention is recommended to prevent ventilator-associated pneumonia (VAP) in intubated patients?",
    "explanation":
        "Head-of-bed elevation to 30–45 degrees reduces the risk of ventilator-associated pneumonia by minimizing aspiration.",
    "incorrect_answer": [
      "Prophylactic antibiotics",
      "Frequent suctioning of the endotracheal tube",
      "Routine changing of ventilator circuits"
    ],
    "correct_answer": ["Head-of-bed elevation to 30–45 degrees"],
    "topic_name": "Pulmonary Medicine",
    "category": "Critical Care",
    "level": 2,
    "status": 1,
    "exam_title": "Acute Care NP Exam Prep 2024"
  },
  {
    "uuid": "q219",
    "question":
        "What is the best initial diagnostic test for a suspected pleural effusion?",
    "explanation":
        "Chest X-ray is the first-line diagnostic tool for detecting pleural effusions and assessing their size and location.",
    "incorrect_answer": [
      "CT scan of the chest",
      "Ultrasound of the chest",
      "Thoracentesis"
    ],
    "correct_answer": ["Chest X-ray"],
    "topic_name": "Pulmonary Medicine",
    "category": "Pleural Diseases",
    "level": 1,
    "status": 1,
    "exam_title": "Acute Care NP Exam Prep 2024"
  },
  {
    "uuid": "q220",
    "question":
        "Which organism is the most common cause of ventilator-associated pneumonia (VAP)?",
    "explanation":
        "Pseudomonas aeruginosa is a common pathogen in ventilator-associated pneumonia, particularly in hospitalized patients.",
    "incorrect_answer": [
      "Streptococcus pneumoniae",
      "Legionella pneumophila",
      "Mycoplasma pneumoniae"
    ],
    "correct_answer": ["Pseudomonas aeruginosa"],
    "topic_name": "Pulmonary Medicine",
    "category": "Respiratory Infections",
    "level": 2,
    "status": 1,
    "exam_title": "Acute Care NP Exam Prep 2024"
  },
  {
    "uuid": "q221",
    "question":
        "Which of the following is the most common cause of chronic cough in non-smokers with normal chest X-rays?",
    "explanation":
        "Postnasal drip syndrome is the leading cause of chronic cough in non-smokers with normal imaging studies.",
    "incorrect_answer": [
      "Chronic obstructive pulmonary disease",
      "Asthma",
      "Gastroesophageal reflux disease"
    ],
    "correct_answer": ["Postnasal drip syndrome"],
    "topic_name": "Pulmonary Medicine",
    "category": "Cough and Airway Disorders",
    "level": 1,
    "status": 1,
    "exam_title": "Acute Care NP Exam Prep 2024"
  },
  {
    "uuid": "q222",
    "question":
        "A patient presents with hemoptysis, weight loss, and night sweats. Chest imaging shows a cavitary lesion in the upper lobe. What is the most likely diagnosis?",
    "explanation":
        "Tuberculosis typically presents with upper lobe cavitary lesions, hemoptysis, weight loss, and night sweats.",
    "incorrect_answer": ["Lung abscess", "Pulmonary embolism", "Sarcoidosis"],
    "correct_answer": ["Tuberculosis"],
    "topic_name": "Pulmonary Medicine",
    "category": "Respiratory Infections",
    "level": 2,
    "status": 1,
    "exam_title": "Acute Care NP Exam Prep 2024"
  },
  {
    "uuid": "q223",
    "question": "What is the primary treatment for tension pneumothorax?",
    "explanation":
        "Needle decompression followed by chest tube placement is the life-saving intervention for tension pneumothorax.",
    "incorrect_answer": [
      "High-flow oxygen therapy",
      "Observation and monitoring",
      "Thoracentesis"
    ],
    "correct_answer": ["Needle decompression followed by chest tube placement"],
    "topic_name": "Pulmonary Medicine",
    "category": "Pleural Diseases",
    "level": 1,
    "status": 1,
    "exam_title": "Acute Care NP Exam Prep 2024"
  },
  {
    "uuid": "q224",
    "question":
        "Which of the following conditions is most likely to cause a chronic hypoxemic respiratory failure?",
    "explanation":
        "Chronic obstructive pulmonary disease is a common cause of hypoxemic respiratory failure due to impaired gas exchange.",
    "incorrect_answer": [
      "Acute pulmonary embolism",
      "Pneumothorax",
      "Bronchiectasis"
    ],
    "correct_answer": ["Chronic obstructive pulmonary disease"],
    "topic_name": "Pulmonary Medicine",
    "category": "Chronic Respiratory Diseases",
    "level": 2,
    "status": 1,
    "exam_title": "Acute Care NP Exam Prep 2024"
  },
  {
    "uuid": "q225",
    "question":
        "Which diagnostic finding is characteristic of asthma on spirometry?",
    "explanation":
        "Reversible airway obstruction, defined as an increase in FEV1 of 12% or more after bronchodilator administration, is a hallmark of asthma.",
    "incorrect_answer": [
      "Decreased FVC with normal FEV1/FVC",
      "Normal spirometry with exercise-induced symptoms",
      "Reduced DLCO without obstruction"
    ],
    "correct_answer": ["Reversible airway obstruction"],
    "topic_name": "Pulmonary Medicine",
    "category": "Asthma Management",
    "level": 2,
    "status": 1,
    "exam_title": "Acute Care NP Exam Prep 2024"
  },
  {
    "uuid": "q226",
    "question":
        "A patient with cystic fibrosis presents with increased cough and purulent sputum. Which organism is most likely responsible for the infection?",
    "explanation":
        "Pseudomonas aeruginosa is a common pathogen in cystic fibrosis exacerbations, particularly in older patients.",
    "incorrect_answer": [
      "Klebsiella pneumoniae",
      "Staphylococcus aureus",
      "Haemophilus influenzae"
    ],
    "correct_answer": ["Pseudomonas aeruginosa"],
    "topic_name": "Pulmonary Medicine",
    "category": "Respiratory Infections",
    "level": 2,
    "status": 1,
    "exam_title": "Acute Care NP Exam Prep 2024"
  },
  {
    "uuid": "q227",
    "question":
        "Which of the following is a common complication of untreated obstructive sleep apnea (OSA)?",
    "explanation":
        "Untreated OSA can lead to systemic hypertension, increasing cardiovascular risks.",
    "incorrect_answer": ["Pulmonary embolism", "Pneumothorax", "Lung fibrosis"],
    "correct_answer": ["Systemic hypertension"],
    "topic_name": "Pulmonary Medicine",
    "category": "Sleep Disorders",
    "level": 1,
    "status": 1,
    "exam_title": "Acute Care NP Exam Prep 2024"
  },
  {
    "uuid": "q228",
    "question":
        "What is the recommended initial treatment for acute respiratory distress syndrome (ARDS)?",
    "explanation":
        "Low tidal volume mechanical ventilation reduces ventilator-induced lung injury in ARDS patients.",
    "incorrect_answer": [
      "High tidal volume ventilation",
      "Routine use of corticosteroids",
      "Early tracheostomy"
    ],
    "correct_answer": ["Low tidal volume mechanical ventilation"],
    "topic_name": "Pulmonary Medicine",
    "category": "Critical Care",
    "level": 2,
    "status": 1,
    "exam_title": "Acute Care NP Exam Prep 2024"
  },
  {
    "uuid": "q229",
    "question":
        "A 35-year-old male with a recent upper respiratory infection presents with pleuritic chest pain and dyspnea. A chest X-ray shows small pleural effusions. What is the likely diagnosis?",
    "explanation":
        "Viral pleuritis often occurs after a viral upper respiratory infection and can present with pleuritic chest pain and small effusions.",
    "incorrect_answer": ["Pneumonia", "Pulmonary embolism", "Tuberculosis"],
    "correct_answer": ["Viral pleuritis"],
    "topic_name": "Pulmonary Medicine",
    "category": "Pleural Diseases",
    "level": 1,
    "status": 1,
    "exam_title": "Acute Care NP Exam Prep 2024"
  },
  {
    "uuid": "q230",
    "question":
        "Which of the following is the most effective long-term treatment for smoking cessation in patients with COPD?",
    "explanation":
        "Combination therapy with pharmacologic agents like varenicline and counseling increases long-term success rates for smoking cessation.",
    "incorrect_answer": [
      "Nicotine gum alone",
      "Counseling alone",
      "E-cigarettes"
    ],
    "correct_answer": ["Combination of pharmacologic therapy and counseling"],
    "topic_name": "Pulmonary Medicine",
    "category": "COPD Management",
    "level": 1,
    "status": 1,
    "exam_title": "Acute Care NP Exam Prep 2024"
  },
  {
    "uuid": "q231",
    "question":
        "Which of the following is the primary imaging modality for the diagnosis of interstitial lung disease?",
    "explanation":
        "High-resolution CT (HRCT) of the chest is the gold standard imaging modality for diagnosing interstitial lung disease due to its ability to visualize fine lung details.",
    "incorrect_answer": [
      "Chest X-ray",
      "Ventilation-perfusion (V/Q) scan",
      "Pulmonary angiography"
    ],
    "correct_answer": ["High-resolution CT (HRCT)"],
    "topic_name": "Pulmonary Medicine",
    "category": "Interstitial Lung Diseases",
    "level": 2,
    "status": 1,
    "exam_title": "Acute Care NP Exam Prep 2024"
  },
  {
    "uuid": "q232",
    "question":
        "A patient with advanced COPD presents with hypercapnia. What is the best non-invasive intervention to improve ventilation?",
    "explanation":
        "Non-invasive positive pressure ventilation (e.g., BiPAP) improves ventilation and reduces CO2 retention in hypercapnic COPD patients.",
    "incorrect_answer": [
      "High-flow nasal cannula (HFNC)",
      "Supplemental oxygen therapy",
      "Invasive mechanical ventilation"
    ],
    "correct_answer": ["Non-invasive positive pressure ventilation (BiPAP)"],
    "topic_name": "Pulmonary Medicine",
    "category": "Critical Care",
    "level": 2,
    "status": 1,
    "exam_title": "Acute Care NP Exam Prep 2024"
  },
  {
    "uuid": "q233",
    "question":
        "What is the preferred diagnostic test for identifying obstructive sleep apnea?",
    "explanation":
        "Polysomnography, or sleep study, is the gold standard diagnostic test for obstructive sleep apnea, evaluating apneas, hypopneas, and oxygen desaturations.",
    "incorrect_answer": [
      "Chest X-ray",
      "Arterial blood gas analysis",
      "Overnight oximetry"
    ],
    "correct_answer": ["Polysomnography"],
    "topic_name": "Pulmonary Medicine",
    "category": "Sleep Disorders",
    "level": 1,
    "status": 1,
    "exam_title": "Acute Care NP Exam Prep 2024"
  },
  {
    "uuid": "q234",
    "question":
        "A 45-year-old male presents with a history of recurrent lung infections and foul-smelling sputum. High-resolution CT reveals bronchial wall thickening and dilated airways. What is the most likely diagnosis?",
    "explanation":
        "Bronchiectasis is characterized by recurrent infections, chronic sputum production, and airway dilation on imaging.",
    "incorrect_answer": [
      "Chronic obstructive pulmonary disease",
      "Pulmonary fibrosis",
      "Asthma"
    ],
    "correct_answer": ["Bronchiectasis"],
    "topic_name": "Pulmonary Medicine",
    "category": "Chronic Respiratory Diseases",
    "level": 2,
    "status": 1,
    "exam_title": "Acute Care NP Exam Prep 2024"
  },
  {
    "uuid": "q235",
    "question":
        "Which of the following conditions is most strongly associated with silicosis?",
    "explanation":
        "Occupational exposure to silica dust, such as in mining or sandblasting, is a key risk factor for silicosis.",
    "incorrect_answer": [
      "Asbestos exposure",
      "Secondhand smoke",
      "Chronic asthma"
    ],
    "correct_answer": ["Occupational exposure to silica"],
    "topic_name": "Pulmonary Medicine",
    "category": "Occupational Lung Diseases",
    "level": 2,
    "status": 1,
    "exam_title": "Acute Care NP Exam Prep 2024"
  },
  {
    "uuid": "q236",
    "question":
        "What is the primary goal of oxygen therapy in patients with chronic hypoxemia?",
    "explanation":
        "Oxygen therapy aims to maintain oxygen saturation above 88-92%, preventing hypoxemic complications such as pulmonary hypertension.",
    "incorrect_answer": [
      "To improve exercise tolerance",
      "To cure chronic obstructive pulmonary disease",
      "To reduce carbon dioxide levels"
    ],
    "correct_answer": ["To maintain oxygen saturation >88%"],
    "topic_name": "Pulmonary Medicine",
    "category": "Chronic Respiratory Diseases",
    "level": 1,
    "status": 1,
    "exam_title": "Acute Care NP Exam Prep 2024"
  },
  {
    "uuid": "q237",
    "question":
        "Which of the following findings is most characteristic of idiopathic pulmonary fibrosis on chest imaging?",
    "explanation":
        "Honeycombing on high-resolution CT is a classic finding in idiopathic pulmonary fibrosis.",
    "incorrect_answer": [
      "Pleural effusion",
      "Bilateral hilar lymphadenopathy",
      "Consolidation"
    ],
    "correct_answer": ["Honeycombing"],
    "topic_name": "Pulmonary Medicine",
    "category": "Interstitial Lung Diseases",
    "level": 2,
    "status": 1,
    "exam_title": "Acute Care NP Exam Prep 2024"
  },
  {
    "uuid": "q238",
    "question":
        "A 30-year-old female presents with sudden onset dyspnea and pleuritic chest pain after a long flight. What is the most likely diagnosis?",
    "explanation":
        "Pulmonary embolism is a common cause of sudden dyspnea and pleuritic chest pain in patients with prolonged immobility, such as during a long flight.",
    "incorrect_answer": [
      "Pneumonia",
      "Spontaneous pneumothorax",
      "Asthma exacerbation"
    ],
    "correct_answer": ["Pulmonary embolism"],
    "topic_name": "Pulmonary Medicine",
    "category": "Pulmonary Embolism",
    "level": 1,
    "status": 1,
    "exam_title": "Acute Care NP Exam Prep 2024"
  },
  {
    "uuid": "q239",
    "question":
        "What is the hallmark feature of bronchial breath sounds heard during auscultation?",
    "explanation":
        "Bronchial breath sounds are characterized by a high-pitched, hollow sound, with an equal inspiratory and expiratory phase.",
    "incorrect_answer": [
      "Decreased breath sounds",
      "Vesicular breath sounds",
      "Crackles"
    ],
    "correct_answer": ["High-pitched, hollow sounds with equal phases"],
    "topic_name": "Pulmonary Medicine",
    "category": "Physical Examination",
    "level": 1,
    "status": 1,
    "exam_title": "Acute Care NP Exam Prep 2024"
  },
  {
    "uuid": "q240",
    "question":
        "A patient with COPD is started on a long-acting muscarinic antagonist (LAMA). What is the primary effect of this medication?",
    "explanation":
        "LAMA medications reduce airway smooth muscle contraction by blocking muscarinic receptors, improving airflow and reducing symptoms.",
    "incorrect_answer": [
      "Stimulates beta-2 adrenergic receptors",
      "Reduces inflammation in the airways",
      "Thins airway secretions"
    ],
    "correct_answer": [
      "Relaxes airway smooth muscle by blocking muscarinic receptors"
    ],
    "topic_name": "Pulmonary Medicine",
    "category": "COPD Management",
    "level": 2,
    "status": 1,
    "exam_title": "Acute Care NP Exam Prep 2024"
  },
  {
    "uuid": "q241",
    "question":
        "Which of the following conditions is most commonly associated with exudative pleural effusion?",
    "explanation":
        "Exudative pleural effusions are commonly caused by pneumonia, malignancy, or tuberculosis, due to increased capillary permeability.",
    "incorrect_answer": [
      "Congestive heart failure",
      "Nephrotic syndrome",
      "Cirrhosis"
    ],
    "correct_answer": ["Pneumonia"],
    "topic_name": "Pulmonary Medicine",
    "category": "Pleural Diseases",
    "level": 2,
    "status": 1,
    "exam_title": "Acute Care NP Exam Prep 2024"
  },
  {
    "uuid": "q242",
    "question":
        "What is the most common presenting symptom of pulmonary hypertension?",
    "explanation":
        "Dyspnea on exertion is the most common initial symptom of pulmonary hypertension due to increased pulmonary vascular resistance.",
    "incorrect_answer": ["Chest pain", "Hemoptysis", "Cough"],
    "correct_answer": ["Dyspnea on exertion"],
    "topic_name": "Pulmonary Medicine",
    "category": "Pulmonary Hypertension",
    "level": 2,
    "status": 1,
    "exam_title": "Acute Care NP Exam Prep 2024"
  },
  {
    "uuid": "q243",
    "question":
        "Which pulmonary function test finding is characteristic of obstructive lung disease?",
    "explanation":
        "A decreased FEV1/FVC ratio is the hallmark finding in obstructive lung diseases such as asthma or COPD.",
    "incorrect_answer": [
      "Decreased total lung capacity",
      "Normal FEV1/FVC ratio",
      "Increased FEV1"
    ],
    "correct_answer": ["Decreased FEV1/FVC ratio"],
    "topic_name": "Pulmonary Medicine",
    "category": "Pulmonary Function Testing",
    "level": 1,
    "status": 1,
    "exam_title": "Acute Care NP Exam Prep 2024"
  },
  {
    "uuid": "q244",
    "question":
        "A patient with asthma is experiencing frequent nighttime symptoms and requires albuterol use daily. What is the next step in management?",
    "explanation":
        "Adding an inhaled corticosteroid is the next step for patients with persistent asthma to reduce inflammation and improve control.",
    "incorrect_answer": [
      "Increase the dose of albuterol",
      "Start a leukotriene receptor antagonist",
      "Add a long-acting beta-agonist (LABA)"
    ],
    "correct_answer": ["Add an inhaled corticosteroid"],
    "topic_name": "Pulmonary Medicine",
    "category": "Asthma Management",
    "level": 1,
    "status": 1,
    "exam_title": "Acute Care NP Exam Prep 2024"
  },
  {
    "uuid": "q245",
    "question":
        "What is the classic finding on a chest X-ray for a patient with tension pneumothorax?",
    "explanation":
        "Tension pneumothorax often presents with a mediastinal shift to the opposite side due to increased intrathoracic pressure.",
    "incorrect_answer": [
      "Ground-glass opacities",
      "Consolidation",
      "Pleural effusion"
    ],
    "correct_answer": ["Mediastinal shift to the opposite side"],
    "topic_name": "Pulmonary Medicine",
    "category": "Pleural Diseases",
    "level": 2,
    "status": 1,
    "exam_title": "Acute Care NP Exam Prep 2024"
  },
  {
    "uuid": "q246",
    "question":
        "Which of the following is the first-line treatment for mild persistent asthma?",
    "explanation":
        "Inhaled corticosteroids are the cornerstone treatment for mild persistent asthma to reduce airway inflammation.",
    "incorrect_answer": [
      "Short-acting beta-agonists (SABA) alone",
      "Leukotriene receptor antagonists",
      "Oral corticosteroids"
    ],
    "correct_answer": ["Inhaled corticosteroids"],
    "topic_name": "Pulmonary Medicine",
    "category": "Asthma Management",
    "level": 1,
    "status": 1,
    "exam_title": "Acute Care NP Exam Prep 2024"
  },
  {
    "uuid": "q247",
    "question": "What is the gold standard diagnostic test for tuberculosis?",
    "explanation":
        "Sputum culture is the gold standard test for diagnosing active tuberculosis and identifying the causative organism.",
    "incorrect_answer": [
      "Chest X-ray",
      "Tuberculin skin test",
      "Interferon-gamma release assay (IGRA)"
    ],
    "correct_answer": ["Sputum culture"],
    "topic_name": "Pulmonary Medicine",
    "category": "Respiratory Infections",
    "level": 2,
    "status": 1,
    "exam_title": "Acute Care NP Exam Prep 2024"
  },
  {
    "uuid": "q248",
    "question":
        "Which acid-base abnormality is most commonly associated with acute asthma exacerbation?",
    "explanation":
        "Respiratory alkalosis occurs early in acute asthma exacerbations due to hyperventilation.",
    "incorrect_answer": [
      "Metabolic acidosis",
      "Respiratory acidosis",
      "Metabolic alkalosis"
    ],
    "correct_answer": ["Respiratory alkalosis"],
    "topic_name": "Pulmonary Medicine",
    "category": "Acid-Base Disorders",
    "level": 1,
    "status": 1,
    "exam_title": "Acute Care NP Exam Prep 2024"
  },
  {
    "uuid": "q249",
    "question":
        "A 70-year-old male with COPD presents with new-onset hypoxemia and confusion. Chest X-ray shows hyperinflated lungs. What is the most likely cause of his symptoms?",
    "explanation":
        "Hypercapnic respiratory failure is common in COPD exacerbations and leads to confusion and hypoxemia.",
    "incorrect_answer": [
      "Pulmonary embolism",
      "Pneumothorax",
      "Acute respiratory distress syndrome (ARDS)"
    ],
    "correct_answer": ["Hypercapnic respiratory failure"],
    "topic_name": "Pulmonary Medicine",
    "category": "COPD Management",
    "level": 2,
    "status": 1,
    "exam_title": "Acute Care NP Exam Prep 2024"
  },
  {
    "uuid": "q250",
    "question":
        "What is the mechanism of action of long-acting beta-agonists (LABAs) in asthma management?",
    "explanation":
        "LABAs stimulate beta-2 adrenergic receptors, causing prolonged relaxation of airway smooth muscles and improved airflow.",
    "incorrect_answer": [
      "Inhibit muscarinic receptors",
      "Reduce airway inflammation",
      "Block leukotriene pathways"
    ],
    "correct_answer": ["Stimulate beta-2 adrenergic receptors"],
    "topic_name": "Pulmonary Medicine",
    "category": "Asthma Management",
    "level": 1,
    "status": 1,
    "exam_title": "Acute Care NP Exam Prep 2024"
  },
  {
    "uuid": "q251",
    "question":
        "Which imaging modality is most sensitive for detecting early interstitial lung disease?",
    "explanation":
        "High-resolution computed tomography (HRCT) is the most sensitive imaging modality for detecting interstitial lung disease, as it provides detailed visualization of lung parenchyma.",
    "incorrect_answer": [
      "Chest X-ray",
      "Ventilation-perfusion (V/Q) scan",
      "MRI of the chest"
    ],
    "correct_answer": ["High-resolution computed tomography (HRCT)"],
    "topic_name": "Pulmonary Medicine",
    "category": "Interstitial Lung Diseases",
    "level": 2,
    "status": 1,
    "exam_title": "Acute Care NP Exam Prep 2024"
  },
  {
    "uuid": "q252",
    "question":
        "Which pathogen is most commonly associated with opportunistic infections in patients with advanced HIV and a CD4 count below 200 cells/μL?",
    "explanation":
        "Pneumocystis jirovecii is the most common cause of opportunistic pneumonia in HIV patients with a low CD4 count.",
    "incorrect_answer": [
      "Mycobacterium tuberculosis",
      "Aspergillus fumigatus",
      "Histoplasma capsulatum"
    ],
    "correct_answer": ["Pneumocystis jirovecii"],
    "topic_name": "Pulmonary Medicine",
    "category": "Respiratory Infections",
    "level": 3,
    "status": 1,
    "exam_title": "Acute Care NP Exam Prep 2024"
  },
  {
    "uuid": "q253",
    "question":
        "Which medication is recommended for the treatment of exercise-induced bronchoconstriction?",
    "explanation":
        "Short-acting beta-agonists (SABAs) like albuterol are effective for preventing exercise-induced bronchoconstriction when used prior to exercise.",
    "incorrect_answer": [
      "Inhaled corticosteroids",
      "Leukotriene receptor antagonists",
      "Anticholinergics"
    ],
    "correct_answer": ["Short-acting beta-agonists (SABAs)"],
    "topic_name": "Pulmonary Medicine",
    "category": "Asthma Management",
    "level": 1,
    "status": 1,
    "exam_title": "Acute Care NP Exam Prep 2024"
  },
  {
    "uuid": "q254",
    "question":
        "A 60-year-old patient with a history of asbestos exposure presents with progressive dyspnea and weight loss. Imaging shows pleural thickening and calcifications. What is the most likely diagnosis?",
    "explanation":
        "Mesothelioma is strongly associated with asbestos exposure and often presents with pleural thickening and calcifications.",
    "incorrect_answer": [
      "Adenocarcinoma of the lung",
      "Small cell lung cancer",
      "Pulmonary fibrosis"
    ],
    "correct_answer": ["Mesothelioma"],
    "topic_name": "Pulmonary Medicine",
    "category": "Oncology",
    "level": 3,
    "status": 1,
    "exam_title": "Acute Care NP Exam Prep 2024"
  },
  {
    "uuid": "q255",
    "question": "What is the most common complication of bronchoscopy?",
    "explanation":
        "Bleeding is the most common complication of bronchoscopy, especially if a biopsy is performed.",
    "incorrect_answer": ["Pneumothorax", "Infection", "Respiratory failure"],
    "correct_answer": ["Bleeding"],
    "topic_name": "Pulmonary Medicine",
    "category": "Procedures",
    "level": 2,
    "status": 1,
    "exam_title": "Acute Care NP Exam Prep 2024"
  },
  {
    "uuid": "q256",
    "question":
        "What is the primary mechanism of hypoxemia in acute respiratory distress syndrome (ARDS)?",
    "explanation":
        "Shunting is the primary mechanism of hypoxemia in ARDS due to alveolar collapse and non-ventilated perfused lung units.",
    "incorrect_answer": [
      "Hypoventilation",
      "Diffusion impairment",
      "Decreased cardiac output"
    ],
    "correct_answer": ["Shunting"],
    "topic_name": "Pulmonary Medicine",
    "category": "Critical Care",
    "level": 3,
    "status": 1,
    "exam_title": "Acute Care NP Exam Prep 2024"
  },
  {
    "uuid": "q257",
    "question":
        "What is the recommended treatment for a 25-year-old patient with primary spontaneous pneumothorax involving 20% of the hemithorax?",
    "explanation":
        "Observation is recommended for small primary spontaneous pneumothoraces involving less than 30% of the hemithorax.",
    "incorrect_answer": [
      "Needle aspiration",
      "Chest tube placement",
      "Surgical intervention"
    ],
    "correct_answer": ["Observation"],
    "topic_name": "Pulmonary Medicine",
    "category": "Pleural Diseases",
    "level": 1,
    "status": 1,
    "exam_title": "Acute Care NP Exam Prep 2024"
  },
  {
    "uuid": "q258",
    "question":
        "Which of the following is a key component of long-term oxygen therapy in COPD patients?",
    "explanation":
        "Long-term oxygen therapy is indicated for COPD patients with chronic hypoxemia (PaO2 ≤ 55 mm Hg or SpO2 ≤ 88%).",
    "incorrect_answer": [
      "Used only during exertion",
      "Recommended for all COPD patients",
      "Avoided to prevent oxygen toxicity"
    ],
    "correct_answer": ["Indicated for patients with PaO2 ≤ 55 mm Hg"],
    "topic_name": "Pulmonary Medicine",
    "category": "COPD Management",
    "level": 2,
    "status": 1,
    "exam_title": "Acute Care NP Exam Prep 2024"
  },
  {
    "uuid": "q259",
    "question":
        "Which cytokine plays a major role in the pathogenesis of sarcoidosis?",
    "explanation":
        "Tumor necrosis factor-alpha (TNF-α) is involved in granuloma formation and is a key mediator in sarcoidosis.",
    "incorrect_answer": [
      "Interleukin-4 (IL-4)",
      "Interleukin-10 (IL-10)",
      "Transforming growth factor-beta (TGF-β)"
    ],
    "correct_answer": ["Tumor necrosis factor-alpha (TNF-α)"],
    "topic_name": "Pulmonary Medicine",
    "category": "Immunology",
    "level": 3,
    "status": 1,
    "exam_title": "Acute Care NP Exam Prep 2024"
  },
  {
    "uuid": "q260",
    "question": "What is the most common presenting symptom of bronchiectasis?",
    "explanation":
        "Chronic productive cough with copious sputum is the hallmark symptom of bronchiectasis.",
    "incorrect_answer": [
      "Dyspnea on exertion",
      "Chest pain",
      "Hemoptysis without sputum"
    ],
    "correct_answer": ["Chronic productive cough with copious sputum"],
    "topic_name": "Pulmonary Medicine",
    "category": "Bronchiectasis",
    "level": 2,
    "status": 1,
    "exam_title": "Acute Care NP Exam Prep 2024"
  },
  {
    "uuid": "q261",
    "question":
        "Which pulmonary function test result is characteristic of obstructive lung disease?",
    "explanation":
        "A reduced FEV1/FVC ratio is the hallmark of obstructive lung diseases such as COPD and asthma.",
    "incorrect_answer": [
      "Increased total lung capacity",
      "Normal FEV1/FVC ratio",
      "Decreased diffusing capacity of the lungs for carbon monoxide (DLCO)"
    ],
    "correct_answer": ["Reduced FEV1/FVC ratio"],
    "topic_name": "Pulmonary Medicine",
    "category": "Pulmonary Function Testing",
    "level": 2,
    "status": 1,
    "exam_title": "Acute Care NP Exam Prep 2024"
  },
  {
    "uuid": "q262",
    "question":
        "What is the preferred imaging modality for staging lung cancer?",
    "explanation":
        "Positron emission tomography-computed tomography (PET-CT) is used to assess metastatic spread in lung cancer staging.",
    "incorrect_answer": [
      "Chest X-ray",
      "High-resolution CT (HRCT)",
      "MRI of the chest"
    ],
    "correct_answer": [
      "Positron emission tomography-computed tomography (PET-CT)"
    ],
    "topic_name": "Pulmonary Medicine",
    "category": "Oncology",
    "level": 3,
    "status": 1,
    "exam_title": "Acute Care NP Exam Prep 2024"
  },
  {
    "uuid": "q263",
    "question":
        "Which condition is characterized by digital clubbing and abnormal proliferation of connective tissue in the nail beds?",
    "explanation":
        "Digital clubbing is a common finding in diseases such as bronchiectasis, lung cancer, and interstitial lung disease.",
    "incorrect_answer": [
      "Asthma",
      "Chronic bronchitis",
      "COPD without bronchiectasis"
    ],
    "correct_answer": ["Bronchiectasis"],
    "topic_name": "Pulmonary Medicine",
    "category": "Clinical Signs",
    "level": 2,
    "status": 1,
    "exam_title": "Acute Care NP Exam Prep 2024"
  },
  {
    "uuid": "q264",
    "question":
        "What is the recommended diagnostic test for confirming obstructive sleep apnea (OSA)?",
    "explanation":
        "Polysomnography (sleep study) is the gold standard for diagnosing obstructive sleep apnea.",
    "incorrect_answer": [
      "Spirometry",
      "Overnight pulse oximetry",
      "Chest X-ray"
    ],
    "correct_answer": ["Polysomnography (sleep study)"],
    "topic_name": "Pulmonary Medicine",
    "category": "Sleep Disorders",
    "level": 1,
    "status": 1,
    "exam_title": "Acute Care NP Exam Prep 2024"
  },
  {
    "uuid": "q265",
    "question":
        "What is the primary mechanism of action of inhaled corticosteroids in asthma management?",
    "explanation":
        "Inhaled corticosteroids reduce airway inflammation by inhibiting cytokine production and inflammatory cell infiltration.",
    "incorrect_answer": [
      "Bronchodilation",
      "Inhibition of leukotrienes",
      "Relaxation of airway smooth muscles"
    ],
    "correct_answer": ["Reduction of airway inflammation"],
    "topic_name": "Pulmonary Medicine",
    "category": "Asthma Management",
    "level": 1,
    "status": 1,
    "exam_title": "Acute Care NP Exam Prep 2024"
  },
  {
    "uuid": "q266",
    "question":
        "A 45-year-old male with a history of chronic bronchitis presents with worsening dyspnea and peripheral edema. Which physical exam finding is most consistent with cor pulmonale?",
    "explanation":
        "Jugular venous distension (JVD) is a hallmark sign of cor pulmonale, indicating right heart failure.",
    "incorrect_answer": [
      "Wheezing",
      "Bibasilar crackles",
      "Tracheal deviation"
    ],
    "correct_answer": ["Jugular venous distension (JVD)"],
    "topic_name": "Pulmonary Medicine",
    "category": "Right Heart Failure",
    "level": 2,
    "status": 1,
    "exam_title": "Acute Care NP Exam Prep 2024"
  },
  {
    "uuid": "q267",
    "question":
        "Which antibiotic is most commonly used to treat Mycoplasma pneumoniae infection?",
    "explanation":
        "Azithromycin, a macrolide antibiotic, is the first-line treatment for Mycoplasma pneumoniae due to its efficacy against atypical pathogens.",
    "incorrect_answer": [
      "Amoxicillin",
      "Ciprofloxacin",
      "Trimethoprim-sulfamethoxazole"
    ],
    "correct_answer": ["Azithromycin"],
    "topic_name": "Pulmonary Medicine",
    "category": "Respiratory Infections",
    "level": 1,
    "status": 1,
    "exam_title": "Acute Care NP Exam Prep 2024"
  },
  {
    "uuid": "q268",
    "question":
        "What is the most appropriate initial step in the management of a tension pneumothorax?",
    "explanation":
        "Needle decompression is the first-line intervention for tension pneumothorax, relieving pressure and improving ventilation.",
    "incorrect_answer": [
      "Chest tube insertion",
      "Supplemental oxygen therapy",
      "Observation"
    ],
    "correct_answer": ["Needle decompression"],
    "topic_name": "Pulmonary Medicine",
    "category": "Emergency Management",
    "level": 2,
    "status": 1,
    "exam_title": "Acute Care NP Exam Prep 2024"
  },
  {
    "uuid": "q269",
    "question":
        "Which biomarker is most commonly used to evaluate exacerbations of chronic obstructive pulmonary disease (COPD)?",
    "explanation":
        "Elevated C-reactive protein (CRP) levels are associated with systemic inflammation and can be used to assess COPD exacerbations.",
    "incorrect_answer": ["Procalcitonin", "D-dimer", "Troponin"],
    "correct_answer": ["C-reactive protein (CRP)"],
    "topic_name": "Pulmonary Medicine",
    "category": "COPD Management",
    "level": 2,
    "status": 1,
    "exam_title": "Acute Care NP Exam Prep 2024"
  },
  {
    "uuid": "q270",
    "question":
        "What is the most common presenting symptom in patients with pulmonary hypertension?",
    "explanation":
        "Dyspnea on exertion is the most common symptom of pulmonary hypertension, as increased pulmonary vascular resistance affects oxygen exchange.",
    "incorrect_answer": ["Syncope", "Hemoptysis", "Pleuritic chest pain"],
    "correct_answer": ["Dyspnea on exertion"],
    "topic_name": "Pulmonary Medicine",
    "category": "Pulmonary Hypertension",
    "level": 2,
    "status": 1,
    "exam_title": "Acute Care NP Exam Prep 2024"
  },
  {
    "uuid": "q271",
    "question":
        "Which diagnostic criterion is required to confirm the diagnosis of ARDS (Acute Respiratory Distress Syndrome)?",
    "explanation":
        "Bilateral infiltrates on chest imaging are essential criteria for diagnosing ARDS, along with other clinical and oxygenation parameters.",
    "incorrect_answer": [
      "Pulmonary capillary wedge pressure >18 mm Hg",
      "FEV1/FVC ratio <70%",
      "Presence of pleural effusion"
    ],
    "correct_answer": ["Bilateral infiltrates on chest imaging"],
    "topic_name": "Pulmonary Medicine",
    "category": "Critical Care",
    "level": 3,
    "status": 1,
    "exam_title": "Acute Care NP Exam Prep 2024"
  },
  {
    "uuid": "q272",
    "question":
        "Which imaging study is most sensitive for detecting early interstitial lung disease?",
    "explanation":
        "High-resolution CT (HRCT) is the most sensitive imaging modality for evaluating interstitial lung diseases.",
    "incorrect_answer": ["Chest X-ray", "MRI of the chest", "PET-CT"],
    "correct_answer": ["High-resolution CT (HRCT)"],
    "topic_name": "Pulmonary Medicine",
    "category": "Interstitial Lung Diseases",
    "level": 2,
    "status": 1,
    "exam_title": "Acute Care NP Exam Prep 2024"
  },
  {
    "uuid": "q273",
    "question":
        "What is the first-line pharmacologic treatment for patients with pulmonary arterial hypertension (PAH)?",
    "explanation":
        "Endothelin receptor antagonists, such as bosentan, are commonly used as first-line treatment for pulmonary arterial hypertension.",
    "incorrect_answer": ["Beta-blockers", "Loop diuretics", "Anticoagulants"],
    "correct_answer": ["Endothelin receptor antagonists"],
    "topic_name": "Pulmonary Medicine",
    "category": "Pulmonary Hypertension",
    "level": 3,
    "status": 1,
    "exam_title": "Acute Care NP Exam Prep 2024"
  },
  {
    "uuid": "q274",
    "question":
        "A patient presents with acute onset dyspnea and pleuritic chest pain. What is the most appropriate initial test to evaluate for pulmonary embolism?",
    "explanation":
        "A D-dimer test is a useful initial screening tool to rule out pulmonary embolism in patients with low pretest probability.",
    "incorrect_answer": [
      "Chest X-ray",
      "High-resolution CT (HRCT)",
      "Arterial blood gas"
    ],
    "correct_answer": ["D-dimer blood test"],
    "topic_name": "Pulmonary Medicine",
    "category": "Pulmonary Embolism",
    "level": 2,
    "status": 1,
    "exam_title": "Acute Care NP Exam Prep 2024"
  },
  {
    "uuid": "q275",
    "question":
        "Which of the following medications is most appropriate for treating exercise-induced bronchoconstriction?",
    "explanation":
        "Inhaled short-acting beta-agonists, such as albuterol, are the preferred treatment for exercise-induced bronchoconstriction.",
    "incorrect_answer": [
      "Inhaled corticosteroids",
      "Leukotriene receptor antagonists",
      "Long-acting beta-agonists"
    ],
    "correct_answer": ["Inhaled short-acting beta-agonists"],
    "topic_name": "Pulmonary Medicine",
    "category": "Asthma Management",
    "level": 1,
    "status": 1,
    "exam_title": "Acute Care NP Exam Prep 2024"
  },
  {
    "uuid": "q276",
    "question":
        "What is the most common cause of secondary spontaneous pneumothorax?",
    "explanation":
        "COPD is the leading cause of secondary spontaneous pneumothorax, as it is associated with bullae formation.",
    "incorrect_answer": ["Lung cancer", "Tuberculosis", "Asthma"],
    "correct_answer": ["COPD"],
    "topic_name": "Pulmonary Medicine",
    "category": "Pleural Diseases",
    "level": 2,
    "status": 1,
    "exam_title": "Acute Care NP Exam Prep 2024"
  },
  {
    "uuid": "q277",
    "question":
        "A 60-year-old male presents with hemoptysis, weight loss, and a history of asbestos exposure. What is the most likely diagnosis?",
    "explanation":
        "Mesothelioma is strongly associated with asbestos exposure and often presents with hemoptysis and weight loss.",
    "incorrect_answer": [
      "Lung adenocarcinoma",
      "Small cell lung cancer",
      "Pulmonary fibrosis"
    ],
    "correct_answer": ["Mesothelioma"],
    "topic_name": "Pulmonary Medicine",
    "category": "Oncology",
    "level": 3,
    "status": 1,
    "exam_title": "Acute Care NP Exam Prep 2024"
  },
  {
    "uuid": "q278",
    "question":
        "What is the hallmark histologic feature of granulomatosis with polyangiitis (Wegener’s)?",
    "explanation":
        "Necrotizing granulomas are the hallmark histologic feature of granulomatosis with polyangiitis.",
    "incorrect_answer": [
      "Caseating granulomas",
      "Fibrosis with honeycombing",
      "Lymphoid aggregates"
    ],
    "correct_answer": ["Necrotizing granulomas"],
    "topic_name": "Pulmonary Medicine",
    "category": "Vasculitis",
    "level": 3,
    "status": 1,
    "exam_title": "Acute Care NP Exam Prep 2024"
  },
  {
    "uuid": "q279",
    "question":
        "Which condition is associated with increased risk of reactivation of latent tuberculosis infection?",
    "explanation":
        "Patients on immunosuppressive therapy, such as TNF-alpha inhibitors, are at increased risk of reactivating latent TB.",
    "incorrect_answer": [
      "Chronic kidney disease",
      "Chronic liver disease",
      "Asthma"
    ],
    "correct_answer": ["Use of TNF-alpha inhibitors"],
    "topic_name": "Pulmonary Medicine",
    "category": "Respiratory Infections",
    "level": 2,
    "status": 1,
    "exam_title": "Acute Care NP Exam Prep 2024"
  },
  {
    "uuid": "q280",
    "question":
        "What is the most common clinical presentation of bronchiectasis?",
    "explanation":
        "Chronic cough with large amounts of purulent sputum is the hallmark symptom of bronchiectasis.",
    "incorrect_answer": [
      "Dry cough and hemoptysis",
      "Exertional dyspnea",
      "Recurrent pneumothorax"
    ],
    "correct_answer": ["Chronic cough with purulent sputum"],
    "topic_name": "Pulmonary Medicine",
    "category": "Bronchiectasis",
    "level": 1,
    "status": 1,
    "exam_title": "Acute Care NP Exam Prep 2024"
  },
  {
    "uuid": "q281",
    "question":
        "Which pathogen is most commonly associated with ventilator-associated pneumonia (VAP)?",
    "explanation":
        "Pseudomonas aeruginosa is a frequent pathogen in ventilator-associated pneumonia, especially in patients in critical care settings.",
    "incorrect_answer": [
      "Streptococcus pneumoniae",
      "Legionella pneumophila",
      "Mycoplasma pneumoniae"
    ],
    "correct_answer": ["Pseudomonas aeruginosa"],
    "topic_name": "Pulmonary Medicine",
    "category": "Respiratory Infections",
    "level": 3,
    "status": 1,
    "exam_title": "Acute Care NP Exam Prep 2024"
  },
  {
    "uuid": "q282",
    "question":
        "What is the primary mechanism of action of ipratropium bromide in managing COPD?",
    "explanation":
        "Ipratropium bromide works as a muscarinic antagonist, leading to bronchodilation and improved airflow in COPD patients.",
    "incorrect_answer": [
      "Beta-2 receptor agonist",
      "Phosphodiesterase-4 inhibitor",
      "Mast cell stabilizer"
    ],
    "correct_answer": ["Muscarinic receptor antagonist"],
    "topic_name": "Pulmonary Medicine",
    "category": "COPD Management",
    "level": 2,
    "status": 1,
    "exam_title": "Acute Care NP Exam Prep 2024"
  },
  {
    "uuid": "q283",
    "question":
        "Which of the following is a contraindication to noninvasive positive pressure ventilation (NIPPV)?",
    "explanation":
        "NIPPV is contraindicated in patients with hemodynamic instability due to the need for close monitoring and potential for deterioration.",
    "incorrect_answer": [
      "Acute exacerbation of COPD",
      "Cardiogenic pulmonary edema",
      "Hypoxemic respiratory failure"
    ],
    "correct_answer": ["Hemodynamic instability"],
    "topic_name": "Pulmonary Medicine",
    "category": "Ventilator Management",
    "level": 3,
    "status": 1,
    "exam_title": "Acute Care NP Exam Prep 2024"
  },
  {
    "uuid": "q284",
    "question":
        "What is the most common presenting symptom in patients with pulmonary sarcoidosis?",
    "explanation":
        "Dry cough is a common presenting symptom in pulmonary sarcoidosis, often accompanied by dyspnea.",
    "incorrect_answer": ["Wheezing", "Hemoptysis", "Chest pain"],
    "correct_answer": ["Dry cough"],
    "topic_name": "Pulmonary Medicine",
    "category": "Interstitial Lung Diseases",
    "level": 2,
    "status": 1,
    "exam_title": "Acute Care NP Exam Prep 2024"
  },
  {
    "uuid": "q285",
    "question":
        "Which oxygen delivery device provides the highest fraction of inspired oxygen (FiO2)?",
    "explanation":
        "A non-rebreather mask can deliver nearly 100% FiO2 under optimal conditions.",
    "incorrect_answer": ["Nasal cannula", "Venturi mask", "Simple face mask"],
    "correct_answer": ["Non-rebreather mask"],
    "topic_name": "Pulmonary Medicine",
    "category": "Critical Care",
    "level": 1,
    "status": 1,
    "exam_title": "Acute Care NP Exam Prep 2024"
  },
  {
    "uuid": "q286",
    "question":
        "A patient with a history of asthma presents with recurrent episodes of productive cough, wheezing, and bronchiectasis. What is the most likely underlying diagnosis?",
    "explanation":
        "Allergic bronchopulmonary aspergillosis (ABPA) often presents with asthma, bronchiectasis, and recurrent productive cough.",
    "incorrect_answer": [
      "Cystic fibrosis",
      "Chronic bronchitis",
      "Bronchiolitis obliterans"
    ],
    "correct_answer": ["Allergic bronchopulmonary aspergillosis"],
    "topic_name": "Pulmonary Medicine",
    "category": "Asthma Management",
    "level": 3,
    "status": 1,
    "exam_title": "Acute Care NP Exam Prep 2024"
  },
  {
    "uuid": "q287",
    "question":
        "Which biomarker is most commonly used to monitor disease activity in pulmonary fibrosis?",
    "explanation":
        "Serum Krebs von den Lungen-6 (KL-6) is commonly used to monitor disease activity in pulmonary fibrosis.",
    "incorrect_answer": [
      "D-dimer",
      "Procalcitonin",
      "Angiotensin-converting enzyme (ACE)"
    ],
    "correct_answer": ["Krebs von den Lungen-6 (KL-6)"],
    "topic_name": "Pulmonary Medicine",
    "category": "Interstitial Lung Diseases",
    "level": 2,
    "status": 1,
    "exam_title": "Acute Care NP Exam Prep 2024"
  },
  {
    "uuid": "q288",
    "question":
        "Which imaging finding is most suggestive of tuberculosis (TB) reactivation?",
    "explanation":
        "Upper lobe cavitary lesions are a hallmark imaging feature of TB reactivation.",
    "incorrect_answer": [
      "Ground-glass opacities",
      "Bilateral pleural effusion",
      "Central hilar mass"
    ],
    "correct_answer": ["Upper lobe cavitary lesions"],
    "topic_name": "Pulmonary Medicine",
    "category": "Respiratory Infections",
    "level": 2,
    "status": 1,
    "exam_title": "Acute Care NP Exam Prep 2024"
  },
  {
    "uuid": "q289",
    "question":
        "What is the primary purpose of prone positioning in patients with ARDS?",
    "explanation":
        "Prone positioning improves oxygenation by redistributing perfusion to less dependent, better-ventilated lung areas.",
    "incorrect_answer": [
      "To prevent pressure ulcers",
      "To reduce ventilator-associated pneumonia",
      "To decrease pulmonary edema"
    ],
    "correct_answer": ["To improve oxygenation"],
    "topic_name": "Pulmonary Medicine",
    "category": "Critical Care",
    "level": 3,
    "status": 1,
    "exam_title": "Acute Care NP Exam Prep 2024"
  },
  {
    "uuid": "q290",
    "question":
        "Which of the following is the hallmark PFT finding in restrictive lung disease?",
    "explanation":
        "Reduced total lung capacity (TLC) is the hallmark finding in restrictive lung diseases.",
    "incorrect_answer": [
      "Decreased FEV1/FVC ratio",
      "Increased residual volume",
      "Normal diffusing capacity (DLCO)"
    ],
    "correct_answer": ["Reduced total lung capacity (TLC)"],
    "topic_name": "Pulmonary Medicine",
    "category": "Pulmonary Function Tests",
    "level": 2,
    "status": 1,
    "exam_title": "Acute Care NP Exam Prep 2024"
  },
  {
    "uuid": "q291",
    "question":
        "Which complication is most commonly associated with long-term mechanical ventilation?",
    "explanation":
        "Ventilator-associated pneumonia (VAP) is a common complication in patients undergoing prolonged mechanical ventilation.",
    "incorrect_answer": [
      "Pneumothorax",
      "Pulmonary embolism",
      "Tracheal stenosis"
    ],
    "correct_answer": ["Ventilator-associated pneumonia (VAP)"],
    "topic_name": "Pulmonary Medicine",
    "category": "Critical Care",
    "level": 2,
    "status": 1,
    "exam_title": "Acute Care NP Exam Prep 2024"
  },
  {
    "uuid": "q292",
    "question":
        "A 45-year-old male presents with dyspnea, fever, and a productive cough. A chest X-ray reveals a right lower lobe infiltrate. What is the most appropriate initial antibiotic for community-acquired pneumonia in a patient with no comorbidities?",
    "explanation":
        "Amoxicillin is a first-line treatment for community-acquired pneumonia in healthy adults without comorbidities.",
    "incorrect_answer": ["Levofloxacin", "Ceftriaxone", "Vancomycin"],
    "correct_answer": ["Amoxicillin"],
    "topic_name": "Pulmonary Medicine",
    "category": "Respiratory Infections",
    "level": 1,
    "status": 1,
    "exam_title": "Acute Care NP Exam Prep 2024"
  },
  {
    "uuid": "q293",
    "question":
        "Which diagnostic test is the gold standard for confirming obstructive sleep apnea?",
    "explanation":
        "Polysomnography is the gold standard diagnostic test for obstructive sleep apnea.",
    "incorrect_answer": ["Chest X-ray", "Arterial blood gas", "Echocardiogram"],
    "correct_answer": ["Polysomnography"],
    "topic_name": "Pulmonary Medicine",
    "category": "Sleep Disorders",
    "level": 2,
    "status": 1,
    "exam_title": "Acute Care NP Exam Prep 2024"
  },
  {
    "uuid": "q294",
    "question":
        "What is the most effective intervention to prevent acute exacerbations of COPD?",
    "explanation":
        "Smoking cessation is the most effective intervention to prevent COPD exacerbations and improve overall lung function.",
    "incorrect_answer": [
      "Inhaled corticosteroids",
      "Pulmonary rehabilitation",
      "Long-term oxygen therapy"
    ],
    "correct_answer": ["Smoking cessation"],
    "topic_name": "Pulmonary Medicine",
    "category": "COPD Management",
    "level": 1,
    "status": 1,
    "exam_title": "Acute Care NP Exam Prep 2024"
  },
  {
    "uuid": "q295",
    "question":
        "A 60-year-old patient presents with hemoptysis and weight loss. CT imaging reveals a peripheral lung mass. What is the most likely diagnosis?",
    "explanation":
        "Adenocarcinoma is the most common type of lung cancer and is often located peripherally in the lung.",
    "incorrect_answer": [
      "Small cell lung cancer",
      "Squamous cell carcinoma",
      "Mesothelioma"
    ],
    "correct_answer": ["Adenocarcinoma"],
    "topic_name": "Pulmonary Medicine",
    "category": "Oncology",
    "level": 3,
    "status": 1,
    "exam_title": "Acute Care NP Exam Prep 2024"
  },
  {
    "uuid": "q296",
    "question":
        "Which of the following is the hallmark finding in chest imaging for interstitial lung disease (ILD)?",
    "explanation":
        "Honeycombing on high-resolution CT is a classic finding in advanced interstitial lung disease.",
    "incorrect_answer": [
      "Bilateral pleural effusion",
      "Cavitary lesions",
      "Solitary pulmonary nodule"
    ],
    "correct_answer": ["Honeycombing"],
    "topic_name": "Pulmonary Medicine",
    "category": "Interstitial Lung Diseases",
    "level": 2,
    "status": 1,
    "exam_title": "Acute Care NP Exam Prep 2024"
  },
  {
    "uuid": "q297",
    "question":
        "What is the mechanism of action of tiotropium in the treatment of COPD?",
    "explanation":
        "Tiotropium is a long-acting muscarinic antagonist (LAMA) that improves airflow by preventing bronchoconstriction.",
    "incorrect_answer": [
      "Beta-2 agonist",
      "Phosphodiesterase-4 inhibitor",
      "Inhaled corticosteroid"
    ],
    "correct_answer": ["Long-acting muscarinic antagonist"],
    "topic_name": "Pulmonary Medicine",
    "category": "COPD Management",
    "level": 2,
    "status": 1,
    "exam_title": "Acute Care NP Exam Prep 2024"
  },
  {
    "uuid": "q298",
    "question":
        "Which of the following is the most common cause of chronic cough in non-smokers?",
    "explanation":
        "Postnasal drip syndrome, also known as upper airway cough syndrome, is the leading cause of chronic cough in non-smokers.",
    "incorrect_answer": [
      "Gastroesophageal reflux disease (GERD)",
      "Asthma",
      "Chronic bronchitis"
    ],
    "correct_answer": ["Postnasal drip syndrome"],
    "topic_name": "Pulmonary Medicine",
    "category": "Respiratory Symptoms",
    "level": 1,
    "status": 1,
    "exam_title": "Acute Care NP Exam Prep 2024"
  },
  {
    "uuid": "q299",
    "question":
        "A 70-year-old male with a history of COPD is started on long-term oxygen therapy. What is the primary indication for initiating oxygen therapy in such patients?",
    "explanation":
        "Long-term oxygen therapy is indicated for patients with chronic hypoxemia, defined as PaO2 ≤ 55 mmHg or SpO2 ≤ 88%.",
    "incorrect_answer": [
      "Frequent COPD exacerbations",
      "Severe dyspnea",
      "Pulmonary hypertension"
    ],
    "correct_answer": ["Chronic hypoxemia (PaO2 ≤ 55 mmHg)"],
    "topic_name": "Pulmonary Medicine",
    "category": "COPD Management",
    "level": 2,
    "status": 1,
    "exam_title": "Acute Care NP Exam Prep 2024"
  },
  {
    "uuid": "q300",
    "question":
        "What is the most common cause of pleuritic chest pain in young, healthy adults?",
    "explanation":
        "Viral pleuritis, often caused by respiratory viruses, is a common cause of pleuritic chest pain in young adults.",
    "incorrect_answer": ["Pulmonary embolism", "Pneumothorax", "Lung abscess"],
    "correct_answer": ["Viral pleuritis"],
    "topic_name": "Pulmonary Medicine",
    "category": "Pleural Diseases",
    "level": 1,
    "status": 1,
    "exam_title": "Acute Care NP Exam Prep 2024"
  }
];
