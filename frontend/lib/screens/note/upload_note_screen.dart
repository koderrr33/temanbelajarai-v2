import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';
import '../../providers/note_provider.dart';

class UploadNoteScreen extends StatefulWidget {
  const UploadNoteScreen({super.key});

  @override
  State<UploadNoteScreen> createState() => _UploadNoteScreenState();
}

class _UploadNoteScreenState extends State<UploadNoteScreen> {
  final _titleController = TextEditingController();
  File? _selectedFile;
  String? _fileName;

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png', 'webp'],
    );
    if (result != null && result.files.single.path != null) {
      setState(() {
        _selectedFile = File(result.files.single.path!);
        _fileName = result.files.single.name;
      });
    }
  }

  Future<void> _upload() async {
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Judul catatan harus diisi')),
      );
      return;
    }
    if (_selectedFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pilih file terlebih dahulu')),
      );
      return;
    }

    final noteProvider = context.read<NoteProvider>();
    final note = await noteProvider.uploadNote(
      _titleController.text.trim(),
      _selectedFile!,
    );

    if (note != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Catatan berhasil diupload!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context, true);
    } else if (noteProvider.error != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(noteProvider.error!)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final noteProvider = context.watch<NoteProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Upload Catatan')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Upload catatan belajarmu',
              style: theme.textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Format: PDF, JPG, PNG, WEBP (maks 10MB)',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 32),
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Judul Catatan',
                hintText: 'Contoh: Catatan Fisika Bab 1',
                prefixIcon: Icon(Icons.title),
              ),
            ),
            const SizedBox(height: 24),
            InkWell(
              onTap: _pickFile,
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: theme.colorScheme.primary.withOpacity(0.3),
                    width: 2,
                    style: BorderStyle.solid,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  color: theme.colorScheme.primary.withOpacity(0.05),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.cloud_upload_outlined,
                      size: 48,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _fileName ?? 'Tap untuk memilih file',
                      style: theme.textTheme.bodyLarge,
                      textAlign: TextAlign.center,
                    ),
                    if (_fileName == null) ...[
                      const SizedBox(height: 4),
                      Text(
                        'PDF atau foto catatan',
                        style: theme.textTheme.bodyMedium,
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: noteProvider.isLoading ? null : _upload,
              child: noteProvider.isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text('Upload'),
            ),
          ],
        ),
      ),
    );
  }
}
