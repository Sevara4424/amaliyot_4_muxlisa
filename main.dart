import 'package:flutter/material.dart';

import 'calc.dart';

void main() {
  runApp(
      const MaterialApp(
        title: 'My calculator',
        debugShowCheckedModeBanner: false,
        home: CalculatorApp(),
  ),
  );
}
