  //-------------------------------------------------------------------------------<
// ----> Clase
class Pokemon {
  //-------------------------------------------------------------------------------<
  // --> Atributos / propiedades de la clase
  final String name;
  final String url;
  final String imgUrl;

  //-------------------------------------------------------------------------------<
  // --> CONSTRUCTOR BASICO
  Pokemon ({
    required this.name,
    required this.url,
    required this.imgUrl
  });

  //-------------------------------------------------------------------------------<
  // CONSTRUCTOR DE FABRICA
  //(Puede devolver una instancia existente,
  // Tambien se usa para proporcionar una forma flexible de crear instancias)
  factory Pokemon.fromJson(Map<String, dynamic> json) {
    final String name = json['name'];
    final String url = json['url'];

    // Extraer el ID del Pokémon de la URL
    // Con los objetos URI se puede trabajar las URL de maneras mas eficientes
    final Uri uri = Uri.parse(url);

    //Segmentos individuales de la ruta URL (les hace como un split)
    final List<String> pathSegments = uri.pathSegments;
  
    // Acceso al segmento donde esta el id
    final String id = pathSegments[pathSegments.length - 2];
    final String imgUrl = 'https://raw.githubusercontent.com/PokeAPI/sprites/pokemon/$id.png';

    return Pokemon(
      name: name,
      url: url,
      imgUrl: imgUrl
    );
  }
}