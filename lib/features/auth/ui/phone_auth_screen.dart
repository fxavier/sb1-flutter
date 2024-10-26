import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_ecommerce/core/di/service_locator.dart';
import 'package:flutter_ecommerce/features/auth/store/auth_store.dart';
import 'package:go_router/go_router.dart';

class PhoneAuthScreen extends StatefulWidget {
  const PhoneAuthScreen({super.key});

  @override
  State<PhoneAuthScreen> createState() => _PhoneAuthScreenState();
}

class _PhoneAuthScreenState extends State<PhoneAuthScreen> {
  final _authStore = getIt<AuthStore>();
  final _phoneController = TextEditingController();
  final _otpController = TextEditingController();
  bool _otpSent = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Phone Authentication'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (!_otpSent) ...[
                      Text(
                        'Enter your phone number',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 24),
                      TextFormField(
                        controller: _phoneController,
                        decoration: const InputDecoration(
                          labelText: 'Phone Number',
                          border: OutlineInputBorder(),
                          prefixText: '+',
                        ),
                        keyboardType: TextInputType.phone,
                      ),
                      const SizedBox(height: 24),
                      Observer(
                        builder: (context) {
                          return Column(
                            children: [
                              SizedBox(
                                width: double.infinity,
                                child: FilledButton(
                                  onPressed: _authStore.isLoading
                                      ? null
                                      : _handleSendOtp,
                                  child: _authStore.isLoading
                                      ? const CircularProgressIndicator()
                                      : const Text('Send OTP'),
                                ),
                              ),
                              if (_authStore.error != null) ...[
                                const SizedBox(height: 16),
                                Text(
                                  _authStore.error!,
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.error,
                                  ),
                                ),
                              ],
                            ],
                          );
                        },
                      ),
                    ] else ...[
                      Text(
                        'Enter OTP',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'OTP sent to ${_phoneController.text}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 24),
                      TextFormField(
                        controller: _otpController,
                        decoration: const InputDecoration(
                          labelText: 'OTP',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        maxLength: 6,
                      ),
                      const SizedBox(height: 24),
                      Observer(
                        builder: (context) {
                          return Column(
                            children: [
                              SizedBox(
                                width: double.infinity,
                                child: FilledButton(
                                  onPressed: _authStore.isLoading
                                      ? null
                                      : _handleVerifyOtp,
                                  child: _authStore.isLoading
                                      ? const CircularProgressIndicator()
                                      : const Text('Verify OTP'),
                                ),
                              ),
                              const SizedBox(height: 16),
                              TextButton(
                                onPressed: _authStore.isLoading
                                    ? null
                                    : _handleResendOtp,
                                child: const Text('Resend OTP'),
                              ),
                              if (_authStore.error != null) ...[
                                const SizedBox(height: 16),
                                Text(
                                  _authStore.error!,
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.error,
                                  ),
                                ),
                              ],
                            ],
                          );
                        },
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleSendOtp() async {
    try {
      await _authStore.sendOtp(_phoneController.text);
      setState(() => _otpSent = true);
    } catch (e) {
      // Error is handled by the store
    }
  }

  Future<void> _handleVerifyOtp() async {
    try {
      await _authStore.verifyOtp(
        _phoneController.text,
        _otpController.text,
      );
      if (mounted) {
        context.go('/products');
      }
    } catch (e) {
      // Error is handled by the store
    }
  }

  Future<void> _handleResendOtp() async {
    _otpController.clear();
    await _handleSendOtp();
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _otpController.dispose();
    super.dispose();
  }
}