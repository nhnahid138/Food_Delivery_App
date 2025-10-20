class ubc{
  String image;
  String title;
  String description;
  ubc(
      {required this.image, required this.title, required this.description}
      );
}

List<ubc> content=[
  ubc(image: "img/screen1.png", title: "Screen 1", description: "Description for Screen 1"),
  ubc(image: "img/screen2.png", title: "Screen 2", description: "Description for Screen 2"),
  ubc(image: "img/screen3.png", title: "Screen 3", description: "Description for Screen 3"),

];