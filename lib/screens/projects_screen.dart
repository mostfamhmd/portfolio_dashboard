import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/portfolio_provider.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_button.dart';
import '../widgets/gradient_card.dart';
import '../models/project.dart';

class ProjectsScreen extends StatefulWidget {
  const ProjectsScreen({super.key});

  @override
  State<ProjectsScreen> createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends State<ProjectsScreen> {
  void _showAddEditDialog({Project? project}) {
    showDialog(
      context: context,
      builder: (context) => _ProjectDialog(project: project),
    );
  }

  Future<void> _deleteProject(String id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Project'),
        content: const Text('Are you sure you want to delete this project?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      await context.read<PortfolioProvider>().deleteProject(id);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Project deleted')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PortfolioProvider>();
    final projects = provider.projects;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Projects'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddEditDialog(),
        icon: const Icon(Icons.add),
        label: const Text('Add Project'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: projects.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.folder_outlined, size: 64),
                    const SizedBox(height: 16),
                    const Text('No projects yet'),
                    const SizedBox(height: 8),
                    const Text(
                      'Add your first project to showcase your work',
                    ),
                  ],
                ),
              )
            : Wrap(
                spacing: 16,
                runSpacing: 16,
                children: projects.map((project) {
                  return SizedBox(
                    width: 350,
                    child: GradientCard(
                      hasGlassEffect: false,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  project.title,
                                  style: Theme.of(
                                    context,
                                  ).textTheme.titleLarge,
                                ),
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit),
                                    onPressed: () =>
                                        _showAddEditDialog(project: project),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete),
                                    onPressed: () => _deleteProject(project.id),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            project.description,
                            style: Theme.of(context).textTheme.bodyMedium,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 8,
                            children: project.technologies.map((tech) {
                              return Chip(label: Text(tech));
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
      ),
    );
  }
}

class _ProjectDialog extends StatefulWidget {
  final Project? project;

  const _ProjectDialog({this.project});

  @override
  State<_ProjectDialog> createState() => _ProjectDialogState();
}

class _ProjectDialogState extends State<_ProjectDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _imageUrlController;
  late TextEditingController _technologiesController;
  late TextEditingController _playStoreUrlController;
  late TextEditingController _appStoreUrlController;
  late TextEditingController _githubUrlController;
  bool _isFeatured = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.project?.title ?? '');
    _descriptionController = TextEditingController(
      text: widget.project?.description ?? '',
    );
    _imageUrlController = TextEditingController(
      text: widget.project?.imageUrl ?? '',
    );
    _technologiesController = TextEditingController(
      text: widget.project?.technologies.join(', ') ?? '',
    );
    _playStoreUrlController = TextEditingController(
      text: widget.project?.playStoreUrl ?? '',
    );
    _appStoreUrlController = TextEditingController(
      text: widget.project?.appStoreUrl ?? '',
    );
    _githubUrlController = TextEditingController(
      text: widget.project?.githubUrl ?? '',
    );
    _isFeatured = widget.project?.isFeatured ?? false;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _imageUrlController.dispose();
    _technologiesController.dispose();
    _playStoreUrlController.dispose();
    _appStoreUrlController.dispose();
    _githubUrlController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final provider = context.read<PortfolioProvider>();
    final technologies = _technologiesController.text
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    final project = Project(
      id: widget.project?.id ??
          DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      imageUrl: _imageUrlController.text.trim(),
      technologies: technologies,
      playStoreUrl: _playStoreUrlController.text.trim(),
      appStoreUrl: _appStoreUrlController.text.trim(),
      githubUrl: _githubUrlController.text.trim(),
      isFeatured: _isFeatured,
    );

    if (widget.project == null) {
      await provider.addProject(project);
    } else {
      await provider.updateProject(project);
    }

    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Project ${widget.project == null ? 'added' : 'updated'}!',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.project == null ? 'Add Project' : 'Edit Project'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: SizedBox(
            width: 500,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomTextField(
                  label: 'Project Title',
                  controller: _titleController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter project title';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  label: 'Description',
                  controller: _descriptionController,
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter description';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  label: 'Image URL',
                  controller: _imageUrlController,
                  keyboardType: TextInputType.url,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  label: 'Technologies (comma separated)',
                  hint: 'Flutter, Dart, Firebase',
                  controller: _technologiesController,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  label: 'Play Store URL',
                  controller: _playStoreUrlController,
                  keyboardType: TextInputType.url,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  label: 'App Store URL',
                  controller: _appStoreUrlController,
                  keyboardType: TextInputType.url,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  label: 'GitHub URL',
                  controller: _githubUrlController,
                  keyboardType: TextInputType.url,
                ),
                const SizedBox(height: 16),
                CheckboxListTile(
                  title: const Text('Featured Project'),
                  value: _isFeatured,
                  onChanged: (value) {
                    setState(() => _isFeatured = value ?? false);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        CustomButton(text: 'Save', onPressed: _save, isLoading: _isLoading),
      ],
    );
  }
}
