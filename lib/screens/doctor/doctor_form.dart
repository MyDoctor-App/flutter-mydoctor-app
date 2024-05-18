// ignore_for_file: library_private_types_in_public_api

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
// screens
import 'package:my_doctor_app/screens/home.dart';
import 'package:my_doctor_app/theme/theme.dart';
import 'package:page_transition/page_transition.dart';

class DoctorFormPage extends StatefulWidget {
  const DoctorFormPage({Key? key}) : super(key: key);

  @override
  _DoctorFormPageState createState() => _DoctorFormPageState();
}

class _DoctorFormPageState extends State<DoctorFormPage> {
  final List<GlobalKey<FormState>> _formKey = [
    GlobalKey(),
    GlobalKey(),
    GlobalKey()
  ];
  int _currentStep = 0;

  // Map<String, dynamic> formData = {};

  TextEditingController name = TextEditingController();
  TextEditingController genero = TextEditingController();
  TextEditingController cpf = TextEditingController();
  TextEditingController celular = TextEditingController();

  TextEditingController crm_advice = TextEditingController();
  TextEditingController crm_number = TextEditingController();
  TextEditingController crm_province = TextEditingController();
  TextEditingController cbo = TextEditingController();

  TextEditingController email = TextEditingController();
  TextEditingController senha = TextEditingController();

  bool _obscureText = true;

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  Future<http.Response> postDoctorForm(
      String name,
      String genero,
      String cpf,
      String celular,
      String crm_advice,
      String crm_number,
      String crm_province,
      String cbo,
      String email,
      String senha) async {
    // Prepare the JSON data
    final Map<String, String> data = {
      "name": name,
      "sex": genero,
      "crm_advice": crm_advice,
      "crm_number": crm_number,
      "crm_province": crm_province,
      "cpf": cpf,
      "phone": celular,
      "email": email,
      "cbo": cbo,
      "password": senha
    };

    final jsonData = json.encode(data);

    // Set up the POST request
    final response = await http.post(
      Uri.parse("https://back-end-unisenai.onrender.com/doctor"),
      headers: {'Content-Type': 'application/json'},
      body: jsonData,
    );

    return response;
  }

  Widget _buildCustomControls(BuildContext context, ControlsDetails controls) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton(
          onPressed: controls.onStepCancel,
          child: Text(controls.currentStep == 0 ? '' : 'Anterior'),
        ),
        TextButton(
          style: TextButton.styleFrom(
            backgroundColor: lightColorScheme.primary, // Text color
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0), // Border radius
            ),
          ),
          onPressed: () async {
            if (controls.currentStep < 3) {
              controls.onStepContinue!();
            } else {
              // Handle last step completion (e.g., show a success message)
              bool isFormValidate = _formKey[0].currentState!.validate() &&
                  _formKey[1].currentState!.validate() &&
                  _formKey[2].currentState!.validate();
              if (isFormValidate) {
                EasyLoading.show(status: 'Cadastrando...');
                final response = await postDoctorForm(
                    name.text,
                    genero.text,
                    cpf.text,
                    celular.text,
                    crm_advice.text,
                    crm_number.text,
                    crm_province.text,
                    cbo.text,
                    email.text,
                    senha.text);
                EasyLoading.dismiss();

                if (response.statusCode == 200) {
                  // Successful request
                  // Process the response data here (e.g., show a success message)
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      showCloseIcon: true,
                      content: Text(
                        'Profissional cadastrado com sucesso!',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  );

                  Navigator.pop(context);

                } else {
                  // Handle errors
                  // Show an error message or handle the error appropriately
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    showCloseIcon: true,
                    content: Text(
                      'Dados incorretos/já existentes!',
                      style: TextStyle(color: Colors.white),
                    ),
                  ));
                }
              }
            }
          },
          child: Text(controls.currentStep == 4 - 1 ? 'Enviar' : 'Próximo',
              style: const TextStyle(color: Colors.white)),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro de Médicos'),
        foregroundColor: Colors.white,
        backgroundColor: lightColorScheme.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Stepper(
          controlsBuilder: _buildCustomControls,
          type: StepperType.vertical,
          currentStep: _currentStep,
          onStepContinue: () {
            setState(() {});

            final form = _formKey[_currentStep].currentState;
            if (_currentStep < 3) {
              if (form!.validate()) {
                form.save(); // Save form data if needed
                _currentStep += 1;
              }
            }

            if (_currentStep == 3) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  showCloseIcon: true,
                  content: Text(
                    'Revise os dados e envie o formulário.',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              );
            }
          },
          onStepCancel: () {
            if (_currentStep > 0) {
              setState(() {
                _currentStep--;
              });
            }
          },
          steps: [
            Step(
              isActive: _currentStep >= 0,
              state: _currentStep <= 0 ? StepState.editing : StepState.complete,
              title: const Text('Informações Pessoais'),
              content: Form(
                key: _formKey[0],
                child: Column(
                  children: [
                    const SizedBox(
                      height: 10.0,
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor insira o nome do profissional';
                        }
                        return null;
                      },
                      controller: name,
                      decoration: InputDecoration(
                        label: const Text('Nome'),
                        hintText: 'Nome do profissional',
                        hintStyle: const TextStyle(
                          color: Colors.black54,
                        ),
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.black, // Default border color
                          ),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.black, // Default border color
                          ),
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    DropdownButtonFormField<String>(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor selecione um gênero';
                        }
                        return null;
                      },
                      onChanged: (String? newValue) {
                        genero.text = newValue!;
                        setState(() {
                          //
                        });
                      },
                      decoration: InputDecoration(
                        label: const Text('Gênero'),
                        // Change label to "Tipo de Usuário"
                        hintText: '',
                        // Remove hint text as dropdown shows options
                        hintStyle: const TextStyle(
                          color: Colors.black26,
                        ),
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.black,
                          ),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.black,
                          ),
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 'm',
                          child: Text('Masculino'),
                        ),
                        DropdownMenuItem(
                          value: 'f',
                          child: Text('Feminino'),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            value.length < 11) {
                          return 'Por favor insira um CPF válido';
                        }
                        return null;
                      },
                      maxLength: 11,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      controller: cpf,
                      decoration: InputDecoration(
                        label: const Text('CPF'),
                        hintText: 'CPF',
                        hintStyle: const TextStyle(
                          color: Colors.black54,
                        ),
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.black, // Default border color
                          ),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.black, // Default border color
                          ),
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            value.length < 11) {
                          return 'Por favor insira um número válido';
                        }
                        return null;
                      },
                      maxLength: 11,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      controller: celular,
                      decoration: InputDecoration(
                        label: const Text('Celular'),
                        hintText: 'Celular',
                        hintStyle: const TextStyle(
                          color: Colors.black54,
                        ),
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.black, // Default border color
                          ),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.black, // Default border color
                          ),
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                  ],
                ),
              ),
            ),
            Step(
              isActive: _currentStep >= 1,
              state: _currentStep <= 1 ? StepState.editing : StepState.complete,
              title: const Text('Informações Profissionais'),
              content: Form(
                key: _formKey[1],
                child: Column(children: [
                  const SizedBox(
                    height: 10.0,
                  ),
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty || value.length < 6) {
                        return 'Número conselho CRM inválido';
                      }
                      return null;
                    },
                    maxLength: 6,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    controller: crm_advice,
                    decoration: InputDecoration(
                      label: const Text('Nº Conselho CRM'),
                      hintText: 'Nº Conselho CRM',
                      hintStyle: const TextStyle(
                        color: Colors.black54,
                      ),
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.black, // Default border color
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.black, // Default border color
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty || value.length < 6) {
                        return 'Número CRM inválido';
                      }
                      return null;
                    },
                    maxLength: 6,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    controller: crm_number,
                    decoration: InputDecoration(
                      label: const Text('Nº CRM'),
                      hintText: 'Nº CRM',
                      hintStyle: const TextStyle(
                        color: Colors.black54,
                      ),
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.black, // Default border color
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.black, // Default border color
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  DropdownButtonFormField<String>(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor selecione um Estado';
                      }
                      return null;
                    },
                    onChanged: (String? newValue) {
                      crm_province.text = newValue!;
                      setState(() {
                        //
                      });
                    },
                    decoration: InputDecoration(
                      label: const Text('Estado CRM'),
                      // Change label to "Tipo de Usuário"
                      hintText: 'Estado CRM',
                      // Remove hint text as dropdown shows options
                      hintStyle: const TextStyle(
                        color: Colors.black26,
                      ),
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.black,
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.black,
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 'sc',
                        child: Text('Santa Catarina'),
                      ),
                      DropdownMenuItem(
                        value: 'sp',
                        child: Text('São Paulo'),
                      ),
                      DropdownMenuItem(
                        value: 'rj',
                        child: Text('Rio de Janeiro'),
                      ),
                      DropdownMenuItem(
                        value: 'pr',
                        child: Text('Paraná'),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty || value.length < 10) {
                        return 'Número CBO inválido';
                      }
                      return null;
                    },
                    maxLength: 10,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    controller: cbo,
                    decoration: InputDecoration(
                      label: const Text('Nº CBO'),
                      hintText: 'Nº CBO',
                      hintStyle: const TextStyle(
                        color: Colors.black54,
                      ),
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.black, // Default border color
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.black, // Default border color
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  )
                ]),
              ),
            ),
            Step(
              isActive: _currentStep >= 2,
              state: _currentStep <= 2 ? StepState.editing : StepState.complete,
              title: const Text('Informações de Cadastro'),
              content: Form(
                key: _formKey[2],
                child: Column(
                  children: [
                    const SizedBox(
                      height: 10.0,
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            !RegExp(r'^[\w-]+(\.[\w-]+)*@mydoctor.com$')
                                .hasMatch(value)) {
                          return 'Email inválido/domínio incorreto';
                        }
                        return null;
                      },
                      controller: email,
                      decoration: InputDecoration(
                        label: const Text('Email'),
                        hintText: 'cliente@mydoctor.com',
                        hintStyle: const TextStyle(
                          color: Colors.black54,
                        ),
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.black, // Default border color
                          ),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.black, // Default border color
                          ),
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            value.length < 8) {
                          return 'Senha deve ter no mínimo 8 caracteres';
                        }
                        return null;
                      },
                      obscureText: _obscureText,
                      obscuringCharacter: '*',
                      controller: senha,
                      decoration: InputDecoration(
                        label: const Text('Senha'),
                        hintText: 'Senha',
                        suffixIcon: IconButton(
                          icon: Icon(_obscureText
                              ? Icons.visibility
                              : Icons.visibility_off),
                          onPressed: _togglePasswordVisibility,
                        ),
                        hintStyle: const TextStyle(
                          color: Colors.black54,
                        ),
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.black, // Default border color
                          ),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.black, // Default border color
                          ),
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                  ],
                ),
              ),
            ),
            Step(
              isActive: _currentStep >= 3,
              state: StepState.complete,
              title: const Text('Revisão dos Dados'),
              content: Padding(
                padding: const EdgeInsets.all(16.0), // Adjust padding as needed
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  // Padding inside the container for spacing
                  decoration: BoxDecoration(
                    color: lightColorScheme.primary, // Light blue background
                    borderRadius: BorderRadius.circular(8), // Rounded corners
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    // Align items to the start
                    mainAxisAlignment: MainAxisAlignment.start,
                    // Align vertically
                    children: [
                      Text('Nome: ${name.text}',
                          style: const TextStyle(
                              fontSize: 16, color: Colors.white)),
                      // Styling for each text
                      Text('Gênero: ${genero.text}',
                          style: const TextStyle(
                              fontSize: 16, color: Colors.white)),
                      Text('CPF: ${cpf.text}',
                          style: const TextStyle(
                              fontSize: 16, color: Colors.white)),
                      Text('Celular: ${celular.text}',
                          style: const TextStyle(
                              fontSize: 16, color: Colors.white)),

                      Text('Nº Conselho CRM: ${crm_advice.text}',
                          style: const TextStyle(
                              fontSize: 16, color: Colors.white)),
                      Text('Nº CRM: ${crm_number.text}',
                          style: const TextStyle(
                              fontSize: 16, color: Colors.white)),
                      Text('Estado CRM: ${crm_province.text}',
                          style: const TextStyle(
                              fontSize: 16, color: Colors.white)),
                      Text('Nº CBO: ${cbo.text}',
                          style: const TextStyle(
                              fontSize: 16, color: Colors.white)),

                      Text('Email: ${email.text}',
                          style: const TextStyle(
                              fontSize: 16, color: Colors.white)),
                      const Text('Senha: ********',
                          style: TextStyle(fontSize: 16, color: Colors.white)),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
