import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/note_provider.dart';
import '../../providers/theme_provider.dart';
import '../../widgets/empty_state.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NoteProvider>().loadNotes();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final auth = context.watch<AuthProvider>();
    final noteProvider = context.watch<NoteProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: Icon(
                theme.brightness == Brightness.dark
                    ? Icons.light_mode
                    : Icons.dark_mode,
                color: theme.colorScheme.primary),
            onPressed: () {
              context.read<ThemeProvider>().toggle();
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await auth.logout();
              if (context.mounted) {
                Navigator.pushReplacementNamed(context, '/login');
              }
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => noteProvider.loadNotes(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
              child: Text(
                'Halo, ${auth.userName}!',
                style: theme.textTheme.headlineMedium,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                '${noteProvider.notes.length} catatan tersimpan',
                style: theme.textTheme.bodyMedium,
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () =>
                          Navigator.pushNamed(context, '/upload-note'),
                      icon: const Icon(Icons.upload_file, size: 20),
                      label: const Text('Upload Catatan'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  OutlinedButton.icon(
                    onPressed: () =>
                        Navigator.pushNamed(context, '/error-journal'),
                    icon: const Icon(Icons.error_outline, size: 20),
                    label: const Text('Jurnal Salah'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text('Daftar Catatan', style: theme.textTheme.titleLarge),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: noteProvider.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : noteProvider.notes.isEmpty
                      ? EmptyState(
                          icon: Icons.note_add_outlined,
                          title: 'Belum ada catatan',
                          subtitle: 'Upload catatan belajarmu untuk mulai',
                          actionLabel: 'Upload Catatan',
                          onAction: () =>
                              Navigator.pushNamed(context, '/upload-note'),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: noteProvider.notes.length,
                          itemBuilder: (context, index) {
                            final note = noteProvider.notes[index];
                            return Card(
                              margin: const EdgeInsets.symmetric(
                                  vertical: 4, horizontal: 8),
                              child: ListTile(
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                leading: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.primary
                                        .withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(
                                    Icons.description_outlined,
                                    color: theme.colorScheme.primary,
                                  ),
                                ),
                                title: Text(note.title,
                                    style: theme.textTheme.titleMedium),
                                subtitle: Text(
                                  note.createdAt,
                                  style: theme.textTheme.bodyMedium,
                                ),
                                trailing: const Icon(Icons.chevron_right),
                                onTap: () async {
                                  noteProvider.selectNote(note);
                                  await noteProvider
                                      .generateQuestions(note.id);
                                  if (context.mounted) {
                                    Navigator.pushNamed(context, '/quiz',
                                        arguments: note.id);
                                  }
                                },
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}


