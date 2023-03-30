import 'package:flutter/material.dart';
import 'package:flutter_frontend/screens/sensitive/coordinator/coordinator_map.dart';
import 'package:flutter_frontend/screens/sensitive/coordinator/big_red_button.dart';
import 'package:flutter_frontend/screens/sensitive/coordinator/coordinator_options.dart';

class CoordinatorSuggestions extends StatefulWidget {
  CoordinatorSuggestions({Key? key}) : super(key: key);

  @override
  SuggestionDropdown createState() => SuggestionDropdown();
}

class SuggestionDropdown extends State<CoordinatorSuggestions> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
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
                    width: 2 * MediaQuery.of(context).size.width / 3,
                    child: CoordinatorOptions()),
                SizedBox(
                    width: MediaQuery.of(context).size.width / 3,
                    child: CoordinatorMap()),
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
