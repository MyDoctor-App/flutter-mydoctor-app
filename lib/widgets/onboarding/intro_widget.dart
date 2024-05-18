import 'package:flutter/material.dart';
import 'package:my_doctor_app/screens/welcome_screen.dart';
import 'package:page_transition/page_transition.dart';

class IntroWidget extends StatelessWidget {
  const IntroWidget({
    super.key,
    required this.color,
    required this.title,
    required this.description,
    required this.skip,
    required this.image,
    required this.onTab,
    required this.index,
  });

  final String color;
  final String title;
  final String description;
  final bool skip;
  final String image;
  final VoidCallback onTab;
  final int index;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: hexToColor(color),
      child: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height / 1.86,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(image), fit: BoxFit.scaleDown)),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            left: 0,
            child: Container(
              height: MediaQuery.of(context).size.height / 2.16,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: index == 0
                        ? const Radius.circular(100)
                        : const Radius.circular(0),
                    topRight: index == 2
                        ? const Radius.circular(100)
                        : const Radius.circular(0),
                  )),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 45),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 62,
                    ),
                    Text(title,
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold)),
                    const SizedBox(
                      height: 16,
                    ),
                    Text(
                      description,
                      style: const TextStyle(
                          fontSize: 18, height: 1.5, color: Colors.black45),
                      textAlign: TextAlign.center,
                    )
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            right: 0,
            left: 0,
            child: Padding(
                padding: const EdgeInsets.all(16),
                child: skip
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: onTab,
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                  color: hexToColor(color),
                                  borderRadius: BorderRadius.circular(50)),
                              child: const Icon(Icons.arrow_circle_right,
                                  color: Colors.white, size: 42),
                            ),
                          )
                        ],
                      )
                    : SizedBox(
                        height: 46,
                        child: MaterialButton(
                          color: hexToColor(color),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              PageTransition(
                                duration: const Duration(milliseconds: 600),
                                type: PageTransitionType.theme,
                                child: const WelcomeScreen(),
                              ),
                            );
                          },
                          child: const Text('Começar Agora',
                              style: TextStyle(color: Colors.white)),
                        ),
                      )),
          )
        ],
      ),
    );
  }
}

Color hexToColor(String hex) {
  assert(RegExp(r'^#([0-9a-fA-F]{6})|([0-9a-fA-F]{8})$').hasMatch(hex));

  return Color(int.parse(hex.substring(1), radix: 16) +
      (hex.length == 7 ? 0xFF000000 : 0x00000000));
}
