import 'package:flutter/material.dart';
import 'package:front/constants/colors.dart';
import 'package:googleapis/admob/v1.dart';
import 'package:provider/provider.dart';
import '../../models/user.dart';
import '../../providers/user.dart';

class Account extends StatelessWidget {

  static String routeName = '/account';

  const Account({super.key});

  @override
  Widget build(BuildContext context) {
    final User? user = Provider.of<UserProvider>(context).user;
    return Scaffold(
      extendBody: true,
      body: Align(
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Builder(builder: (context) {
            if(user != null) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  SizedBox(height: 10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Image.network(user.photoUrl as String),
                  ),
                  SizedBox(height: 10),
                  Text(
                    user.username as String,
                    style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                  ),
                  Text(user.email as String),
                  SizedBox(height: 80),
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: Icon(Icons.phone, color: AppColors.primary),
                    label: Text(
                      'Contacter l\'administration',
                      style: TextStyle(color: AppColors.primary),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      side: BorderSide(color: AppColors.primary),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 25, horizontal: 20),
                    ),
                  ),
                  SizedBox(height: 15),
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: Icon(Icons.warning, color: Colors.red),
                    label: Text(
                      'Supprimer mon compte',
                      style: TextStyle(color: Colors.red),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      side: BorderSide(color: Colors.red),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 25, horizontal: 20),
                    ),
                  ),
                ],
              );
            }
            return Text("Une erreur est survenue veuillez réessayer.");
          }),
        ),
      )
    );
  }

  Widget _buildInputField(String label, String initialValue) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 16, color: AppColors.primary),
        ),
        SizedBox(height: 5),
        Container(
          height: 56,
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.primary, width: 2),
            borderRadius: BorderRadius.circular(20),
          ),
          child: TextField(
            controller: TextEditingController(text: initialValue),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
              border: InputBorder.none,
            ),
          ),
        ),
        SizedBox(height: 20),
      ],
    );
  }

  Widget _buildDatePickerField(BuildContext context, String label) {
    return DatePickerField(label: label);
  }

  Widget _buildDropdownField(String label) {
    return DropdownField(label: label);
  }
}

class DatePickerField extends StatefulWidget {
  final String label;

  DatePickerField({required this.label});

  @override
  _DatePickerFieldState createState() => _DatePickerFieldState();
}

class _DatePickerFieldState extends State<DatePickerField> {
  DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1900, 1),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: TextStyle(fontSize: 16, color: AppColors.primary),
        ),
        SizedBox(height: 5),
        GestureDetector(
          onTap: () => _selectDate(context),
          child: Container(
            height: 56,
            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.primary, width: 2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${selectedDate.toLocal()}".split(' ')[0],
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
                Icon(
                  Icons.calendar_today,
                  color: Colors.grey,
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 20),
      ],
    );
  }
}

class DropdownField extends StatefulWidget {
  final String label;

  DropdownField({required this.label});

  @override
  _DropdownFieldState createState() => _DropdownFieldState();
}

class _DropdownFieldState extends State<DropdownField> {
  String dropdownValue = 'Femme';

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: TextStyle(fontSize: 16, color: AppColors.primary),
        ),
        SizedBox(height: 5),
        Container(
          height: 56,
          padding: EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.primary, width: 2),
            borderRadius: BorderRadius.circular(20),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              value: dropdownValue,
              icon: Icon(Icons.arrow_drop_down),
              iconSize: 24,
              elevation: 16,
              style: TextStyle(fontSize: 16, color: Colors.black),
              onChanged: (String? newValue) {
                setState(() {
                  dropdownValue = newValue!;
                });
              },
              items: <String>['Femme', 'Homme', 'Autre']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
        ),
        SizedBox(height: 20),
      ],
    );
  }
}
