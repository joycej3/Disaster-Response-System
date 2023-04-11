import 'package:flutter/material.dart';
import 'package:flutter_frontend/screens/sensitive/coordinator/coordinator_map.dart';
import 'package:flutter_frontend/screens/sensitive/coordinator/big_red_button.dart';
import 'package:flutter_frontend/screens/sensitive/coordinator/coordinator_options.dart';
import 'package:flutter_frontend/screens/sensitive/coordinator/stats.dart';

class CoordinatorPage extends StatefulWidget {
  CoordinatorPage({Key? key}) : super(key: key);

  @override
  HomePage createState() => HomePage();
}

class HomePage extends State<CoordinatorPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: DefaultTabController(
          length: 3,
          child: Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: const Text(
                'Coordinator Page',
                style: TextStyle(fontSize: 28),
              ),
              bottom: const TabBar(
                indicatorSize: TabBarIndicatorSize.tab,
                indicatorWeight: 10,
                tabs: [
                  Tab(icon: Icon(Icons.home)),
                  Tab(icon: Icon(Icons.format_list_bulleted)),
                  Tab(icon: Icon(Icons.error))
                ],
              ),
            ),
            body: TabBarView(
              children: [
                Row(
                  children: [
                    SizedBox(
                        width: MediaQuery.of(context).size.width / 2,
                        child: CoordinatorOptions()),
                    SizedBox(
                        width: MediaQuery.of(context).size.width / 2,
                        child: Stats()),
                  ],
                ),
                Expanded(child: CoordinatorMap()),
                RedButton(),
              ],
            ),
          ),
        ));
  }
}
