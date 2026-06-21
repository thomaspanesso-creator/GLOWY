import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

  runApp(GlowyApp(isLoggedIn: isLoggedIn));
}

class GlowyApp extends StatelessWidget {
  final bool isLoggedIn;

  const GlowyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GLOWY',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF070412),
      ),
      home: isLoggedIn ? const MainNavigationPage() : const LoginPage(),
    );
  }
}

class MainNavigationPage extends StatefulWidget {
  const MainNavigationPage({super.key});

  @override
  State<MainNavigationPage> createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const FeedScreen(),
    const SearchScreen(),
    const UploadScreen(),
    const SavedScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(0.7, -0.6),
            radius: 1.3,
            colors: [Color(0xFF25113A), Color(0xFF070412)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 10.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'GLOWY',
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        letterSpacing: 4.0,
                        fontSize: 28,
                        color: Colors.white,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.logout, color: Color(0xFFE5A4E7)),
                      onPressed: () async {
                        final prefs = await SharedPreferences.getInstance();
                        await prefs.setBool('isLoggedIn', false);
                        if (context.mounted) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginPage(),
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
              Expanded(child: _screens[_selectedIndex]),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: Color(0xFF25113A), width: 1.5)),
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: const Color(0xFF0C081F),
          selectedItemColor: const Color(0xFFFF416C),
          unselectedItemColor: const Color(0xFF8E8A9F),
          showUnselectedLabels: true,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.auto_awesome),
              label: 'Inicio',
            ),
            BottomNavigationBarItem(icon: Icon(Icons.tune), label: 'Buscar'),
            BottomNavigationBarItem(
              icon: Icon(Icons.add_circle_outline),
              label: 'Subir',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bookmark_border),
              label: 'Guardados',
            ),
          ],
        ),
      ),
    );
  }
}

// 1. PANTALLA DE INICIO (FEED DE IMÁGENES TIPO MOSAICO)
class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> categories = [
      {'name': 'All', 'icon': '✨'},
      {'name': 'Coquette', 'icon': '🎀'},
      {'name': 'Minimal', 'icon': '⚪'},
      {'name': 'Aesthetic', 'icon': '🪐'},
      {'name': 'Elegant', 'icon': '💎'},
      {'name': 'Trendy', 'icon': '🔥'},
    ];

    final List<Map<String, String>> nailDesigns = [
      {
        'url': 'https://unsplash.com',
        'title': 'Minimalist Red',
        'likes': '324',
      },
      {
        'url': 'https://unsplash.com',
        'title': 'Glam Extravaganza',
        'likes': '1.2k',
      },
      {'url': 'https://unsplash.com', 'title': 'Pastel French', 'likes': '542'},
      {
        'url': 'https://unsplash.com',
        'title': 'Chrome Metallic',
        'likes': '891',
      },
      {
        'url': 'https://unsplash.com',
        'title': 'Coquette Bows 🎀',
        'likes': '2.3k',
      },
      {
        'url': 'https://unsplash.com',
        'title': 'Emerald Luxury',
        'likes': '415',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 5.0),
          child: Text(
            'Nail inspiration\nthat matches you ✨',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              height: 1.3,
            ),
          ),
        ),
        SizedBox(
          height: 55,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(
              horizontal: 12.0,
              vertical: 8.0,
            ),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final cat = categories[index];
              final isAll = cat['name'] == 'All';
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 5.0),
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                decoration: BoxDecoration(
                  gradient: isAll
                      ? const LinearGradient(
                          colors: [Color(0xFFFF416C), Color(0xFF8A2387)],
                        )
                      : null,
                  color: isAll
                      ? null
                      : const Color(0xFF1E1A3A).withOpacity(0.6),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Text(cat['icon']!),
                    const SizedBox(width: 6),
                    Text(
                      cat['name']!,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: MasonryGridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 14,
              crossAxisSpacing: 14,
              itemCount: nailDesigns.length,
              itemBuilder: (context, index) {
                final design = nailDesigns[index];
                final double cardHeight = (index % 3 == 0)
                    ? 260
                    : (index % 3 == 1)
                    ? 200
                    : 310;

                return Container(
                  height: cardHeight,
                  decoration: BoxDecoration(
                    color: const Color(0xFF16122C),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFF25113A)),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: Image.network(design['url']!, fit: BoxFit.cover),
                      ),
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withOpacity(0.2),
                                Colors.black.withOpacity(0.85),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 12,
                        right: 12,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.5),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.bookmark_border,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 12,
                        left: 12,
                        right: 12,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              design['title']!,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(
                                  Icons.favorite,
                                  color: Color(0xFFFF416C),
                                  size: 12,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  design['likes']!,
                                  style: const TextStyle(
                                    color: Color(0xFF8E8A9F),
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

// ==========================================
// 2. PANTALLA DE BÚSQUEDA Y FILTROS
// ==========================================
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<String> _searchHistory = [];

  @override
  void initState() {
    super.initState();
    _loadSearchHistory();
  }

  Future<void> _loadSearchHistory() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _searchHistory = prefs.getStringList('glowy_search_history') ?? [];
    });
  }

  Future<void> _saveToHistory(String query) async {
    if (query.trim().isEmpty) return;
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _searchHistory.remove(query);
      _searchHistory.insert(0, query);
      if (_searchHistory.length > 5) _searchHistory.removeLast();
    });
    await prefs.setStringList('glowy_search_history', _searchHistory);
  }

  Future<void> _clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _searchHistory.clear();
    });
    await prefs.remove('glowy_search_history');
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _searchController,
            onSubmitted: (value) {
              _saveToHistory(value);
              _searchController.clear();
            },
            decoration: InputDecoration(
              hintText: 'Buscar colores, técnicas...',
              prefixIcon: const Icon(Icons.search, color: Color(0xFFFF416C)),
              filled: true,
              fillColor: const Color(0xFF16122C),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: const BorderSide(color: Color(0xFF25113A)),
              ),
            ),
          ),
          const SizedBox(height: 25),
          if (_searchHistory.isNotEmpty) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'BÚSQUEDAS RECIENTES',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
                TextButton(
                  onPressed: _clearHistory,
                  child: const Text(
                    'Limpiar',
                    style: TextStyle(color: Color(0xFFFF416C), fontSize: 12),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: _searchHistory
                  .map(
                    (query) => ActionChip(
                      backgroundColor: const Color(0xFF16122C),
                      label: Text(
                        query,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                        ),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      onPressed: () {
                        _searchController.text = query;
                      },
                    ),
                  )
                  .toList(),
            ),
          ] else ...[
            const Center(
              child: Padding(
                padding: EdgeInsets.only(top: 40.0),
                child: Text(
                  'No tienes búsquedas recientes.',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ==========================================
// 3. PANTALLA DE SUBIR CONTENIDO
// ==========================================
class UploadScreen extends StatelessWidget {
  const UploadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Subir Diseño'));
  }
}

// ==========================================
// 4. PANTALLA DE GUARDADOS INTERACTIVA
// ==========================================
class SavedScreen extends StatefulWidget {
  const SavedScreen({super.key});

  @override
  State<SavedScreen> createState() => _SavedScreenState();
}

class _SavedScreenState extends State<SavedScreen> {
  List<Map<String, String>> _agendaFolders = [];
  bool _isViewingDetail = false;
  String _currentFolderTitle = '';

  @override
  void initState() {
    super.initState();
    _loadFolders();
  }

  Future<void> _loadFolders() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? savedList = prefs.getStringList('glowy_folders');
    if (savedList == null || savedList.isEmpty) {
      _agendaFolders = [
        {
          'title': 'Mi Próximo Estilo ✨',
          'subtitle': 'El diseño seleccionado para tu siguiente cita',
          'count': '1',
        },
        {
          'title': 'Inspiración por mi Tono',
          'subtitle': 'Estilos que contrastan con tu tono de piel',
          'count': '14',
        },
        {
          'title': 'Historial de Manicuras',
          'subtitle': 'Diseños que ya te has aplicado antes',
          'count': '8',
        },
      ];
      _saveFoldersToPrefs();
    } else {
      setState(() {
        _agendaFolders = savedList.map((item) {
          final parts = item.split('|');
          return {'title': parts[0], 'subtitle': parts[1], 'count': parts[2]};
        }).toList();
      });
    }
  }

  Future<void> _saveFoldersToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> listToSave = _agendaFolders
        .map((f) => '${f['title']}|${f['subtitle']}|${f['count']}')
        .toList();
    await prefs.setStringList('glowy_folders', listToSave);
  }

  void _createNewFolderDialog() {
    final titleController = TextEditingController();
    final subtitleController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF16122C),
          title: const Text(
            'Nuevo Panel de Inspiración',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                autofocus: true,
                decoration: const InputDecoration(
                  labelText: 'Nombre',
                  labelStyle: TextStyle(color: Colors.grey),
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: subtitleController,
                decoration: const InputDecoration(
                  labelText: 'Descripción corta',
                  labelStyle: TextStyle(color: Colors.grey),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Cancelar',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF416C),
              ),
              onPressed: () {
                if (titleController.text.trim().isNotEmpty) {
                  setState(() {
                    _agendaFolders.add({
                      'title': titleController.text.trim(),
                      'subtitle': subtitleController.text.trim().isEmpty
                          ? 'Colección personalizada'
                          : subtitleController.text.trim(),
                      'count': '0',
                    });
                  });
                  _saveFoldersToPrefs();
                  Navigator.pop(context);
                }
              },
              child: const Text(
                'Crear',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isViewingDetail) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Color(0xFFFF416C)),
                  onPressed: () => setState(() => _isViewingDetail = false),
                ),
                Expanded(
                  child: Text(
                    _currentFolderTitle,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
            const Center(
              child: Text(
                'Aún no hay fotos en este panel.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: _agendaFolders.length,
        itemBuilder: (context, index) {
          final folder = _agendaFolders[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 15),
            decoration: BoxDecoration(
              color: const Color(0xFF16122C),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: const Color(0xFF25113A)),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 10,
              ),
              title: Text(
                folder['title']!,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  folder['subtitle']!,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ),
              trailing: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF070412),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '${folder['count']} uña${folder['count'] == '1' ? '' : 's'}',
                  style: const TextStyle(
                    color: Color(0xFFFF416C),
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              onTap: () => setState(() {
                _isViewingDetail = true;
                _currentFolderTitle = folder['title']!;
              }),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFFF416C),
        onPressed: _createNewFolderDialog,
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
    );
  }
}
