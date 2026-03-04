import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'data/default_categories.dart';
import 'models/category_model.dart';
import 'models/expense.dart';
import 'providers/expense_provider.dart';
import 'screens/main_shell.dart';
import 'services/hive_service.dart';
import 'utils/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(ExpenseAdapter());
  Hive.registerAdapter(CategoryModelAdapter());

  final categoriesBox = await Hive.openBox<CategoryModel>('categories');
  if (categoriesBox.isEmpty) {
    for (final category in defaultCategories) {
      await categoriesBox.put(category.id, category);
    }
  }

  await HiveService.instance.init();

  runApp(const ExpenseTrackerApp());
}

class ExpenseTrackerApp extends StatelessWidget {
  const ExpenseTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ExpenseProvider()..loadExpenses(),
      child: Consumer<ExpenseProvider>(
        builder: (context, provider, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Harcamalar',
            themeMode: provider.themeMode,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            locale: const Locale('tr'),
            supportedLocales: const [Locale('tr')],
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            home: const MainShell(),
          );
        },
      ),
    );
  }
}

