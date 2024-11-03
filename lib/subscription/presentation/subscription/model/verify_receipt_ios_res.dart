import 'package:electrician/subscription/presentation/subscription/model/purchase_receipt_ios.dart';
import 'package:http/http.dart' as http;

class VerifyReceiptIOSRes {
  final PurchaseReceiptIOS purchaseReceiptIOS;
  final http.Response response;
  VerifyReceiptIOSRes(
      {required this.purchaseReceiptIOS, required this.response});
}
