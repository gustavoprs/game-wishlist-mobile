import 'package:flutter/material.dart';

import 'package:guaxilist/models/game.dart';

class GameCard extends StatelessWidget {
  final Game game;

  const GameCard({super.key, required this.game});

  Color getStatusColor(String status) {
    switch (status) {
      case 'Planejo Jogar':
        return Colors.grey;
      case 'Jogando':
        return Colors.blue;
      case 'Pausado':
        return Colors.yellow;
      case 'Jogado':
        return Colors.green;
      case 'Abandonado':
        return Colors.red;
      default:
        return Colors.white;
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
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
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
                            borderRadius: BorderRadius.circular(99),
                          ),
                        ),
                        SizedBox(height: 16),
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
                          // ListTile(
                          //   leading: Icon(Icons.favorite_border),
                          //   title: Text('Favoritar'),
                          //   onTap: () {},
                          // ),
                          ListTile(
                            leading: Icon(Icons.sync),
                            title: Text('Mudar status'),
                            onTap: () => _selectStatus(context),
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

  void _selectStatus(BuildContext context) {
    final statuses = [
      "Planejo Jogar",
      "Jogando",
      "Pausado",
      "Jogado",
      "Abandonado",
    ];

    String selectedStatus = game.status;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Material(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
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
                        borderRadius: BorderRadius.circular(99),
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      "Selecionar Status",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8),
              RadioGroup(
                groupValue: selectedStatus,
                onChanged: (value) {
                  Navigator.of(ctx).pop(value);
                },
                child: Column(
                  children: [
                    ...statuses.map((status) {
                      final color = getStatusColor(status);

                      return RadioListTile<String>(
                        value: status,
                        title: Text(status),
                        activeColor: color,
                        // fillColor: WidgetStateColor.resolveWith((states) => color),
                      );
                    }),
                  ],
                ),
              ),

              SizedBox(height: 12),
            ],
          ),
        );
      },
    ).then((selectedStatus) {
      if (selectedStatus != null) {
        // TODO: aplicar o novo status no game
        print("Novo status selecionado: $selectedStatus");
      }
    });
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
                bottom: 8,
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 300),
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
