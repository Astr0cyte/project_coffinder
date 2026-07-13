import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DiaryGlossaryPage extends StatelessWidget {
  DiaryGlossaryPage({super.key});

	double cardInterval = -0.35; // TODO: Create a simple algorithm for this variable.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            color: Color.fromRGBO(250, 249, 244, 1.0),
          ),

          child: Stack(
						children: [
							// 1 - Navigation bar instance

							// 2 - Descriptive phrase
							Align(
								alignment: Alignment(-0.40, -0.55),
								child: Text(
									"Vietnamese pronunciation of popular coffees",
									style: GoogleFonts.quicksand(
										fontSize: 14,
										color: Color.fromRGBO(126, 101, 76, 1.0),
									),
								),
							),

							// 3 - Divider line
							Align(
								alignment: Alignment(0, -0.50),
								child: Divider(
									color: Color.fromRGBO(239, 236, 220, 1.0),
									thickness: 1, 
									indent: 30,
									endIndent: 30,
								),
							),

							// 4 - Coffee definition card instance
							Align(
								alignment: Alignment(0, cardInterval), // TODO: Create a simple algorithm for this variable.
								child: Container(
									width: 348,
									height: 96,
									decoration: BoxDecoration(
										color: Color.fromRGBO(250, 249, 239, 1.0),
										borderRadius: BorderRadius.circular(16),
										border: Border.all(
											color: Color.fromRGBO(222, 212, 186, 1.0), 
											width: 1
										),
									boxShadow: [
										BoxShadow(
											offset: Offset(0, 2),
											color: Color.fromRGBO(204, 203, 199, 1.0),
											blurRadius: 1.0,
										),
									],
									),
								),
							),

							Align(
								alignment: Alignment(0, cardInterval + 0.26), // TODO: Create a simple algorithm for this variable.
								child: Container(
									width: 348,
									height: 96,
									decoration: BoxDecoration(
										color: Color.fromRGBO(250, 249, 239, 1.0),
										borderRadius: BorderRadius.circular(16),
										border: Border.all(
											color: Color.fromRGBO(222, 212, 186, 1.0), 
											width: 1
										),
									boxShadow: [
										BoxShadow(
											offset: Offset(0, 2),
											color: Color.fromRGBO(204, 203, 199, 1.0),
											blurRadius: 1.0,
										),
									],
									),
								),
							),

							Align(
								alignment: Alignment(0, cardInterval + 0.52), // TODO: Create a simple algorithm for this variable.
								child: Container(
									width: 348,
									height: 96,
									decoration: BoxDecoration(
										color: Color.fromRGBO(250, 249, 239, 1.0),
										borderRadius: BorderRadius.circular(16),
										border: Border.all(
											color: Color.fromRGBO(222, 212, 186, 1.0), 
											width: 1
										),
									boxShadow: [
										BoxShadow(
											offset: Offset(0, 2),
											color: Color.fromRGBO(204, 203, 199, 1.0),
											blurRadius: 1.0,
										),
									],
									),
								),
							),

							Align(
								alignment: Alignment(0, cardInterval + 0.78), // TODO: Create a simple algorithm for this variable.
								child: Container(
									width: 348,
									height: 96,
									decoration: BoxDecoration(
										color: Color.fromRGBO(250, 249, 239, 1.0),
										borderRadius: BorderRadius.circular(16),
										border: Border.all(
											color: Color.fromRGBO(222, 212, 186, 1.0), 
											width: 1
										),
									boxShadow: [
										BoxShadow(
											offset: Offset(0, 2),
											color: Color.fromRGBO(204, 203, 199, 1.0),
											blurRadius: 1.0,
										),
									],
									),
								),
							),


						/*
						Container(
							width: 200,
							height: 100,
							decoration: BoxDecoration(
								color: Colors.blue,
								borderRadius: BorderRadius.circular(12), // Rounds the corners
								border: Border.all(color: Colors.black, width: 2), // Optional border
							),
						)
						*/

        		],
          ),
        ),
      ),
    );
  }
}
