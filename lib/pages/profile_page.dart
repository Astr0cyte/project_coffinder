import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                        OutlinedButton(
                          onPressed: () {
                           // Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage()));
                          },
                          child: Icon(Icons.arrow_back, color: Color(0xFF3E2A20)),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}