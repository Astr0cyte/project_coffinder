import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFAF9F4),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            onPressed: () {
                            // Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage()));
                            },
                        ),
                        Spacer(),
                      ],
                    ),
                    SizedBox(height: 20),

                    Center(
                      child: CircleAvatar(
                        radius: 35,
                        backgroundImage: AssetImage('assets/images/profile.jpg'),
                      ),
                    ),

                          SizedBox(width: 16.0),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Text(
                                  'John Doe',
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'PlayfairDisplay',
                                    color: Color(0xFF402F11),
                                  ),
                                ),
                              ),
                              Center(
                                child: Text(
                                  '@Username',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'Quicksand',
                                    color: Color(0xFF7E654C),
                                  ),
                                ),
                              ),
                              SizedBox(height: 4.0),
                              Center(
                                child: Text(
                                  'Coffee app',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: 'Inter',
                                    color: Color(0xFF7E654C),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 20.0),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              children: [
                                Text(
                                  '42',
                                style: GoogleFonts.playfairDisplay(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF402F11),
                                ),
                                ),
                                Text(
                                  'Posts',
                                style: GoogleFonts.inter(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xFF7E654C),
                                ),
                                ),
                              ],
                            ),
                            SizedBox(width: 16.0),
                            Column(
                              children: [
                                Text(
                                  '128',
                                style: GoogleFonts.playfairDisplay(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF402F11),
                                ),
                                ),
                                Text(
                                  'Followers',
                                  style: GoogleFonts.inter(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xFF7E654C),
                                ),
                                ),
                              ],
                            ),
                            SizedBox(width: 16.0),
                            Column(
                              children: [
                                Text(
                                  '56',
                                  style: GoogleFonts.playfairDisplay(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF402F11),
                                ),
                                ),
                                Text(
                                  'Following',
                                  style: GoogleFonts.inter(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xFF7E654C),
                                ),
                                ),
                              ],
                            )
                          ],
                        )
                      ],
                ),

                SizedBox(height: 20.0),

                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      // Go to food page
                    },
                    child: Text(
                      'Follow',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFDED4BA),
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF402F11),
                      padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 12.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                  ),
            ),
            SizedBox(height: 20.0),

            Divider(
              color: Color(0xFFDED4BA),
              thickness: 1,
                ),

            const SizedBox(height: 5.0),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Favourite Coffee Shop',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF402F11),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: const Color(0xFFDED4BA),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8DFC8), // light beige
                        border: Border.all(
                          color: const Color(0xFFD6C7A8),
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.image_outlined,
                          size: 28,
                          color: Color(0xFF7E654C),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12.0),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        // Name + Pinned badge
                        Row(
                          children: [
                            Text(
                              "L'Usine",
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF402F11),
                              ),
                            ),
                            const Spacer(),
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
                                "Pinned",
                                style: GoogleFonts.inter(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 6),

                        Row(
                          children: const [
                            Icon(Icons.coffee, size: 14, color: Color(0xFF7E654C)),
                            SizedBox(width: 3),
                            Icon(Icons.coffee, size: 14, color: Color(0xFF7E654C)),
                            SizedBox(width: 3),
                            Icon(Icons.coffee, size: 14, color: Color(0xFF7E654C)),
                            SizedBox(width: 3),
                            Icon(Icons.coffee, size: 14, color: Color(0xFF7E654C)),
                            SizedBox(width: 3),
                            Icon(Icons.coffee, size: 14, color: Color(0xFFB8A78A)),
                          ],
                        ),

                        const SizedBox(height: 6),

                        Text(
                          "My top pick for pour-over and a quiet corner to work.",
                          style: GoogleFonts.inter(
                            fontSize: 10.5,
                            color: const Color(0xFF7E654C),
                          ),
                        ),
                      ],
                    ),
                  ),
                  ],
                  ),
                  ),

                  const SizedBox(height: 25),

                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Post History",
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF402F11),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),
                  

                  Container(
  padding: const EdgeInsets.all(12),
  decoration: BoxDecoration(
    color: const Color(0xFFDED4BA),
    borderRadius: BorderRadius.circular(8),
  ),
  child: Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [

      // Image placeholder
      Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          color: const Color(0xFFE8DFC8),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: const Color(0xFFD6C7A8),
          ),
        ),
        child: const Icon(
          Icons.image_outlined,
          color: Color(0xFF7E654C),
        ),
      ),

      const SizedBox(width: 12),

      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "L'Usine",
              style: GoogleFonts.inter(
                fontWeight: FontWeight.bold,
                color: const Color(0xFF402F11),
              ),
            ),

            const SizedBox(height: 6),

            Row(
              children: const [
                Icon(Icons.coffee, size: 14, color: Color(0xFF7E654C)),
                SizedBox(width: 3),
                Icon(Icons.coffee, size: 14, color: Color(0xFF7E654C)),
                SizedBox(width: 3),
                Icon(Icons.coffee, size: 14, color: Color(0xFF7E654C)),
                SizedBox(width: 3),
                Icon(Icons.coffee, size: 14, color: Color(0xFF7E654C)),
                SizedBox(width: 3),
                Icon(Icons.coffee, size: 14, color: Color(0xFFB8A78A)),
              ],
            ),

            const SizedBox(height: 6),

            Text(
              "My top pick for pour-over and a quiet corner to work.",
              style: GoogleFonts.inter(fontSize: 10.5),
            ),

            const SizedBox(height: 4),

            Text(
              "2 days ago",
              style: GoogleFonts.inter(
                fontSize: 8,
                color: const Color(0xFF7E654C),
              ),
            ),
          ],
        ),
      ),
    ],
  ),
),

                  const SizedBox(height: 12),

                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFDED4BA),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        // Image placeholder
                        Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            color: const Color(0xFFE8DFC8),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: const Color(0xFFD6C7A8),
                            ),
                          ),
                          child: const Icon(
                            Icons.image_outlined,
                            color: Color(0xFF7E654C),
                          ),
                        ),

                        const SizedBox(width: 12),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              Text(
                                "Workshop Coffee",
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF402F11),
                                ),
                              ),

                              const SizedBox(height: 6),

                              Row(
                                children: const [
                                  Icon(Icons.coffee,size:14,color:Color(0xFF7E654C)),
                                  SizedBox(width:3),
                                  Icon(Icons.coffee,size:14,color:Color(0xFF7E654C)),
                                  SizedBox(width:3),
                                  Icon(Icons.coffee,size:14,color:Color(0xFF7E654C)),
                                  SizedBox(width:3),
                                  Icon(Icons.coffee,size:14,color:Color(0xFF7E654C)),
                                  SizedBox(width:3),
                                  Icon(Icons.coffee,size:14,color:Color(0xFFB8A78A)),
                                ],
                              ),

                              const SizedBox(height: 6),

                              Text(
                                "Great espresso and atmosphere.",
                                style: GoogleFonts.inter(
                                  fontSize: 10.5,
                                  color: const Color(0xFF7E654C),
                                ),
                              ),

                              const SizedBox(height: 4),

                              Text(
                                "5 days ago",
                                style: GoogleFonts.inter(
                                  fontSize: 8,
                                  color: const Color(0xFF7E654C),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                  );
                    }
                  }