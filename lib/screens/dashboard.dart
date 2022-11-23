import 'package:flutter/material.dart';
import 'package:snowbill/supabase_state/auth_require_state.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:user_profile_avatar/user_profile_avatar.dart';

import 'package:circle_nav_bar/circle_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart' as prov;
import 'package:snowbill/providers/snowball_provider.dart';
import 'package:snowbill/widgets/debt_list_screen.dart';
import 'package:snowbill/widgets/graph_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends AuthRequiredState<DashboardScreen> {
  User? user;
  String usrIcon = '';
  int tabIndex = 0;
  Future<bool>? initLocalStorage;

  @override
  void onAuthenticated(Session session) {
    final _user = session.user;
    print('USER AUTH');
    print(session.user.toString());
    // final _userIcon = session.user?.user_metadata?.avatar_url
    user = _user;
    usrIcon =
        'https://lh3.googleusercontent.com/a/ALm5wu3gerBO9DrmDfjpN1xyYD55D3iEEBgK1K_rzZDNTIE=s96-c';
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        initLocalStorage =
            prov.Provider.of<SnowballProvider>(context, listen: false).init();
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Color background = const Color.fromRGBO(38, 42, 62, 1);
    Color accentColor = const Color.fromRGBO(89, 207, 206, 1);
    return MaterialApp(
      title: 'Snowbill',
      theme: ThemeData(
        backgroundColor: background,
        cardColor: const Color.fromRGBO(52, 56, 76, 1),
        colorScheme:
            Theme.of(context).colorScheme.copyWith(secondary: accentColor),
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
        body: tabIndex == 0 ? const DebtListScreen() : const GraphScreen(),
        bottomNavigationBar: CircleNavBar(
          activeIcons: [
            UserProfileAvatar(
              avatarUrl: usrIcon,
              avatarSplashColor: Colors.purple,
              radius: 20,
              isActivityIndicatorSmall: false,
              avatarBorderData: AvatarBorderData(
                borderColor: Colors.white,
                borderWidth: 5.0,
              ),
            ),
            Icon(
              Icons.attach_money,
              color: accentColor,
            ),
            if (prov.Provider.of<SnowballProvider>(context)
                .snowball
                .debts
                .isNotEmpty)
              Icon(
                Icons.bar_chart_sharp,
                color: accentColor,
              ),
          ],
          inactiveIcons: [
            UserProfileAvatar(
              avatarUrl: usrIcon,
              avatarSplashColor: Colors.purple,
              radius: 20,
              isActivityIndicatorSmall: false,
              avatarBorderData: AvatarBorderData(
                borderColor: Colors.white,
                borderWidth: 5.0,
              ),
            ),
            Text(
              "Debt",
              style: TextStyle(
                color: accentColor,
              ),
            ),
            if (prov.Provider.of<SnowballProvider>(context)
                .snowball
                .debts
                .isNotEmpty)
              Text(
                "Breakdown",
                style: TextStyle(
                  color: accentColor,
                ),
              ),
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

  void onTapSignOut() async {
    await Supabase.instance.client.auth.signOut();
  }
}
