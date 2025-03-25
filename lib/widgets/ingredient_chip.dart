import 'package:flutter/material.dart';

class IngredientChip extends StatelessWidget {
  final String ingredient;

  IngredientChip({required this.ingredient});

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(ingredient),
      backgroundColor: Colors.green[100],
    );
  }
}
