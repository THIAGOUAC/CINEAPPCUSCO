// lib/main.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'providers/movies_provider.dart';
import 'models/movie.dart';

void main() {
  runApp(const ProviderScope(child: CineApp()));
}

// ── Raíz de la aplicación ─────────────────────────────────
class CineApp extends StatelessWidget {
  const CineApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CineApp Cusco',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
      ),
      themeMode: ThemeMode.system,
      home: const HomeScreen(),
    );
  }
}

// ── Pantalla principal ────────────────────────────────────
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final TextEditingController _searchCtrl = TextEditingController();

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final moviesAsync = ref.watch(movieListProvider);
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        title: const Text('🎬 CineApp Cusco'),
        backgroundColor: cs.primaryContainer,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.read(movieListProvider.notifier).refresh(),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSearchBar(cs),
          Expanded(
            child: moviesAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) => _buildError(err),
              data: (movies) => _buildLayout(movies, context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(ColorScheme cs) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: TextField(
        controller: _searchCtrl,
        decoration: InputDecoration(
          hintText: 'Buscar película...',
          prefixIcon: const Icon(Icons.search),
          filled: true,
          fillColor: cs.surfaceContainerHighest,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none),
        ),
        onChanged: (v) => ref.read(searchQueryProvider.notifier).update(v),
      ),
    );
  }

  Widget _buildError(Object error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline,
              size: 64, color: Theme.of(context).colorScheme.error),
          const SizedBox(height: 16),
          Text('Error: $error', textAlign: TextAlign.center),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: () => ref.read(movieListProvider.notifier).refresh(),
            icon: const Icon(Icons.refresh),
            label: const Text('Reintentar'),
          ),
        ],
      ),
    );
  }

  Widget _buildLayout(List<Movie> movies, BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // BUG FIX B5:
        // La lógica responsiva estaba invertida.
        // Pantallas grandes (>600) deben usar GridView
        // Pantallas pequeñas deben usar ListView.

        if (constraints.maxWidth > 600) {
          // Pantalla grande → cuadrícula
          return GridView.builder(
            padding: const EdgeInsets.all(8),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.72,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: movies.length,
            itemBuilder: (ctx, i) => MovieCard(movie: movies[i]),
          );
        } else {
          // Pantalla pequeña → lista
          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: movies.length,
            itemBuilder: (ctx, i) => MovieCard(movie: movies[i]),
          );
        }
      },
    );
  }
}

// ── Tarjeta de película ───────────────────────────────────
class MovieCard extends StatelessWidget {
  final Movie movie;
  const MovieCard({super.key, required this.movie});

  String _category(double v) => switch (v) {
        >= 8.0 => '⭐⭐⭐ Obra Maestra',
        >= 6.0 => '⭐⭐  Recomendada',
        >= 4.0 => '⭐   Pasable',
        _ => '💀  Evítala',
      };

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final overview = movie.overview.length > 80
        ? '${movie.overview.substring(0, 80)}...'
        : movie.overview;

    return Card(
      elevation: 2,
      color: cs.surfaceContainerHighest,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              movie.title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: cs.onSurface,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Text(
              '⭐ ${movie.voteAverage.toStringAsFixed(1)} / 10',
              style: TextStyle(color: cs.primary, fontSize: 13),
            ),
            const SizedBox(height: 4),
            Text(
              _category(movie.voteAverage),
              style: TextStyle(color: cs.secondary, fontSize: 12),
            ),
            const SizedBox(height: 8),
            Text(
              overview,
              style: TextStyle(color: cs.onSurfaceVariant, fontSize: 12),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
