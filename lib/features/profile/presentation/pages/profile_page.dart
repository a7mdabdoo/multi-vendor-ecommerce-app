import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/theme_cubit.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_event.dart';
import '../../../auth/presentation/bloc/auth_state.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Account & Settings'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // 1. User Profile Header Card
            BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                if (state is AuthenticatedState) {
                  final user = state.user;
                  return Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardTheme.color,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Theme.of(context).colorScheme.outline.withOpacity(0.6),
                      ),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 32,
                          backgroundColor: (isDark ? AppColors.primaryNeon : AppColors.primary).withOpacity(0.15),
                          backgroundImage: user.image != null && user.image!.isNotEmpty
                              ? CachedNetworkImageProvider(user.image!)
                              : null,
                          child: user.image == null || user.image!.isEmpty
                              ? Text(
                                  user.firstName.isNotEmpty ? user.firstName[0].toUpperCase() : 'U',
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: isDark ? AppColors.primaryNeon : AppColors.primary,
                                  ),
                                )
                              : null,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    user.fullName,
                                    style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(width: 4),
                                  const Icon(Icons.verified, size: 16, color: AppColors.accentGold),
                                ],
                              ),
                              const SizedBox(height: 3),
                              Text(
                                user.email,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: isDark ? AppColors.textDarkSecondary : AppColors.textLightSecondary,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Text(
                                  'Premium Buyer',
                                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primary),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }

                // Guest User State
                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardTheme.color,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Theme.of(context).colorScheme.outline.withOpacity(0.6)),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 28,
                            backgroundColor: isDark ? AppColors.darkSurface : Colors.grey[200],
                            child: const Icon(Icons.person_outline_rounded, size: 30),
                          ),
                          const SizedBox(width: 14),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Guest Explorer', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                SizedBox(height: 2),
                                Text('Sign in to track orders & vendor messages', style: TextStyle(fontSize: 12)),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      CustomButton(
                        text: 'Sign In / Register',
                        height: 44,
                        onPressed: () => context.push('/login'),
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 20),

            // 2. Settings & Navigation Tiles
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardTheme.color,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Theme.of(context).colorScheme.outline.withOpacity(0.6),
                ),
              ),
              child: Column(
                children: [
                  // Dark Mode Switch Tile
                  BlocBuilder<ThemeCubit, ThemeMode>(
                    builder: (context, themeMode) {
                      final isCurrentDark = themeMode == ThemeMode.dark;
                      return SwitchListTile(
                        secondary: Icon(
                          isCurrentDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                          color: isCurrentDark ? AppColors.primaryNeon : AppColors.primary,
                        ),
                        title: const Text('Dark Mode', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                        subtitle: Text(
                          isCurrentDark ? 'Obsidian & Neon Palette' : 'Clean Light Palette',
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? AppColors.textDarkMuted : AppColors.textLightMuted,
                          ),
                        ),
                        value: isCurrentDark,
                        activeColor: AppColors.primaryNeon,
                        onChanged: (val) {
                          context.read<ThemeCubit>().toggleTheme();
                        },
                      );
                    },
                  ),
                  const Divider(height: 1),

                  // My Orders Tile
                  ListTile(
                    leading: const Icon(Icons.receipt_long_outlined),
                    title: const Text('Order History', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                    subtitle: const Text('Track multi-vendor packages & receipts', style: TextStyle(fontSize: 12)),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () => context.push('/orders'),
                  ),
                  const Divider(height: 1),

                  // Wishlist Tile
                  ListTile(
                    leading: const Icon(Icons.favorite_border_rounded),
                    title: const Text('Saved Wishlist', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                    subtitle: const Text('Products you saved from stores', style: TextStyle(fontSize: 12)),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () => context.push('/wishlist'),
                  ),
                  const Divider(height: 1),

                  // Verified Stores Directory
                  ListTile(
                    leading: const Icon(Icons.storefront_outlined),
                    title: const Text('Stores & Merchants Directory', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                    subtitle: const Text('Browse all verified brands & boutiques', style: TextStyle(fontSize: 12)),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () => context.push('/vendors'),
                  ),
                  const Divider(height: 1),

                  // Architecture & Portfolio Info
                  ListTile(
                    leading: const Icon(Icons.architecture_rounded),
                    title: const Text('Architecture & Tech Specs', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                    subtitle: const Text('Clean Architecture, BLoC, Dio & Multi-Vendor design', style: TextStyle(fontSize: 12)),
                    trailing: const Icon(Icons.info_outline_rounded),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('Project Architecture'),
                          content: const Text(
                            'Built with strict Feature-First Clean Architecture:\n\n'
                            '• Domain Layer: Entities, Repositories, UseCases\n'
                            '• Data Layer: Models, DataSources, DioClient with Interceptors\n'
                            '• Presentation Layer: flutter_bloc, Equatable, GoRouter\n'
                            '• Multi-Vendor: Store profiles, per-vendor cart grouping & shipping breakdown',
                            style: TextStyle(fontSize: 13, height: 1.4),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(ctx),
                              child: const Text('Close'),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // 3. Logout / Account Actions
            BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                if (state is AuthenticatedState) {
                  return CustomButton(
                    text: 'Sign Out',
                    icon: Icons.logout_rounded,
                    isOutlined: true,
                    textColor: AppColors.error,
                    backgroundColor: AppColors.error,
                    onPressed: () {
                      context.read<AuthBloc>().add(const LogoutRequestedEvent());
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Logged out successfully'),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                  );
                }
                return const SizedBox.shrink();
              },
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
