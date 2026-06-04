import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  await Hive.openBox('songs');

  runApp(const ChurchSongApp());
}

class ChurchSongApp extends StatelessWidget {
  const ChurchSongApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Church Songbook',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: const MainScreen(),
    );
  }
}

/* ================= MAIN SCREEN ================= */

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentIndex = 0;

  final pages = const [
    HomePage(),
    SongsPage(),
    ChoirPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.music_note), label: "Songs"),
          BottomNavigationBarItem(icon: Icon(Icons.group), label: "Choir"),
        ],
      ),
    );
  }
}

/* ================= HOME ================= */

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Church Songbook Home")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          categoryCard("Amharic Songs", Icons.language),
          categoryCard("English Songs", Icons.music_note),
          categoryCard("Afaan Oromo Songs", Icons.library_music),
        ],
      ),
    );
  }

  Widget categoryCard(String title, IconData icon) {
    return Card(
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () {},
      ),
    );
  }
}

/* ================= SONGS PAGE ================= */

class SongsPage extends StatefulWidget {
  const SongsPage({super.key});

  @override
  State<SongsPage> createState() => _SongsPageState();
}

class _SongsPageState extends State<SongsPage> {
  final box = Hive.box('songs');

  List songs = [];
  List filteredSongs = [];

  @override
  void initState() {
    super.initState();

    // Add your Afaan Oromo song once
    if (box.isEmpty) {
      box.add({
        "title": "Yesus Du'a Moo'ee Nuuf Ka'ee",
        "lyrics": """
Yesus Du'a Moo'ee Nuuf Ka'ee x2

1.
Iyaru Salemrit ni dhalate
Cubbuu baya keessa nuu baye
Kakuu Harawaalee nuuf late x2

2.
Cubbuu keenya dhiisuf nuu dhalate
Iddoo duuwa keenya nuuf guutee
Hafuura Qulqulluu nuuf kenne x2

3.
Worri Balanike situ olfate
Garaa kiya kotta jechuun jettee
Boffonale kuno nuuf bayifte x2

4.
Mariam falale yoo dhalawni
Awalicha duwa ni arganvi
Yesus keenya kuno humna qaba
Awalichale dige nuuf ka'eeraa x2
""",
        "lang": "Afaan Oromo",
      });
    }

    songs = box.values.toList();
    filteredSongs = songs;
  }

  void searchSong(String query) {
    final results = songs.where((song) {
      final title = song["title"].toString().toLowerCase();
      return title.contains(query.toLowerCase());
    }).toList();

    setState(() {
      filteredSongs = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Songs")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search songs...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: searchSong,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredSongs.length,
              itemBuilder: (context, index) {
                final song = filteredSongs[index];

                return Card(
                  child: ListTile(
                    leading: const Icon(Icons.music_note),
                    title: Text(song["title"]),
                    subtitle: Text(song["lang"]),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => SongDetailPage(
                            title: song["title"],
                            lyrics: song["lyrics"],
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/* ================= SONG DETAIL PAGE ================= */

class SongDetailPage extends StatelessWidget {
  final String title;
  final String lyrics;

  const SongDetailPage({
    super.key,
    required this.title,
    required this.lyrics,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Text(
          lyrics,
          style: const TextStyle(fontSize: 18, height: 1.5),
        ),
      ),
    );
  }
}

/* ================= CHOIR ================= */

class ChoirPage extends StatelessWidget {
  const ChoirPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Choir Groups")),
      body: ListView(
        children: const [
          ListTile(leading: Icon(Icons.group), title: Text("Choir Group 1")),
          ListTile(leading: Icon(Icons.group), title: Text("Choir Group 2")),
          ListTile(leading: Icon(Icons.group), title: Text("Choir Group 3")),
        ],
      ),
    );
  }
}
