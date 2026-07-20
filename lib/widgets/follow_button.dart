import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/follow_service.dart';

/// Nút Follow / Following, chỉ hiện khi xem profile của NGƯỜI KHÁC.
/// Bấm lần 1 -> follow. Bấm lần 2 -> unfollow.
class FollowButton extends StatefulWidget {
  final String currentUid;
  final String targetUid;
  final VoidCallback? onChanged; // báo cho ProfilePage biết để refresh số liệu

  const FollowButton({
    super.key,
    required this.currentUid,
    required this.targetUid,
    this.onChanged,
  });

  @override
  State<FollowButton> createState() => _FollowButtonState();
}

class _FollowButtonState extends State<FollowButton> {
  bool _isProcessing = false;

  Future<void> _handleTap(bool isFollowing) async {
    if (_isProcessing) return;
    setState(() => _isProcessing = true);
    try {
      if (isFollowing) {
        await FollowService.instance
            .unfollowUser(widget.currentUid, widget.targetUid);
      } else {
        await FollowService.instance
            .followUser(widget.currentUid, widget.targetUid);
      }
      widget.onChanged?.call();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Không tự follow chính mình -> ẩn hẳn nút.
    if (widget.currentUid == widget.targetUid) {
      return const SizedBox.shrink();
    }

    return StreamBuilder<bool>(
      stream: FollowService.instance
          .streamIsFollowing(widget.currentUid, widget.targetUid),
      builder: (context, snapshot) {
        final isFollowing = snapshot.data ?? false;

        return Center(
          child: ElevatedButton(
            onPressed: _isProcessing ? null : () => _handleTap(isFollowing),
            style: ElevatedButton.styleFrom(
              backgroundColor: isFollowing
                  ? const Color(0xFFDED4BA)
                  : const Color(0xFF402F11),
              padding:
              const EdgeInsets.symmetric(horizontal: 32.0, vertical: 12.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
            child: _isProcessing
                ? const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
                : Text(
              isFollowing ? 'Following' : 'Follow',
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: isFollowing
                    ? const Color(0xFF402F11)
                    : const Color(0xFFDED4BA),
              ),
            ),
          ),
        );
      },
    );
  }
}