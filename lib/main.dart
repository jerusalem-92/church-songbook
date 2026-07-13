import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:share_plus/share_plus.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  await Hive.openBox('songs');
  await Hive.openBox('favorites');

  runApp(const ChurchSongApp());
}

class ChurchSongApp extends StatelessWidget {
  const ChurchSongApp({super.key});

  static final ValueNotifier<ThemeMode> themeNotifier =
      ValueNotifier(ThemeMode.light);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, themeMode, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Church Songbook',
          themeMode: themeMode,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
            scaffoldBackgroundColor: Colors.grey[100],
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.blue,
              titleTextStyle: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              iconTheme: IconThemeData(color: Colors.black),
              elevation: 0,
            ),
          ),
          darkTheme: ThemeData.dark().copyWith(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.blue,
              brightness: Brightness.dark,
            ),
            scaffoldBackgroundColor: Colors.grey[900],
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.blueGrey,
              titleTextStyle: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              iconTheme: IconThemeData(color: Colors.white),
              elevation: 0,
            ),
          ),
          home: const MainScreen(),
        );
      },
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

  final List<Widget> pages = const [
    HomePage(),
    SongsPage(),
    FavoritesPage(),
    SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        currentIndex: currentIndex,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black54,
        type: BottomNavigationBarType.fixed,
        onTap: (i) {
          setState(() {
            currentIndex = i;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: Colors.black,
            ),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.music_note,
              color: Colors.black,
            ),
            label: "Songs",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.favorite,
              color: Colors.black,
            ),
            label: "Favorites",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.settings,
              color: Colors.black,
            ),
            label: "Settings",
          ),
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
      appBar: AppBar(
        title: const Text("Church Songbook"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _categoryCard(
              context,
              "Amharic Songs",
              Icons.language,
              "Amharic",
            ),
            const SizedBox(height: 12),
            _categoryCard(
              context,
              "Afaan Oromo Songs",
              Icons.music_note,
              "Afaan Oromo",
            ),
            const SizedBox(height: 12),
            _categoryCard(
              context,
              "Wolaita Songs",
              Icons.queue_music,
              "Wolaita",
            ),
            const SizedBox(height: 12),
            _categoryCard(
              context,
              "English Songs",
              Icons.library_music,
              "English",
            ),
          ],
        ),
      ),
    );
  }

  Widget _categoryCard(
    BuildContext context,
    String title,
    IconData icon,
    String category,
  ) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          size: 30,
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => SongsPage(
                category: category,
              ),
            ),
          );
        },
      ),
    );
  }
}
/* ================= SONGS PAGE ================= */

class SongsPage extends StatefulWidget {
  final String category;

  const SongsPage({
    super.key,
    this.category = "All",
  });

  @override
  State<SongsPage> createState() => _SongsPageState();
}

class _SongsPageState extends State<SongsPage> {
  final box = Hive.box('songs');
  final favBox = Hive.box('favorites');

  List songs = [];
  List filtered = [];

  @override
  void initState() {
    super.initState();
    loadSongs();
  }

  void loadSongs() {
    final defaultSongs = [
      // Add sample songs ONLY ON FIRST RUN

      {
        "title": "karan dhuganilee ana kan jedhe",
        "lyrics": """
karan dhuganilee ana kan jedhe
Yesus Du'a Moo'ee Nuuf Ka'ee x2

1.
Iyaru Salemrit ni dhalate
Cubbuu baye keessa nuu base
Kakuu Harawaalee nuuf late x2

2.
Cubbuu kenyaa dhiisuf nuu dhalate
Iddoo duuwa keenya nuuf gute'ee
Hafuura Qulqulluu nuuf kene x2

3.
Worri Balanike situ olfate
Garaa kiya kotta nuluun jettee
Boqqonale kuno nuuf bayifte x2

4.
Mariam falale yoo dhalawni
Awalicha duwa ni arganil
Yesus keenya kuno humna qaba
Awalichale dige nuuf ka'eeraa x2
""",
        "lang": "Afaan Oromo",
      },

// Amharic Song
      {
        "title": "Wolaita Yesuusaa Galataa",
        "lyrics": """
Wolaita Yesuusaa galataa
Aawaa agga gido yohanne
Baasaa baqaa x2

1.
Yesuusaa nuuni woossana
Malaata gido beettaana
Aawaa nuuyyo maaddaa
Yohanne ta'aa x2
""",
        "lang": "Wolaita",
      },
      {
        "title": "የባርነትን ቀንበር የሰበረው",
        "lyrics": """
የባርነትን ቀንበር የሰበረው
ቀና ብለን እንድንሄድ ያደረገው
እርሱ እግዚአብሔር ነው ዛሬም ያለው
ይገባዋል ክብር ምስጋና ለገናናው

ይገባዋል ለገናናው
ክብር
ምስጋና

ፈረሱንና ፈረሰኛውን በባሕር የጣለው
በክብርም ቢሆን ከፍ ከፍ ያለው
ባሄድንበትም መንገድ ከእኛ ጋር የሆነው
እግዚአብሔር ነው እርሱ ስለ እኛ የተዋጋው

ይህ ነው አምላካችን የተሞላ በምስጋና
ይመሰገን እርሱ ዛሬም እንደገና

ይመሰገን
ይከበር
ይወደስ

የኤርትራን ባሕር ገሥፆ ያደረቀው
በምድረ በዳም በድንቅ የመራው
ከጠላት እጅ እስራኤልን ያዳነው
ያሳደዱትን ጠላት በውሃ ያሰጠመው

ኤልሻዳይ ጌታ ነው ኃይሉን የገለጠው
እንዘምርለት አምላካችን ክብር የተገባው

ውዳሴ
እልልታ
""",
        "lang": "Amharic",
      },

// Amharic Song 2
      {
        "title": "እዩት ልብ በሉት",
        "lyrics": """
1.
በእውነት ደዌያችንን ተቀበለ ህመማችንን
እርሱ ግን ቆሰለ ስለ አመፃችን
እንደተቀጸፈ በእግዚአብሔር እንደተጠላ
እኛ ግን ቆጠርነው የደም ግባት እንደሌለው

በራሱ ስቃይ ሌላውን ሲፈታ
በቀራንዮ በገልጎታ
እጅ እግሮቹን በችንካር ሲመታ
እዩት ልብ በሉት ያን መሐሪ ጌታ

2.
መስቀል ተሸክሞ ሲወጣ ያንን ተራራ
ማንም አልረዳውም ስቃዩንና መከራ
ሲጠላ ሲገፋ አጸፋውን ሳይመልስ
ምንም ሳይናገር
ሁሉንም በትዕግስት ቻለው

3.
ኤሎሄ ኤሎሄ ብሎ ሲጮህ ወይ አባቱ
እርሱም አልራራለት ሲበዛበት ጣር ጭንቀቱ
ተፈጸመ ብሎ ነፍሱን አሳለፈ
ፈጸሞ ዝም አለ ጨከነ ፍቅሩን ሊገልጥ
""",
        "lang": "Amharic",
      },

// Amharic Song 3

      {
        "title": "የእስራኤል ቅዱስ",
        "lyrics": """
የእስራኤል ቅዱስ (4)
እንደቀድሞ ዘመናችን ይታደስ

ይታደስ (2) ጌታ ሆይ
የቀድሞ ክብር ይመለስ

ይታደስ (2) የሱስ ሆይ
የቀድሞ ክብር ይመለስ

1.
ህዝብ ሞልቶባት የነበረች ከተማ
ምድረ በዳ ስለሆነች እንደ አውድማ
እያለቀሰ ኤርምያስ እንባውን ሲያፈስ
እንደገና ታደሰች ጌታ ሆይ ስትመለስ

2x
እኛም ፈልገናል እንዲመለስ ክብርህ
አሳየን ጌታ ሆይ ተስፋችን አንተ ነህ

2.
አቤቱ በስምህ አምነናልና
እርዳን እንደገና ያለ አንተ አንችልምና
አምላካችን አንተ ነህ ምንም ማያሸንፍህ
አትጣለን በጠላት ፊት ይምጣልን ኃይልህ

2x
ይመጣል ኃይል ይመጣል
ይሻለናል በአንተ ጊዜ የሚሆንልን

3.
የቃልኪዳኑን ታቦት በምድረ በዳ ባሉ ጊዜ
የኪዳኑን መፅሐፍ ሙሴም ወስዶ ባነበበ ጊዜ
የጌታን ትዕዛዝ እናደርጋለን ብለው ሲስማሙ በአንድነት
ያንተ ክብር በተራራው ላይ ታየ እንደ እሳት

2x
እኛም እጆቻችን እያነሳን ወደ ሰማይ
እንለምናለን እንዳንሞት ክብርህን አሳይ

4.
እግዚያብሔር የሚመስልህ የለም እንደ አንተ ትልቅ
ለባሪያዎችህ ኪዳንና ምህረትን የምትጠብቅ
አሁንም አምላካችን ተነሳ ከዙፋንህ
አንተን እንፈልጋለን እንፈልጋለን አንጸናምና ያለ ክብርህ

2x
አቤቱ ይመለስ ምርኳችህ
አሮጌ የሆነው ይቀየር ታሪካችን
""",
        "lang": "Amharic",
      },

      {
        "title": "በአዲስ ዘመን አዲስ ነገር",
        "lyrics": """
በአዲስ ዘመን አዲስ ነገር
የእግዚአብሔር ስም እንዲነገር
እንጠብቀዋለን በናፍቆት
ያደርገዋል ምን ተስኖት

የተዘጋው ደጅ ተከፍቶ
የተገደበው ጅረት ወርዶ
እንሰማለን የድል ዜና
እንዘጋጅ ለምስጋና

በፍጹም ሞት አይገዛም
ትንሣኤ አለ ለሙታንም
ያዘነውን ዕንባ ያብሳል
ገናና የድል ጌታ የሱስ

በችግር ጊዜ በሰው የሌለን
መጠጊያ ይሆነናል
የሠራዊት አምላክ የፀባኦት
ቸሩ አባት ዝም አይልም

ሰማያዊው ገበሬ
የወንጌል ዘር በእምነት ተዘራ
የበቀለው ስንዴ መስሎ
ተሰብስቧል በጎተራ

ውሃ ያጣ ገላ መስሎ
ውሃ የሌለው ደረቅ ሜዳ
ጌታ የሰጠው ረጅም እድሜ
እርሱም ያያል ልምላሜ
""",
        "lang": "Amharic",
      },
      {
        "title": "አመት በአመት ሲተካ",
        "lyrics": """
አመት በአመት ሲተካ
ህይወት በእድሜ ሲለካ
እንዲህ የሚያደርገው እግዚአብሔር ነው ለካ
ወደ ፈጣሪዬ ምስጋናዬን እንዘምር /2x

1)
በአቻምናም በአምናም ዘንድሮ
ድንኳን ተክሎልን ከህዝቡ ጋር አብሮ
ከጠላት መንጋጋ ከአስፈሪው ቀንበር
ያዳነን ጠብቆን ይመስገን ይከበር

2)
ተስፋችን አልቆ ጠላት ሲያጠምደን
ከዘመን ዘመን አሸጋገርከን
ተዋጋልን አምላክ የሠራዊት ጌታ
ሆኖልናል እና ጋሻ መከታ

3)
የሰላም ጊዜ የበረከት ማዕድ
ስለሰጠን አባት ክብር አናቋርጥም
እንዲህ የምንዘምረው እንዳንረሳው ነው
ጌታ በመንገዳችን እንዲመራን ነው
""",
        "lang": "Amharic",
      },

      {
        "title": "በሰማይ በታላቅ ክብር",
        "lyrics": """
በሰማይ በታላቅ ክብር የምትኖር
መልአክት ፍጥነት የሚያመለክትባት (2x)
በዚህ ፈቃድ በላኩኝ ላት
እኛም እርስ በርስ በመስቀል ላይ ቆመን
ከዚህ የሚበልጥ ፍቅር አለ ወይ (2x)
በሰማይም ቢሆን በምድር ላይ

ተጨነቁ ተደቀቁ
እኛም አልነበረንም
ከዚህ ጽድቅ ምድር ተወለድ
ስለ እመቤቴ መለስ
ተቀው ስለሰው ተመለሰ (2x)
በእውነት ደምሽን ተቀበል

ምንም ወንጀል ሳይኖርበት
በአፍም ትንፋሽ ሳይገኝበት
ዝም አለ ለተለይ
እኛን ልታድነን ከሞት ፍርድ
ተገዝ ተሰቀለ ሞተ
ሁሉንም አለፈ ለመድኃኔዓለም (2x)

በረከትህ እያሰበ
ተቀበል እምነታችን
እኛ ግን እንደተናገረ ሰው
እንደ ተለየው ጥም ነው
ያንን መቼ አላስታውስ
የአማርኛ ንባብ ለማ ጠለቀ (2x)

ስለ መታለፊያችሁ ቀላል
ስለ በደላችሁ ቆቆ
እኛ ጠንካራ የነበርን
በእርሱ ጥላ ተመለሰ
ለምን ለእኛ አላማለደ
ለእርሱ ክብር ይህን አምኜ (2x)
""",
        "lang": "Amharic",
      },

      {
        "title": "በክፉ ቀን ደራሽ",
        "lyrics": """
በክፉ ቀን ደራሽ (3x)
ማነው ማነው ማነው ኢየሱስ ብቻ ነው

ለታመመው ደራሽ ኢየሱስ ነው
የበሽታ ፈዋሽ ኢየሱስ ነው
ያዘነው ሚያፅናና ኢየሱስ ነው
መቃብር የሚከፍት ኢየሱስ ነው

ከሞት የተነሳው ኢየሱስ ነው
በሕይወት የሚያኖር ኢየሱስ ነው
እናት አባት ሚሆን ኢየሱስ ነው
መሸሸጊያ ዋሻ ኢየሱስ ነው

መመኪያ ኃይላችን ኢየሱስ ነው
ሰማይ ምድር ፈጣሪ ኢየሱስ ነው
ጨለማን የሚያበራ ኢየሱስ ነው
ከሞት የሚያስነሳ ኢየሱስ ነው
""",
        "lang": "Amharic",
      },

      {
        "title": "የኔ ጌታ አይጥለኝም",
        "lyrics": """
የኔ ጌታ አይጥለኝም
የኔ የሱስ አይተወኝም
ማንን እንደረሳ ይረሳኛል
ማንን እንደተው ይተወኛል

ከአስራ ሁለት ዓመት ደም ሲፈስባት
አቅሟ ገንዘቧን ሁሉ አልቆባት
ድንገት በየሱስ ልብስ ወዲያው ተፈወሰች
እየተደሰተች ወደ ቤቷ ሄደች

ለተቸገረ ሰው ደራሽ
የኔ ጌታ የታሰረውን ማህተም ቀድሞ የሚፈታ
ማንን እንዲተው ሊተወኝ ይችላል
ለጥያቄዬ መልስ ሊሰጠኝ ይችላል

ማጣቴንም ያኔ በቤቴ አይተሃል
ልሰጠኝም አንተ ቃልህ ገብተሃል
ማንም ሲተወኝ ያለተውከኝ አንተ ነህ
በጠላቶቼም ፊት አከበርከኝ አንተህ
""",
        "lang": "Amharic",
      },

      {
        "title": "ኤልሻዳይ ነህ",
        "lyrics": """
ኤልሻዳይ ነህ ኤልሻዳይ [2x]
ሁሉን ቻይ ነህ ሁሉን ቻይ [2x]

ለደካማው ኃይልን ልትሰጥ ኤልሻዳይ ነህ [2x]
መራራውን ሕይወት ልታጣፍጥ
የደነደነውን ልብ ልትለውጥ
የተዘጋውን ደጅ ትከፍታለህ
የናሱንም መዝጊያ ትሰብራለህ
በጭንቀት ውስጥ ሰላም ትሆናለህ

ተራራውን ሜዳ ታደርጋለህ
ሸለቆውን ውሃ ትሞላለህ
በጨለማ ብርሃን ትሆናለህ

ከፋንድያ ከአመድ ታነሳለህ
በግ ጠባቂውን ንጉስ ታደርጋለህ
ለመካኒቱ ልጅ ትሰጣለህ

ሰማያትን በስንዝር ልትለካ
ውሆችንም እልፍኝ ልትሰፍር
ኤልሻዳይ ቅዱስ እግዚአብሔር
መራራውን ሕይወት ልታጣፍጥ
የተዘጋውን መልሰህ ልትከፍት
መካኒቱን በልጅ ልትባርክ
""",
        "lang": "Amharic",
      },
    ];

    if (box.isEmpty) {
      box.addAll(defaultSongs);
    } else {
      final existingTitles =
          box.values.map((value) => value["title"].toString()).toSet();

      for (final song in defaultSongs) {
        if (!existingTitles.contains(song["title"])) {
          box.add(song);
        }
      }
    }

    songs = box.values.toList();
    applyFilter();
  }

  void searchSong(String query) {
    final q = query.toLowerCase();
    final base = widget.category == "All"
        ? songs
        : songs.where((s) => s["lang"] == widget.category).toList();

    setState(() {
      if (q.isEmpty) {
        filtered = base;
      } else {
        filtered = base.where((s) {
          final title = s["title"]?.toString().toLowerCase() ?? '';
          final lyrics = s["lyrics"]?.toString().toLowerCase() ?? '';
          final lang = s["lang"]?.toString().toLowerCase() ?? '';
          return title.contains(q) || lyrics.contains(q) || lang.contains(q);
        }).toList();
      }
    });
  }

  void applyFilter() {
    if (widget.category == "All") {
      filtered = songs;
    } else {
      filtered = songs.where((s) => s["lang"] == widget.category).toList();
    }

    setState(() {});
  }

  void toggleFavorite(Map song) {
    final key = song["title"];

    if (favBox.containsKey(key)) {
      favBox.delete(key);
    } else {
      favBox.put(key, song);
    }

    setState(() {});
  }

  bool isFavorite(Map song) {
    return favBox.containsKey(song["title"]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.category} Songs"),
        backgroundColor: Colors.blue,
      ),
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
              itemCount: filtered.length,
              itemBuilder: (context, index) {
                final song = filtered[index];
                final isDark = Theme.of(context).brightness == Brightness.dark;

                return Card(
                  elevation: 3,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  child: ListTile(
                    leading: Icon(
                      Icons.music_note,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                    title: Text(
                      song["title"],
                      style: TextStyle(
                          color: isDark ? Colors.white : Colors.black),
                    ),
                    subtitle: Text(
                      song["lang"],
                      style: TextStyle(
                          color: isDark ? Colors.grey[400] : Colors.grey),
                    ),
                    trailing: IconButton(
                      icon: Icon(
                        isFavorite(song)
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: Colors.red,
                      ),
                      onPressed: () => toggleFavorite(song),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => SongDetailPage(song: song),
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

/* ================= FAVORITES PAGE ================= */

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final favBox = Hive.box('favorites');

    final favSongs = favBox.values.whereType<Map>().toList(growable: false);

    return Scaffold(
      appBar: AppBar(title: const Text("Favorites ❤️")),
      body: Builder(
        builder: (context) {
          final isDark = Theme.of(context).brightness == Brightness.dark;
          return ListView(
            children: favSongs
                .map((s) => ListTile(
                      title: Text(
                        s["title"],
                        style: TextStyle(
                            color: isDark ? Colors.white : Colors.black),
                      ),
                      subtitle: Text(
                        s["lang"],
                        style: TextStyle(
                            color: isDark ? Colors.grey[400] : Colors.grey),
                      ),
                    ))
                .toList(),
          );
        },
      ),
    );
  }
}

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  // 🔗 SHARE APP FUNCTION
  void shareApp() {
    const String appLink =
        "https://appdistribution.firebase.dev/i/85a1142f934455e0";

    Share.share(
      "🎵 Church Songbook App\n\nDownload it now 👇\n$appLink",
      subject: "Church Songbook App",
    );
  }

  // 👨‍💻 ABOUT DIALOG
  void showAbout(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("About Developer"),
        content: const Text(
          "👨‍💻 Developer: Eyerusalem Desta\n"
          "📱  Developer\n"
          "🎵 Church Song App Creator\n\n"
          "This app is built to help users access church songs easily in Amharic, Afaan Oromo, Wolaita, and English.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          )
        ],
      ),
    );
  }

  // 📞 CONTACT DIALOG
  void showContact(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Contact Us"),
        content: const Text(
          "📧 Email: jerusalemwe@gmail.com\n"
          "📱 Phone: +251 918 177 889\n"
          "🌍 Country: Ethiopia",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        centerTitle: true,
      ),
      body: ValueListenableBuilder<ThemeMode>(
        valueListenable: ChurchSongApp.themeNotifier,
        builder: (context, themeMode, _) {
          final isDark = themeMode == ThemeMode.dark;

          return ListView(
            children: [
              const SizedBox(height: 10),

              SwitchListTile(
                secondary: Icon(
                  isDark ? Icons.dark_mode : Icons.light_mode,
                  color: isDark ? Colors.indigo : Colors.orange,
                ),
                title: const Text("Appearance"),
                subtitle: Text(isDark ? "Dark mode" : "Light mode"),
                value: isDark,
                onChanged: (value) {
                  ChurchSongApp.themeNotifier.value =
                      value ? ThemeMode.dark : ThemeMode.light;
                },
              ),

              const Divider(),

              // 👨‍💻 ABOUT
              ListTile(
                leading: const Icon(Icons.person, color: Colors.blue),
                title: const Text("About Developer"),
                subtitle: const Text("Who built this app"),
                onTap: () => showAbout(context),
              ),

              const Divider(),

              // 📞 CONTACT
              ListTile(
                leading: const Icon(Icons.contact_mail, color: Colors.green),
                title: const Text("Contact Us"),
                subtitle: const Text("Email / Phone support"),
                onTap: () => showContact(context),
              ),

              const Divider(),

              // 🔗 SHARE APP
              ListTile(
                leading: const Icon(Icons.share, color: Colors.orange),
                title: const Text("Share App"),
                subtitle: const Text("Invite friends to use this app"),
                onTap: shareApp,
              ),

              const Divider(),

              // ℹ️ APP INFO
              const ListTile(
                leading: Icon(Icons.info, color: Colors.grey),
                title: Text("App Version"),
                subtitle: Text("v1.0.0"),
              ),

              const SizedBox(height: 20),
            ],
          );
        },
      ),
    );
  }
}
/* ================= SONG DETAIL PAGE ================= */

class SongDetailPage extends StatelessWidget {
  final Map song;

  const SongDetailPage({
    super.key,
    required this.song,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(song["title"] ?? "Song"),
        centerTitle: true,
      ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: SelectableText(
            song["lyrics"] ?? "",
            style: TextStyle(
              fontSize: 18,
              height: 1.6,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
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
