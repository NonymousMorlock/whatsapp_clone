import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp/core/utils/utils.dart';
import 'package:whatsapp/src/auth/controller/auth_controller.dart';
import 'package:whatsapp/src/auth/views/user_information_screen.dart';

class OTPScreen extends ConsumerWidget {
  const OTPScreen({
    super.key,
    required this.verificationId,
    required this.unformattedNumber,
  });

  static const id = '/otp-verification';

  final String verificationId;
  final String unformattedNumber;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verifying your number'),
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Text('We have sent an SMS with a code'),
            SizedBox(
              width: size.width * .5,
              child: TextField(
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: '- - - - - -',
                  hintStyle: TextStyle(
                    fontSize: 30,
                  ),
                ),
                inputFormatters: [
                  MaskedInputFormatter('# # # # # #'),
                ],
                onChanged: (val) async {
                  final navigator = Navigator.of(context);
                  if (val.replaceAll(' ', '').length == 6) {
                    FocusManager.instance.primaryFocus?.unfocus();
                    Utils.showLoadingDialog(
                      context: context,
                      loadingMessage: 'Verifying OTP...',
                    );
                    final error = await ref
                        .read<AuthController>(authControllerProvider)
                        .verifyOTP(
                          context: context,
                          verificationID: verificationId,
                          otp: val.replaceAll(' ', ''),
                        );
                    navigator.pop();
                    if (error == null) {
                      await navigator.pushNamedAndRemoveUntil(
                        UserInformationScreen.id,
                        (_) => false,
                        arguments: unformattedNumber,
                      );
                    } else {
                      debugPrint('ERROR: $error');
                    }
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
