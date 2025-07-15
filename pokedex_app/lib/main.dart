import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import 'models/pokemonModel.dart';
import 'services/pokemon_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pokédex GEN9',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.red).copyWith(
          secondary: Colors.amberAccent,
        ),
        scaffoldBackgroundColor: Colors.grey[50],
      ),
      home: const PokemonListScreen(),
    );
  }
}

class PokemonListScreen extends StatefulWidget {
  const PokemonListScreen({super.key});

  @override
  State<PokemonListScreen> createState() => _PokemonListScreenState();
}

class _PokemonListScreenState extends State<PokemonListScreen> {
  final PokemonService _pokemonService = PokemonService();
  List<Pokemon> _pokemons = []; // Ahora solo necesitamos una lista
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchPokemons();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _fetchPokemons() async {
    try {
      final pokemons = await _pokemonService.fetchGen8Pokemons();
      setState(() {
        _pokemons = pokemons; // Directamente asignamos a _pokemons
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error al cargar los Pokémon de la 8va generación. Inténtalo de nuevo más tarde.';
        _isLoading = false;
      });
      print('Error: $e'); // Para depuración
    }
  }

  String _capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  final Map<String, Color> _typeColors = {
    'normal': const Color(0xFFA8A77A), 'fire': const Color(0xFFEE8130), 'water': const Color(0xFF6390F0),
    'electric': const Color(0xFFF7D02C), 'grass': const Color(0xFF7AC74C), 'ice': const Color(0xFF96D9D6),
    'fighting': const Color(0xFFC22E28), 'poison': const Color(0xFFA33EA1), 'ground': const Color(0xFFE2BF65),
    'flying': const Color(0xFFA98FF3), 'psychic': const Color(0xFFF95587), 'bug': const Color(0xFFA6B91A),
    'rock': const Color(0xFFB6A136), 'ghost': const Color(0xFF735797), 'dragon': const Color(0xFF6F35FC),
    'steel': const Color(0xFFB7B7CE), 'fairy': const Color(0xFFD685AD), 'dark': const Color(0xFF705746),
  };

  Color _getDominantColor(String pokemonName) {
    final int hash = pokemonName.hashCode;
    final int index = hash % _typeColors.length;
    return _typeColors.values.elementAt(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFDC0A2D), Color(0xFFE94D4C)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(top: 55.0, bottom: 25.0, left: 20.0, right: 20.0),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFB22222), Color(0xFFDC143C)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(40)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black38,
                    blurRadius: 15,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              child:
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 45,
                      height: 45,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        border: Border.all(color: Colors.black, width: 2),
                        boxShadow: const [
                          BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(2, 2)),
                        ],
                      ),
                      child: Center(
                        child: Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.redAccent,
                            border: Border.all(color: Colors.black, width: 1.5),
                            boxShadow: const [
                              BoxShadow(color: Colors.redAccent, blurRadius: 8, spreadRadius: 1),
                            ],
                          ),
                          child: Center(
                            child: Container(
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                                border: Border.all(color: Colors.black, width: 1),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Text(
                      'Pokédex GEN 9',
                      style: GoogleFonts.pressStart2p(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                        shadows: [
                          Shadow(
                            offset: Offset(2, 2),
                            blurRadius: 3.0,
                            color: Colors.black.withOpacity(0.5),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    const Icon(Icons.menu_book, color: Colors.white, size: 30),
                  ],
                ),
            ),
            Expanded(
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        strokeWidth: 5,
                      ),
                    )
                  : _errorMessage != null
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Text(
                              _errorMessage!,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
                            ),
                          ),
                        )
                      : GridView.builder(
                          padding: const EdgeInsets.all(15.0),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 18.0,
                            mainAxisSpacing: 18.0,
                            childAspectRatio: 0.85,
                          ),
                          itemCount: _pokemons.length, // Volvemos a usar _pokemons directamente
                          itemBuilder: (context, index) {
                            final pokemon = _pokemons[index]; // Obtenemos el Pokémon de _pokemons
                            final String displayId = (index + 810).toString().padLeft(3, '0');

                            final Color cardColor = _getDominantColor(pokemon.name);

                            return GestureDetector(
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('¡Tocaste a ${_capitalize(pokemon.name)}!', style: GoogleFonts.poppins()),
                                    backgroundColor: cardColor.darken(0.2),
                                    duration: const Duration(milliseconds: 1200),
                                  ),
                                );
                              },
                              child: Hero(
                                tag: 'pokemon-${pokemon.name}',
                                child: TweenAnimationBuilder<double>(
                                  duration: Duration(milliseconds: 300 + index * 50),
                                  tween: Tween(begin: 0.0, end: 1.0),
                                  builder: (context, value, child) {
                                    return Opacity(
                                      opacity: value,
                                      child: Transform.scale(
                                        scale: 0.8 + (value * 0.2),
                                        child: _buildPokemonCard(pokemon, displayId, cardColor),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPokemonCard(Pokemon pokemon, String displayId, Color cardColor) {
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [cardColor.lighten(0.2), cardColor.darken(0.1)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: cardColor.darken(0.3).withOpacity(0.5),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              bottom: -20,
              right: -20,
              child: Opacity(
                opacity: 0.1,
                child: Image.asset(
                  'assets/pokeball_icon.png',
                  width: 100,
                  height: 100,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Positioned(
              top: 15,
              right: 15,
              child: Text(
                '#$displayId',
                style: GoogleFonts.poppins(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  flex: 3,
                  child: Center(
                    child: CachedNetworkImage(
                      imageUrl: pokemon.imgUrl,
                      placeholder: (context, url) => Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white.withOpacity(0.7)),
                          strokeWidth: 3,
                        ),
                      ),
                      errorWidget: (context, url, error) => const Icon(
                        Icons.error_outline,
                        color: Colors.white,
                        size: 40,
                      ),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.4),
                    borderRadius: const BorderRadius.vertical(bottom: Radius.circular(25)),
                  ),
                  child: Text(
                    _capitalize(pokemon.name),
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          offset: Offset(1, 1),
                          blurRadius: 2.0,
                          color: Colors.black.withOpacity(0.5),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

extension ColorExtension on Color {
  Color darken([double amount = .1]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(this);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
    return hslDark.toColor();
  }

  Color lighten([double amount = .1]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(this);
    final hslLight = hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));
    return hslLight.toColor();
  }
}