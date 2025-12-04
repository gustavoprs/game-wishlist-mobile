import 'package:flutter/material.dart';
import 'dart:io';

import 'package:guaxilist/models/game.dart';

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
      title: 'Elden Ring',
      imageUrl:
          'https://static0.srcdn.com/wordpress/wp-content/uploads/2022/12/elden-ring-cover.jpg',
      tags: ['RPG', 'Soulslike', 'Open World'],
      publishedAt: DateTime(2022, 2, 25),
      status: 'Plan to Play',
      platforms: ['pc', 'ps5', 'xbox'],
    ),
    Game(
      title: 'Hades',
      imageUrl:
          'https://cdn1.epicgames.com/min/offer/2560x1440-2560x1440-5e710b93049cbd2125cf0261dcfbf943.jpg',
      tags: ['Roguelike de Ação', 'Roguelike', 'Hack and Slash', 'Indie'],
      publishedAt: DateTime(2020, 9, 17),
      status: 'Played',
      platforms: ['pc', 'ps5', 'xbox'],
    ),
  ];

  List<Game> filteredGames = [];

  @override
  void initState() {
    super.initState();
    filteredGames = List.from(games);
    _searchController.addListener(_applyFilter);
  }

  void _applyFilter() {
    final query = _searchController.text.trim().toLowerCase();

    setState(() {
      if (query.isEmpty) {
        filteredGames = List.from(games);
        return;
      }

      filteredGames = games.where((game) {
        return game.title.toLowerCase().contains(query);
      }).toList();
    });
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
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
                  onPressed: () {},
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

                  return _GameCard(game: filteredGames[index]);
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

class _GameCard extends StatelessWidget {
  final Game game;

  const _GameCard({required this.game});

  Color getStatusColor(String status) {
    switch (status) {
      case 'Plan to Play':
        return Colors.purple;
      case 'Playing':
        return Colors.blue;
      case 'Paused':
        return Colors.yellow;
      case 'Played':
        return Colors.green;
      case 'Dropped':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  void _openSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        final maxHeight = MediaQuery.of(ctx).size.height * 0.8;

        return SafeArea(
          child: Padding(
            padding: EdgeInsets.only(
              left: 0,
              right: 0,
              bottom: MediaQuery.of(ctx).viewInsets.bottom,
            ),
            child: Material(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 48,
                          height: 4,
                          decoration: BoxDecoration(
                            color: Theme.of(
                              ctx,
                            ).colorScheme.onSurface.withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(1),
                          ),
                        ),
                        SizedBox(height: 12),
                        Text(
                          game.title,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 2),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: getStatusColor(game.status),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            game.status,
                            style: TextStyle(fontSize: 12, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                  ConstrainedBox(
                    constraints: BoxConstraints(maxHeight: maxHeight),
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                            leading: Icon(Icons.visibility),
                            title: Text('Visualizar'),
                            onTap: () => Navigator.of(ctx).pop(),
                          ),
                          ListTile(
                            leading: Icon(Icons.favorite_border),
                            title: Text('Favoritar'),
                            onTap: () {},
                          ),
                          ListTile(
                            leading: Icon(Icons.sync),
                            title: Text('Mudar status'),
                            onTap: () {},
                          ),
                          ListTile(
                            leading: Icon(Icons.edit),
                            title: Text('Editar'),
                            onTap: () {},
                          ),
                          ListTile(
                            leading: Icon(Icons.delete_outline),
                            title: Text('Excluir'),
                            onTap: () {},
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _openSheet(context),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: SizedBox(
          height: 220,
          child: Stack(
            children: [
              Positioned.fill(
                child: Image.network(
                  game.imageUrl,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;

                    return Center(child: CircularProgressIndicator());
                  },
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: Colors.grey[200],
                    child: Center(
                      child: Icon(
                        Icons.broken_image,
                        size: 60,
                        color: Colors.grey[300],
                      ),
                    ),
                  ),
                ),
              ),
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.transparent, Colors.black.withAlpha(100)],
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 12,
                right: 12,
                bottom: 8,
                child: Text(
                  game.title,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    shadows: [Shadow(color: Colors.black, blurRadius: 6)],
                  ),
                ),
              ),
              Positioned(
                right: 12,
                bottom: 12,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: getStatusColor(game.status),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
