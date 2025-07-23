//-------------------------------------------------------------------------------<
// -----> IMPORTS
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/pokemonModel.dart';

//-------------------------------------------------------------------------------<
// ----> CLASE
class PokemonService {
  // Propiedad de clase privada
  final String _url = 'https://pokeapi.co/api/v2';

  Future<List<Pokemon>> fetchGen8Pokemons() async {
    // --> Obtencion de la url que contiene los pokemons de la 9na generacion
    final response = await http.get(Uri.parse('$_url/generation/9/'));
    
    // ---> Asignacion de los datos de los pokemones
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> pokemonSpecies = data['pokemon_species'];
    
      // --> Asignacion de los datos en si
      List<Pokemon> pokemons = [];
      for (var species in pokemonSpecies) {
        final String name = species['name'];
        final String url = species['url'];
        final Uri uri = Uri.parse(url);
        final List<String> segments = uri.pathSegments;
        final String id = segments[segments.length - 2];
        final String imgUrl = 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/$id.png';

        pokemons.add(Pokemon(
          name: name,
          url: url,
          imgUrl: imgUrl
        ));
      }
      // --> Retorno de los datos
      return pokemons;
    } else {
      throw Exception('ERROR: Fallo al cargar los Pokemons de la 8va generación.\nStatus: ${response.statusCode}');
    }
  }
}
