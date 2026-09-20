import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/journal_providers.dart';
import 'new_entry_screen.dart';
import '../features/lock/application/lock_providers.dart';
import '../features/lock/presentation/pin_setup.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  String formatDate(DateTime date) {
    final now = DateTime.now();
    final isToday = date.year == now.year && date.month == now.month && date.day == now.day;

    final yesterday = now.subtract(const Duration(days: 1));
    final isYesterday =
        date.year == yesterday.year && date.month == yesterday.month && date.day == yesterday.day;

    final hour = date.hour % 12 == 0 ? 12 : date.hour % 12;
    final minute = date.minute.toString().padLeft(2, '0');
    final period = date.hour >= 12 ? 'PM' : 'AM';
    final time = '$hour:$minute $period';

    if (isToday) return 'Today, $time';
    if (isYesterday) return 'Yesterday, $time';
    return '${date.day}/${date.month}/${date.year}, $time';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entriesAsync = ref.watch(filteredEntriesProvider);
    final query = ref.watch(searchQueryProvider);

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          onChanged: (value) =>
              ref.read(searchQueryProvider.notifier).state = value,
          decoration: const InputDecoration(
            hintText: 'Search entries',
            border: InputBorder.none,
          ),
        ),
                actions: [
          IconButton(
            icon: const Icon(Icons.lock_outline),
            tooltip: 'PIN lock',
            onPressed: () =>
                showLockMenu(context, ref.read(pinRepositoryProvider)),
          ),
        ],
      ),
      body: entriesAsync.when(
        data: (entries) {
          if (entries.isEmpty) {
            return Center(
              child: Text(query.isEmpty
                  ? 'No entries yet — tap + to start'
                  : 'No results'),
            );
          }
          return ListView.builder(
            itemCount: entries.length,
            itemBuilder: (context, index) {
              final entry = entries[index];
                return Dismissible(
                  key: ValueKey(entry.id),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: Theme.of(context).colorScheme.errorContainer,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Icon(
                      Icons.delete_outline,
                      color: Theme.of(context).colorScheme.onErrorContainer,
                    ),
                  ),
                  onDismissed: (_) async {
                    final repository = ref.read(journalRepositoryProvider);
                    await repository.deleteEntry(entry.id);

                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('Entry deleted'),
                          action: SnackBarAction(
                            label: 'Undo',
                            onPressed: () => repository.restoreEntry(entry),
                          ),
                        ),
                      );
                    }
                  },
                  child: ListTile(
                    title: Text(
                      entry.content,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(formatDate(entry.createdAt)),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => NewEntryScreen(entry: entry),
                        ),
                      );
                    },
                  ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const NewEntryScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}