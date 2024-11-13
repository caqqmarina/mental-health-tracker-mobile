// import 'package:flutter/material.dart';
// import 'package:mental_health_tracker/models/mood_entry.dart';
// import 'package:mental_health_tracker/widgets/left_drawer.dart';

// class MoodEntryPage extends StatefulWidget {
//   const MoodEntryPage({super.key});

//   @override
//   _MoodEntryPageState createState() => _MoodEntryPageState();
// }

// class _MoodEntryPageState extends State<MoodEntryPage> {
//   Future<List<MoodEntry>> fetchMood(CookieRequest request) async {
//     // TODO: Don't forget to add the trailing slash (/) at the end of the URL!
//     final response = await request.get('http://[YOUR_APP_URL]/json/');

//     // Decoding the response into JSON
//     var data = response;

//     // Convert json data to a MoodEntry object
//     List<MoodEntry> listMood = [];
//     for (var d in data) {
//       if (d != null) {
//         listMood.add(MoodEntry.fromJson(d));
//       }
//     }
//     return listMood;
//   }
  
//   @override
//   Widget build(BuildContext context) {
//     return Container();
//   }
// }

import 'package:flutter/material.dart';
import 'package:mental_health_tracker/models/mood_entry.dart';
import 'package:mental_health_tracker/widgets/left_drawer.dart';
import 'dart:convert'; // Import the dart:convert package for JSON decoding
import 'package:http/http.dart' as http; // Import http package

// Define the CookieRequest class
class CookieRequest {
  Future<String> get(String url) async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to load data');
    }
  }
}

class MoodEntryPage extends StatefulWidget {
  const MoodEntryPage({super.key});

  @override
  State<MoodEntryPage> createState() => _MoodEntryPageState();
}

class _MoodEntryPageState extends State<MoodEntryPage> {
  Future<List<MoodEntry>> fetchMood(CookieRequest request) async {
    try {
      final response = await request.get('http://[YOUR_APP_URL]/json/');
      var data = jsonDecode(response); // Decode the response into JSON

      List<MoodEntry> listMood = [];
      for (var d in data) {
        if (d != null) {
          listMood.add(MoodEntry.fromJson(d));
        }
      }
      return listMood;
    } catch (e) {
      print('Error: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final request = CookieRequest(); // Create an instance of CookieRequest
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mood Entry List'),
      ),
      drawer: const LeftDrawer(),
      body: FutureBuilder(
        future: fetchMood(request),
        builder: (context, AsyncSnapshot<List<MoodEntry>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error loading mood data.'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'There is no mood data in mental health tracker.',
                style: TextStyle(fontSize: 20, color: Color(0xff59A5D8)),
              ),
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (_, index) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${snapshot.data![index].fields.mood}",
                      style: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text("${snapshot.data![index].fields.feelings}"),
                    const SizedBox(height: 10),
                    Text("${snapshot.data![index].fields.moodIntensity}"),
                    const SizedBox(height: 10),
                    Text("${snapshot.data![index].fields.time}")
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}

