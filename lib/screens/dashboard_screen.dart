import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/portfolio_provider.dart';
import '../widgets/gradient_card.dart';
import '../theme/app_colors.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PortfolioProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Portfolio Dashboard',
                style: Theme.of(context).textTheme.displaySmall,
              ),
              const SizedBox(height: 8),
              Text(
                'Manage your portfolio content',
                style: Theme.of(context).textTheme.bodyLarge,
              ),

              const SizedBox(height: 32),

              // Statistics
              Wrap(
                spacing: 16,
                runSpacing: 16,
                children: [
                  _StatCard(
                    title: 'Projects',
                    value: provider.projects.length.toString(),
                    icon: Icons.work_outline,
                    gradient: AppColors.primaryGradient,
                  ),
                  _StatCard(
                    title: 'Skills',
                    value: provider.skills.length.toString(),
                    icon: Icons.stars_outlined,
                    gradient: AppColors.secondaryGradient,
                  ),
                  _StatCard(
                    title: 'Experiences',
                    value: provider.experiences.length.toString(),
                    icon: Icons.business_center_outlined,
                    gradient: AppColors.accentGradient,
                  ),
                  _StatCard(
                    title: 'Social Links',
                    value: provider.socialLinks.length.toString(),
                    icon: Icons.link,
                    gradient: AppColors.successGradient,
                  ),
                ],
              ),

              const SizedBox(height: 48),

              // Management Cards
              Text(
                'Manage Content',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 24),

              Wrap(
                spacing: 24,
                runSpacing: 24,
                children: [
                  _ManagementCard(
                    title: 'Personal Info',
                    description: 'Update your name, bio, and contact details',
                    icon: Icons.person_outline,
                    onTap: () => context.go('/personal-info'),
                  ),
                  _ManagementCard(
                    title: 'Skills',
                    description: 'Add and manage your skills',
                    icon: Icons.psychology_outlined,
                    onTap: () => context.go('/skills'),
                  ),
                  _ManagementCard(
                    title: 'Projects',
                    description: 'Showcase your work and projects',
                    icon: Icons.folder_outlined,
                    onTap: () => context.go('/projects'),
                  ),
                  _ManagementCard(
                    title: 'Experience',
                    description: 'Add work and education history',
                    icon: Icons.work_history_outlined,
                    onTap: () => context.go('/experience'),
                  ),
                  _ManagementCard(
                    title: 'Social Links',
                    description: 'Connect your social media profiles',
                    icon: Icons.share_outlined,
                    onTap: () => context.go('/social-links'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final LinearGradient gradient;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.white, size: 32),
          const SizedBox(height: 16),
          Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.displaySmall?.copyWith(color: Colors.white),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
        ],
      ),
    );
  }
}

class _ManagementCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final VoidCallback onTap;

  const _ManagementCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 350,
      child: GradientCard(
        hasGlassEffect: false,
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: Colors.white, size: 28),
            ),
            const SizedBox(height: 16),
            Text(title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(description, style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: const [Icon(Icons.arrow_forward, size: 20)],
            ),
          ],
        ),
      ),
    );
  }
}
