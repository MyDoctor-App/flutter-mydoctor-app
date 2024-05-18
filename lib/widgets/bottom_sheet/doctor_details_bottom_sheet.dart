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
          _buildUserDetailRow('CRM:', userData['crm_number']),
          _buildUserDetailRow('UF CRM:', userData['crm_province']),
          _buildUserDetailRow('CPF:', userData['cpf']),
          _buildUserDetailRow('Telefone:', userData['phone']),
          _buildUserDetailRow('Email:', userData['email']),
          _buildUserDetailRow('CBO:', userData['cbo']),
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
