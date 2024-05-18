import 'package:flutter/material.dart';
import 'package:my_doctor_app/screens/login/signin_screen.dart';
import 'package:my_doctor_app/theme/theme.dart';
import 'package:my_doctor_app/widgets/buttons/rounded_button.dart';
import 'package:my_doctor_app/widgets/scafold/custom_scaffold.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      child: Column(
        children: [
          Flexible(
              flex: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 0,
                  horizontal: 40.0,
                ),
              )),
          Flexible(
            flex: 1,
            child: Align(
              alignment: Alignment.bottomRight,
              child: Row(
                children: [
                  Expanded(
                    child: SimpleRoundButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (e) => const SignInScreen(),
                          ),
                        );
                      },
                      backgroundColor: lightColorScheme.onSecondary,
                      buttonText: Text(
                        "LOGIN",
                        style: TextStyle(color: lightColorScheme.primary),
                      ),
                    ),
                  ),
                  // Expanded(
                  //   child: WelcomeButton(
                  //     buttonText: 'Cadastre-se',
                  //     onTap: const SignUpScreen(),
                  //     color: Colors.white,
                  //     textColor: lightColorScheme.primary,
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
