import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Card hiển thị 1 quán cà phê, dùng chung cho cả "Favourite Coffee Shop"
/// (truyền pinned: true) và "Post History" (truyền timeAgo).
class CoffeeShopCard extends StatelessWidget {
  final String name;
  final String description;
  final int rating; // số hạt cà phê tô đậm, tối đa 5
  final bool pinned;
  final String? timeAgo;
  final String? imageUrl;

  const CoffeeShopCard({
    super.key,
    required this.name,
    required this.description,
    this.rating = 4,
    this.pinned = false,
    this.timeAgo,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFDED4BA),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: const Color(0xFFE8DFC8),
                border: Border.all(color: const Color(0xFFD6C7A8)),
                borderRadius: BorderRadius.circular(8),
                image: (imageUrl != null && imageUrl!.isNotEmpty)
                    ? DecorationImage(
                  image: NetworkImage(imageUrl!),
                  fit: BoxFit.cover,
                )
                    : null,
              ),
              child: (imageUrl == null || imageUrl!.isEmpty)
                  ? const Center(
                child: Icon(
                  Icons.image_outlined,
                  size: 28,
                  color: Color(0xFF7E654C),
                ),
              )
                  : null,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        name,
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF402F11),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (pinned) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF7E654C),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'Pinned',
                          style: GoogleFonts.inter(
                            fontSize: 9,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: List.generate(5, (i) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 3),
                      child: Icon(
                        Icons.coffee,
                        size: 14,
                        color: i < rating
                            ? const Color(0xFF7E654C)
                            : const Color(0xFFB8A78A),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 6),
                Text(
                  description,
                  style: GoogleFonts.inter(
                    fontSize: 10.5,
                    color: const Color(0xFF7E654C),
                  ),
                ),
                if (timeAgo != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    timeAgo!,
                    style: GoogleFonts.inter(
                      fontSize: 8,
                      color: const Color(0xFF7E654C),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}