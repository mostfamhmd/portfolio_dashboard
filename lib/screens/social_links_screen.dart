import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/portfolio_provider.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_button.dart';
import '../widgets/gradient_card.dart';
import '../models/social_link.dart';

class SocialLinksScreen extends StatefulWidget {
  const SocialLinksScreen({super.key});

  @override
  State<SocialLinksScreen> createState() => _SocialLinksScreenState();
}

class _SocialLinksScreenState extends State<SocialLinksScreen> {
  void _showAddEditDialog({SocialLink? link}) {
    showDialog(
      context: context,
      builder: (context) => _SocialLinkDialog(link: link),
    );
  }

  Future<void> _deleteLink(String id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Social Link'),
        content: const Text('Are you sure you want to delete this link?'),
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
      await context.read<PortfolioProvider>().deleteSocialLink(id);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Social link deleted')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PortfolioProvider>();
    final links = provider.socialLinks;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Social Links'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddEditDialog(),
        icon: const Icon(Icons.add),
        label: const Text('Add Link'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: links.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.share_outlined, size: 64),
                      const SizedBox(height: 16),
                      const Text('No social links yet'),
                      const SizedBox(height: 8),
                      const Text('Add your social media profiles'),
                    ],
                  ),
                )
              : Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: links.map((link) {
                    return SizedBox(
                      width: 350,
                      child: GradientCard(
                        hasGlassEffect: false,
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    link.platform,
                                    style: Theme.of(
                                      context,
                                    ).textTheme.titleLarge,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    link.url,
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodySmall,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () =>
                                      _showAddEditDialog(link: link),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () => _deleteLink(link.id),
                                ),
                              ],
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

class _SocialLinkDialog extends StatefulWidget {
  final SocialLink? link;

  const _SocialLinkDialog({this.link});

  @override
  State<_SocialLinkDialog> createState() => _SocialLinkDialogState();
}

class _SocialLinkDialogState extends State<_SocialLinkDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _platformController;
  late TextEditingController _urlController;
  bool _isLoading = false;

  final List<String> _platforms = [
    'GitHub',
    'LinkedIn',
    'Twitter',
    'Facebook',
    'Instagram',
    'Portfolio Website',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    _platformController = TextEditingController(
      text: widget.link?.platform ?? '',
    );
    _urlController = TextEditingController(text: widget.link?.url ?? '');
  }

  @override
  void dispose() {
    _platformController.dispose();
    _urlController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final provider = context.read<PortfolioProvider>();
    final link = SocialLink(
      id: widget.link?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      platform: _platformController.text.trim(),
      url: _urlController.text.trim(),
      iconName: 'link',
    );

    if (widget.link == null) {
      await provider.addSocialLink(link);
    } else {
      await provider.updateSocialLink(link);
    }

    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Social link ${widget.link == null ? 'added' : 'updated'}!',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.link == null ? 'Add Social Link' : 'Edit Social Link'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomTextField(
                label: 'Platform',
                controller: _platformController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter platform name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: _platforms.map((platform) {
                  return ActionChip(
                    label: Text(platform),
                    onPressed: () {
                      _platformController.text = platform;
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),

              CustomTextField(
                label: 'URL',
                controller: _urlController,
                keyboardType: TextInputType.url,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter URL';
                  }
                  if (!value.startsWith('http')) {
                    return 'Please enter a valid URL starting with http:// or https://';
                  }
                  return null;
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
