import 'package:flutter/material.dart';
import 'home.dart';
import 'package:intl/intl.dart';

class DualHeaderWithHint extends StatelessWidget {
  const DualHeaderWithHint({
    this.name,
    this.value,
    this.hint,
    this.showHint,
  });

  final String name;
  final String value;
  final String hint;
  final bool showHint;

  Widget _crossFade(Widget first, Widget second, bool isExpanded) {
    return AnimatedCrossFade(
      firstChild: first,
      secondChild: second,
      firstCurve: const Interval(0.0, 0.6, curve: Curves.fastOutSlowIn),
      secondCurve: const Interval(0.4, 1.0, curve: Curves.fastOutSlowIn),
      sizeCurve: Curves.fastOutSlowIn,
      crossFadeState: isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
      duration: const Duration(milliseconds: 200),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Row(
      children: <Widget>[
        Expanded(
          flex: 2,
          child: Container(
            margin: const EdgeInsets.only(left: 24.0),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                name,
              ),
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Container(
            margin: const EdgeInsets.only(left: 24.0),
            child: Text(hint, style: TextStyle(fontSize: 13.0)),
            /* _crossFade(
              Text(value, style: textTheme.caption.copyWith(fontSize: 15.0)),
              Text(hint, style: textTheme.caption.copyWith(fontSize: 15.0)),
              showHint,
            ), */
          ),
        ),
      ],
    );
  }
}

class SearchPage extends StatefulWidget {
  SearchPageState createState() => new SearchPageState();
}

class SearchPageState extends State<SearchPage> {
  int _location = 0;
  int _room = 0;
  bool _switchOn = false;
  int _numStars = 0;
  TimeOfDay _inTime = TimeOfDay.now();
  TimeOfDay _outTime = TimeOfDay.now();
  DateTime _inDate = DateTime.now();
  DateTime _outDate = DateTime.now();
  double _fee = 75.0000;

  List<bool> _checkList = [false, false, false, false, false,];
  List<String> _locations = ['Seoul', 'Busan', 'Daegu'];
  List<String> _rooms = ['Single', 'Double', 'Family'];

  void _onLocationChange(int num){
    print('Pressed');
    setState((){
      _location = num;
      print("Location: " + _location.toString());
    });
  }
  void _onRoomChange(int num){
    print('Pressed');
    setState((){
      _room = num;
      print("Room: " + _room.toString());
    });
  }
  void _onClassChange(int i, bool decide){
    setState((){
      _checkList[i] = decide;
      _numStars = i + 1;
    });
  }
  void _onSwitchChange(bool switcher){
    setState((){
      _switchOn = switcher;
    });
  }
  void _onFeeChange(double value) {
    setState(() {
     _fee = value; 
     print(_fee);
    });
  }
  Future<Null> _checkInDateSetter(BuildContext context) async{
    final DateTime date = await showDatePicker(
      context: context,
      initialDate: _inDate,
      firstDate: DateTime(1969, 1),
      lastDate: DateTime(2100, 12),
    );
    if(date != null && date != _inDate){
      setState((){
        _inDate = date;
      });
    }
  }
  Future<Null> _checkInTimeSetter(BuildContext context) async{
    final TimeOfDay time = await showTimePicker(
      context: context,
      initialTime: _inTime,
    );
    if(time != null && time != _inTime){
      setState((){
        _inTime = time;
      });
    }
  }
  Future<Null> _checkOutDateSetter(BuildContext context) async{
    final DateTime date = await showDatePicker(
      context: context,
      initialDate: _outDate,
      firstDate: DateTime(1969, 1),
      lastDate: DateTime(2100, 12),
    );

    if(date != null && date != _outDate){
      setState((){
        _outDate = date;
      });
    }
  }
  Future<Null> _checkOutTimeSetter(BuildContext context) async{
    final TimeOfDay time = await showTimePicker(
      context: context,
      initialTime: _outTime,
    );

    if(time != null && time != _outTime){
      setState((){
        _outTime = time;
      });
    }
  }

  Widget showDateTime(){
    return Column(
                          children:[
                            Row(
                              children:[
                                Text('IN', style: TextStyle(fontSize: 10.0)),
                                SizedBox(width: 10.0),
                                Text(DateFormat('yyyy.MM.dd (E)').format(_inDate),
                                  style: TextStyle(fontSize: 10.0)),
                                Text(_inTime.format(context).toString(),
                                  style: TextStyle(fontSize: 10.0)),
                              ],
                            ),
                            Row(
                              children:[
                                Text('OUT', style: TextStyle(fontSize: 10.0)),
                                SizedBox(width: 10.0),
                                Text(DateFormat('yyyy.MM.dd (E)').format(_outDate), 
                                  style: TextStyle(fontSize: 10.0)),
                                Text(_outTime.format(context).toString(),
                                  style: TextStyle(fontSize: 10.0)),
                              ],
                            ),
                          ],
                        );
  }

  Future<void> _showSearchBox() async{
    return showDialog(
      context: context,
      builder: (context){
        return AlertDialog(
          title: Row(
            children:[
              Expanded(
                child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height - 550.0,
                color: Colors.blue,
                child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text('Please check your choice :)',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0),
                      ),
                ),
              ),
              ),
            ],
          ),
          actions:[
            Padding(
              padding: EdgeInsets.only(right:40.0),
              child: ButtonBar(
                alignment: MainAxisAlignment.center,
                children: [
                  RaisedButton(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                    child: Text(
                      'Search',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                        fontSize: 20.0,
                      ),
                    ),
                    onPressed: Navigator.of(context).pop,
                  ),
                  RaisedButton(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                    color: Colors.grey,
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                        fontSize: 20.0,
                      ),
                    ),
                    onPressed: Navigator.of(context).pop,
                  ),
                ],
              ),
            ),
          ],
          content: SingleChildScrollView(
            padding: EdgeInsets.all(12.0),
            child: ListBody(
              children:[
                Column(
                  children: [
                    Row(
                      children:[
                        Icon(Icons.location_on, color: Colors.blue),
                        SizedBox(width: 60.0),
                        Text(_locations[_location], style: TextStyle(fontSize: 15.0)),
                      ],
                    ),
                    SizedBox(height: 20.0),
                    Row(
                      children:[
                        Icon(Icons.credit_card, color: Colors.blue),
                        SizedBox(width: 60.0),
                        Text(_rooms[_room], style: TextStyle(fontSize: 15.0))
                      ],
                    ),
                    SizedBox(height: 20.0),
                    Row(
                      children:[
                        Icon(Icons.star, color: Colors.yellow),
                        SizedBox(width: 30.0),
                        buildStar(context, _numStars, false),
                        Text('/'),
                        buildStar(context, 5, false),
                      ],
                    ),
                    SizedBox(height: 20.0),
                    Row(
                      children:[
                        Icon(Icons.calendar_today, color: Colors.blue),
                        SizedBox(width: 20.0),
                        _switchOn ? Text('Not yet') : showDateTime(),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }
    );
  }


  @override
  void initState(){
    super.initState();
  }

  ListView List_Criteria;
  List<bool> _isExpandedList = [false, false, false];
  
  Widget build(BuildContext context) {
    List_Criteria = ListView( //ListView used along with ExpansionPanel Widgets
      children: [
        ExpansionPanelList(
          // Callback called whenever one of the expand/collapse button is pressed.
          expansionCallback: (index, isExpanded) {
            setState(() {
              _isExpandedList[index] = !_isExpandedList[index];
            });
          },
          children: [
            ExpansionPanel(
              headerBuilder: (_,__){
                return DualHeaderWithHint(
                  name: 'Location',
                  hint: 'select location',
                  showHint: false,
                );
              },
              isExpanded: _isExpandedList[0],
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 100.0,
                    child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Radio(
                        value: 0,
                        groupValue: _location,
                        activeColor: Colors.blue,
                        onChanged: (int num) => _onLocationChange(num), 
                      ),
                      Text('Seoul')
                      ],
                    ),
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Radio(
                          value: 1,
                          groupValue: _location,
                          activeColor: Colors.blue,
                          onChanged: (int num) => _onLocationChange(num),
                        ),
                        Text('Busan')
                      ],
                    ),
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Radio(
                          value: 2,
                          groupValue: _location,
                          activeColor: Colors.blue,
                          onChanged: (int num) => _onLocationChange(num),
                        ),
                        Text('Daegu')
                      ],
                    ),
                  ),
                ],
              ),
            ),
            ExpansionPanel(
              headerBuilder: (_,__){
                return DualHeaderWithHint(
                  name: 'Room',
                  hint: 'select room',
                  showHint: false,
                );
              },
              isExpanded: _isExpandedList[1],
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Radio(
                        value: 0,
                        groupValue: _room,
                        activeColor: Colors.blue,
                        onChanged: (int num) => _onRoomChange(num), 
                      ),
                      Text('Single')
                      ],
                    ),
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Radio(
                          value: 1,
                          groupValue: _room,
                          activeColor: Colors.blue,
                          onChanged: (int num) => _onRoomChange(num),
                        ),
                        Text('Double')
                      ],
                    ),
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Radio(
                          value: 2,
                          groupValue: _room,
                          activeColor: Colors.blue,
                          onChanged: (int num) => _onRoomChange(num),
                        ),
                        Text('Family')
                      ],
                    ),
                  ),
                ],
              ),
            ),
            ExpansionPanel(
              headerBuilder: (_,__){
                return DualHeaderWithHint(
                  name: 'Class',
                  hint: 'select hotel classes',
                  showHint: false,
                );
              },
              isExpanded: _isExpandedList[2],
              body: Padding(
                padding: EdgeInsets.fromLTRB(110.0, 0.0, 0.0, 0.0),
                      child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 200.0,
                      alignment: Alignment.center,
                      child: Row(
                      children: [
                        Checkbox(
                          value: _checkList[0],
                          activeColor: Colors.blue,
                          onChanged: (bool decide) => _onClassChange(0, decide), 
                        ),
                        buildStar(context, 1, false),
                        ],
                      ),
                    ),
                    Container(
                      width: 200.0,
                      alignment: Alignment.center,
                      child: Row(
                        children: [
                          Checkbox(
                            value: _checkList[1],
                            activeColor: Colors.blue,
                            onChanged: (bool decide) => _onClassChange(1, decide),
                          ),
                          buildStar(context, 2, false),
                        ],
                      ),
                    ),
                    Container(
                      width: 200.0,
                      alignment: Alignment.center,
                      child: Row(
                        children: [
                          Checkbox(
                            value: _checkList[2],
                            activeColor: Colors.blue,
                            onChanged: (bool decide) => _onClassChange(2, decide),
                          ),
                          buildStar(context, 3, false),
                        ],
                      ),
                    ),
                    Container(
                      width: 200.0,
                      alignment: Alignment.center,
                      child: Row(
                        children: [
                          Checkbox(
                            value: _checkList[3],
                            activeColor: Colors.blue,
                            onChanged: (bool decide) => _onClassChange(3, decide),
                          ),
                          buildStar(context, 4, false),
                        ],
                      ),
                    ),
                    Container(
                      width: 200.0,
                      alignment: Alignment.center,
                      child: Row(
                        children: [
                          Checkbox(
                            value: _checkList[4],
                            activeColor: Colors.blue,
                            onChanged: (bool decide) => _onClassChange(4, decide),
                          ),
                          buildStar(context, 5, false),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ]
        ),
        Container(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(width:10.0),
                  Text('Date', style: TextStyle(fontWeight: FontWeight.bold),),
                  Spacer(),
                  Text('I don\'t have specific dates yet', 
                    style: TextStyle(fontSize: 10.0,
                            color: Colors.grey),
                  ),
                  Switch(
                    activeColor: Colors.blue,
                    value: _switchOn,
                    onChanged: _onSwitchChange,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children:[
                  Column(
                    children: [
                      Row(
                        children:[
                          Icon(Icons.calendar_today),
                          SizedBox(width: 5.0),
                          Text('check-in'),
                        ],
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(DateFormat('yyyy-MM-dd').format(_inDate)),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(_inTime.format(context).toString()),
                      ),
                    ],
                  ),
                  SizedBox(width:50.0),
                  Column(
                    children: [
                      RaisedButton(
                        child: Text('select date'),
                        color: _switchOn ? Colors.grey : Colors.blue,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                        onPressed: () async => _switchOn ? null :  _checkInDateSetter(context),
                      ),
                      RaisedButton(
                        child: Text('select time'),
                        color: _switchOn ? Colors.grey : Colors.blue,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                        onPressed: () async => _switchOn ? null : _checkInTimeSetter(context) ,
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children:[
                  Column(
                    children: [
                      Row(
                        children:[
                          Icon(Icons.calendar_today),
                          SizedBox(width: 5.0),
                          Text('check-out'),
                        ],
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(DateFormat('yyyy-MM-dd').format(_outDate)),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(_outTime.format(context).toString()),
                      ),
                    ],
                  ),
                  SizedBox(width:50.0),
                  Column(
                    children: [
                      RaisedButton(
                        child: Text('select date'),
                        color: _switchOn ? Colors.grey : Colors.blue,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                        onPressed: () async => _switchOn ? null : _checkOutDateSetter(context),
                      ),
                      RaisedButton(
                        child: Text('select time'),
                        color: _switchOn ? Colors.grey : Colors.blue,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                        onPressed: () async => _switchOn ?  null : _checkOutTimeSetter(context),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        Divider(color: Colors.grey[500], height: 2.0),
        Container(
          padding: EdgeInsets.all(15.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children:[
                  SizedBox(width: 10.0),
                  Text('Fee', style: TextStyle(fontWeight: FontWeight.bold)),
                  Spacer(),
                  Text(_fee.toStringAsFixed(2)),
                  Spacer(),
                  Text('Up to \$150', style: TextStyle(fontSize: 12.0)),
                ],
              ),
              SizedBox(height: 20.0),
              Slider(
                value: _fee,
                min: 0.0,
                max: 150.0,
                onChanged: _onFeeChange,
                activeColor: Colors.blue,
              ),
              SizedBox(height: 30.0),
              RaisedButton(
                child: Text('Search',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0),
                  ),
                onPressed: _showSearchBox,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                color: Colors.blue,
              ),
            ],
          ),
        ),
      ],
    );

    Scaffold scaffold = new Scaffold(
      appBar: new AppBar(
        title: Text('Search',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.0),
            ),
          centerTitle: true,
      ),
      body: List_Criteria,
    );
    return scaffold;
  }
}