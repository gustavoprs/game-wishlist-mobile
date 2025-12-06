import 'dart:math';

import 'package:flutter/material.dart';
import 'package:guaxilist/models/game.dart';
import 'package:guaxilist/models/game_status.dart';

class AddGame extends StatefulWidget {
  const AddGame({super.key});

  @override
  State<AddGame> createState() => _AddGameState();
}

class _AddGameState extends State<AddGame> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController imageUrlController;
  late TextEditingController titleController;
  late TextEditingController newTagController;
  late TextEditingController newPlatformController;

  late DateTime? publishedAt;

  List<String> tags = [];
  List<String> platforms = [];

  GameStatus selectedStatus = GameStatus.planToPlay;

  @override
  void initState() {
    super.initState();

    imageUrlController = TextEditingController();
    titleController = TextEditingController();
    newTagController = TextEditingController();
    newPlatformController = TextEditingController();

    selectedStatus = GameStatus.planToPlay;

    publishedAt = null;
  }

  @override
  void dispose() {
    imageUrlController.dispose();
    titleController.dispose();
    newTagController.dispose();
    newPlatformController.dispose();
    super.dispose();
  }

  void _saveAndReturn() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (tags.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Adicione pelo menos um gênero")));
      return;
    }

    final now = DateTime.now();
    final random = Random();

    final timestamp = now.microsecondsSinceEpoch;

    final randomNumber = random.nextInt(999999);

    final newGame = Game(
      id: '$timestamp-${randomNumber.toString().padLeft(6, '0')}',
      title: titleController.text.trim(),
      imageUrl: imageUrlController.text.trim().isEmpty
          ? null
          : imageUrlController.text.trim(),
      tags: List.from(tags),
      publishedAt: publishedAt,
      status: selectedStatus,
      platforms: List.from(platforms),
    );

    Navigator.of(context).pop(newGame);
  }

  Future<void> pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: publishedAt,
      firstDate: DateTime(1970),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() => publishedAt = picked);
    }
  }

  void addTag() {
    final text = newTagController.text.trim();
    if (text.isNotEmpty && !tags.contains(text)) {
      setState(() => tags.add(text));
      newTagController.clear();
    }
  }

  void addPlatform() {
    final text = newPlatformController.text.trim();
    if (text.isNotEmpty && !platforms.contains(text)) {
      setState(() => platforms.add(text));
      newPlatformController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Adicionar"),
        actions: [
          Row(
            children: [
              FilledButton.icon(
                onPressed: _saveAndReturn,
                icon: Icon(Icons.save, size: 20),
                label: Text("Salvar"),
                style: FilledButton.styleFrom(
                  minimumSize: Size(0, 24),
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
              ),
              SizedBox(width: 8),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(16, 8, 16, 32),
        child: Form(
          key: _formKey,
          child: Column(
            spacing: 32,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                spacing: 16,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      imageUrlController.text,
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;

                        return Center(child: CircularProgressIndicator());
                      },
                      errorBuilder: (_, _, _) => Container(
                        width: double.infinity,
                        height: 200,
                        color: theme.colorScheme.surfaceContainer,
                        child: Icon(
                          Icons.broken_image,
                          size: 60,
                          color: theme.colorScheme.surfaceContainerHighest,
                        ),
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 4,
                    children: [
                      Text("Link da foto:"),
                      TextFormField(
                        controller: imageUrlController,
                        onChanged: (_) => setState(() {}),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return null;
                          }

                          final url = value.trim();
                          final isValid =
                              Uri.tryParse(url)?.hasAbsolutePath ?? false;

                          if (!isValid) {
                            return "URL inválida";
                          }

                          return null;
                        },
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                spacing: 4,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Título*:"),
                  TextFormField(
                    controller: titleController,
                    onChanged: (_) => setState(() {}),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "O título não pode ficar vazio";
                      }

                      return null;
                    },
                  ),
                ],
              ),
              Column(
                spacing: 4,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Status*:"),
                  DropdownButtonFormField<GameStatus>(
                    initialValue: selectedStatus,
                    items: GameStatus.values
                        .map(
                          (s) => DropdownMenuItem(
                            value: s,
                            child: Text(s.displayName()),
                          ),
                        )
                        .toList(),
                    onChanged: (v) => setState(() => selectedStatus = v!),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 4,
                children: [
                  Text("Genêros*:"),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 8,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: newTagController,
                              decoration: InputDecoration(
                                hintText: "Adicionar gênero",
                              ),
                              onSubmitted: (_) => addTag(),
                            ),
                          ),
                          IconButton.outlined(
                            onPressed: addTag,
                            icon: Icon(Icons.add),
                          ),
                        ],
                      ),
                      Wrap(
                        spacing: 4,
                        children: tags
                            .map(
                              (tag) => Chip(
                                label: Text(tag),
                                deleteIcon: Icon(Icons.close),
                                onDeleted: () =>
                                    setState(() => tags.remove(tag)),
                              ),
                            )
                            .toList(),
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 8,
                children: [
                  Text("Data de publicação:"),
                  InkWell(
                    onTap: pickDate,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: 12,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: theme.colorScheme.outline),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            publishedAt != null
                                ? "${publishedAt!.day}/${publishedAt!.month}/${publishedAt!.year}"
                                : "Selecione uma data",
                          ),
                          Icon(Icons.calendar_today),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 4,
                children: [
                  Text("Plataformas:"),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 8,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: newPlatformController,
                              decoration: InputDecoration(
                                hintText: "Adicionar plataforma",
                              ),
                              onSubmitted: (_) => addPlatform(),
                            ),
                          ),
                          IconButton.outlined(
                            onPressed: addPlatform,
                            icon: Icon(Icons.add),
                          ),
                        ],
                      ),
                      Wrap(
                        spacing: 4,
                        children: platforms
                            .map(
                              (platform) => Chip(
                                label: Text(platform.toUpperCase()),
                                deleteIcon: Icon(Icons.close),
                                onDeleted: () => setState(
                                  () =>
                                      platforms.remove(platform.toLowerCase()),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
