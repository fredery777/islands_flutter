import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'util.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:logger/logger.dart';

class IslandPage extends StatefulWidget {
  IslandPage({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;

  @override
  _IslandPageState createState() => _IslandPageState();
}

class _IslandPageState extends State<IslandPage> {
  TextEditingController row = TextEditingController();
  TextEditingController column = TextEditingController();
  List<List<String>> gridState = [];
  List<List<int>> grid = [];

  int rowC = 2;
  int colC = 2;
  String islandNum = '0';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: (gridState.isNotEmpty) ? _buildGameBody() : Container(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _onAlertWithCustomContentPressed(context);
        },
        child: Icon(Icons.fiber_new),
      ),
    );
  }

  Widget _buildGridItems(BuildContext context, int index) {
    int gridStateLength = gridState.length;
    int x, y = 0;
    x = (index / gridStateLength).floor();
    y = (index % gridStateLength);
    return GestureDetector(
      //onTap: () => _gridItemTapped(x, y),
      child: GridTile(
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 0.9)),
          child: Container(
            child: (gridState.length > 0) ? _buildGridItem(x, y) : Container(),
          ),
        ),
      ),
    );
  }

  Widget _buildGridItem(int x, int y) {
    switch (gridState[x][y]) {
      case '1':
        return Container(
          height: 100,
          decoration: new BoxDecoration(
            gradient: new LinearGradient(
              colors: [Colors.green, Colors.green],
              begin: FractionalOffset.centerLeft,
              end: FractionalOffset.centerRight,
            ),
          ),
          child: TextButton(
            child: new Text(gridState[x][y],
                style: TextStyle(color: Colors.black)),
            onPressed: () {
              _gridItemTapped(x, y, gridState[x][y], gridState);
            },
          ),
        );
      case '0':
        return Container(
          height: 100,
          decoration: new BoxDecoration(
            gradient: new LinearGradient(
              colors: [Colors.blueGrey, Colors.blueGrey],
              begin: FractionalOffset.centerLeft,
              end: FractionalOffset.centerRight,
            ),
          ),
          child: TextButton(
            child: new Text(gridState[x][y],
                style: TextStyle(color: Colors.black)),
            onPressed: () {
              _gridItemTapped(x, y, gridState[x][y], gridState);
            },
          ),
        );
      default:
        return Text(gridState[x][y].toString());
    }
  }

  Widget _buildGameBody() {
    int gridStateLength = gridState.length;
    return Column(children: <Widget>[
      AspectRatio(
        aspectRatio: 1.0,
        child: Container(
          padding: const EdgeInsets.all(8.0),
          margin: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 2.0)),
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: gridStateLength,
            ),
            itemBuilder: _buildGridItems,
            itemCount: gridStateLength * gridStateLength,
          ),
        ),
      ),
      Text(
        'No of Islands:' + islandNum,
        style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
      )
    ]);
  }

  /// Alert custom content
  _onAlertWithCustomContentPressed(context) {
    Alert(
        context: context,
        title: "MATRIZ",
        content: Column(
          children: <Widget>[
            TextField(
              controller: row,
              maxLength: 1,
              keyboardType: TextInputType.numberWithOptions(decimal: false),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp('[0-9]')),
              ],
              decoration: InputDecoration(
                icon: Icon(Icons.view_comfortable_rounded),
                labelText: 'Row',
              ),
            ),
            TextField(
              controller: column,
              maxLength: 1,
              keyboardType: TextInputType.numberWithOptions(decimal: false),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp('[0-9]')),
              ],
              decoration: InputDecoration(
                icon: Icon(Icons.view_comfortable_rounded),
                labelText: 'Column',
              ),
            ),
          ],
        ),
        buttons: [
          DialogButton(
            onPressed: () {
              Navigator.pop(context);
              rowC = int.parse(row.text);
              colC = int.parse(column.text);
              _createMatriz(rowC, colC);
              /*setState(() {

              });*/
            },
            child: Text(
              "CREATE",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          )
        ]).show();
  }

  _gridItemTapped(int x, int y, String val, List<List<String>> gridStateIn) {
    List<List<String>> _gridStateIn = gridStateIn;
    var logger = Logger();
    logger.d(x.toString() + "----" + y.toString());
    int num = int.parse(val);

    //logger.e("======ROW "+rowC.toString());
    //logger.e("======colC "+colC.toString());

    //logger.e("======NUEVO "+num.toString());

    _gridStateIn[x][y] = (num == 1) ? '0' : '1';
    /* print("¿¿¿¿¿¿¿");
    print(gridState);
    print("*********");
    print(gridStateIn);
    print("=======");
    print(_gridStateIn);
   // print(grid);
    print("¿¿¿¿¿¿¿");*/

    //print(IslandData.shared.grid);
    //Util util= new Util();
    //logger.i("======:::"+util.numIslands(IslandData.shared.grid).toString());
    setState(() {
      gridState = _gridStateIn;
    });
    _islandNumber(gridState);
  }

  void _islandNumber(List<List<String>> gridStateIn) {
    var logger = Logger();
    List<List<int>> _grid = List.generate(
        rowC, (i) => List.generate(colC, (j) => 1, growable: false),
        growable: false);

    for (int i = 0; i < gridStateIn.length; i++) {
      for (int j = 0; j < gridStateIn[i].length; j++) {
        _grid[i][j] = int.parse(gridStateIn[i][j]);
      }
    }
    Util util = new Util();
    print("====");
    print(_grid);
    islandNum = util.findIslands(_grid).toString();
    logger.d("======:" + util.findIslands(_grid).toString());
  }

  void _createMatriz(int rowC, int colC) {
    Random rnd = new Random();
// Define min and max value
    int min = 0, max = 2;
    //List<List<int>> _grid;

    List<List<String>> _gridState = List.generate(
        rowC,
        (i) => List.generate(
            colC, (j) => (min + rnd.nextInt(max - min)).toString(),
            growable: false),
        growable: false);
    /*print("**************************");

    print("**************************");*/

    setState(() {
      gridState = _gridState;
    });

    _islandNumber(_gridState);

    //print(gridState);
  }
}
