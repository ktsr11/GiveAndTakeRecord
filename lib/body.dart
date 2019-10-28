import 'package:flutter/material.dart';



class MotherTabPage extends StatefulWidget {
  const MotherTabPage({ Key key }) : super(key: key);

  @override 
  _MotherTabPageState createState() => _MotherTabPageState();
}

class _MotherTabPageState extends State<MotherTabPage> with SingleTickerProviderStateMixin {
    final List<Tab> tabs = <Tab>[
      Tab(text: 'LEFT'),
      Tab(text: "RIGHT")
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
          title: Text("Pages"),
        backgroundColor: Colors.lime,
        ),
        body: TabBarView(
          controller: _tabController,
          children: tabs.map((Tab tab) {
            final String label = tab.text.toLowerCase();
            return Center(
              child: Text(
                'This is the $label tab',
                style: const TextStyle(fontSize: 36),
              ),
            );
          }).toList(),
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