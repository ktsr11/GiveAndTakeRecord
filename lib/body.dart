import 'package:flutter/material.dart';
import 'package:giv_tak_rec/celebrationPage.dart';
import 'package:giv_tak_rec/condolencePage.dart';



class MotherTabPage extends StatefulWidget {
  const MotherTabPage({ Key key }) : super(key: key);

  @override 
  _MotherTabPageState createState() => _MotherTabPageState();
}

class _MotherTabPageState extends State<MotherTabPage> with SingleTickerProviderStateMixin {
    final List<Tab> tabs = <Tab>[
      Tab(text: '리스트'),
      Tab(text: "환경설정")
    ];

    TabController _tabController;

    @override 
    void initState() {
      super.initState();
      _tabController = TabController(vsync: this, length: tabs.length);
    }

    @override 
    void dispose() {
      _tabController.dispose();
      super.dispose();
    }

    @override 
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text("기브앤테이크"),
        backgroundColor: Colors.lime,
        ),
        body: TabBarView(
          controller: _tabController,
          children: <Widget>[
            CelebarationPage(),
            CondolencePage(),
          ]
        ),
        bottomNavigationBar: Material(
          color: Colors.pinkAccent,
          child: TabBar(
            controller: _tabController,
            tabs: tabs,
          ),
        ),
      );
    }
}