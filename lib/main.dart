import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_app/screens/tabs.dart';

var kColorScheme = ColorScheme.fromSeed(
  seedColor: const Color(0xffb9f3fc),
);

// var kDarkColorScheme = ColorScheme.fromSeed(
//   seedColor: const Color.fromARGB(255, 12, 206, 216),
// );

void main() {
  runApp(
    ProviderScope(
      child: MaterialApp(
        // darkTheme: ThemeData.dark().copyWith(
        //   brightness: Brightness.dark,
        //   appBarTheme: const AppBarTheme().copyWith(
        //       backgroundColor: kDarkColorScheme.onPrimaryContainer,
        //       foregroundColor: kDarkColorScheme.primaryContainer),
        //   useMaterial3: true,
        //   colorScheme: kDarkColorScheme,
        //   elevatedButtonTheme: ElevatedButtonThemeData(
        //     style: ElevatedButton.styleFrom(
        //         backgroundColor: kDarkColorScheme.primaryContainer),
        //   ),
        //   cardTheme: const CardTheme().copyWith(
        //       margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        //       color: kDarkColorScheme.secondaryContainer),
        //   textTheme: ThemeData().textTheme.copyWith(
        //         titleLarge: TextStyle(
        //             fontWeight: FontWeight.bold,
        //             color: kDarkColorScheme.onSecondaryContainer,
        //             fontSize: 16),
        //       ),
        // ),
        theme: ThemeData().copyWith(
          textTheme: ThemeData().textTheme.copyWith(
              titleLarge: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: kColorScheme.onSecondaryContainer,
                  fontSize: 16)),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
                backgroundColor: kColorScheme.primaryContainer),
          ),
          useMaterial3: true,
          cardTheme: const CardTheme().copyWith(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: kColorScheme.secondaryContainer),
          appBarTheme: const AppBarTheme().copyWith(
            backgroundColor: kColorScheme.onPrimaryContainer,
            foregroundColor: kColorScheme.primaryContainer,
          ),
          colorScheme: kColorScheme,
        ),
        home: const TabsScreen(),
      ),
    ),
  );
}
