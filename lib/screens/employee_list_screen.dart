import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

import '../blocs/employee_cubit.dart';
import '../models/employee_model.dart';
import 'employee_form_screen.dart';

class EmployeeListScreen extends StatelessWidget {
  const EmployeeListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        color: Colors.grey.shade100,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Swipe left to delete',style: TextStyle(color: Colors.grey),),
            SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: () => _addEmployee(context),
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    backgroundColor: Colors.blue),
                child: Icon(Icons.add,color: Colors.white,size: 24,),
              ),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.blue,
          title: Text('Employee List', style: TextStyle(color: Colors.white),)),
      body: Container(
        color: Colors.white,
        child: BlocBuilder<EmployeeCubit, List<Employee>>(
          builder: (context, employees) {
            if (employees.isEmpty) {
              return Center(child: Image.asset('assets/noEmp.png'));
            }
            return Column(
              children: [
                Container(
                  padding: EdgeInsets.only(left: 16),
                  height: 50,
                  color: Colors.grey.shade100,
                  child: Row(
                    children: [
                      Text('Current employees',style: TextStyle(color: Colors.blue,fontWeight: FontWeight.w500),),
                    ],
                  )
                ),
                ListView.separated(
                  itemCount: employees.length,
                  shrinkWrap: true,
                  separatorBuilder: (context, index) {
                    return Divider(color: Colors.grey.shade200);
                  },
                  itemBuilder: (context, index) {
                    final employee = employees[index];
                    return Slidable(
                      key: const ValueKey(0),
                      endActionPane: ActionPane(
                        motion: const ScrollMotion(),
                        children: [
                          SlidableAction(
                            onPressed: (val) {
                              _editEmployee(context, index, employee);
                            },
                            backgroundColor: Colors.yellow.shade700,
                            foregroundColor: Colors.white,
                            icon: Icons.edit_outlined,
                            label: 'Edit',
                          ),
                          SlidableAction(
                            onPressed: (val) {
                              context.read<EmployeeCubit>().deleteEmployee(index);
                            },
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            icon: Icons.delete,
                            label: 'Delete',
                          ),
                        ],
                      ),
                      child: ListTile(
                        title: Text(employee.name,style: TextStyle(fontWeight: FontWeight.w500),),
                        subtitle: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(employee.role,style: TextStyle(color: Colors.grey.shade500),),
                            SizedBox(height: 2),
                            Text('${DateFormat("dd MMM yyyy").format(employee.fromDate.toLocal())} - ${DateFormat("dd MMM yyyy").format(employee.toDate.toLocal())}',style: TextStyle(color: Colors.grey.shade500)),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  _addEmployee(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => EmployeeForm()));
  }

  _editEmployee(BuildContext context, int index, Employee employee) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => EmployeeForm(employee: employee, index: index)),
    );
  }
}
