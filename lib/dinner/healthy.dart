//import 'dart:async';
//import 'dart:io';
import 'package:flutter/material.dart';
//import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/rendering.dart';
//import 'package:flutter/src/widgets/navigator.dart';

class Healthy extends StatefulWidget {
  @override
  _HealthyList createState() => _HealthyList();
}

class _HealthyList extends State<Healthy> {
  List<String> healthy_list = <String>['test1', 'test2'];
  final myController = TextEditingController();
  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }

  int listLength = 0;
  @override
  void initState() {
    super.initState();
    _fetchList();
  }

// GET LIST FROM SHARED PREFERENCES

  Future<void> _fetchList() async {
    final prefs = await SharedPreferences.getInstance();
    var tempList = prefs.getStringList("healthy") ?? [];
    setState(() {
      healthy_list = tempList;
    });
  }

  Future<bool> _saveList() async {
    final prefs = await SharedPreferences.getInstance();
    return await prefs.setStringList("healthy", healthy_list);
  }

// HEALTHY DINNER SCREEN
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        centerTitle: true,
        elevation: 1,
        title: Center(
          child: Text('Healthy Dinner        '),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/healthy.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: ListView.separated(
            itemCount: listLength = healthy_list.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(
                  healthy_list[index],
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            },
            separatorBuilder: (context, index) {
              return Divider();
            }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {
          print('addItem called'),
          showDialog<String>(
            context: context,
            child: AlertDialog(
              contentPadding: const EdgeInsets.all(17),
              content: Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: myController,
                      autofocus: true,
                      decoration: InputDecoration(
                        labelText: 'Enter the food item',
                        labelStyle: TextStyle(
                          fontSize: 35,
                          height: 0.75,
                        ),
                        hintText: 'Eg. Pizza',
                      ),
                    ),
                  ),
                ],
              ),
              actions: <Widget>[
                FlatButton(
                  child: const Text('CANCEL'),
                  onPressed: () => {
                    Navigator.pop(context),
                  },
                ),
                FlatButton(
                    child: const Text('ADD'),
                    onPressed: () => {
                          if (myController.text != null)
                            {
                              setState(() {
                                healthy_list.insert(0, myController.text);
                              }),
                              _saveList(),
                              Navigator.pop(context),
                              myController.text = '',
                            }
                        }),
              ],
            ),
          )
        },
        tooltip: 'Add Item',
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }
}