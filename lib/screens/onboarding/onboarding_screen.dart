import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:my_doctor_app/widgets/onboarding/intro_widget.dart';

class AppScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  final PageController _pageController = PageController();

  int _activePage = 0;

  void onNextPage() {
    if (_activePage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 1000),
        curve: Curves.fastEaseInToSlowEaseOut,
      );
    }
  }

  final List<Map<String, dynamic>> _pages = [
    {
      'color': '#60A3D9',
      'title': 'Bem vindo(a) ao MyDoctor!',
      'image': 'assets/images/img10.png',
      'description':
          "Bem-vindo ao aplicativo que torna o gerenciamento da sua saúde mais fácil do que nunca!",
      'skip': true
    },
    {
      'color': '#0074B7',
      'title': 'Você no controle!',
      'image': 'assets/images/img3.png',
      'description':
          'Sua jornada de saúde começa aqui! Descubra um aplicativo que coloca você no controle da sua saúde para uma vida mais saudável e feliz.',
      'skip': true
    },
    {
      'color': '#003B73',
      'title': 'Comece sua jornada',
      'image': 'assets/images/img4.png',
      'description':
          'Gerencie sua saúde a qualquer hora, em qualquer lugar, a partir do conforto do seu próprio dispositivo.',
      'skip': false
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
              controller: _pageController,
              itemCount: _pages.length,
              scrollBehavior: AppScrollBehavior(),
              onPageChanged: (int page) {
                setState(() {
                  _activePage = page;
                });
              },
              itemBuilder: (BuildContext context, int index) {
                return IntroWidget(
                  index: index,
                  color: _pages[index]['color'],
                  title: _pages[index]['title'],
                  description: _pages[index]['description'],
                  image: _pages[index]['image'],
                  skip: _pages[index]['skip'],
                  onTab: onNextPage,
                );
              }),
          Positioned(
            top: MediaQuery.of(context).size.height / 1.75,
            right: 0,
            left: 0,
            child: Column(
              children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: _buildIndicator())
              ],
            ),
          )
        ],
      ),
    );
  }

  List<Widget> _buildIndicator() {
    final indicators = <Widget>[];

    for (var i = 0; i < _pages.length; i++) {
      if (_activePage == i) {
        indicators.add(_indicatorsTrue());
      } else {
        indicators.add(_indicatorsFalse());
      }
    }
    return indicators;
  }

  Widget _indicatorsTrue() {
    final String color;
    if (_activePage == 0) {
      color = '#60A3D9';
    } else if (_activePage == 1) {
      color = '#0074B7';
    } else {
      color = '#003B73';
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 700),
      height: 6,
      width: 42,
      margin: const EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: hexToColor(color),
      ),
    );
  }

  Widget _indicatorsFalse() {
    return AnimatedContainer(
      duration: const Duration(microseconds: 700),
      height: 8,
      width: 8,
      margin: const EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: Colors.grey.shade100,
      ),
    );
  }
}
