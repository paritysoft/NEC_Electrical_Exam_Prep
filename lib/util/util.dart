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
String getExamDate(){

  String currentDate = SharedPreferenceHelper.getExamDate()?.split('T').first ?? "01/01/2026";
  return currentDate;
}
String yourDBKey = dotenv.env["YOUR_DB_KEY"]!;
String your_db_pass = dotenv.env["YOUR_DB_PASS_KEY"]!;

List<Map<String, dynamic>> quizzesJsonList = [
  {
    "uuid": "1a2b3c4d5e6f7g8h9i0j",
    "question": "What is the primary purpose of a generator's stator?",
    "explanation":
        "The stator in a generator produces a magnetic field that interacts with the rotor to induce a current in the windings.",
    "incorrect_answer":
        '["【1】To regulate voltage","【2】To house the cooling system","【3】To protect against overload"]',
    "correct_answer": '["【0】To produce a magnetic field"]',
    "topic_name": "Electrical Equipment and Devices",
    "category": "Basic Components",
    "level": 2,
    "status": 1,
    "exam_title": "Electrician Exam Prep Pro 2024"
  },
  {
    "uuid": "1b2c3d4e5f6g7h8i9j0k",
    "question":
        "What type of motor is commonly used in residential HVAC systems?",
    "explanation":
        "A single-phase induction motor is commonly used in residential HVAC systems due to its efficiency and reliability.",
    "incorrect_answer":
        '["【1】Three-phase motor","【2】Universal motor","【3】Synchronous motor"]',
    "correct_answer": '["【0】Single-phase induction motor"]',
    "topic_name": "Electrical Equipment and Devices",
    "category": "Motor Types",
    "level": 1,
    "status": 1,
    "exam_title": "Electrician Exam Prep Pro 2024"
  },
  {
    "uuid": "2c3d4e5f6g7h8i9j0k1l",
    "question": "What is an electrical feeder in a distribution system?",
    "explanation":
        "An electrical feeder is a conductor that carries current from the main service panel to a subpanel or large load.",
    "incorrect_answer":
        '["【1】A small circuit","【2】A branch circuit breaker","【3】A load conductor"]',
    "correct_answer": '["【0】A conductor carrying current to a subpanel"]',
    "topic_name": "Electrical Feeders",
    "category": "Distribution Systems",
    "level": 1,
    "status": 1,
    "exam_title": "Electrician Exam Prep Pro 2024"
  },
  {
    "uuid": "2b3c4d5e6f7g8h9i0k1l",
    "question":
        "What is the purpose of the main disconnect switch in an electrical system?",
    "explanation":
        "The main disconnect switch allows for the complete disconnection of power to the electrical system for safety and maintenance.",
    "incorrect_answer":
        '["【1】To regulate voltage","【2】To provide surge protection","【3】To isolate circuits"]',
    "correct_answer": '["【0】To disconnect power completely"]',
    "topic_name": "Electrical Feeders",
    "category": "System Safety",
    "level": 1,
    "status": 1,
    "exam_title": "Electrician Exam Prep Pro 2024"
  },
  {
    "uuid": "3c4d5e6f7g8h9i0j1k2m",
    "question":
        "What special precaution is required for electrical installations in areas with explosive gases?",
    "explanation":
        "Equipment in these areas must be explosion-proof or intrinsically safe to prevent sparks or heat from causing an ignition.",
    "incorrect_answer":
        '["【1】Standard insulation","【2】Waterproofing","【3】Grounding only"]',
    "correct_answer": '["【0】Explosion-proof equipment"]',
    "topic_name": "Special Occupancies, Equipment, and Conditions",
    "category": "Safety Standards",
    "level": 3,
    "status": 1,
    "exam_title": "Electrician Exam Prep Pro 2024"
  },
  {
    "uuid": "4c5d6e7f8g9h0i1j2k3l",
    "question":
        "What is the typical operating voltage for solar photovoltaic systems?",
    "explanation":
        "Solar photovoltaic systems typically operate at low DC voltage, commonly around 12V, 24V, or 48V.",
    "incorrect_answer": '["【1】240V","【2】120V","【3】480V"]',
    "correct_answer": '["【0】12V, 24V, or 48V"]',
    "topic_name": "Renewable Energy Technologies",
    "category": "Energy Systems",
    "level": 2,
    "status": 1,
    "exam_title": "Electrician Exam Prep Pro 2024"
  },
  {
    "uuid": "5d6e7f8g9h0i1j2k3l4m",
    "question":
        "What type of current is generated by photovoltaic (PV) solar panels?",
    "explanation":
        "PV panels generate direct current (DC), which is then often converted to alternating current (AC) for household use.",
    "incorrect_answer": '["【1】AC","【2】VC","【3】AC and DC"]',
    "correct_answer": '["【0】DC"]',
    "topic_name": "Renewable Energy Technologies",
    "category": "Energy Systems",
    "level": 2,
    "status": 1,
    "exam_title": "Electrician Exam Prep Pro 2024"
  },
  {
    "uuid": "6d7e8f9g0h1i2j3k4l5m",
    "question":
        "What is the maximum allowable voltage drop in branch circuits according to NEC standards?",
    "explanation":
        "NEC recommends a maximum voltage drop of 3% in branch circuits to maintain energy efficiency and appliance performance.",
    "incorrect_answer": '["【1】5%","【2】2%","【3】4%"]',
    "correct_answer": '["【0】3%"]',
    "topic_name": "Branch Circuit Calculations and Conductors",
    "category": "Electrical Standards",
    "level": 2,
    "status": 1,
    "exam_title": "Electrician Exam Prep Pro 2024"
  },
  {
    "uuid": "7d8e9f0g1h2i3j4k5l6m",
    "question":
        "What is the purpose of derating conductors in a multi-wire branch circuit?",
    "explanation":
        "Derating is necessary to account for heat generated by multiple conductors bundled together, ensuring they do not exceed their temperature ratings.",
    "incorrect_answer":
        '["【1】Increase current flow","【2】Reduce wire length","【3】Improve insulation"]',
    "correct_answer": '["【0】Prevent overheating"]',
    "topic_name": "Branch Circuit Calculations and Conductors",
    "category": "Circuit Design",
    "level": 3,
    "status": 1,
    "exam_title": "Electrician Exam Prep Pro 2024"
  },
  {
    "uuid": "8e9f0g1h2i3j4k5l6m7n",
    "question":
        "What is the minimum burial depth for underground electrical cables?",
    "explanation":
        "The minimum burial depth for residential underground wiring is typically 24 inches, following NEC guidelines to prevent accidental contact.",
    "incorrect_answer": '["【1】18 inches","【2】36 inches","【3】12 inches"]',
    "correct_answer": '["【0】24 inches"]',
    "topic_name": "Electrical Wiring Methods and Electrical Materials",
    "category": "Installation Standards",
    "level": 2,
    "status": 1,
    "exam_title": "Electrician Exam Prep Pro 2024"
  },
  {
    "uuid": "9f0g1h2i3j4k5l6m7n8o",
    "question":
        "What type of conduit is commonly used for outdoor installations?",
    "explanation":
        "PVC conduit is widely used outdoors as it is resistant to corrosion and suitable for protecting wiring from environmental factors.",
    "incorrect_answer": '["【1】EMT","【2】Flexible metal","【3】Bare copper"]',
    "correct_answer": '["【0】PVC"]',
    "topic_name": "Electrical Wiring Methods and Electrical Materials",
    "category": "Material Selection",
    "level": 1,
    "status": 1,
    "exam_title": "Electrician Exam Prep Pro 2024"
  },
  {
    "uuid": "10g1h2i3j4k5l6m7n8o9p",
    "question":
        "What is the function of a contactor in electrical control devices?",
    "explanation":
        "A contactor controls the switching on and off of high-power circuits using a low-power signal.",
    "incorrect_answer":
        '["【1】Measures current","【2】Increases voltage","【3】Protects against surges"]',
    "correct_answer": '["【0】Controls switching"]',
    "topic_name": "Electrical Control Devices and Disconnecting Means",
    "category": "System Control",
    "level": 2,
    "status": 1,
    "exam_title": "Electrician Exam Prep Pro 2024"
  },
  {
    "uuid": "11h2i3j4k5l6m7n8o9p0q",
    "question":
        "In a service panel, what device is used to interrupt current in case of overload?",
    "explanation":
        "Circuit breakers are installed in the service panel to automatically disconnect power in case of an overload.",
    "incorrect_answer": '["【1】Contactors", "【2】Transformers", "【3】Relays"]',
    "correct_answer": '["【0】Circuit breakers"]',
    "topic_name": "Electrical Equipment and Devices",
    "category": "System Protection",
    "level": 1,
    "status": 1,
    "exam_title": "Electrician Exam Prep Pro 2024"
  },
  {
    "uuid": "12i3j4k5l6m7n8o9p0q1r",
    "question":
        "What is the National Electrical Code (NEC) definition of 'Ampacity'?",
    "explanation":
        "Ampacity refers to the maximum current a conductor can carry continuously without exceeding its temperature rating.",
    "incorrect_answer":
        '["【1】Voltage capacity", "【2】Load potential", "【3】Electrical insulation"]',
    "correct_answer": '["【0】Maximum current a conductor can carry"]',
    "topic_name": "Definitions, Calculations, Theory, and Plans",
    "category": "Code Knowledge",
    "level": 2,
    "status": 1,
    "exam_title": "Electrician Exam Prep Pro 2024"
  },
  {
    "uuid": "13j4k5l6m7n8o9p0q1r2s",
    "question":
        "How is conductor size for a feeder circuit typically determined?",
    "explanation":
        "Feeder conductor size is based on ampacity requirements and derating factors for temperature and conduit fill, following NEC calculations.",
    "incorrect_answer":
        '["【1】By voltage alone", "【2】By conduit type", "【3】By load power factor"]',
    "correct_answer": '["【0】By ampacity and derating factors"]',
    "topic_name": "Electrical Feeders",
    "category": "Circuit Design",
    "level": 3,
    "status": 1,
    "exam_title": "Electrician Exam Prep Pro 2024"
  },
  {
    "uuid": "14k5l6m7n8o9p0q1r2s3t",
    "question":
        "What is the proper way to size a circuit breaker for a residential kitchen circuit?",
    "explanation":
        "For kitchen circuits, it is typically sized at 20 amps for general-purpose circuits and 30 amps for dedicated appliances.",
    "incorrect_answer": '["【1】15 amps only", "【2】40 amps", "【3】10 amps"]',
    "correct_answer": '["【0】20 amps or 30 amps for dedicated"]',
    "topic_name": "Electrical Equipment and Devices",
    "category": "Load Calculation",
    "level": 1,
    "status": 1,
    "exam_title": "Electrician Exam Prep Pro 2024"
  },
  {
    "uuid": "15l6m7n8o9p0q1r2s3t4u",
    "question":
        "What is the purpose of a ground fault circuit interrupter (GFCI)?",
    "explanation":
        "GFCIs are designed to protect against electrical shock by monitoring current differences between the hot and neutral wires.",
    "incorrect_answer":
        '["【1】To increase voltage", "【2】To enhance conductivity", "【3】To reduce power loss"]',
    "correct_answer": '["【0】To protect against electrical shock"]',
    "topic_name": "Electrical Control Devices and Disconnecting Means",
    "category": "Safety Devices",
    "level": 2,
    "status": 1,
    "exam_title": "Electrician Exam Prep Pro 2024"
  },
  {
    "uuid": "16m7n8o9p0q1r2s3t4u5v",
    "question":
        "What is the most common type of wiring method used in residential construction?",
    "explanation":
        "Non-metallic sheathed cable (often referred to as Romex) is the most common wiring method in residential construction.",
    "incorrect_answer":
        '["【1】Rigid conduit", "【2】Flexible metal conduit", "【3】Direct burial cable"]',
    "correct_answer": '["【0】Non-metallic sheathed cable"]',
    "topic_name": "Electrical Wiring Methods and Electrical Materials",
    "category": "Wiring Methods",
    "level": 1,
    "status": 1,
    "exam_title": "Electrician Exam Prep Pro 2024"
  },
  {
    "uuid": "17n8o9p0q1r2s3t4u5v6w",
    "question":
        "What is the primary function of a transformer in an electrical system?",
    "explanation":
        "A transformer is used to change the voltage levels in an electrical system, either stepping it up or stepping it down.",
    "incorrect_answer":
        '["【1】To store electrical energy", "【2】To convert AC to DC", "【3】To increase current"]',
    "correct_answer": '["【0】To change voltage levels"]',
    "topic_name": "Electrical Equipment and Devices",
    "category": "Transformers",
    "level": 2,
    "status": 1,
    "exam_title": "Electrician Exam Prep Pro 2024"
  },
  {
    "uuid": "18o9p0q1r2s3t4u5v6w7x",
    "question": "What is the definition of short-circuit current?",
    "explanation":
        "Short-circuit current is the maximum current that flows when a fault occurs, leading to a direct connection between the supply and ground.",
    "incorrect_answer":
        '["【1】Normal operating current", "【2】Average current", "【3】Emergency current"]',
    "correct_answer": '["【0】Maximum current during a fault"]',
    "topic_name": "Definitions, Calculations, Theory, and Plans",
    "category": "Electrical Definitions",
    "level": 3,
    "status": 1,
    "exam_title": "Electrician Exam Prep Pro 2024"
  },
  {
    "uuid": "19p0q1r2s3t4u5v6w7x8y",
    "question":
        "What should be the first step in troubleshooting an electrical circuit?",
    "explanation":
        "The first step is to verify that power is available and the circuit is energized before proceeding with further testing.",
    "incorrect_answer":
        '["【1】Replace the circuit breaker", "【2】Check the load", "【3】Inspect the wiring"]',
    "correct_answer": '["【0】Verify power availability"]',
    "topic_name": "Electrical Control Devices and Disconnecting Means",
    "category": "Troubleshooting",
    "level": 2,
    "status": 1,
    "exam_title": "Electrician Exam Prep Pro 2024"
  },
  {
    "uuid": "20q1r2s3t4u5v6w7x8y9z",
    "question": "What is the function of a circuit breaker?",
    "explanation":
        "A circuit breaker protects electrical circuits from overload and short circuits by interrupting the current flow.",
    "incorrect_answer":
        '["【1】To amplify current", "【2】To regulate voltage", "【3】To serve as a fuse"]',
    "correct_answer": '["【0】To interrupt current flow"]',
    "topic_name": "Electrical Equipment and Devices",
    "category": "Protection Devices",
    "level": 1,
    "status": 1,
    "exam_title": "Electrician Exam Prep Pro 2024"
  },
  {
    "uuid": "21r2s3t4u5v6w7x8y9z0a",
    "question":
        "What is the recommended maximum voltage for low-voltage lighting systems?",
    "explanation":
        "Low-voltage lighting systems typically operate at 12V or 24V, which is safe for residential use.",
    "incorrect_answer": '["【1】120V", "【2】240V", "【3】480V"]',
    "correct_answer": '["【0】12V or 24V"]',
    "topic_name": "Renewable Energy Technologies",
    "category": "Low-Voltage Systems",
    "level": 1,
    "status": 1,
    "exam_title": "Electrician Exam Prep Pro 2024"
  },
  {
    "uuid": "22s3t4u5v6w7x8y9z0a1b",
    "question":
        "Which code provides regulations for the installation of electrical systems?",
    "explanation":
        "The National Electrical Code (NEC) provides regulations to ensure safe electrical installations across the United States.",
    "incorrect_answer":
        '["【1】OSHA regulations", "【2】Local building codes", "【3】Fire safety codes"]',
    "correct_answer": '["【0】National Electrical Code (NEC)"]',
    "topic_name": "Electrical Wiring Methods and Electrical Materials",
    "category": "Regulatory Standards",
    "level": 2,
    "status": 1,
    "exam_title": "Electrician Exam Prep Pro 2024"
  },
  {
    "uuid": "23t4u5v6w7x8y9z0a1b2c",
    "question":
        "What is the typical lifespan of LED lighting compared to incandescent bulbs?",
    "explanation":
        "LED lighting typically lasts 25,000 to 50,000 hours, significantly longer than incandescent bulbs which last around 1,000 hours.",
    "incorrect_answer":
        '["【1】10,000 hours", "【2】5,000 hours", "【3】2,000 hours"]',
    "correct_answer": '["【0】25,000 to 50,000 hours"]',
    "topic_name": "Electrical Equipment and Devices",
    "category": "Lighting Technologies",
    "level": 1,
    "status": 1,
    "exam_title": "Electrician Exam Prep Pro 2024"
  },
  {
    "uuid": "24u5v6w7x8y9z0a1b2c3d",
    "question": "What is the purpose of a surge protector?",
    "explanation":
        "Surge protectors are designed to protect electrical devices from voltage spikes by diverting excess voltage away from sensitive equipment.",
    "incorrect_answer":
        '["【1】To increase voltage", "【2】To limit current", "【3】To store energy"]',
    "correct_answer": '["【0】To protect against voltage spikes"]',
    "topic_name": "Electrical Equipment and Devices",
    "category": "Protection Devices",
    "level": 2,
    "status": 1,
    "exam_title": "Electrician Exam Prep Pro 2024"
  },
  {
    "uuid": "25v6w7x8y9z0a1b2c3d4e",
    "question": "What is the role of a relay in electrical circuits?",
    "explanation":
        "A relay is an electrically operated switch that uses an electromagnet to control the opening and closing of a circuit.",
    "incorrect_answer":
        '["【1】To measure voltage", "【2】To convert AC to DC", "【3】To protect against overload"]',
    "correct_answer": '["【0】To control switching"]',
    "topic_name": "Electrical Control Devices and Disconnecting Means",
    "category": "Control Devices",
    "level": 2,
    "status": 1,
    "exam_title": "Electrician Exam Prep Pro 2024"
  },
  {
    "uuid": "26w7x8y9z0a1b2c3d4e5f",
    "question":
        "What is the primary advantage of using a variable frequency drive (VFD) with motors?",
    "explanation":
        "VFDs allow for precise control of motor speed and torque, enhancing efficiency and reducing energy consumption.",
    "incorrect_answer":
        '["【1】Increases noise", "【2】Decreases efficiency", "【3】Adds complexity"]',
    "correct_answer": '["【0】Enhances efficiency"]',
    "topic_name": "Motors and Generators",
    "category": "Motor Control",
    "level": 2,
    "status": 1,
    "exam_title": "Electrician Exam Prep Pro 2024"
  },
  {
    "uuid": "27x8y9z0a1b2c3d4e5f6g",
    "question":
        "Which device is commonly used to provide overcurrent protection in circuits?",
    "explanation":
        "Fuses and circuit breakers are commonly used to provide overcurrent protection by interrupting the flow of electricity during overload conditions.",
    "incorrect_answer": '["【1】Transformers", "【2】Switches", "【3】Contactors"]',
    "correct_answer": '["【0】Fuses and circuit breakers"]',
    "topic_name": "Electrical Equipment and Devices",
    "category": "Protection Devices",
    "level": 1,
    "status": 1,
    "exam_title": "Electrician Exam Prep Pro 2024"
  },
  {
    "uuid": "28y9z0a1b2c3d4e5f6g7h",
    "question": "What is the role of a power factor correction capacitor?",
    "explanation":
        "Power factor correction capacitors are used to improve the power factor of a system, reducing losses and improving efficiency.",
    "incorrect_answer":
        '["【1】To decrease voltage", "【2】To increase inductance", "【3】To serve as a load"]',
    "correct_answer": '["【0】To improve power factor"]',
    "topic_name": "Motors and Generators",
    "category": "Power Quality",
    "level": 3,
    "status": 1,
    "exam_title": "Electrician Exam Prep Pro 2024"
  },
  {
    "uuid": "29z0a1b2c3d4e5f6g7h8i",
    "question":
        "What does the term 'harmonics' refer to in electrical systems?",
    "explanation":
        "Harmonics are voltage or current waveforms that are multiples of the fundamental frequency, which can cause distortion and inefficiency in systems.",
    "incorrect_answer":
        '["【1】Standard frequencies", "【2】Surge currents", "【3】Transient voltages"]',
    "correct_answer": '["【0】Multiples of fundamental frequency"]',
    "topic_name": "Electrical Control Devices and Disconnecting Means",
    "category": "Power Quality",
    "level": 3,
    "status": 1,
    "exam_title": "Electrician Exam Prep Pro 2024"
  },
  {
    "uuid": "30a1b2c3d4e5f6g7h8i9j",
    "question": "What is the purpose of an overload relay?",
    "explanation":
        "An overload relay protects motors from overheating due to excessive current by disconnecting the power supply when preset levels are exceeded.",
    "incorrect_answer":
        '["【1】To increase motor speed", "【2】To control voltage", "【3】To provide starting torque"]',
    "correct_answer": '["【0】To protect against overheating"]',
    "topic_name": "Motors and Generators",
    "category": "Motor Protection",
    "level": 2,
    "status": 1,
    "exam_title": "Electrician Exam Prep Pro 2024"
  },
  {
    "uuid": "31b2c3d4e5f6g7h8i9j0k",
    "question":
        "What is the typical installation height for a service disconnect switch?",
    "explanation":
        "Service disconnect switches are typically installed at a height of 5 to 6 feet above the floor to allow for easy access and visibility.",
    "incorrect_answer": '["【1】3 feet", "【2】8 feet", "【3】2 feet"]',
    "correct_answer": '["【0】5 to 6 feet"]',
    "topic_name": "Electrical Control Devices and Disconnecting Means",
    "category": "Installation Standards",
    "level": 1,
    "status": 1,
    "exam_title": "Electrician Exam Prep Pro 2024"
  },
  {
    "uuid": "32c3d4e5f6g7h8i9j0k1l",
    "question":
        "What type of cable is typically used for residential wiring in walls?",
    "explanation":
        "Romex, or NM cable, is commonly used for residential wiring as it combines conductors in a single insulated jacket, making installation easier.",
    "incorrect_answer":
        '["【1】Armored cable", "【2】Rigid conduit", "【3】Flexible conduit"]',
    "correct_answer": '["【0】Romex (NM cable)"]',
    "topic_name": "Electrical Wiring Methods and Electrical Materials",
    "category": "Wiring Materials",
    "level": 1,
    "status": 1,
    "exam_title": "Electrician Exam Prep Pro 2024"
  },
  {
    "uuid": "33d4e5f6g7h8i9j0k1l2m",
    "question": "What is the typical color code for a three-phase system?",
    "explanation":
        "In a typical three-phase system, the color code is commonly red, yellow, and blue for the three phases.",
    "incorrect_answer":
        '["【1】Black, red, blue", "【2】Green, white, black", "【3】Brown, orange, yellow"]',
    "correct_answer": '["【0】Red, yellow, blue"]',
    "topic_name": "Electrical Wiring Methods and Electrical Materials",
    "category": "Color Codes",
    "level": 1,
    "status": 1,
    "exam_title": "Electrician Exam Prep Pro 2024"
  },
  {
    "uuid": "34e5f6g7h8i9j0k1l2m3n",
    "question": "What is the primary advantage of using digital multimeters?",
    "explanation":
        "Digital multimeters provide precise readings and can measure multiple electrical parameters, including voltage, current, and resistance.",
    "incorrect_answer":
        '["【1】Only measure voltage", "【2】Increased size", "【3】Lower accuracy"]',
    "correct_answer": '["【0】Precise readings for multiple parameters"]',
    "topic_name": "Electrical Equipment and Devices",
    "category": "Measurement Tools",
    "level": 2,
    "status": 1,
    "exam_title": "Electrician Exam Prep Pro 2024"
  },
  {
    "uuid": "35f6g7h8i9j0k1l2m3n4o",
    "question":
        "What is the main purpose of a contactor in electrical systems?",
    "explanation":
        "Contactors are electrically operated switches used to control the flow of electricity in larger circuits, especially in motor control applications.",
    "incorrect_answer":
        '["【1】To reduce voltage", "【2】To measure current", "【3】To amplify signals"]',
    "correct_answer": '["【0】To control electricity in larger circuits"]',
    "topic_name": "Electrical Control Devices and Disconnecting Means",
    "category": "Control Devices",
    "level": 1,
    "status": 1,
    "exam_title": "Electrician Exam Prep Pro 2024"
  },
  {
    "uuid": "36g7h8i9j0k1l2m3n4o5p",
    "question":
        "What type of battery is commonly used in uninterruptible power supplies (UPS)?",
    "explanation":
        "Lead-acid batteries are commonly used in uninterruptible power supplies due to their reliability and cost-effectiveness.",
    "incorrect_answer":
        '["【1】Lithium-ion", "【2】Nickel-cadmium", "【3】Alkaline"]',
    "correct_answer": '["【0】Lead-acid"]',
    "topic_name": "Fundamentals of Electrical Theory",
    "category": "UPS Systems",
    "level": 1,
    "status": 1,
    "exam_title": "Electrician Exam Prep Pro 2024"
  },
  {
    "uuid": "37h8i9j0k1l2m3n4o5p6q",
    "question":
        "What is the primary function of a line reactor in electrical systems?",
    "explanation":
        "Line reactors are used to reduce harmonics and limit inrush current in motor applications, improving system stability.",
    "incorrect_answer":
        '["【1】To store energy", "【2】To convert voltage", "【3】To amplify signals"]',
    "correct_answer": '["【0】To reduce harmonics and limit inrush current"]',
    "topic_name": "Electrical Equipment and Devices",
    "category": "Motor Control",
    "level": 2,
    "status": 1,
    "exam_title": "Electrician Exam Prep Pro 2024"
  },
  {
    "uuid": "38i9j0k1l2m3n4o5p6q7r",
    "question": "What is the purpose of an electrical panel cover?",
    "explanation":
        "An electrical panel cover protects the internal components from dust, moisture, and unauthorized access, ensuring safety.",
    "incorrect_answer":
        '["【1】To increase efficiency", "【2】To cool the system", "【3】To enhance performance"]',
    "correct_answer": '["【0】To protect internal components"]',
    "topic_name": "Electrical Equipment and Devices",
    "category": "Panel Components",
    "level": 1,
    "status": 1,
    "exam_title": "Electrician Exam Prep Pro 2024"
  },
  {
    "uuid": "39j0k1l2m3n4o5p6q7r8s",
    "question": "What does a power quality analyzer measure?",
    "explanation":
        "A power quality analyzer measures various electrical parameters including voltage, current, frequency, and harmonics, helping to assess system performance.",
    "incorrect_answer":
        '["【1】Only voltage", "【2】Energy consumption", "【3】Load analysis only"]',
    "correct_answer": '["【0】Multiple electrical parameters"]',
    "topic_name": "Fundamentals of Electrical Theory",
    "category": "Measurement Tools",
    "level": 2,
    "status": 1,
    "exam_title": "Electrician Exam Prep Pro 2024"
  },
  {
    "uuid": "40k1l2m3n4o5p6q7r8s9t",
    "question":
        "What is the main advantage of using programmable logic controllers (PLCs)?",
    "explanation":
        "PLCs offer flexibility and can be easily programmed to perform various control tasks, making them ideal for automation in industrial applications.",
    "incorrect_answer":
        '["【1】Fixed operation", "【2】High cost", "【3】Limited functionality"]',
    "correct_answer": '["【0】Flexibility in programming"]',
    "topic_name": "Fundamentals of Electrical Theory",
    "category": "Automation",
    "level": 1,
    "status": 1,
    "exam_title": "Electrician Exam Prep Pro 2024"
  },
  {
    "uuid": "41l2m3n4o5p6q7r8s9t0a",
    "question": "What is the role of a photoelectric sensor in automation?",
    "explanation":
        "Photoelectric sensors detect changes in light levels and are commonly used for object detection and position sensing in automation systems.",
    "incorrect_answer":
        '["【1】To measure temperature", "【2】To amplify sound", "【3】To control pressure"]',
    "correct_answer": '["【0】To detect light changes"]',
    "topic_name": "Fundamentals of Electrical Theory",
    "category": "Sensing Devices",
    "level": 2,
    "status": 1,
    "exam_title": "Electrician Exam Prep Pro 2024"
  },
  {
    "uuid": "42m3n4o5p6q7r8s9t0a1b",
    "question": "What is the purpose of a fuse in an electrical circuit?",
    "explanation":
        "A fuse protects an electrical circuit by breaking the circuit when the current exceeds a specified level, preventing damage from overload.",
    "incorrect_answer":
        '["【1】To store energy", "【2】To enhance efficiency", "【3】To increase voltage"]',
    "correct_answer": '["【0】To protect from overload"]',
    "topic_name": "Electrical Equipment and Devices",
    "category": "Protection Devices",
    "level": 1,
    "status": 1,
    "exam_title": "Electrician Exam Prep Pro 2024"
  },
  {
    "uuid": "43n4o5p6q7r8s9t0a1b2c",
    "question": "What is the main purpose of an electrical ground?",
    "explanation":
        "The main purpose of an electrical ground is to provide a safe path for fault current to prevent electrical shock and equipment damage.",
    "incorrect_answer":
        '["【1】To increase voltage", "【2】To reduce power loss", "【3】To store energy"]',
    "correct_answer": '["【0】To provide a safe fault current path"]',
    "topic_name": "Fundamentals of Electrical Theory",
    "category": "Grounding",
    "level": 2,
    "status": 1,
    "exam_title": "Electrician Exam Prep Pro 2024"
  },
  {
    "uuid": "44o5p6q7r8s9t0a1b2c3d",
    "question": "What is the primary purpose of an isolation transformer?",
    "explanation":
        "Isolation transformers provide electrical isolation for equipment, reducing noise and improving safety by isolating sensitive devices from the power supply.",
    "incorrect_answer":
        '["【1】To increase voltage", "【2】To amplify current", "【3】To store energy"]',
    "correct_answer": '["【0】To provide electrical isolation"]',
    "topic_name": "Fundamentals of Electrical Theory",
    "category": "Isolation Devices",
    "level": 2,
    "status": 1,
    "exam_title": "Electrician Exam Prep Pro 2024"
  },
  {
    "uuid": "45p6q7r8s9t0a1b2c3d4e",
    "question": "What is the primary purpose of a current transformer?",
    "explanation":
        "Current transformers are used to measure alternating current (AC) by producing a secondary current proportional to the primary current, enabling safe monitoring.",
    "incorrect_answer":
        '["【1】To increase voltage", "【2】To store energy", "【3】To convert DC to AC"]',
    "correct_answer": '["【0】To measure AC current"]',
    "topic_name": "Fundamentals of Electrical Theory",
    "category": "Measurement Devices",
    "level": 1,
    "status": 1,
    "exam_title": "Electrician Exam Prep Pro 2024"
  },
  {
    "uuid": "46q7r8s9t0a1b2c3d4e5f",
    "question":
        "What is the typical installation location for a service panel?",
    "explanation":
        "Service panels are typically installed in a dry, accessible location, such as a basement or utility room, to facilitate maintenance and operation.",
    "incorrect_answer": '["【1】Near windows", "【2】In bathrooms", "【3】Outdoors"]',
    "correct_answer": '["【0】In dry, accessible locations"]',
    "topic_name": "Electrical Control Devices and Disconnecting Means",
    "category": "Installation Standards",
    "level": 1,
    "status": 1,
    "exam_title": "Electrician Exam Prep Pro 2024"
  },
  {
    "uuid": "47r8s9t0a1b2c3d4e5f6g",
    "question": "What is the primary advantage of using smart meters?",
    "explanation":
        "Smart meters provide real-time data on energy consumption, enabling consumers to monitor usage and optimize energy efficiency.",
    "incorrect_answer":
        '["【1】Only measure voltage", "【2】No remote access", "【3】Higher cost than traditional meters"]',
    "correct_answer": '["【0】Real-time energy monitoring"]',
    "topic_name": "Fundamentals of Electrical Theory",
    "category": "Smart Meters",
    "level": 1,
    "status": 1,
    "exam_title": "Electrician Exam Prep Pro 2024"
  },
  {
    "uuid": "48s9t0a1b2c3d4e5f6g7h",
    "question": "What is the main function of a circuit breaker?",
    "explanation":
        "A circuit breaker interrupts the flow of electricity when there is an overload or a short circuit, protecting the wiring and devices.",
    "incorrect_answer":
        '["【1】To increase current", "【2】To store energy", "【3】To amplify signals"]',
    "correct_answer": '["【0】To interrupt the flow of electricity"]',
    "topic_name": "Branch Circuit Calculations and Conductors",
    "category": "Safety",
    "level": 1,
    "status": 1,
    "exam_title": "Electrician Exam Prep Pro 2024"
  },
  {
    "uuid": "49t0a1b2c3d4e5f6g7h8i",
    "question":
        "What is the purpose of a GFCI (Ground Fault Circuit Interrupter)?",
    "explanation":
        "A GFCI detects ground faults and interrupts the circuit to prevent electrical shock, particularly in wet locations.",
    "incorrect_answer":
        '["【1】To enhance voltage", "【2】To control current", "【3】To store energy"]',
    "correct_answer": '["【0】To prevent electrical shock"]',
    "topic_name": "Branch Circuit Calculations and Conductors",
    "category": "Safety Devices",
    "level": 2,
    "status": 1,
    "exam_title": "Electrician Exam Prep Pro 2024"
  },
  {
    "uuid": "50a1b2c3d4e5f6g7h8i9j",
    "question":
        "What is the standard voltage for residential electrical systems in North America?",
    "explanation":
        "The standard voltage for residential systems is 120/240 volts, with 120 volts used for general lighting and outlets.",
    "incorrect_answer": '["【1】110 volts", "【2】220 volts", "【3】240 volts"]',
    "correct_answer": '["【0】120/240 volts"]',
    "topic_name": "Fundamentals of Electrical Theory",
    "category": "Voltage Standards",
    "level": 1,
    "status": 1,
    "exam_title": "Electrician Exam Prep Pro 2024"
  },
  {
    "uuid": "51b2c3d4e5f6g7h8i9j0k",
    "question":
        "What type of conduit is often used for underground installations?",
    "explanation":
        "Rigid PVC conduit is commonly used for underground installations due to its corrosion resistance and durability.",
    "incorrect_answer":
        '["【1】Flexible conduit", "【2】Metal conduit", "【3】Non-metallic tubing"]',
    "correct_answer": '["【0】Rigid PVC conduit"]',
    "topic_name": "Electrical Wiring Methods and Electrical Materials",
    "category": "Conduit Types",
    "level": 1,
    "status": 1,
    "exam_title": "Electrician Exam Prep Pro 2024"
  },
  {
    "uuid": "52c3d4e5f6g7h8i9j0k1l",
    "question": "What is the primary purpose of a transformer?",
    "explanation":
        "Transformers are used to change the voltage level in AC circuits, either stepping up or stepping down voltage for transmission or distribution.",
    "incorrect_answer":
        '["【1】To measure current", "【2】To store energy", "【3】To amplify signals"]',
    "correct_answer": '["【0】To change voltage levels"]',
    "topic_name": "Fundamentals of Electrical Theory",
    "category": "Electrical Devices",
    "level": 1,
    "status": 1,
    "exam_title": "Electrician Exam Prep Pro 2024"
  },
  {
    "uuid": "53d4e5f6g7h8i9j0k1l2m",
    "question": "What does NEC stand for in electrical work?",
    "explanation":
        "NEC stands for National Electrical Code, which provides standards for safe electrical installation in the U.S.",
    "incorrect_answer":
        '["【1】National Energy Code", "【2】National Electric Commission", "【3】New Energy Code"]',
    "correct_answer": '["【0】National Electrical Code"]',
    "topic_name": "Fundamentals of Electrical Theory",
    "category": "Regulations",
    "level": 1,
    "status": 1,
    "exam_title": "Electrician Exam Prep Pro 2024"
  },
  {
    "uuid": "54e5f6g7h8i9j0k1l2m3n",
    "question": "What is the purpose of a junction box?",
    "explanation":
        "A junction box protects electrical connections and provides a safe enclosure for splices and junctions in wiring systems.",
    "incorrect_answer":
        '["【1】To amplify signals", "【2】To reduce voltage", "【3】To store energy"]',
    "correct_answer": '["【0】To protect electrical connections"]',
    "topic_name": "Electrical Wiring Methods and Electrical Materials",
    "category": "Junctions",
    "level": 1,
    "status": 1,
    "exam_title": "Electrician Exam Prep Pro 2024"
  },
  {
    "uuid": "55f6g7h8i9j0k1l2m3n4o",
    "question": "What is the typical use of an RCD (Residual Current Device)?",
    "explanation":
        "RCDs are used to prevent electric shock by disconnecting the supply when a fault is detected, such as when current leaks to earth.",
    "incorrect_answer":
        '["【1】To store energy", "【2】To amplify signals", "【3】To control lighting"]',
    "correct_answer": '["【0】To prevent electric shock"]',
    "topic_name": "Branch Circuit Calculations and Conductors",
    "category": "Safety Devices",
    "level": 2,
    "status": 1,
    "exam_title": "Electrician Exam Prep Pro 2024"
  },
  {
    "uuid": "56g7h8i9j0k1l2m3n4o5p",
    "question": "What is the difference between a volt and an ampere?",
    "explanation":
        "A volt is a measure of electrical potential difference, while an ampere measures the flow of electric current.",
    "incorrect_answer":
        '["【1】Both measure power", "【2】Volts measure current", "【3】Amperes measure voltage"]',
    "correct_answer":
        '["【0】Volts measure potential difference, amperes measure current"]',
    "topic_name": "Fundamentals of Electrical Theory",
    "category": "Basic Concepts",
    "level": 1,
    "status": 1,
    "exam_title": "Electrician Exam Prep Pro 2024"
  },
  {
    "uuid": "57h8i9j0k1l2m3n4o5p6q",
    "question": "What is the role of a neutral wire in an electrical system?",
    "explanation":
        "The neutral wire provides a return path for current and is essential for the operation of single-phase systems.",
    "incorrect_answer":
        '["【1】To increase voltage", "【2】To provide ground", "【3】To store energy"]',
    "correct_answer": '["【0】To provide a return path for current"]',
    "topic_name": "Electrical Wiring Methods and Electrical Materials",
    "category": "Wiring Concepts",
    "level": 1,
    "status": 1,
    "exam_title": "Electrician Exam Prep Pro 2024"
  },
  {
    "uuid": "58i9j0k1l2m3n4o5p6q7r",
    "question":
        "What type of electrical device is used to reduce voltage in a circuit?",
    "explanation":
        "A step-down transformer is used to reduce voltage in an electrical circuit.",
    "incorrect_answer": '["【1】Generator", "【2】Capacitor", "【3】Inductor"]',
    "correct_answer": '["【0】Step-down transformer"]',
    "topic_name": "Fundamentals of Electrical Theory",
    "category": "Voltage Reduction",
    "level": 1,
    "status": 1,
    "exam_title": "Electrician Exam Prep Pro 2024"
  },
  {
    "uuid": "59j0k1l2m3n4o5p6q7r8s",
    "question": "What is the primary purpose of an electrical circuit diagram?",
    "explanation":
        "An electrical circuit diagram provides a visual representation of the electrical connections and components in a circuit, aiding in understanding and troubleshooting.",
    "incorrect_answer":
        '["【1】To increase efficiency", "【2】To store energy", "【3】To amplify signals"]',
    "correct_answer": '["【0】To represent electrical connections visually"]',
    "topic_name": "Fundamentals of Electrical Theory",
    "category": "Design",
    "level": 1,
    "status": 1,
    "exam_title": "Electrician Exam Prep Pro 2024"
  },
  {
    "uuid": "60k1l2m3n4o5p6q7r8s9t",
    "question": "What does a circuit's load refer to?",
    "explanation":
        "The load of a circuit refers to the total amount of electrical power consumed by all devices connected to it.",
    "incorrect_answer":
        '["【1】The total voltage", "【2】The number of wires", "【3】The type of circuit"]',
    "correct_answer": '["【0】The total power consumed"]',
    "topic_name": "Fundamentals of Electrical Theory",
    "category": "Load Calculations",
    "level": 1,
    "status": 1,
    "exam_title": "Electrician Exam Prep Pro 2024"
  },
  {
    "uuid": "61l2m3n4o5p6q7r8s9t0a",
    "question":
        "What is the common color coding for a 240V circuit in North America?",
    "explanation":
        "In North America, black and red wires are commonly used for 240V circuits, with the white wire serving as the neutral.",
    "incorrect_answer": '["【1】Green", "【2】Blue", "【3】Yellow"]',
    "correct_answer": '["【0】Black and red"]',
    "topic_name": "Electrical Wiring Methods and Electrical Materials",
    "category": "Voltage Circuits",
    "level": 1,
    "status": 1,
    "exam_title": "Electrician Exam Prep Pro 2024"
  },
  {
    "uuid": "62m3n4o5p6q7r8s9t0a1b",
    "question": "What device is used to control the speed of a motor?",
    "explanation":
        "A variable frequency drive (VFD) is used to control the speed of a motor by varying the frequency and voltage supplied to the motor.",
    "incorrect_answer": '["【1】Capacitor", "【2】Resistor", "【3】Inductor"]',
    "correct_answer": '["【0】Variable frequency drive"]',
    "topic_name": "Motors and Generators",
    "category": "Motor Control",
    "level": 2,
    "status": 1,
    "exam_title": "Electrician Exam Prep Pro 2024"
  },
  {
    "uuid": "63n4o5p6q7r8s9t0a1b2c",
    "question": "What is the function of a relay in electrical systems?",
    "explanation":
        "A relay is an electrically operated switch that uses a small control signal to switch a larger load, enabling remote control of circuits.",
    "incorrect_answer":
        '["【1】To amplify voltage", "【2】To store energy", "【3】To measure resistance"]',
    "correct_answer": '["【0】To switch larger loads remotely"]',
    "topic_name": "Electrical Control Devices and Disconnecting Means",
    "category": "Control Devices",
    "level": 2,
    "status": 1,
    "exam_title": "Electrician Exam Prep Pro 2024"
  },
  {
    "uuid": "64o5p6q7r8s9t0a1b2c3d",
    "question":
        "What is the primary purpose of a capacitor in an electrical circuit?",
    "explanation":
        "Capacitors store and release electrical energy, used for filtering, smoothing, and timing applications in circuits.",
    "incorrect_answer":
        '["【1】To increase current", "【2】To convert AC to DC", "【3】To amplify signals"]',
    "correct_answer": '["【0】To store and release electrical energy"]',
    "topic_name": "Electrical Equipment and Devices",
    "category": "Capacitance",
    "level": 1,
    "status": 1,
    "exam_title": "Electrician Exam Prep Pro 2024"
  },
  {
    "uuid": "65p6q7r8s9t0a1b2c3d4e",
    "question": "What is the purpose of a surge protector?",
    "explanation":
        "Surge protectors safeguard electrical devices from voltage spikes by diverting excess voltage away from the connected equipment.",
    "incorrect_answer":
        '["【1】To increase voltage", "【2】To amplify current", "【3】To measure energy consumption"]',
    "correct_answer": '["【0】To protect against voltage spikes"]',
    "topic_name": "Electrical Equipment and Devices",
    "category": "Protection Devices",
    "level": 1,
    "status": 1,
    "exam_title": "Electrician Exam Prep Pro 2024"
  },
  {
    "uuid": "66q7r8s9t0a1b2c3d4e5f",
    "question": "What is the main function of a motor starter?",
    "explanation":
        "A motor starter provides the necessary power and control to start and stop an electric motor safely.",
    "incorrect_answer":
        '["【1】To increase efficiency", "【2】To measure current", "【3】To convert AC to DC"]',
    "correct_answer": '["【0】To start and stop motors safely"]',
    "topic_name": "Motors and Generators",
    "category": "Motor Control",
    "level": 1,
    "status": 1,
    "exam_title": "Electrician Exam Prep Pro 2024"
  },
  {
    "uuid": "67r8s9t0a1b2c3d4e5f6g",
    "question": "What is the common cause of electrical fires?",
    "explanation":
        "Electrical fires are commonly caused by overloaded circuits, faulty wiring, or the misuse of electrical equipment.",
    "incorrect_answer":
        '["【1】Overheating devices", "【2】High humidity", "【3】Old age"]',
    "correct_answer": '["【0】Overloaded circuits"]',
    "topic_name": "Fundamentals of Electrical Theory",
    "category": "Fire Hazards",
    "level": 1,
    "status": 1,
    "exam_title": "Electrician Exam Prep Pro 2024"
  },
  {
    "uuid": "68s9t0a1b2c3d4e5f6g7h",
    "question":
        "What is the purpose of using circuit diagrams in electrical work?",
    "explanation":
        "Circuit diagrams are used to represent electrical systems visually, making it easier to understand connections and troubleshoot problems.",
    "incorrect_answer":
        '["【1】To store energy", "【2】To amplify signals", "【3】To increase voltage"]',
    "correct_answer": '["【0】To represent electrical systems visually"]',
    "topic_name": "Fundamentals of Electrical Theory",
    "category": "Design",
    "level": 1,
    "status": 1,
    "exam_title": "Electrician Exam Prep Pro 2024"
  },
  {
    "uuid": "69t0a1b2c3d4e5f6g7h8i",
    "question": "What is a primary benefit of using renewable energy sources?",
    "explanation":
        "Renewable energy sources reduce dependence on fossil fuels, decrease greenhouse gas emissions, and promote sustainable energy practices.",
    "incorrect_answer":
        '["【1】Higher costs", "【2】Limited availability", "【3】Complex installation"]',
    "correct_answer": '["【0】Reduction of greenhouse gas emissions"]',
    "topic_name": "Renewable Energy Technologies",
    "category": "Sustainability",
    "level": 1,
    "status": 1,
    "exam_title": "Electrician Exam Prep Pro 2024"
  },
  {
    "uuid": "70a1b2c3d4e5f6g7h8i9j",
    "question": "What is the primary function of a photovoltaic (PV) cell?",
    "explanation":
        "PV cells convert sunlight directly into electricity, making them essential components of solar panels.",
    "incorrect_answer":
        '["【1】To store energy", "【2】To increase current", "【3】To reduce voltage"]',
    "correct_answer": '["【0】To convert sunlight into electricity"]',
    "topic_name": "Renewable Energy Technologies",
    "category": "Solar Energy",
    "level": 1,
    "status": 1,
    "exam_title": "Electrician Exam Prep Pro 2024"
  },
  {
    "uuid": "71b2c3d4e5f6g7h8i9j0k",
    "question":
        "What is the primary purpose of an inverter in solar energy systems?",
    "explanation":
        "An inverter converts the direct current (DC) generated by solar panels into alternating current (AC) for use in homes and businesses.",
    "incorrect_answer":
        '["【1】To store energy", "【2】To increase voltage", "【3】To measure current"]',
    "correct_answer": '["【0】To convert DC to AC"]',
    "topic_name": "Renewable Energy Technologies",
    "category": "Solar Power Systems",
    "level": 1,
    "status": 1,
    "exam_title": "Electrician Exam Prep Pro 2024"
  },
  {
    "uuid": "72c3d4e5f6g7h8i9j0k1l",
    "question": "What is the main advantage of using LED lighting?",
    "explanation":
        "LED lighting is energy-efficient, has a longer lifespan, and produces less heat compared to traditional incandescent bulbs.",
    "incorrect_answer":
        '["【1】Higher energy consumption", "【2】Shorter lifespan", "【3】More heat production"]',
    "correct_answer": '["【0】Energy efficiency"]',
    "topic_name": "Electrical Equipment and Devices",
    "category": "Lighting",
    "level": 1,
    "status": 1,
    "exam_title": "Electrician Exam Prep Pro 2024"
  },
  {
    "uuid": "73d4e5f6g7h8i9j0k1l2m",
    "question": "What is the importance of grounding in electrical systems?",
    "explanation":
        "Grounding provides a safe path for electrical current to reduce the risk of shock and equipment damage in case of a fault.",
    "incorrect_answer":
        '["【1】To increase voltage", "【2】To store energy", "【3】To amplify signals"]',
    "correct_answer": '["【0】To provide safety against electrical faults"]',
    "topic_name": "Fundamentals of Electrical Theory",
    "category": "Grounding",
    "level": 1,
    "status": 1,
    "exam_title": "Electrician Exam Prep Pro 2024"
  },
  {
    "uuid": "74e5f6g7h8i9j0k1l2m3n",
    "question": "What is the function of a fuse in an electrical circuit?",
    "explanation":
        "A fuse protects electrical circuits by melting and breaking the connection when current exceeds a safe level.",
    "incorrect_answer":
        '["【1】To increase current", "【2】To store energy", "【3】To measure voltage"]',
    "correct_answer": '["【0】To protect against overcurrent"]',
    "topic_name": "Branch Circuit Calculations and Conductors",
    "category": "Fuses",
    "level": 1,
    "status": 1,
    "exam_title": "Electrician Exam Prep Pro 2024"
  },
  {
    "uuid": "75f6g7h8i9j0k1l2m3n4o",
    "question": "What is the role of an ammeter in electrical circuits?",
    "explanation":
        "An ammeter measures the current flowing through a circuit, allowing for monitoring and troubleshooting.",
    "incorrect_answer":
        '["【1】To measure voltage", "【2】To increase power", "【3】To store energy"]',
    "correct_answer": '["【0】To measure current"]',
    "topic_name": "Electrical Equipment and Devices",
    "category": "Measurement Tools",
    "level": 1,
    "status": 1,
    "exam_title": "Electrician Exam Prep Pro 2024"
  },
  {
    "uuid": "76g7h8i9j0k1l2m3n4o5p",
    "question": "What is the function of a contactor in motor control systems?",
    "explanation":
        "A contactor is an electrically controlled switch used for switching a power circuit, often used to control electric motors.",
    "incorrect_answer":
        '["【1】To increase voltage", "【2】To measure current", "【3】To store energy"]',
    "correct_answer": '["【0】To switch power circuits"]',
    "topic_name": "Electrical Control Devices and Disconnecting Means",
    "category": "Motor Control",
    "level": 1,
    "status": 1,
    "exam_title": "Electrician Exam Prep Pro 2024"
  },
  {
    "uuid": "77h8i9j0k1l2m3n4o5p6q",
    "question": "What is the purpose of a relay in an electrical circuit?",
    "explanation":
        "A relay is a switch operated by an electromagnet that can control a circuit by opening or closing contacts.",
    "incorrect_answer":
        '["【1】To increase current", "【2】To store energy", "【3】To measure resistance"]',
    "correct_answer": '["【0】To control a circuit with an electromagnet"]',
    "topic_name": "Electrical Control Devices and Disconnecting Means",
    "category": "Control Devices",
    "level": 1,
    "status": 1,
    "exam_title": "Electrician Exam Prep Pro 2024"
  },
  {
    "uuid": "78i9j0k1l2m3n4o5p6q7r",
    "question": "What does a power factor of less than 1 indicate?",
    "explanation":
        "A power factor of less than 1 indicates that not all the power supplied is being used effectively for work, which can lead to wasted energy.",
    "incorrect_answer":
        '["【1】Efficiency is maximized", "【2】Power is not available", "【3】Voltage is excessive"]',
    "correct_answer": '["【0】Inefficient use of power"]',
    "topic_name": "Fundamentals of Electrical Theory",
    "category": "Power Factor",
    "level": 1,
    "status": 1,
    "exam_title": "Electrician Exam Prep Pro 2024"
  },
  {
    "uuid": "79j0k1l2m3n4o5p6q7r8s",
    "question": "What is the primary function of a distribution board?",
    "explanation":
        "A distribution board distributes electrical power to various circuits while providing protection via fuses or circuit breakers.",
    "incorrect_answer":
        '["【1】To store energy", "【2】To amplify signals", "【3】To measure current"]',
    "correct_answer": '["【0】To distribute electrical power"]',
    "topic_name": "Electrical Equipment and Devices",
    "category": "Distribution Systems",
    "level": 1,
    "status": 1,
    "exam_title": "Electrician Exam Prep Pro 2024"
  },
  {
    "uuid": "80k1l2m3n4o5p6q7r8s9",
    "question":
        "What is the purpose of using a ground fault circuit interrupter (GFCI)?",
    "explanation":
        "A GFCI protects against electric shock by detecting ground faults and quickly shutting off power to prevent injury.",
    "incorrect_answer":
        '["【1】To increase voltage", "【2】To measure resistance", "【3】To reduce current"]',
    "correct_answer": '["【0】To protect against ground faults"]',
    "topic_name": "Fundamentals of Electrical Theory",
    "category": "Protection Devices",
    "level": 1,
    "status": 1,
    "exam_title": "Electrician Exam Prep Pro 2024"
  },
  {
    "uuid": "81l2m3n4o5p6q7r8s9t0",
    "question":
        "What type of wiring is typically used for underground installations?",
    "explanation":
        "Type UF (Underground Feeder) cable is used for underground wiring as it is resistant to moisture and suitable for direct burial.",
    "incorrect_answer": '["【1】NM cable", "【2】BX cable", "【3】THHN wire"]',
    "correct_answer": '["【0】UF cable"]',
    "topic_name": "Electrical Wiring Methods and Electrical Materials",
    "category": "Wiring Materials",
    "level": 2,
    "status": 1,
    "exam_title": "Electrician Exam Prep Pro 2024"
  },
  {
    "uuid": "82m3n4o5p6q7r8s9t0a1",
    "question": "What type of current does a generator produce?",
    "explanation":
        "Generators produce alternating current (AC), which can be used directly in AC systems or converted to DC if necessary.",
    "incorrect_answer":
        '["【1】Direct current only", "【2】Voltage only", "【3】No current"]',
    "correct_answer": '["【0】Alternating current"]',
    "topic_name": "Motors and Generators",
    "category": "Power Sources",
    "level": 1,
    "status": 1,
    "exam_title": "Electrician Exam Prep Pro 2024"
  },
  {
    "uuid": "83n4o5p6q7r8s9t0a1b2",
    "question":
        "What is the purpose of an arc fault circuit interrupter (AFCI)?",
    "explanation":
        "An AFCI detects and interrupts electrical arcs that could cause fires, providing protection against arc faults.",
    "incorrect_answer":
        '["【1】To reduce voltage", "【2】To increase current", "【3】To measure resistance"]',
    "correct_answer": '["【0】To prevent electrical fires"]',
    "topic_name": "Fundamentals of Electrical Theory",
    "category": "Protection Devices",
    "level": 1,
    "status": 1,
    "exam_title": "Electrician Exam Prep Pro 2024"
  },
  {
    "uuid": "84o5p6q7r8s9t0a1b2c3",
    "question":
        "What is the primary purpose of using conduit in wiring installations?",
    "explanation":
        "Conduits protect electrical wiring from physical damage and provide a safe, organized route for wires.",
    "incorrect_answer":
        '["【1】To reduce voltage", "【2】To conduct electricity", "【3】To increase current"]',
    "correct_answer": '["【0】To protect and route wiring"]',
    "topic_name": "Electrical Wiring Methods and Electrical Materials",
    "category": "Wiring Protection",
    "level": 2,
    "status": 1,
    "exam_title": "Electrician Exam Prep Pro 2024"
  },
  {
    "uuid": "85p6q7r8s9t0a1b2c3d4",
    "question":
        "In North America, which color wire is commonly used for neutral in AC circuits?",
    "explanation":
        "The white wire is commonly used as the neutral conductor in AC circuits in North America.",
    "incorrect_answer": '["【1】Black", "【2】Green", "【3】Blue"]',
    "correct_answer": '["【0】White"]',
    "topic_name": "Electrical Wiring Methods and Electrical Materials",
    "category": "Neutral Conductor",
    "level": 1,
    "status": 1,
    "exam_title": "Electrician Exam Prep Pro 2024"
  },
  {
    "uuid": "86q7r8s9t0a1b2c3d4e5",
    "question": "What is the primary function of a step-down transformer?",
    "explanation":
        "A step-down transformer reduces the voltage of an electrical circuit to a safer or required level for specific applications.",
    "incorrect_answer":
        '["【1】To increase voltage", "【2】To change frequency", "【3】To convert AC to DC"]',
    "correct_answer": '["【0】To reduce voltage"]',
    "topic_name": "Electrical Equipment and Devices",
    "category": "Fundamentals of Electrical Theory",
    "level": 1,
    "status": 1,
    "exam_title": "Electrician Exam Prep Pro 2024"
  },
  {
    "uuid": "87r8s9t0a1b2c3d4e5f6",
    "question": "What is the function of a load center?",
    "explanation":
        "A load center is used to distribute electrical power throughout a building by housing circuit breakers and protecting circuits.",
    "incorrect_answer":
        '["【1】To measure voltage", "【2】To store energy", "【3】To convert AC to DC"]',
    "correct_answer": '["【0】To distribute power to circuits"]',
    "topic_name": "Electrical Equipment and Devices",
    "category": "Distribution Systems",
    "level": 1,
    "status": 1,
    "exam_title": "Electrician Exam Prep Pro 2024"
  },
  {
    "uuid": "88s9t0a1b2c3d4e5f6g7",
    "question": "What is the role of a diode in electrical circuits?",
    "explanation":
        "Diodes allow current to flow in one direction only, preventing backflow and providing rectification in circuits.",
    "incorrect_answer":
        '["【1】To amplify signals", "【2】To measure current", "【3】To store energy"]',
    "correct_answer": '["【0】To control current direction"]',
    "topic_name": "Electrical Equipment and Devices",
    "category": "Semiconductors",
    "level": 1,
    "status": 1,
    "exam_title": "Electrician Exam Prep Pro 2024"
  },
  {
    "uuid": "89t0a1b2c3d4e5f6g7h8",
    "question": "What is the purpose of using twist-on wire connectors?",
    "explanation":
        "Twist-on wire connectors are used to join and insulate wires securely in a junction box or other enclosure.",
    "incorrect_answer":
        '["【1】To increase voltage", "【2】To reduce current", "【3】To measure resistance"]',
    "correct_answer": '["【0】To join and insulate wires"]',
    "topic_name": "Electrical Wiring Methods and Electrical Materials",
    "category": "Connectors",
    "level": 1,
    "status": 1,
    "exam_title": "Electrician Exam Prep Pro 2024"
  },
  {
    "uuid": "103a1b2c3d4e5f6g7h8i",
    "question":
        "What is the purpose of a service disconnect in an electrical service system?",
    "explanation":
        "A service disconnect allows the complete isolation of electrical power from the service equipment for maintenance or emergency situations.",
    "incorrect_answer":
        '["【1】To increase voltage", "【2】To control lighting", "【3】To measure current"]',
    "correct_answer": '["【0】To disconnect electrical power from the service"]',
    "topic_name":
        "Electrical Services, Service Equipment, and Separately Derived Systems",
    "category": "Service Disconnect",
    "level": 1,
    "status": 1,
    "exam_title": "Electrician Exam Prep Pro 2024"
  },
  {
    "uuid": "104b2c3d4e5f6g7h8i9j",
    "question":
        "In an electrical service, what is the purpose of a main bonding jumper?",
    "explanation":
        "The main bonding jumper ensures electrical continuity between the grounded service conductor and the equipment grounding conductors.",
    "incorrect_answer":
        '["【1】To increase current", "【2】To reduce resistance", "【3】To measure voltage"]',
    "correct_answer": '["【0】To bond grounded and grounding conductors"]',
    "topic_name":
        "Electrical Services, Service Equipment, and Separately Derived Systems",
    "category": "Grounding and Bonding",
    "level": 2,
    "status": 1,
    "exam_title": "Electrician Exam Prep Pro 2024"
  },
  {
    "uuid": "105c3d4e5f6g7h8i9j0k",
    "question": "What is a separately derived system?",
    "explanation":
        "A separately derived system is an electrical system that has no direct connection to circuit conductors of any other system, typically powered by a transformer or generator.",
    "incorrect_answer":
        '["【1】A secondary service line", "【2】A backup circuit", "【3】A battery-powered device"]',
    "correct_answer": '["【0】An isolated electrical system"]',
    "topic_name":
        "Electrical Services, Service Equipment, and Separately Derived Systems",
    "category": "System Isolation",
    "level": 2,
    "status": 1,
    "exam_title": "Electrician Exam Prep Pro 2024"
  },
  {
    "uuid": "106d4e5f6g7h8i9j0k1l",
    "question":
        "Which component provides overcurrent protection for service equipment?",
    "explanation":
        "The main breaker provides overcurrent protection, disconnecting power when a fault or overload occurs.",
    "incorrect_answer":
        '["【1】Bonding jumper", "【2】Grounding electrode", "【3】Insulating bushing"]',
    "correct_answer": '["【0】Main breaker"]',
    "topic_name":
        "Electrical Services, Service Equipment, and Separately Derived Systems",
    "category": "Protection Devices",
    "level": 1,
    "status": 1,
    "exam_title": "Electrician Exam Prep Pro 2024"
  },
  {
    "uuid": "107e5f6g7h8i9j0k1l2m",
    "question":
        "What type of equipment grounding conductor is typically used in a residential service panel?",
    "explanation":
        "Bare copper or green insulated grounding conductors are used to provide a safe grounding path in a residential service panel.",
    "incorrect_answer":
        '["【1】Red insulated wire", "【2】White neutral wire", "【3】Black hot wire"]',
    "correct_answer": '["【0】Bare copper or green wire"]',
    "topic_name":
        "Electrical Services, Service Equipment, and Separately Derived Systems",
    "category": "Grounding Conductors",
    "level": 1,
    "status": 1,
    "exam_title": "Electrician Exam Prep Pro 2024"
  },
  {
    "uuid": "108f6g7h8i9j0k1l2m3n",
    "question":
        "What is the purpose of an electrical meter in service equipment?",
    "explanation":
        "An electrical meter measures the amount of electric power consumed by a building or service panel.",
    "incorrect_answer":
        '["【1】To provide overcurrent protection", "【2】To control voltage", "【3】To ground the system"]',
    "correct_answer": '["【0】To measure power consumption"]',
    "topic_name":
        "Electrical Services, Service Equipment, and Separately Derived Systems",
    "category": "Metering Devices",
    "level": 1,
    "status": 1,
    "exam_title": "Electrician Exam Prep Pro 2024"
  },
  {
    "uuid": "109g7h8i9j0k1l2m3n4o",
    "question":
        "What does the National Electrical Code (NEC) require for service grounding?",
    "explanation":
        "The NEC requires that a service be grounded using an approved grounding electrode, such as a ground rod or metal water pipe.",
    "incorrect_answer":
        '["【1】No grounding is needed", "【2】Use of any metal object", "【3】Any non-conductive material"]',
    "correct_answer": '["【0】An approved grounding electrode"]',
    "topic_name":
        "Electrical Services, Service Equipment, and Separately Derived Systems",
    "category": "Grounding Requirements",
    "level": 2,
    "status": 1,
    "exam_title": "Electrician Exam Prep Pro 2024"
  },
  {
    "uuid": "110h8i9j0k1l2m3n4o5p",
    "question":
        "What type of equipment should be bonded to the ground in a separately derived system?",
    "explanation":
        "All metal parts of electrical equipment should be bonded to the grounding conductor to prevent accidental shock.",
    "incorrect_answer":
        '["【1】Only high-voltage equipment", "【2】Only control circuits", "【3】No bonding is required"]',
    "correct_answer": '["【0】All metal parts of electrical equipment"]',
    "topic_name":
        "Electrical Services, Service Equipment, and Separately Derived Systems",
    "category": "Grounding and Bonding",
    "level": 2,
    "status": 1,
    "exam_title": "Electrician Exam Prep Pro 2024"
  },
  {
    "uuid": "111i9j0k1l2m3n4o5p6q",
    "question":
        "What is the purpose of an automatic transfer switch in a service panel?",
    "explanation":
        "An automatic transfer switch automatically switches power to a backup source during a main power outage.",
    "incorrect_answer":
        '["【1】To reduce voltage", "【2】To measure resistance", "【3】To isolate circuits for maintenance"]',
    "correct_answer": '["【0】To switch to backup power during an outage"]',
    "topic_name":
        "Electrical Services, Service Equipment, and Separately Derived Systems",
    "category": "Power Backup",
    "level": 1,
    "status": 1,
    "exam_title": "Electrician Exam Prep Pro 2024"
  },
  {
    "uuid": "112j0k1l2m3n4o5p6q7r",
    "question":
        "How is a service entrance cable typically protected from weather exposure?",
    "explanation":
        "Service entrance cables are covered in weather-resistant insulation to protect against elements.",
    "incorrect_answer":
        '["【1】Using bare wire", "【2】Using plastic ties", "【3】Exposed directly to the weather"]',
    "correct_answer": '["【0】Using weather-resistant insulation"]',
    "topic_name":
        "Electrical Services, Service Equipment, and Separately Derived Systems",
    "category": "Service Cables",
    "level": 1,
    "status": 1,
    "exam_title": "Electrician Exam Prep Pro 2024"
  },
  {
    "uuid": "113k1l2m3n4o5p6q7r8s",
    "question":
        "What is a grounding electrode conductor's purpose in a service panel?",
    "explanation":
        "A grounding electrode conductor connects the service panel to a grounding electrode, providing a safe path for fault currents.",
    "incorrect_answer":
        '["【1】To conduct hot current", "【2】To increase resistance", "【3】To measure voltage"]',
    "correct_answer": '["【0】To connect the service to a grounding electrode"]',
    "topic_name":
        "Electrical Services, Service Equipment, and Separately Derived Systems",
    "category": "Grounding Conductors",
    "level": 1,
    "status": 1,
    "exam_title": "Electrician Exam Prep Pro 2024"
  },
  {
    "uuid": "114l2m3n4o5p6q7r8s9t",
    "question":
        "What does the NEC specify for electrical service entrance conductors?",
    "explanation":
        "The NEC specifies requirements for insulation, grounding, and the routing of service entrance conductors to ensure safety.",
    "incorrect_answer":
        '["【1】No specific requirements", "【2】Allows bare wiring", "【3】No grounding required"]',
    "correct_answer": '["【0】Insulation, grounding, and routing requirements"]',
    "topic_name":
        "Electrical Services, Service Equipment, and Separately Derived Systems",
    "category": "Service Conductors",
    "level": 2,
    "status": 1,
    "exam_title": "Electrician Exam Prep Pro 2024"
  },
  {
    "uuid": "115m3n4o5p6q7r8s9t0a",
    "question":
        "What is an acceptable grounding electrode for a separately derived system according to the NEC?",
    "explanation":
        "Acceptable grounding electrodes include ground rods, metal water pipes, or building steel bonded to the grounding system.",
    "incorrect_answer":
        '["【1】Plastic pipes", "【2】Insulated rods", "【3】Non-metallic conductors"]',
    "correct_answer":
        '["【0】Metal water pipes, ground rods, or building steel"]',
    "topic_name":
        "Electrical Services, Service Equipment, and Separately Derived Systems",
    "category": "Grounding Requirements",
    "level": 2,
    "status": 1,
    "exam_title": "Electrician Exam Prep Pro 2024"
  },
  {
    "uuid": "116n4o5p6q7r8s9t0a1b",
    "question":
        "What component limits the fault current in a service equipment setup?",
    "explanation":
        "A current-limiting fuse or circuit breaker reduces the amount of fault current by opening the circuit before it reaches dangerous levels.",
    "incorrect_answer":
        '["【1】Service entrance conductor", "【2】Grounding electrode", "【3】Main bonding jumper"]',
    "correct_answer": '["【0】Current-limiting fuse"]',
    "topic_name":
        "Electrical Services, Service Equipment, and Separately Derived Systems",
    "category": "Protection Devices",
    "level": 2,
    "status": 1,
    "exam_title": "Electrician Exam Prep Pro 2024"
  },
  {
    "uuid": "117o5p6q7r8s9t0a1b2c",
    "question": "How does the NEC define a grounding electrode?",
    "explanation":
        "A grounding electrode is a conducting element, like a ground rod or metal water pipe, that establishes an earth connection for the electrical system.",
    "incorrect_answer":
        '["【1】An insulator", "【2】A control device", "【3】A resistor"]',
    "correct_answer": '["【0】A conducting element connected to earth"]',
    "topic_name":
        "Electrical Services, Service Equipment, and Separately Derived Systems",
    "category": "Grounding Requirements",
    "level": 1,
    "status": 1,
    "exam_title": "Electrician Exam Prep Pro 2024"
  },
  {
    "uuid": "118p6q7r8s9t0a1b2c3d",
    "question":
        "What is the purpose of a ground fault circuit interrupter (GFCI) in a service panel?",
    "explanation":
        "GFCIs protect against electrical shock by detecting imbalances in current flow between the hot and neutral wires.",
    "incorrect_answer":
        '["【1】Increases voltage output", "【2】Reduces system impedance", "【3】Detects high voltage surges"]',
    "correct_answer":
        '["【0】Protects against electrical shock from current imbalances"]',
    "topic_name":
        "Electrical Services, Service Equipment, and Separately Derived Systems",
    "category": "Protection Devices",
    "level": 1,
    "status": 1,
    "exam_title": "Electrician Exam Prep Pro 2024"
  },
  {
    "uuid": "119q7r8s9t0a1b2c3d4e",
    "question":
        "What kind of transformer is commonly used in a separately derived system?",
    "explanation":
        "An isolation transformer is commonly used in separately derived systems to isolate the primary and secondary systems.",
    "incorrect_answer":
        '["【1】Auto transformer", "【2】Step-up transformer", "【3】Inductive transformer"]',
    "correct_answer": '["【0】Isolation transformer"]',
    "topic_name":
        "Electrical Services, Service Equipment, and Separately Derived Systems",
    "category": "Transformers",
    "level": 2,
    "status": 1,
    "exam_title": "Electrician Exam Prep Pro 2024"
  },
  {
    "uuid": "120r8s9t0a1b2c3d4e5f",
    "question":
        "Which type of service entrance conductor is suitable for outdoor use in wet conditions?",
    "explanation":
        "Type SE cable is suitable for outdoor service entrance installations and is resistant to moisture.",
    "incorrect_answer":
        '["【1】Type NM cable", "【2】Type AC cable", "【3】Type MC cable"]',
    "correct_answer": '["【0】Type SE cable"]',
    "topic_name": "Electrical Services",
    "category":
        "Electrical Services, Service Equipment, and Separately Derived Systems",
    "level": 2,
    "status": 1,
    "exam_title": "Electrician Exam Prep Pro 2024"
  },
  {
    "uuid": "121s9t0a1b2c3d4e5f6g",
    "question":
        "How does an overcurrent protection device help in electrical safety?",
    "explanation":
        "An overcurrent protection device, like a breaker or fuse, opens the circuit when current exceeds safe levels, preventing overheating or fire.",
    "incorrect_answer":
        '["【1】Increases voltage", "【2】Controls circuit impedance", "【3】Balances current load"]',
    "correct_answer": '["【0】Prevents overheating by opening the circuit"]',
    "topic_name":
        "Electrical Services, Service Equipment, and Separately Derived Systems",
    "category": "Protection Devices",
    "level": 1,
    "status": 1,
    "exam_title": "Electrician Exam Prep Pro 2024"
  },
  {
    "uuid": "122t0a1b2c3d4e5f6g7h",
    "question":
        "What color is typically used for grounding conductors in a separately derived system?",
    "explanation":
        "Green or bare conductors are used to denote grounding in a separately derived system, ensuring easy identification.",
    "incorrect_answer": '["【1】Black", "【2】Red", "【3】Blue"]',
    "correct_answer": '["【0】Green or bare"]',
    "topic_name":
        "Electrical Services, Service Equipment, and Separately Derived Systems",
    "category": "Grounding Conductors",
    "level": 1,
    "status": 1,
    "exam_title": "Electrician Exam Prep Pro 2024"
  },
  {
    "uuid": "123a1b2c3d4e5f6g7h8i",
    "question":
        "What is required to bond a service panel to the grounding electrode?",
    "explanation":
        "A bonding jumper is used to ensure continuity between the grounding electrode and the service panel, preventing stray voltages.",
    "incorrect_answer":
        '["【1】Control wire", "【2】Insulated conductor", "【3】Neutral wire"]',
    "correct_answer": '["【0】Bonding jumper"]',
    "topic_name":
        "Electrical Services, Service Equipment, and Separately Derived Systems",
    "category": "Bonding Requirements",
    "level": 2,
    "status": 1,
    "exam_title": "Electrician Exam Prep Pro 2024"
  },
  {
    "uuid": "124b2c3d4e5f6g7h8i9j",
    "question": "What is a surge protector’s function in a service panel?",
    "explanation":
        "A surge protector limits voltage spikes to protect devices connected to the service from damage due to power surges.",
    "incorrect_answer":
        '["【1】Increases voltage", "【2】Measures current", "【3】Reduces current flow"]',
    "correct_answer": '["【0】Limits voltage spikes"]',
    "topic_name":
        "Electrical Services, Service Equipment, and Separately Derived Systems",
    "category": "Protection Devices",
    "level": 1,
    "status": 1,
    "exam_title": "Electrician Exam Prep Pro 2024"
  },
  {
    "uuid": "125c3d4e5f6g7h8i9j0k",
    "question":
        "What is the NEC requirement for bonding the neutral to the ground in a service panel?",
    "explanation":
        "The NEC requires bonding of the neutral to the ground in the main service panel to maintain a clear return path for fault currents.",
    "incorrect_answer":
        '["【1】Never bond neutral to ground", "【2】Only in secondary panels", "【3】Only during testing"]',
    "correct_answer": '["【0】Bond neutral to ground in the main service panel"]',
    "topic_name":
        "Electrical Services, Service Equipment, and Separately Derived Systems",
    "category": "Bonding Requirements",
    "level": 2,
    "status": 1,
    "exam_title": "Electrician Exam Prep Pro 2024"
  },
  {
    "uuid": "200a1b2c3d4e5f6g7h8i",
    "question": "What is Ohm's Law?",
    "explanation":
        "Ohm's Law defines the relationship between voltage, current, and resistance, represented by the formula V = IR.",
    "incorrect_answer": '["【1】P = IV", "【2】V = P/I", "【3】V = I + R"]',
    "correct_answer": '["【0】V = IR"]',
    "topic_name": "Definitions, Calculations, Theory, and Plans",
    "category": "Basic Electrical Theory",
    "level": 1,
    "status": 1,
    "exam_title": "Electrician Exam Prep Pro 2024"
  },
  {
    "uuid": "201b2c3d4e5f6g7h8i9j",
    "question":
        "What is the formula to calculate power in an electrical circuit?",
    "explanation":
        "The formula to calculate power is P = IV, where P is power, I is current, and V is voltage.",
    "incorrect_answer": '["【1】P = V/I", "【2】P = I^2", "【3】P = IR"]',
    "correct_answer": '["【0】P = IV"]',
    "topic_name": "Definitions, Calculations, Theory, and Plans",
    "category": "Power Calculations",
    "level": 1,
    "status": 1,
    "exam_title": "Electrician Exam Prep Pro 2024"
  },
  {
    "uuid": "202c3d4e5f6g7h8i9j0k",
    "question": "What is the unit of resistance?",
    "explanation":
        "Resistance is measured in ohms, which is denoted by the symbol Ω.",
    "incorrect_answer": '["【1】Watts", "【2】Volts", "【3】Amperes"]',
    "correct_answer": '["【0】Ohms"]',
    "topic_name": "Definitions, Calculations, Theory, and Plans",
    "category": "Electrical Units",
    "level": 1,
    "status": 1,
    "exam_title": "Electrician Exam Prep Pro 2024"
  },
  {
    "uuid": "203d4e5f6g7h8i9j0k1l",
    "question":
        "What does the National Electrical Code (NEC) define as a 'circuit'?",
    "explanation":
        "A circuit is defined as a complete path for current flow, usually consisting of conductors, load, and source.",
    "incorrect_answer":
        '["【1】A device that stores charge", "【2】A disconnected line", "【3】A component that reduces current"]',
    "correct_answer": '["【0】A complete path for current flow"]',
    "topic_name": "Definitions, Calculations, Theory, and Plans",
    "category": "NEC Terms",
    "level": 2,
    "status": 1,
    "exam_title": "Electrician Exam Prep Pro 2024"
  },
  {
    "uuid": "204e5f6g7h8i9j0k1l2m",
    "question": "How is total resistance calculated in a series circuit?",
    "explanation":
        "In a series circuit, the total resistance is the sum of all resistances.",
    "incorrect_answer":
        '["【1】Total resistance is the product of all resistances", "【2】Total resistance is zero", "【3】Total resistance is the inverse of each resistance"]',
    "correct_answer": '["【0】The sum of all resistances"]',
    "topic_name": "Definitions, Calculations, Theory, and Plans",
    "category": "Series Circuits",
    "level": 1,
    "status": 1,
    "exam_title": "Electrician Exam Prep Pro 2024"
  },
  {
    "uuid": "205f6g7h8i9j0k1l2m3n",
    "question": "What is a schematic diagram?",
    "explanation":
        "A schematic diagram represents the elements of a system using symbols rather than physical layout, showing the circuit configuration and components.",
    "incorrect_answer":
        '["【1】A wiring diagram", "【2】A physical layout", "【3】A document with only labels"]',
    "correct_answer":
        '["【0】A representation using symbols to show components and connections"]',
    "topic_name": "Definitions, Calculations, Theory, and Plans",
    "category": "Fundamentals of Electrical Theory",
    "level": 1,
    "status": 1,
    "exam_title": "Electrician Exam Prep Pro 2024"
  },
  {
    "uuid": "206g7h8i9j0k1l2m3n4o",
    "question": "What does 'ampacity' refer to in electrical terms?",
    "explanation":
        "Ampacity is the maximum amount of electrical current a conductor or device can safely carry.",
    "incorrect_answer":
        '["【1】Voltage capacity", "【2】Power rating", "【3】Resistance level"]',
    "correct_answer": '["【0】Current-carrying capacity"]',
    "topic_name": "Definitions, Calculations, Theory, and Plans",
    "category": "Electrical Ratings",
    "level": 2,
    "status": 1,
    "exam_title": "Electrician Exam Prep Pro 2024"
  },
  {
    "uuid": "207h8i9j0k1l2m3n4o5p",
    "question": "What is the purpose of using a fuse in a circuit?",
    "explanation":
        "A fuse is a protective device that melts and opens the circuit when current exceeds safe levels, protecting against overloads.",
    "incorrect_answer":
        '["【1】Increase voltage", "【2】Control current flow", "【3】Store electric charge"]',
    "correct_answer": '["【0】Protect against overloads"]',
    "topic_name": "Definitions, Calculations, Theory, and Plans",
    "category": "Branch Circuit Calculations and Conductors",
    "level": 1,
    "status": 1,
    "exam_title": "Electrician Exam Prep Pro 2024"
  },
  {
    "uuid": "208i9j0k1l2m3n4o5p6q",
    "question":
        "In a parallel circuit, what happens to the total resistance as more resistors are added?",
    "explanation":
        "In a parallel circuit, the total resistance decreases as more resistors are added.",
    "incorrect_answer":
        '["【1】Total resistance increases", "【2】Total resistance remains the same", "【3】Total resistance doubles"]',
    "correct_answer": '["【0】Total resistance decreases"]',
    "topic_name": "Definitions, Calculations, Theory, and Plans",
    "category": "Parallel Circuits",
    "level": 1,
    "status": 1,
    "exam_title": "Electrician Exam Prep Pro 2024"
  },
  {
    "uuid": "209j0k1l2m3n4o5p6q7r",
    "question": "What is the symbol for an AC voltage source on a schematic?",
    "explanation":
        "An AC voltage source is typically represented by a circle with a sine wave symbol inside.",
    "incorrect_answer":
        '["【1】A square wave symbol", "【2】A straight line", "【3】A plus and minus symbol"]',
    "correct_answer": '["【0】A circle with a sine wave"]',
    "topic_name": "Definitions, Calculations, Theory, and Plans",
    "category": "Symbols",
    "level": 1,
    "status": 1,
    "exam_title": "Electrician Exam Prep Pro 2024"
  },
  {
    "uuid": "300a2b3c4d5e6f7g8h9i",
    "question":
        "What is the formula for calculating total capacitance in a series circuit?",
    "explanation":
        "In a series circuit, the total capacitance is found using 1/C_total = 1/C1 + 1/C2 + ... + 1/Cn.",
    "incorrect_answer":
        '["【1】C_total = C1 + C2", "【2】C_total = C1 × C2", "【3】C_total = C1 - C2"]',
    "correct_answer": '["【0】1/C_total = 1/C1 + 1/C2 + ..."]',
    "topic_name": "Definitions, Calculations, Theory, and Plans",
    "category": "Capacitance",
    "level": 2,
    "status": 1,
    "exam_title": "Electrician Exam Prep Pro 2024"
  },
  {
    "uuid": "301b3c4d5e6f7g8h9i0j",
    "question":
        "In a three-phase circuit, what is the phase angle difference between phases?",
    "explanation":
        "In a three-phase system, each phase is 120 degrees apart to ensure balanced power delivery.",
    "incorrect_answer": '["【1】90 degrees", "【2】60 degrees", "【3】45 degrees"]',
    "correct_answer": '["【0】120 degrees"]',
    "topic_name": "Definitions, Calculations, Theory, and Plans",
    "category": "Three-Phase Systems",
    "level": 2,
    "status": 1,
    "exam_title": "Electrician Exam Prep Pro 2024"
  },
  {
    "uuid": "302c4d5e6f7g8h9i0j1k",
    "question":
        "What does the symbol 'μ' stand for in electrical calculations?",
    "explanation":
        "The Greek letter μ (mu) represents the prefix micro-, denoting 10^-6.",
    "incorrect_answer": '["【1】Mili", "【2】Mega", "【3】Kilo"]',
    "correct_answer": '["【0】Micro"]',
    "topic_name": "Definitions, Calculations, Theory, and Plans",
    "category": "Metric Prefixes",
    "level": 1,
    "status": 1,
    "exam_title": "Electrician Exam Prep Pro 2024"
  },
  {
    "uuid": "303d5e6f7g8h9i0j1k2l",
    "question": "How is total inductance calculated in a parallel circuit?",
    "explanation":
        "For inductors in parallel, the total inductance is calculated using 1/L_total = 1/L1 + 1/L2 + ...",
    "incorrect_answer":
        '["【1】L_total = L1 + L2", "【2】L_total = L1 × L2", "【3】L_total = L1 - L2"]',
    "correct_answer": '["【0】1/L_total = 1/L1 + 1/L2 + ..."]',
    "topic_name": "Definitions, Calculations, Theory, and Plans",
    "category": "Inductance",
    "level": 2,
    "status": 1,
    "exam_title": "Electrician Exam Prep Pro 2024"
  },
  {
    "uuid": "304e6f7g8h9i0j1k2l3m",
    "question": "What is 'kVA' a measure of in an electrical system?",
    "explanation":
        "kVA (kilovolt-ampere) is a unit of apparent power in an electrical system, factoring both real power and reactive power.",
    "incorrect_answer": '["【1】True power", "【2】Current flow", "【3】Heat loss"]',
    "correct_answer": '["【0】Apparent power"]',
    "topic_name": "Definitions, Calculations, Theory, and Plans",
    "category": "Power Measurement",
    "level": 1,
    "status": 1,
    "exam_title": "Electrician Exam Prep Pro 2024"
  },
  {
    "uuid": "305f7g8h9i0j1k2l3m4n",
    "question":
        "What formula is used to calculate the impedance in an AC circuit?",
    "explanation":
        "In an AC circuit, impedance Z is calculated as Z = √(R^2 + (XL - XC)^2).",
    "incorrect_answer":
        '["【1】Z = R + XL + XC", "【2】Z = V/I", "【3】Z = R × (XL - XC)"]',
    "correct_answer": '["【0】Z = √(R^2 + (XL - XC)^2)"]',
    "topic_name": "Definitions, Calculations, Theory, and Plans",
    "category": "Impedance",
    "level": 2,
    "status": 1,
    "exam_title": "Electrician Exam Prep Pro 2024"
  },
  {
    "uuid": "306g8h9i0j1k2l3m4n5o",
    "question": "What is the main difference between AC and DC current?",
    "explanation":
        "AC (alternating current) changes direction periodically, while DC (direct current) flows in one direction.",
    "incorrect_answer":
        '["【1】AC is only used in batteries", "【2】DC changes direction", "【3】AC flows in one direction"]',
    "correct_answer": '["【0】AC changes direction; DC flows in one direction"]',
    "topic_name": "Definitions, Calculations, Theory, and Plans",
    "category": "Basic Electrical Theory",
    "level": 1,
    "status": 1,
    "exam_title": "Electrician Exam Prep Pro 2024"
  },
  {
    "uuid": "307h9i0j1k2l3m4n5o6p",
    "question": "What is Kirchhoff’s Voltage Law?",
    "explanation":
        "Kirchhoff's Voltage Law states that the sum of all voltages around a closed loop is zero.",
    "incorrect_answer":
        '["【1】Voltage is constant across all components", "【2】Current is constant around a loop", "【3】Power is the product of voltage and current"]',
    "correct_answer": '["【0】Sum of voltages around a closed loop is zero"]',
    "topic_name": "Definitions, Calculations, Theory, and Plans",
    "category": "Circuit Laws",
    "level": 2,
    "status": 1,
    "exam_title": "Electrician Exam Prep Pro 2024"
  },
  {
    "uuid": "308i0j1k2l3m4n5o6p7q",
    "question": "What tool measures electrical current in a circuit?",
    "explanation":
        "An ammeter is used to measure the current flowing in a circuit.",
    "incorrect_answer": '["【1】Voltmeter", "【2】Ohmmeter", "【3】Wattmeter"]',
    "correct_answer": '["【0】Ammeter"]',
    "topic_name": "Definitions, Calculations, Theory, and Plans",
    "category": "Measurement Tools",
    "level": 1,
    "status": 1,
    "exam_title": "Electrician Exam Prep Pro 2024"
  },
  {
    "uuid": "309j1k2l3m4n5o6p7q8r",
    "question": "In a transformer, what does the turns ratio affect?",
    "explanation":
        "The turns ratio of a transformer determines the change in voltage from primary to secondary windings.",
    "incorrect_answer":
        '["【1】Current frequency", "【2】Core material", "【3】Impedance of primary coil"]',
    "correct_answer": '["【0】Voltage between primary and secondary windings"]',
    "topic_name": "Definitions, Calculations, Theory, and Plans",
    "category": "Transformers",
    "level": 2,
    "status": 1,
    "exam_title": "Electrician Exam Prep Pro 2024"
  },
  {
    "uuid": "1a2b3c4d5e6f7g8h9i0j",
    "question": "What is the minimum depth for buried non-metallic conduit?",
    "explanation":
        "Non-metallic conduit must be buried at least 18 inches below the surface for safety.",
    "incorrect_answer": '["【1】12 inches", "【2】24 inches", "【3】30 inches"]',
    "correct_answer": '["【0】18 inches"]',
    "topic_name": "Electrical Wiring Methods and Electrical Materials",
    "category": "Installation Standards",
    "level": 1,
    "status": 1,
    "exam_title": "Electrician Exam Prep Pro 2024"
  },
  {
    "uuid": "2a3b4c5d6e7f8g9h0i1j",
    "question": "What is the primary function of a circuit breaker?",
    "explanation":
        "A circuit breaker protects an electrical circuit from overload or short circuits by interrupting the flow of electricity.",
    "incorrect_answer":
        '["【1】To increase current", "【2】To store energy", "【3】To enhance voltage"]',
    "correct_answer": '["【0】To interrupt the flow of electricity"]',
    "topic_name": "Electrical Wiring Methods and Electrical Materials",
    "category": "Protection Devices",
    "level": 1,
    "status": 1,
    "exam_title": "Electrician Exam Prep Pro 2024"
  },
  {
    "uuid": "3a4b5c6d7e8f9g0h1i2j",
    "question": "What is the primary advantage of using insulated wires?",
    "explanation":
        "Insulated wires prevent accidental contact with conductive materials, reducing the risk of electrical shock.",
    "incorrect_answer":
        '["【1】To reduce cost", "【2】To enhance signal strength", "【3】To increase resistance"]',
    "correct_answer": '["【0】To prevent electrical shock"]',
    "topic_name": "Electrical Wiring Methods and Electrical Materials",
    "category": "Wire Insulation",
    "level": 1,
    "status": 1,
    "exam_title": "Electrician Exam Prep Pro 2024"
  },
  {
    "uuid": "4a5b6c7d8e9f0g1h2i3j",
    "question":
        "What type of connector is used to join two pieces of electrical wire?",
    "explanation":
        "Wire connectors, such as wire nuts or crimp connectors, are used to join two or more wires together.",
    "incorrect_answer": '["【1】Locknut", "【2】Bushing", "【3】Coupling"]',
    "correct_answer": '["【0】Wire connector"]',
    "topic_name": "Electrical Wiring Methods and Electrical Materials",
    "category": "Connectors",
    "level": 1,
    "status": 1,
    "exam_title": "Electrician Exam Prep Pro 2024"
  },
  {
    "uuid": "5a6b7c8d9e0f1g2h3i4j",
    "question":
        "Which type of wire is rated for use in high-temperature environments?",
    "explanation":
        "Silicone-insulated wire is rated for high-temperature environments due to its ability to withstand high heat.",
    "incorrect_answer": '["【1】PVC wire", "【2】Rubber wire", "【3】Aluminum wire"]',
    "correct_answer": '["【0】Silicone-insulated wire"]',
    "topic_name": "Electrical Wiring Methods and Electrical Materials",
    "category": "Wire Types",
    "level": 1,
    "status": 1,
    "exam_title": "Electrician Exam Prep Pro 2024"
  },
  {
    "uuid": "6a7b8c9d0e1f2g3h4i5j",
    "question": "What does the term 'ampacity' refer to?",
    "explanation":
        "'Ampacity' refers to the maximum amount of electric current a conductor or device can carry before sustaining immediate or progressive deterioration.",
    "incorrect_answer":
        '["【1】Voltage rating", "【2】Resistance", "【3】Power rating"]',
    "correct_answer": '["【0】Maximum current capacity"]',
    "topic_name": "Electrical Wiring Methods and Electrical Materials",
    "category": "Basic Concepts",
    "level": 1,
    "status": 1,
    "exam_title": "Electrician Exam Prep Pro 2024"
  },
  {
    "uuid": "7a8b9c0d1e2f3g4h5i6j",
    "question": "Which wiring method uses a metal conduit for protection?",
    "explanation":
        "Metal conduit wiring provides physical protection for electrical wires and is often used in exposed locations.",
    "incorrect_answer":
        '["【1】Open wiring", "【2】Romex wiring", "【3】Knob and tube wiring"]',
    "correct_answer": '["【0】Metal conduit wiring"]',
    "topic_name": "Electrical Wiring Methods and Electrical Materials",
    "category": "Wiring Methods",
    "level": 1,
    "status": 1,
    "exam_title": "Electrician Exam Prep Pro 2024"
  },
  {
    "uuid": "8a9b0c1d2e3f4g5h6i7j",
    "question": "What is the main purpose of using circuit grounding?",
    "explanation":
        "Circuit grounding provides a path for electrical current to flow safely to the ground in the event of a fault, reducing the risk of shock or fire.",
    "incorrect_answer":
        '["【1】To increase resistance", "【2】To reduce current", "【3】To enhance voltage"]',
    "correct_answer": '["【0】To provide a safe path for current"]',
    "topic_name": "Electrical Wiring Methods and Electrical Materials",
    "category": "Grounding",
    "level": 1,
    "status": 1,
    "exam_title": "Electrician Exam Prep Pro 2024"
  },
  {
    "uuid": "9a0b1c2d3e4f5g6h7i8j",
    "question": "What is the typical insulation rating for residential wiring?",
    "explanation":
        "Typical insulation rating for residential wiring is 600 volts, suitable for most home applications.",
    "incorrect_answer": '["【1】300 volts", "【2】1000 volts", "【3】2000 volts"]',
    "correct_answer": '["【0】600 volts"]',
    "topic_name": "Electrical Wiring Methods and Electrical Materials",
    "category": "Insulation Ratings",
    "level": 1,
    "status": 1,
    "exam_title": "Electrician Exam Prep Pro 2024"
  },
  {
    "uuid": "0a1b2c3d4e5f6g7h8i9j",
    "question":
        "Which type of wire is often used for low-voltage lighting systems?",
    "explanation":
        "Low-voltage landscape lighting systems typically use 12 or 14 AWG wire for safety and efficiency.",
    "incorrect_answer": '["【1】8 AWG", "【2】10 AWG", "【3】16 AWG"]',
    "correct_answer": '["【0】12 or 14 AWG"]',
    "topic_name": "Electrical Wiring Methods and Electrical Materials",
    "category": "Wire Sizes",
    "level": 1,
    "status": 1,
    "exam_title": "Electrician Exam Prep Pro 2024"
  },
  {
    "uuid": "1a2b3c4d5e6f7g8h9j0k",
    "question":
        "What type of wiring method involves running wires inside walls and ceilings?",
    "explanation":
        "Concealed wiring involves running electrical wires inside walls and ceilings to provide a clean look.",
    "incorrect_answer":
        '["【1】Surface-mounted wiring", "【2】Open wiring", "【3】Exposed wiring"]',
    "correct_answer": '["【0】Concealed wiring"]',
    "topic_name": "Electrical Wiring Methods and Electrical Materials",
    "category": "Wiring Methods",
    "level": 1,
    "status": 1,
    "exam_title": "Electrician Exam Prep Pro 2024"
  },
  {
    "uuid": "2a3b4c5d6e7f8g9h0j1k",
    "question": "Which device is used to measure electrical current?",
    "explanation":
        "An ammeter is used to measure the amount of electrical current in a circuit.",
    "incorrect_answer": '["【1】Voltmeter", "【2】Wattmeter", "【3】Ohmmeter"]',
    "correct_answer": '["【0】Ammeter"]',
    "topic_name": "Electrical Wiring Methods and Electrical Materials",
    "category": "Measuring Devices",
    "level": 1,
    "status": 1,
    "exam_title": "Electrician Exam Prep Pro 2024"
  },
  {
    "uuid": "3a4b5c6d7e8f9g0h1j2k",
    "question":
        "What type of wiring is considered the safest for residential use?",
    "explanation":
        "Romex wiring is designed for safety and ease of installation in residential settings.",
    "incorrect_answer":
        '["【1】Knob and tube wiring", "【2】BX wiring", "【3】Flexible cord wiring"]',
    "correct_answer": '["【0】Romex wiring"]',
    "topic_name": "Electrical Wiring Methods and Electrical Materials",
    "category": "Wiring Types",
    "level": 1,
    "status": 1,
    "exam_title": "Electrician Exam Prep Pro 2024"
  },
  {
    "uuid": "4a5b6c7d8e9f0g1h2j3k",
    "question": "What does the 'N' in NM cable stand for?",
    "explanation":
        "The 'N' in NM cable stands for non-metallic, indicating that the cable is insulated.",
    "incorrect_answer": '["【1】New", "【2】Neutral", "【3】Normal"]',
    "correct_answer": '["【0】Non-metallic"]',
    "topic_name": "Electrical Wiring Methods and Electrical Materials",
    "category": "Cable Types",
    "level": 1,
    "status": 1,
    "exam_title": "Electrician Exam Prep Pro 2024"
  },
  {
    "uuid": "5a6b7c8d9e0f1g2h3j4k",
    "question": "What is the purpose of a GFCI outlet?",
    "explanation":
        "A GFCI outlet protects against electrical shocks by cutting off power if it detects an imbalance in current.",
    "incorrect_answer":
        '["【1】To increase voltage", "【2】To measure current", "【3】To reduce energy consumption"]',
    "correct_answer": '["【0】To protect against electrical shocks"]',
    "topic_name": "Electrical Wiring Methods and Electrical Materials",
    "category": "Outlets",
    "level": 1,
    "status": 1,
    "exam_title": "Electrician Exam Prep Pro 2024"
  },
  {
    "uuid": "6a7b8c9d0e1f2g3h4j5k",
    "question":
        "What type of wire is typically used for heavy-duty applications?",
    "explanation":
        "Larger gauge wires, such as 6 AWG or 8 AWG, are used for heavy-duty applications to handle higher current loads.",
    "incorrect_answer": '["【1】14 AWG", "【2】16 AWG", "【3】20 AWG"]',
    "correct_answer": '["【0】6 AWG or 8 AWG"]',
    "topic_name": "Electrical Wiring Methods and Electrical Materials",
    "category": "Wire Sizes",
    "level": 1,
    "status": 1,
    "exam_title": "Electrician Exam Prep Pro 2024"
  },
  {
    "uuid": "7a8b9c0d1e2f3g4h5j6k",
    "question": "What is the purpose of a disconnect switch?",
    "explanation":
        "A disconnect switch provides a way to safely cut off power to a circuit for maintenance or repair.",
    "incorrect_answer":
        '["【1】To increase voltage", "【2】To connect circuits", "【3】To measure current"]',
    "correct_answer": '["【0】To safely cut off power"]',
    "topic_name": "Electrical Wiring Methods and Electrical Materials",
    "category": "Switches",
    "level": 1,
    "status": 1,
    "exam_title": "Electrician Exam Prep Pro 2024"
  },
  {
    "uuid": "8a9b0c1d2e3f4g5h6j7k",
    "question":
        "What is the standard wire gauge (AWG) for most household outlets?",
    "explanation":
        "Most household outlets are typically wired with 12 AWG wire, suitable for most circuits.",
    "incorrect_answer": '["【1】10 AWG", "【2】14 AWG", "【3】16 AWG"]',
    "correct_answer": '["【0】12 AWG"]',
    "topic_name": "Electrical Wiring Methods and Electrical Materials",
    "category": "Wire Sizes",
    "level": 1,
    "status": 1,
    "exam_title": "Electrician Exam Prep Pro 2024"
  },
  {
    "uuid": "9a0b1c2d3e4f5g6h7j8k",
    "question": "What is the primary function of electrical conduit?",
    "explanation":
        "Electrical conduit protects electrical wiring from physical damage and environmental conditions.",
    "incorrect_answer":
        '["【1】To increase voltage", "【2】To store energy", "【3】To reduce resistance"]',
    "correct_answer": '["【0】To protect electrical wiring"]',
    "topic_name": "Electrical Wiring Methods and Electrical Materials",
    "category": "Conduit Use",
    "level": 1,
    "status": 1,
    "exam_title": "Electrician Exam Prep Pro 2024"
  },
  {
    "uuid": "0a1b2c3d4e5f6g7h8j9k",
    "question": "Which of the following is NOT a type of electrical conduit?",
    "explanation":
        "While PVC, EMT, and flexible metal conduit are common types, 'organic conduit' is not a recognized type.",
    "incorrect_answer": '["【1】PVC", "【2】EMT", "【3】Flexible metal"]',
    "correct_answer": '["【0】Organic conduit"]',
    "topic_name": "Electrical Wiring Methods and Electrical Materials",
    "category": "Conduit Types",
    "level": 1,
    "status": 1,
    "exam_title": "Electrician Exam Prep Pro 2024"
  },
  {
    "uuid": "1a2b3c4d5e6f7g8h9j0k",
    "question": "What is the role of a wire gauge in electrical systems?",
    "explanation":
        "Wire gauge determines the current-carrying capacity of the wire; smaller gauges can carry more current.",
    "incorrect_answer":
        '["【1】To measure voltage", "【2】To reduce heat", "【3】To increase resistance"]',
    "correct_answer": '["【0】To determine current-carrying capacity"]',
    "topic_name": "Electrical Wiring Methods and Electrical Materials",
    "category": "Wire Gauge",
    "level": 1,
    "status": 1,
    "exam_title": "Electrician Exam Prep Pro 2024"
  },
  {
    "uuid": "2a3b4c5d6e7f8g9h0j1k",
    "question":
        "What type of cable is used for outdoor applications and is UV-resistant?",
    "explanation":
        "UF (Underground Feeder) cable is designed for outdoor use and is resistant to ultraviolet light.",
    "incorrect_answer": '["【1】NM cable", "【2】THHN cable", "【3】MC cable"]',
    "correct_answer": '["【0】UF cable"]',
    "topic_name": "Electrical Wiring Methods and Electrical Materials",
    "category": "Cable Types",
    "level": 1,
    "status": 1,
    "exam_title": "Electrician Exam Prep Pro 2024"
  },
  {
    "uuid": "3a4b5c6d7e8f9g0h1j2k",
    "question": "Which color indicates a hot wire in electrical systems?",
    "explanation":
        "Red and black wires typically indicate hot wires in electrical circuits.",
    "incorrect_answer": '["【1】White", "【2】Green", "【3】Blue"]',
    "correct_answer": '["【0】Red or black"]',
    "topic_name": "Electrical Wiring Methods and Electrical Materials",
    "category": "Wire Color Codes",
    "level": 1,
    "status": 1,
    "exam_title": "Electrician Exam Prep Pro 2024"
  },
  {
    "uuid": "4a5b6c7d8e9f0g1h2j3k",
    "question": "What is the main purpose of a circuit panel?",
    "explanation":
        "A circuit panel distributes electrical power to various circuits in a building and houses circuit breakers.",
    "incorrect_answer":
        '["【1】To store energy", "【2】To measure voltage", "【3】To increase power"]',
    "correct_answer": '["【0】To distribute electrical power"]',
    "topic_name": "Electrical Wiring Methods and Electrical Materials",
    "category": "Panels",
    "level": 1,
    "status": 1,
    "exam_title": "Electrician Exam Prep Pro 2024"
  },
  {
    "uuid": "5a6b7c8d9e0f1g2h3j4k",
    "question":
        "What type of device is used to protect circuits from overloads?",
    "explanation":
        "Circuit breakers are devices that automatically stop the flow of electricity when an overload occurs.",
    "incorrect_answer": '["【1】Fuses", "【2】Transformers", "【3】Switches"]',
    "correct_answer": '["【0】Circuit breakers"]',
    "topic_name": "Electrical Wiring Methods and Electrical Materials",
    "category": "Protection Devices",
    "level": 1,
    "status": 1,
    "exam_title": "Electrician Exam Prep Pro 2024"
  },
  {
    "uuid": "6a7b8c9d0e1f2g3h4j5k",
    "question": "What is the typical use of 14 AWG wire?",
    "explanation":
        "14 AWG wire is commonly used for general-purpose circuits, including lighting and receptacle circuits.",
    "incorrect_answer":
        '["【1】Heavy-duty equipment", "【2】Low-voltage systems", "【3】High-power appliances"]',
    "correct_answer": '["【0】General-purpose circuits"]',
    "topic_name": "Electrical Wiring Methods and Electrical Materials",
    "category": "Wire Uses",
    "level": 1,
    "status": 1,
    "exam_title": "Electrician Exam Prep Pro 2024"
  },
  {
    "uuid": "7a8b9c0d1e2f3g4h5j6k",
    "question": "Which of the following is a common type of flexible cable?",
    "explanation":
        "SO cord is a common type of flexible cable used in power supply applications.",
    "incorrect_answer": '["【1】THHN", "【2】NM", "【3】EMT"]',
    "correct_answer": '["【0】SO cord"]',
    "topic_name": "Electrical Wiring Methods and Electrical Materials",
    "category": "Cable Types",
    "level": 1,
    "status": 1,
    "exam_title": "Electrician Exam Prep Pro 2024"
  },
  {
    "uuid": "8a9b0c1d2e3f4g5h6j7k",
    "question": "What type of wire is suitable for wet locations?",
    "explanation":
        "Wires rated for wet locations, such as UF or THWN, are designed to withstand moisture.",
    "incorrect_answer": '["【1】NM cable", "【2】Romex", "【3】Aluminum wire"]',
    "correct_answer": '["【0】UF or THWN"]',
    "topic_name": "Electrical Wiring Methods and Electrical Materials",
    "category": "Wire Ratings",
    "level": 1,
    "status": 1,
    "exam_title": "Electrician Exam Prep Pro 2024"
  },
  {
    "uuid": "9a0b1c2d3e4f5g6h7j8k",
    "question":
        "Which material is commonly used for residential electrical wire?",
    "explanation":
        "Copper is the most commonly used material for residential electrical wiring due to its excellent conductivity.",
    "incorrect_answer": '["【1】Aluminum", "【2】Steel", "【3】Plastic"]',
    "correct_answer": '["【0】Copper"]',
    "topic_name": "Electrical Wiring Methods and Electrical Materials",
    "category": "Wire Materials",
    "level": 1,
    "status": 1,
    "exam_title": "Electrician Exam Prep Pro 2024"
  },
  {
    "uuid": "0a1b2c3d4e5f6g7h8j9k",
    "question": "What is the typical installation method for wiring in attics?",
    "explanation":
        "Wiring in attics is usually installed in conduit or secured to the framing to protect it from physical damage.",
    "incorrect_answer":
        '["【1】Loosely placed", "【2】Exposed on the floor", "【3】Hanging freely"]',
    "correct_answer": '["【0】Secured to framing or in conduit"]',
    "topic_name": "Electrical Wiring Methods and Electrical Materials",
    "category": "Installation Methods",
    "level": 1,
    "status": 1,
    "exam_title": "Electrician Exam Prep Pro 2024"
  },
  {
    "uuid": "1a2b3c4d5e6f7g8h9j0k",
    "question": "Which device is commonly used to convert AC to DC?",
    "explanation":
        "A rectifier is used to convert alternating current (AC) to direct current (DC).",
    "incorrect_answer": '["【1】Inverter", "【2】Transformer", "【3】Capacitor"]',
    "correct_answer": '["【0】Rectifier"]',
    "topic_name": "Electrical Wiring Methods and Electrical Materials",
    "category": "Conversion Devices",
    "level": 1,
    "status": 1,
    "exam_title": "Electrician Exam Prep Pro 2024"
  },
  {
    "uuid": "2a3b4c5d6e7f8g9h0j1k",
    "question": "What is the purpose of a transformer?",
    "explanation":
        "A transformer is used to change the voltage level in an AC circuit, either increasing or decreasing it.",
    "incorrect_answer":
        '["【1】To store energy", "【2】To convert DC to AC", "【3】To measure current"]',
    "correct_answer": '["【0】To change voltage levels"]',
    "topic_name": "Electrical Wiring Methods and Electrical Materials",
    "category": "Transformers",
    "level": 1,
    "status": 1,
    "exam_title": "Electrician Exam Prep Pro 2024"
  },
  {
    "uuid": "3a4b5c6d7e8f9g0h1j2k",
    "question":
        "Which is a common type of electrical box used for wiring connections?",
    "explanation":
        "Junction boxes are commonly used for making electrical connections and protecting them.",
    "incorrect_answer": '["【1】Toolbox", "【2】Storage box", "【3】Control box"]',
    "correct_answer": '["【0】Junction box"]',
    "topic_name": "Electrical Wiring Methods and Electrical Materials",
    "category": "Boxes",
    "level": 1,
    "status": 1,
    "exam_title": "Electrician Exam Prep Pro 2024"
  },
  {
    "uuid": "4a5b6c7d8e9f0g1h2j3k",
    "question": "What is the function of a relay in an electrical circuit?",
    "explanation":
        "A relay is an electrically operated switch used to control a circuit by a low-power signal.",
    "incorrect_answer":
        '["【1】To increase current", "【2】To measure voltage", "【3】To store energy"]',
    "correct_answer": '["【0】To control a circuit"]',
    "topic_name": "Electrical Wiring Methods and Electrical Materials",
    "category": "Control Devices",
    "level": 1,
    "status": 1,
    "exam_title": "Electrician Exam Prep Pro 2024"
  },
  {
    "uuid": "5a6b7c8d9e0f1g2h3j4k",
    "question": "What is a common cause of electrical fires?",
    "explanation":
        "Electrical fires can often be caused by overloaded circuits or faulty wiring.",
    "incorrect_answer":
        '["【1】Low power consumption", "【2】Proper installation", "【3】Quality materials"]',
    "correct_answer": '["【0】Overloaded circuits"]',
    "topic_name": "Electrical Wiring Methods and Electrical Materials",
    "category": "Safety",
    "level": 1,
    "status": 1,
    "exam_title": "Electrician Exam Prep Pro 2024"
  },
  {
    "uuid": "6a7b8c9d0e1f2g3h4j5k",
    "question": "What does the term 'voltage drop' refer to?",
    "explanation":
        "Voltage drop is the reduction in voltage in an electrical circuit as energy is used.",
    "incorrect_answer":
        '["【1】Voltage increase", "【2】Power gain", "【3】Energy storage"]',
    "correct_answer": '["【0】Reduction in voltage"]',
    "topic_name": "Electrical Wiring Methods and Electrical Materials",
    "category": "Basic Concepts",
    "level": 1,
    "status": 1,
    "exam_title": "Electrician Exam Prep Pro 2024"
  },
  {
    "uuid": "7a8b9c0d1e2f3g4h5j6k",
    "question": "What is the role of a capacitor in electrical circuits?",
    "explanation":
        "A capacitor stores and releases electrical energy in a circuit, smoothing out fluctuations.",
    "incorrect_answer":
        '["【1】To convert AC to DC", "【2】To increase voltage", "【3】To measure current"]',
    "correct_answer": '["【0】To store electrical energy"]',
    "topic_name": "Electrical Wiring Methods and Electrical Materials",
    "category": "Passive Components",
    "level": 1,
    "status": 1,
    "exam_title": "Electrician Exam Prep Pro 2024"
  },
  {
    "uuid": "8a9b0c1d2e3f4g5h6j7k",
    "question": "What does the term 'short circuit' mean?",
    "explanation":
        "A short circuit occurs when a low-resistance path forms, allowing excess current to flow and potentially causing a fire.",
    "incorrect_answer":
        '["【1】High resistance flow", "【2】Normal current flow", "【3】Power loss"]',
    "correct_answer": '["【0】Low-resistance path for current"]',
    "topic_name": "Electrical Wiring Methods and Electrical Materials",
    "category": "Basic Concepts",
    "level": 1,
    "status": 1,
    "exam_title": "Electrician Exam Prep Pro 2024"
  },
  {
    "uuid": "9a0b1c2d3e4f5g6h7j8k",
    "question":
        "What does the term 'grounding' refer to in electrical systems?",
    "explanation":
        "Grounding provides a safe path for electricity to follow in case of a fault, reducing the risk of shock or fire.",
    "incorrect_answer":
        '["【1】Storing energy", "【2】Increasing voltage", "【3】Measuring current"]',
    "correct_answer": '["【0】Providing a safe path for electricity"]',
    "topic_name": "Electrical Wiring Methods and Electrical Materials",
    "category": "Safety",
    "level": 1,
    "status": 1,
    "exam_title": "Electrician Exam Prep Pro 2024"
  }
];
