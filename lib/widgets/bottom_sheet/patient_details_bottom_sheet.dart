import 'package:flutter/material.dart';

class UserDetailsBottomSheet extends StatelessWidget {
  final Map<String, dynamic> userData;

  const UserDetailsBottomSheet({required this.userData});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            userData['name'],
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8.0),
          _buildUserDetailRow('ID:', userData['id'].toString()),
          _buildUserDetailRow(
              'Sexo:', userData['sex'] == 'm' ? 'Masculino' : 'Feminino'),
          // Assuming 'm' for male and anything else for female
          _buildUserDetailRow('Nascimento:', userData['birth_date']),
          _buildUserDetailRow('CPF:', userData['cpf']),
          _buildUserDetailRow('RG:', userData['rg']),
          _buildUserDetailRow('Nome da Mãe:', userData['mother_name']),
          _buildUserDetailRow('Contato:', userData['phone']),
          _buildUserDetailRow('Email:', userData['email']),
          _buildUserDetailRow('CEP:', userData['cep']),
          _buildUserDetailRow('Endereço:', userData['address']),
          _buildUserDetailRow('Número:', userData['number'].toString()),
          _buildUserDetailRow('Bairro:', userData['neighborhood']),
          _buildUserDetailRow('Cidade:', userData['city']),
          _buildUserDetailRow('Estado:', userData['province']),
        ],
      ),
    );
  }

  Widget _buildUserDetailRow(String label, String value) {
    return Row(
      children: [
        Text(
          label,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(width: 8.0),
        Text(value),
      ],
    );
  }
}
