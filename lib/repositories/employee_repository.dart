import 'package:hive/hive.dart';
import '../models/employee_model.dart';

class EmployeeRepository {
  static const String boxName = 'employees';

  Future<void> addEmployee(Employee employee) async {
    final box = await Hive.openBox<Employee>(boxName);
    await box.add(employee);
  }

  Future<void> updateEmployee(int index, Employee employee) async {
    final box = await Hive.openBox<Employee>(boxName);
    await box.putAt(index, employee);
  }

  Future<void> deleteEmployee(int index) async {
    final box = await Hive.openBox<Employee>(boxName);
    await box.deleteAt(index);
  }

  Future<List<Employee>> getEmployees() async {
    final box = await Hive.openBox<Employee>(boxName);
    return box.values.toList();
  }
}
