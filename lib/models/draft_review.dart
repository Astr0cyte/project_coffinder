/*

lib/
│
├── models/
│   └── draft_review.dart             <-- 1. Data Models (The Blueprints)
│
├── pages/
│   └── diary_pages/
│       └── draft_reviews_page.dart <-- 2. Screens (The Canvas)
│
└── widgets/
    └── draft_reviews_card.dart    <-- 3. UI Components (The Paintbrushes)

*/

class DraftReview {
  final String shopName;
  final int rating;
  final String shopImage;
  final String comment;

  const DraftReview({
    required this.shopName,
    required this.rating,
    required this.shopImage,
    required this.comment,
  });
}