import 'package:flutter/material.dart';

class IngredientChip extends StatelessWidget {
  final String ingredient;

  const IngredientChip({super.key, required this.ingredient});

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(ingredient),
      backgroundColor: Colors.green[100],
    );
  }
}
