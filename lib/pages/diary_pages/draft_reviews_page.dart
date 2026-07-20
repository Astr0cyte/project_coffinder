import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../widgets/draft_reviews_card.dart';
import '../../models/draft_review.dart';

class DraftReviewsPage extends StatefulWidget {
  const DraftReviewsPage({super.key});

  @override
  State<DraftReviewsPage> createState() => _DraftReviewsPageState();
}

class _DraftReviewsPageState extends State<DraftReviewsPage> {
  final List<DraftReview> draftReviewsList = [
    DraftReview(
        shopName: 'Ca phe Muoi Chu Long',
        rating: 4,
        shopImage: 'assets/images/profile.jpg',
        comment: 'Great atmosphere and quiet room but staffs...',
    ),
    DraftReview(
        shopName: 'Phuc Long',
        rating: 3,
        shopImage: 'assets/images/Phuc_Long.png',
        comment: 'Friendly Staffs but A/C, parking???. I give this shop 3 stars'
    ),
    DraftReview(
        shopName: 'Workshop Cafe',
        rating: 5,
        shopImage: 'assets/images/profile.jpg',
        comment: 'I love this place because I met my wife here.',
    ),
    DraftReview(
        shopName: 'Highlands',
        rating: 2,
        shopImage: 'assets/images/Highlands.jpeg',
        comment: 'This is the worst coffee shop I have ever been to, but I still gave it 2 stars because the staff were very friendly. '
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Incomplete & pending reviews below",
          style: TextStyle(
            color: const Color(0xFF7E654C),
            fontFamily: GoogleFonts.quicksand().fontFamily,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Divider(
          color: Color.fromRGBO(228, 225, 208, 1),
          thickness: 1,
        ),
        const SizedBox(height: 18),

        ...draftReviewsList.map((review) => DraftReviewCard(review: review)),
      ],
    );
  }
}


