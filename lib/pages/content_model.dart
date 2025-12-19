class ubc{
  String image;
  String title;
  String description;
  ubc(
      {required this.image, required this.title, required this.description}
      );
}

List<ubc> content=[
  ubc(image: "img/screen1.png", title: "Quick Foodie", description: "Get Food at Reasonable Price"),
  ubc(image: "img/screen2.png", title: "Quick Foodie", description: "All Payment method available"),
  ubc(image: "img/screen3.png", title: "Quick Foodie", description: "Get Fastest Delivery"),

];