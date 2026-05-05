import 'package:flutter/material.dart';
import 'pantry_header.dart';
import 'pantry_grid.dart';

class PantrySection extends StatelessWidget {
  const PantrySection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        PantryHeader(),
        SizedBox(height: 10),
        Expanded(child: PantryGrid()), 
        SizedBox(height: 20),
      ],
    );
  }
}