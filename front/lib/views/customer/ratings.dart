import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class Ratings extends StatelessWidget {
  const Ratings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      ),


      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
Align(heightFactor: 20),
              Text(
                'Donnez nous votre avis !',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              buildRatingCategory('Propreté'),
              buildRatingCategory('Temps d’attente'),
              buildRatingCategory('Fonctionnement global'),
              buildRatingCategory('Votre expérience avec l’application'),
              SizedBox(height: 20),
              TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Un avis...',
                ),
                maxLines: 3,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {},
                child: Text('Envoyer'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightBlue,
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildRatingCategory(String title) {
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10),
        RatingBar.builder(
          initialRating: 0,
          minRating: 1,
          direction: Axis.horizontal,
          allowHalfRating: true,
          itemCount: 5,
          itemPadding: EdgeInsets.symmetric(horizontal: 4),
          itemBuilder: (context, _) => Icon(
            Icons.star,
            color: Colors.amber, // Filled stars color
          ),
          onRatingUpdate: (rating) {},
          unratedColor: Color(0xFFA2DAC2), // Unrated stars color
        ),
        SizedBox(height: 20),
      ],
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: Ratings(),
  ));
}
