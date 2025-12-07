import 'package:flutter/material.dart';
import 'dart:io';

import 'package:guaxilist/models/game.dart';
import 'package:guaxilist/models/game_status.dart';
import 'package:guaxilist/screens/add_game.dart';
import 'package:guaxilist/widgets/filter_sheet.dart';
import 'package:guaxilist/widgets/game_card.dart';
import 'package:guaxilist/data/repositories/game_repository.dart';

class MyHomePage extends StatefulWidget {
  final GameRepository gameRepository;

  const MyHomePage({super.key, required this.gameRepository});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  List<Game> games = [];

  List<Game> filteredGames = [];

  List<GameStatus> allStatuses = [];
  List<String> allTags = [];
  List<String> allPlatforms = [];

  Set<GameStatus> selectedStatuses = {};
  Set<String> selectedTags = {};
  Set<String> selectedPlatforms = {};

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_applyFilter);
    _loadGames();
  }

  @override
  void dispose() {
    _searchController.removeListener(_applyFilter);
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadGames() async {
    setState(() {
      isLoading = true;
    });

    final loadedGames = await widget.gameRepository.getAll();

    final statuses = <GameStatus>{};
    final tags = <String>{};
    final platforms = <String>{};

    for (final game in loadedGames) {
      statuses.add(game.status);
      tags.addAll(game.tags);
      platforms.addAll(game.platforms);
    }

    setState(() {
      games = loadedGames;
      filteredGames = List.from(loadedGames);

      allStatuses = statuses.toList();
      allTags = tags.toList();
      allPlatforms = platforms.toList();

      isLoading = false;
    });
  }

  void _applyFilter() {
    final query = _searchController.text.trim().toLowerCase();

    setState(() {
      filteredGames = games.where((game) {
        final matchesText =
            query.isEmpty || game.title.toLowerCase().contains(query);

        final matchesStatus =
            selectedStatuses.isEmpty || selectedStatuses.contains(game.status);

        final matchesTags =
            selectedTags.isEmpty ||
            game.tags.any((tag) => selectedTags.contains(tag));

        final matchesPlatforms =
            selectedPlatforms.isEmpty ||
            game.platforms.any((plat) => selectedPlatforms.contains(plat));

        return matchesText && matchesStatus && matchesTags && matchesPlatforms;
      }).toList();
    });
  }

  Future<void> _openFilterSheet() async {
    // import: import 'package:guaxilist/widgets/filter_sheet.dart';
    final result = await showModalBottomSheet<FilterResult>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return FilterSheet(
          initialStatuses: selectedStatuses,
          initialTags: selectedTags,
          initialPlatforms: selectedPlatforms,
          possibleStatuses: allStatuses,
          possibleTags: allTags,
          possiblePlatforms: allPlatforms,
          onChanged: (result) {
            setState(() {
              selectedStatuses = result.statuses;
              selectedTags = result.tags;
              selectedPlatforms = result.platforms;
            });
            _applyFilter();
          },
        );
      },
    );

    if (result != null) {
      setState(() {
        selectedStatuses = result.statuses;
        selectedTags = result.tags;
        selectedPlatforms = result.platforms;
      });

      // reaplica filtro imediatamente
      _applyFilter();
    }
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  Future<void> _addGame(Game game) async {
    await widget.gameRepository.insert(game);
    await _loadGames();
  }

  Future<void> _updateGameStatus(Game game, GameStatus newStatus) async {
    final index = games.indexWhere((g) => g.id == game.id);
    if (index == -1) {
      return;
    }

    final updated = games[index].copyWith(status: newStatus);

    await widget.gameRepository.update(updated);

    setState(() {
      games[index] = updated;
      _applyFilter();
    });
  }

  Future<void> _updateGame(Game updated) async {
    await widget.gameRepository.update(updated);

    setState(() {
      final i1 = games.indexWhere((g) => g.id == updated.id);
      if (i1 != -1) games[i1] = updated;

      final i2 = filteredGames.indexWhere((g) => g.id == updated.id);
      if (i2 != -1) filteredGames[i2] = updated;
    });
  }

  Future<void> _deleteGame(Game game) async {
    await widget.gameRepository.delete(game.id);
    await _loadGames();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Icon(
              Icons.image,
              size: 32,
              color: Theme.of(context).colorScheme.primary,
            ),
            SizedBox(width: 4),
            Text("GuaxiList"),
          ],
        ),
        actions: [DrawerButton()],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          spacing: 12,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                  width: 160,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Theme.of(context).colorScheme.surfaceContainer,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.search,
                        size: 18,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration.collapsed(
                            hintText: 'Pesquisar...',
                            hintStyle: TextStyle(
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurface.withValues(alpha: 0.5),
                            ),
                          ),
                          style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(child: SizedBox(width: 8)),
                FilledButton.icon(
                  onPressed: _openFilterSheet,
                  icon: Icon(Icons.filter_list, size: 18),
                  label: Text("Filtrar", style: TextStyle(fontSize: 14)),
                  style: FilledButton.styleFrom(
                    minimumSize: Size(0, 16),
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    foregroundColor: Theme.of(context).colorScheme.onSecondary,
                  ),
                ),
              ],
            ),
            Expanded(
              child: isLoading
                  ? Center(child: CircularProgressIndicator())
                  : filteredGames.isEmpty
                  ? Padding(
                    padding: EdgeInsetsGeometry.symmetric(vertical: 30),
                    child: Center(
                        child: Column(
                          spacing: 4,
                          children: [
                            Text(
                              'Nenhum jogo encontrado.',
                              style: TextStyle(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurface.withAlpha(100),
                              ),
                            ),
                            Text(
                              'Clique no botão abaixo para cadastrar.',
                              style: TextStyle(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurface.withAlpha(100),
                              ),
                            ),
                          ],
                        ),
                      ),
                  )
                  : ListView.separated(
                      controller: _scrollController,
                      padding: EdgeInsets.only(bottom: 120),
                      itemCount: filteredGames.length + 1,
                      separatorBuilder: (_, _) => SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        if (index == filteredGames.length) {
                          return Center(
                            child: TextButton.icon(
                              onPressed: _scrollToTop,
                              icon: Icon(Icons.keyboard_arrow_up),
                              label: Text("Ir para o topo"),
                            ),
                          );
                        }

                        return GameCard(
                          game: filteredGames[index],
                          onStatusChange: (newStatus) {
                            _updateGameStatus(filteredGames[index], newStatus);
                          },
                          onUpdate: (game) => _updateGame(game),
                          onDelete: () => _deleteGame(filteredGames[index]),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.primary,
        onPressed: () async {
          final newGame = await Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (_) => AddGame()));

          if (newGame != null) {
            _addGame(newGame);
          }
        },
        child: Icon(
          Icons.add,
          color: Theme.of(context).colorScheme.inversePrimary,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      drawer: Drawer(
        width: MediaQuery.of(context).size.width,
        child: ListView(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      SizedBox(width: 16),
                      Icon(
                        Icons.image,
                        size: 32,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      SizedBox(width: 4),
                      Text("GuaxiList", style: TextStyle(fontSize: 22)),
                    ],
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(Icons.close),
                  ),
                ],
              ),
            ),
            ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
              title: Text("Início"),
              titleTextStyle: TextStyle(fontSize: 20, color: Colors.black),
              onTap: () {
                Navigator.of(
                  context,
                ).pushNamedAndRemoveUntil('/', (_) => false);
              },
            ),
            ListTile(
              title: Text("Sair"),
              titleTextStyle: TextStyle(fontSize: 20, color: Colors.black),
              onTap: () {
                exit(0);
              },
            ),
          ],
        ),
      ),
    );
  }
}
