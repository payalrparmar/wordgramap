import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wordgramapp/find_word_page.dart';

import 'find_word_page.dart';

class WordGridPage extends StatefulWidget {
  final String rowval;
  final String colval;

  const WordGridPage({Key? key, required this.rowval, required this.colval})
      : super(key: key);
  @override
  _WordGridPageState createState() => _WordGridPageState();
}

class _WordGridPageState extends State<WordGridPage> {
  var row;
  var col;

  bool isANumber = true;

  RegExp letterValidator = RegExp("[a-z]+");
  TextEditingController lettercon = TextEditingController();

  final rowsController = TextEditingController();
  final columnsController = TextEditingController();

  late List<TextField?> listgrid;
  late List<TextEditingController?> listcontroller;

  late List<List<String?>> wrdgrd;

  late int colnum;
  int? rownum;
  @override
  void dispose() {
    rowsController.dispose();
    columnsController.dispose();
    for (var row in listcontroller) {
      row!.dispose();
    }
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    listgrid = [];
    listcontroller = [];

    wrdgrd = List.generate(int.tryParse(widget.rowval)!,
        (i) => List.filled(int.tryParse(widget.colval)!, "a", growable: true),
        growable: true);
    colnum = int.parse(widget.colval);
    rownum = int.parse(widget.rowval);

    for (int indx = 0;
        indx < (int.tryParse(widget.rowval)! * int.tryParse(widget.colval)!);
        indx++) {
      var textEditContrl = TextEditingController();
      listcontroller.add(textEditContrl);
      listgrid.add(TextField(
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
          ),
          decoration: InputDecoration(border: InputBorder.none),
          inputFormatters: [LengthLimitingTextInputFormatter(1)],
          controller: listcontroller[indx]));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text(
          "WORD GRID",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              height: 900,
              child: GridView.builder(
                  itemCount:
                      int.parse(widget.rowval) * int.parse(widget.colval),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: int.parse(widget.colval),
                      childAspectRatio: 0.8,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {},
                      child: GridTile(
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border:
                                  Border.all(color: Colors.black, width: 1)),
                          child: Align(
                            alignment: Alignment.center,
                            child: Center(
                              child: listgrid[index],
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => FindWordPage(
                            gridcara: listgrid,
                            colnumber: colnum,
                          )));
            },
            child: Container(
              height: 40,
              width: 200,
              decoration: BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.white,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const Text(
                    "MAKE WORD GRID",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Colors.white),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
