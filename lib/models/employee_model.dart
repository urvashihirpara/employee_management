import 'package:hive/hive.dart';

part 'employee_model.g.dart';

@HiveType(typeId: 0)
class Employee extends HiveObject {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final String role;

  @HiveField(2)
  final DateTime fromDate;

  @HiveField(3)
  final DateTime toDate;

  Employee({required this.name, required this.role, required this.fromDate, required this.toDate});
}
