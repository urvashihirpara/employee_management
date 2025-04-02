import 'package:employee_app/utility/colors_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:intl/intl.dart';

import '../blocs/employee_cubit.dart';
import '../models/employee_model.dart';
import '../utility/custom_datepicker.dart';

class EmployeeForm extends StatefulWidget {
  final Employee? employee;
  final int? index;

  const EmployeeForm({super.key, this.employee, this.index});

  @override
  _EmployeeFormState createState() => _EmployeeFormState();
}

class _EmployeeFormState extends State<EmployeeForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  String _selectedRole = 'Flutter Developer';
  DateTime _fromDate = DateTime.now();
  DateTime _toDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    if (widget.employee != null) {
      _nameController.text = widget.employee!.name;
      _selectedRole = widget.employee!.role;
      _fromDate = widget.employee!.fromDate;
      _toDate = widget.employee!.toDate;
    }
  }

  void _selectDate(bool isFromDate) async {
    DateTime selectedDate = isFromDate ? _fromDate : _toDate;
    showDialog(
      useSafeArea: true,
      context: context,
      builder: (context) {
        return CustomDatePicker(
          initialDate: selectedDate,
          onDateSelected: (date) {
            setState(() {
              if (isFromDate) {
                _fromDate = date;
              } else {
                _toDate = date;
              }
            });
          },
        );
      },
    );
  }

  void _saveEmployee() {
    if (_formKey.currentState!.validate()) {
      final employee = Employee(
        name: _nameController.text,
        role: _selectedRole,
        fromDate: _fromDate,
        toDate: _toDate,
      );

      final cubit = context.read<EmployeeCubit>();
      if (widget.index == null) {
        cubit.addEmployee(employee);
      } else {
        cubit.updateEmployee(widget.index!, employee);
      }

      Navigator.pop(context);
    }
  }

  void _cancelForm() {
    Navigator.pop(context);  // Simply navigate back to the previous screen
  }

  void _selectRole(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SizedBox(
          height: 240,
          child: Column(
            children: [
              ListTile(
                title: Text('Product Designer'),
                onTap: () {
                  setState(() {
                    _selectedRole = 'Product Designer';
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('Flutter Developer'),
                onTap: () {
                  setState(() {
                    _selectedRole = 'Flutter Developer';
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('QA Tester'),
                onTap: () {
                  setState(() {
                    _selectedRole = 'QA Tester';
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('Product Owner'),
                onTap: () {
                  setState(() {
                    _selectedRole = 'Product Owner';
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.index == null ? 'Add Employee Details' : 'Edit Employee Details')),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ElevatedButton(
              onPressed: _cancelForm,
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  backgroundColor: Colors.grey.shade100,elevation: 0.0),
              child: Text('Cancel',style: TextStyle(color: Colors.blue),),
            ),
            SizedBox(width: 20,),
            ElevatedButton(
              onPressed: _saveEmployee,
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  backgroundColor: Colors.blue),
              child: Text('Save',style: TextStyle(color: Colors.white),),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(
                height: 50,
                child: TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: greyColor)
                    ),
                    labelText: 'Name',
                  ),
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: TextEditingController(text: _selectedRole),
                readOnly: true, // Prevents manual typing
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  labelText: 'Role',
                  suffixIcon: GestureDetector(
                    onTap: () => _selectRole(context), // Ensures dropdown is clickable
                    child: Icon(Icons.arrow_drop_down),
                  ),
                ),
                onTap: () => _selectRole(context), // Ensures tapping the field works
              ),
              // InkWell(
              //   onTap: () => _selectRole(context),
              //   child: TextFormField(
              //     readOnly: true,
              //     controller: TextEditingController(text: _selectedRole),
              //     decoration: InputDecoration(
              //       border: OutlineInputBorder(
              //           borderSide: BorderSide(color: greyColor)
              //       ),
              //       labelText: 'Role',
              //       suffixIcon:Icon(Icons.arrow_drop_down),
              //     ),
              //   ),
              // ),
              SizedBox(height: 10,),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                        onPressed: () => _selectDate(true),
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                side: BorderSide(color: greyColor),
                                borderRadius: BorderRadius.circular(10),
                            ),
                            backgroundColor: Colors.transparent,
                            elevation: 0.0),
                        child: Row(
                          children: [
                            Icon(Icons.calendar_month_outlined,color: Colors.blue),
                            SizedBox(width: 5),
                            Text(DateFormat("dd MMM yyyy").format(_fromDate),style: TextStyle(color: Colors.black)),
                          ],
                        )),
                  ),
                  SizedBox(width: 10,),
                  Icon(Icons.arrow_forward,color: Colors.blue),
                  SizedBox(width: 10,),
                  Expanded(
                    child: ElevatedButton(
                        onPressed: () => _selectDate(false),
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              side: BorderSide(color: greyColor),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            backgroundColor: Colors.transparent,
                            elevation: 0.0),
                        child: Row(
                          children: [
                            Icon(Icons.calendar_month_outlined,color: Colors.blue),
                            SizedBox(width: 5),
                            Text(DateFormat("dd MMM yyyy").format(_toDate),style: TextStyle(color: Colors.black),),
                          ],
                        )),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
