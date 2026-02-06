import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/channel_group.dart';
import '../../providers/playlist_provider.dart';
import '../../providers/search_provider.dart';

class CategorySidebar extends ConsumerWidget {
  const CategorySidebar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playlistState = ref.watch(playlistProvider);
    final selectedCategory = ref.watch(selectedCategoryProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return playlistState.when(
      data: (data) => _buildList(context, ref, data.groups, selectedCategory, colorScheme),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Erro: $e')),
    );
  }

  Widget _buildList(
    BuildContext context,
    WidgetRef ref,
    List<ChannelGroup> groups,
    String? selectedCategory,
    ColorScheme colorScheme,
  ) {
    final totalChannels =
        groups.fold<int>(0, (sum, g) => sum + g.count);

    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 8),
      children: [
        // "All channels" option
        _CategoryTile(
          icon: Icons.tv,
          label: 'Todos',
          count: totalChannels,
          isSelected: selectedCategory == null,
          colorScheme: colorScheme,
          onTap: () =>
              ref.read(selectedCategoryProvider.notifier).state = null,
        ),
        const Divider(indent: 16, endIndent: 16),
        // Group categories
        for (final group in groups)
          _CategoryTile(
            icon: _iconForGroup(group.name),
            label: group.name,
            count: group.count,
            isSelected: selectedCategory == group.name,
            colorScheme: colorScheme,
            onTap: () => ref.read(selectedCategoryProvider.notifier).state =
                group.name,
          ),
      ],
    );
  }

  static IconData _iconForGroup(String name) {
    final lower = name.toLowerCase();
    if (lower.contains('not\u00edcia') || lower.contains('news')) {
      return Icons.newspaper;
    }
    if (lower.contains('esporte') || lower.contains('sport')) {
      return Icons.sports_soccer;
    }
    if (lower.contains('filme') || lower.contains('movie')) {
      return Icons.movie;
    }
    if (lower.contains('s\u00e9rie')) return Icons.video_library;
    if (lower.contains('anime')) return Icons.animation;
    if (lower.contains('kid') || lower.contains('infantil')) {
      return Icons.child_care;
    }
    if (lower.contains('religi')) return Icons.church;
    if (lower.contains('legisl')) return Icons.account_balance;
    if (lower.contains('m\u00fasic') || lower.contains('music')) {
      return Icons.music_note;
    }
    if (lower.contains('mtv')) return Icons.music_video;
    if (lower.contains('vh1')) return Icons.audiotrack;
    if (lower.contains('entret')) return Icons.theater_comedy;
    if (lower.contains('varied')) return Icons.dashboard;
    if (lower.contains('usa') || lower.contains('uk') || lower.contains('canada')) {
      return Icons.public;
    }
    return Icons.live_tv;
  }
}

class _CategoryTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final int count;
  final bool isSelected;
  final ColorScheme colorScheme;
  final VoidCallback onTap;

  const _CategoryTile({
    required this.icon,
    required this.label,
    required this.count,
    required this.isSelected,
    required this.colorScheme,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 1),
      child: ListTile(
        dense: true,
        leading: Icon(
          icon,
          size: 20,
          color: isSelected ? colorScheme.primary : colorScheme.onSurfaceVariant,
        ),
        title: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected ? colorScheme.primary : colorScheme.onSurface,
          ),
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: isSelected
                ? colorScheme.primaryContainer
                : colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            '$count',
            style: TextStyle(
              fontSize: 11,
              color: isSelected
                  ? colorScheme.onPrimaryContainer
                  : colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        selected: isSelected,
        selectedTileColor: colorScheme.primaryContainer.withValues(alpha: 0.3),
        onTap: onTap,
      ),
    );
  }
}
