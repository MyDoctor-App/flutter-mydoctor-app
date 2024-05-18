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
import 'package:search_cep/search_cep.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';



class PatientFormPage extends StatefulWidget {
  const PatientFormPage({Key? key}) : super(key: key);

  @override
  _PatientFormPageState createState() => _PatientFormPageState();
}

class _PatientFormPageState extends State<PatientFormPage> {
  final List<GlobalKey<FormState>> _formKey = [
    GlobalKey(),
    GlobalKey(),
    GlobalKey()
  ];
  int _currentStep = 0;

  TextEditingController name = TextEditingController();
  TextEditingController sex = TextEditingController();
  TextEditingController birth_date = TextEditingController();
  TextEditingController cpf = TextEditingController();
  TextEditingController rg = TextEditingController();
  TextEditingController mother_name = TextEditingController();
  TextEditingController social_name = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController cep = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController number = TextEditingController();
  TextEditingController neighborhood = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController province = TextEditingController();
  TextEditingController password = TextEditingController();

  bool _obscureText = true;

  final maskFormatter = MaskTextInputFormatter(mask: '0000-00-00', initialText: '2024-05-01');
  DateTime _selectedDate = DateTime.now();


  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  Future<void> _getAddressFromCEP(String cep) async {
    String _bairro;
    String _cidade;
    String _uf;
    String _endereco;

    final viaCepSearchCep = ViaCepSearchCep();
    final infoCepJSON = await viaCepSearchCep.searchInfoByCep(cep: cep);
    final responseCep = infoCepJSON.fold((_) => null, (data) => data);

    if (responseCep != null) {
      // variáveis recebendo os dados em JSON da API
      _bairro = responseCep.bairro.toString();
      _endereco = responseCep.logradouro.toString();
      _cidade = responseCep.localidade.toString();
      _uf = responseCep.uf.toString();

      // controller recebendo os dados das variáveis
      address.text = _endereco;
      neighborhood.text = _bairro;
      city.text = _cidade;
      province.text = _uf;

    } else {
      // Handle errors or invalid CEP
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          showCloseIcon: true,
          content: Text(
            'CEP digitado é inválido!',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }
  }

  Future<http.Response> postPatientForm(
      String name,
      String sex,
      String birth_date,
      String cpf,
      String rg,
      String mother_name,
      String phone,
      String email,
      String cep,
      String address,
      String number,
      String neighborhood,
      String city,
      String province,
      String password,

      ) async {
    // Prepare the JSON data
    final Map<String, String> data = {
      "name": name,
      "sex": sex,
      "birth_date": birth_date,
      "cpf": cpf,
      "rg": rg,
      "mother_name": mother_name,
      "social_name": name,
      "phone": phone,
      "email": email,
      "cep": cep,
      "address": address,
      "number": number,
      "neighborhood": neighborhood,
      "city": city,
      "province": province,
      "password": password
    };

    final jsonData = json.encode(data);

    // Set up the POST request
    final response = await http.post(
      Uri.parse("https://back-end-unisenai.onrender.com/patient"),
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
                final response = await postPatientForm(
                    name.text,
                    sex.text,
                    birth_date.text,
                    cpf.text,
                    rg.text,
                    mother_name.text,
                    phone.text,
                    email.text,
                    cep.text,
                    address.text,
                    number.text,
                    neighborhood.text,
                    city.text,
                    province.text,
                    password.text
                );
                EasyLoading.dismiss();

                if (response.statusCode == 200) {
                  // Successful request
                  // Process the response data here (e.g., show a success message)
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      showCloseIcon: true,
                      content: Text(
                        'Paciente cadastrado com sucesso!',
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
        title: const Text('Cadastro de Pacientes'),
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
                          return 'Por favor insira o nome do paciente';
                        }
                        return null;
                      },
                      controller: name,
                      decoration: InputDecoration(
                        label: const Text('Nome'),
                        hintText: 'Nome do paciente',
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
                      controller: birth_date,
                      readOnly: true,
                      decoration: InputDecoration(
                        label: const Text('Data de Nascimento'),
                        hintText: 'Data de Nascimento',
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
                        suffixIcon: IconButton(
                          icon: Icon(Icons.calendar_today),
                          onPressed: () async {
                            final pickedDate = await showDatePicker(
                              context: context,
                              initialDate: _selectedDate,
                              firstDate: DateTime(1900),
                              lastDate: DateTime.now(),
                            );

                            if (pickedDate!= null && pickedDate!= _selectedDate) {
                              setState(() {
                                _selectedDate = pickedDate;
                                birth_date.text = '${_selectedDate.year}-${_selectedDate.month.toString().padLeft(2, '0')}-${_selectedDate.day.toString().padLeft(2, '0')}';
                              });
                            }
                          },
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor insira o nome da mãe';
                        }
                        return null;
                      },
                      controller: mother_name,
                      decoration: InputDecoration(
                        label: const Text('Nome da mãe'),
                        hintText: 'Nome da mãe',
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
                        sex.text = newValue!;
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
                            value.length < 9) {
                          return 'Por favor insira um RG válido';
                        }
                        return null;
                      },
                      maxLength: 9,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      controller: rg,
                      decoration: InputDecoration(
                        label: const Text('RG'),
                        hintText: 'RG',
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
                      controller: phone,
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
              title: const Text('Informações Residenciais'),
              content: Form(
                key: _formKey[1],
                child: Column(children: [
                  const SizedBox(
                    height: 10.0,
                  ),
                  TextFormField(
                    onChanged: (value) {
                      if (value.length == 8) {
                        _getAddressFromCEP(value);
                      }
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty || value.length < 8) {
                        return 'Número de CEP inválido';
                      }
                      return null;
                    },
                    maxLength: 8,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    controller: cep,
                    decoration: InputDecoration(
                      label: const Text('CEP'),
                      hintText: 'CEP',
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
                      if (value == null || value.isEmpty) {
                        return 'Por favor insira um endereço';
                      }
                      return null;
                    },
                    enabled: true,
                    controller: address,
                    decoration: InputDecoration(
                      label: Text('Endereço'),
                      hintText: 'Endereço',
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
                      if (value == null || value.isEmpty) {
                        return 'Por favor insira um bairro';
                      }
                      return null;
                    },
                    enabled: true,
                    controller: neighborhood,
                    decoration: InputDecoration(
                      label: Text('Bairro'),
                      hintText: 'Bairro',
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
                    enabled: false,
                    controller: city,
                    decoration: InputDecoration(
                      label: Text('Cidade'),
                      hintText: 'Cidade',
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
                    enabled: false,
                    controller: province,
                    decoration: InputDecoration(
                      label: Text('Estado'),
                      hintText: 'Estado',
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
                    controller: number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor insira um número';
                      }
                      return null;
                    },
                    maxLength: 4,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    // controller: cbo,
                    decoration: InputDecoration(
                      label: const Text('Nº da Residência'),
                      hintText: 'Nº da Residência',
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
                      // controller: senha,
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
                      Text('Gênero: ${sex.text}',
                          style: const TextStyle(
                              fontSize: 16, color: Colors.white)),
                      Text('Nascimento: ${birth_date.text}',
                          style: const TextStyle(
                              fontSize: 16, color: Colors.white)),
                      Text('Nome da mãe: ${mother_name.text}',
                          style: const TextStyle(
                              fontSize: 16, color: Colors.white)),
                      Text('CPF: ${cpf.text}',
                          style: const TextStyle(
                              fontSize: 16, color: Colors.white)),
                      Text('RG: ${rg.text}',
                          style: const TextStyle(
                              fontSize: 16, color: Colors.white)),
                      Text('Celular: ${phone.text}',
                          style: const TextStyle(
                              fontSize: 16, color: Colors.white)),
                      Text('CEP: ${cep.text}',
                          style: const TextStyle(
                              fontSize: 16, color: Colors.white)),
                      Text('Endereço: ${address.text}',
                          style: const TextStyle(
                              fontSize: 16, color: Colors.white)),
                      Text('Número: ${number.text}',
                          style: const TextStyle(
                              fontSize: 16, color: Colors.white)),
                      Text('Cidade: ${city.text}',
                          style: const TextStyle(
                              fontSize: 16, color: Colors.white)),
                      Text('Estado: ${province.text}',
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
