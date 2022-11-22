import 'package:flutter/material.dart';
import 'package:snowbill/supabase_state/auth_require_state.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:circle_nav_bar/circle_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart' as prov;
import 'package:snowbill/providers/snowball_provider.dart' as prov;
import 'package:snowbill/widgets/debt_list_screen.dart';
import 'package:snowbill/widgets/graph_screen.dart';
import 'package:snowbill/widgets/auth_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends AuthRequiredState<DashboardScreen> {
  User? user;
    int tabIndex = 0;
    Future<bool>? initLocalStorage;

  @override
  void onAuthenticated(Session session) {
    final _user = session.user;
    user = _user;

  }

    @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        initLocalStorage = prov.Provider.of<prov.SnowballProvider>(context, listen: false).init();
      });
    });
    super.initState();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Color background = const Color.fromRGBO(38, 42, 62, 1);
    Color accentColor = const Color.fromRGBO(89, 207, 206, 1);
    final List<Widget> children = [
      const DebtListScreen(),
      const GraphScreen(),
      const AuthPage()
    ];
    return FutureBuilder(
      builder: (context, AsyncSnapshot<bool> asyncSnapshot) {
        if (asyncSnapshot.connectionState == ConnectionState.done && asyncSnapshot.hasData) {
          return MaterialApp(
            title: 'Snowbill',
            theme: ThemeData(
              backgroundColor: background,
              cardColor: const Color.fromRGBO(52, 56, 76, 1),
              colorScheme: Theme.of(context).colorScheme.copyWith(secondary: accentColor),
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ButtonStyle(
                  backgroundColor: MaterialStateColor.resolveWith((states) {
                    return accentColor;
                  }),
                ),
              ),
              textTheme: TextTheme(
                titleMedium: TextStyle(
                  color: accentColor,
                ),
                titleLarge: TextStyle(
                  color: accentColor,
                ),
                bodyLarge: TextStyle(
                  color: accentColor,
                ),
                bodyMedium: TextStyle(
                  color: accentColor,
                ),
                bodySmall: TextStyle(
                  color: accentColor,
                ),
              ),
            ),
            home: Scaffold(
              backgroundColor: background,
              body: children[tabIndex],
              bottomNavigationBar: CircleNavBar(
                activeIcons: [
                  Icon(
                    Icons.attach_money,
                    color: accentColor,
                  ),
                  if (prov.Provider.of<prov.SnowballProvider>(context).snowball.debts.isNotEmpty)
                    Icon(
                      Icons.bar_chart_sharp,
                      color: accentColor,
                    ),
                  Icon(
                    Icons.account_circle,
                    color: accentColor,
                  )
                ],
                inactiveIcons: [
                  Text(
                    "Debt",
                    style: TextStyle(
                      color: accentColor,
                    ),
                  ),
                  if (prov.Provider.of<prov.SnowballProvider>(context).snowball.debts.isNotEmpty)
                    Text(
                      "Breakdown",
                      style: TextStyle(
                        color: accentColor,
                      ),
                    ),
                  Text(
                    "Account",
                    style: TextStyle(
                      color: accentColor,
                    ),
                  )
                ],
                color: const Color.fromRGBO(52, 56, 76, 1),
                height: 60,
                circleWidth: 60,
                activeIndex: tabIndex,
                onTab: (val) {
                  setState(() {
                    tabIndex = val;
                  });
                },
                cornerRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                  bottomRight: Radius.circular(24),
                  bottomLeft: Radius.circular(24),
                ),
                shadowColor: Colors.transparent,
                elevation: 10,
              ),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  void onTapSignOut() async {
    await Supabase.instance.client.auth.signOut();
  }
}
