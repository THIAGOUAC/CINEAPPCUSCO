// lib/services/movie_service.dart
// NOTA: La app usa datos locales (sin conexión a internet).
// El servicio simula latencia de red con Future.delayed.

import '../models/movie.dart';

// Catálogo local de películas peruanas
const _catalogo = [
  {
    'id': 1,
    'title': 'Wiñaypacha',
    'overview':
        'Una pareja de ancianos en los Andes espera el regreso de su hijo con fe inquebrantable.',
    'vote_average': 7.8,
    'poster_path': null
  },
  {
    'id': 2,
    'title': 'La Boca del Lobo',
    'overview':
        'Un destacamento militar enfrenta dilemas morales en un pueblo andino durante el conflicto interno.',
    'vote_average': 8.2,
    'poster_path': null
  },
  {
    'id': 3,
    'title': 'Retablo',
    'overview':
        'Un joven aprende el arte del retablo mientras descubre una verdad que sacude su mundo.',
    'vote_average': 7.5,
    'poster_path': null
  },
  {
    'id': 4,
    'title': 'Magallanes',
    'overview':
        'Un ex-soldado busca redención ante una mujer a quien su unidad causó daño décadas atrás.',
    'vote_average': 7.4,
    'poster_path': null
  },
  {
    'id': 5,
    'title': 'Contracorriente',
    'overview':
        'Un pescador casado debe reconciliar su doble vida con las expectativas de su comunidad.',
    'vote_average': 7.6,
    'poster_path': null
  },
  {
    'id': 6,
    'title': 'El Limpiador',
    'overview':
        'Un limpiador de escenas del crimen cuida a un niño huérfano durante una misteriosa epidemia.',
    'vote_average': 7.1,
    'poster_path': null
  },
  {
    'id': 7,
    'title': 'Dióses',
    'overview':
        'La vida de una familia adinerada de Lima se fractura cuando el padre anuncia un nuevo matrimonio.',
    'vote_average': 6.3,
    'poster_path': null
  },
  {
    'id': 8,
    'title': 'Paraíso',
    'overview':
        'Amor adolescente en las lomas de Lima donde dos jóvenes de mundos distintos se encuentran.',
    'vote_average': 6.8,
    'poster_path': null
  },
  {
    'id': 9,
    'title': 'Melina',
    'overview':
        'Una madre lucha por recuperar a su hija en medio de la violencia política de los años 80.',
    'vote_average': 6.9,
    'poster_path': null
  },
  {
    'id': 10,
    'title': 'Todos Somos Estrellas',
    'overview':
        'Un reality en Lima expone las contradicciones del sueño de la fama en televisión peruana.',
    'vote_average': 5.9,
    'poster_path': null
  },
];

class MovieService {
  Future<List<Movie>> fetchMovies() async {
    // Simula latencia de red
    await Future.delayed(const Duration(milliseconds: 800));

    const int mockStatusCode = 200;

    // BUG FIX B2:
    // La condición estaba invertida.
    // El código lanzaba un error cuando el status HTTP era 200.
    // En HTTP, 200 significa éxito, por lo que la excepción
    // solo debe lanzarse cuando el código sea diferente de 200.

    if (mockStatusCode != 200) {
      throw Exception('Error en la red: $mockStatusCode');
    }

    return _catalogo
        .map((m) => Movie.fromJson(Map<String, dynamic>.from(m)))
        .toList();
  }
}
