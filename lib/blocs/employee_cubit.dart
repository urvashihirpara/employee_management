import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/employee_model.dart';
import '../repositories/employee_repository.dart';

class EmployeeCubit extends Cubit<List<Employee>> {
  final EmployeeRepository repository;

  EmployeeCubit(this.repository) : super([]);

  void loadEmployees() async {
    final employees = await repository.getEmployees();
    emit(employees);
  }

  void addEmployee(Employee employee) async {
    await repository.addEmployee(employee);
    loadEmployees();
  }

  void updateEmployee(int index, Employee employee) async {
    await repository.updateEmployee(index, employee);
    loadEmployees();
  }

  void deleteEmployee(int index) async {
    await repository.deleteEmployee(index);
    loadEmployees();
  }
}
