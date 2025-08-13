import 'package:flutter/material.dart';
import 'package:flutter_pokedex/widgets/pokemon_grid.dart';
// 1. Import your new widget file using a relative path.
import 'widgets/pokemon_card.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PokemonDetailScreen(),
    );
  }
}


class PokemonDetailScreen extends StatelessWidget {
  const PokemonDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pokémon Details'),
        backgroundColor: Colors.red,
      ),
      body: const Center(
        // 2. Use your shiny new widget!
        // We now pass the data it needs directly into its constructor.
        child: PokemonGrid()
      ),
    );
  }
}