import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _textEditingController = TextEditingController();
  List<Map<String, dynamic>> _namedEntities = [];

  void _predictNamedEntities() async {
    String text = _textEditingController.text;
    final response = await http.post(
      Uri.parse('http://10.0.2.2:5000/predict'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>{'text': text}),
    );
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      setState(() {
        _namedEntities =
            List<Map<String, dynamic>>.from(jsonResponse['named_entities']);
      });
    } else {
      print('Failed to load named entities');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Named Entity Recognition'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _textEditingController,
              decoration: const InputDecoration(
                labelText: 'Enter text',
              ),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: _predictNamedEntities,
              child: const Text('Predict Named Entities'),
            ),
            const SizedBox(height: 20.0),
            const Text('Named Entities Found:',
                style: TextStyle(fontWeight: FontWeight.bold)),
            Expanded(
              child: ListView.builder(
                itemCount: _namedEntities.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                        '${_namedEntities[index]['text']} (${_namedEntities[index]['label']})'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
