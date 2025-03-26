import 'package:flutter/material.dart';

class IngredientChip extends StatelessWidget {
  final String ingredient;

  const IngredientChip({Key? key, required this.ingredient}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(ingredient),
      backgroundColor: Colors.green[100],
    );
  }
}
