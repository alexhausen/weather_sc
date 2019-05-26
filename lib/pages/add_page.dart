import 'package:flutter/material.dart';
import 'package:weather_sc/models/cities.dart';

class AddPage extends StatefulWidget {
  final List<String> _selectedCities;

  AddPage(this._selectedCities);

  @override
  State<StatefulWidget> createState() => _AddPage();
}

class _AddPage extends State<AddPage> {
  final controller = TextEditingController();
  var _cities = List<String>();

  @override
  void initState() {
    _cities = Cities.filter('', widget._selectedCities);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add City')),
      body: Container(
        child: Column(
          children: <Widget>[
            TextField(
              controller: controller,
              onChanged: (value) {
                setState(() {
                  _cities = Cities.filter(value, widget._selectedCities);
                });
              },
              decoration: InputDecoration(
                hintText: 'City name',
                prefixIcon: Icon(Icons.search),
              ),
            ),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _cities.length,
                itemBuilder: (context, index) {
                  String name = _cities[index];
                  return InkWell(
                    onTap: () {
                      Navigator.of(context).pop(name);
                    },
                    child: ListTile(title: Text(name)),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
