import 'package:flutter/material.dart';
import 'package:front/constants/colors.dart';

class Account extends StatelessWidget {

  static String routeName = '/account';

  const Account({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(height: 10),
            CircleAvatar(
              radius: 40,
              backgroundColor: Colors.white,
              child: Icon(Icons.person, size: 50, color: Colors.black),
            ),
            SizedBox(height: 10),
            Text(
              'John Doe',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 30),
            _buildInputField('Nom et prénom :', 'John Doe'),
            _buildDatePickerField(context, 'Date de naissance :'),
            _buildDropdownField('Genre :'),
            _buildInputField('E-mail :', 'John@Doe.com'),
            SizedBox(height: 60),
            ElevatedButton.icon(

              onPressed: () {
                   // Ajouter la logique pour supprimer le compte ici
              },

              icon: Icon(Icons.warning, color: Colors.red),
              label: Text(
                'Supprimer mon compte',
                style: TextStyle(color: Colors.red),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,

                side: BorderSide(color: Colors.red),

                shape: RoundedRectangleBorder(

                  borderRadius: BorderRadius.circular(10),

                     ),
                padding: EdgeInsets.symmetric(vertical: 25, horizontal: 20),

              ),

            ) ,
            SizedBox(height: 30),
          ],
        ),
      ),
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
