enum FillType { jpeg, png }

class PictureContainer {
  PictureContainer(this.name, this.height, this.width, this.type);

  final String name;
  final int height;
  final int width;
  final FillType type;
}
