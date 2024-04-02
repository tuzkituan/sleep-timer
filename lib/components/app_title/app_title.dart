import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTitle extends StatelessWidget {
  const AppTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      "SLEEP TIMER",
      style: GoogleFonts.archivo(fontSize: 14, letterSpacing: 7),
    );
  }
}
