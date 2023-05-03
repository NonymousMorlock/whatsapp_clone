import 'package:country_picker/country_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp/core/common/widgets/what_button.dart';
import 'package:whatsapp/core/extensions/string_extensions.dart';
import 'package:whatsapp/core/utils/utils.dart';
import 'package:whatsapp/src/auth/controller/auth_controller.dart';
import 'package:whatsapp/src/auth/views/otp_screen.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  static const id = '/login';

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final phoneController = TextEditingController();

  Country? country;

  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enter your phone number'),
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            const Text(
              'WhatsApp will send an SMS message to verify your phone number. '
              'Enter your country code and phone number:',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () {
                showCountryPicker(
                  context: context,
                  onSelect: (Country country) {
                    if (country == this.country) return;
                    setState(() {
                      this.country = country;
                    });
                  },
                );
              },
              child: Text(country == null ? 'Pick country' : 'Change'),
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                if (country != null)
                  Text(
                    '+${country!.phoneCode}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: phoneController,
                    style: const TextStyle(
                      fontSize: 20,
                    ),
                    decoration: const InputDecoration(
                      hintText: 'Enter your phone number',
                    ),
                    inputFormatters: [
                      PhoneInputFormatter(
                        defaultCountryCode: country?.countryCode,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Spacer(),
            SizedBox(
              width: 90,
              child: WhatButton(
                onPressed: () async {
                  FocusManager.instance.primaryFocus?.unfocus();
                  final phoneNumber = phoneController.text.trim();
                  if (country != null) {
                    if (phoneNumber.isNotEmpty) {
                      if (isPhoneValid(
                        phoneNumber,
                        defaultCountryCode: country!.countryCode,
                      )) {
                        final formattedNumber =
                            '+${country!.phoneCode}${phoneNumber.onlyNumbers}';
                        if (defaultTargetPlatform != TargetPlatform.iOS &&
                            defaultTargetPlatform != TargetPlatform.android) {
                          await Navigator.pushNamed(
                            context,
                            OTPScreen.id,
                            arguments: {
                              'verificationId': '123232',
                              'phone': '+233 23 321 2132'
                            },
                          );
                          return;
                        }
                        Utils.showLoadingDialog(
                          context: context,
                          loadingMessage: 'Verifying...',
                        );
                        await ref
                            .read<AuthController>(authControllerProvider)
                            .signInWithPhone(
                              context,
                              formattedNumber: formattedNumber,
                              unformattedNumber: '+${country!.phoneCode} '
                                  '$phoneNumber',
                            );
                      } else {
                        Utils.showSnackBar(
                          context: context,
                          content: 'Enter a valid phone number',
                        );
                      }
                    } else {
                      Utils.showSnackBar(
                        context: context,
                        content: 'Enter your phone number',
                      );
                    }
                  } else {
                    Utils.showSnackBar(
                      context: context,
                      content: 'Pick a Country!',
                    );
                  }
                },
                text: 'Next',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
