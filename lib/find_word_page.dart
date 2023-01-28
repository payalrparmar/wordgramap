import 'package:flutter/material.dart';
import 'package:wordgramapp/home_page.dart';
import 'package:wordgramapp/word_find_algo.dart';
import 'package:wordgramapp/word_grid_page.dart';

class FindWordPage extends StatefulWidget {
  final List<TextField?> gridcara;
  final int colnumber;

  const FindWordPage({
    Key? key,
    required this.gridcara,
    required this.colnumber,
  }) : super(key: key);
  @override
  _FindWordPageState createState() => _FindWordPageState();
}

class _FindWordPageState extends State<FindWordPage> {
  late String coll;
  bool _validatevalue = false;

  TextEditingController wordcontroller = TextEditingController();
  late List<List<String?>> wrdgrd;
  List<WSLocation> locations = [];
  late WSSettings ws;
  final WordFindAlgo wordtofind = WordFindAlgo();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late List<int> colorList;
  @override
  void initState() {
    super.initState();

    wrdgrd = List.generate(
        (widget.gridcara.length / widget.colnumber).round(),
        (i) => List.filled(int.tryParse(widget.colnumber.toString())!, "a",
            growable: true),
        growable: true);

    colorList = List.filled(widget.gridcara.length, widget.gridcara.length,
        growable: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: Colors.blueAccent,
          title: Text(
            "FIND WORD",
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Container(
                height: 400,
                child: GridView.builder(
                    itemCount: widget.gridcara.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: widget.colnumber,
                        childAspectRatio: .8,
                        crossAxisSpacing: 23,
                        mainAxisSpacing: 20),
                    itemBuilder: (context, index) {
                      return Container(
                        height: 40,
                        color: index == colorList[index]
                            ? Colors.blueAccent.withOpacity(.5)
                            : Colors.black12,
                        child: Center(child: widget.gridcara[index]),
                      );
                    }),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: TextField(
                controller: wordcontroller,
                onChanged: (value) {
                  setState(() {
                    colorList = List.filled(
                        widget.gridcara.length, widget.gridcara.length,
                        growable: false);
                  });
                },
                style: TextStyle(
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                    errorText: _validatevalue ? 'Please enter word' : null,
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 18),
                    hintText: "Enter word"),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 20, right: 20, top: 10),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: Colors.blueAccent),
                  onPressed: () {
                    setState(() {
                      wordcontroller.text.isEmpty
                          ? _validatevalue = true
                          : _validatevalue = false;
                      int r = 0;

                      for (int p = 0;
                          p <
                              (widget.gridcara.length / widget.colnumber)
                                  .floor();
                          p++) {
                        if (r > (widget.gridcara.length)) {
                          return;
                        }

                        for (int q = 0; q < (widget.colnumber); q++) {
                          wrdgrd[p][q] =
                              widget.gridcara[r]?.controller?.text.toString();

                          r++;
                          wrdgrd[p][q]?.compareTo(wordcontroller.text);
                        }
                      }

                      ws = WSSettings(
                          width: (widget.gridcara.length / widget.colnumber)
                              .floor(),
                          height: widget.colnumber,
                          orientations: List.from([
                            WSOrientation.horizontal,
                            WSOrientation.vertical,
                            WSOrientation.diagonal
                          ]));

                      final WSSolved solved =
                          wordtofind.solvePuzzle(wrdgrd, [wordcontroller.text]);

                      solved.found.forEach((element) {
                        setState(() {
                          _scaffoldKey.currentState!.showSnackBar(SnackBar(
                            backgroundColor: Colors.green,
                            content: Text(
                              '${element.word} word Found Successfully!',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ));
                        });
                        switch (element.orientation.toString()) {
                          case 'WSOrientation.horizontal':
                            {
                              int count = 1;

                              for (int a = (element.y * widget.colnumber);
                                  a < widget.gridcara.length;
                                  a++) {
                                if (element.x == 0) {
                                  colorList[a] = a;
                                  count++;
                                  if (count > wordcontroller.text.length) break;
                                } else {
                                  colorList[a + element.x] = a + element.x;
                                  count++;
                                  if (count > wordcontroller.text.length) break;
                                }
                              }
                            }

                            break;

                          case 'WSOrientation.vertical':
                            {
                              int count = 1;
                              int rc =
                                  (widget.gridcara.length / widget.colnumber)
                                      .floor();

                              for (int a = element.x;
                                  a < widget.gridcara.length;
                                  a += widget.colnumber) {
                                if (element.y == 0) {
                                  colorList[a] = a;
                                  count++;
                                  if (count > wordcontroller.text.length) break;
                                } else {
                                  rc += widget.colnumber;
                                  colorList[(a + rc)] = (a + rc);
                                  count++;

                                  if (count > wordcontroller.text.length) break;
                                }
                              }
                              break;
                            }
                          case 'WSOrientation.diagonal':
                            {}
                            break;

                          default:
                            {}
                            break;
                        }
                      });

                      solved.notFound.forEach((element) {
                        setState(() {
                          _scaffoldKey.currentState!.showSnackBar(SnackBar(
                            backgroundColor: Colors.red,
                            content: Text(
                              'Sorry ! word Not Found.',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ));
                        });
                      });
                    });
                  },
                  child: Text(
                    "SEARCH",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  )),
            ),
            Padding(
              padding: EdgeInsets.only(left: 20, right: 20, top: 10),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => HomePage()));
                },
                child: Container(
                  height: 40,
                  width: 80,
                  decoration: BoxDecoration(
                    color: Colors.blueAccent,
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(
                      color: Colors.white,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      const Text(
                        "RESET",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ));
  }
}
