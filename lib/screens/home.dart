import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:my_doctor_app/screens/patient/patient_form.dart';
import 'package:my_doctor_app/screens/patient/patient_list.dart';
import 'package:page_transition/page_transition.dart';
import '../theme/theme.dart';
import 'package:intl/intl.dart';
//screens
import 'package:my_doctor_app/screens/doctor/doctor_form.dart';
import 'package:my_doctor_app/screens/doctor/doctor_list.dart';
import 'package:my_doctor_app/screens/welcome_screen.dart';

class MyHomePage extends StatelessWidget {
  final String? email;
  const MyHomePage({super.key, this.email});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Builder(builder: (context) {
      return Scaffold(
          backgroundColor: const Color(0xffffffff),
          body: Column(children: [
            Stack(
              children: [
                SizedBox(
                  height: size.height * .4,
                  width: size.width,
                ),
                GradientContainer(size),
                Positioned(
                  top: size.height * .15,
                  left: 30,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                       Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Bem vindo(a),",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 26,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 10, bottom: 5),
                            child: RichText(
                              text: TextSpan(
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 17,
                                ),
                                children: [
                                  TextSpan(text: "$email\n\n"),
                                  TextSpan(
                                    text: '', // Add a space before @MyDoctor
                                  ),
                                  TextSpan(
                                    text: 'Sessão: ${DateFormat('dd/MM/yyyy HH:mm:ss').format(DateTime.now())}',
                                    style: TextStyle(
                                      fontSize: 14.0, // Adjust subtext size if needed
                                      color: Colors.white.withOpacity(0.8), // Subdued white color for subtext
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(Icons.exit_to_app_outlined,
                              color: Colors.white),
                          TextButton(
                            // Wrap TextButton around text for functionality
                            onPressed: () {
                              Navigator.of(context).pop();
                              EasyLoading.show(status: 'Saindo...');
                              Future.delayed(const Duration(milliseconds: 1500), () {
                                EasyLoading.dismiss();
                              });
                            },
                            child: const Text(
                              "Sair",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            DevicesGridDashboard(size: size),
            const ScenesDashboard()
          ]));
    });
  }

  // ignore: non_constant_identifier_names
  Container GradientContainer(Size size) {
    return Container(
      height: size.height * .3,
      width: size.width,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
      ),
      child: Container(
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30)),
              color: lightColorScheme.primary)),
    );
  }
}

class ScenesDashboard extends StatelessWidget {
  const ScenesDashboard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 15),
            child: Text(
              "Minhas Consultas",
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 17),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                CardWidget(
                    subtitle: '13/05/2024',
                    icon: Icon(
                      Icons.bloodtype,
                      color: lightColorScheme.primary,
                    ),
                    title: 'Doação Sangue'),
                CardWidget(
                    subtitle: '22/05/2024',
                    icon: Icon(
                      Icons.medical_services,
                      color: lightColorScheme.primary,
                    ),
                    title: 'Neurologista'),
                CardWidget(
                    subtitle: '03/06/2024',
                    icon: Icon(
                      Icons.favorite,
                      color: lightColorScheme.primary,
                    ),
                    title: 'Cardiologista')
              ],
            ),
          )
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class CardWidget extends StatelessWidget {
  Icon icon;
  String title;
  String subtitle;

  CardWidget(
      {Key? key,
      required this.icon,
      required this.title,
      required this.subtitle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: SizedBox(
        height: 80,
        width: 200,
        child: Center(
          child: ListTile(
            leading: icon,
            title: Text(
              title,
              style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 14),
            ),
            subtitle: Text(
              subtitle,
              style: const TextStyle(
                  color: Colors.black54,
                  fontWeight: FontWeight.bold,
                  fontSize: 12),
            ),
          ),
        ),
      ),
    );
  }
}

class DevicesGridDashboard extends StatelessWidget {
  const DevicesGridDashboard({
    Key? key,
    required this.size,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    void showServiceNotAvailableSnackBar() {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          showCloseIcon: true,
          content: Text('Serviço não está disponível no momento.'),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(bottom: 15),
            child: Text(
              "Serviços Disponíveis",
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 17),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: showServiceNotAvailableSnackBar,
                child: CardField(
                    size,
                    Colors.blue,
                    const Icon(
                      Icons.grade,
                      color: Colors.white,
                    ),
                    'Exames',
                    'Resultado'),
              ),
              GestureDetector(
                onTap: showServiceNotAvailableSnackBar,
                child: CardField(
                    size,
                    Colors.amber,
                    const Icon(Icons.assignment_add, color: Colors.white),
                    'Agendar',
                    'Consultas'),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    PageTransition(
                      duration: const Duration(milliseconds: 800),
                      type: PageTransitionType.theme,
                      child: DoctorListView(),
                    ),
                  );
                },
                child: CardField(
                    size,
                    Colors.orange,
                    const Icon(Icons.list, color: Colors.white),
                    'Listar',
                    'Médicos'),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    PageTransition(
                    duration: const Duration(milliseconds: 800),
                    type: PageTransitionType.theme,
                    child: PatientListView(),
                    ),
                  );
                },
                child: CardField(
                    size,
                    Colors.teal,
                    const Icon(Icons.list,
                        color: Colors.white),
                    'Listar',
                    'Pacientes'),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  // Handle "Cadastro Pacientes" tap here (e.g., navigate to a new screen)
                  Navigator.push(
                    context,
                    PageTransition(
                      duration: const Duration(milliseconds: 800),
                      type: PageTransitionType.theme,
                      child: const DoctorFormPage(),
                    ),
                  );
                },
                child: CardField(
                  size,
                  Colors.green,
                  const Icon(Icons.person_add_alt_1, color: Colors.white),
                  'Cadastrar',
                  'Médicos',
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    PageTransition(
                      duration: const Duration(milliseconds: 800),
                      type: PageTransitionType.theme,
                      child: const PatientFormPage(),
                    ),
                  );
                },
                child: CardField(
                  size,
                  Colors.green,
                  const Icon(Icons.person_add_alt_1, color: Colors.white),
                  'Cadastrar',
                  'Pacientes',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ignore: non_constant_identifier_names
CardField(
  Size size,
  Color color,
  Icon icon,
  String title,
  String subtitle,
) {
  return Padding(
    padding: const EdgeInsets.all(2),
    child: Card(
        child: SizedBox(
            height: size.height * .1,
            width: size.width * .39,
            child: Center(
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: lightColorScheme.primary,
                  child: icon,
                ),
                title: Text(
                  title,
                  style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 14),
                ),
                subtitle: Text(
                  subtitle,
                  style: const TextStyle(
                      color: Color.fromARGB(255, 69, 69, 69),
                      fontWeight: FontWeight.bold,
                      fontSize: 13),
                ),
              ),
            ))),
  );
}
