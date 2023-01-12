import 'dart:ui';

class Recognition {
  String name;
  Rect location;
  List<double> embeddings;
  double distance;
  /// Constructs a Category.
  Recognition(this.name, this.location,this.embeddings,this.distance);

}
