class Recommendation {
  String city;
  String country;
  String ImageURL;
  String name;
  num? rating;
  String description;
  // num rankingDenominator;
  num? rankingPosition;
  num? numReviews;
  num? rawRanking;
  String subCategory;
  String subType;
  Recommendation(this.city, this.country, this.ImageURL, this.name, this.rating,
      this.description,
      // this.rankingDenominator,
      this.rankingPosition,
      this.numReviews,this.rawRanking,this.subCategory,this.subType
);
}
