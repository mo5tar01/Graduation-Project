import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About',
        textAlign: TextAlign.center,),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              Text('This project aims to develop a content-based recommender system for tourism attractions using a clustering approach. The system utilizes user ratings for different categories '
                  'to cluster users into distinct groups, enabling personalized recommendations based on their cluster affiliation. The recommender system employs the attribute-based content filtering technique, '
                  'which analyzes the attributes of attractions to generate recommendations tailored to users preferences. To initialize the system, a survey was conducted to explore various types of recommender '
                  'systems and popular technologies. Subsequently, the team chose to focus on a content-based approach, specifically employing the K-means clustering algorithm for user segmentation. The system incorporates users average ratings for categories '
                  'to assign them to one of the 11 identified clusters. For users without prior ratings, a slider mechanism was implemented during registration to capture their initial ratings for each category. '
                  'The system dynamically updates its clustering output and associated cluster centers whenever new users register, ensuring accurate recommendations based on the latest user data. '
                  'The system incorporates a Firebase database, enabling efficient storage and retrieval of user ratings, cluster information, and attraction data. Additionally, a sparse matrix is employed to capture the top 5 rated categories for each userThis matrix supplements the cluster-based recommendations, providing independent suggestions to diversify the user experience. '
                  'The user interface (UI) is developed using Flutter, a cross-platform framework, to ensure compatibility across different devices. The UI interacts seamlessly with the Firebase database, retrieving and displaying personalized recommendations for each user. To enhance the user experience, a hybrid recommendation approach is implemented, combining cluster-based recommendations with suggestions from the sparse matrix. '
                  'By randomly selecting 15 recommendations from a pool of attractions associated with each cluster, the system ensures a balance between offering typical recommendations for the cluster while providing some degree of uniqueness to individual users. In conclusion, this project presents a content-based recommender system for tourism attractions, leveraging user clustering and attribute-based filtering techniques. '
                  'By utilizing K-means clustering and integrating with Firebase and Flutter technologies, the system provides personalized and diverse recommendations to enhance the tourism experience for users.',

              ),
            ],
          ),
        ),
      ),

    );
  }
}
