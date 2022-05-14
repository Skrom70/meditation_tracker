import 'package:flutter/material.dart';
import 'package:group_list_view/group_list_view.dart';
import 'package:intl/intl.dart';
import 'package:meditation_tracker/database/database_provider.dart';
import 'package:meditation_tracker/database/database_session.dart';
import 'package:meditation_tracker/reuseble_widget/breath_circle.dart';
import 'package:provider/provider.dart';

class RecentPage extends StatelessWidget {
  RecentPage({Key? key}) : super(key: key);

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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.timer,
                        color: Color.fromRGBO(255, 215, 0, 1).withOpacity(0.8),
                        size: 12,
                      ),
                      Text(
                        '${provider.preview.totalTime}',
                        style: TextStyle(fontSize: 10),
                      ),
                    ],
                  )
                ],
              ),
            ),
            body: GroupListView(
              sectionsCount: provider.preview.months.toList().length,
              countOfItemInSection: (int section) {
                return provider.preview.months[section].days.length;
              },
              itemBuilder: (context, index) =>
                  _itemBuilder(context, index, provider),
              groupHeaderBuilder: (BuildContext context, int section) =>
                  _buildSessionTitleWidget(
                      context, provider.preview.months[section].date),
              separatorBuilder: (context, indexPath) => Divider(
                height: 1,
                color: Colors.black.withOpacity(0.5),
                indent: 30,
                endIndent: 30,
              ),
            ))));
  }

  Widget _itemBuilder(
      BuildContext context, IndexPath index, DatabaseProvider provider) {
    final day = provider.preview.months[index.section].days[index.index];
    return _buildSessionItemWidget(context, day);
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

  Widget _buildSessionItemWidget(
      BuildContext context, DatabaseSessionByDay from) {
    final String title = DateFormat('MMMM d, EEEE').format(from.date);

    List<Row> sessions = from.sessions.map((e) {
      final String title =
          e.durationMins == 1 ? '1 min' : '${e.durationMins} mins';
      final String addingToTitle = DateFormat.Hm().format(e.date);
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 100,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${title}',
                  style: TextStyle(
                      fontSize: 18, color: Theme.of(context).primaryColor),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 100,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(addingToTitle,
                    style: TextStyle(
                        fontSize: 16,
                        fontStyle: FontStyle.italic,
                        color: Colors.blueGrey)),
              ],
            ),
          ),
          SizedBox(
            width: 100,
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Container(
                width: 20,
                height: 20,
                child: Center(
                  child: BreathCircle(
                      initalValue: e.durationMins, maxValue: 90, size: 20),
                ),
              ),
            ]),
          ),
        ],
      );
    }).toList();

    return ListTile(
      title: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(
                  fontSize: 18,
                  fontStyle: FontStyle.italic,
                  color: Colors.blueGrey),
            ),
          ],
        ),
      ),
      subtitle: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: sessions,
          )),
    );
  }

  void _loadData(BuildContext context) async {
    Provider.of<DatabaseProvider>(context, listen: false).getAll();
  }
}
