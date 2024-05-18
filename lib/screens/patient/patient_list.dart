import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:my_doctor_app/theme/theme.dart';
import 'package:my_doctor_app/widgets/bottom_sheet/patient_details_bottom_sheet.dart';

class PatientListView extends StatefulWidget {
  @override
  _PatientListViewState createState() => _PatientListViewState();
}

class _PatientListViewState extends State<PatientListView> {
  Future<List<dynamic>>? _data;

  Future<List<dynamic>> fetchData() async {
    final response = await http
        .get(Uri.parse('https://back-end-unisenai.onrender.com/patient'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body) as List<dynamic>;
      return data;
    } else {
      // Handle API errors
      throw Exception('Failed to load data');
    }
  }

  @override
  void initState() {
    super.initState();
    _data = fetchData();
  }

  Future<http.Response> deleteDoctor(int id) async {
    // Set up the POST request
    final response = await http.delete(
      Uri.parse("https://back-end-unisenai.onrender.com/patient/$id"),
      headers: {'Content-Type': 'application/json'},
    );

    return response;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pacientes Cadastrados'),
        foregroundColor: Colors.white,
        backgroundColor: lightColorScheme.primary,
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _data,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final itemData = snapshot.data![index];
                // Access data from the item (replace with your data structure)
                final id = itemData['id'];
                final title = itemData['name'];
                final description = itemData['email'];

                return ListTile(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) => UserDetailsBottomSheet(
                        userData: itemData,
                      ),
                    );
                  },
                  leading: Icon(Icons.person, color: lightColorScheme.primary),
                  trailing: GestureDetector(
                    onTap: () async {
                      EasyLoading.show(status: 'Deletando...');
                      final response = await deleteDoctor(id);
                      EasyLoading.dismiss();

                      if (response.statusCode == 200) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            showCloseIcon: true,
                            content: Text(
                              'Cadastro deletado com sucesso!',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        );
                      } else {
                        print(response.body);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            showCloseIcon: true,
                            content: Text(
                              'Ocorreu um erro ao deletar o dado',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        );
                      }

                      setState(() {
                        _data = fetchData();
                      });
                    },
                    child: const Icon(Icons.delete_outlined, color: Colors.red),
                  ),
                  title: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(description),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0), // Rounded corners
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          // Display a loading indicator while waiting for data
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
