import 'package:flutter/material.dart';
import 'package:whatsapp/core/common/widgets/what_button.dart';
import 'package:whatsapp/core/res/colors.dart';
import 'package:whatsapp/core/res/res.dart';
import 'package:whatsapp/src/auth/views/login_screen.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  static const id = '/';

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ListView(
            shrinkWrap: true,
            children: [
              const SizedBox(height: 50),
              const Text(
                'Welcome to WhatsApp',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 33,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: size.height / 9),
              ShaderMask(
                // shader mask for circular image
                shaderCallback: (rect) {
                  return RadialGradient(
                    colors: [
                      tabColor,
                      tabColor,
                      tabColor.withOpacity(.9),
                      tabColor.withOpacity(.8),
                      tabColor.withOpacity(.7),
                      tabColor.withOpacity(.6),
                      tabColor.withOpacity(.4),
                      tabColor.withOpacity(.2),
                      Colors.transparent,
                    ],
                  ).createShader(
                    Rect.fromLTRB(0, 0, rect.width, rect.height),
                  );
                },
                child: Image.asset(
                  Res.bg,
                  color: tabColor,
                ),
              ),
              SizedBox(height: size.height / 9),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Text(
                  'Read our Privacy Policy. Tap, "Agree and continue" to accept '
                  'the Terms of Service',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: size.width * .75,
                child: WhatButton(
                  text: 'AGREE AND CONTINUE',
                  onPressed: () => Navigator.pushNamed(context, LoginScreen.id),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
