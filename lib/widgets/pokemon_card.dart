import 'package:flutter/material.dart';

// A stateless widget that represents the visual card for a Pokémon.
class PokemonCard extends StatelessWidget {
  // The data this widget needs to display.
  final String name;
  final String imageUrl;
  final String id;

  // The constructor.
  // It requires the data to be passed in when the widget is created.
  // {super.key} handles the optional key parameter.
  const PokemonCard({
    super.key,
    required this.name,
    required this.imageUrl,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    // We are returning the exact same UI we had before,
    // but now it uses the variables passed into the constructor
    // instead of hardcoded values.
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Image.network(
            imageUrl, // Use the imageUrl variable
            height: 150,
            width: 150,
            // Add a loading builder for a better user experience
            loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
              if (loadingProgress == null) return child;
              return SizedBox(
                height: 150,
                width: 150,
                child: Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                        : null,
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 20),
        Text(
          name, // Use the name variable
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        Text(
          '#$id', // Use the id variable
          style: const TextStyle(fontSize: 20, color: Colors.grey),
        ),
      ],
    );
  }
}