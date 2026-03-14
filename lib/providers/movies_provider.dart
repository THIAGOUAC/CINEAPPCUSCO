// lib/providers/movies_provider.dart

import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/movie.dart';
import '../services/movie_service.dart';

part 'movies_provider.g.dart';

// ── Provider de búsqueda (texto que escribe el usuario) ──────
@riverpod
class SearchQuery extends _$SearchQuery {
  @override
  String build() => '';

  void update(String query) => state = query;
}

// ── Provider principal: lista filtrada de películas ──────────
@riverpod
class MovieList extends _$MovieList {
  @override
  Future<List<Movie>> build() async {
    // Obtiene el texto de búsqueda y filtra
    // BUG FIX B4:
// ref.read() solo obtiene el valor una vez y no crea dependencia reactiva.
// Esto impedía que la lista se actualice cuando cambia el texto de búsqueda.
// Se reemplaza por ref.watch() para que el provider escuche cambios
// y reconstruya la lista automáticamente.

    final query = ref.watch(searchQueryProvider);
    final all = await MovieService().fetchMovies();
    if (query.isEmpty) return all;
    return all
        .where((m) => m.title.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  Future<void> refresh() async {
    // BUG FIX B3:
    // En lugar de cargar datos manualmente,
    // se invalida el provider para que build()
    // vuelva a ejecutarse respetando el filtro.

    ref.invalidateSelf();
  }
}
