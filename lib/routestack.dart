// ignore_for_file: prefer_const_constructors, prefer_final_fields, sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lukatout/presentation/screens/home/home_screen.dart';
import 'package:lukatout/sizeconfig.dart';

class RouteStack extends StatefulWidget {
  const RouteStack({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _RouteStackState createState() => _RouteStackState();
}

class _RouteStackState extends State<RouteStack>
    with AutomaticKeepAliveClientMixin {
  int _selectedIndex = 0;
  PageController pageController = PageController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void _onPageChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  List<Widget> _screens = [
    HomeScreen(),
    HomeScreen(),
    HomeScreen(),
    HomeScreen(),
    // QuizScreen(backNavigation: false),
  ];

  void _onItemTapped(int index) {
    pageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    super.build(context);
    return Scaffold(
        // backgroundColor: const Color(0xFFFFFFFF),
        body: PageView(
          controller: pageController,
          onPageChanged: _onPageChanged,
          children: _screens,
          physics: const NeverScrollableScrollPhysics(),
        ),
        bottomNavigationBar:
            bottomNavigationBar(_selectedIndex, _onItemTapped, context));
  }

  @override
  bool get wantKeepAlive => true;
}

Widget bottomNavigationBar(_selectedIndex, _onItemTapped, context) {
  return Container(
    color: Colors.blue.withOpacity(0.1),
    padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 10.0),
    child: ClipRRect(
      borderRadius: const BorderRadius.only(
        topRight: Radius.circular(30),
        topLeft: Radius.circular(30),
        bottomLeft: Radius.circular(30),
        bottomRight: Radius.circular(30),
      ),
      child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          // backgroundColor: const Color(0xFFffffff),
          backgroundColor: Colors.white,
          selectedItemColor: Colors.lightBlue.shade600,
          unselectedItemColor: Colors.grey,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: <BottomNavigationBarItem>[
            // ignore: prefer_const_constructors
            BottomNavigationBarItem(
                label: "Accueil",
                icon: Container(
                    padding: const EdgeInsets.only(top: 10.0),
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(
                            width: _selectedIndex == 0 ? 1.0 : 0,
                            color: _selectedIndex == 0
                                ? Colors.lightBlue.shade600
                                : Colors.transparent),
                      ),
                      // borderRadius: BorderRadius.circular(50.0)
                    ),
                    child: SvgPicture.asset(
                      _selectedIndex == 0
                          ? "assets/icons/home-blue.svg"
                          : "assets/icons/home-light.svg",
                      width: 20,
                    ))),
            BottomNavigationBarItem(
                label: "Réalisations",
                icon: Container(
                    padding: const EdgeInsets.only(top: 10.0),
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(
                            width: _selectedIndex == 1 ? 1.0 : 0,
                            color: _selectedIndex == 1
                                ? Colors.lightBlue.shade600
                                : Colors.transparent),
                      ),
                      // borderRadius: BorderRadius.circular(50.0)
                    ),
                    child: SvgPicture.asset(
                      _selectedIndex == 1
                          ? "assets/icons/realisation.svg"
                          : "assets/icons/realisation-light.svg",
                      width: 20,
                    ))),
            BottomNavigationBarItem(
                label: "IONIS",
                icon: Container(
                    padding: const EdgeInsets.only(top: 10.0),
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(
                            width: _selectedIndex == 2 ? 1.0 : 0,
                            color: _selectedIndex == 2
                                ? Colors.lightBlue.shade600
                                : Colors.transparent),
                      ),
                      // borderRadius: BorderRadius.circular(50.0)
                    ),
                    child: SvgPicture.asset(
                      _selectedIndex == 2
                          ? "assets/icons/actes.svg"
                          : "assets/icons/vote-light.svg",
                      width: 20,
                    ))),

            BottomNavigationBarItem(
                label: "Equipe",
                icon: Container(
                    padding: const EdgeInsets.only(top: 10.0),
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(
                            width: _selectedIndex == 3 ? 1.0 : 0,
                            color: _selectedIndex == 3
                                ? Colors.lightBlue.shade600
                                : Colors.transparent),
                      ),
                      // borderRadius: BorderRadius.circular(50.0)
                    ),
                    child: SvgPicture.asset(
                      _selectedIndex == 3
                          ? "assets/icons/user1.svg"
                          : "assets/icons/user-light.svg",
                      width: 20,
                    ))),
          ]),
    ),
  );
}
