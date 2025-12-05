import 'package:flutter/material.dart';
import 'dart:io';

import 'package:guaxilist/models/game.dart';
import 'package:guaxilist/models/game_status.dart';
import 'package:guaxilist/widgets/filter_sheet.dart';
import 'package:guaxilist/widgets/game_card.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final List<Game> games = [
    Game(
      id: "1",
      title: 'Elden Ring',
      imageUrl:
          'https://static0.srcdn.com/wordpress/wp-content/uploads/2022/12/elden-ring-cover.jpg',
      tags: ['RPG', 'Soulslike', 'Open World'],
      publishedAt: DateTime(2022, 2, 25),
      status: GameStatus.planToPlay,
      platforms: ['pc', 'ps5', 'xbox series'],
    ),
    Game(
      id: "2",
      title: 'Hades',
      imageUrl:
          'https://cdn1.epicgames.com/min/offer/2560x1440-2560x1440-5e710b93049cbd2125cf0261dcfbf943.jpg',
      tags: ['Roguelike de Ação', 'Roguelike', 'Hack and Slash', 'Indie'],
      publishedAt: DateTime(2020, 9, 17),
      status: GameStatus.finished,
      platforms: ['pc', 'ps5', 'xbox series'],
    ),
    Game(
      id: "3",
      title: 'Metro: Exodus',
      imageUrl: 'https://i.ytimg.com/vi/uoBF-7x69wY/maxresdefault.jpg',
      tags: ['FPS', 'Open World'],
      publishedAt: DateTime(2019, 2, 14),
      status: GameStatus.planToPlay,
      platforms: ['pc', 'ps5', 'ps4', 'xbox series'],
    ),
    Game(
      id: "3",
      title: 'The Walking Dead: The Telltale Definitive Series',
      imageUrl:
          'https://shared.fastly.steamstatic.com/store_item_assets/steam/apps/1449690/a9ccc64b359746f3905e760a73dcff3e2b6ec052/capsule_616x353.jpg?t=1760651835',
      tags: ['Escolhas importam', 'Ficção Interativa', 'Horror'],
      publishedAt: DateTime(2020, 10, 29),
      status: GameStatus.playing,
      platforms: ['pc', 'ps5', 'ps4', 'xbox series'],
    ),
  ];

  List<Game> filteredGames = [];

  List<GameStatus> allStatuses = [];
  List<String> allTags = [];
  List<String> allPlatforms = [];

  Set<GameStatus> selectedStatuses = {};
  Set<String> selectedTags = {};
  Set<String> selectedPlatforms = {};

  @override
  void initState() {
    super.initState();
    filteredGames = List.from(games);
    _searchController.addListener(_applyFilter);

    final statuses = <GameStatus>{};
    final tags = <String>{};
    final platforms = <String>{};

    for (final game in games) {
      statuses.add(game.status);
      tags.addAll(game.tags);
      platforms.addAll(game.platforms);
    }

    allStatuses = statuses.toList();
    allTags = tags.toList();
    allPlatforms = platforms.toList();
  }

  @override
  void dispose() {
    _searchController.removeListener(_applyFilter);
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
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

  void _updateGameStatus(Game game, GameStatus newStatus) {
    final index = games.indexWhere((g) => g.id == game.id);

    if (index == -1) {
      return;
    }

    setState(() {
      games[index] = games[index].copyWith(status: newStatus);

      if (!allStatuses.contains(newStatus)) {
        allStatuses.add(newStatus);
      }

      _applyFilter();
    });
  }

  void _deleteGame(Game game) {
    setState(() {
      games.removeWhere((g) => g.id == game.id);
      _applyFilter();
    });
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
              child: ListView.separated(
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
        onPressed: () => {},
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
