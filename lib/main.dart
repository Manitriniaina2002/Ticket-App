import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:ticket_app/models/event.dart';
import 'package:ticket_app/models/ticket_type.dart';
import 'package:ticket_app/providers/event_provider.dart';
import 'package:ticket_app/providers/theme_provider.dart';
import 'package:ticket_app/screens/home_screen.dart';
import 'package:ticket_app/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  
  // Register Hive adapters
  Hive.registerAdapter(EventAdapter());
  Hive.registerAdapter(TicketTypeAdapter());
  
  // Open Hive boxes
  await Hive.openBox<Event>('events');
  await Hive.openBox<TicketType>('ticket_types');
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => EventProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'Ticket Manager',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.themeMode,
            home: const HomeScreen(),
          );
        },
      ),
    );
  }
}
