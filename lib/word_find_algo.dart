import 'orientations.dart';
import 'check_orientations.dart';
import 'skip_orientations.dart';
import 'utils.dart';
export 'utils.dart';

class WordFindAlgo {
  final orientations = wsOrientations;
  final _checkOrientations = wsCheckOrientations;
  final _skipOrientations = wsSkipOrientations;

  List<WSLocation> _findBestLocations(
    List<List<String?>> puzzle,
    WSSettings options,
    String word,
  ) {
    List<WSLocation> locations = [];
    int height = options.height;
    int width = options.width;
    int wordLength = word.length;
    int maxOverlap = 0;

    for (var i = 0; i < options.orientations.length; i++) {
      final WSOrientation orientation = options.orientations[i];
      final WSOrientationFn? next = orientations[orientation];
      final WSCheckOrientationFn? check = _checkOrientations[orientation];
      final WSOrientationFn? skip = _skipOrientations[orientation];
      int x = 0;
      int y = 0;
      while (y < height) {
        if (check!(x, y, height, width, wordLength)) {
          final int overlap = _calcOverlap(word, puzzle, x, y, next!);
          if (overlap >= maxOverlap ||
              (!options.preferOverlap && overlap > -1)) {
            maxOverlap = overlap;
            locations.add(
              WSLocation(
                x: x,
                y: y,
                orientation: orientation,
                overlap: overlap,
                word: word,
              ),
            );
          }
          x += 1;
          if (x >= width) {
            x = 0;
            y += 1;
          }
        } else {
          WSPosition nextPossible = skip!(x, y, wordLength);
          x = nextPossible.x;
          y = nextPossible.y;
        }
      }
    }

    return options.preferOverlap
        ? _pruneLocations(locations, maxOverlap)
        : locations;
  }

  int _calcOverlap(
    String word,
    List<List<String?>> puzzle,
    int x,
    int y,
    WSOrientationFn fnGetSquare,
  ) {
    int overlap = 0;
    for (var i = 0; i < word.length; i++) {
      final WSPosition next = fnGetSquare(x, y, i);
      String? square;
      try {
        square = puzzle[next.y][next.x];
      } catch (_e) {
        square = null;
      }
      if (square == word[i]) {
        overlap++;
      } else if (square != '') {
        return -1;
      }
    }
    return overlap;
  }

  List<WSLocation> _pruneLocations(
    List<WSLocation> locations,
    int overlap,
  ) {
    List<WSLocation> pruned = [];
    for (var i = 0; i < locations.length; i++) {
      if (locations[i].overlap >= overlap) {
        pruned.add(locations[i]);
      }
    }
    return pruned;
  }

  WSSolved solvePuzzle(
    List<List<String?>> puzzle,
    List<String> words,
  ) {
    WSSettings options = WSSettings(
      height: puzzle.length,
      width: puzzle[0].length,
    );
    WSSolved output = WSSolved(found: [], notFound: []);

    for (var i = 0, len = words.length; i < len; i++) {
      final String word = words[i];
      List<WSLocation> locations = _findBestLocations(puzzle, options, word);
      if (locations.isNotEmpty && locations[0].overlap == word.length) {
        locations[0].word = word;
        output.found.add(locations[0]);
      } else {
        output.notFound.add(word);
      }
    }

    return output;
  }
}
