import 'package:employee_app/firebase_options.dart';
import 'package:employee_app/repositories/employee_repository.dart';
import 'package:employee_app/screens/employee_list_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'blocs/employee_cubit.dart';
import 'models/employee_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Hive.initFlutter();
  Hive.registerAdapter(EmployeeAdapter());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EmployeeCubit(EmployeeRepository())..loadEmployees(),
      child: MaterialApp(
        title: 'Employee Management',
        debugShowCheckedModeBanner: false,
        theme: ThemeData.light(),
        home: EmployeeListScreen(),
      ),
    );
  }
}

