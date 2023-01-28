const String WSLetters = 'abcdefghijklmnoprstuvwy';

enum WSOrientation {
  horizontal,
  vertical,
  diagonal,
}

class WSSettings {
  int height;
  int width;

  final List<WSOrientation> orientations;
  final dynamic fillBlanks;
  final bool allowExtraBlanks;
  final int maxAttempts;
  final int maxGridGrowth;
  final bool preferOverlap;

  WSSettings({
    required this.width,
    required this.height,
    this.orientations = WSOrientation.values,
    this.fillBlanks,
    this.allowExtraBlanks = true,
    this.maxAttempts = 3,
    this.maxGridGrowth = 10,
    this.preferOverlap = true,
  });
}

class WSLocation implements WSPosition {
  final int x;
  final int y;

  final WSOrientation orientation;
  final int overlap;
  String word;

  WSLocation({
    required this.x,
    required this.y,
    required this.orientation,
    required this.overlap,
    required this.word,
  });
}

class WSPosition {
  final int x;
  final int y;

  WSPosition({
    this.x = 0,
    this.y = 0,
  });
}

class WSSolved {
  final List<WSLocation> found;
  final List<String> notFound;

  WSSolved({
    required List<WSLocation> found,
    required List<String> notFound,
  })  : found = found,
        notFound = notFound;
}

typedef WSOrientationFn = WSPosition Function(int x, int y, int i);
typedef WSCheckOrientationFn = bool Function(int x, int y, int h, int w, int l);
