import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String result = "Press button to fetch data";
  List items = [];
  bool isLoading = false;

  Future<void> fetchData() async {
    setState(() {
      isLoading = true;
    });
    try {
      final response = await http.get(
        // have to add user-agent and accept it is claudeflare-side change not Flutter
        Uri.parse("https://jsonplaceholder.typicode.com/todos"),
        headers: {
          'User-Agent': 'Mozilla/5.0 (Flutter)',
          'Accept': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          items = data;
          isLoading = false;
        });
      } else {
        setState(() {
          result = "Error: Server returned status ${response.statusCode}";
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        result = "Error: $e";
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text("Async Practice")),
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : items.isEmpty
            ? Center(child: Text(result))
            : ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Icon(Icons.check_circle_outline),
                    title: Text(items[index]['title']),
                  );
                },
              ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: isLoading ? null : fetchData,
          icon: Icon(Icons.download),
          label: Text("Fetch Data"),
        ),
      ),
    );
  }
}
