import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../model/journal_entry.dart';
import '../presenter/journal_presenter.dart';
import 'package:intl/intl.dart'; // untuk format tanggal

class JournalPage extends StatefulWidget {
  const JournalPage({Key? key}) : super(key: key);

  @override
  State<JournalPage> createState() => _JournalPageState();
}

class _JournalPageState extends State<JournalPage> {
  final JournalPresenter _presenter = JournalPresenter();
  final ImagePicker _picker = ImagePicker();

  List<JournalEntry> _entries = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadEntries();
  }

  Future<void> _loadEntries() async {
    final data = await _presenter.loadJournalEntries();
    setState(() {
      _entries = data;
      _loading = false;
    });
  }

  Future<void> _deleteEntry(int id) async {
    await _presenter.deleteJournalEntry(id);
    await _loadEntries();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Journal entry deleted')),
    );
  }

  Future<void> _openForm({JournalEntry? entry}) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => JournalFormPage(entry: entry),
      ),
    );
    if (result == true) {
      _loadEntries();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Journal'),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _entries.isEmpty
              ? const Center(child: Text('No journal entries yet'))
              : ListView.builder(
                  itemCount: _entries.length,
                  itemBuilder: (context, index) {
                    final entry = _entries[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      child: ListTile(
                        leading: entry.imagePath != null
                            ? Image.file(
                                File(entry.imagePath!),
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                              )
                            : null,
                        title: Text(entry.title),
                        subtitle: Text(
                            DateFormat('yyyy-MM-dd').format(DateTime.parse(entry.date))),
                        onTap: () => _openForm(entry: entry),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.redAccent),
                          onPressed: () => _deleteEntry(entry.id!),
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openForm(),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class JournalFormPage extends StatefulWidget {
  final JournalEntry? entry;

  const JournalFormPage({Key? key, this.entry}) : super(key: key);

  @override
  State<JournalFormPage> createState() => _JournalFormPageState();
}

class _JournalFormPageState extends State<JournalFormPage> {
  final _formKey = GlobalKey<FormState>();
  final JournalPresenter _presenter = JournalPresenter();
  final ImagePicker _picker = ImagePicker();

  late TextEditingController _titleController;
  late TextEditingController _contentController;
  String? _imagePath;
  late String _date;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.entry?.title ?? '');
    _contentController = TextEditingController(text: widget.entry?.content ?? '');
    _imagePath = widget.entry?.imagePath;
    _date = widget.entry?.date ?? DateTime.now().toIso8601String();
  }

  Future<void> _pickImage(ImageSource source) async {
    final XFile? picked = await _picker.pickImage(source: source, imageQuality: 80);
    if (picked != null) {
      setState(() {
        _imagePath = picked.path;
      });
    }
  }

  Future<void> _saveEntry() async {
    if (_formKey.currentState?.validate() ?? false) {
      final newEntry = JournalEntry(
        id: widget.entry?.id,
        title: _titleController.text.trim(),
        content: _contentController.text.trim(),
        imagePath: _imagePath,
        date: _date,
      );

      if (widget.entry == null) {
        await _presenter.addJournalEntry(newEntry);
      } else {
        await _presenter.updateJournalEntry(newEntry);
      }

      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.entry == null ? 'Add Journal' : 'Edit Journal'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Title required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _contentController,
                decoration: const InputDecoration(labelText: 'Content'),
                maxLines: 5,
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Content required' : null,
              ),
              const SizedBox(height: 12),
              _imagePath != null
                  ? Image.file(File(_imagePath!), height: 200, fit: BoxFit.cover)
                  : const SizedBox(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton.icon(
                    onPressed: () => _pickImage(ImageSource.camera),
                    icon: const Icon(Icons.camera_alt),
                    label: const Text('Camera'),
                  ),
                  TextButton.icon(
                    onPressed: () => _pickImage(ImageSource.gallery),
                    icon: const Icon(Icons.photo),
                    label: const Text('Gallery'),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _saveEntry,
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
