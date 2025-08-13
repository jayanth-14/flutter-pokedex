import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_pokedex/widgets/pokemon_card.dart'; // Make sure this path is correct
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;

class PokemonGrid extends StatefulWidget {
  const PokemonGrid({super.key});

  @override
  State<PokemonGrid> createState() => _PokemonGridState();
}

class _PokemonGridState extends State<PokemonGrid> {
  // --- FIX: Initialize the list as non-nullable ---
  List<Map<String, dynamic>> _pokemonDetailsList = [];
  bool _isLoading = true;

  // --- FIX: Add state variables for infinite scrolling ---
  final ScrollController _scrollController = ScrollController();
  int _offset = 0;
  bool _isFetchingMore = false; // Manages the "loading more" state

  @override
  void initState() {
    super.initState();
    _fetchPokemonBatch(); // Fetch the initial batch
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    // --- FIX: Check the flag to prevent multiple simultaneous fetches ---
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        !_isFetchingMore) {
      _fetchPokemonBatch();
    }
  }

  // Renamed for clarity and updated logic
  Future<void> _fetchPokemonBatch() async {
    // --- FIX: Set the 'isFetchingMore' flag to true before the API call ---
    // This will trigger the loading indicator at the bottom of the grid.
    if (!_isLoading) {
      setState(() {
        _isFetchingMore = true;
      });
    }

    try {
      const limit = 20;
      final listUrl = Uri.https('pokeapi.co', '/api/v2/pokemon', {
        'limit': limit.toString(),
        'offset': _offset.toString(),
      });

      final listResponse = await http.get(listUrl);
      if (listResponse.statusCode != 200) throw Exception('Failed to load list');
      
      final List results = json.decode(listResponse.body)['results'];
      final newPokemon = await Future.wait(
          results.map((r) => _fetchSinglePokemonDetails(r['url'])));

      setState(() {
        // Your existing logic to append data is correct!
        _pokemonDetailsList.addAll(newPokemon);
        _offset += limit;

        // --- FIX: Reset all loading flags after the data is added ---
        _isLoading = false;
        _isFetchingMore = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _isFetchingMore = false;
      });
      print("An error occurred: $e");
    }
  }

  // This function fetches details and can include your image resizing
  Future<Map<String, dynamic>> _fetchSinglePokemonDetails(String url) async {
    final detailResponse = await http.get(Uri.parse(url));
    if (detailResponse.statusCode == 200) {
      return json.decode(detailResponse.body);
    } else {
      throw Exception('Failed to load details for $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Center(child: CircularProgressIndicator())
        : GridView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.all(10),
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 180,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 0.7,
            ),
            // --- FIX: Add 1 to the item count for the loading indicator ---
            itemCount: _pokemonDetailsList.length + (_isFetchingMore ? 1 : 0),
            itemBuilder: (context, index) {
              // --- FIX: If this is the last item, show the loading spinner ---
              if (index == _pokemonDetailsList.length) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              final pokemonData = _pokemonDetailsList[index];
              return PokemonCard(
                name: pokemonData['name'] ?? 'No Name',
                id: pokemonData['id'].toString(),
                // Make sure your PokemonCard can handle the image data
                imageUrl: pokemonData['sprites']['other']['official-artwork']
                        ['front_default'] ??
                    pokemonData['sprites']['front_default'],
              );
            },
          );
  }
}