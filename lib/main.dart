import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Welcome to Startup Namer',
      theme: new ThemeData(primaryColor: Colors.deepPurpleAccent),
      home: new RandomWords(),
    );
  }
}

class RandomWordsState extends State<StatefulWidget> {
  final _suggestions = <WordPair>[];
  final _biggerFont = const TextStyle(fontSize: 18.0);
  final _saved = new Set<WordPair>();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Startup Name Generator'),
        actions: <Widget>[
          new IconButton(
            icon: new Icon(
              Icons.list,
            ),
            onPressed: _viewSaved,
          )
        ],
      ),
      body: _buildSuggestions(),
    );
  }

  void _viewSaved() {
    Navigator.of(context).push(
      new MaterialPageRoute(
        builder: (context) {
          return new SavedWords(_saved);
        },
      ),
    );
  }

  Widget _buildSuggestions() {
    return new ListView.builder(
      padding: EdgeInsets.all(16.0),
      itemBuilder: (context, i) {
        if (i.isOdd) return new Divider();
        final index = i ~/ 2;
        if (index >= _suggestions.length) {
          _suggestions.addAll(generateWordPairs().take(10));
        }
        return _buildRow(_suggestions[index]);
      },
    );
  }

  Widget _buildRow(WordPair pair) {
    final alreadySaved = _saved.contains(pair);

    void onPressedFavourite() {
      setState(() {
        if (alreadySaved) {
          _saved.remove(pair);
        } else {
          _saved.add(pair);
        }
      });
    }

    return new ListTile(
      title: new Text(
        pair.asPascalCase,
        style: _biggerFont,
      ),
      trailing: new IconButton(
        icon: new Icon(
          alreadySaved ? Icons.favorite : Icons.favorite_border,
          color: alreadySaved ? Colors.red : null,
        ),
        onPressed: onPressedFavourite,
      ),
    );
  }
}

class RandomWords extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new RandomWordsState();
  }
}

class SavedWordsState extends State<StatefulWidget> {
  final Set<WordPair> _saved;
  final _biggerFont = const TextStyle(fontSize: 18.0);

  SavedWordsState(this._saved);

  @override
  Widget build(BuildContext context) {
    final tiles = _saved.map(
      (pair) {
        void onPressedDelete() {
          setState(() {
            _saved.remove(pair);
          });
        }

        return new ListTile(
          title: new Text(
            pair.asPascalCase,
            style: _biggerFont,
          ),
          trailing: new IconButton(
            icon: new Icon(
              Icons.delete,
            ),
            onPressed: onPressedDelete,
          ),
        );
      },
    );

    var divided = ListTile
        .divideTiles(
          context: context,
          tiles: tiles,
        )
        .toList();

    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Saved Name'),
      ),
      body: new ListView(
        children: divided,
      ),
    );
  }
}

class SavedWords extends StatefulWidget {
  final Set<WordPair> _saved;

  SavedWords(this._saved);

  @override
  State<StatefulWidget> createState() {
    return new SavedWordsState(_saved);
  }
}
