import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp/core/common/responsive/mobile_layout_screen.dart';
import 'package:whatsapp/core/utils/utils.dart';
import 'package:whatsapp/src/auth/controller/auth_controller.dart';

class UserInformationScreen extends ConsumerStatefulWidget {
  const UserInformationScreen({super.key, required this.unformattedNumber});

  static const id = '/user-info';

  final String unformattedNumber;

  @override
  ConsumerState<UserInformationScreen> createState() =>
      _UserInformationScreenState();
}

class _UserInformationScreenState extends ConsumerState<UserInformationScreen> {
  final nameController = TextEditingController();
  File? image;

  late Size size;

  @override
  void didChangeDependencies() {
    size = MediaQuery.of(context).size;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 20),
              Stack(
                children: [
                  CircleAvatar(
                    backgroundImage: image == null
                        ? const NetworkImage(
                            'https://images.freeimages'
                            '.com/fic/images/icons/573/must_have/256/user.png',
                          )
                        : FileImage(image!) as ImageProvider,
                    radius: 64,
                  ),
                  Positioned(
                    bottom: -10,
                    right: 0,
                    child: IconButton(
                      onPressed: () async {
                        image = await Utils.pickImage(context);
                        setState(() {});
                      },
                      icon: const Icon(Icons.add_a_photo),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Container(
                    width: size.width * .85,
                    padding: const EdgeInsets.all(20),
                    child: TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        hintText: 'Enter your name',
                      ),
                    ),
                  ),
                  Baseline(
                    baseline: 50,
                    baselineType: TextBaseline.alphabetic,
                    child: IconButton(
                      onPressed: () async {
                        Utils.showLoadingDialog(
                          context: context,
                          loadingMessage: 'Creating Profile...',
                        );
                        final isSuccessful = await ref
                            .read(authControllerProvider)
                            .saveUserToFirebase(
                              name: nameController.text.trim(),
                              context: context,
                              profilePic: image,
                              unformattedNumber: widget.unformattedNumber,
                            );

                        if (isSuccessful) {
                          if (!mounted) return;
                          unawaited(
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              MobileLayoutScreen.id,
                              (route) => false,
                            ),
                          );
                        }
                      },
                      icon: const Icon(Icons.done),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
