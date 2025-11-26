import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/portfolio_provider.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_button.dart';
import '../widgets/gradient_card.dart';
import '../models/skill.dart';

class SkillsScreen extends StatefulWidget {
  const SkillsScreen({super.key});

  @override
  State<SkillsScreen> createState() => _SkillsScreenState();
}

class _SkillsScreenState extends State<SkillsScreen> {
  void _showAddEditDialog({Skill? skill}) {
    showDialog(
      context: context,
      builder: (context) => _SkillDialog(skill: skill),
    );
  }

  Future<void> _deleteSkill(String id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Skill'),
        content: const Text('Are you sure you want to delete this skill?'),
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
      await context.read<PortfolioProvider>().deleteSkill(id);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Skill deleted')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PortfolioProvider>();
    final skills = provider.skills;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Skills'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddEditDialog(),
        icon: const Icon(Icons.add),
        label: const Text('Add Skill'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: skills.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.psychology_outlined, size: 64),
                    const SizedBox(height: 16),
                    const Text('No skills yet'),
                    const SizedBox(height: 8),
                    const Text('Add your first skill to get started'),
                  ],
                ),
              )
            : Wrap(
                spacing: 16,
                runSpacing: 16,
                children: skills.map((skill) {
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
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      skill.name,
                                      style: Theme.of(
                                        context,
                                      ).textTheme.titleLarge,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      skill.category,
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodySmall,
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit),
                                    onPressed: () =>
                                        _showAddEditDialog(skill: skill),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete),
                                    onPressed: () => _deleteSkill(skill.id),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Chip(
                              label: Text(
                                skill.category,
                                style: Theme.of(context).textTheme.labelMedium,
                              ),
                            ),
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

class _SkillDialog extends StatefulWidget {
  final Skill? skill;

  const _SkillDialog({this.skill});

  @override
  State<_SkillDialog> createState() => _SkillDialogState();
}

class _SkillDialogState extends State<_SkillDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late String _category;
  bool _isLoading = false;

  final List<String> _categories = [
    'Mobile Development',
    'Web Development',
    'Backend',
    'Programming Languages',
    'Databases',
    'Tools & Technologies',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.skill?.name ?? '');
    _category = widget.skill?.category ?? _categories[0];
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final provider = context.read<PortfolioProvider>();
    final skill = Skill(
      id: widget.skill?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      name: _nameController.text.trim(),
      category: _category,
    );

    if (widget.skill == null) {
      await provider.addSkill(skill);
    } else {
      await provider.updateSkill(skill);
    }

    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Skill ${widget.skill == null ? 'added' : 'updated'}!'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.skill == null ? 'Add Skill' : 'Edit Skill'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomTextField(
                label: 'Skill Name',
                controller: _nameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter skill name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _category,
                decoration: const InputDecoration(labelText: 'Category'),
                items: _categories.map((cat) {
                  return DropdownMenuItem(value: cat, child: Text(cat));
                }).toList(),
                onChanged: (value) {
                  setState(() => _category = value!);
                },
              ),
            ],
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
