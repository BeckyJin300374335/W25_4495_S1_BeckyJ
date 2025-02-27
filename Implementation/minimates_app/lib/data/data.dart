class Post {
  String id;
  String image;
  String title;
  List<dynamic> tags;
  Post(this.id,  this.title, this.image, this.tags);
}

class Tag {
  String name;
  Tag(this.name);
}