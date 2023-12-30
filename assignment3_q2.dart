import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Album App',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: const AlbumList(),
    );
  }
}

class AlbumList extends StatefulWidget {
  const AlbumList({Key? key}) : super(key: key);

  @override
  _AlbumListState createState() => _AlbumListState();
}

class _AlbumListState extends State<AlbumList> {
  late Future<List<Album>> futureAlbums;

  @override
  void initState() {
    super.initState();
    futureAlbums = fetchAlbums();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Album App'),
      ),
      body: Center(
        child: FutureBuilder<List<Album>>(
          future: futureAlbums,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return AlbumListView(albums: snapshot.data!);
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }

            return const CircularProgressIndicator();
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddAlbumScreen(),
            ),
          ).then((value) {
            setState(() {
              futureAlbums = fetchAlbums();
            });
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class AlbumListView extends StatefulWidget {
  final List<Album> albums;

  const AlbumListView({Key? key, required this.albums}) : super(key: key);

  @override
  _AlbumListViewState createState() => _AlbumListViewState();
}

class _AlbumListViewState extends State<AlbumListView> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.albums.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(widget.albums[index].title),
          trailing: IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              _deleteAlbum(widget.albums[index].id);
            },
          ),
        );
      },
    );
  }

  void _deleteAlbum(int id) {
    try {
      deleteAlbum(id);
      setState(() {
        widget.albums.removeWhere((album) => album.id == id);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Album deleted'),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to delete album'),
        ),
      );
    }
  }
}


class AddAlbumScreen extends StatefulWidget {
  const AddAlbumScreen({Key? key}) : super(key: key);

  @override
  _AddAlbumScreenState createState() => _AddAlbumScreenState();
}

class _AddAlbumScreenState extends State<AddAlbumScreen> {
  final TextEditingController titleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Album'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Album Title',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await addAlbum(titleController.text);
                Navigator.pop(context);
              },
              child: const Text('Add Album'),
            ),
          ],
        ),
      ),
    );
  }
}

Future<List<Album>> fetchAlbums() async {
  final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/albums'));

  if (response.statusCode == 200) {
    return (jsonDecode(response.body) as List)
        .map((data) => Album.fromJson(data))
        .toList();
  } else {
    throw Exception('Failed to load albums');
  }
}

Future<void> addAlbum(String title) async {
  final response = await http.post(
    Uri.parse('https://jsonplaceholder.typicode.com/albums'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'title': title,
    }),
  );

  if (response.statusCode != 201) {
    throw Exception('Failed to add album');
  }
}

Future<void> deleteAlbum(int id) async {
  final response = await http.delete(
    Uri.parse('https://jsonplaceholder.typicode.com/albums/$id'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );

  if (response.statusCode != 200) {
    throw Exception('Failed to delete album');
  }
}

class Album {
  final int id;
  final int userId;
  final String title;

  const Album({
    required this.id,
    required this.userId,
    required this.title,
  });

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      id: json['id'] as int,
      userId: json['userId'] as int,
      title: json['title'] as String,
    );
  }
}
