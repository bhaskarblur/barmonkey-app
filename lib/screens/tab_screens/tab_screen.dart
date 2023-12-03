import 'package:bar_monkey/providers/bars_provider.dart';
import 'package:bar_monkey/screens/tab_screens/discover_screens/discover_screen.dart';

import '/providers/home_screen_provider.dart';
import '/screens/tab_screens/meet_screens/meet_screens.dart';
import '/screens/tab_screens/profile_screens/profile_screen.dart';
import '/screens/tab_screens/social_screens/social_screens.dart';
import '/widget/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../app_config/colors.dart';
import '../../widget/navigator.dart';
import 'home_screens/home_screen.dart';
import 'orders_screens/orders_screen.dart';

class TabScreen extends StatefulWidget {
  const TabScreen({super.key});

  @override
  State<TabScreen> createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> {
  int selectedTab = 2;

  final List<Widget> _screens = [
    const OrdersScreen(),
    const SocialScreen(),
    const HomePage(),
    const DiscoverScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final provider =
            Provider.of<HomeScreenProvider>(context, listen: false);
        if (provider.selectedIndex == 2) {
          showYesNoButton(context, 'Are you sure you want to exit?', () {
            SystemNavigator.pop();
          }, () {
            Nav.pop(context);
          });
          return true;
        } else {
          provider.changeSelectedIndex(2);
          return false;
        }
      },
      child: Scaffold(
          backgroundColor: backgroundColor,
          resizeToAvoidBottomInset: false,
          body: Consumer<HomeScreenProvider>(builder: (context, provider, _) {
            return Stack(
              children: [
                _screens[provider.selectedIndex],
                if (MediaQuery.of(context).viewInsets.bottom == 0.0)
                  Positioned(
                      left: 0, right: 0, bottom: 0, child: menu(provider))
              ],
            );
          })),
    );
  }

  Widget menu(HomeScreenProvider provider) {
    final barsProvider = Provider.of<BarsProvider>(context, listen: false);
    return Container(
      color: backgroundColor.withOpacity(.9),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            Expanded(
              child: InkWell(
                  onTap: () {
                    barsProvider.resetFilter();
                    barsProvider.clearSearchedBars();
                    provider.changeSelectedIndex(0);
                  },
                  child: SvgPicture.asset(
                      provider.selectedIndex == 0
                          ? 'assets/icons/home_icons/receipt_color.svg'
                          : 'assets/icons/home_icons/receipt.svg',
                      height: 26,
                      width: 26)),
            ),
            // Expanded(
            //   child: InkWell(
            //       onTap: () {
            //         barsProvider.resetFilter();
            //         barsProvider.clearSearchedBars();
            //         provider.changeSelectedIndex(1);
            //       },
            //       child: SvgPicture.asset(
            //           provider.selectedIndex == 3
            //               ? 'assets/icons/home_icons/person_color.svg'
            //               : 'assets/icons/home_icons/person.svg',
            //           height: 26,
            //           width: 26)),
            // ),
            Expanded(
              child: InkWell(
                  onTap: () {
                    barsProvider.resetFilter();
                    barsProvider.clearSearchedBars();
                    provider.changeSelectedIndex(1);
                  },
                  child: SvgPicture.asset(
                      provider.selectedIndex == 1
                          ? 'assets/icons/home_icons/social_color.svg'
                          : 'assets/icons/home_icons/social.svg',
                      height: 28,
                      width: 28)),
            ),
            Expanded(
              child: InkWell(
                  onTap: () {
                    provider.changeSelectedIndex(2);
                  },
                  child: SvgPicture.asset(
                      provider.selectedIndex == 2
                          ? 'assets/icons/home_icons/homeicon_color.svg'
                          : 'assets/icons/home_icons/homeIcon.svg',
                      height: 26,
                      width: 26)),
            ),
            Expanded(
              child: InkWell(
                  onTap: () {
                    barsProvider.resetFilter();
                    barsProvider.clearSearchedBars();
                    provider.changeSelectedIndex(3);
                  },
                  child: SvgPicture.asset(
                      provider.selectedIndex == 3
                          ? 'assets/icons/discover_active.svg'
                          : 'assets/icons/discover_inactive.svg',
                      height: 28,
                      width: 28)),
            ),
            Expanded(
              child: InkWell(
                  onTap: () {
                    barsProvider.resetFilter();
                    barsProvider.clearSearchedBars();
                    provider.changeSelectedIndex(4);
                  },
                  child: SvgPicture.asset(
                      provider.selectedIndex == 4
                          ? 'assets/icons/home_icons/profile_color.svg'
                          : 'assets/icons/home_icons/profile.svg',
                      height: 28,
                      width: 28)),
            ),
          ],
        ),
      ),
    );
  }
}
