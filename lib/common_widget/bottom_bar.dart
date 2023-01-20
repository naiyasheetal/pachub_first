import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:bottom_indicator_bar_fork/bottom_indicator_bar_fork.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pachub/config/preference.dart';
import 'package:pachub/models/login_response_model_new.dart';
import 'package:pachub/view/Athletes/athletes.dart';
import 'package:pachub/view/Pending%20Payments/pending_payment_page.dart';
import 'package:pachub/view/Settings/Tabs/change_password.dart';
import 'package:pachub/view/Settings/Tabs/manage_subscription.dart';
import 'package:pachub/view/Settings/setting_screen.dart';
import 'package:pachub/view/bookmark/bookmark.dart';
import 'package:pachub/view/collegerecruiters/college_recruiters_page.dart';
import 'package:pachub/view/profile/profile.dart';
import 'package:pachub/view/solicitor/solicitor.dart';
import '../Utils/appcolors.dart';
import '../Utils/images.dart';
import '../view/adviser/adviser.dart';
import '../view/chat/chatscreen.dart';
import '../view/dashboard/homescreen.dart';
import 'drawer.dart';

class BottomBar extends StatefulWidget {
  int selectedIndex;

  BottomBar({required this.selectedIndex});

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int currentPage = 0;
  bool isSelected = false;
  String _title = "Dashbaord";
  late LoginDataModel loginDataModel;
  List<Menu> items = [];
  String? role;

  void _onItemTapped(int index) {
    setState(() {
      widget.selectedIndex = index;
      currentPage = widget.selectedIndex;
      print(currentPage);
    });
  }

  @override
  void initState() {
    _onItemTapped(widget.selectedIndex);
    loginDataModel = LoginDataModel.fromJson(
        jsonDecode(PreferenceUtils.getString("loginData")));
    items.addAll(loginDataModel.menu!);
    setState(() {
      role = PreferenceUtils.getString("role");
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: widget.selectedIndex,
        children: [
          for (final tabItem in TabNavigationItem.items) tabItem.page,
        ],
      ),
      drawer: Drawer(
        child: AppDrawer(),
      ),
      bottomNavigationBar: BottomIndicatorBar(
        onTap: _onItemTapped,
        items: [
          BottomIndicatorNavigationBarItem(
              icon: SvgPicture.asset(
                currentPage == 0 ? home_icon : unselecthome,
                color: AppColors.dark_blue_button_color,
              ),
              label: ""),
          BottomIndicatorNavigationBarItem(
              icon: role != "Coach / Recruiter"
                  ? SvgPicture.asset(
                      currentPage == 1 ? selectgroup : group_icon,
                      color: AppColors.dark_blue_button_color,
                    )
                  : SvgPicture.asset(
                      currentPage == 1 ? selectedadvisors : advisor_icon,
                      color: AppColors.dark_blue_button_color,
                    ),
              label: ""),
          BottomIndicatorNavigationBarItem(
              icon: role != "Advisor"
                  ? SvgPicture.asset(
                      currentPage == 2 ? selectedadvisors : advisor_icon,
                      color: AppColors.dark_blue_button_color,
                    )
                  : SvgPicture.asset(
                      currentPage == 2 ? selectedadvisors : advisor_icon,
                      color: AppColors.dark_blue_button_color,
                    ),
              label: ""),
          BottomIndicatorNavigationBarItem(
            icon: role != "admin"
                ? SvgPicture.asset(
                    currentPage == 3 ? selectedmessage : message_icon,
                    color: AppColors.dark_blue_button_color,
                  )
                : SvgPicture.asset(
                    currentPage == 3 ? selectedadvisors : advisor_icon,
                    color: AppColors.dark_blue_button_color,
                  ),
            label: "",
          ),
        ],
        indicatorColor: AppColors.orange,
        currentIndex: currentPage,
      ),
    );
  }
}

class TabNavigationItem {
  final Widget page;
  final String? role;

  TabNavigationItem({required this.page, this.role});

  static List<TabNavigationItem> get items => [
        TabNavigationItem(
          page: HomeScreen(),
        ),
        PreferenceUtils.getString("role") == "Coach / Recruiter"
            ? TabNavigationItem(page: Athletes())
            : TabNavigationItem(page: Recruiters()),
        PreferenceUtils.getString("role") == "Advisor"
            ? TabNavigationItem(page: Athletes())
            : TabNavigationItem(page: Advisorscreen()),
        PreferenceUtils.getString("role") == "admin"
            ? TabNavigationItem(page: Athletes())
            : TabNavigationItem(page: ChatScreen()),
        PreferenceUtils.getString("role") == "Advisor"
            ? TabNavigationItem(page: const AdvisorProfileScreen())
            : PreferenceUtils.getString("role") == "Coach / Recruiter"
                ? TabNavigationItem(page: const CoachProfileScreen())
                : PreferenceUtils.getString("role") == "Athlete"&&PreferenceUtils.getString("plan") == "Free"?
       TabNavigationItem(page: const FREEAthleteProfileScreen()):
        TabNavigationItem(page: const AthleteProfileScreen(),
        ),
        TabNavigationItem(
          page: BookMarkScreen(),
        ),
        TabNavigationItem(
          page: const SettingScreen(),
        ),
        TabNavigationItem(
          page: const PendingPaymentPage(),
        ),
       TabNavigationItem(
          page: const Solicitor(),
        ),
      ];
}
