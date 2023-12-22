import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Namer App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();
  void getNext() {
    current = WordPair.random();
    notifyListeners();
  }
  var favorites = <WordPair>[];

  void toggleFavorite() {
    if (favorites.contains(current)) {
      favorites.remove(current);
    } else {
      favorites.add(current);
    }
    notifyListeners();
  }

  void removeFavorite(WordPair pair) {
    favorites.remove(pair);
    notifyListeners();
  }
}

class FavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    if (appState.favorites.isEmpty) {
      return Center(
        child: Text('No favorites yet.'),
      );
    }

    return ListView.builder(
      itemCount: appState.favorites.length,
      itemBuilder: (context, index) {
        final pair = appState.favorites[index];
        return Dismissible(
          key: Key(pair.toString()), 
          onDismissed: (direction) {
            appState.removeFavorite(pair);
          },
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerRight,
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Icon(
              Icons.delete,
              color: Colors.white,
            ),
          ),
          child: ListTile(
            leading: Icon(Icons.favorite),
            title: Text(pair.asLowerCase),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                appState.removeFavorite(pair);
              },
            ),
          ),
        );
      },
    );
  }
}

class PersonPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: const EdgeInsets.only(top: 20),
            child: CircleAvatar(
              radius: 100,
              backgroundImage: NetworkImage(
                  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTHE4vcD6O1-GAxEU2CDLEQlD140pQI94q5qA&usqp=CAU'),
            ),
          ),
        ),
        SizedBox(height: 20),
        Row(
          children: [
            Center(
              child: RichText(
                textAlign: TextAlign.left,
                text: TextSpan(
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black, // Define color if needed
                  ),
                  children: [
                    TextSpan(
                      text: '  Ayush Yadav\n',
                    ),
                    WidgetSpan(
                      child: SizedBox(height: 25), // Add spacing using WidgetSpan and SizedBox
                    ),
                    TextSpan(
                      text: '   ayushy21@iitk.ac.in',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                  
                ),
              ),
              
            ),
          ],
          
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
                children: [
                  SizedBox(width: 12),
                  CircleAvatar(
                    radius: 12,
                    backgroundImage: NetworkImage(
                    'https://png.pngtree.com/png-vector/20190507/ourmid/pngtree-vector-location-icon-png-image_1024680.jpg'),
                  ),
                  SizedBox(width: 5),
                  Text(
                    'City: Kanpur',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  
                ],
              ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
                children: [
                  SizedBox(width: 12),
                  CircleAvatar(
                    radius: 12,
                    backgroundImage: NetworkImage(
                        'https://static.vecteezy.com/system/resources/thumbnails/000/554/591/small/briefcase_001.jpg'), // Replace with your photo URL
                  ),
                  SizedBox(width: 5),
                  Text(
                    'Roll No: 210251',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
        ),
      ],
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0; 
  bool isNavigationExtended = false;

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = GeneratorPage();
        break;
      case 1:
        page = FavoritesPage();
        break;
      case 2:
        page = PersonPage();
        break;
      // case 3:
      //   page = MenuPage();
      //   break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }
    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        body: Row(
          children: [
            SafeArea(
              child: NavigationRail(
                extended: isNavigationExtended,
                destinations: [
                  NavigationRailDestination(
                    icon: Icon(Icons.home),
                    label: Text('Home'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.favorite),
                    label: Text('Favorites'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.person),
                    label: Text('Profile'),
                  ),
                  // NavigationRailDestination(
                  //   icon:Icon(Icons.menu),
                  //   label: Text('Menu'),
                  // )
                ],
                selectedIndex: selectedIndex,
                onDestinationSelected: (value) {
                  setState(() {
                    selectedIndex = value;
                  });
                },
              ),
            ),
            Expanded(
              child: Container(
                color: Theme.of(context).colorScheme.primaryContainer,
                child: page,
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              isNavigationExtended = !isNavigationExtended;
            });
          },
          child: Icon(Icons.menu),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.miniStartFloat,
      );
    });
  }

}

class GeneratorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var pair = appState.current;

    IconData icon;
    if (appState.favorites.contains(pair)) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BigCard(pair: pair),
          SizedBox(height: 10),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  appState.toggleFavorite();
                },
                icon: Icon(icon),
                label: Text('Like'),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  appState.getNext();
                },
                child: Text('Next'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class BigCard extends StatelessWidget {
  const BigCard({
    super.key,
    required this.pair,
  });

  final WordPair pair;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );

    return Card(
      color: theme.colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Text(
          pair.asLowerCase,
          style: style,
          semanticsLabel: "${pair.first} ${pair.second}",
        ),
      ),
    );
  }
}