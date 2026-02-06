import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/constants/app_constants.dart';
import 'core/theme/app_theme.dart';
import 'providers/settings_provider.dart';
import 'ui/screens/home/home_screen.dart';

class IptvApp extends ConsumerWidget {
  const IptvApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(darkModeProvider);

    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
      home: const HomeScreen(),
    );
  }
}
