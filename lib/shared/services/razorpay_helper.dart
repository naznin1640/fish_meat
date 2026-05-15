import 'package:dio/dio.dart';
import 'package:fish_meat/shared/services/api_services.dart';
import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class RazorpayHelper {
  late Razorpay _razorpay;
  final Dio _dio = ApiServices().dio;

  final VoidCallback onSuccess;
  final VoidCallback onFailure;

  String? _currentRazorpayOrderId;

  RazorpayHelper({required this.onSuccess, required this.onFailure}) {
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  Future<void> openCheckout({
    required double amount,
    required String name,
    required String description,
    required String contact,
    required String email,
    required String address,
    required String pincode,
    int discountAmount = 222,
    String? preOrder,
  }) async {
    try {
      debugPrint("Calling /checkouts...");
      debugPrint("Sending amount: $amount");

      final Map<String, dynamic> body = {
        "discountAmount": discountAmount,
        "address": address,
        "pincode": pincode,
      };
      if(preOrder != null){
        body['preOrder'] = preOrder;
      }

      final res = await _dio.post("/checkouts", data: body);

      final data = res.data["data"];
      if (data == null) {
        debugPrint("Checkout failed: data is null");
        onFailure();
        return;
      }

      debugPrint("Full checkout data: $data");

      final razorpayOrderId = data["razorpayOrderId"]?.toString();

      final orderAmount = ((data["amount"] ?? 0) as num).toInt();

      debugPrint("razorpayOrderId: $razorpayOrderId");
      debugPrint("orderAmount from backend: $orderAmount");

      if (razorpayOrderId == null || razorpayOrderId.isEmpty) {
        debugPrint("razorpayOrderId is null or empty");
        onFailure();
        return;
      }

      _currentRazorpayOrderId = razorpayOrderId;

      final options = {
        'key': 'rzp_test_SnyDzdHOCuvIhI',
        'amount': orderAmount * 100,
        // 'order_id': razorpayOrderId,
        'name': name,
        'description': description,
        'prefill': {'contact': contact, 'email': email},
        'theme': {'color': '#03213A'},
      };

      _razorpay.open(options);
    } on DioException catch (e) {
      debugPrint("Checkout error: ${e.response?.data}");
      onFailure();
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    debugPrint("Payment SUCCESS");
    debugPrint("   paymentId: ${response.paymentId}");
    debugPrint("   orderId:   ${response.orderId}");
    debugPrint("   signature: ${response.signature}");

    final orderId = response.orderId ?? _currentRazorpayOrderId;

    if (orderId != null && response.paymentId != null) {
      try {
        final confirmRes = await _dio.post(
          "/checkouts/comfirm-payment",
          data: {
            "orderId": orderId,
            "paymentId": response.paymentId,
            "status": "PAID",
          },
        );
        debugPrint("Payment confirmed: ${confirmRes.data}");
      } on DioException catch (e) {
        debugPrint("Confirm payment error: ${e.response?.data}");
      }
    }

    onSuccess();
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    debugPrint("Payment ERROR: ${response.message}");
    onFailure();
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    debugPrint("External wallet: ${response.walletName}");
  }

  void dispose() {
    _razorpay.clear();
  }
}
