import 'package:flutter/material.dart';

import 'package:weather_sc/pages/add_page.dart';
import 'package:weather_sc/models/cities.dart';

class EditPage extends StatefulWidget {
  final List<String> _selectedCities;
  final Function savePreferences;

  EditPage(this._selectedCities, this.savePreferences);

  @override
  State<StatefulWidget> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Cities'),
      ),
      body: _buildEditCities(context),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _navAdd(context),
      ),
    );
  }

  Widget _buildEditCities(BuildContext context) {
    final list = widget._selectedCities.map((name) {
      final key = Key(name);
      final int id = Cities.id(name);
      return Dismissible(
        key: key,
        background: Container(
          alignment: Alignment.centerLeft,
          child: Icon(Icons.delete, color: Colors.white),
          color: Colors.red,
        ),
        onDismissed: (_) => widget._selectedCities.remove(name),
        direction: DismissDirection.startToEnd,
        child: ListTile(
          leading: Icon(Icons.drag_handle),
          title: Text(name),
          subtitle: Text(id.toString()),
        ),
      );
    }).toList(growable: false);

    return ReorderableListView(
      onReorder: (oldIndex, newIndex) {
        setState(() {
          if (oldIndex < newIndex) {
            newIndex -= 1;
          }
          final element = widget._selectedCities.removeAt(oldIndex);
          widget._selectedCities.insert(newIndex, element);
          widget.savePreferences();
        });
      },
      children: list,
    );
  }

  void _navAdd(BuildContext context) {
    final route = MaterialPageRoute(
        builder: (context) => AddPage(widget._selectedCities));
    Navigator.of(context).push(route).then((name) {
      if (name != null) {
        widget._selectedCities.insert(0, name);
        widget.savePreferences();
        //pop edit page
        Navigator.of(context).pop();
      }
    });
  }
}
