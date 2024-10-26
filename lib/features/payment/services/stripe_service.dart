import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:dio/dio.dart';

class StripeService {
  final Dio _dio;

  StripeService() : _dio = Dio();

  Future<PaymentIntent> createPaymentIntent(double amount, String currency) async {
    try {
      final response = await _dio.post(
        '/api/create-payment-intent',
        data: {
          'amount': (amount * 100).toInt(), // Convert to cents
          'currency': currency,
        },
      );

      return PaymentIntent(
        clientSecret: response.data['clientSecret'],
        id: response.data['id'],
      );
    } catch (e) {
      throw Exception('Failed to create payment intent: $e');
    }
  }

  Future<bool> handlePayment(double amount, String currency) async {
    try {
      // Create payment intent
      final paymentIntent = await createPaymentIntent(amount, currency);

      // Confirm payment with Stripe SDK
      await Stripe.instance.confirmPayment(
        paymentIntent.clientSecret,
        const PaymentMethodParams.card(
          paymentMethodData: PaymentMethodData(),
        ),
      );

      return true;
    } catch (e) {
      return false;
    }
  }
}

class PaymentIntent {
  final String clientSecret;
  final String id;

  PaymentIntent({
    required this.clientSecret,
    required this.id,
  });
}