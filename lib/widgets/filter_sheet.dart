import 'package:flutter/material.dart';
import 'package:guaxilist/models/game_status.dart';

typedef FilterChanged = void Function(FilterResult result);

class FilterResult {
  final Set<GameStatus> statuses;
  final Set<String> tags;
  final Set<String> platforms;

  FilterResult({
    required this.statuses,
    required this.tags,
    required this.platforms,
  });
}

class FilterSheet extends StatefulWidget {
  final Set<GameStatus> initialStatuses;
  final Set<String> initialTags;
  final Set<String> initialPlatforms;

  final List<GameStatus> possibleStatuses;
  final List<String> possibleTags;
  final List<String> possiblePlatforms;

  final FilterChanged? onChanged;

  const FilterSheet({
    super.key,
    this.initialStatuses = const {},
    this.initialTags = const {},
    this.initialPlatforms = const {},
    this.possibleStatuses = const [],
    this.possibleTags = const [],
    this.possiblePlatforms = const [],
    this.onChanged,
  });

  @override
  State<FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<FilterSheet> {
  late Set<GameStatus> selectedStatuses;
  late Set<String> selectedTags;
  late Set<String> selectedPlatforms;

  @override
  void initState() {
    super.initState();
    selectedStatuses = Set.from(widget.initialStatuses);
    selectedTags = Set.from(widget.initialTags);
    selectedPlatforms = Set.from(widget.initialPlatforms);
  }

  void _toggle<T>(Set<T> set, T value) {
    setState(() {
      if (set.contains(value)) {
        set.remove(value);
      } else {
        set.add(value);
      }
    });

    _notifyChanged();
  }

  void _notifyChanged() {
    if (widget.onChanged == null) return;
    final result = FilterResult(
      statuses: Set.from(selectedStatuses),
      tags: Set.from(selectedTags),
      platforms: Set.from(selectedPlatforms),
    );
    widget.onChanged!(result);
  }

  // void _clearAll() {
  //   setState(() {
  //     selectedStatuses.clear();
  //     selectedTags.clear();
  //     selectedPlatforms.clear();
  //   });
  // }

  // void _applyAndClose() {
  //   final result = FilterResult(
  //     statuses: selectedStatuses,
  //     tags: selectedTags,
  //     platforms: selectedPlatforms,
  //   );
  //   Navigator.of(context).pop(result);
  // }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final statuses = widget.possibleStatuses;
    final tags = widget.possibleTags;
    final platforms = widget.possiblePlatforms;

    return SafeArea(
      left: false,
      right: false,
      bottom: false,
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Material(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 12),
                Center(
                  child: Column(
                    children: [
                      Container(
                        width: 48,
                        height: 4,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.onSurface.withAlpha(100),
                          borderRadius: BorderRadius.circular(99),
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        "Filtros",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 12),
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.6,
                  ),
                  child: SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(16, 16, 16, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (statuses.isNotEmpty) ...[
                          Text(
                            "Status",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: statuses.map((s) {
                              final selected = selectedStatuses.contains(s);
                              return FilterChip(
                                label: Text(s.displayName()),
                                selected: selected,
                                onSelected: (_) => _toggle(selectedStatuses, s),
                                selectedColor: theme.colorScheme.primary
                                    .withAlpha(40),
                                showCheckmark: false,
                              );
                            }).toList(),
                          ),
                          SizedBox(height: 16),
                        ],
                        if (tags.isNotEmpty) ...[
                          Text(
                            "Gêneros",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: tags.map((t) {
                              final selected = selectedTags.contains(t);
                              return FilterChip(
                                label: Text(t),
                                selected: selected,
                                onSelected: (_) => _toggle(selectedTags, t),
                                selectedColor: theme.colorScheme.primary
                                    .withAlpha(40),
                                showCheckmark: false,
                              );
                            }).toList(),
                          ),
                          SizedBox(height: 16),
                        ],
                        if (platforms.isNotEmpty) ...[
                          Text(
                            "Plataformas",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: platforms.map((p) {
                              final selected = selectedPlatforms.contains(p);
                              return FilterChip(
                                label: Text(p.toUpperCase()),
                                selected: selected,
                                onSelected: (_) =>
                                    _toggle(selectedPlatforms, p),
                                selectedColor: theme.colorScheme.primary
                                    .withAlpha(40),
                                showCheckmark: false,
                              );
                            }).toList(),
                          ),
                          SizedBox(height: 16),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
