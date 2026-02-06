import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_constants.dart';
import '../../../providers/playlist_provider.dart';
import '../../../providers/settings_provider.dart';
import '../../../providers/player_provider.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  late final TextEditingController _urlController;

  @override
  void initState() {
    super.initState();
    _urlController = TextEditingController(
      text: ref.read(playlistUrlProvider),
    );
  }

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = ref.watch(darkModeProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Configurações')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Appearance
          Text(
            'Aparência',
            style: TextStyle(
              color: colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Card(
            child: SwitchListTile(
              title: const Text('Modo escuro'),
              subtitle: const Text('Tema escuro para melhor visualização'),
              secondary: Icon(isDark ? Icons.dark_mode : Icons.light_mode),
              value: isDark,
              onChanged: (value) {
                ref.read(darkModeProvider.notifier).state = value;
                ref.read(settingsRepositoryProvider).setDarkMode(value);
              },
            ),
          ),

          const SizedBox(height: 24),

          // Playlist
          Text(
            'Playlist',
            style: TextStyle(
              color: colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _urlController,
                    decoration: const InputDecoration(
                      labelText: 'URL da Playlist M3U',
                      hintText: 'https://...',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.link),
                    ),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      FilledButton.icon(
                        onPressed: _saveUrl,
                        icon: const Icon(Icons.save),
                        label: const Text('Salvar'),
                      ),
                      const SizedBox(width: 8),
                      OutlinedButton.icon(
                        onPressed: _resetUrl,
                        icon: const Icon(Icons.restore),
                        label: const Text('Restaurar padrão'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Data
          Text(
            'Dados',
            style: TextStyle(
              color: colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.refresh),
                  title: const Text('Atualizar playlist'),
                  subtitle: const Text('Baixar novamente a lista de canais'),
                  onTap: () {
                    ref.read(playlistProvider.notifier).refresh();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Atualizando playlist...')),
                    );
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.delete_outline),
                  title: const Text('Limpar histórico'),
                  subtitle: const Text('Remover canais assistidos recentemente'),
                  onTap: () async {
                    await ref.read(historyRepositoryProvider).clearHistory();
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Histórico limpo')),
                    );
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // About
          Text(
            'Sobre',
            style: TextStyle(
              color: colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('IPTV Player v1.0.0'),
              subtitle: const Text(
                'Player IPTV gratuito e open-source',
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _saveUrl() {
    final url = _urlController.text.trim();
    if (url.isNotEmpty) {
      ref.read(playlistUrlProvider.notifier).state = url;
      ref.read(settingsRepositoryProvider).setPlaylistUrl(url);
      ref.read(playlistProvider.notifier).refresh();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('URL salva. Atualizando playlist...')),
      );
    }
  }

  void _resetUrl() {
    _urlController.text = AppConstants.defaultPlaylistUrl;
    _saveUrl();
  }
}
