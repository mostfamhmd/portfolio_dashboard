import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/portfolio_provider.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_button.dart';
import '../widgets/gradient_card.dart';
import '../models/experience.dart';

class ExperienceScreen extends StatefulWidget {
  const ExperienceScreen({super.key});

  @override
  State<ExperienceScreen> createState() => _ExperienceScreenState();
}

class _ExperienceScreenState extends State<ExperienceScreen> {
  void _showAddEditDialog({Experience? experience}) {
    showDialog(
      context: context,
      builder: (context) => _ExperienceDialog(experience: experience),
    );
  }

  Future<void> _deleteExperience(String id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Experience'),
        content: const Text('Are you sure you want to delete this experience?'),
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
      await context.read<PortfolioProvider>().deleteExperience(id);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Experience deleted')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PortfolioProvider>();
    final experiences = provider.experiences;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Experience'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddEditDialog(),
        icon: const Icon(Icons.add),
        label: const Text('Add Experience'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: experiences.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.work_history_outlined, size: 64),
                      const SizedBox(height: 16),
                      const Text('No experience yet'),
                      const SizedBox(height: 8),
                      const Text('Add your work or education history'),
                    ],
                  ),
                )
              : Column(
                  children: experiences.map((exp) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        exp.title,
                                        style: Theme.of(
                                          context,
                                        ).textTheme.titleLarge,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        exp.organization,
                                        style: Theme.of(
                                          context,
                                        ).textTheme.titleMedium,
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        '${DateFormat('MMM yyyy').format(exp.startDate)} - ${exp.isCurrent ? 'Present' : DateFormat('MMM yyyy').format(exp.endDate!)}',
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
                                          _showAddEditDialog(experience: exp),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete),
                                      onPressed: () =>
                                          _deleteExperience(exp.id),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              exp.description,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
        ),
      ),
    );
  }
}

class _ExperienceDialog extends StatefulWidget {
  final Experience? experience;

  const _ExperienceDialog({this.experience});

  @override
  State<_ExperienceDialog> createState() => _ExperienceDialogState();
}

class _ExperienceDialogState extends State<_ExperienceDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _organizationController;
  late TextEditingController _descriptionController;
  late TextEditingController _locationController;
  DateTime? _startDate;
  DateTime? _endDate;
  bool _isCurrent = false;
  String _type = 'work';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(
      text: widget.experience?.title ?? '',
    );
    _organizationController = TextEditingController(
      text: widget.experience?.organization ?? '',
    );
    _descriptionController = TextEditingController(
      text: widget.experience?.description ?? '',
    );
    _locationController = TextEditingController(
      text: widget.experience?.location ?? '',
    );
    _startDate = widget.experience?.startDate;
    _endDate = widget.experience?.endDate;
    _isCurrent = widget.experience?.isCurrent ?? false;
    _type = widget.experience?.type ?? 'work';
  }

  @override
  void dispose() {
    _titleController.dispose();
    _organizationController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(bool isStart) async {
    final date = await showDatePicker(
      context: context,
      initialDate: (isStart ? _startDate : _endDate) ?? DateTime.now(),
      firstDate: DateTime(1990),
      lastDate: DateTime(2100),
    );

    if (date != null) {
      setState(() {
        if (isStart) {
          _startDate = date;
        } else {
          _endDate = date;
        }
      });
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (_startDate == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please select start date')));
      return;
    }
    if (!_isCurrent && _endDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select end date or mark as current'),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    final provider = context.read<PortfolioProvider>();
    final experience = Experience(
      id:
          widget.experience?.id ??
          DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleController.text.trim(),
      organization: _organizationController.text.trim(),
      description: _descriptionController.text.trim(),
      location: _locationController.text.trim(),
      startDate: _startDate!,
      endDate: _isCurrent ? null : _endDate,
      type: _type,
    );

    if (widget.experience == null) {
      await provider.addExperience(experience);
    } else {
      await provider.updateExperience(experience);
    }

    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Experience ${widget.experience == null ? 'added' : 'updated'}!',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        widget.experience == null ? 'Add Experience' : 'Edit Experience',
      ),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: SizedBox(
            width: 500,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  value: _type,
                  decoration: const InputDecoration(labelText: 'Type'),
                  items: const [
                    DropdownMenuItem(value: 'work', child: Text('Work')),
                    DropdownMenuItem(
                      value: 'education',
                      child: Text('Education'),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() => _type = value!);
                  },
                ),
                const SizedBox(height: 16),

                CustomTextField(
                  label: 'Title',
                  hint: 'e.g., Software Engineer',
                  controller: _titleController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter title';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                CustomTextField(
                  label: 'Organization',
                  hint: 'Company or School',
                  controller: _organizationController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter organization';
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
                  label: 'Location',
                  controller: _locationController,
                ),
                const SizedBox(height: 16),

                ListTile(
                  title: Text(
                    _startDate == null
                        ? 'Start Date'
                        : 'Start Date: ${DateFormat('MMM yyyy').format(_startDate!)}',
                  ),
                  trailing: const Icon(Icons.calendar_today),
                  onTap: () => _selectDate(true),
                ),

                CheckboxListTile(
                  title: const Text('Currently working/studying here'),
                  value: _isCurrent,
                  onChanged: (value) {
                    setState(() => _isCurrent = value ?? false);
                  },
                ),

                if (!_isCurrent)
                  ListTile(
                    title: Text(
                      _endDate == null
                          ? 'End Date'
                          : 'End Date: ${DateFormat('MMM yyyy').format(_endDate!)}',
                    ),
                    trailing: const Icon(Icons.calendar_today),
                    onTap: () => _selectDate(false),
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
