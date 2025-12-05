import 'package:flutter/material.dart';

import 'package:guaxilist/models/game.dart';
import 'package:guaxilist/models/game_status.dart';

class GameCard extends StatelessWidget {
  final Game game;
  final void Function(GameStatus newStatus)? onStatusChange;
  final void Function()? onDelete;

  const GameCard({
    super.key,
    required this.game,
    this.onStatusChange,
    this.onDelete,
  });

  void _openSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        final maxHeight = MediaQuery.of(ctx).size.height * 0.8;

        return SafeArea(
          bottom: false,
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
                            color: game.status.color,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            game.status.displayName(),
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
                            onTap: () async {
                              final sheetNavigator = Navigator.of(ctx);

                              final bool? delete = await showDialog<bool>(
                                context: ctx,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text("Confirmar exclusão"),
                                    content: Text(
                                      "Você tem certeza que deseja excluir esse registro? Essa ação não pode ser desfeita.",
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(false),
                                        child: Text("Cancelar"),
                                      ),
                                      TextButton(
                                        style: ButtonStyle(
                                          backgroundColor:
                                              WidgetStateProperty.all(
                                                Theme.of(
                                                  context,
                                                ).colorScheme.error,
                                              ),
                                        ),
                                        onPressed: () =>
                                            Navigator.of(context).pop(true),
                                        child: Text(
                                          "Apagar",
                                          style: TextStyle(
                                            color: Theme.of(
                                              context,
                                            ).colorScheme.onError,
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );

                              if (delete == true) {
                                onDelete?.call();
                                sheetNavigator.pop();
                              }
                            },
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
    final navigator = Navigator.of(context);

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
              RadioGroup<GameStatus>(
                groupValue: game.status,
                onChanged: (value) {
                  Navigator.of(ctx).pop(value);
                },
                child: Column(
                  children: [
                    ...GameStatus.values.map((status) {
                      final color = status.color;

                      return RadioListTile<GameStatus>(
                        value: status,
                        title: Text(status.displayName()),
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
        onStatusChange?.call(selectedStatus as GameStatus);

        navigator.pop();
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
                    color: game.status.color,
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
