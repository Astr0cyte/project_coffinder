import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/user_model.dart';
import '../services/user_service.dart';
import 'app_colors.dart';
import 'profile_page.dart';

class UserSearchPage extends StatefulWidget {
  const UserSearchPage({super.key});

  @override
  State<UserSearchPage> createState() => _UserSearchPageState();
}

class _UserSearchPageState extends State<UserSearchPage> {
  final _controller = TextEditingController();
  List<UserModel> _results = [];
  bool _loading = false;
  String _lastQuery = '';

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onQueryChanged);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _onQueryChanged() async {
    final query = _controller.text.trim();
    if (query == _lastQuery) return;
    _lastQuery = query;

    if (query.isEmpty) {
      setState(() { _results = []; _loading = false; });
      return;
    }

    setState(() => _loading = true);
    try {
      final results = await UserService.instance.searchUsers(query);
      if (!mounted) return;
      // Discard stale results if the query changed while we were waiting,
      // but still clear loading — the newer call will set its own results.
      if (_controller.text.trim() != query) {
        setState(() => _loading = false);
        return;
      }
      setState(() { _results = results; _loading = false; });
    } catch (_) {
      if (!mounted) return;
      setState(() { _results = []; _loading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    color: AppColors.brownDark,
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      height: 42,
                      decoration: BoxDecoration(
                        color: AppColors.chipLight,
                        borderRadius: BorderRadius.circular(21),
                      ),
                      child: TextField(
                        controller: _controller,
                        autofocus: true,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: AppColors.brownDark,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Search users...',
                          hintStyle: GoogleFonts.inter(
                            fontSize: 14,
                            color: AppColors.brownMid,
                          ),
                          prefixIcon: const Icon(Icons.search,
                              size: 18, color: AppColors.brownMid),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            const Divider(color: AppColors.tan, height: 1),
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : _results.isEmpty && _lastQuery.isNotEmpty
                      ? Center(
                          child: Text(
                            'No users found',
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              color: AppColors.brownMid,
                            ),
                          ),
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          itemCount: _results.length,
                          separatorBuilder: (_, __) =>
                              const Divider(color: AppColors.tan, height: 1),
                          itemBuilder: (context, i) {
                            final user = _results[i];
                            return ListTile(
                              onTap: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) =>
                                      ProfilePage(userId: user.userId),
                                ),
                              ),
                              leading: CircleAvatar(
                                radius: 22,
                                backgroundColor: AppColors.tan,
                                backgroundImage: user.avatarUrl.isNotEmpty
                                    ? NetworkImage(user.avatarUrl)
                                    : const AssetImage('assets/avatar.png')
                                        as ImageProvider,
                              ),
                              title: Text(
                                user.displayName,
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.brownDark,
                                ),
                              ),
                              subtitle: null,
                              trailing: const Icon(Icons.chevron_right,
                                  color: AppColors.brownMid),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
