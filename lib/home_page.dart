import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wordgramapp/word_grid_page.dart';

class HomePage extends StatefulWidget {
  static String tag = "home-page";
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController rowcontroller = TextEditingController();
  TextEditingController colcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text(
          "ROWS N COLUMNS",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Center(
              child: Text(
            "Enter number of Rows",
            style: TextStyle(fontSize: 18),
          )),
          TextfieldLayout(rowcontroller),
          Center(
              child: Text(
            "Enter number of Columns",
            style: TextStyle(fontSize: 18),
          )),
          TextfieldLayout(colcontroller),
          createGridButton()
        ],
      ),
    );
  }

  Widget TextfieldLayout(TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Container(
        width: 100,
        decoration: BoxDecoration(border: Border.all(color: Colors.black)),
        child: TextFormField(
          controller: controller,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
          ],
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          // keyboardType: TextInputType.numberWithOptions(decimal: true),
        ),
      ),
    );
  }

  Widget createGridButton() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => WordGridPage(
                      rowval: rowcontroller.text,
                      colval: colcontroller.text,
                    )));
      },
      child: Container(
        height: 40,
        width: 200,
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
            Text(
              "CREATE WORD GRID",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
