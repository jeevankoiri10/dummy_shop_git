import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/widgets/status_views.dart';
import '../data/models/user_profile.dart';
import '../data/users_repository.dart';
import 'user_avatar.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key, required this.userId});

  final int userId;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Future<UserProfile> _profile = _load();

  Future<UserProfile> _load() =>
      context.read<UsersRepository>().fetchUser(widget.userId);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: FutureBuilder<UserProfile>(
        future: _profile,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            final error = snapshot.error;
            return StatusView(
              icon: Icons.error_outline,
              title: 'Could not load your profile',
              message: error is ApiException ? error.message : null,
              actionLabel: 'Try again',
              onAction: () => setState(() {
                _profile = _load();
              }),
            );
          }
          final profile = snapshot.data;
          if (profile == null) {
            return const Center(child: CircularProgressIndicator());
          }
          return _ProfileDetails(profile: profile);
        },
      ),
    );
  }
}

class _ProfileDetails extends StatelessWidget {
  const _ProfileDetails({required this.profile});

  final UserProfile profile;

  @override
  Widget build(BuildContext context) {
    final location = [profile.city, profile.country].nonNulls.join(', ');
    final work = [
      profile.companyTitle,
      profile.companyName,
    ].nonNulls.join(', ');
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 24),
      children: [
        Center(
          child: UserAvatar(
            username: profile.username,
            url: profile.image,
            radius: 48,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          profile.fullName,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        Text('@${profile.username}', textAlign: TextAlign.center),
        const SizedBox(height: 16),
        _row(Icons.email_outlined, profile.email),
        _row(Icons.phone_outlined, profile.phone),
        _row(Icons.cake_outlined, profile.birthDate),
        _row(Icons.place_outlined, location),
        _row(Icons.work_outline, work),
      ],
    );
  }

  Widget _row(IconData icon, String? value) => value == null || value.isEmpty
      ? const SizedBox.shrink()
      : ListTile(leading: Icon(icon), title: Text(value));
}
