import 'package:flutter/material.dart';

import '../screens/moodentry_form.dart';
import '../screens/list_moodentry.dart'; // Import MoodEntryPage

class ItemCard extends StatelessWidget {
  // Display the card with an icon and name.

  final ItemHomepage item;

  const ItemCard(this.item, {super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.secondary,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: () {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(
                content: Text("You have pressed the ${item.name} button!")));

          // Check if item name matches "Add Mood"
          if (item.name == "Add Mood") {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => MoodEntryFormPage(),
              ),
            );
          } 
          // Check if item name matches "View Mood"
          else if (item.name == "View Mood") {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const MoodEntryPage(), // Ensure this page exists
              ),
            );
          }
        },
        child: Container(
          padding: const EdgeInsets.all(8),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  item.icon,
                  color: Colors.white,
                  size: 30.0,
                ),
                const Padding(padding: EdgeInsets.all(3)),
                Text(
                  item.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ItemHomepage {
  final String name;
  final IconData icon;

  ItemHomepage(this.name, this.icon);
}
