// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'string_casing_extension.dart';
import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Word Pair Generator',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
        ),
      ),
      home: const RandomWords(),
    );
  }
}

class RandomWords extends StatefulWidget {
  const RandomWords({Key? key}) : super(key: key);

  @override
  State<RandomWords> createState() => _RandomWordsState();
}

class _RandomWordsState extends State<RandomWords> {
  final _suggestions = <WordPair>[];
  final _saved = <WordPair>[];
  final _biggerFont = const TextStyle(fontSize: 18.0);

  void _handleTap(bool alreadySaved, WordPair pair) {
    setState(() {
      alreadySaved ? _saved.remove(pair) : _saved.add(pair);
    });
  }

  void _pushSaved() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) {
          final tiles = _saved.map((pair) {
            return ListTile(
                title: Text(
              pair.join(' ').toTitleCase(),
              style: _biggerFont,
            ));
          });
          final divided = tiles.isNotEmpty
              ? ListTile.divideTiles(tiles: tiles, context: context).toList()
              : <Widget>[];
          return Scaffold(
            appBar: AppBar(
              title: const Text('Saved pairs'),
            ),
            body: ListView(children: divided),
          );
        },
      ),
    );
  }

  Widget _buildRow(WordPair pair) {
    final alreadySaved = _saved.contains(pair);
    return ListTile(
      title: Text(
        pair.join(' ').toTitleCase(),
        style: _biggerFont,
      ),
      trailing: Icon(
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadySaved ? Colors.red : null,
        semanticLabel: alreadySaved ? 'Remove from saved' : 'Save',
      ),
      onTap: () => _handleTap(alreadySaved, pair),
    );
  }

  Widget _buildSuggestions() {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemBuilder: (context, i) {
        if (i.isOdd) return const Divider();
        final index = i ~/ 2;

        if (index >= _suggestions.length) {
          _suggestions.addAll(generateWordPairs().take(10));
        }

        return _buildRow(_suggestions[index]);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Word Pair Generator"),
        actions: [
          IconButton(
            onPressed: _pushSaved,
            icon: const Icon(Icons.list),
            tooltip: 'Saved Pairs',
          )
        ],
      ),
      body: _buildSuggestions(),
    );
  }
}
