import 'package:flutter/material.dart';
import 'package:group_list_view/group_list_view.dart';
import 'package:intl/intl.dart';
import 'package:meditation_tracker/database/database_provider.dart';
import 'package:meditation_tracker/database/database_session.dart';
import 'package:provider/provider.dart';

class RecentPage extends StatelessWidget {
  RecentPage({Key? key}) : super(key: key);

  // final Map<String, List> provider.sections = {
  //   'Fruits Name From A': ['Apple', 'Apricot', 'Avocado'],
  //   'Fruits Name From B': ['Banana', 'Blackberry', 'Blueberry', 'Boysenberry'],
  //   'Fruits Name From C': ['Cherry', 'Coconut'],
  //   'Fruits Name From D': ['Date Fruit', 'Durian'],
  //   'Fruits Name From G': ['Grapefruit', 'Grapes', 'Guava']
  // };

  String totalTime = '';

  @override
  Widget build(BuildContext context) {
    _loadData(context);
    return Consumer<DatabaseProvider>(
        builder: ((context, provider, child) => Scaffold(
            appBar: AppBar(
              title: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image(
                          image: AssetImage('lib/assets/images/lotus_icon.png'),
                          height: 35),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        'Lotus',
                        style: Theme.of(context).appBarTheme.titleTextStyle,
                      ),
                    ],
                  ),
                  Text(
                    'Total is ${provider.totalTime}',
                    style: TextStyle(fontSize: 10),
                  )
                ],
              ),
            ),
            body: GroupListView(
              sectionsCount: provider.sessionsByMonth.keys.toList().length,
              countOfItemInSection: (int section) {
                return provider.sessionsByMonth.values.toList()[section].length;
              },
              itemBuilder: (context, index) =>
                  _itemBuilder(context, index, provider),
              groupHeaderBuilder: (BuildContext context, int section) =>
                  _buildSessionTitleWidget(
                      context, provider.sessionsByMonth.keys.toList()[section]),
              separatorBuilder: (context, indexPath) => Divider(
                height: 1,
                color: Colors.black.withOpacity(0.5),
                indent: 20,
              ),
            ))));
  }

  Widget _itemBuilder(
      BuildContext context, IndexPath index, DatabaseProvider provider) {
    final session =
        provider.sessionsByMonth.values.toList()[index.section][index.index];
    return _buildSessionItemWidget(session);
  }

  Widget _buildSessionTitleWidget(BuildContext context, DateTime from) {
    final String title = DateTime.now().year == from.year
        ? DateFormat.MMMM().format(from)
        : DateFormat.yMMMM().format(from);

    return Container(
        color: Theme.of(context).primaryColor,
        height: 40,
        padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            title,
            style: TextStyle(
                fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
            textAlign: TextAlign.left,
          ),
        ));
  }

  Widget _buildSessionItemWidget(DatabaseSession from) {
    final String title = DateFormat.d().add_EEEE().format(from.date);
    final String addingToTitle = DateFormat.Hm().format(from.date);
    final String subtitle =
        from.durationMins == 1 ? '1 min' : '${from.durationMins} mins';

    return ListTile(
      title: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '$title, ',
              style: TextStyle(
                  fontSize: 18,
                  fontStyle: FontStyle.italic,
                  color: Colors.blueGrey),
            ),
            Text(addingToTitle,
                style: TextStyle(
                    fontSize: 16,
                    fontStyle: FontStyle.italic,
                    color: Colors.blueGrey))
          ],
        ),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Text(
          subtitle,
          style: TextStyle(fontSize: 18, color: Colors.black),
        ),
      ),
      trailing: Icon(
        Icons.accessibility_new_rounded,
        color: Colors.blueGrey,
      ),
    );
  }

  void _loadData(BuildContext context) async {
    Provider.of<DatabaseProvider>(context, listen: false).getAll();
  }
}
