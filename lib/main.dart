import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'login_page.dart';
import 'package:image_picker/image_picker.dart';

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
              // ==========================================
              // ENCABEZADO LOGO Y ESLOGAN PREMIUM DE GLOWY
              // ==========================================
              Padding(
                padding: const EdgeInsets.only(
                  left: 20.0,
                  right: 20.0,
                  top: 15.0,
                  bottom: 5.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: const Color(0xFFFF416C),
                                  width: 1.5,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(
                                      0xFFFF416C,
                                    ).withOpacity(0.3),
                                    blurRadius: 8,
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.auto_awesome,
                                color: Color(0xFFFF416C),
                                size: 16,
                              ),
                            ),
                            const SizedBox(width: 10),
                            ShaderMask(
                              shaderCallback: (bounds) => const LinearGradient(
                                colors: [Color(0xFFFF416C), Color(0xFF8A2387)],
                              ).createShader(bounds),
                              child: const Text(
                                'GLOWY',
                                style: TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 2.5,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'DISCOVER  •  SAVE  •  GET INSPIRED',
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFFE5A4E7),
                            letterSpacing: 2.0,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.logout,
                        color: Color(0xFFE5A4E7),
                        size: 22,
                      ),
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
              const SizedBox(height: 10),
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

    // Datos actualizados a números enteros para los likes matemáticos
    final List<Map<String, dynamic>> nailDesigns = [
      {'url': 'https://unsplash.com', 'title': 'Minimalist Red', 'likes': 324},
      {
        'url': 'https://unsplash.com',
        'title': 'Glam Extravaganza',
        'likes': 1200,
      },
      {'url': 'https://unsplash.com', 'title': 'Pastel French', 'likes': 542},
      {'url': 'https://unsplash.com', 'title': 'Chrome Metallic', 'likes': 891},
      {
        'url': 'https://unsplash.com',
        'title': 'Coquette Bows 🎀',
        'likes': 2300,
      },
      {'url': 'https://unsplash.com', 'title': 'Emerald Luxury', 'likes': 415},
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

                // AQUÍ SE CONECTA TU NUEVA TARJETA CON EL CONTADOR REAL
                return NailDesignCard(design: design, cardHeight: cardHeight);
              },
            ),
          ),
        ),
      ],
    );
  }
}

// ==========================================
// 2. PANTALLA DE BÚSQUEDA Y FILTROS AVANZADOS
// ==========================================
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<String> _searchHistory = [];

  // Estados de memoria para los Filtros Avanzados (La función del 75%)
  String _selectedLength = 'All'; // All, Short, Medium, Long
  String _selectedShape = 'All'; // All, Almond, Square, Stiletto
  Color _selectedColor =
      Colors.transparent; // Color seleccionado para el filtro

  // Paleta de colores interactiva basada en tendencias de Nail Art
  final List<Color> _glowyColors = [
    const Color(0xFFFF416C), // Fucsia/Rosa Glam
    const Color(0xFF8A2387), // Morado Neón
    const Color(0xFFFFB7B2), // Pastel Pink
    const Color(0xFF00F2FE), // Azul Eléctrico
    const Color(0xFF4FACFE), // Celeste Aesthetic
    Colors.white, // Blanco Minimal
    Colors.black, // Negro Dark Elegance
  ];

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

  Future<void> clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _searchHistory.clear();
    });
    await prefs.remove('glowy_search_history');
  }

  // Limpia todos los filtros avanzados aplicados
  void _resetFilters() {
    setState(() {
      _selectedLength = 'All';
      _selectedShape = 'All';
      _selectedColor = Colors.transparent;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Barra de Búsqueda de Texto
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

            // Encabezado de Filtros Avanzados
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'FILTROS AVANZADOS (75% VOTADO)',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF8E8A9F),
                    letterSpacing: 1.0,
                  ),
                ),
                TextButton(
                  onPressed: _resetFilters,
                  child: const Text(
                    'Limpiar Filtros',
                    style: TextStyle(color: Color(0xFFFF416C), fontSize: 12),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),

            // 2. FILTRO POR COLOR INTERACTIVO
            const Text(
              'FILTRAR POR COLOR EXACTO',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _glowyColors.length,
                itemBuilder: (context, index) {
                  final color = _glowyColors[index];
                  final isSelected = _selectedColor == color;
                  return GestureDetector(
                    onTap: () => setState(
                      () => _selectedColor = isSelected
                          ? Colors.transparent
                          : color,
                    ),
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 6),
                      width: 38,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected
                              ? const Color(0xFFFF416C)
                              : const Color(0xFF25113A),
                          width: isSelected ? 3 : 1,
                        ),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: const Color(
                                    0xFFFF416C,
                                  ).withOpacity(0.5),
                                  blurRadius: 10,
                                ),
                              ]
                            : null,
                      ),
                      child: isSelected
                          ? const Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 18,
                            )
                          : null,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 25),

            // 3. FILTRO POR LARGO DE UÑA
            const Text(
              'LONGITUD DE LA UÑA',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: ['All', 'Short', 'Medium', 'Long'].map((length) {
                final isSelected = _selectedLength == length;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedLength = length),
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        gradient: isSelected
                            ? const LinearGradient(
                                colors: [Color(0xFFFF416C), Color(0xFF8A2387)],
                              )
                            : null,
                        color: isSelected ? null : const Color(0xFF16122C),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFF25113A)),
                      ),
                      child: Center(
                        child: Text(
                          length,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isSelected ? Colors.white : Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 25),

            // 4. FILTRO POR FORMA DE UÑA
            const Text(
              'FORMA DE LA UÑA',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: ['All', 'Almond', 'Square', 'Stiletto'].map((shape) {
                final isSelected = _selectedShape == shape;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedShape = shape),
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        gradient: isSelected
                            ? const LinearGradient(
                                colors: [Color(0xFFFF416C), Color(0xFF8A2387)],
                              )
                            : null,
                        color: isSelected ? null : const Color(0xFF16122C),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFF25113A)),
                      ),
                      child: Center(
                        child: Text(
                          shape,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isSelected ? Colors.white : Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 35),

            // Historial de Búsquedas Recientes abajo
            if (_searchHistory.isNotEmpty) ...[
              const Text(
                'BÚSQUEDAS RECIENTES',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 10),
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
            ],
          ],
        ),
      ),
    );
  }
}

// ==========================================
// 3. PANTALLA DE SUBIR CONTENIDO (CON GALERÍA ACTIVA)
// ==========================================
class UploadScreen extends StatefulWidget {
  const UploadScreen({super.key});

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  final _titleController = TextEditingController();
  String _selectedLength = 'Medium';
  String _selectedShape = 'Almond';
  bool _isSharedInCommunity = true;

  // Variables para gestionar la imagen seleccionada de la galería
  final ImagePicker _picker = ImagePicker();
  XFile? _pickedFile;

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  // Función asíncrona que conecta con la galería o explorador de archivos
  Future<void> _pickImageFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85, // Optimiza el peso de la imagen de forma automática
      );
      if (image != null) {
        setState(() {
          _pickedFile = image;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al acceder a la galería: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _simulateUpload() {
    if (_pickedFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Por favor, selecciona una foto de tu manicura primero 📷',
          ),
          backgroundColor: Colors.amber,
        ),
      );
      return;
    }
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, escribe un título para tu diseño ✨'),
          backgroundColor: Colors.amber,
        ),
      );
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('¡Tu diseño se ha subido con éxito! 💅🚀'),
        backgroundColor: Color(0xFFFF416C),
      ),
    );
    setState(() {
      _titleController.clear();
      _selectedLength = 'Medium';
      _selectedShape = 'Almond';
      _pickedFile = null; // Resetea la imagen tras el éxito
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Comparte tu Nail Art 📷',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            const Text(
              'Inspira a la comunidad subiendo tus creaciones.',
              style: TextStyle(color: Colors.grey, fontSize: 13),
            ),
            const SizedBox(height: 25),

            // CONTENEDOR INTERACTIVO DE FOTO DE MANICURA
            GestureDetector(
              onTap: _pickedFile == null ? _pickImageFromGallery : null,
              child: Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  color: const Color(0xFF16122C),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFF25113A)),
                ),
                clipBehavior: Clip.antiAlias,
                child: _pickedFile == null
                    ? const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add_photo_alternate_outlined,
                            color: Color(0xFFFF416C),
                            size: 40,
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Seleccionar foto de manicura',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Abre tu galería o archivos',
                            style: TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                        ],
                      )
                    : Stack(
                        fit: StackFit.expand,
                        children: [
                          // Renderizado multiplataforma (Web y Móvil) de la foto cargada
                          Image.network(_pickedFile!.path, fit: BoxFit.cover),
                          // Capa oscura superior decorativa
                          Container(color: Colors.black.withOpacity(0.4)),
                          // Botón flotante para cambiar o eliminar la foto seleccionada
                          Positioned(
                            top: 12,
                            right: 12,
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Colors.black54,
                                shape: BoxShape.circle,
                              ),
                              child: IconButton(
                                icon: const Icon(
                                  Icons.delete_outline,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _pickedFile =
                                        null; // Borra la foto de la memoria
                                  });
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
              ),
            ),
            const SizedBox(height: 25),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Título del Diseño',
                labelStyle: const TextStyle(color: Colors.grey),
                filled: true,
                fillColor: const Color(0xFF16122C),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: const BorderSide(color: Color(0xFF25113A)),
                ),
              ),
            ),
            const SizedBox(height: 25),
            const Text(
              'LONGITUD DE LA UÑA',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: Color(0xFF8E8A9F),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: ['Short', 'Medium', 'Long'].map((length) {
                final isSelected = _selectedLength == length;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedLength = length),
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        gradient: isSelected
                            ? const LinearGradient(
                                colors: [Color(0xFFFF416C), Color(0xFF8A2387)],
                              )
                            : null,
                        color: isSelected ? null : const Color(0xFF16122C),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFF25113A)),
                      ),
                      child: Center(
                        child: Text(
                          length,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isSelected ? Colors.white : Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 25),
            const Text(
              'FORMA DE LA UÑA',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: Color(0xFF8E8A9F),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: ['Almond', 'Square', 'Stiletto'].map((shape) {
                final isSelected = _selectedShape == shape;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedShape = shape),
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        gradient: isSelected
                            ? const LinearGradient(
                                colors: [Color(0xFFFF416C), Color(0xFF8A2387)],
                              )
                            : null,
                        color: isSelected ? null : const Color(0xFF16122C),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFF25113A)),
                      ),
                      child: Center(
                        child: Text(
                          shape,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isSelected ? Colors.white : Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 25),
            SwitchListTile(
              title: const Text(
                'Compartir en el Feed público',
                style: TextStyle(fontSize: 14),
              ),
              value: _isSharedInCommunity,
              activeColor: const Color(0xFFFF416C),
              contentPadding: EdgeInsets.zero,
              onChanged: (bool value) =>
                  setState(() => _isSharedInCommunity = value),
            ),
            const SizedBox(height: 25),
            Container(
              width: double.infinity,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                gradient: const LinearGradient(
                  colors: [Color(0xFFFF416C), Color(0xFF8A2387)],
                ),
              ),
              child: ElevatedButton(
                onPressed: _simulateUpload,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                ),
                child: const Text(
                  'PUBLICAR DISEÑO ✨',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
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

// ==========================================
// COMPONENTE TARJETA DE NAIL ART INTERACTIVA
// ==========================================
class NailDesignCard extends StatefulWidget {
  final Map<String, dynamic> design;
  final double cardHeight;

  const NailDesignCard({
    super.key,
    required this.design,
    required this.cardHeight,
  });

  @override
  State<NailDesignCard> createState() => _NailDesignCardState();
}

class _NailDesignCardState extends State<NailDesignCard> {
  bool _isLiked = false; // Memoria: ¿La usuaria le dio like?
  late int _likeCount; // Memoria: Cuenta actual de corazones

  @override
  void initState() {
    super.initState();
    // Inicializamos el contador con el valor que viene de los datos
    _likeCount = widget.design['likes'];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.cardHeight,
      decoration: BoxDecoration(
        color: const Color(0xFF16122C),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF25113A)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // 1. Imagen del diseño de uñas
          Positioned.fill(
            child: Image.network(widget.design['url']!, fit: BoxFit.cover),
          ),

          // 2. Degradado inferior protector de texto
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

          // 3. Botón flotante para Guardar en la Agenda
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

          // 4. Panel de Información Inferior (Título, Corazón e Interactividad)
          Positioned(
            bottom: 12,
            left: 12,
            right: 12,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.design['title']!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),

                // FILA INTERACTIVA: Corazón táctil y contador dinámico
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        // Cambiamos el estado al recibir el toque
                        setState(() {
                          _isLiked =
                              !_isLiked; // Si era true pasa a false y viceversa
                          if (_isLiked) {
                            _likeCount++; // Suma un corazón real
                          } else {
                            _likeCount--; // Resta el corazón si se arrepiente
                          }
                        });
                      },
                      child: Icon(
                        _isLiked ? Icons.favorite : Icons.favorite_border,
                        // Si tiene like se pinta del rosa encendido de tu logo, si no, se queda gris
                        color: _isLiked
                            ? const Color(0xFFFF416C)
                            : const Color(0xFF8E8A9F),
                        size: 16,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      _likeCount.toString(),
                      style: const TextStyle(
                        color: Color(0xFF8E8A9F),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
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
  }
}
